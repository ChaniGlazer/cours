"use client";

import { useEffect, useRef } from "react";
import { countDone, lessonStatus, markSeen, setDone, useProgress } from "./progress";
import "./lesson-design.css";

// מעטפת עמוד השיעור (תבנית אחת לכל השיעורים בכל הקורסים), לפי design-reference/lesson-page.html:
// כרטיס צד (שם הקורס, טבעת התקדמות, רשימת שיעורים, "המשך לשיעור הבא") ולצדו התוכן: נתיב ניווט,
// הירו (רק לשיעורים בלי HTML משלהם), תוכן השיעור, וכפתור "סמן כהושלם".
// lessons: [{ slug, title, locked }]. prev/next: { slug, title } או null.
const RING_C = 2 * Math.PI * 31; // היקף הטבעת (r = 31)

function Check({ size = 18, stroke = 3 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M5 12.5l4.5 4.5L19 7.5" />
    </svg>
  );
}

// "שיעור 2 - תנאים (if)" -> ["שיעור 2", "תנאים (if)"]. בלי " - " הכותרת נשארת שורה אחת.
function splitTitle(title) {
  const i = title.indexOf(" - ");
  return i === -1 ? [title, ""] : [title.slice(0, i), title.slice(i + 3)];
}

function ringTexts(done, total) {
  if (done === 0) return ["מתחילים!", "עוד לא סיימתם שיעורים"];
  const note = done === 1 ? "סיימתם שיעור אחד" : `סיימתם ${done} שיעורים`;
  if (done >= total) return ["סיימתם את הקורס!", note];
  return [done === 1 ? "התחלה טובה!" : "ממשיכים יפה!", note];
}

