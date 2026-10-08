"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { getDb, nowIso } from "@/lib/db";
import { updateSettings } from "@/lib/settings";
import { slugify } from "@/lib/courses";
import {
  createAdminSession,
  destroyAdminSession,
  isAdmin,
  verifyAdminPassword
} from "@/lib/admin-auth";

export async function adminLoginAction(formData) {
  const password = (formData.get("password") || "").toString();
  if (!verifyAdminPassword(password)) {
    redirect("/admin?error=1");
  }
  await createAdminSession();
  redirect("/admin");
}

export async function adminLogoutAction() {
  await destroyAdminSession();
  redirect("/admin");
}

const fail = (error) => ({ ok: false, error, ts: Date.now() });
const done = (message, extra = {}) => {
  revalidatePath("/admin");
  return { ok: true, message, ts: Date.now(), ...extra };
};

const SETTINGS_TEXT_FIELDS = [
  "site_title",
  "instructor_name",
  "instructor_bio",
  "instructor_photo_url",
  "guarantee_text"
];

export async function updateSettingsAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const values = {};
  for (const field of SETTINGS_TEXT_FIELDS) {
    values[field] = (formData.get(field) || "").toString().trim();
  }

  await updateSettings(values);
  return done("ההגדרות נשמרו");
}

export async function createTestimonialAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const name = (formData.get("name") || "").toString().trim();
  const role = (formData.get("role") || "").toString().trim();
  const quote = (formData.get("quote") || "").toString().trim();
  const result = (formData.get("result") || "").toString().trim();
  const photo_url = (formData.get("photo_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!name || !quote) return fail("יש להזין שם וטקסט המלצה.");

  const newId = crypto.randomUUID();
  const db = await getDb();
  await db
    .prepare(
      "INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(newId, name, role, quote, result, photo_url, position, nowIso())
    .run();

  return done("ההמלצה נוספה", { createdId: newId });
}

export async function updateTestimonialAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const name = (formData.get("name") || "").toString().trim();
  const role = (formData.get("role") || "").toString().trim();
  const quote = (formData.get("quote") || "").toString().trim();
  const result = (formData.get("result") || "").toString().trim();
  const photo_url = (formData.get("photo_url") || "").toString().trim();
  const statusRaw = (formData.get("status") || "").toString();
  const status = ["approved", "pending", "rejected"].includes(statusRaw) ? statusRaw : "approved";
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !name || !quote) return fail("יש להזין שם וטקסט המלצה.");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE testimonials SET name = ?, role = ?, quote = ?, result = ?, photo_url = ?, position = ?, status = ? WHERE id = ?"
    )
    .bind(name, role, quote, result, photo_url, position, status, id)
    .run();

  revalidatePath("/courses", "layout");
  return done(status === "approved" ? "ההמלצה נשמרה ומוצגת באתר" : status === "pending" ? "ההמלצה נשמרה וממתינה לאישור" : "ההמלצה נשמרה ולא תוצג");
}

export async function deleteTestimonialAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    const db = await getDb();
    await db.prepare("DELETE FROM testimonials WHERE id = ?").bind(id).run();
  }
  return done("ההמלצה נמחקה", { deleted: true });
}

export async function createCourseAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const title = (formData.get("title") || "").toString().trim();
  const subtitle = (formData.get("subtitle") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const is_paid = formData.get("is_paid") ? 1 : 0;
  const priceRaw = parseInt((formData.get("price_ils") || "").toString(), 10);
  const price_ils = Number.isFinite(priceRaw) ? priceRaw : null;

  if (!title) return fail("יש להזין כותרת לקורס.");

  const id = slugify(title, crypto.randomUUID().slice(0, 8));

  const db = await getDb();
  const existing = await db.prepare("SELECT id FROM courses").all();
  const maxPosition = existing.results.length;

  await db
    .prepare(
      "INSERT INTO courses (id, title, subtitle, description, is_paid, price_ils, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(id, title, subtitle, description, is_paid, price_ils, maxPosition + 1, nowIso())
    .run();

  return done("הקורס נוצר (חינמי כברירת מחדל)", { createdId: id });
}

export async function updateCourseAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const subtitle = (formData.get("subtitle") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const is_paid = formData.get("is_paid") ? 1 : 0;
  const coming_soon = formData.get("coming_soon") ? 1 : 0;
  const priceRaw = parseInt((formData.get("price_ils") || "").toString(), 10);
  const price_ils = Number.isFinite(priceRaw) ? priceRaw : null;
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !title) return fail("יש להזין כותרת לקורס.");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE courses SET title = ?, subtitle = ?, description = ?, is_paid = ?, coming_soon = ?, price_ils = ?, position = ? WHERE id = ?"
    )
    .bind(title, subtitle, description, is_paid, coming_soon, price_ils, position, id)
    .run();

  return done("הקורס נשמר");
}

export async function createLessonAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const course_id = (formData.get("course_id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const html_content = (formData.get("html_content") || "").toString();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);

  if (!title || !course_id) return fail("יש להזין כותרת לשיעור ולבחור קורס.");

  const db = await getDb();

  let position = positionRaw;
  if (!Number.isFinite(position)) {
    const row = await db.prepare("SELECT COUNT(*) as c FROM lessons WHERE course_id = ?").bind(course_id).first();
    position = row.c + 1;
  }

  const slugInput = (formData.get("slug") || "").toString().trim();
  const slug = slugify(slugInput || title, crypto.randomUUID().slice(0, 8));
  const newId = crypto.randomUUID();

  await db
    .prepare(
      "INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(newId, course_id, slug, title, description, video_url, html_content, position, nowIso())
    .run();

  return done("השיעור נוסף", { createdId: newId });
}

export async function updateLessonAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const course_id = (formData.get("course_id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const html_content = (formData.get("html_content") || "").toString();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;
  const slugInput = (formData.get("slug") || "").toString().trim();
  const slug = slugify(slugInput || title, id.slice(0, 8));

  if (!id || !title || !course_id) return fail("יש להזין כותרת לשיעור ולבחור קורס.");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE lessons SET course_id = ?, slug = ?, title = ?, description = ?, video_url = ?, html_content = ?, position = ? WHERE id = ?"
    )
    .bind(course_id, slug, title, description, video_url, html_content, position, id)
    .run();

  return done("השיעור נשמר");
}

export async function deleteLessonAction(_prev, formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    const db = await getDb();
    await db.prepare("DELETE FROM lessons WHERE id = ?").bind(id).run();
  }
  return done("השיעור נמחק", { deleted: true });
}
