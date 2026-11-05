// lib/testimonials.js
//
// המלצות מוצגות באתר רק במצב 'approved'. המלצה של מנהל (course_id ריק) מוצגת בכל הקורסים;
// המלצה של תלמיד קשורה לקורס אחד.
import { getDb } from "./db";

export async function getApprovedTestimonials(courseId) {
  const db = await getDb();
  const { results } = await db
    .prepare(
      "SELECT id, name, role, quote, result, photo_url FROM testimonials WHERE status = 'approved' AND (course_id IS NULL OR course_id = '' OR course_id = ?) ORDER BY position ASC, created_at DESC"
    )
    .bind(courseId)
    .all();
  return results;
}

// המלצות מאושרות מכל הקורסים, החדשות ראשונות, לעמוד הקטלוג. course_title ריק להמלצה של מנהל בלי קורס מסוים.
export async function getLatestApprovedTestimonials(limit = 3) {
  const db = await getDb();
  const { results } = await db
    .prepare(
      "SELECT t.id, t.name, t.role, t.quote, t.result, t.photo_url, c.title AS course_title FROM testimonials t LEFT JOIN courses c ON c.id = t.course_id WHERE t.status = 'approved' ORDER BY t.created_at DESC LIMIT ?"
    )
    .bind(limit)
    .all();
  return results;
}

export async function getUserTestimonial(userId, courseId) {
  if (!userId) return null;
  const db = await getDb();
  return db
    .prepare("SELECT id, name, role, quote, result, status FROM testimonials WHERE user_id = ? AND course_id = ?")
    .bind(userId, courseId)
    .first();
}
