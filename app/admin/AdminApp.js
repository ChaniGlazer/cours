"use client";

import "./admin.css";
import { Fragment,useActionState, useCallback, useEffect, useMemo, useRef, useState, startTransition } from "react";
import {
  updateSettingsAction,
  createCourseAction,
  updateCourseAction,
  createLessonAction,
  updateLessonAction,
  deleteLessonAction,
  createTestimonialAction,
  updateTestimonialAction,
  deleteTestimonialAction
} from "@/app/actions/admin";

const GROUPS = [
  { label: "סקירה", items: [{ key: "dashboard", label: "לוח בקרה", icon: "🏠" }] },
  {
    label: "תוכן הקורסים",
    items: [
      { key: "courses", label: "קורסים", icon: "📚", desc: "שם, תיאור, מחיר וגישה לכל קורס" },
      { key: "lessons", label: "שיעורים", icon: "🎬", desc: "תוכן וסדר השיעורים בכל קורס" }
    ]
  },
  {
    label: "לומדות ותנועה",
    items: [
      { key: "learners", label: "לומדות והתקדמות", icon: "👩‍🎓", desc: "מי נכנסה, מה למדה וכמה התקדמה" },
      { key: "visits", label: "כניסות לאתר", icon: "📈", desc: "כמה כניסות היו, מאיפה הגיעו ומי נכנס (גם מבקרים שלא נרשמו)" }
    ]
  },
  { label: "שיווק", items: [{ key: "testimonials", label: "המלצות", icon: "💬", desc: "הוכחה חברתית שמוצגת בעמודי הקורס" }] },
  { label: "האתר", items: [{ key: "settings", label: "הגדרות אתר", icon: "⚙️", desc: "מותג, פרופיל מדריך ואחריות" }] }
];
const SECTIONS = GROUPS.flatMap((g) => g.items);

/* ---------- Toasts ---------- */

function Toasts({ toasts, dismiss }) {
  return (
    <div className="adm-toasts" aria-live="polite" role="status">
      {toasts.map((t) => (
        <div key={t.id} className={`adm-toast adm-toast--${t.kind}`}>
          <span>{t.text}</span>
          <button type="button" onClick={() => dismiss(t.id)} aria-label="סגירה">
            ×
          </button>
        </div>
      ))}
    </div>
  );
}

/* ---------- Generic editor form ----------
   - שמירה בלי ריענון עמוד (המיקום והבחירה נשמרים)
   - זיהוי שינויים שלא נשמרו + קיצור Ctrl/⌘+S
   - הערכים שהוקלדו נשארים גם כשיש שגיאת ולידציה
*/

function labelFor(el) {
  const id = el.id;
  const lab = id ? el.form.querySelector(`label[for="${id}"]`) : el.closest("label");
  return (lab?.childNodes[0]?.textContent || lab?.textContent || el.name).trim();
}

function snapshot(form) {
  const out = {};
  for (const el of form.elements) {
    if (!el.name || el.type === "hidden" || el.type === "submit") continue;
    out[el.name] = el.type === "checkbox" ? el.checked : el.value;
  }
  return out;
}

