"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { updateSettings, getLessonCount } from "@/lib/settings";
import {
  createAdminSession,
  destroyAdminSession,
  isAdmin,
  verifyAdminPassword
} from "@/lib/admin-auth";
import { allowRequest } from "@/lib/rate-limit";
import { createCoupon, setCouponActive, deleteCoupon, incrementCouponUsage } from "@/lib/coupons";
import { markUserPaid } from "@/lib/auth";
import { getClearingLogById } from "@/lib/invoice4u";
import { getPaymentById } from "@/lib/payments";

export async function adminLoginAction(formData) {
  const password = (formData.get("password") || "").toString();
  if (!(await allowRequest("admin-login", { max: 8 }))) {
    redirect("/admin?error=rate_limited");
  }
  if (!verifyAdminPassword(password)) {
    redirect("/admin?error=1");
  }
  await createAdminSession();
  redirect("/admin");
}

export async function adminLogoutAction() {
  await destroyAdminSession();
  redirect("/admin");
}

export async function updateSettingsAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const course_title = (formData.get("course_title") || "").toString().trim();
  const course_subtitle = (formData.get("course_subtitle") || "").toString().trim();
  const course_description = (formData.get("course_description") || "").toString().trim();
  const price = (formData.get("price") || "").toString().trim();

  updateSettings({ course_title, course_subtitle, course_description, price });
  redirect("/admin?saved=settings");
}

export async function createLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : getLessonCount() + 1;

  if (!title) redirect("/admin?error=lesson_title");

  db.prepare(
    "INSERT INTO lessons (id, title, description, video_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?)"
  ).run(crypto.randomUUID(), title, description, video_url, position, nowIso());

  redirect("/admin?saved=lesson");
}

export async function updateLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !title) redirect("/admin?error=lesson_title");

  db.prepare("UPDATE lessons SET title = ?, description = ?, video_url = ?, position = ? WHERE id = ?").run(
    title,
    description,
    video_url,
    position,
    id
  );

  redirect("/admin?saved=lesson");
}

export async function deleteLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    db.prepare("DELETE FROM lessons WHERE id = ?").run(id);
  }
  redirect("/admin?saved=lesson");
}

export async function createCouponAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const code = (formData.get("code") || "").toString().trim();
  const discountType = (formData.get("discount_type") || "").toString();
  const discountValue = parseFloat((formData.get("discount_value") || "").toString());
  const maxUsesRaw = (formData.get("max_uses") || "").toString().trim();
  const maxUses = maxUsesRaw ? parseInt(maxUsesRaw, 10) : null;
  const expiresAtRaw = (formData.get("expires_at") || "").toString().trim();
  const expiresAt = expiresAtRaw ? new Date(expiresAtRaw).toISOString() : null;

  if (!code || !["percent", "amount"].includes(discountType) || !(discountValue > 0)) {
    redirect("/admin?error=coupon_invalid");
  }

  try {
    createCoupon({ code, discountType, discountValue, maxUses, expiresAt });
  } catch (err) {
    if (String(err?.message || "").includes("UNIQUE")) {
      redirect("/admin?error=coupon_duplicate");
    }
    throw err;
  }

  redirect("/admin?saved=coupon");
}

export async function toggleCouponAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  const active = formData.get("active") === "1";
  if (id) {
    setCouponActive(id, active);
  }
  redirect("/admin?saved=coupon");
}

export async function deleteCouponAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    deleteCoupon(id);
  }
  redirect("/admin?saved=coupon");
}

// בודקים שוב מול Invoice4U תשלום שנשאר תקוע ב-pending - למשל אם המשתמש שילם
// בהצלחה אבל סגר את הדפדפן לפני שהאישור האוטומטי (polling מ-/payment/success)
// הספיק לעדכן את המערכת שלנו. אין webhook אוטומטי מ-Invoice4U לעסקאות רגילות,
// אז זו הדרך היחידה לתקן מצב כזה בלי גישה ישירה למסד הנתונים.
export async function recheckPaymentAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const payment = id ? getPaymentById(id) : null;
  if (!payment || !payment.clearing_log_id) {
    redirect("/admin?error=payment_check_failed");
  }

  let result;
  try {
    result = await getClearingLogById({ clearingLogId: payment.clearing_log_id });
  } catch (err) {
    console.error("[Admin] בדיקת תשלום מול Invoice4U נכשלה:", err);
    redirect("/admin?error=payment_check_failed");
    return;
  }

  db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
    JSON.stringify(result.raw).slice(0, 2000),
    nowIso(),
    id
  );

  if (result.ok === true) {
    db.prepare("UPDATE payments SET status = 'paid', updated_at = ? WHERE id = ?").run(nowIso(), id);
    markUserPaid(payment.user_id);
    if (payment.coupon_code) incrementCouponUsage(payment.coupon_code);
    redirect("/admin?saved=payment_paid");
  }

  if (result.ok === false) {
    db.prepare("UPDATE payments SET status = 'failed', updated_at = ? WHERE id = ?").run(nowIso(), id);
    redirect("/admin?saved=payment_failed");
  }

  redirect("/admin?saved=payment_still_pending");
}

// עקיפה ידנית - למקרה שהתשלום אושר מחוץ למערכת (למשל בבירור טלפוני/בנקאי מול
// חברת הסליקה) ואי אפשר לאמת אותו שוב דרך recheckPaymentAction.
export async function markPaymentPaidAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const payment = id ? getPaymentById(id) : null;
  if (!payment) {
    redirect("/admin?error=payment_not_found");
  }

  db.prepare("UPDATE payments SET status = 'paid', updated_at = ? WHERE id = ?").run(nowIso(), id);
  markUserPaid(payment.user_id);
  if (payment.coupon_code) incrementCouponUsage(payment.coupon_code);

  redirect("/admin?saved=payment_paid");
}
