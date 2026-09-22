// lib/courses.js
import { getDb } from "./db";

// הופך כותרת עברית/כלשהי ל-slug תקין ל-URL. באנגלית/מספרים משאיר כמו שהוא;
// כל השאר (כולל עברית) הופך למקף, כי תעתוק אוטומטי מעברית לרוב יוצא לא קריא.
export function slugify(text, fallback) {
  const base = (text || "")
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
  return base || fallback;
}

export async function getCourses() {
  const db = await getDb();
  const { results } = await db.prepare("SELECT * FROM courses ORDER BY position ASC, created_at ASC").all();
  return results;
}

export async function getCourseBySlug(slug) {
  const db = await getDb();
  return db.prepare("SELECT * FROM courses WHERE id = ?").bind(slug).first();
}

export async function getLessonsForCourse(courseId) {
  const db = await getDb();
  const { results } = await db
    .prepare("SELECT * FROM lessons WHERE course_id = ? ORDER BY position ASC, created_at ASC")
    .bind(courseId)
    .all();
  return results;
}

export async function getLessonBySlug(courseId, lessonSlug) {
  const db = await getDb();
  return db
    .prepare("SELECT * FROM lessons WHERE course_id = ? AND slug = ?")
    .bind(courseId, lessonSlug)
    .first();
}
