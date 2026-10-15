// POST /api/tutor - החונך הסוקרטי (צד שרת בלבד, בלי ממשק).
// בקשה: { courseId, lessonSlug, topicKey, message, history, code? }.
// תשובה: { reply, suggestions, attempt, level, remaining }. המודל מחזיר JSON מובנה { reply, suggestions } (Structured Outputs),
// והשרת מפענח אותו ומסנן את ההצעות (כולל הצעות שחושפות תשובה של תרגיל).
//
// הסדר חשוב: מקור הבקשה -> התחברות -> ולידציה -> קורס ושיעור -> הגדרות -> הגבלת קצב -> ספירת ניסיון -> OpenAI.
// מספר הניסיון נקבע רק כאן (ב-D1), ורמת הרמז נגזרת ממנו. המפתח, שגיאות הספק ומידע פנימי לא מוחזרים לעולם.
import { getCurrentUser } from "@/lib/auth";
import { validateTutorBody } from "@/lib/tutorInput";
import { TUTOR_COURSES } from "@/lib/tutorCourses";
import { lessonAnswers, lessonContext } from "@/lib/tutorLessons";
import { buildTutorInstructions, hintLevel, wrapHistoryTurn, wrapLearnerTurn } from "@/lib/tutorPrompt";
import { TUTOR_TEXT_FORMAT, finalizeSuggestions, parseTutorOutput } from "@/lib/tutorOutput";
import { callTutorModel, DEFAULT_API_BASE, TutorProviderError } from "@/lib/tutorOpenAI";
import { bumpAttempt, consumeRateLimit, lessonExists, logUsage, refundRateLimit, rollbackAttempt } from "@/lib/tutorStore";

// ברירת מחדל מתוך התיעוד של OpenAI (developers.openai.com/api/docs/models, 2026-10): מודל בינוני וחסכוני.
// ההחלטה הסופית לפי scripts/tutor-eval.mjs, ונקבעת במשתנה הסביבה TUTOR_MODEL.
const DEFAULT_MODEL = "gpt-6.1-sol";
// טוקני reasoning נספרים בתוך max_output_tokens, ולכן המגבלה גבוהה מהתשובה הנראית (עד 5 משפטים + הצעות ב-JSON). האורך נשלט בפרומפט.
const DEFAULT_MAX_OUTPUT_TOKENS = 1500;
const MAX_BODY_CHARS = 30000;

const NO_STORE = { "Cache-Control": "no-store" };
const json = (body, status = 200, headers = {}) => Response.json(body, { status, headers: { ...NO_STORE, ...headers } });

const MSG = {
  forbidden: "אי אפשר לשלוח את הבקשה הזאת.",
  login: "צריך להתחבר כדי לדבר עם החונכת.",
  badRequest: "הבקשה לא תקינה. בדקי את ההודעה והקוד ונסי שוב.",
  notAvailable: "החונכת לא זמינה בקורס הזה.",
  unavailable: "החונכת לא זמינה כרגע. נסי שוב בעוד כמה דקות.",
  failed: "משהו השתבש אצל החונכת. נסי שוב בעוד רגע. ההודעה הזאת לא נספרת.",
  rate: "שלחת הרבה הודעות. אפשר לחזור לחונכת בעוד קצת."
};

// הגנת CSRF: האימות הוא עוגיית סשן, ולכן דורשים שהבקשה תגיע מהאתר עצמו.
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

