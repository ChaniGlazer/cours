// lib/courseAccess.js
//
// גישה ידנית לקורס (migrations/0013_course_access.sql): המנהלת מוסיפה לומדת לפי מייל.
// כל הפונקציות סובלות טבלה שעדיין לא קיימת (לפני שהמיגרציה רצה): מחזירות "אין גישה" ולא מפילות עמוד.
import { getDb, nowIso } from "./db";

export async function hasCourseGrant(userId, courseId) {
  if (!userId) return false;
  try {
    const db = await getDb();
    const row = await db
      .prepare("SELECT 1 AS ok FROM course_access WHERE user_id = ? AND course_id = ? LIMIT 1")
      .bind(userId, courseId)
      .first();
    return Boolean(row);
  } catch {
    return false;
  }
}

export async function getGrantedCourseIds(userId) {
  if (!userId) return [];
  try {
    const db = await getDb();
    const { results } = await db.prepare("SELECT course_id FROM course_access WHERE user_id = ?").bind(userId).all();
    return results.map((r) => r.course_id);
  } catch {
    return [];
  }
}

export async function grantCourseAccess(userId, courseId) {
  const db = await getDb();
  await db
    .prepare("INSERT OR IGNORE INTO course_access (user_id, course_id, created_at) VALUES (?, ?, ?)")
    .bind(userId, courseId, nowIso())
    .run();
}

export async function revokeCourseAccess(userId, courseId) {
  const db = await getDb();
  await db.prepare("DELETE FROM course_access WHERE user_id = ? AND course_id = ?").bind(userId, courseId).run();
}

// לפאנל הניהול. null אם הטבלה עוד לא קיימת.
export async function listCourseGrants() {
  try {
    const db = await getDb();
    const { results } = await db
      .prepare(
        `SELECT a.user_id, a.course_id, a.created_at, u.name, u.email
         FROM course_access a JOIN users u ON u.id = a.user_id
         ORDER BY a.created_at DESC`
      )
      .all();
    return results;
  } catch {
    return null;
  }
}
