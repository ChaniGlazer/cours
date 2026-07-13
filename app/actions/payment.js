"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { getCurrentUser, markUserPaid } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { createClearingRequest, getClearingLogById } from "@/lib/invoice4u";
import { findValidCoupon, computeDiscountedPrice, incrementCouponUsage } from "@/lib/coupons";
import { siteUrl } from "@/lib/site";

export async function applyCouponAction(formData) {
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }
  if (user.paid) {
    redirect("/course");
  }

  const code = (formData.get("code") || "").toString().trim();
  const coupon = findValidCoupon(code);
  if (!coupon) {
    redirect("/course?error=coupon_invalid");
  }

  redirect(`/course?coupon=${encodeURIComponent(coupon.code)}`);
}

export async function startPaymentAction(formData) {
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }
  if (user.paid) {
    redirect("/course");
  }

  const settings = getSettings();
  const basePrice = parseFloat(settings.price);
  if (!basePrice || basePrice <= 0) {
    redirect("/course?error=price_not_set");
  }

  // מוודאים את הקופון שוב כאן, בזמן החיוב בפועל - לא סומכים על שדה שהגיע
  // מהטופס בלבד, כי המצב יכול להשתנות מרגע שהמחיר הוצג (למשל קופון שהגיע
  // בינתיים למכסת השימושים המקסימלית, פג תוקף, או הושבת ע"י המנהל).
  const couponCode = (formData?.get("coupon_code") || "").toString().trim();
  const coupon = couponCode ? findValidCoupon(couponCode) : null;
  const price = computeDiscountedPrice(basePrice, coupon);

  const paymentId = crypto.randomUUID();
  const timestamp = nowIso();
  db.prepare(
    "INSERT INTO payments (id, user_id, amount, status, coupon_code, created_at, updated_at) VALUES (?, ?, ?, 'pending', ?, ?, ?)"
  ).run(paymentId, user.id, price, coupon?.code || null, timestamp, timestamp);

  const base = siteUrl({ required: true });

  // הערה: redirect() נקרא מחוץ ל-try/catch בכוונה - redirect() פועל ע"י "זריקת"
  // שגיאה פנימית מיוחדת של Next.js, וצריך להיזהר שלא ניתפס אותה בטעות ב-catch שלנו.
  let paymentUrl;
  try {
    const result = await createClearingRequest({
      sum: price,
      description: settings.course_title || "רכישת קורס",
      fullName: user.name,
      email: user.email,
      orderId: paymentId,
      returnUrl: `${base}/payment/success?order=${paymentId}`,
      docHeadline: settings.course_title
    });

    db.prepare("UPDATE payments SET clearing_log_id = ?, raw_log = ?, updated_at = ? WHERE id = ?").run(
      result.clearingLogId,
      JSON.stringify(result.raw).slice(0, 2000),
      nowIso(),
      paymentId
    );
    paymentUrl = result.url;
  } catch (err) {
    console.error("[Invoice4U] יצירת בקשת סליקה נכשלה:", err);
    db.prepare("UPDATE payments SET status = 'failed', raw_log = ?, updated_at = ? WHERE id = ?").run(
      String(err?.message || err).slice(0, 2000),
      nowIso(),
      paymentId
    );
    redirect("/payment/cancel?reason=init_failed");
    return;
  }

  redirect(paymentUrl);
}

export async function checkPaymentStatusAction(orderId) {
  if (!orderId) return { status: "unknown" };
  const user = await getCurrentUser();
  if (!user) return { status: "unknown" };
  const payment = db.prepare("SELECT * FROM payments WHERE id = ?").get(orderId);
  if (!payment || payment.user_id !== user.id) return { status: "unknown" };
  if (payment.status !== "pending") return { status: payment.status };
  if (!payment.clearing_log_id) return { status: "pending" };

  // Invoice4U לא שולח webhook אוטומטי לעסקאות רגילות (Type=1) - זה קיים רק ל-Standing
  // Orders (StandingOrderCallBackUrl). לכן הבדיקה נעשית כאן, בקריאה פעילה לשרת Invoice4U
  // בכל פעם שהעמוד בודק סטטוס (ראו PaymentStatusPoller.js - נקרא כל 2 שניות).
  try {
    const result = await getClearingLogById({ clearingLogId: payment.clearing_log_id });

    // תמיד שומרים את התגובה האחרונה, גם כשעדיין לא ברור אם שולם - כדי שאפשר יהיה
    // לבדוק ב-raw_log מה בדיוק Invoice4U מחזיר (בלי תלות בלוגים של השרת).
    db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
      JSON.stringify(result.raw).slice(0, 2000),
      nowIso(),
      orderId
    );

    if (result.ok === true) {
      db.prepare("UPDATE payments SET status = 'paid', updated_at = ? WHERE id = ?").run(nowIso(), orderId);
      markUserPaid(payment.user_id);
      if (payment.coupon_code) {
        incrementCouponUsage(payment.coupon_code);
      }
      return { status: "paid" };
    }

    if (result.ok === false) {
      db.prepare("UPDATE payments SET status = 'failed', updated_at = ? WHERE id = ?").run(nowIso(), orderId);
      return { status: "failed" };
    }
  } catch (err) {
    console.error("[Invoice4U] שגיאה בבדיקת סטטוס סליקה:", err);
    db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
      `getClearingLogById error: ${String(err?.message || err).slice(0, 1900)}`,
      nowIso(),
      orderId
    );
  }

  return { status: "pending" };
}
