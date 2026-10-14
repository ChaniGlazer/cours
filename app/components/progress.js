"use client";

import { useMemo, useSyncExternalStore } from "react";

// התקדמות בקורסים נשמרת ב-localStorage של הדפדפן (אין עדיין טבלת התקדמות במסד):
// { [courseId]: { done: [lessonSlug], seen: [lessonSlug], auto: [lessonSlug] } }
// auto = שיעורים שסומנו כהושלמו אוטומטית (השיעור עצמו דיווח שכל תרגילי החובה הושלמו).
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

// changes: { [field]: boolean } - כל השדות נכתבים יחד, בכתיבה אחת ובאירוע אחד.
function update(courseId, slug, changes) {
  let all = {};
  try {
    all = JSON.parse(read()) || {};
  } catch {
    all = {};
  }
  const entry = all[courseId] || { done: [], seen: [] };
  const next = { ...entry };
  for (const [field, on] of Object.entries(changes)) {
    const list = new Set(entry[field] || []);
    if (on) list.add(slug);
    else list.delete(slug);
    next[field] = [...list];
  }
  all[courseId] = next;
  write(all);
}

export function markSeen(courseId, slug) {
  update(courseId, slug, { seen: true });
}

// auto = true רק כשהשיעור עצמו דיווח שכל תרגילי החובה הושלמו. סימון או ביטול ידני תמיד מאפס אותו.
export function setDone(courseId, slug, on, auto = false) {
  update(courseId, slug, { done: on, auto: on && auto });
}

export function isAuto(progress, courseId, slug) {
  return !!progress[courseId]?.auto?.includes(slug) && !!progress[courseId]?.done?.includes(slug);
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
