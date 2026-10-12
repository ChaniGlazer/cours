"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";

// טופס המלצה פשוט וציבורי - בלי הרשמה. ההמלצה נשמרת כ"ממתינה" ומפורסמת רק אחרי
// אישור ידני בעמוד הניהול. הגנות בסיסיות מספאם: honeypot, מגבלות אורך, מניעת
// כפילות ותקרה למספר ההמלצות הממתינות.
export async function submitTestimonialAction(formData) {
  // שדה מלכודת שרק בוטים ממלאים - מתעלמים בשקט
  if ((formData.get("website") || "").toString().trim()) {
    redirect("/?testimonial=sent#testimonials");
  }

  const name = (formData.get("name") || "").toString().trim().slice(0, 80);
  const quote = (formData.get("quote") || "").toString().trim().slice(0, 1200);
  const role = (formData.get("role") || "").toString().trim().slice(0, 80);
  const rating = parseInt((formData.get("rating") || "").toString(), 10);

  if (!name || quote.length < 10) {
    redirect("/?testimonial=invalid#testimonials");
  }

  const pending = db.prepare("SELECT COUNT(*) c FROM testimonials WHERE status = 'pending'").get().c;
  const duplicate = db.prepare("SELECT 1 FROM testimonials WHERE quote = ?").get(quote);
  if (pending >= 100 || duplicate) {
    redirect("/?testimonial=sent#testimonials");
  }

  db.prepare(
    `INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at, rating, status, user_id, verified)
     VALUES (?, ?, ?, ?, '', '', 0, ?, ?, 'pending', NULL, 0)`
  ).run(
    crypto.randomUUID(),
    name,
    role,
    quote,
    nowIso(),
    rating >= 1 && rating <= 5 ? rating : null
  );

  redirect("/?testimonial=sent#testimonials");
}
