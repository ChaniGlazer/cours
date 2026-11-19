// lib/auth.js
//
// שימו לב: ב-Next.js 16 הפונקציה cookies() היא אסינכרונית (מחזירה Promise), וגם
// D1 (lib/db.js) אסינכרוני - ולכן כל הפונקציות כאן שמשתמשות בעוגיות/DB הן async
// ויש לקרוא להן עם await.
//
// גיבוב סיסמאות: scrypt (node:crypto), לא bcryptjs.
// bcryptjs הוא מימוש JS טהור, וחישוב bcrypt(cost=10) צורך הרבה זמן CPU -
// על Cloudflare Workers יש מגבלת זמן CPU קשיחה לבקשה, וזה גרם לשגיאות
// "Worker exceeded resource limits" (1102) בכל הרשמה/התחברות.
// scrypt דרך node:crypto רץ על המימוש הנטיבי של ה-runtime ולא צורך כמעט CPU
// יחסית ל-bcryptjs.
//
// תאימות לאחור: משתמשים/ות שנרשמו לפני השינוי הזה יש להם עדיין hash בפורמט
// bcrypt ($2a$/$2b$/$2y$) בטבלת users. verifyPassword מזהה את הפורמט לפי
// prefix ומאמת בהתאם (bcryptjs רק לאימות, לא לגיבוב חדש). ברגע שמשתמש/ת כזו
// מתחברת בהצלחה, upgradeHashIfNeeded מחליפה את ה-hash השמור לפורמט scrypt
// החדש - כך שעם הזמן כל המשתמשים עוברים ל-hash המהיר, בלי לכפות על אף אחד
// לאפס סיסמה.
import { cookies } from "next/headers";
import bcrypt from "bcryptjs";
import crypto from "node:crypto";
import { getDb, nowIso } from "./db";

import { SESSION_COOKIE } from "./publicCache";
const SESSION_DURATION_DAYS = 30;

const SCRYPT_PREFIX = "scrypt";
const SCRYPT_KEYLEN = 64;
// פרמטרים שמוריים ב-hash עצמו (לא קבועים בקוד) כדי שאפשר יהיה להחמיר
// אותם בעתיד בלי לשבור אימות של hash-ים ישנים.
const SCRYPT_PARAMS = { N: 16384, r: 8, p: 1 };

function scryptAsync(password, salt, params) {
  return new Promise((resolve, reject) => {
    crypto.scrypt(
      password,
      salt,
      SCRYPT_KEYLEN,
      { N: params.N, r: params.r, p: params.p },
      (err, derivedKey) => {
        if (err) reject(err);
        else resolve(derivedKey);
      }
    );
  });
}

export async function hashPassword(password) {
  const salt = crypto.randomBytes(16).toString("hex");
  const { N, r, p } = SCRYPT_PARAMS;
  const derivedKey = await scryptAsync(password, salt, SCRYPT_PARAMS);
  return `${SCRYPT_PREFIX}$${N}$${r}$${p}$${salt}$${derivedKey.toString("hex")}`;
}

function isBcryptHash(hash) {
  return (
    typeof hash === "string" &&
    (hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$"))
  );
}

function isScryptHash(hash) {
  return typeof hash === "string" && hash.startsWith(`${SCRYPT_PREFIX}$`);
}

export async function verifyPassword(password, hash) {
  if (isScryptHash(hash)) {
    const parts = hash.split("$");
    // scrypt$N$r$p$salt$keyHex
    if (parts.length !== 6) return false;
    const [, nStr, rStr, pStr, salt, keyHex] = parts;
    const params = { N: Number(nStr), r: Number(rStr), p: Number(pStr) };
    const expected = Buffer.from(keyHex, "hex");
    const actual = await scryptAsync(password, salt, params);
    if (actual.length !== expected.length) return false;
    return crypto.timingSafeEqual(actual, expected);
  }

  if (isBcryptHash(hash)) {
    // תאימות לאחור בלבד - משתמשים שעדיין לא התחברו מאז השינוי.
    return bcrypt.compare(password, hash);
  }

  return false;
}

// קוראים לזה אחרי אימות מוצלח ב-login, כדי להעביר בהדרגה כל משתמש/ת
// שעדיין נשארו עם hash ישן (bcrypt) ל-hash החדש (scrypt).
export async function upgradeHashIfNeeded(userId, password, currentHash) {
  if (!isBcryptHash(currentHash)) return;
  const newHash = await hashPassword(password);
  const db = await getDb();
  await db.prepare("UPDATE users SET password_hash = ? WHERE id = ?").bind(newHash, userId).run();
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
  // כניסה אחרונה ומספר כניסות לפאנל הניהול (נקרא מכל מסלולי הכניסה: הרשמה, התחברות ואיפוס סיסמה).
  const now = new Date().toISOString();
  await db
    .prepare("UPDATE users SET last_login_at = ?, last_active_at = ?, login_count = login_count + 1 WHERE id = ?")
    .bind(now, now, userId)
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
