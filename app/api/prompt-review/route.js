// POST /api/prompt-review - משוב AI על פרומפט שהלומדת כתבה בתרגיל "כתבו בעצמכם" (קורס הפרומפטים).
// בקשה: { courseId, lessonSlug, exerciseKey, prompt }. תשובה: { review: { parts, tip, improved }, remaining }.
//
// הסדר: מתג כיבוי -> מקור הבקשה -> התחברות -> ולידציה -> הרשאה לקורס (אותו כלל כמו עמוד השיעור) -> תרגיל -> מכסה -> OpenAI.
// המכסה (30 בשעה, 60 ביום) משותפת עם החונכת (tutor_usage). המפתח, שגיאות הספק ותוכן הפרומפט לא נרשמים ולא מוחזרים.
import { getCurrentUser } from "@/lib/auth";
import { isAdmin } from "@/lib/admin-auth";
import { getCourseBySlug } from "@/lib/courses";
import { hasCourseGrant } from "@/lib/courseAccess";
import { hasPurchasedCourse } from "@/lib/purchases";
import { isSameOriginRequest } from "@/lib/sameOrigin";
import {
  PROMPT_REVIEW_COURSES,
  REVIEW_TEXT_FORMAT,
  buildReviewInstructions,
  parseReviewOutput,
  promptReviewEnabled,
  reviewExercise,
  validateReviewBody,
  wrapLearnerPrompt
} from "@/lib/promptReview";
import { callTutorModel, DEFAULT_API_BASE, TutorProviderError } from "@/lib/tutorOpenAI";
import { consumeRateLimit, logUsage, refundRateLimit } from "@/lib/tutorStore";

const DEFAULT_MODEL = "gpt-6.1-sol";
// המשוב ארוך מתשובת החונכת (4 הערות + טיפ + גרסה משופרת), וטוקני reasoning נספרים בתוך המגבלה.
const MAX_OUTPUT_TOKENS = 2500;
const MAX_BODY_CHARS = 6000;

const NO_STORE = { "Cache-Control": "no-store" };
const json = (body, status = 200, headers = {}) => Response.json(body, { status, headers: { ...NO_STORE, ...headers } });

const MSG = {
  disabled: "המשוב האוטומטי לא זמין כרגע.",
  forbidden: "אי אפשר לשלוח את הבקשה הזאת.",
  login: "צריך להתחבר לאתר כדי לקבל משוב.",
  badRequest: "הבקשה לא תקינה. בדקו שהפרומפט באורך 10 עד 2000 תווים ונסו שוב.",
  noAccess: "אין גישה לקורס הזה.",
  unavailable: "המשוב לא זמין כרגע. נסו שוב בעוד כמה דקות.",
  failed: "משהו השתבש בבדיקה. נסו שוב בעוד רגע. הניסיון הזה לא נספר.",
  rate: "שלחתם הרבה בקשות. אפשר לנסות שוב בעוד קצת."
};

async function safetyId(id) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(`prompt-review:${id}`));
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

// אותו כלל כמו בעמוד השיעור (app/courses/[slug]/[lessonSlug]/page.js): קורס "בקרוב" רק למנהלת או למי שקיבלה גישה,
// וקורס בתשלום רק למי שרכשה, קיבלה גישה או מנהלת.
async function canUseCourse(course, user, admin) {
  if (admin) return true;
  const granted = user ? await hasCourseGrant(user.id, course.id) : false;
  if (course.coming_soon && !granted) return false;
  if (!course.is_paid) return true;
  return granted || (user ? await hasPurchasedCourse(user.id, course.id) : false);
}

export async function POST(request) {
  try {
    if (!promptReviewEnabled()) return json({ error: MSG.disabled }, 503);
    if (!isSameOriginRequest(request)) return json({ error: MSG.forbidden }, 403);

    const user = await getCurrentUser();
    const admin = await isAdmin();
    if (!user && !admin) return json({ error: MSG.login }, 401);
    // מנהלת בלי חשבון לומדת (תצוגה מקדימה) נספרת במכסה תחת מזהה קבוע.
    const actorId = user ? user.id : "admin";

    const declared = Number(request.headers.get("content-length"));
    if (Number.isFinite(declared) && declared > MAX_BODY_CHARS * 3) return json({ error: MSG.badRequest }, 400);
    let body;
    try {
      const raw = await request.text();
      if (raw.length > MAX_BODY_CHARS) return json({ error: MSG.badRequest }, 400);
      body = JSON.parse(raw);
    } catch {
      return json({ error: MSG.badRequest }, 400);
    }
    const parsed = validateReviewBody(body);
    if (!parsed.ok) return json({ error: MSG.badRequest }, 400);
    const { courseId, lessonSlug, exerciseKey, prompt } = parsed.value;

    if (!PROMPT_REVIEW_COURSES.includes(courseId)) return json({ error: MSG.noAccess }, 403);
    const course = await getCourseBySlug(courseId);
    if (!course || !(await canUseCourse(course, user, admin))) return json({ error: MSG.noAccess }, 403);
    const exercise = reviewExercise(courseId, lessonSlug, exerciseKey);
    if (!exercise) return json({ error: MSG.badRequest }, 400);

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      console.error("prompt-review: OPENAI_API_KEY is not configured");
      return json({ error: MSG.unavailable }, 503);
    }

    const limit = await consumeRateLimit(actorId);
    if (!limit.ok) return json({ error: MSG.rate }, 429, { "Retry-After": String(limit.retryAfter) });

    const model = process.env.PROMPT_REVIEW_MODEL || process.env.TUTOR_MODEL || DEFAULT_MODEL;
    let result;
    let review;
    try {
      result = await callTutorModel({
        apiKey,
        baseUrl: process.env.OPENAI_BASE_URL || DEFAULT_API_BASE,
        model,
        instructions: buildReviewInstructions(exercise),
        messages: [{ role: "user", content: wrapLearnerPrompt(prompt) }],
        maxOutputTokens: MAX_OUTPUT_TOKENS,
        reasoningEffort: "low",
        textFormat: REVIEW_TEXT_FORMAT,
        safetyIdentifier: await safetyId(actorId),
        timeoutMs: Number.parseInt(process.env.TUTOR_TIMEOUT_MS, 10) || 40000
      });
      const out = parseReviewOutput(result.text);
      if (!out.ok) throw new TutorProviderError("bad_response");
      review = out.value;
    } catch (e) {
      // רק סוג הכשל נרשם (בלי תוכן ובלי טקסט גולמי של הספק), והמכסה מוחזרת: הלומדת לא קיבלה משוב.
      console.error("prompt-review provider failure:", e instanceof TutorProviderError ? `${e.kind} ${e.status || ""}` : "unknown");
      await refundRateLimit(actorId, limit.buckets).catch(() => {});
      return json({ error: MSG.failed }, 502);
    }

    await logUsage(actorId, model, result.usage.output).catch(() => {});
    return json({ review, remaining: limit.remaining });
  } catch (e) {
    console.error("prompt-review route error:", e?.name || "unknown");
    return json({ error: MSG.failed }, 500);
  }
}
