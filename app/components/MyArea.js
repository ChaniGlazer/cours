"use client";

// הלוח האישי ב"האזור שלי" (app/my-courses/page.js). רכיב client אחד, כי כל חלקיו תלויים בהתקדמות שנשמרת ב-localStorage.
// השרת שולח את הקורסים והשיעורים (slug וכותרת); כאן מחשבים מה סיימו ומה הבא בתור.
//
// בלי "קפיצה" בין שרת ללקוח: ב-HTML מהשרת ובהידרציה אין עדיין נתוני התקדמות, ולכן כל מה שתלוי בהם מוצג כשלד בגובה קבוע
// (ma-skel) עד שהדפדפן קורא את ה-localStorage. רק אז מופיעים המספרים, התוויות והכפתורים, בלי להציג רגע "0 שיעורים".

import { useEffect, useMemo, useSyncExternalStore } from "react";
import { ProgressBar } from "./ui";
import { countDone, enableServerTracking, lessonStatus, nextLesson, useProgress } from "./progress";

const noopSubscribe = () => () => {};

// false בשרת ובהידרציה, true מיד אחריה: סימן שאפשר לקרוא את ההתקדמות מהדפדפן.
function useReady() {
  return useSyncExternalStore(noopSubscribe, () => true, () => false);
}

function lessonsWord(n) {
  return n === 1 ? "שיעור אחד" : `${n} שיעורים`;
}

// מצב כל קורס לפי ההתקדמות: empty (אין שיעורים) | new | progress | done
function describe(course, progress) {
  const slugs = course.lessons.map((l) => l.slug);
  const total = slugs.length;
  const done = countDone(progress, course.id, slugs);
  const started = slugs.some((s) => lessonStatus(progress, course.id, s) !== "new");
  const state = total === 0 ? "empty" : done === total ? "done" : started ? "progress" : "new";
  const nextSlug = total > 0 ? nextLesson(progress, course.id, slugs) : null;
  const next = nextSlug ? course.lessons.find((l) => l.slug === nextSlug) : null;
  return { ...course, total, done, started, state, next };
}

function Skel({ w = "100%", h = "1em", className = "" }) {
  return <span className={`ma-skel ${className}`} style={{ width: w, height: h }} aria-hidden="true" />;
}

function summaryText(items) {
  const doneLessons = items.reduce((n, c) => n + c.done, 0);
  const coursesWithDone = items.filter((c) => c.done > 0).length;
  if (doneLessons > 0) {
    const l = doneLessons === 1 ? "שיעור אחד" : `${doneLessons} שיעורים`;
    const c = coursesWithDone === 1 ? "קורס אחד" : `${coursesWithDone} קורסים`;
    return `סיימת ${l} ב${c}`;
  }
  if (items.some((c) => c.started)) return "התחלת ללמוד, בואי נמשיך";
  return "בואי נתחיל";
}

// כרטיס "המשך מהמקום שעצרת": קורס בתהליך, או "אפשר להתחיל מכאן", או "סיימת הכל".
function Spotlight({ ready, items }) {
  const playable = items.filter((c) => c.total > 0);
  if (playable.length === 0) return null; // תלוי רק בנתוני השרת, ולכן לא גורם לקפיצה
  if (!ready) {
    return (
      <section className="ma-spot ma-spot--loading" aria-busy="true" aria-label="טוענת את ההתקדמות">
        <div className="ma-spot__main">
          <Skel w="9rem" h="0.95rem" />
          <Skel w="70%" h="2rem" className="ma-spot__t" />
          <Skel w="55%" h="1.1rem" />
        </div>
        <div className="ma-spot__side">
          <Skel w="100%" h="8px" />
          <Skel w="9rem" h="1rem" />
          <Skel w="100%" h="56px" className="ma-skel--pill" />
        </div>
      </section>
    );
  }
  const resume = playable.find((c) => c.state === "progress");
  const fresh = playable.find((c) => c.state === "new");
  let mode = "resume";
  let course = resume;
  if (!resume) {
    mode = fresh ? "start" : "all";
    course = fresh || playable[0];
  }

  const heading = mode === "resume" ? "המשך מהמקום שעצרת" : mode === "start" ? "אפשר להתחיל מכאן" : "כל הכבוד";
  const lessonLine =
    mode === "resume"
      ? `השיעור הבא: ${course.next.title}`
      : mode === "start"
        ? `השיעור הראשון: ${course.lessons[0].title}`
        : `נתחיל מ${course.title}`;
  const href =
    mode === "resume"
      ? `/courses/${course.id}/${course.next.slug}`
      : mode === "start"
        ? `/courses/${course.id}/${course.lessons[0].slug}`
        : `/courses/${course.id}`;
  const cta = mode === "resume" ? "המשך ללימוד" : mode === "start" ? "התחילי ללמוד" : "חזרה לתרגול";
  const countLine =
    mode === "start" ? `${lessonsWord(course.total)} בקורס` : `${course.done} מתוך ${course.total} שיעורים הושלמו`;

  return (
    <section className={`ma-spot ma-spot--${mode}`} aria-labelledby="ma-spot-h">
      <div className="ma-spot__main">
        <span className="ma-spot__eyebrow" id="ma-spot-h">
          {heading}
        </span>
        <h2 className="ma-spot__t">{mode === "all" ? "סיימת הכל, אפשר לחזור לתרגל" : course.title}</h2>
        <p className="ma-spot__lesson">{lessonLine}</p>
      </div>
      <div className="ma-spot__side">
        <ProgressBar value={mode === "start" ? 0 : course.done} max={course.total} label={`התקדמות ב${course.title}`} />
        <p className="ma-spot__count">{countLine}</p>
        <a href={href} className="btn btn-primary ma-spot__cta">
          {cta}
        </a>
      </div>
    </section>
  );
}

