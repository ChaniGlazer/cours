"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { findUserByEmail, hashPassword, createSession } from "@/lib/auth";
import { sendPasswordResetEmail } from "@/lib/mailer";
import { getSettings } from "@/lib/settings";

const RESET_TOKEN_HOURS = 1;

function hashToken(token) {
  return crypto.createHash("sha256").update(token).digest("hex");
}

export async function requestPasswordResetAction(formData) {
  const email = (formData.get("email") || "").toString().trim().toLowerCase();

  if (email) {
    const user = findUserByEmail(email);

    // שמים לב: ממשיכים לאותו עמוד "נשלח" בין אם המשתמש קיים ובין אם לא,
    // כדי שלא יהיה אפשר להשתמש בטופס הזה לבדוק אילו כתובות אימייל רשומות באתר.
    if (user) {
      const rawToken = crypto.randomBytes(32).toString("hex");
      const tokenHash = hashToken(rawToken);
      const expiresAt = new Date(Date.now() + RESET_TOKEN_HOURS * 60 * 60 * 1000).toISOString();

      // מבטלים בקשות איפוס קודמות שלא נוצלו, כדי שלא יצטברו קישורים פתוחים
      db.prepare("DELETE FROM password_resets WHERE user_id = ?").run(user.id);
      db.prepare(
        "INSERT INTO password_resets (token_hash, user_id, expires_at, created_at) VALUES (?, ?, ?, ?)"
      ).run(tokenHash, user.id, expiresAt, nowIso());

      const site = (process.env.SITE_URL || "").replace(/\/$/, "");
      const resetUrl = `${site}/reset-password?token=${rawToken}`;
      const settings = getSettings();

      await sendPasswordResetEmail({
        to: user.email,
        resetUrl,
        courseTitle: settings.course_title || "האתר"
      });
    }
  }

  redirect("/forgot-password?sent=1");
}

export async function resetPasswordAction(formData) {
  const token = (formData.get("token") || "").toString();
  const password = (formData.get("password") || "").toString();
  const confirmPassword = (formData.get("confirmPassword") || "").toString();

  if (!token) {
    redirect("/forgot-password?error=missing_token");
  }

  if (!password || password.length < 8) {
    redirect(`/reset-password?token=${encodeURIComponent(token)}&error=password`);
  }

  if (password !== confirmPassword) {
    redirect(`/reset-password?token=${encodeURIComponent(token)}&error=mismatch`);
  }

  const tokenHash = hashToken(token);
  const resetRow = db.prepare("SELECT * FROM password_resets WHERE token_hash = ?").get(tokenHash);

  if (!resetRow || new Date(resetRow.expires_at) < new Date()) {
    if (resetRow) {
      db.prepare("DELETE FROM password_resets WHERE token_hash = ?").run(tokenHash);
    }
    redirect("/forgot-password?error=expired");
  }

  const passwordHash = await hashPassword(password);
  db.prepare("UPDATE users SET password_hash = ? WHERE id = ?").run(passwordHash, resetRow.user_id);

  // הקישור הזה כבר נוצל - מוחקים אותו. ומכיוון שזה איפוס סיסמה, מבטלים גם
  // כל סשן פתוח אחר של המשתמש הזה (למשל אם החשבון היה חשוף).
  db.prepare("DELETE FROM password_resets WHERE token_hash = ?").run(tokenHash);
  db.prepare("DELETE FROM sessions WHERE user_id = ?").run(resetRow.user_id);

  await createSession(resetRow.user_id);
  redirect("/course");
}
