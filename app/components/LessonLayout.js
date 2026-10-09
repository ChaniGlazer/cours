"use client";

import { Fragment, useCallback, useEffect, useRef, useState } from "react";
import { ProgressBar } from "./ui";
import { countDone, lessonStatus, markSeen, setDone, useProgress } from "./progress";

// מעטפת דף השיעור: פס התקדמות דק, תפריט צד עם כל השיעורים (במובייל נפתח בלחיצה),
// פירורי לחם, והכפתורים התחתונים: קודם / סמן כהושלם / הבא.
// lessons: [{ slug, title, locked }]. prev/next: { slug, title } או null.
export default function LessonLayout({ course, lessons, currentSlug, prev, next, heading, theme, children }) {
  const progress = useProgress();
  const [open, setOpen] = useState(false);
  const slugs = lessons.map((l) => l.slug);
  const idx = slugs.indexOf(currentSlug);
  const done = countDone(progress, course.id, slugs);
  const isDone = lessonStatus(progress, course.id, currentSlug) === "done";
  const soft = theme === "python-soft";
  const ItemsWrap = soft ? "div" : Fragment;
  const total = slugs.length;
  const RING_C = 2 * Math.PI * 24; // היקף הטבעת (r = 24)
  const ringOffset = total > 0 ? RING_C * (1 - done / total) : RING_C;

  useEffect(() => {
    markSeen(course.id, currentSlug);
  }, [course.id, currentSlug]);

  // אזור הרשימה בסרגל הצד: דהייה בקצה רק כשיש עוד תוכן בכיוון הזה, וגלילה למרכז השיעור הנוכחי.
  const listRef = useRef(null);
  const trackRef = useRef(null);
  const fillRef = useRef(null);
  const updateFade = useCallback(() => {
    const el = listRef.current;
    if (!el) return;
    const scrollable = el.scrollHeight > el.clientHeight + 1;
    el.dataset.fadeTop = scrollable && el.scrollTop > 2 ? "1" : "0";
    el.dataset.fadeBottom = scrollable && el.scrollTop + el.clientHeight < el.scrollHeight - 2 ? "1" : "0";
  }, []);
  // קו ציר הזמן: הרקע מהעיגול הראשון ועד האחרון, והמילוי עד העיגול של השיעור הנוכחי (לפי מיקום העיגולים בפועל)
  const updateTrack = useCallback(() => {
    const list = listRef.current;
    const track = trackRef.current;
    const fill = fillRef.current;
    if (!list || !track || !fill) return;
    const dots = list.querySelectorAll(".side-item > i");
    if (!dots.length) return;
    const center = (d) => {
      const r = d.getBoundingClientRect();
      return r.top + r.height / 2;
    };
    const first = center(dots[0]);
    const curItem = list.querySelector(".is-current > i");
    const base = track.parentElement.getBoundingClientRect().top;
    track.style.top = `${first - base}px`;
    track.style.height = `${center(dots[dots.length - 1]) - first}px`;
    fill.style.top = `${first - base}px`;
    fill.style.height = `${curItem ? Math.max(0, center(curItem) - first) : 0}px`;
  }, []);
  useEffect(() => {
    const el = listRef.current;
    if (!el) return;
    const cur = el.querySelector(".is-current");
    if (cur && el.scrollHeight > el.clientHeight + 1) {
      const c = cur.getBoundingClientRect();
      const l = el.getBoundingClientRect();
      el.scrollTop += c.top - l.top - (el.clientHeight - c.height) / 2; // רק הרשימה, לא הדף
    }
    el.classList.toggle("no-scroll", el.scrollHeight <= el.clientHeight + 1);
    updateFade();
    updateTrack();
    const onResize = () => {
      el.classList.toggle("no-scroll", el.scrollHeight <= el.clientHeight + 1);
      updateFade();
      updateTrack();
    };
    window.addEventListener("resize", onResize);
    const ro = typeof ResizeObserver !== "undefined" ? new ResizeObserver(onResize) : null;
    if (ro) ro.observe(el);
    return () => {
      window.removeEventListener("resize", onResize);
      if (ro) ro.disconnect();
    };
  }, [currentSlug, updateFade, updateTrack]);

  return (
    <div className={`lesson-page${theme === "python-soft" ? " theme-python-soft" : ""}`}>
      {theme === "python-soft" && (
        <>
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
          <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;600;700;800&family=Assistant:wght@400;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap"
            precedence="default"
          />
          <link rel="stylesheet" href="/themes/python-soft.css" precedence="default" />
        </>
      )}
      <div className="lesson-topprogress">
        <ProgressBar value={done} max={slugs.length} label="התקדמות בקורס" thin />
      </div>

      <div className="lesson-layout">
        <button
          type="button"
          className="lesson-drawer-toggle"
          aria-expanded={open}
          aria-controls="lesson-side"
          onClick={() => setOpen((o) => !o)}
        >
          <span>
            שיעור {idx + 1} מתוך {slugs.length}: רשימת השיעורים
          </span>
          <span aria-hidden="true">{open ? "▴" : "▾"}</span>
        </button>

        <nav id="lesson-side" className={`lesson-side${open ? " is-open" : ""}`} aria-label="תוכן הקורס">
          <a href={`/courses/${course.id}`} className="lesson-side__back">
            → חזרה לעמוד הקורס
          </a>
          {soft ? (
            <>
              <h2>{course.title}</h2>
              <div className="lesson-side__head">
                <div
                  className="progress-ring"
                  role="img"
                  aria-label={`סיימתם ${done} מתוך ${total} שיעורים`}
                >
                  <svg viewBox="0 0 58 58" aria-hidden="true">
                    <defs>
                      <linearGradient id="psRing" x1="0" y1="0" x2="1" y2="1">
                        <stop offset="0%" stopColor="#6C7BFF" />
                        <stop offset="100%" stopColor="#34D6A0" />
                      </linearGradient>
                    </defs>
                    <circle className="ring-track" cx="29" cy="29" r="24" />
                    <circle
                      className="ring-fill"
                      cx="29"
                      cy="29"
                      r="24"
                      style={{ strokeDasharray: RING_C, strokeDashoffset: ringOffset }}
                    />
                  </svg>
                  <span className="ring-num" dir="ltr">
                    {done}/{total}
                  </span>
                </div>
                <div className="progress-text">
                  <b>{done === 0 ? "מתחילים!" : done >= total ? "סיימתם את הקורס!" : "ממשיכים יפה!"}</b>
                  <span>{done === 0 ? "עוד לא סיימתם שיעורים" : done === 1 ? "סיימתם שיעור אחד" : `סיימתם ${done} שיעורים`}</span>
                </div>
              </div>
            </>
          ) : (
            <h2>{course.title}</h2>
          )}
          <div className="lesson-side__list" ref={listRef} onScroll={updateFade}>
            <ItemsWrap {...(soft ? { className: "lesson-side__items" } : {})}>
            {soft && (
              <>
                <div className="lesson-side__track" ref={trackRef} aria-hidden="true" />
                <div className="lesson-side__track-fill" ref={fillRef} aria-hidden="true" />
              </>
            )}
            {lessons.map((l, i) => {
              const status = l.locked ? "locked" : lessonStatus(progress, course.id, l.slug);
              const cls = `side-item${l.slug === currentSlug ? " is-current" : ""}${status === "done" ? " is-done" : ""}${l.locked ? " is-locked" : ""}`;
              const mark = <i aria-hidden="true">{l.locked ? "🔒" : status === "done" ? "✓" : i + 1}</i>;
              const sub = l.slug === currentSlug ? "אתם כאן" : status === "done" ? "הושלם" : null;
              const body = soft ? (
                <span className="side-item__body">
                  <span className="side-item__t">{l.title}</span>
                  {sub && <span className="side-item__s">{sub}</span>}
                </span>
              ) : (
                <span className="side-item__t">{l.title}</span>
              );
              return l.locked ? (
                <span key={l.slug} className={cls} title={l.title}>
                  {mark}
                  {body}
                </span>
              ) : (
                <a
                  key={l.slug}
                  href={`/courses/${course.id}/${l.slug}`}
                  className={cls}
                  aria-current={l.slug === currentSlug ? "page" : undefined}
                  title={l.title}
                >
                  {mark}
                  {body}
                </a>
              );
            })}
            </ItemsWrap>
          </div>
          {soft && next && (
            <div className="lesson-side__foot">
              <a href={`/courses/${course.id}/${next.slug}`} className="btn btn-primary lesson-side__next">
                המשך לשיעור הבא
              </a>
            </div>
          )}
        </nav>

        <div className="lesson-main">
          <div className="crumbs">
            <a href="/courses">קורסים</a>
            <span aria-hidden="true">›</span>
            <a href={`/courses/${course.id}`}>{course.title}</a>
            <span aria-hidden="true">›</span>
            <span>שיעור {idx + 1}</span>
          </div>
          {heading}
          <div className="lesson-content">{children}</div>

          <div className="lesson-pager">
            {prev ? (
              <a href={`/courses/${course.id}/${prev.slug}`} className="btn btn-secondary">
                → השיעור הקודם
              </a>
            ) : (
              <span />
            )}
            <button
              type="button"
              className={`btn btn-secondary btn-done${isDone ? " is-done" : ""}`}
              aria-pressed={isDone}
              onClick={() => setDone(course.id, currentSlug, !isDone)}
            >
              {isDone ? "הושלם ✓" : "סמן כהושלם"}
            </button>
            {next ? (
              <a href={`/courses/${course.id}/${next.slug}`} className="btn btn-primary">
                השיעור הבא ←
              </a>
            ) : (
              <a href={`/courses/${course.id}`} className="btn btn-primary">
                סיימתם! חזרה לעמוד הקורס
              </a>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