function EditorForm({ action, onResult, onDirtyChange, saveLabel = "שמירה", impact, children, footerExtra }) {
  const [state, run, pending] = useActionState(action, null);
  const [changes, setChanges] = useState([]);
  const [resetKey, setResetKey] = useState(0);
  const dirty = changes.length > 0;
  const formRef = useRef(null);
  const baseline = useRef(null);
  const lastTs = useRef(null);

  const rebase = () => {
    baseline.current = snapshot(formRef.current);
    setChanges([]);
  };

  useEffect(() => {
    rebase();
  }, [resetKey]);

  useEffect(() => {
    onDirtyChange?.(dirty);
  }, [dirty, onDirtyChange]);

  useEffect(() => {
    if (!state || state.ts === lastTs.current) return;
    lastTs.current = state.ts;
    if (state.ok) rebase();
    onResult?.(state);
  }, [state, onResult]);

  useEffect(() => {
    const onKey = (e) => {
      if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "s") {
        e.preventDefault();
        formRef.current?.requestSubmit();
      }
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, []);

  useEffect(() => {
    if (!dirty) return;
    const warn = (e) => {
      e.preventDefault();
      e.returnValue = "";
    };
    window.addEventListener("beforeunload", warn);
    return () => window.removeEventListener("beforeunload", warn);
  }, [dirty]);

  // מחשב אילו שדות השתנו ביחס למצב השמור, כדי להציג בדיוק מה יישמר
  const detectChanges = () => {
    const form = formRef.current;
    if (!form || !baseline.current) return;
    const now = snapshot(form);
    const names = Object.keys(now).filter((n) => now[n] !== baseline.current[n]);
    setChanges(names.map((n) => labelFor(form.elements[n])));
  };

  const onSubmit = (e) => {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    startTransition(() => run(fd));
  };

  return (
    <form ref={formRef} onSubmit={onSubmit} onInput={detectChanges} onChange={detectChanges} className="adm-form">
      {impact && (
        <p className="adm-impact">
          <strong>💡 מה זה משנה: </strong>
          {impact}
        </p>
      )}
      <Fragment key={resetKey}>{children}</Fragment>
      {state && !state.ok && (
        <div className="alert alert-error" role="alert">
          {state.error}
        </div>
      )}
      <div className={`adm-savebar ${dirty ? "is-dirty" : ""}`}>
        <div className="adm-savebar__status">
          {pending ? (
            "שומר…"
          ) : dirty ? (
            <>
              <strong>● שינויים שלא נשמרו:</strong> {changes.join(", ")}
            </>
          ) : (
            "✓ הכול שמור"
          )}
        </div>
        <div className="adm-savebar__actions">
          {footerExtra}
          {dirty && (
            <button type="button" className="btn btn-ghost adm-btn-sm" onClick={() => setResetKey((k) => k + 1)}>
              ביטול שינויים
            </button>
          )}
          <button type="submit" className="btn btn-primary adm-btn-sm" disabled={pending || !dirty}>
            {saveLabel} <kbd>Ctrl+S</kbd>
          </button>
        </div>
      </div>
    </form>
  );
}

function Field({ label, hint, children, htmlFor }) {
  return (
    <div className="field">
      <label htmlFor={htmlFor}>{label}</label>
      {children}
      {hint && <small className="adm-hint">{hint}</small>}
    </div>
  );
}

function Section({ title, hint, children, open }) {
  return (
    <details className="adm-disclosure" open={open}>
      <summary>
        {title}
        {hint && <small>{hint}</small>}
      </summary>
      <div className="adm-disclosure__body">{children}</div>
    </details>
  );
}

function DeleteButton({ action, id, label, noun, onResult }) {
  const [state, run, pending] = useActionState(action, null);
  const [confirming, setConfirming] = useState(false);
  const lastTs = useRef(null);

  useEffect(() => {
    if (!state || state.ts === lastTs.current) return;
    lastTs.current = state.ts;
    onResult?.(state);
  }, [state, onResult]);

  if (!confirming) {
    return (
      <button type="button" className="muted-link" onClick={() => setConfirming(true)}>
        {label}
      </button>
    );
  }
  return (
    <span className="adm-confirm" role="alertdialog" aria-label={`אישור מחיקת ${noun}`}>
      למחוק את ה{noun} לצמיתות?
      <button
        type="button"
        className="btn adm-btn-sm adm-btn-danger"
        disabled={pending}
        onClick={() => {
          const fd = new FormData();
          fd.set("id", id);
          startTransition(() => run(fd));
        }}
        autoFocus
      >
        {pending ? "מוחק…" : "כן, מחיקה"}
      </button>
      <button type="button" className="btn btn-ghost adm-btn-sm" onClick={() => setConfirming(false)}>
        ביטול
      </button>
    </span>
  );
}

/* ---------- Badges ---------- */

const Badge = ({ kind = "neutral", children }) => <span className={`adm-badge adm-badge--${kind}`}>{children}</span>;

/* ---------- Master-detail shell ---------- */

function MasterDetail({ title, items, selectedId, onSelect, onNew, renderItem, searchText, newLabel, empty, children, groupBy }) {
  const [q, setQ] = useState("");
  const filtered = useMemo(() => {
    const needle = q.trim().toLowerCase();
    if (!needle) return items;
    return items.filter((it) => searchText(it).toLowerCase().includes(needle));
  }, [items, q, searchText]);

  const groups = useMemo(() => {
    if (!groupBy) return [{ label: null, items: filtered }];
    const map = new Map();
    for (const it of filtered) {
      const g = groupBy(it);
      if (!map.has(g)) map.set(g, []);
      map.get(g).push(it);
    }
    return [...map.entries()].map(([label, its]) => ({ label, items: its }));
  }, [filtered, groupBy]);

  return (
    <div className="adm-md">
      <aside className="adm-list" aria-label={title}>
        <div className="adm-list__head">
          <button type="button" className="btn btn-primary adm-btn-sm adm-btn-block" onClick={onNew}>
            + {newLabel}
          </button>
          {items.length > 5 && (
            <input
              type="search"
              className="adm-search"
              placeholder="חיפוש…"
              value={q}
              onChange={(e) => setQ(e.target.value)}
              aria-label="חיפוש ברשימה"
            />
          )}
        </div>
        <div className="adm-list__body" role="listbox" aria-label={title}>
          {items.length === 0 && <p className="adm-empty">{empty}</p>}
          {items.length > 0 && filtered.length === 0 && <p className="adm-empty">לא נמצאו תוצאות.</p>}
          {groups.map((g) => (
            <div key={g.label ?? "all"}>
              {g.label && <div className="adm-list__group">{g.label}</div>}
              {g.items.map((it) => (
                <button
                  type="button"
                  role="option"
                  aria-selected={selectedId === it.id}
                  key={it.id}
                  className={`adm-list__item ${selectedId === it.id ? "is-active" : ""}`}
                  onClick={() => onSelect(it.id)}
                >
                  {renderItem(it)}
                </button>
              ))}
            </div>
          ))}
        </div>
      </aside>
      <div className="adm-editor">{children}</div>
    </div>
  );
}

function EmptyEditor({ text }) {
  return (
    <div className="adm-editor__empty">
      <p>{text}</p>
    </div>
  );
}

/* ---------- Courses ---------- */

function CourseFields({ course, isNew }) {
  const [paid, setPaid] = useState(Boolean(course?.is_paid));
  return (
    <>
      <Field label="כותרת הקורס" htmlFor="c-title">
        <input id="c-title" name="title" defaultValue={course?.title || ""} required autoFocus={isNew} />
      </Field>
      <Field label="כותרת משנה" htmlFor="c-sub">
        <input id="c-sub" name="subtitle" defaultValue={course?.subtitle || ""} />
      </Field>
      <Field label="תיאור מלא" hint="שורה ריקה = פסקה חדשה" htmlFor="c-desc">
        <textarea id="c-desc" name="description" rows={5} defaultValue={course?.description || ""} />
      </Field>

      <fieldset className="adm-fieldset">
        <legend>מודל גישה</legend>
        <label className="adm-check">
          <input type="checkbox" name="is_paid" checked={paid} onChange={(e) => setPaid(e.target.checked)} />
          <span>
            קורס בתשלום
            <small>{isNew ? "ברירת מחדל: חינמי" : "ללא סימון הקורס חינמי לכל נרשם"}</small>
          </span>
        </label>
        <div hidden={!paid}>
          <Field label="מחיר (₪)" htmlFor="c-price">
            <input
              id="c-price"
              name="price_ils"
              type="number"
              min="0"
              step="1"
              inputMode="numeric"
              defaultValue={course?.price_ils || ""}
              style={{ maxWidth: 160 }}
            />
          </Field>
        </div>
        {!isNew && (
          <label className="adm-check">
            <input type="checkbox" name="coming_soon" defaultChecked={Boolean(course?.coming_soon)} />
            <span>
              בקרוב
              <small>מוצג עם תגית "בקרוב" ואי אפשר לרכוש עדיין</small>
            </span>
          </label>
        )}
      </fieldset>

      {!isNew && (
        <Section title="מתקדם" hint="סדר תצוגה">
          <Field label="סדר תצוגה בקטלוג" hint="מספר נמוך מופיע ראשון" htmlFor="c-pos">
            <input id="c-pos" name="position" type="number" defaultValue={course.position} style={{ maxWidth: 120 }} />
          </Field>
        </Section>
      )}
    </>
  );
}

function CoursesPanel({ courses, lessons, notify, selected, setSelected, guard }) {
  const sel = selected === "new" ? "new" : courses.find((c) => c.id === selected) || null;
  const lessonCount = (id) => lessons.filter((l) => l.course_id === id).length;

  const onResult = useCallback(
    (state) => {
      if (state.ok) {
        notify("ok", state.message);
        if (state.createdId) setSelected(state.createdId, true);
      } else notify("err", state.error);
    },
    [notify, setSelected]
  );

  return (
    <MasterDetail
      title="קורסים"
      items={courses}
      selectedId={selected}
      onSelect={(id) => guard(() => setSelected(id))}
      onNew={() => guard(() => setSelected("new"))}
      newLabel="קורס חדש"
      searchText={(c) => `${c.title} ${c.subtitle || ""}`}
      empty="עדיין אין קורסים. צרו את הראשון."
      renderItem={(c) => (
        <>
          <strong>{c.title}</strong>
          <span className="adm-list__meta">
            {c.coming_soon ? <Badge kind="warn">בקרוב</Badge> : c.is_paid ? <Badge kind="gold">₪{c.price_ils || 0}</Badge> : <Badge kind="ok">חינם</Badge>}
            <small>{lessonCount(c.id)} שיעורים</small>
          </span>
        </>
      )}
    >
      {!sel && <EmptyEditor text="בחרו קורס מהרשימה כדי לערוך, או צרו קורס חדש." />}
      {sel === "new" && (
        <>
          <h2 className="adm-editor__title">קורס חדש</h2>
          <EditorForm key="new" action={createCourseAction} onResult={onResult} onDirtyChange={guard.setDirty} saveLabel="יצירת קורס" impact="הקורס יתווסף לקטלוג. הוא נוצר חינמי ובלי שיעורים; הוסיפו שיעורים בלשונית שיעורים.">
            <CourseFields isNew />
          </EditorForm>
        </>
      )}
      {sel && sel !== "new" && (
        <>
          <div className="adm-editor__head">
            <h2 className="adm-editor__title">{sel.title}</h2>
            <a className="adm-link" href={`/courses/${sel.id}`} target="_blank" rel="noreferrer">
              צפייה באתר ↗
            </a>
          </div>
          <EditorForm key={sel.id} action={updateCourseAction} onResult={onResult} onDirtyChange={guard.setDirty} impact="הכרטיס של הקורס בקטלוג (/courses) ועמוד הקורס. שינוי מחיר או סימון תשלום משפיע מיד על רכישות חדשות.">
            <input type="hidden" name="id" value={sel.id} />
            <CourseFields course={sel} />
          </EditorForm>
        </>
      )}
    </MasterDetail>
  );
}

/* ---------- Lessons ---------- */

function LessonFields({ lesson, courses, isNew, defaultCourse }) {
  const [html, setHtml] = useState(lesson?.html_content || "");
  const [video, setVideo] = useState(lesson?.video_url || "");
  return (
    <>
      <Field label="קורס" htmlFor="l-course">
        <select id="l-course" name="course_id" defaultValue={lesson?.course_id || defaultCourse || ""} required className="adm-select">
          <option value="" disabled>
            בחרו קורס
          </option>
          {courses.map((c) => (
            <option key={c.id} value={c.id}>
              {c.title}
            </option>
          ))}
        </select>
      </Field>
      <Field label="כותרת השיעור" htmlFor="l-title">
        <input id="l-title" name="title" defaultValue={lesson?.title || ""} required autoFocus={isNew} />
      </Field>
      <Field label="תיאור קצר" htmlFor="l-desc">
        <input id="l-desc" name="description" defaultValue={lesson?.description || ""} />
      </Field>

      <fieldset className="adm-fieldset">
        <legend>תוכן השיעור</legend>
        <p className="adm-hint">אם יש תוכן HTML הוא זה שיוצג, וקישור הווידאו יתעלם.</p>
        <Field label="תוכן HTML" hint={`${html.length.toLocaleString("he-IL")} תווים`} htmlFor="l-html">
          <textarea
            id="l-html"
            name="html_content"
            rows={10}
            dir="ltr"
            className="adm-code"
            value={html}
            onChange={(e) => setHtml(e.target.value)}
            spellCheck={false}
          />
        </Field>
        <Field label="קישור לסרטון (YouTube / Vimeo / mp4)" htmlFor="l-video">
          <input
            id="l-video"
            name="video_url"
            dir="ltr"
            value={video}
            onChange={(e) => setVideo(e.target.value)}

          />
        </Field>
        {html.trim() && video.trim() && (
          <div className="alert alert-error" role="note">
            שימו לב: מוגדרים גם HTML וגם סרטון. יוצג רק ה-HTML.
          </div>
        )}
      </fieldset>

      <Section title="מתקדם" hint="כתובת וסדר">
        <Field label="כתובת (slug, אנגלית)" hint={isNew ? "ריק = ייווצר אוטומטית מהכותרת" : "קובע את הקישור לשיעור. שינוי שובר קישורים קיימים."} htmlFor="l-slug">
          <input id="l-slug" name="slug" dir="ltr" defaultValue={lesson?.slug || ""} />
        </Field>
        <Field label="סדר בתוך הקורס" htmlFor="l-pos">
          <input id="l-pos" name="position" type="number" defaultValue={lesson?.position ?? ""} style={{ maxWidth: 120 }} />
        </Field>
      </Section>
    </>
  );
}

function LessonsPanel({ courses, lessons, notify, selected, setSelected, guard }) {
  const [courseFilter, setCourseFilter] = useState("all");
  const courseTitle = useMemo(() => Object.fromEntries(courses.map((c) => [c.id, c.title])), [courses]);
  const visible = courseFilter === "all" ? lessons : lessons.filter((l) => l.course_id === courseFilter);
  const sel = selected === "new" ? "new" : lessons.find((l) => l.id === selected) || null;

  const onResult = useCallback(
    (state) => {
      if (state.ok) {
        notify("ok", state.message);
        if (state.createdId) setSelected(state.createdId, true);
        if (state.deleted) setSelected(null, true);
      } else notify("err", state.error);
    },
    [notify, setSelected]
  );

  return (
    <>
      <div className="adm-filter" role="group" aria-label="סינון לפי קורס">
        <button type="button" className={`adm-chip ${courseFilter === "all" ? "is-active" : ""}`} onClick={() => setCourseFilter("all")}>
          הכול ({lessons.length})
        </button>
        {courses.map((c) => (
          <button
            type="button"
            key={c.id}
            className={`adm-chip ${courseFilter === c.id ? "is-active" : ""}`}
            onClick={() => setCourseFilter(c.id)}
          >
            {c.title}
          </button>
        ))}
      </div>
      <MasterDetail
        title="שיעורים"
        items={visible}
        selectedId={selected}
        onSelect={(id) => guard(() => setSelected(id))}
        onNew={() => guard(() => setSelected("new"))}
        newLabel="שיעור חדש"
        searchText={(l) => `${l.title} ${l.description || ""}`}
        empty="אין שיעורים להצגה."
        groupBy={courseFilter === "all" ? (l) => courseTitle[l.course_id] || "ללא קורס" : null}
        renderItem={(l) => (
          <>
            <strong>
              <span className="adm-list__pos">{l.position}</span> {l.title}
            </strong>
            <span className="adm-list__meta">
              {l.html_content ? <Badge>HTML</Badge> : l.video_url ? <Badge>וידאו</Badge> : <Badge kind="warn">ללא תוכן</Badge>}
            </span>
          </>
        )}
      >
        {!sel && <EmptyEditor text="בחרו שיעור מהרשימה כדי לערוך, או צרו שיעור חדש." />}
        {sel === "new" && (
          <>
            <h2 className="adm-editor__title">שיעור חדש</h2>
            <EditorForm key="new" action={createLessonAction} onResult={onResult} onDirtyChange={guard.setDirty} saveLabel="הוספת שיעור" impact="השיעור יתווסף לקורס שנבחר ויוצג לנרשמים מיד.">
              <LessonFields isNew courses={courses} defaultCourse={courseFilter !== "all" ? courseFilter : ""} />
            </EditorForm>
          </>
        )}
        {sel && sel !== "new" && (
          <>
            <div className="adm-editor__head">
              <h2 className="adm-editor__title">{sel.title}</h2>
              <a className="adm-link" href={`/courses/${sel.course_id}/${sel.slug}`} target="_blank" rel="noreferrer">
                צפייה באתר ↗
              </a>
            </div>
            <EditorForm
              key={sel.id}
              action={updateLessonAction}
              impact="עמוד השיעור שהתלמידים רואים. מחיקה סופית ואי אפשר לשחזר."
              onResult={onResult}
              onDirtyChange={guard.setDirty}
              footerExtra={<DeleteButton action={deleteLessonAction} id={sel.id} label="מחיקת שיעור" noun="שיעור" onResult={onResult} />}
            >
              <input type="hidden" name="id" value={sel.id} />
              <LessonFields lesson={sel} courses={courses} />
            </EditorForm>
          </>
        )}
      </MasterDetail>
    </>
  );
}

/* ---------- Testimonials ---------- */

function TestimonialFields({ t, isNew, nextPosition, courseTitle }) {
  return (
    <>
      {t?.user_id && (
        <p className="adm-impact">
          נשלחה על ידי תלמיד/ה{courseTitle ? ` בקורס "${courseTitle}"` : ""}. ההמלצה מוצגת באתר רק במצב "מאושרת".
        </p>
      )}
      {!isNew && (
        <Field label="סטטוס" hint="מאושרת = מוצגת בעמוד הקורס. ממתינה / נדחתה = לא מוצגת." htmlFor="t-status">
          <select id="t-status" name="status" defaultValue={t?.status || "approved"} className="adm-select">
            <option value="approved">מאושרת (מוצגת באתר)</option>
            <option value="pending">ממתינה לאישור</option>
            <option value="rejected">נדחתה (לא מוצגת)</option>
          </select>
        </Field>
      )}
      <div className="adm-row2">
        <Field label="שם" htmlFor="t-name">
          <input id="t-name" name="name" defaultValue={t?.name || ""} required autoFocus={isNew} />
        </Field>
        <Field label="תפקיד / הקשר" htmlFor="t-role">
          <input id="t-role" name="role" defaultValue={t?.role || ""} />
        </Field>
      </div>
      <Field label="ציטוט ההמלצה" htmlFor="t-quote">
        <textarea id="t-quote" name="quote" rows={4} defaultValue={t?.quote || ""} required />
      </Field>
      <Field label="תוצאה מדידה (אופציונלי)" hint='המלצה עם תוצאה מדידה משכנעת יותר, למשל "חסכתי 5 שעות בשבוע"' htmlFor="t-result">
        <input id="t-result" name="result" defaultValue={t?.result || ""} />
      </Field>
      <Section title="מתקדם" hint="תמונה וסדר">
        <Field label="קישור לתמונה" htmlFor="t-photo">
          <input id="t-photo" name="photo_url" dir="ltr" defaultValue={t?.photo_url || ""} />
        </Field>
        <Field label="סדר תצוגה" htmlFor="t-pos">
          <input id="t-pos" name="position" type="number" defaultValue={t?.position ?? nextPosition} style={{ maxWidth: 120 }} />
        </Field>
      </Section>
    </>
  );
}

function TestimonialsPanel({ testimonials, courses, notify, selected, setSelected, guard }) {
  const sel = selected === "new" ? "new" : testimonials.find((t) => t.id === selected) || null;
  const rank = { pending: 0, approved: 1, rejected: 2 };
  const sortedTestimonials = useMemo(
    () => [...testimonials].sort((a, b) => (rank[a.status] ?? 1) - (rank[b.status] ?? 1)),
    [testimonials]
  );

  const onResult = useCallback(
    (state) => {
      if (state.ok) {
        notify("ok", state.message);
        if (state.createdId) setSelected(state.createdId, true);
        if (state.deleted) setSelected(null, true);
      } else notify("err", state.error);
    },
    [notify, setSelected]
  );

  return (
    <MasterDetail
      title="המלצות"
      items={sortedTestimonials}
      selectedId={selected}
      onSelect={(id) => guard(() => setSelected(id))}
      onNew={() => guard(() => setSelected("new"))}
      newLabel="המלצה חדשה"
      searchText={(t) => `${t.name} ${t.quote}`}
      empty="עדיין אין המלצות."
      renderItem={(t) => (
        <>
          <strong>{t.name}</strong>
          <span className="adm-list__meta">
            {t.status === "pending" && <Badge kind="warn">ממתינה</Badge>}
            {t.status === "rejected" && <Badge>נדחתה</Badge>}
            <small className="adm-clamp">{t.quote}</small>
          </span>
        </>
      )}
    >
      {!sel && <EmptyEditor text="בחרו המלצה מהרשימה כדי לערוך, או הוסיפו חדשה. המלצות מוצגות באתר רק כשיש לפחות אחת." />}
      {sel === "new" && (
        <>
          <h2 className="adm-editor__title">המלצה חדשה</h2>
          <EditorForm key="new" action={createTestimonialAction} onResult={onResult} onDirtyChange={guard.setDirty} saveLabel="הוספת המלצה" impact="ההמלצה תופיע בעמודי הקורסים בסדר התצוגה שנקבע.">
            <TestimonialFields isNew nextPosition={testimonials.length + 1} />
          </EditorForm>
        </>
      )}
      {sel && sel !== "new" && (
        <>
          <h2 className="adm-editor__title">{sel.name}</h2>
          <EditorForm
            key={sel.id}
            action={updateTestimonialAction}
            impact="מוצגת בעמודי הקורסים רק כשהסטטוס מאושרת. מחיקה סופית."
            onResult={onResult}
            onDirtyChange={guard.setDirty}
            footerExtra={<DeleteButton action={deleteTestimonialAction} id={sel.id} label="מחיקת המלצה" noun="המלצה" onResult={onResult} />}
          >
            <input type="hidden" name="id" value={sel.id} />
            <TestimonialFields t={sel} courseTitle={courses.find((c) => c.id === sel.course_id)?.title} />
          </EditorForm>
        </>
      )}
    </MasterDetail>
  );
}

/* ---------- Settings ---------- */

function SettingsPanel({ settings, notify, guard }) {
  const onResult = useCallback(
    (state) => (state.ok ? notify("ok", state.message) : notify("err", state.error)),
    [notify]
  );
  return (
    <div className="adm-single">
      <h2 className="adm-editor__title">הגדרות האתר</h2>
      <p className="text-soft adm-hint">מוצגות בכל האתר (כותרת, פוטר). שם, מחיר ותיאור של קורס עורכים בלשונית "קורסים".</p>
      <EditorForm action={updateSettingsAction} onResult={onResult} onDirtyChange={guard.setDirty} impact="שם האתר מופיע בכותרת הדפדפן ובתפריט העליון בכל העמודים. פרופיל המדריך והאחריות מוצגים בעמודי הקורסים.">
        <Field label="שם האתר (מותג)" htmlFor="s-title">
          <input id="s-title" name="site_title" defaultValue={settings.site_title || ""} required />
        </Field>
        <fieldset className="adm-fieldset">
          <legend>פרופיל המדריך/ה</legend>
          <p className="adm-hint">מוצג רק אם הוזן שם.</p>
          <Field label="שם" htmlFor="s-iname">
            <input id="s-iname" name="instructor_name" defaultValue={settings.instructor_name || ""} />
          </Field>
          <Field label="קישור לתמונת פרופיל" htmlFor="s-iphoto">
            <input id="s-iphoto" name="instructor_photo_url" dir="ltr" defaultValue={settings.instructor_photo_url || ""} />
          </Field>
          <Field label="ביוגרפיה קצרה" htmlFor="s-ibio">
            <textarea id="s-ibio" name="instructor_bio" rows={4} defaultValue={settings.instructor_bio || ""} />
          </Field>
        </fieldset>
        <fieldset className="adm-fieldset">
          <legend>הסרת סיכון</legend>
          <Field label="מדיניות אחריות / החזר" hint='למשל: "30 יום החזר כספי מלא, ללא שאלות"' htmlFor="s-guar">
            <input id="s-guar" name="guarantee_text" defaultValue={settings.guarantee_text || ""} />
          </Field>
        </fieldset>
      </EditorForm>
    </div>
  );
}

/* ---------- Learners ---------- */

const fmtDate = (iso) =>
  iso ? new Date(iso).toLocaleString("he-IL", { dateStyle: "short", timeStyle: "short", timeZone: "Asia/Jerusalem" }) : "-";

function daysAgo(iso) {
  if (!iso) return null;
  return Math.floor((Date.now() - new Date(iso).getTime()) / 86400000);
}

function ago(iso) {
  const d = daysAgo(iso);
  if (d === null) return "לא נכנסה";
  if (d <= 0) return "היום";
  if (d === 1) return "אתמול";
  return `לפני ${d} ימים`;
}

const lastSeenOf = (u) => u.last_active_at || u.last_login_at || null;

// לכל קורס שהלומדת נגעה בו: כמה שיעורים הושלמו / נפתחו מתוך הסך.
function courseSummaries(u, courses, totals) {
  return courses
    .map((c) => {
      const rows = u.progress.filter((p) => p.course_id === c.id);
      return { course: c, total: totals[c.id] || 0, done: rows.filter((p) => p.done).length, opened: rows.length };
    })
    .filter((x) => x.opened > 0);
}

function LearnerDetail({ u, courses, lessons, totals }) {
  const sums = courseSummaries(u, courses, totals);
  return (
    <div>
      <h2 className="adm-editor__title">{u.name}</h2>
      <p className="adm-section-desc">
        <bdi dir="ltr">{u.email}</bdi>
      </p>
      <div className="adm-stats">
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{u.login_count || 0}</span>
          <span className="adm-stat__label">התחברויות</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value adm-stat__value--sm">{ago(lastSeenOf(u))}</span>
          <span className="adm-stat__label">פעילות אחרונה: {fmtDate(lastSeenOf(u))}</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value adm-stat__value--sm">{fmtDate(u.created_at)}</span>
          <span className="adm-stat__label">נרשמה</span>
        </div>
      </div>
      {sums.length === 0 && <p className="adm-empty">עדיין לא נפתח אף שיעור (או שהיא לא ביקרה מאז שהמעקב הופעל).</p>}
      {sums.map(({ course, total, done, opened }) => {
        const list = lessons.filter((l) => l.course_id === course.id && l.slug);
        const bySlug = new Map(u.progress.filter((p) => p.course_id === course.id).map((p) => [p.lesson_slug, p]));
        return (
          <div key={course.id} className="adm-learner-course">
            <h3>
              {course.title}{" "}
              <Badge kind={done === total && total > 0 ? "ok" : "gold"}>
                {done}/{total} הושלמו · {opened} נפתחו
              </Badge>
            </h3>
            <div className="adm-bar" role="img" aria-label={`${done} מתוך ${total} שיעורים הושלמו`}>
              <span style={{ width: `${total ? Math.round((done / total) * 100) : 0}%` }} />
            </div>
            <table className="adm-table">
              <thead>
                <tr>
                  <th>שיעור</th>
                  <th>מצב</th>
                  <th>תרגילי חובה</th>
                  <th>ביקורים</th>
                  <th>ביקור אחרון</th>
                </tr>
              </thead>
              <tbody>
                {list.map((l) => {
                  const p = bySlug.get(l.slug);
                  return (
                    <tr key={l.id} className={p ? "" : "is-untouched"}>
                      <td>{l.title}</td>
                      <td>{!p ? "לא נפתח" : p.done ? <Badge kind="ok">{p.auto ? "הושלם אוטומטית" : "הושלם"}</Badge> : <Badge>נפתח</Badge>}</td>
                      <td>{p && p.ex_total ? `${p.ex_done}/${p.ex_total}` : "-"}</td>
                      <td>{p ? p.visits : "-"}</td>
                      <td>{p ? fmtDate(p.last_seen_at) : "-"}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        );
      })}
    </div>
  );
}

function LearnersPanel({ learnerData, courses, lessons, selected, setSelected }) {
  const { learners, totals } = learnerData;
  const [weekOnly, setWeekOnly] = useState(false);
  const active = learners.filter((u) => (daysAgo(lastSeenOf(u)) ?? 999) <= 7).length;
  const withProgress = learners.filter((u) => u.progress.some((p) => p.done)).length;
  const items = useMemo(
    () => (weekOnly ? learners.filter((u) => (daysAgo(lastSeenOf(u)) ?? 999) <= 7) : learners),
    [learners, weekOnly]
  );
  const current = learners.find((u) => u.id === selected);

  return (
    <div className="adm-learners">
      <div className="adm-stats">
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{learners.length}</span>
          <span className="adm-stat__label">לומדות רשומות</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{active}</span>
          <span className="adm-stat__label">פעילות ב-7 הימים האחרונים</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{withProgress}</span>
          <span className="adm-stat__label">סיימו לפחות שיעור אחד</span>
        </div>
      </div>
      <p className="adm-hint">
        המעקב מתחיל ברגע ההפעלה. התקדמות שנשמרה קודם בדפדפן של לומדת מועברת לכאן בביקור הבא שלה באתר.
      </p>
      <MasterDetail
        title="לומדות"
        items={items}
        selectedId={selected}
        onSelect={(id) => setSelected(id)}
        onNew={() => setWeekOnly((v) => !v)}
        newLabel={weekOnly ? "הצגת כל הלומדות" : "רק פעילות השבוע"}
        searchText={(u) => `${u.name} ${u.email}`}
        empty="עדיין אין לומדות רשומות."
        renderItem={(u) => {
          const sums = courseSummaries(u, courses, totals);
          return (
            <>
              <strong>{u.name}</strong>
              <span className="adm-list__meta">
                <bdi dir="ltr">{u.email}</bdi>
              </span>
              <span className="adm-list__meta">
                {ago(lastSeenOf(u))}
                {sums.map((s) => (
                  <Badge key={s.course.id} kind={s.done === s.total && s.total > 0 ? "ok" : "neutral"}>
                    {s.done}/{s.total}
                  </Badge>
                ))}
              </span>
            </>
          );
        }}
      >
        {current ? (
          <LearnerDetail u={current} courses={courses} lessons={lessons} totals={totals} />
        ) : (
          <EmptyEditor text="בחרי לומדת מהרשימה כדי לראות מתי נכנסה, מה למדה וכמה התקדמה." />
        )}
      </MasterDetail>
    </div>
  );
}

/* ---------- Visits ---------- */

const countryName = (() => {
  try {
    const dn = new Intl.DisplayNames(["he"], { type: "region" });
    return (code) => (code && /^[A-Z]{2}$/.test(code) ? dn.of(code) || code : "לא ידוע");
  } catch {
    return (code) => code || "לא ידוע";
  }
})();

const DEVICE_LABELS = { mobile: "נייד", tablet: "טאבלט", desktop: "מחשב" };

function VisitsTable({ title, rows, labelOf = (x) => x, total }) {
  return (
    <div className="adm-learner-course">
      <h4 className="adm-subhead">{title}</h4>
      {rows.length === 0 ? (
        <p className="adm-hint">אין נתונים עדיין.</p>
      ) : (
        <table className="adm-table">
          <thead>
            <tr>
              <th></th>
              <th>צפיות</th>
              <th>מבקרים</th>
              <th aria-hidden="true"></th>
            </tr>
          </thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.label}>
                <td>{labelOf(r.label)}</td>
                <td>{r.views}</td>
                <td>{r.visitors}</td>
                <td className="adm-table__bar">
                  <div className="adm-bar" role="img" aria-label={`${r.views} מתוך ${total} צפיות`}>
                    <span style={{ width: `${total ? Math.round((r.views / total) * 100) : 0}%` }} />
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

function VisitsPanel({ visitData }) {
  if (!visitData) {
    return (
      <div className="alert alert-error">
        טבלת הכניסות עדיין לא קיימת במסד הנתונים. צריך להריץ את המיגרציה <bdi dir="ltr">0010_site_visits.sql</bdi> (db:migrate:remote) ואז לרענן.
      </div>
    );
  }
  const { totals, daily, pages, countries, sources, devices, visitors } = visitData;
  const maxViews = Math.max(1, ...daily.map((d) => d.views));
  const registered = visitors.filter((v) => v.user_id).length;

  return (
    <div className="adm-learners">
      <div className="adm-stats">
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{totals.views1}</span>
          <span className="adm-stat__label">צפיות היום · {totals.visitors1} מבקרים</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{totals.views7}</span>
          <span className="adm-stat__label">צפיות ב-7 ימים · {totals.visitors7} מבקרים</span>
        </div>
        <div className="adm-stat adm-stat--static">
          <span className="adm-stat__value">{totals.views30}</span>
          <span className="adm-stat__label">צפיות ב-{visitData.days} ימים · {totals.visitors30} מבקרים</span>
        </div>
      </div>
      <p className="adm-hint">
        צפייה = פתיחת עמוד. מבקר = דפדפן אחד (מזהה אקראי בדפדפן, לא כתובת IP), ולכן מי שנכנס מכמה מכשירים נספר כמה פעמים. המעקב מתחיל מרגע ההפעלה, והנתונים נשמרים שנה.
      </p>

      <h4 className="adm-subhead">צפיות לפי יום ({visitData.days} ימים אחרונים)</h4>
      <div className="adm-chart" role="img" aria-label="צפיות לפי יום">
        {daily.map((d) => (
          <div key={d.day} className="adm-chart__col" title={`${d.day}: ${d.views} צפיות, ${d.visitors} מבקרים`}>
            <span className="adm-chart__bar" style={{ height: `${Math.round((d.views / maxViews) * 100)}%` }} />
          </div>
        ))}
      </div>

      <VisitsTable title="העמודים הנצפים ביותר" rows={pages} labelOf={(p) => <bdi dir="ltr">{p}</bdi>} total={totals.views30} />
      <VisitsTable title="מאיפה הגיעו" rows={sources} labelOf={(s) => <bdi dir="ltr">{s}</bdi>} total={totals.views30} />
      <VisitsTable title="מדינות" rows={countries} labelOf={countryName} total={totals.views30} />
      <VisitsTable title="מכשירים" rows={devices} labelOf={(d) => DEVICE_LABELS[d] || d} total={totals.views30} />

      <h4 className="adm-subhead">
        המבקרים האחרונים ({visitors.length}
        {registered ? `, מהם ${registered} מחוברות עם שם` : ""})
      </h4>
      {visitors.length === 0 ? (
        <p className="adm-hint">עדיין אין כניסות. הן יופיעו כאן אחרי שמישהו יפתח עמוד באתר.</p>
      ) : (
        <table className="adm-table">
          <thead>
            <tr>
              <th>מי</th>
              <th>מיקום</th>
              <th>מכשיר</th>
              <th>הגיע מ</th>
              <th>צפיות</th>
              <th>ימים</th>
              <th>עמוד אחרון</th>
              <th>כניסה אחרונה</th>
            </tr>
          </thead>
          <tbody>
            {visitors.map((v) => (
              <tr key={v.visitor_id}>
                <td>
                  {v.user_id ? (
                    <>
                      <strong>{v.user_name}</strong>
                      <br />
                      <bdi dir="ltr">{v.user_email}</bdi>
                    </>
                  ) : (
                    <>
                      מבקר אנונימי <bdi dir="ltr">#{v.visitor_id.slice(0, 6)}</bdi>
                    </>
                  )}
                </td>
                <td>{[v.city, countryName(v.country)].filter(Boolean).join(", ")}</td>
                <td>
                  {DEVICE_LABELS[v.device] || v.device} · {v.browser}
                </td>
                <td>
                  <bdi dir="ltr">{v.source}</bdi>
                </td>
                <td>{v.views}</td>
                <td>{v.days}</td>
                <td>
                  <bdi dir="ltr">{v.last_path}</bdi>
                </td>
                <td>{fmtDate(v.last_at)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

/* ---------- Dashboard ---------- */

function Stat({ value, label, onClick }) {
  return (
    <button type="button" className="adm-stat" onClick={onClick}>
      <span className="adm-stat__value">{value}</span>
      <span className="adm-stat__label">{label}</span>
    </button>
  );
}

// סיכום התקדמות הלומדות בלוח הבקרה: מספרים, הפעילות האחרונה, ולכל שיעור כמה פתחו וכמה סיימו.
function LearnersSummary({ learnerData, courses, lessons, go }) {
  const { learners, totals } = learnerData;
  const active = learners.filter((u) => (daysAgo(lastSeenOf(u)) ?? 999) <= 7);
  const finishedAny = learners.filter((u) => u.progress.some((p) => p.done)).length;
  const recent = learners.filter((u) => lastSeenOf(u)).slice(0, 5);
  const trackedCourses = courses.filter((c) => !c.coming_soon && (totals[c.id] || 0) > 0 && learners.some((u) => u.progress.some((p) => p.course_id === c.id)));

  return (
    <>
      <h3>לומדות והתקדמות</h3>
      <div className="adm-stats">
        <Stat value={learners.length} label="לומדות רשומות" onClick={() => go("learners")} />
        <Stat value={active.length} label="פעילות ב-7 הימים האחרונים" onClick={() => go("learners")} />
        <Stat value={finishedAny} label="סיימו לפחות שיעור אחד" onClick={() => go("learners")} />
      </div>

      {recent.length > 0 && (
        <>
          <h4 className="adm-subhead">פעילות אחרונה</h4>
          <ul className="adm-todos">
            {recent.map((u) => {
              const sums = courseSummaries(u, courses, totals);
              return (
                <li key={u.id}>
                  <span>
                    <strong>{u.name}</strong> · {ago(lastSeenOf(u))} ({fmtDate(lastSeenOf(u))}){" "}
                    {sums.length === 0 ? <Badge>עוד לא פתחה שיעור</Badge> : sums.map((x) => (
                      <Badge key={x.course.id} kind={x.done === x.total && x.total > 0 ? "ok" : "gold"}>
                        {x.done}/{x.total} שיעורים
                      </Badge>
                    ))}
                  </span>
                  <button type="button" className="btn btn-ghost adm-btn-sm" onClick={() => go("learners", u.id)}>
                    פירוט
                  </button>
                </li>
              );
            })}
          </ul>
        </>
      )}

      {trackedCourses.map((c) => (
        <div key={c.id} className="adm-learner-course">
          <h4 className="adm-subhead">{c.title}: כמה לומדות בכל שיעור</h4>
          <table className="adm-table">
            <thead>
              <tr>
                <th>שיעור</th>
                <th>פתחו</th>
                <th>סיימו</th>
                <th aria-hidden="true"></th>
              </tr>
            </thead>
            <tbody>
              {lessons.filter((l) => l.course_id === c.id && l.slug).map((l) => {
                const rows = learners.flatMap((u) => u.progress.filter((p) => p.course_id === c.id && p.lesson_slug === l.slug));
                const doneN = rows.filter((p) => p.done).length;
                return (
                  <tr key={l.id}>
                    <td>{l.title}</td>
                    <td>{rows.length}</td>
                    <td>{doneN}</td>
                    <td className="adm-table__bar">
                      <div className="adm-bar" role="img" aria-label={`${doneN} מתוך ${learners.length} סיימו`}>
                        <span style={{ width: `${learners.length ? Math.round((doneN / learners.length) * 100) : 0}%` }} />
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      ))}
      {trackedCourses.length === 0 && (
        <p className="adm-hint">עדיין לא נאסף מידע על שיעורים. הוא יופיע כאן אחרי שלומדת מחוברת תפתח שיעור.</p>
      )}
    </>
  );
}

function Dashboard({ courses, lessons, testimonials, settings, learnerData, visitData, go }) {
  const paid = courses.filter((c) => c.is_paid).length;
  const soon = courses.filter((c) => c.coming_soon).length;
  const lessonsOf = (id) => lessons.filter((l) => l.course_id === id).length;
  const todos = [];
  for (const c of courses) {
    if (!c.coming_soon && lessonsOf(c.id) === 0) todos.push({ text: `לקורס "${c.title}" אין עדיין שיעורים`, section: "lessons", cta: "הוספת שיעור", isNew: true });
    if (c.is_paid && !c.price_ils && !c.coming_soon) todos.push({ text: `הקורס "${c.title}" בתשלום אבל בלי מחיר`, section: "courses", cta: "הגדרת מחיר", id: c.id });
  }
  const empty = lessons.filter((l) => !l.html_content && !l.video_url);
  if (empty.length) todos.push({ text: `${empty.length} שיעורים בלי תוכן (בלי HTML ובלי סרטון)`, section: "lessons", cta: "לשיעורים" });
  const pendingT = testimonials.filter((t) => t.status === "pending");
  if (pendingT.length) todos.push({ text: `${pendingT.length} המלצות מתלמידים ממתינות לאישור`, section: "testimonials", cta: "לאישור", id: pendingT[0].id });
  if (testimonials.filter((t) => t.status === "approved").length === 0) todos.push({ text: "אין המלצות. הן מגדילות אמון בעמודי הקורס", section: "testimonials", cta: "הוספת המלצה", isNew: true });
  if (!settings.instructor_name) todos.push({ text: "לא הוגדר שם מדריך/ה, ולכן אזור הפרופיל לא מוצג", section: "settings", cta: "להגדרות" });

  return (
    <div className="adm-dash">
      <h2 className="adm-editor__title">מצב האתר</h2>
      <div className="adm-stats">
        <Stat value={courses.length} label={`קורסים (${paid} בתשלום, ${courses.length - paid} חינם${soon ? `, ${soon} בקרוב` : ""})`} onClick={() => go("courses")} />
        <Stat value={lessons.length} label="שיעורים" onClick={() => go("lessons")} />
        <Stat value={testimonials.length} label={`המלצות (${testimonials.filter((t) => t.status === "pending").length} ממתינות)`} onClick={() => go("testimonials")} />
      </div>

      {visitData && (
        <>
          <h3>כניסות לאתר</h3>
          <div className="adm-stats">
            <Stat value={visitData.totals.views1} label={`צפיות היום (${visitData.totals.visitors1} מבקרים)`} onClick={() => go("visits")} />
            <Stat value={visitData.totals.views7} label={`צפיות ב-7 ימים (${visitData.totals.visitors7} מבקרים)`} onClick={() => go("visits")} />
            <Stat value={visitData.totals.visitors30} label={`מבקרים ב-${visitData.days} ימים`} onClick={() => go("visits")} />
          </div>
        </>
      )}

      <LearnersSummary learnerData={learnerData} courses={courses} lessons={lessons} go={go} />

      <h3>דורש תשומת לב</h3>
      {todos.length === 0 ? (
        <div className="alert alert-success">הכול תקין, אין משימות פתוחות ✓</div>
      ) : (
        <ul className="adm-todos">
          {todos.map((t, i) => (
            <li key={i}>
              <span>⚠️ {t.text}</span>
              <button type="button" className="btn btn-ghost adm-btn-sm" onClick={() => go(t.section, t.id, t.isNew)}>
                {t.cta}
              </button>
            </li>
          ))}
        </ul>
      )}

      <h3>פעולות מהירות</h3>
      <div className="adm-quick">
        <button type="button" className="adm-quick__card" onClick={() => go("courses", null, true)}>
          <strong>+ קורס חדש</strong>
          <small>נוצר חינמי, אפשר להפוך לבתשלום</small>
        </button>
        <button type="button" className="adm-quick__card" onClick={() => go("lessons", null, true)}>
          <strong>+ שיעור חדש</strong>
          <small>HTML או קישור לסרטון</small>
        </button>
        <button type="button" className="adm-quick__card" onClick={() => go("testimonials", null, true)}>
          <strong>+ המלצה חדשה</strong>
          <small>ציטוט עם תוצאה מדידה</small>
        </button>
      </div>
    </div>
  );
}

/* ---------- Root ---------- */

export default function AdminApp({ settings, courses, lessons, testimonials, learnerData, visitData, logoutAction }) {
  const [section, setSection] = useState("dashboard");
  const [selection, setSelection] = useState({ courses: null, lessons: null, testimonials: null, learners: null });
  const [toasts, setToasts] = useState([]);
  const dirtyRef = useRef(false);

  // שחזור מיקום מה-hash (#lessons) כדי שרענון/חזרה יחזירו לאותה לשונית
  useEffect(() => {
    const h = window.location.hash.replace("#", "");
    if (SECTIONS.some((s) => s.key === h)) setSection(h);
  }, []);

  const notify = useCallback((kind, text) => {
    const id = Math.random().toString(36).slice(2);
    setToasts((t) => [...t, { id, kind, text }]);
    setTimeout(() => setToasts((t) => t.filter((x) => x.id !== id)), kind === "err" ? 7000 : 3500);
  }, []);
  const dismiss = (id) => setToasts((t) => t.filter((x) => x.id !== id));

  // מונע אובדן שינויים בטעות בעת מעבר בין פריטים/לשוניות
  const guard = useCallback((fn) => {
    if (dirtyRef.current && !window.confirm("יש שינויים שלא נשמרו. לעזוב ולאבד אותם?")) return;
    dirtyRef.current = false;
    fn();
  }, []);
  guard.setDirty = (d) => {
    dirtyRef.current = d;
  };

  const setSelectedFor = (key) => (id, force) => {
    if (force) dirtyRef.current = false;
    setSelection((s) => ({ ...s, [key]: id }));
  };

  const goSection = (key, id, forceNew) =>
    guard(() => {
      setSection(key);
      if (id || forceNew) setSelection((s) => ({ ...s, [key]: forceNew ? "new" : id }));
      window.history.replaceState(null, "", `#${key}`);
    });

  const counts = { courses: courses.length, lessons: lessons.length, testimonials: testimonials.length, learners: learnerData.learners.length, visits: visitData?.totals.views7 };
  const current = SECTIONS.find((s) => s.key === section);

  return (
    <div className="adm-shell">
      <header className="adm-top">
        <h1>ניהול האתר</h1>
        <div className="adm-top__actions">
          <a className="adm-link" href="/courses" target="_blank" rel="noreferrer">
            צפייה באתר ↗
          </a>
          <form action={logoutAction}>
            <button type="submit" className="btn btn-ghost adm-btn-sm">
              התנתקות
            </button>
          </form>
        </div>
      </header>

      <div className="adm-layout">
        <nav className="adm-nav" aria-label="אזורי ניהול">
          {GROUPS.map((g) => (
            <div className="adm-nav__group" key={g.label}>
              <div className="adm-nav__label">{g.label}</div>
              {g.items.map((it) => (
                <button
                  key={it.key}
                  type="button"
                  aria-current={section === it.key ? "page" : undefined}
                  className={`adm-nav__item ${section === it.key ? "is-active" : ""}`}
                  onClick={() => goSection(it.key)}
                >
                  <span aria-hidden="true">{it.icon}</span> {it.label}
                  {counts[it.key] !== undefined && <span className="adm-tab__count">{counts[it.key]}</span>}
                </button>
              ))}
            </div>
          ))}
        </nav>

        <div className="adm-content">
          {current?.desc && <p className="adm-section-desc">{current.desc}</p>}
      <main className="adm-main">
        {section === "dashboard" && (
          <Dashboard courses={courses} lessons={lessons} testimonials={testimonials} settings={settings} learnerData={learnerData} visitData={visitData} go={goSection} />
        )}
        {section === "courses" && (
          <CoursesPanel
            courses={courses}
            lessons={lessons}
            notify={notify}
            selected={selection.courses}
            setSelected={setSelectedFor("courses")}
            guard={guard}
          />
        )}
        {section === "lessons" && (
          <LessonsPanel
            courses={courses}
            lessons={lessons}
            notify={notify}
            selected={selection.lessons}
            setSelected={setSelectedFor("lessons")}
            guard={guard}
          />
        )}
        {section === "testimonials" && (
          <TestimonialsPanel
            testimonials={testimonials}
            courses={courses}
            notify={notify}
            selected={selection.testimonials}
            setSelected={setSelectedFor("testimonials")}
            guard={guard}
          />
        )}
        {section === "learners" && (
          <LearnersPanel
            learnerData={learnerData}
            courses={courses}
            lessons={lessons}
            selected={selection.learners}
            setSelected={setSelectedFor("learners")}
          />
        )}
        {section === "visits" && <VisitsPanel visitData={visitData} />}
        {section === "settings" && <SettingsPanel settings={settings} notify={notify} guard={guard} />}
      </main>
        </div>
      </div>

      <Toasts toasts={toasts} dismiss={dismiss} />
    </div>
  );
}
