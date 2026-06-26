// lib/db.js
//
// שכבת מסד הנתונים. משתמשים ב-node:sqlite המובנה ב-Node.js (גרסה 22.5+)
// כדי שלא יהיה צורך בהתקנת תוסף native כלשהו - דבר שמקל מאוד על אחסון עצמי.
// אם תרצו להחליף בעתיד למסד נתונים אחר (Postgres וכו'), זה הקובץ היחיד שצריך לשנות.

import { DatabaseSync } from "node:sqlite";
import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";

const DATA_DIR = path.join(process.cwd(), "data");
const DB_PATH = path.join(DATA_DIR, "course.db");

if (!fs.existsSync(DATA_DIR)) {
  fs.mkdirSync(DATA_DIR, { recursive: true });
}

// משתמשים ב-global כדי לא לפתוח חיבור חדש בכל hot-reload בסביבת פיתוח
const globalForDb = globalThis;

function createConnection() {
  const db = new DatabaseSync(DB_PATH);
  db.exec("PRAGMA journal_mode = WAL;");
  db.exec("PRAGMA foreign_keys = ON;");
  return db;
}

export const db = globalForDb.__courseDb || (globalForDb.__courseDb = createConnection());

function migrate() {
  db.exec(`
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
      grow_transaction_id TEXT,
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
  `);
}

migrate();

const DEFAULT_SETTINGS = {
  course_title: "שם הקורס שלך",
  course_subtitle: "כתבו כאן משפט קצר שמסביר למי הקורס ומה הוא נותן",
  course_description:
    "זהו טקסט לדוגמה. ערכו אותו בעמוד הניהול (/admin) וכתבו כמה פסקאות שמסבירות מה כלול בקורס, למי הוא מתאים ולמה כדאי להירשם.",
  price: "490",
  currency: "ILS"
};

function seedIfEmpty() {
  const row = db.prepare("SELECT COUNT(*) as c FROM settings").get();
  if (row.c === 0) {
    const stmt = db.prepare("INSERT INTO settings (key, value) VALUES (?, ?)");
    for (const [key, value] of Object.entries(DEFAULT_SETTINGS)) {
      stmt.run(key, value);
    }
  }

  const lessonsCount = db.prepare("SELECT COUNT(*) as c FROM lessons").get();
  if (lessonsCount.c === 0) {
    const insertLesson = db.prepare(
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

seedIfEmpty();

export function nowIso() {
  return new Date().toISOString();
}
