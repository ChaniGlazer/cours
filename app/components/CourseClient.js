"use client";

import { ProgressBar } from "./ui";
import { countDone, lessonStatus, nextLesson, useProgress } from "./progress";

const STATUS_LABEL = { done: "הושלם", seen: "בתהליך", new: "לא התחיל" };

// כפתור ראשי בדף הקורס: "התחל ללמוד" או "המשך ללימוד" לפי ההתקדמות.
export function CourseCta({ courseId, slugs, className = "btn btn-primary", startLabel = "התחל ללמוד" }) {
  const progress = useProgress();
  if (slugs.length === 0) return null;
  const started = slugs.some((s) => lessonStatus(progress, courseId, s) !== "new");
  const target = nextLesson(progress, courseId, slugs);
  return (
    <a href={`/courses/${courseId}/${target}`} className={className}>
      {started ? "המשך ללימוד" : startLabel}
    </a>
  );
}

export function CourseProgress({ courseId, slugs }) {
  const progress = useProgress();
  const done = countDone(progress, courseId, slugs);
  return (
    <div className="course-hero__progress">
      <small>
        {done} מתוך {slugs.length} שיעורים הושלמו
      </small>
      <ProgressBar value={done} max={slugs.length} label="התקדמות בקורס" />
    </div>
  );
}

// כרטיס "המשך מהמקום שעצרת": הקורס הראשון שהתחילו בו ולא סיימו.
export function ResumeCard({ courses }) {
  const progress = useProgress();
  const found = courses.find((c) => {
    const slugs = c.lessons.map((l) => l.slug);
    const started = slugs.some((s) => lessonStatus(progress, c.id, s) !== "new");
    return started && countDone(progress, c.id, slugs) < slugs.length;
  });
  if (!found) return null;
  const slugs = found.lessons.map((l) => l.slug);
  const target = nextLesson(progress, found.id, slugs);
  const lesson = found.lessons.find((l) => l.slug === target);
  const done = countDone(progress, found.id, slugs);
  return (
    <div className="resume-card">
      <div className="resume-card__text">
        <small>המשך מהמקום שעצרת · {found.title}</small>
        <b>{lesson.title}</b>
      </div>
      <ProgressBar value={done} max={slugs.length} label="התקדמות בקורס" />
      <a href={`/courses/${found.id}/${target}`} className="btn btn-primary btn-sm">
        המשך ללימוד
      </a>
    </div>
  );
}

// התקדמות בתוך כרטיס קורס בקטלוג (מוצגת רק אם יש התקדמות) + כפתור התחל/המשך.
export function CardAction({ courseId, slugs }) {
  const progress = useProgress();
  const done = countDone(progress, courseId, slugs);
  const started = slugs.some((s) => lessonStatus(progress, courseId, s) !== "new");
  const target = nextLesson(progress, courseId, slugs);
  return (
    <>
      {done > 0 && <ProgressBar value={done} max={slugs.length} label="התקדמות בקורס" />}
      <a href={`/courses/${courseId}/${target}`} className="btn btn-primary btn-block">
        {started ? "המשך ללימוד" : "התחל ללמוד"}
      </a>
    </>
  );
}

// סילבוס עם סטטוס לכל שיעור. lessons: [{ slug, title, description, locked }]
export function Syllabus({ courseId, lessons }) {
  const progress = useProgress();
  const openSlugs = lessons.filter((l) => !l.locked).map((l) => l.slug);
  const startedAny = openSlugs.some((s) => lessonStatus(progress, courseId, s) !== "new");
  const target = startedAny ? nextLesson(progress, courseId, openSlugs) : null;
  return (
    <ol className="syllabus">
      {lessons.map((l, i) => {
        const status = l.locked ? "locked" : lessonStatus(progress, courseId, l.slug);
        const isCurrent = l.slug === target && status !== "done";
        const cls = `syl-row is-${status}${isCurrent ? " is-current" : ""}`;
        const label = l.locked ? "נעול" : isCurrent && status === "new" ? "הבא בתור" : STATUS_LABEL[status];
        const body = (
          <>
            <span className="syl-num" aria-hidden="true">
              {l.locked ? "🔒" : status === "done" ? "✓" : i + 1}
            </span>
            <span className="syl-text">
              <b>{l.title}</b>
              {l.description && <span>{l.description}</span>}
            </span>
            <span className="syl-status">{label}</span>
          </>
        );
        return (
          <li key={l.slug}>
            {l.locked ? (
              <div className={cls}>{body}</div>
            ) : (
              <a href={`/courses/${courseId}/${l.slug}`} className={cls}>
                {body}
              </a>
            )}
          </li>
        );
      })}
    </ol>
  );
}
