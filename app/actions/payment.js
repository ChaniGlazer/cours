"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { getDb, nowIso } from "@/lib/db";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { createClearingRequest, getClearingLogById } from "@/lib/invoice4u";

function siteUrl() {
  const url = process.env.SITE_URL;
  if (!url) {
    throw new Error("יש להגדיר את משתנה הסביבה SITE_URL (כתובת האתר בפועל) לפני קבלת תשלומים");
  }
  return url.replace(/\/$/, "");
}

export async function startPaymentAction(courseId) {
  const user = await getCurrentUser();
  if (!user) {
    redirect(`/login?next=${encodeURIComponent(`/courses/${courseId}`)}`);
  }

  const course = await getCourseBySlug(courseId);
  if (!course || !course.is_paid) {
    redirect(`/courses/${courseId}`);
  }

  if (await hasPurchasedCourse(user.id, courseId)) {
    redirect(`/courses/${courseId}`);
  }

  const price = course.price_ils;
  if (!price || price <= 0) {
    redirect(`/courses/${courseId}?error=price_not_set`);
  }

  const paymentId = crypto.randomUUID();
  const timestamp = nowIso();
  const db = await getDb();
  await db
    .prepare(
      "INSERT INTO payments (id, user_id, amount, status, course_id, created_at, updated_at) VALUES (?, ?, ?, 'pending', ?, ?, ?)"
    )
    .bind(paymentId, user.id, price, courseId, timestamp, timestamp)
    .run();

  const base = siteUrl();

  // הערה: redirect() נקרא מחוץ ל-try/catch בכוונה - redirect() פועל ע"י "זריקת"
  // שגיאה פנימית מיוחדת של Next.js, וצריך להיזהר שלא ניתפס אותה בטעות ב-catch שלנו.
  let paymentUrl;
  try {
    const result = await createClearingRequest({
      sum: price,
      description: course.title,
      fullName: user.name,
      email: user.email,
      orderId: paymentId,
      returnUrl: `${base}/payment/success?order=${paymentId}`,
      docHeadline: course.title
    });

    await db
      .prepare("UPDATE payments SET clearing_log_id = ?, raw_log = ?, updated_at = ? WHERE id = ?")
      .bind(result.clearingLogId, JSON.stringify(result.raw).slice(0, 2000), nowIso(), paymentId)
      .run();
    paymentUrl = result.url;
  } catch (err) {
    console.error("[Invoice4U] יצירת בקשת סליקה נכשלה:", err);
    await db
      .prepare("UPDATE payments SET status = 'failed', raw_log = ?, updated_at = ? WHERE id = ?")
      .bind(String(err?.message || err).slice(0, 2000), nowIso(), paymentId)
      .run();
    redirect(`/payment/cancel?reason=init_failed&course=${courseId}`);
    return;
  }

  redirect(paymentUrl);
}

export async function checkPaymentStatusAction(orderId) {
  if (!orderId) return { status: "unknown" };
  const db = await getDb();
  const payment = await db.prepare("SELECT * FROM payments WHERE id = ?").bind(orderId).first();
  if (!payment) return { status: "unknown" };
  if (payment.status !== "pending") return { status: payment.status };
  if (!payment.clearing_log_id) return { status: "pending" };

  // Invoice4U לא שולח webhook אוטומטי לעסקאות רגילות (Type=1) - זה קיים רק ל-Standing
  // Orders (StandingOrderCallBackUrl). לכן הבדיקה נעשית כאן, בקריאה פעילה לשרת Invoice4U
  // בכל פעם שהעמוד בודק סטטוס (ראו PaymentStatusPoller.js - נקרא כל 2 שניות).
  try {
    const result = await getClearingLogById({ clearingLogId: payment.clearing_log_id });

    // תמיד שומרים את התגובה האחרונה, גם כשעדיין לא ברור אם שולם - כדי שאפשר יהיה
    // לבדוק ב-raw_log מה בדיוק Invoice4U מחזיר (בלי תלות בלוגים של השרת).
    await db
      .prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?")
      .bind(JSON.stringify(result.raw).slice(0, 2000), nowIso(), orderId)
      .run();

    if (result.ok === true) {
      await db
        .prepare("UPDATE payments SET status = 'paid', updated_at = ? WHERE id = ?")
        .bind(nowIso(), orderId)
        .run();
      return { status: "paid", courseId: payment.course_id };
    }

    if (result.ok === false) {
      await db
        .prepare("UPDATE payments SET status = 'failed', updated_at = ? WHERE id = ?")
        .bind(nowIso(), orderId)
        .run();
      return { status: "failed" };
    }
  } catch (err) {
    console.error("[Invoice4U] שגיאה בבדיקת סטטוס סליקה:", err);
    await db
      .prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?")
      .bind(`getClearingLogById error: ${String(err?.message || err).slice(0, 1900)}`, nowIso(), orderId)
      .run();
  }

  return { status: "pending" };
}
