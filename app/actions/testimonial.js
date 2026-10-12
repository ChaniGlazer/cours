"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { getCurrentUser } from "@/lib/auth";

// תלמיד/ה שרכש/ה את הקורס יכול/ה להשאיר המלצה אחת. ההמלצה נשמרת במצב "ממתינה"
// ומפורסמת רק לאחר אישור ידני בעמוד הניהול. סימון "תלמיד מאומת" נקבע בשרת לפי
// נתוני הרכישה בפועל - לא לפי מה שהמשתמש שלח בטופס.
export async function submitTestimonialAction(formData) {
  const user = await getCurrentUser();
  if (!user) redirect("/login?next=/course");
  if (!user.paid) redirect("/course");

  const quote = (formData.get("quote") || "").toString().trim().slice(0, 1200);
  const role = (formData.get("role") || "").toString().trim().slice(0, 80);
  const result = (formData.get("result") || "").toString().trim().slice(0, 200);
  const rating = parseInt((formData.get("rating") || "").toString(), 10);

  if (quote.length < 15 || !(rating >= 1 && rating <= 5)) {
    redirect("/course?testimonial=invalid");
  }

  const existing = db.prepare("SELECT id FROM testimonials WHERE user_id = ?").get(user.id);
  if (existing) {
    db.prepare(
      "UPDATE testimonials SET quote = ?, role = ?, result = ?, rating = ?, status = 'pending' WHERE id = ?"
    ).run(quote, role, result, rating, existing.id);
  } else {
    db.prepare(
      `INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at, rating, status, user_id, verified)
       VALUES (?, ?, ?, ?, ?, '', 0, ?, ?, 'pending', ?, 1)`
    ).run(crypto.randomUUID(), user.name, role, quote, result, nowIso(), rating, user.id);
  }

  redirect("/course?testimonial=sent");
}
