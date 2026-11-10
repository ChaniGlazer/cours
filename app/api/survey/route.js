// /api/survey
//   GET  - תוצאות מצטברות (מספרים בלבד: בלי טקסט חופשי ובלי מיילים), להצגה אחרי מילוי.
//   POST - שליחת תשובות. ולידציה בשרת, honeypot ("website"), מילוי מהיר מדי, הגבלת קצב לפי IP מגובב והגנת Origin.
import { getSurveyResults, isFillTooFast, saveSubmission, takeRateSlot, validateSubmission } from "@/lib/surveyStore";

const json = (data, status = 200) => Response.json(data, { status, headers: { "Cache-Control": "no-store" } });

function sameSite(request) {
  const own = (u) => new URL(u).hostname.replace(/^www\./, "");
  const hosts = new Set([own(request.url)]);
  try {
    if (process.env.SITE_URL) hosts.add(own(process.env.SITE_URL));
  } catch {
    // SITE_URL לא תקין - מתעלמים
  }
  const origin = request.headers.get("origin");
  if (origin) {
    try {
      return hosts.has(own(origin));
    } catch {
      return false;
    }
  }
  const fetchSite = request.headers.get("sec-fetch-site");
  return fetchSite === "same-origin" || fetchSite === "none";
}

export async function GET() {
  try {
    return json({ ok: true, results: await getSurveyResults() });
  } catch (err) {
    console.error("survey: results failed", err?.message);
    return json({ ok: false, error: "אי אפשר לטעון את התוצאות כרגע." }, 503);
  }
}

export async function POST(request) {
  if (!sameSite(request)) return json({ ok: false, error: "בקשה לא מורשית." }, 403);

  let body;
  try {
    const text = await request.text();
    if (text.length > 6000) return json({ ok: false, error: "הבקשה גדולה מדי." }, 413);
    body = JSON.parse(text);
  } catch {
    return json({ ok: false, error: "בקשה לא תקינה." }, 400);
  }

  const parsed = validateSubmission(body);
  if (!parsed.ok) return json(parsed, 400);

  try {
    // בוט (שדה honeypot מלא או מילוי מהיר מדי): מחזירים הצלחה כאילו נשמר, בלי לשמור, כדי לא ללמד אותו מה נחסם.
    if ((typeof body.website === "string" && body.website !== "") || isFillTooFast(body.elapsed)) {
      return json({ ok: true, results: await getSurveyResults() });
    }
    if (!(await takeRateSlot(request.headers.get("cf-connecting-ip")))) {
      return json({ ok: false, error: "נשלחו הרבה תשובות בזמן קצר. נסי שוב בעוד שעה." }, 429);
    }
    await saveSubmission(parsed.value);
    return json({ ok: true, results: await getSurveyResults() });
  } catch (err) {
    console.error("survey: save failed", err?.message);
    return json({ ok: false, error: "משהו השתבש בשמירה. נסי שוב בעוד רגע." }, 503);
  }
}
