// lib/db.js
//
// שכבת מסד הנתונים. משתמשים ב-node:sqlite המובנה ב-Node.js (גרסה 22.5+)
// כדי שלא יהיה צורך בהתקנת תוסף native כלשהו - דבר שמקל מאוד על אחסון עצמי.
// אם תרצו להחליף בעתיד למסד נתונים אחר (Postgres וכו'), זה הקובץ היחיד שצריך לשנות.
//
// חשוב: החיבור למסד הנתונים (ופעולות ה-migrate/seed) נפתח באופן "עצלן" (lazy) -
// רק כשבאמת קוראים לפונקציה כמו db.prepare(...) בזמן ריצה, ולא בזמן import של
// הקובץ. הסיבה: בשלב הבנייה (next build) Next.js מייבא את כל קבצי ה-routes
// במספר workers במקביל רק כדי לבדוק מטא-דאטה, בלי להריץ אותם בפועל. אם פתיחת
// הקובץ והרצת ה-migrate היו קורות כבר ב-import, כמה workers היו מנסים לכתוב
// לאותו קובץ SQLite חדש בו-זמנית ונתקלים בשגיאת "database is locked".

import { DatabaseSync } from "node:sqlite";
import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

// אפשר לדרוס את מיקום תיקיית הנתונים עם משתנה סביבה DATA_DIR - שימושי בשירותי
// אחסון כמו Render שבהם דיסק קבוע (Persistent Disk) מחובר בנתיב משלו ולא
// בתוך תיקיית הפרויקט (שנמחקת בכל פריסה מחדש).
const DATA_DIR = process.env.DATA_DIR
  ? path.resolve(process.env.DATA_DIR)
  : path.join(process.cwd(), "data");
const DB_PATH = path.join(DATA_DIR, "course.db");

// משתמשים ב-global כדי לא לפתוח חיבור חדש בכל hot-reload בסביבת פיתוח
const globalForDb = globalThis;

function migrate(conn) {
  conn.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      paid INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS sessions (
      token TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      expires_at TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS admin_sessions (
      token TEXT PRIMARY KEY,
      expires_at TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS payments (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      amount REAL NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      clearing_log_id TEXT,
      raw_log TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS lessons (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      video_url TEXT,
      position INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS settings (
      key TEXT PRIMARY KEY,
      value TEXT
    );

    CREATE TABLE IF NOT EXISTS password_resets (
      token_hash TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      expires_at TEXT NOT NULL,
      created_at TEXT NOT NULL
    );
  `);

  // מיגרציה: פרויקטים שהורצו לפני המעבר מ-Grow ל-Invoice4U מחזיקים עדיין עמודה
  // בשם grow_transaction_id - ממירים אותה לשם הגנרי החדש בלי לאבד נתונים קיימים.
  const paymentsColumns = conn.prepare("PRAGMA table_info(payments)").all();
  const hasOldColumn = paymentsColumns.some((c) => c.name === "grow_transaction_id");
  const hasNewColumn = paymentsColumns.some((c) => c.name === "clearing_log_id");
  if (hasOldColumn && !hasNewColumn) {
    conn.exec("ALTER TABLE payments RENAME COLUMN grow_transaction_id TO clearing_log_id;");
  }
}

const DEFAULT_SETTINGS = {
  course_title: "שם הקורס שלך",
  course_subtitle: "כתבו כאן משפט קצר שמסביר למי הקורס ומה הוא נותן",
  course_description:
    "זהו טקסט לדוגמה. ערכו אותו בעמוד הניהול (/admin) וכתבו כמה פסקאות שמסבירות מה כלול בקורס, למי הוא מתאים ולמה כדאי להירשם.",
  price: "490",
  currency: "ILS"
};

function seedIfEmpty(conn) {
  const row = conn.prepare("SELECT COUNT(*) as c FROM settings").get();
  if (row.c === 0) {
    const stmt = conn.prepare("INSERT INTO settings (key, value) VALUES (?, ?)");
    for (const [key, value] of Object.entries(DEFAULT_SETTINGS)) {
      stmt.run(key, value);
    }
  }

  const lessonsCount = conn.prepare("SELECT COUNT(*) as c FROM lessons").get();
  if (lessonsCount.c === 0) {
    const insertLesson = conn.prepare(
      "INSERT INTO lessons (id, title, description, video_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?)"
    );
    insertLesson.run(
      crypto.randomUUID(),
      "שיעור 1 - ערכו אותי בעמוד הניהול",
      "תיאור קצר של השיעור. הדביקו כאן קישור לסרטון (מומלץ Vimeo עם הגבלת דומיין, או YouTube לא רשום).",
      "",
      1,
      new Date().toISOString()
    );
    insertLesson.run(
      crypto.randomUUID(),
      "שיעור 2 - לדוגמה",
      "אפשר להוסיף, לערוך ולמחוק שיעורים בעמוד /admin.",
      "",
      2,
      new Date().toISOString()
    );
  }
}

function createConnection() {
  if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR, { recursive: true });
  }
  const conn = new DatabaseSync(DB_PATH);
  conn.exec("PRAGMA journal_mode = WAL;");
  // אם בכל זאת יש גישה מקבילה לקובץ (כמה תהליכים/workers), עדיף שה-SQLite
  // ינסה להמתין לנעילה כמה שניות במקום להיכשל מיידית עם "database is locked".
  conn.exec("PRAGMA busy_timeout = 5000;");
  conn.exec("PRAGMA foreign_keys = ON;");
  migrate(conn);
  seedIfEmpty(conn);
  return conn;
}

function getRealDb() {
  if (!globalForDb.__courseDb) {
    globalForDb.__courseDb = createConnection();
  }
  return globalForDb.__courseDb;
}

// Proxy "עצלן": הקובץ הזה ייובא (import) במקומות רבים, אבל החיבור בפועל
// (פתיחת קובץ + migrate + seed) קורה רק כשמשתמשים בפועל ב-db.prepare/db.exec
// וכו', לא בזמן ה-import עצמו.
export const db = new Proxy(
  {},
  {
    get(_target, prop) {
      const real = getRealDb();
      const value = real[prop];
      return typeof value === "function" ? value.bind(real) : value;
    }
  }
);

export function nowIso() {
  return new Date().toISOString();
}
