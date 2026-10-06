// lib/db.js
//
// שכבת מסד הנתונים. משתמשים ב-Cloudflare D1 (SQLite serverless מנוהל) - ל-Cloudflare
// Workers אין דיסק קבוע, ולכן אי אפשר להשתמש ב-node:sqlite כפי שהיה בזמן ריצה ב-Render.
// מבנה הטבלאות וה-seed הראשוני נמצאים ב-migrations/0001_init.sql ומורצים דרך
// `wrangler d1 migrations apply`, לא בזמן ריצה (כמו migrate()/seedIfEmpty() הקודמים).
//
// חשוב: בניגוד ל-node:sqlite הסינכרוני, db.prepare(...).first()/.all()/.run() של D1
// הם אסינכרוניים - כל קריאה בכל קובץ שמשתמש ב-getDb() חייבת await.

import { getCloudflareContext } from "@opennextjs/cloudflare";

export async function getDb() {
  const { env } = await getCloudflareContext({ async: true });
  return env.DB;
}

export function nowIso() {
  return new Date().toISOString();
}
