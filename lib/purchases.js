// lib/purchases.js
//
// גישה לקורס בתשלום נגזרת מקיום תשלום מוצלח (payments.status = 'paid') לאותו
// (user_id, course_id) - לא מ-flag גלובלי אחד למשתמש, כדי לתמוך בכמה קורסים
// בתשלום במקביל.
import { getDb } from "./db";

export async function hasPurchasedCourse(userId, courseId) {
  if (!userId) return false;
  const db = await getDb();
  const row = await db
    .prepare("SELECT id FROM payments WHERE user_id = ? AND course_id = ? AND status = 'paid' LIMIT 1")
    .bind(userId, courseId)
    .first();
  return Boolean(row);
}

export async function getPurchasedCourseIds(userId) {
  if (!userId) return [];
  const db = await getDb();
  const { results } = await db
    .prepare("SELECT DISTINCT course_id FROM payments WHERE user_id = ? AND status = 'paid'")
    .bind(userId)
    .all();
  return results.map((r) => r.course_id);
}
