// lib/admin-auth.js
import { cookies } from "next/headers";
import crypto from "node:crypto";
import { db } from "./db";

const ADMIN_COOKIE = "admin_session";
const ADMIN_SESSION_DAYS = 7;

export function verifyAdminPassword(password) {
  const expected = process.env.ADMIN_PASSWORD;
  if (!expected) return false;
  if (!password) return false;
  // השוואה בזמן קבוע כדי להקטין חשיפה להתקפות תזמון
  const a = Buffer.from(String(password));
  const b = Buffer.from(String(expected));
  if (a.length !== b.length) return false;
  return crypto.timingSafeEqual(a, b);
}

export async function createAdminSession() {
  const token = crypto.randomBytes(32).toString("hex");
  const expiresDate = new Date(Date.now() + ADMIN_SESSION_DAYS * 24 * 60 * 60 * 1000);
  db.prepare("INSERT INTO admin_sessions (token, expires_at) VALUES (?, ?)").run(
    token,
    expiresDate.toISOString()
  );
  const cookieStore = await cookies();
  cookieStore.set(ADMIN_COOKIE, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    expires: expiresDate
  });
}

export async function destroyAdminSession() {
  const cookieStore = await cookies();
  const token = cookieStore.get(ADMIN_COOKIE)?.value;
  if (token) {
    db.prepare("DELETE FROM admin_sessions WHERE token = ?").run(token);
  }
  cookieStore.delete(ADMIN_COOKIE);
}

export async function isAdmin() {
  const cookieStore = await cookies();
  const token = cookieStore.get(ADMIN_COOKIE)?.value;
  if (!token) return false;
  const row = db.prepare("SELECT * FROM admin_sessions WHERE token = ?").get(token);
  if (!row) return false;
  if (new Date(row.expires_at) < new Date()) {
    db.prepare("DELETE FROM admin_sessions WHERE token = ?").run(token);
    return false;
  }
  return true;
}
