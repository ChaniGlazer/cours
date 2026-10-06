// lib/auth.js
//
// שימו לב: ב-Next.js 16 הפונקציה cookies() היא אסינכרונית (מחזירה Promise), וגם
// D1 (lib/db.js) אסינכרוני - ולכן כל הפונקציות כאן שמשתמשות בעוגיות/DB הן async
// ויש לקרוא להן עם await.
import { cookies } from "next/headers";
import bcrypt from "bcryptjs";
import crypto from "node:crypto";
import { getDb, nowIso } from "./db";

const SESSION_COOKIE = "session_token";
const SESSION_DURATION_DAYS = 30;

export async function hashPassword(password) {
  return bcrypt.hash(password, 10);
}

export async function verifyPassword(password, hash) {
  return bcrypt.compare(password, hash);
}

export async function createUser({ name, email, passwordHash }) {
  const id = crypto.randomUUID();
  const db = await getDb();
  await db
    .prepare("INSERT INTO users (id, name, email, password_hash, paid, created_at) VALUES (?, ?, ?, ?, 0, ?)")
    .bind(id, name, email.toLowerCase().trim(), passwordHash, nowIso())
    .run();
  return id;
}

export async function findUserByEmail(email) {
  const db = await getDb();
  return db.prepare("SELECT * FROM users WHERE email = ?").bind(email.toLowerCase().trim()).first();
}

export async function findUserById(id) {
  const db = await getDb();
  return db.prepare("SELECT * FROM users WHERE id = ?").bind(id).first();
}

export async function createSession(userId) {
  const token = crypto.randomBytes(32).toString("hex");
  const expiresDate = new Date(Date.now() + SESSION_DURATION_DAYS * 24 * 60 * 60 * 1000);
  const db = await getDb();
  await db
    .prepare("INSERT INTO sessions (token, user_id, expires_at) VALUES (?, ?, ?)")
    .bind(token, userId, expiresDate.toISOString())
    .run();
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
    const db = await getDb();
    await db.prepare("DELETE FROM sessions WHERE token = ?").bind(token).run();
  }
  cookieStore.delete(SESSION_COOKIE);
}

export async function getCurrentUser() {
  const cookieStore = await cookies();
  const token = cookieStore.get(SESSION_COOKIE)?.value;
  if (!token) return null;
  const db = await getDb();
  const session = await db.prepare("SELECT * FROM sessions WHERE token = ?").bind(token).first();
  if (!session) return null;
  if (new Date(session.expires_at) < new Date()) {
    await db.prepare("DELETE FROM sessions WHERE token = ?").bind(token).run();
    return null;
  }
  return findUserById(session.user_id);
}
