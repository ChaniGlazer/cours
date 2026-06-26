// lib/settings.js
import { db } from "./db";

export function getSettings() {
  const rows = db.prepare("SELECT key, value FROM settings").all();
  const settings = {};
  for (const row of rows) {
    settings[row.key] = row.value;
  }
  return settings;
}

export function updateSettings(partial) {
  const stmt = db.prepare(
    "INSERT INTO settings (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value"
  );
  for (const [key, value] of Object.entries(partial)) {
    stmt.run(key, String(value ?? ""));
  }
}

export function getLessons() {
  return db.prepare("SELECT * FROM lessons ORDER BY position ASC, created_at ASC").all();
}

export function getLessonCount() {
  return db.prepare("SELECT COUNT(*) as c FROM lessons").get().c;
}
