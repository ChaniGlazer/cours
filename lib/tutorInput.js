// lib/tutorInput.js
//
// ולידציה של גוף הבקשה ל-POST /api/tutor. קובץ עצמאי (בלי import), בלי גישה ל-DB: מחזיר { ok: true, value } או { ok: false }.
// כל קלט שלא עומד בדרישות נדחה (400), בלי לנסות "לתקן" אותו.

export const LIMITS = {
  message: 2000,
  code: 4000,
  historyItems: 8,
  historyItemChars: 2000
};

const TOPIC_KEY = /^[a-z0-9_-]{1,40}$/;
const COURSE_ID = /^[a-z0-9-]{1,60}$/;
const LESSON_SLUG = /^[a-z0-9-]{1,80}$/;
const ALLOWED_KEYS = new Set(["courseId", "lessonSlug", "topicKey", "message", "history", "code"]);

const isStr = (v) => typeof v === "string";

export function validateTutorBody(body) {
  if (!body || typeof body !== "object" || Array.isArray(body)) return { ok: false };
  // שדות לא מוכרים (בעיקר מספר ניסיון שהקליינט מנסה לשלוח) נדחים: הרמה נקבעת רק בשרת.
  for (const k of Object.keys(body)) if (!ALLOWED_KEYS.has(k)) return { ok: false };

  const { courseId, lessonSlug, topicKey, message, history = [], code } = body;
  if (!isStr(courseId) || !COURSE_ID.test(courseId)) return { ok: false };
  if (!isStr(lessonSlug) || !LESSON_SLUG.test(lessonSlug)) return { ok: false };
  if (!isStr(topicKey) || !TOPIC_KEY.test(topicKey)) return { ok: false };
  if (!isStr(message) || !message.trim() || message.length > LIMITS.message) return { ok: false };
  if (code !== undefined && (!isStr(code) || code.length > LIMITS.code)) return { ok: false };
  if (!Array.isArray(history) || history.length > LIMITS.historyItems) return { ok: false };

  const cleanHistory = [];
  for (const h of history) {
    if (!h || typeof h !== "object" || Array.isArray(h)) return { ok: false };
    for (const k of Object.keys(h)) if (k !== "role" && k !== "content") return { ok: false };
    if (h.role !== "user" && h.role !== "assistant") return { ok: false };
    if (!isStr(h.content) || h.content.length > LIMITS.historyItemChars) return { ok: false };
    cleanHistory.push({ role: h.role, content: h.content });
  }

  return {
    ok: true,
    value: { courseId, lessonSlug, topicKey, message, history: cleanHistory, code: code && code.trim() ? code : undefined }
  };
}
