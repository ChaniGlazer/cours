// POST /api/progress - דיווח התקדמות של הלומדת המחוברת לפאנל הניהול.
// בקשה: { events: [{ courseId, slug, seen?, done?, auto?, exDone?, exTotal? }] }. אותה הגנת CSRF כמו /api/tutor (Origin).
import { getCurrentUser } from "@/lib/auth";
import { recordProgress } from "@/lib/learnerStore";

const json = (body, status = 200) => Response.json(body, { status, headers: { "Cache-Control": "no-store" } });

function sameSite(request) {
  const origin = request.headers.get("origin");
  const allowed = new Set([new URL(request.url).origin]);
  try {
    if (process.env.SITE_URL) allowed.add(new URL(process.env.SITE_URL).origin);
  } catch {
    // SITE_URL לא תקין - מתעלמים
  }
  if (origin) return allowed.has(origin);
  const fetchSite = request.headers.get("sec-fetch-site");
  return fetchSite === "same-origin" || fetchSite === "none";
}

const isId = (v) => typeof v === "string" && /^[a-z0-9_-]{1,80}$/i.test(v);

export async function POST(request) {
  if (!sameSite(request)) return json({ error: "forbidden" }, 403);
  const user = await getCurrentUser();
  if (!user) return json({ error: "login" }, 401);

  let body;
  try {
    const text = await request.text();
    if (text.length > 40000) return json({ error: "bad_request" }, 400);
    body = JSON.parse(text);
  } catch {
    return json({ error: "bad_request" }, 400);
  }
  if (!Array.isArray(body?.events) || body.events.length === 0) return json({ error: "bad_request" }, 400);

  const events = [];
  for (const e of body.events.slice(0, 200)) {
    if (!e || !isId(e.courseId) || !isId(e.slug)) continue;
    events.push({
      courseId: e.courseId,
      slug: e.slug,
      seen: e.seen === true,
      done: typeof e.done === "boolean" ? e.done : undefined,
      auto: e.auto === true,
      exDone: e.exDone,
      exTotal: e.exTotal
    });
  }
  if (!events.length) return json({ error: "bad_request" }, 400);

  try {
    return json({ saved: await recordProgress(user.id, events) });
  } catch (err) {
    console.error("progress: record failed", err?.message);
    return json({ error: "unavailable" }, 503);
  }
}