// מזהה יציב ולא חושף של הלומדת עבור OpenAI (safety_identifier): hash של מזהה המשתמש.
async function safetyId(userId) {
  const bytes = new TextEncoder().encode(`tutor:${userId}`);
  const digest = await crypto.subtle.digest("SHA-256", bytes);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

export async function POST(request) {
  try {
    if (!sameSite(request)) return json({ error: MSG.forbidden }, 403);

    const user = await getCurrentUser();
    if (!user) return json({ error: MSG.login }, 401);

    const declared = Number(request.headers.get("content-length"));
    if (Number.isFinite(declared) && declared > MAX_BODY_CHARS * 3) return json({ error: MSG.badRequest }, 400);
    let raw;
    try {
      raw = await request.text();
    } catch {
      return json({ error: MSG.badRequest }, 400);
    }
    if (raw.length > MAX_BODY_CHARS) return json({ error: MSG.badRequest }, 400);
    let body;
    try {
      body = JSON.parse(raw);
    } catch {
      return json({ error: MSG.badRequest }, 400);
    }
    const parsed = validateTutorBody(body);
    if (!parsed.ok) return json({ error: MSG.badRequest }, 400);
    const { courseId, lessonSlug, topicKey, message, history, code } = parsed.value;

    if (!TUTOR_COURSES.includes(courseId)) return json({ error: MSG.notAvailable }, 403);
    const lesson = await lessonExists(courseId, lessonSlug);
    if (!lesson) return json({ error: MSG.badRequest }, 400);

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      console.error("tutor: OPENAI_API_KEY is not configured");
      return json({ error: MSG.unavailable }, 503);
    }

    const limit = await consumeRateLimit(user.id);
    if (!limit.ok) return json({ error: MSG.rate }, 429, { "Retry-After": String(limit.retryAfter) });

    const attempt = await bumpAttempt(user.id, lessonSlug, topicKey);

    const model = process.env.TUTOR_MODEL || DEFAULT_MODEL;
    const maxOut = Number.parseInt(process.env.TUTOR_MAX_OUTPUT_TOKENS, 10) || DEFAULT_MAX_OUTPUT_TOKENS;
    // TUTOR_REASONING_EFFORT: ברירת מחדל low (הכי נמוך שנתמך ב-gpt-6.1-sol). ערך ריק או "off" משמיט את הפרמטר.
    const effortEnv = process.env.TUTOR_REASONING_EFFORT;
    const effort = effortEnv === undefined ? "low" : effortEnv === "off" ? "" : effortEnv;

    const messages = [
      ...history.map((h) => ({ role: h.role, content: wrapHistoryTurn(h.role, h.content) })),
      { role: "user", content: wrapLearnerTurn(message, code) }
    ];

    let result;
    try {
      result = await callTutorModel({
        apiKey,
        baseUrl: process.env.OPENAI_BASE_URL || DEFAULT_API_BASE,
        model,
        instructions: buildTutorInstructions({
          lessonContext: lessonContext(courseId, lessonSlug, { title: lesson.title, topicKey }),
          attempt: hintLevel(attempt)
        }),
        messages,
        maxOutputTokens: maxOut,
        reasoningEffort: effort,
        textFormat: TUTOR_TEXT_FORMAT,
        safetyIdentifier: await safetyId(user.id),
        // timeout של 20 שניות. TUTOR_TIMEOUT_MS קיים רק כדי שאפשר יהיה לבדוק את הכשל הזה מקומית.
        timeoutMs: Number.parseInt(process.env.TUTOR_TIMEOUT_MS, 10) || 20000
      });
    } catch (e) {
      // רושמים רק את סוג הכשל (בלי תוכן שיחה ובלי טקסט גולמי של הספק), ומחזירים גם את הניסיון וגם את המכסה שנצרכה.
      console.error("tutor provider failure:", e instanceof TutorProviderError ? `${e.kind} ${e.status || ""}` : "unknown");
      await rollbackAttempt(user.id, lessonSlug, topicKey).catch(() => {});
      await refundRateLimit(user.id, limit.buckets).catch(() => {});
      return json({ error: MSG.failed }, 502);
    }

    try {
      await logUsage(user.id, model, result.usage.output);
    } catch {
      // כשל בלוג לא אמור להפיל תשובה שכבר התקבלה
    }

    // פלט לא תקין (לא JSON לפי הסכמה, או JSON חתוך) לא מפיל את הבקשה: reply הוא מה שאפשר לחלץ או הטקסט הגולמי, וההצעות ברירת מחדל.
    const out = parseTutorOutput(result.text);
    const suggestions = finalizeSuggestions(out.ok ? out.suggestions : [], lessonAnswers(courseId, lessonSlug));
    return json({ reply: out.reply, suggestions, attempt, level: hintLevel(attempt), remaining: limit.remaining });
  } catch (e) {
    console.error("tutor route error:", e?.name || "unknown");
    return json({ error: MSG.failed }, 500);
  }
}
