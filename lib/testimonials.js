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

export async function getUserTestimonial(userId, courseId) {
  if (!userId) return null;
  const db = await getDb();
  return db
    .prepare("SELECT id, name, role, quote, result, status FROM testimonials WHERE user_id = ? AND course_id = ?")
    .bind(userId, courseId)
    .first();
}
