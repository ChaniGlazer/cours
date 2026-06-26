// lib/auth.js
//
// שימו לב: ב-Next.js 16 הפונקציה cookies() היא אסינכרונית (מחזירה Promise),
// ולכן הפונקציות כאן שמשתמשות בעוגיות הן async ויש לקרוא להן עם await.
import { cookies } from "next/headers";
import bcrypt from "bcryptjs";
import crypto from "node:crypto";
import { db, nowIso } from "./db";

const SESSION_COOKIE = "session_token";
const SESSION_DURATION_DAYS = 30;

export async function hashPassword(password) {
  return bcrypt.hash(password, 10);
}

export async function verifyPassword(password, hash) {
  return bcrypt.compare(password, hash);
}

export function createUser({ name, email, passwordHash }) {
  const id = crypto.randomUUID();
  db.prepare(
    "INSERT INTO users (id, name, email, password_hash, paid, created_at) VALUES (?, ?, ?, ?, 0, ?)"
  ).run(id, name, email.toLowerCase().trim(), passwordHash, nowIso());
  return id;
}

export function findUserByEmail(email) {
  return db.prepare("SELECT * FROM users WHERE email = ?").get(email.toLowerCase().trim());
}

export function findUserById(id) {
  return db.prepare("SELECT * FROM users WHERE id = ?").get(id);
}

export function markUserPaid(userId) {
  db.prepare("UPDATE users SET paid = 1 WHERE id = ?").run(userId);
}

export async function createSession(userId) {
  const token = crypto.randomBytes(32).toString("hex");
  const expiresDate = new Date(Date.now() + SESSION_DURATION_DAYS * 24 * 60 * 60 * 1000);
  db.prepare("INSERT INTO sessions (token, user_id, expires_at) VALUES (?, ?, ?)").run(
    token,
    userId,
    expiresDate.toISOString()
  );
  const cookieStore = await cookies();
  cookieStore.set(SESSION_COOKIE, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    expires: expiresDate
  });
}

export async function destroySession() {
  const cookieStore = await cookies();
  const token = cookieStore.get(SESSION_COOKIE)?.value;
  if (token) {
    db.prepare("DELETE FROM sessions WHERE token = ?").run(token);
  }
  cookieStore.delete(SESSION_COOKIE);
}

export async function getCurrentUser() {
  const cookieStore = await cookies();
  const token = cookieStore.get(SESSION_COOKIE)?.value;
  if (!token) return null;
  const session = db.prepare("SELECT * FROM sessions WHERE token = ?").get(token);
  if (!session) return null;
  if (new Date(session.expires_at) < new Date()) {
    db.prepare("DELETE FROM sessions WHERE token = ?").run(token);
    return null;
  }
  return findUserById(session.user_id);
}
