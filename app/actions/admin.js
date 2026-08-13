"use server";

import crypto from "node:crypto";
import { redirect } from "next/navigation";
import { db, nowIso } from "@/lib/db";
import { updateSettings, getLessonCount } from "@/lib/settings";
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
  "course_title",
  "course_subtitle",
  "course_description",
  "price",
  "hero_video_url",
  "rating_value",
  "rating_count",
  "stat_highlight",
  "problem_text",
  "outcome_text",
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

  updateSettings(values);
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

  db.prepare(
    "INSERT INTO testimonials (id, name, role, quote, result, photo_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
  ).run(crypto.randomUUID(), name, role, quote, result, photo_url, position, nowIso());

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

  db.prepare(
    "UPDATE testimonials SET name = ?, role = ?, quote = ?, result = ?, photo_url = ?, position = ? WHERE id = ?"
  ).run(name, role, quote, result, photo_url, position, id);

  redirect("/admin?saved=testimonial");
}

export async function deleteTestimonialAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    db.prepare("DELETE FROM testimonials WHERE id = ?").run(id);
  }
  redirect("/admin?saved=testimonial");
}

export async function createLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : getLessonCount() + 1;

  if (!title) redirect("/admin?error=lesson_title");

  db.prepare(
    "INSERT INTO lessons (id, title, description, video_url, position, created_at) VALUES (?, ?, ?, ?, ?, ?)"
  ).run(crypto.randomUUID(), title, description, video_url, position, nowIso());

  redirect("/admin?saved=lesson");
}

export async function updateLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");

  const id = (formData.get("id") || "").toString();
  const title = (formData.get("title") || "").toString().trim();
  const description = (formData.get("description") || "").toString().trim();
  const video_url = (formData.get("video_url") || "").toString().trim();
  const positionRaw = parseInt((formData.get("position") || "").toString(), 10);
  const position = Number.isFinite(positionRaw) ? positionRaw : 0;

  if (!id || !title) redirect("/admin?error=lesson_title");

  db.prepare("UPDATE lessons SET title = ?, description = ?, video_url = ?, position = ? WHERE id = ?").run(
    title,
    description,
    video_url,
    position,
    id
  );

  redirect("/admin?saved=lesson");
}

export async function deleteLessonAction(formData) {
  if (!(await isAdmin())) redirect("/admin");
  const id = (formData.get("id") || "").toString();
  if (id) {
    db.prepare("DELETE FROM lessons WHERE id = ?").run(id);
  }
  redirect("/admin?saved=lesson");
}