export default function LessonLayout({ course, lessons, currentSlug, prev, next, heading, hero, children }) {
  const progress = useProgress();
  const slugs = lessons.map((l) => l.slug);
  const idx = slugs.indexOf(currentSlug);
  const total = slugs.length;
  const done = countDone(progress, course.id, slugs);
  const isDone = lessonStatus(progress, course.id, currentSlug) === "done";
  const ringOffset = total > 0 ? RING_C * (1 - done / total) : RING_C;
  const [ringLabel, ringNote] = ringTexts(done, total);

  useEffect(() => {
    markSeen(course.id, currentSlug);
  }, [course.id, currentSlug]);

  // בטעינה: גוללים את רשימת השיעורים (ורק אותה) כך שהשיעור הנוכחי יהיה במרכז.
  const listRef = useRef(null);
  useEffect(() => {
    const el = listRef.current;
    if (!el || el.scrollHeight <= el.clientHeight + 1) return;
    const cur = el.querySelector("[aria-current]");
    if (!cur) return;
    const c = cur.getBoundingClientRect();
    const l = el.getBoundingClientRect();
    el.scrollTop += c.top - l.top - (el.clientHeight - c.height) / 2;
  }, [currentSlug]);

  const nextHref = next ? `/courses/${course.id}/${next.slug}` : "/courses";
  const [heroTop, heroAccent] = hero ? splitTitle(hero.title) : ["", ""];

  return (
    <div className="lx">
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap"
        precedence="default"
      />

      <div className="lx-page">
        <aside className="lx-aside">
          <nav className="lx-card" aria-label="תוכן הקורס">
            <a href="/courses" className="lx-back">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                <path d="M5 12h14" />
                <path d="M13 6l6 6-6 6" />
              </svg>
              חזרה לקטלוג הקורסים
            </a>
            <div className="lx-card__title">{course.title}</div>

            <div className="lx-ring">
              <svg width="76" height="76" viewBox="0 0 76 76" aria-hidden="true" className="lx-ring__svg">
                <circle cx="38" cy="38" r="31" fill="none" stroke="#14121F" strokeWidth="8" />
                <circle
                  cx="38"
                  cy="38"
                  r="31"
                  fill="none"
                  stroke="#6FE0A0"
                  strokeWidth="8"
                  strokeLinecap="round"
                  strokeDasharray={RING_C}
                  strokeDashoffset={ringOffset}
                />
              </svg>
              <div className="lx-ring__text" role="img" aria-label={`סיימתם ${done} מתוך ${total} שיעורים`}>
                <span dir="ltr" className="lx-ring__count">
                  {done}/{total}
                </span>
                <span className="lx-ring__label">{ringLabel}</span>
                <span className="lx-ring__note">{ringNote}</span>
              </div>
            </div>

            <ol className="lx-list" ref={listRef}>
              {lessons.map((l, i) => {
                const current = l.slug === currentSlug;
                const status = l.locked ? "locked" : lessonStatus(progress, course.id, l.slug);
                const isItemDone = status === "done";
                const body = (
                  <>
                    <span className="lx-item__rail">
                      <span className={`lx-circle${current ? " is-current" : ""}${isItemDone ? " is-done" : ""}`} aria-hidden="true">
                        {l.locked ? "🔒" : isItemDone ? <Check /> : i + 1}
                      </span>
                      {i < lessons.length - 1 && <span className="lx-item__line" />}
                    </span>
                    <span className="lx-item__text">
                      <span className="lx-item__title">{l.title}</span>
                      {current && <span className="lx-item__sub">אתם כאן</span>}
                      {!current && isItemDone && <span className="lx-item__sub lx-item__sub--done">הושלם</span>}
                    </span>
                  </>
                );
                return (
                  <li key={l.slug}>
                    {l.locked ? (
                      <span className="lx-item is-locked" title={l.title}>
                        {body}
                      </span>
                    ) : (
                      <a
                        href={`/courses/${course.id}/${l.slug}`}
                        className={`lx-item${current ? " is-current" : ""}`}
                        aria-current={current ? "page" : undefined}
                        title={l.title}
                      >
                        {body}
                      </a>
                    )}
                  </li>
                );
              })}
            </ol>

            <a href={nextHref} className="lx-next">
              {next ? "המשך לשיעור הבא" : "חזרה לקטלוג הקורסים"}
            </a>
          </nav>
        </aside>

        <main className="lx-main">
          <nav className="lx-crumbs" aria-label="נתיב">
            <a href="/courses">קורסים</a>
            <span aria-hidden="true">›</span>
            <a href={`/courses/${course.id}`}>{course.title}</a>
            <span aria-hidden="true">›</span>
            <span className="lx-crumbs__cur">שיעור {idx + 1}</span>
          </nav>

          {hero ? (
            <section className="lx-hero">
              <span className="lx-hero__badge">{heroTop}</span>
              <h1 className="lx-hero__h1">
                {heroAccent ? (
                  <>
                    {heroTop}
                    <br />
                    <span className="lx-accent">{heroAccent}</span>
                  </>
                ) : (
                  <span className="lx-accent">{hero.title}</span>
                )}
              </h1>
              {hero.description && <p className="lx-hero__p">{hero.description}</p>}
              <a href="#lesson" className="lx-hero__cta">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M12 5v14" />
                  <path d="M6 13l6 6 6-6" />
                </svg>
                בואו נתחיל
              </a>
            </section>
          ) : (
            heading
          )}

          <section id="lesson" className="lx-content">
            {children}
          </section>

          <section className="lx-complete">
            <span className="lx-complete__q">סיימתם את השיעור?</span>
            <div className="lx-complete__actions">
              {prev && (
                <a href={`/courses/${course.id}/${prev.slug}`} className="lx-ghost">
                  השיעור הקודם
                </a>
              )}
              <button
                type="button"
                className={`lx-done${isDone ? " is-done" : ""}`}
                aria-pressed={isDone}
                onClick={() => setDone(course.id, currentSlug, !isDone)}
              >
                <Check size={20} stroke={2.6} />
                <span>{isDone ? "הושלם" : "סמן כהושלם"}</span>
              </button>
            </div>
          </section>
        </main>
      </div>
    </div>
  );
}
