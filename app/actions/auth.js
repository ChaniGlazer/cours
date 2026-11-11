"use server";

import { redirect } from "next/navigation";
import {
  createSession,
  createUser,
  destroySession,
  findUserByEmail,
  hashPassword,
  verifyPassword
} from "@/lib/auth";
import { recordMailingConsent } from "@/lib/surveyStore";

// תיבת "אשמח לקבל עדכונים": נרשמת לרשימת התפוצה רק אם סומנה. כשל בשמירה לא מפיל את ההרשמה/ההתחברות.
async function saveMailingConsent(formData, email, source) {
  if (formData.get("marketing") !== "on") return;
  try {
    await recordMailingConsent(email, source);
  } catch (e) {
    console.error("mailing consent failed", e);
  }
}

function safeNext(next) {
  // מונע redirect לכתובת חיצונית - מאפשרים רק נתיבים פנימיים שמתחילים ב-/
  if (typeof next === "string" && next.startsWith("/") && !next.startsWith("//")) {
    return next;
  }
  return "/courses";
}

export async function registerAction(formData) {
  const name = (formData.get("name") || "").toString().trim();
  const email = (formData.get("email") || "").toString().trim().toLowerCase();
  const password = (formData.get("password") || "").toString();
  const next = safeNext((formData.get("next") || "").toString());

  const qp = `next=${encodeURIComponent(next)}`;

  if (!name || name.length < 2) {
    redirect(`/register?error=name&${qp}`);
  }
  if (!email || !email.includes("@")) {
    redirect(`/register?error=email&${qp}`);
  }
  if (!password || password.length < 8) {
    redirect(`/register?error=password&${qp}`);
  }

  const existing = await findUserByEmail(email);
  if (existing) {
    redirect(`/register?error=exists&${qp}`);
  }

  const passwordHash = await hashPassword(password);
  const userId = await createUser({ name, email, passwordHash });
  await createSession(userId);
  await saveMailingConsent(formData, email, "register");

  redirect(next);
}

export async function loginAction(formData) {
  const email = (formData.get("email") || "").toString().trim().toLowerCase();
  const password = (formData.get("password") || "").toString();
  const next = safeNext((formData.get("next") || "").toString());
  const qp = `next=${encodeURIComponent(next)}`;

  const user = await findUserByEmail(email);
  if (!user) {
    redirect(`/login?error=invalid&${qp}`);
  }

  const valid = await verifyPassword(password, user.password_hash);
  if (!valid) {
    redirect(`/login?error=invalid&${qp}`);
  }

  await createSession(user.id);
  await saveMailingConsent(formData, email, "login");
  redirect(next);
}

export async function logoutAction() {
  await destroySession();
  redirect("/");
}
