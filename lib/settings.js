// lib/settings.js
import { getDb } from "./db";

export async function getSettings() {
  const db = await getDb();
  const { results } = await db.prepare("SELECT key, value FROM settings").all();
  const settings = {};
  for (const row of results) {
    settings[row.key] = row.value;
  }
  return settings;
}

export async function updateSettings(partial) {
  const db = await getDb();
  const stmt = db.prepare(
    "INSERT INTO settings (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value"
  );
  for (const [key, value] of Object.entries(partial)) {
    await stmt.bind(key, String(value ?? "")).run();
  }
}

export async function getAllLessons() {
  const db = await getDb();
  const { results } = await db
    .prepare("SELECT * FROM lessons ORDER BY course_id ASC, position ASC, created_at ASC")
    .all();
  return results;
}

export async function getTestimonials() {
  const db = await getDb();
  const { results } = await db.prepare("SELECT * FROM testimonials ORDER BY position ASC, created_at ASC").all();
  return results;
}
