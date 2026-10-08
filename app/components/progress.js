"use client";

import { useMemo, useSyncExternalStore } from "react";

// התקדמות בקורסים נשמרת ב-localStorage של הדפדפן (אין עדיין טבלת התקדמות במסד):
// { [courseId]: { done: [lessonSlug], seen: [lessonSlug] } }
const KEY = "course-progress-v1";
const EVT = "course-progress-change";

function read() {
  try {
    return window.localStorage.getItem(KEY) || "{}";
  } catch {
    return "{}";
  }
}

function subscribe(cb) {
  window.addEventListener("storage", cb);
  window.addEventListener(EVT, cb);
  return () => {
    window.removeEventListener("storage", cb);
    window.removeEventListener(EVT, cb);
  };
}

export function useProgress() {
  const raw = useSyncExternalStore(subscribe, read, () => "{}");
  return useMemo(() => {
    try {
      return JSON.parse(raw) || {};
    } catch {
      return {};
    }
  }, [raw]);
}

function write(next) {
  try {
    window.localStorage.setItem(KEY, JSON.stringify(next));
    window.dispatchEvent(new Event(EVT));
  } catch {
    // אחסון חסום (מצב פרטי ועוד) - ההתקדמות פשוט לא תישמר.
  }
}

function update(courseId, slug, field, on) {
  let all = {};
  try {
    all = JSON.parse(read()) || {};
  } catch {
    all = {};
  }
  const entry = all[courseId] || { done: [], seen: [] };
  const list = new Set(entry[field] || []);
  if (on) list.add(slug);
  else list.delete(slug);
  all[courseId] = { ...entry, [field]: [...list] };
  write(all);
}

export function markSeen(courseId, slug) {
  update(courseId, slug, "seen", true);
}

export function setDone(courseId, slug, on) {
  update(courseId, slug, "done", on);
}

// "done" | "seen" | "new"
export function lessonStatus(progress, courseId, slug) {
  const e = progress[courseId];
  if (e?.done?.includes(slug)) return "done";
  if (e?.seen?.includes(slug)) return "seen";
  return "new";
}

// השיעור שצריך להמשיך אליו: הראשון שלא הושלם (ואם הכול הושלם - הראשון).
export function nextLesson(progress, courseId, slugs) {
  return slugs.find((s) => lessonStatus(progress, courseId, s) !== "done") || slugs[0];
}

export function countDone(progress, courseId, slugs) {
  return slugs.filter((s) => lessonStatus(progress, courseId, s) === "done").length;
}