const STATE_LABEL = { new: "לא התחלת", progress: "בתהליך", done: "הושלם", empty: "בקרוב יתווספו שיעורים" };

function CourseCard({ ready, course }) {
  const c = course;
  const first = c.lessons[0];
  // קורס בלי שיעורים עדיין: המצב ידוע כבר מהשרת, ולכן אין שלד ואין "0 מתוך 0".
  const noLessons = c.total === 0;
  const isDone = ready && c.state === "done";
  const href = !ready
    ? `/courses/${c.id}`
    : c.state === "progress"
      ? `/courses/${c.id}/${c.next.slug}`
      : c.state === "new"
        ? `/courses/${c.id}/${first.slug}`
        : `/courses/${c.id}`;
  const cta = !ready && !noLessons ? null : c.state === "progress" ? "המשיכי" : c.state === "new" ? "התחילי" : c.state === "done" ? "חזרה לקורס" : "לעמוד הקורס";

  return (
    <li className="ma-li">
      <article className={`ma-card${isDone ? " is-done" : ""}`} aria-labelledby={`ma-c-${c.id}`}>
        <div className="ma-card__top">
          <span className={`ui-badge ${c.is_paid ? "ui-badge--paid" : "ui-badge--free"}`}>{c.is_paid ? "נרכש" : "חינם"}</span>
          <span className="ma-card__count">{noLessons ? "בקרוב" : lessonsWord(c.total)}</span>
        </div>
        <h3 className="ma-card__title" id={`ma-c-${c.id}`}>
          {isDone && (
            <span className="ma-check" role="img" aria-label="הושלם">
              ✓
            </span>
          )}
          {c.title}
        </h3>
        {c.subtitle && <p className="ma-card__sub">{c.subtitle}</p>}

        <div className="ma-card__progress">
          {noLessons ? (
            <p className="ma-card__soon">השיעורים יתווספו בקרוב</p>
          ) : ready ? (
            <>
              <ProgressBar value={c.done} max={c.total} label={`התקדמות ב${c.title}`} thin />
              <div className="ma-card__row">
                <span>
                  {c.done} מתוך {c.total}
                </span>
                <span className={`ma-state ma-state--${c.state}`}>{STATE_LABEL[c.state]}</span>
              </div>
            </>
          ) : (
            <>
              <Skel w="100%" h="5px" />
              <div className="ma-card__row">
                <Skel w="5rem" h="1rem" />
                <Skel w="4.5rem" h="1rem" />
              </div>
            </>
          )}
        </div>

        {ready || noLessons ? (
          <a href={href} className={`btn ma-card__cta ${c.state === "done" ? "btn-secondary btn-done" : "btn-primary"}`}>
            {cta}
          </a>
        ) : (
          <Skel w="100%" h="48px" className="ma-skel--pill ma-card__cta" />
        )}
      </article>
    </li>
  );
}

// props: firstName, courses: [{ id, title, subtitle, is_paid, lessons: [{ slug, title }] }]
export default function MyArea({ firstName, courses }) {
  const ready = useReady();
  const progress = useProgress();
  // האזור שלי מוצג רק למשתמשת מחוברת: מפעילים מעקב ומעבירים לשרת התקדמות ישנה מהדפדפן.
  useEffect(() => enableServerTracking(), []);
  const items = useMemo(() => courses.map((c) => describe(c, progress)), [courses, progress]);

  return (
    <>
      <header className="ma-hero">
        <span className="eyebrow">האזור שלי</span>
        <h1 className="ma-hero__h1">{firstName ? `שלום ${firstName}` : "שלום"}</h1>
        <p className="ma-hero__sum" role="status" aria-live="polite">
          {courses.length === 0 ? "בואי נתחיל" : ready ? summaryText(items) : <Skel w="14rem" h="1.1em" className="ma-skel--inline" />}
        </p>
      </header>

      {courses.length === 0 ? (
        <section className="ma-empty" aria-labelledby="ma-empty-h">
          <h2 id="ma-empty-h">עדיין אין קורסים באזור שלך</h2>
          <p>בקטלוג יש קורסים בחינם שאפשר להתחיל מהם עכשיו.</p>
          <a href="/courses" className="btn btn-primary">
            לקטלוג הקורסים
          </a>
        </section>
      ) : (
        <>
          <Spotlight ready={ready} items={items} />
          <section className="ma-section" aria-labelledby="ma-mine-h">
            <h2 className="ma-section__h" id="ma-mine-h">
              הקורסים שלי
            </h2>
            <ul className="ma-grid" role="list" aria-busy={!ready}>
              {items.map((c) => (
                <CourseCard key={c.id} ready={ready} course={c} />
              ))}
            </ul>
          </section>
        </>
      )}
    </>
  );
}
