"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
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

const SETTINGS_TEXT_FIELDS = [
  "site_title",
  "instructor_name",
  "instructor_bio",
  "instructor_photo_url",
  "guarantee_text"
];

export async function updateSettingsAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const values = {};
  for (const field of SETTINGS_TEXT_FIELDS) {
    values[field] = (formData.get(field) || "").toString().trim();
  }

  await updateSettings(values);
  redirect("/admin?saved=settings");
}

export async function createTestimonialAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const name = (formData.get("name") || "").toString().trim();
  const role = (formData.get("role") || "").toString().trim();
  const quote = (formData.get("quote") || "").toString().trim();
  const result = (formData.get("result") || "").toString().trim();
  const photo_url = (formData.get("photo_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!name || !quote) redirect("/admin?error=testimonial_fields");

  const db = await getDb();
  await db
    .prepare(
      "INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(crypto.randomUUID(), name, role, quote, result, photo_url, position, nowIso())
    .run();

  redirect("/admin?saved=testimonial");
}

export async function updateTestimonialAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const name = (formData.get("name") || "").toString().trim();
  const role = (formData.get("role") || "").toString().trim();
  const quote = (formData.get("quote") || "").toString().trim();
  const result = (formData.get("result") || "").toString().trim();
  const photo_url = (formData.get("photo_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !name || !quote) redirect("/admin?error=testimonial_fields");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE testimonials SET name = ?, role = ?, quote = ?, result = ?, photo_url = ?, position = ? WHERE id = ?"
    )
    .bind(name, role, quote, result, photo_url, position, id)
    .run();

  redirect("/admin?saved=testimonial");
}

export async function deleteTestimonialAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    const db = await getDb();
    await db.prepare("DELETE FROM testimonials WHERE id = ?").bind(id).run();
  }
  redirect("/admin?saved=testimonial");
}

export async function createCourseAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const title = (formData.get("title") || "").toString().trim();
  const subtitle = (formData.get("subtitle") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const is_paid = formData.get("is_paid") ? 1 : 0;
  const priceRaw = parseInt((formData.get("price_ils") || "").toString(), 10);
  const price_ils = Number.isFinite(priceRaw) ? priceRaw : null;

  if (!title) redirect("/admin?error=course_title");

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

  redirect("/admin?saved=course");
}

export async function updateCourseAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const subtitle = (formData.get("subtitle") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const is_paid = formData.get("is_paid") ? 1 : 0;
  const priceRaw = parseInt((formData.get("price_ils") || "").toString(), 10);
  const price_ils = Number.isFinite(priceRaw) ? priceRaw : null;
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !title) redirect("/admin?error=course_title");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE courses SET title = ?, subtitle = ?, description = ?, is_paid = ?, price_ils = ?, position = ? WHERE id = ?"
    )
    .bind(title, subtitle, description, is_paid, price_ils, position, id)
    .run();

  redirect("/admin?saved=course");
}

export async function createLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const course_id = (formData.get("course_id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const html_content = (formData.get("html_content") || "").toString();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);

  if (!title || !course_id) redirect("/admin?error=lesson_title");

  const db = await getDb();

  let position = positionRaw;
  if (!Number.isFinite(position)) {
    const row = await db.prepare("SELECT COUNT(*) as c FROM lessons WHERE course_id = ?").bind(course_id).first();
    position = row.c + 1;
  }

  const slugInput = (formData.get("slug") || "").toString().trim();
  const slug = slugify(slugInput || title, crypto.randomUUID().slice(0, 8));

  await db
    .prepare(
      "INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
    )
    .bind(crypto.randomUUID(), course_id, slug, title, description, video_url, html_content, position, nowIso())
    .run();

  redirect("/admin?saved=lesson");
}

export async function updateLessonAction(formData) {
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

  if (!id || !title || !course_id) redirect("/admin?error=lesson_title");

  const db = await getDb();
  await db
    .prepare(
      "UPDATE lessons SET course_id = ?, slug = ?, title = ?, description = ?, video_url = ?, html_content = ?, position = ? WHERE id = ?"
    )
    .bind(course_id, slug, title, description, video_url, html_content, position, id)
    .run();

  redirect("/admin?saved=lesson");
}

export async function deleteLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    const db = await getDb();
    await db.prepare("DELETE FROM lessons WHERE id = ?").bind(id).run();
  }
  redirect("/admin?saved=lesson");
}
