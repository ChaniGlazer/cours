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

function safeNext(next) {
  // מונע redirect לכתובת חיצונית - מאפשרים רק נתיבים פנימיים שמתחילים ב-/
  if (typeof next === "string" && next.startsWith("/") && !next.startsWith("//")) {
    return next;
  }
  return "/course";
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

  const existing = findUserByEmail(email);
  if (existing) {
    redirect(`/register?error=exists&${qp}`);
  }

  const passwordHash = await hashPassword(password);
  const userId = createUser({ name, email, passwordHash });
  await createSession(userId);

  redirect(next);
}

export async function loginAction(formData) {
  const email = (formData.get("email") || "").toString().trim().toLowerCase();
  const password = (formData.get("password") || "").toString();
  const next = safeNext((formData.get("next") || "").toString());
  const qp = `next=${encodeURIComponent(next)}`;

  const user = findUserByEmail(email);
  if (!user) {
    redirect(`/login?error=invalid&${qp}`);
  }

  const valid = await verifyPassword(password, user.password_hash);
  if (!valid) {
    redirect(`/login?error=invalid&${qp}`);
  }

  await createSession(user.id);
  redirect(next);
}

export async function logoutAction() {
  await destroySession();
  redirect("/");
}
