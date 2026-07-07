"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { createLowProfile } from "@/lib/cardcom";

function siteUrl() {
  const url = process.env.SITE_URL;
  if (!url) {
    throw new Error("יש להגדיר את משתנה הסביבה SITE_URL (כתובת האתר בפועל) לפני קבלת תשלומים");
  }
  return url.replace(/\/$/, "");
}

export async function startPaymentAction() {
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }
  if (user.paid) {
    redirect("/course");
  }

  const settings = getSettings();
  const price = parseFloat(settings.price);
  if (!price || price <= 0) {
    redirect("/course?error=price_not_set");
  }

  const paymentId = crypto.randomUUID();
  const timestamp = nowIso();
  db.prepare(
    "INSERT INTO payments (id, user_id, amount, status, created_at, updated_at) VALUES (?, ?, ?, 'pending', ?, ?)"
  ).run(paymentId, user.id, price, timestamp, timestamp);

  const base = siteUrl();

  // הערה: redirect() נקרא מחוץ ל-try/catch בכוונה - redirect() פועל ע"י "זריקת"
  // שגיאה פנימית מיוחדת של Next.js, וצריך להיזהר שלא ניתפס אותה בטעות ב-catch שלנו.
  let paymentUrl;
  try {
    const result = await createLowProfile({
      sum: price,
      description: settings.course_title || "רכישת קורס",
      successUrl: `${base}/payment/success?order=${paymentId}`,
      cancelUrl: `${base}/payment/cancel?order=${paymentId}`,
      notifyUrl: `${base}/api/payment/webhook`,
      returnValue: paymentId
    });

    db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
      JSON.stringify(result.raw).slice(0, 2000),
      nowIso(),
      paymentId
    );
    paymentUrl = result.url;
  } catch (err) {
    console.error("[קארדקום] יצירת תהליך תשלום נכשלה:", err);
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
  const payment = db.prepare("SELECT status FROM payments WHERE id = ?").get(orderId);
  return { status: payment?.status || "unknown" };
}
