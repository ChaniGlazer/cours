// lib/tutorStore.js
//
// המצב של החונך ב-D1: מספר ניסיון, הגבלת קצב ולוג שימוש מינימלי (migrations/0008_tutor.sql).
// כל העדכונים הם פעולות SQL אטומיות (UPSERT) ולא קריאה-ואז-כתיבה, כי אי אפשר לסמוך על זיכרון או על סדר בקשות ב-Workers.
import { getDb } from "./db";

export const RATE_LIMITS = { perHour: 30, perDay: 200 };
export const MAX_ATTEMPT_ROWS_PER_USER = 200;
const ATTEMPT_RESET_MS = 24 * 60 * 60 * 1000;
const USAGE_KEEP_MS = 2 * 24 * 60 * 60 * 1000;
const LOG_KEEP_MS = 30 * 24 * 60 * 60 * 1000;

const pad = (n, len = 2) => String(n).padStart(len, "0");

export function hourBucket(d) {
  return `h:${d.getUTCFullYear()}${pad(d.getUTCMonth() + 1)}${pad(d.getUTCDate())}${pad(d.getUTCHours())}`;
}

export function dayBucket(d) {
  return `d:${d.getUTCFullYear()}${pad(d.getUTCMonth() + 1)}${pad(d.getUTCDate())}`;
}

// מגדיל מונה של דלי באטומיות, אבל רק אם הוא עוד מתחת למגבלה. מחזיר את הערך החדש, או null אם המגבלה כבר מלאה.
async function bumpBucket(db, userId, bucket, limit, nowIso) {
  const { results } = await db
    .prepare(
      `INSERT INTO tutor_usage (user_id, bucket, count, updated_at) VALUES (?1, ?2, 1, ?3)
       ON CONFLICT (user_id, bucket) DO UPDATE SET count = count + 1, updated_at = ?3 WHERE count < ?4
       RETURNING count`
    )
    .bind(userId, bucket, nowIso, limit)
    .all();
  return results.length ? results[0].count : null;
}

async function refundBucket(db, userId, bucket) {
  await db
    .prepare("UPDATE tutor_usage SET count = MAX(count - 1, 0) WHERE user_id = ? AND bucket = ?")
    .bind(userId, bucket)
    .run();
}

// צורך הודעה אחת מהמכסה השעתית והיומית. מחזיר { ok: true, remaining } או { ok: false, retryAfter } (בשניות).
export async function consumeRateLimit(userId, now = new Date()) {
  const db = await getDb();
  const nowIso = now.toISOString();
  const hour = hourBucket(now);
  const day = dayBucket(now);

  const h = await bumpBucket(db, userId, hour, RATE_LIMITS.perHour, nowIso);
  if (h === null) {
    const next = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), now.getUTCHours() + 1);
    return { ok: false, retryAfter: Math.max(1, Math.ceil((next - now.getTime()) / 1000)) };
  }
  const d = await bumpBucket(db, userId, day, RATE_LIMITS.perDay, nowIso);
  if (d === null) {
    await refundBucket(db, userId, hour);
    const next = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() + 1);
    return { ok: false, retryAfter: Math.max(1, Math.ceil((next - now.getTime()) / 1000)) };
  }

  // ניקוי דליים ישנים של אותו משתמש (זול: לפי המפתח הראשי)
  await db
    .prepare("DELETE FROM tutor_usage WHERE user_id = ? AND updated_at < ?")
    .bind(userId, new Date(now.getTime() - USAGE_KEEP_MS).toISOString())
    .run();

  return { ok: true, remaining: Math.max(0, Math.min(RATE_LIMITS.perHour - h, RATE_LIMITS.perDay - d)) };
}

// מגדיל את מספר הניסיון של הלומדת בנושא ב-1 (או מתחיל מ-1 אחרי 24 שעות בלי פעילות), ומחזיר אותו.
// אחר כך חותך רשומות ישנות מעבר למגבלה, כדי שאי אפשר יהיה לנפח את הטבלה עם topicKey שונים.
export async function bumpAttempt(userId, lessonSlug, topicKey, now = new Date()) {
  const db = await getDb();
  const nowIso = now.toISOString();
  const cutoff = new Date(now.getTime() - ATTEMPT_RESET_MS).toISOString();
  const [upsert] = await db.batch([
    db
      .prepare(
        `INSERT INTO tutor_attempts (user_id, lesson_slug, topic_key, attempts, updated_at) VALUES (?1, ?2, ?3, 1, ?4)
         ON CONFLICT (user_id, lesson_slug, topic_key) DO UPDATE SET
           attempts = CASE WHEN updated_at < ?5 THEN 1 ELSE attempts + 1 END,
           updated_at = ?4
         RETURNING attempts`
      )
      .bind(userId, lessonSlug, topicKey, nowIso, cutoff),
    // קודם נמחקות רשומות שפג תוקפן, ואם עדיין יש יותר מדי - הישנות ביותר. הרשומה שעודכנה עכשיו היא תמיד החדשה ביותר.
    db.prepare("DELETE FROM tutor_attempts WHERE user_id = ?1 AND updated_at < ?2").bind(userId, cutoff),
    db
      .prepare(
        `DELETE FROM tutor_attempts WHERE user_id = ?1 AND rowid NOT IN
           (SELECT rowid FROM tutor_attempts WHERE user_id = ?1 ORDER BY updated_at DESC LIMIT ?2)`
      )
      .bind(userId, MAX_ATTEMPT_ROWS_PER_USER)
  ]);
  return upsert.results[0].attempts;
}

// כשהספק נכשל: מחזירים את הניסיון, כדי שתקלה לא "תשרוף" רמז.
export async function rollbackAttempt(userId, lessonSlug, topicKey) {
  const db = await getDb();
  await db
    .prepare(
      "UPDATE tutor_attempts SET attempts = MAX(attempts - 1, 0) WHERE user_id = ? AND lesson_slug = ? AND topic_key = ?"
    )
    .bind(userId, lessonSlug, topicKey)
    .run();
}

// לוג מינימלי, בלי תוכן שיחה. גם מנקה שורות ישנות מ-30 יום.
export async function logUsage(userId, model, tokens, now = new Date()) {
  const db = await getDb();
  await db.batch([
    db
      .prepare("INSERT INTO tutor_log (user_id, created_at, model, tokens) VALUES (?, ?, ?, ?)")
      .bind(userId, now.toISOString(), model, tokens),
    db.prepare("DELETE FROM tutor_log WHERE created_at < ?").bind(new Date(now.getTime() - LOG_KEEP_MS).toISOString())
  ]);
}

// השיעור קיים בקורס (שאילתה קלה, בלי לקרוא את ה-HTML)
export async function lessonExists(courseId, lessonSlug) {
  const db = await getDb();
  return db
    .prepare("SELECT title FROM lessons WHERE course_id = ? AND slug = ?")
    .bind(courseId, lessonSlug)
    .first();
}
