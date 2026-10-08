"use server";

import crypto from "node:crypto";
import { revalidatePath } from "next/cache";
import { getDb, nowIso } from "@/lib/db";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";

const MAX_QUOTE = 600;

// תלמיד מחובר עם גישה לקורס (חינמי, או בתשלום שנרכש) כותב/מעדכן המלצה אחת לקורס.
// ההמלצה נשמרת כ-pending וממתינה לאישור המנהל לפני שהיא מוצגת.
export async function submitTestimonialAction(courseId, _prev, formData) {
  const user = await getCurrentUser();
  if (!user) return { ok: false, error: "יש להתחבר כדי לכתוב המלצה." };

  const course = await getCourseBySlug(courseId);
  if (!course || course.coming_soon) return { ok: false, error: "אי אפשר לכתוב המלצה על הקורס הזה." };
  if (course.is_paid && !(await hasPurchasedCourse(user.id, course.id))) {
    return { ok: false, error: "ההמלצה פתוחה לתלמידים שרכשו את הקורס." };
  }

  const name = (formData.get("name") || "").toString().trim().slice(0, 60);
  const role = (formData.get("role") || "").toString().trim().slice(0, 80);
  const quote = (formData.get("quote") || "").toString().trim();
  const result = (formData.get("result") || "").toString().trim().slice(0, 160);

  if (!name) return { ok: false, error: "יש להזין שם להצגה." };
  if (quote.length < 15) return { ok: false, error: "ההמלצה קצרה מדי, כתבו לפחות משפט או שניים." };
  if (quote.length > MAX_QUOTE) return { ok: false, error: `ההמלצה ארוכה מדי (עד ${MAX_QUOTE} תווים).` };

  const db = await getDb();
  const existing = await db
    .prepare("SELECT id FROM testimonials WHERE user_id = ? AND course_id = ?")
    .bind(user.id, course.id)
    .first();

  if (existing) {
    await db
      .prepare("UPDATE testimonials SET name = ?, role = ?, quote = ?, result = ?, status = 'pending' WHERE id = ?")
      .bind(name, role, quote, result, existing.id)
      .run();
  } else {
    await db
      .prepare(
        "INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at, status, user_id, course_id) VALUES (?, ?, ?, ?, ?, '', 0, ?, 'pending', ?, ?)"
      )
      .bind(crypto.randomUUID(), name, role, quote, result, nowIso(), user.id, course.id)
      .run();
  }

  revalidatePath(`/courses/${course.id}`);
  revalidatePath("/admin");
  return { ok: true, message: "תודה! ההמלצה התקבלה ותופיע באתר אחרי אישור." };
}
