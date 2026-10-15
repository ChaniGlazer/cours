"use client";

import { Fragment, useCallback, useEffect, useRef, useState } from "react";
import "./tutor-widget.css";

// החונכת: כפתור צף ופאנל שיחה בעמודי השיעור. החונכת כותבת משפט או שניים, והלומדת עונה בעיקר בלחיצה על הצעות ("צ'יפים").
// השיחה נשמרת בזיכרון הרכיב בלבד, ומתאפסת במעבר שיעור (LessonLayout נותן key לפי השיעור).
// ההודעות נשלחות ל-POST /api/tutor. רמת הרמז ומספר הניסיון נקבעים בשרת, והרכיב רק מציג את ה-level שחזר.
// הקשר השיעור (topicKey וקוד) מגיע מה-iframe של השיעור דרך LessonLayout (ההודעה tutor-context, ראו LessonHtmlFrame.js).

const LOGIN_HREF = "/login";
const OPENING_TEXT = "היי! איפה נתקעת?";
const OPENING_CHIPS = ["רוצה רמז", "הקוד לא עובד", "לא הבנתי את התרגיל"];
const CHECK_CHIP = "בדקי את מה שכתבתי";
const MORE_HINT = "עוד רמז";
const GHOST_CHIPS = new Set([MORE_HINT, "לא יודעת"]);
const MAX_MESSAGE = 2000;
const MAX_CODE = 4000;
const MAX_HISTORY = 8;
const TOPIC_KEY = /^[a-z0-9_-]{1,40}$/;

let nextId = 1;
const newMessage = (role, text, code) => ({ id: nextId++, role, text, code });

// "```python\n...```" הופך לבלוק קוד (LTR), ו-`x` בתוך טקסט לקוד בשורה. הכול כצמתי טקסט של React, בלי HTML גולמי.
function MessageText({ text }) {
  const blocks = String(text).split(/```[a-zA-Z]*\n?/);
  return blocks.map((part, i) => {
    if (i % 2 === 1) {
      return (
        <pre className="tw-code" dir="ltr" key={i}>
          <code>{part.replace(/\n$/, "")}</code>
        </pre>
      );
    }
    const inline = part.split(/`([^`\n]+)`/);
    return (
      <Fragment key={i}>
        {inline.map((s, j) =>
          j % 2 === 1 ? (
            <code className="tw-inline-code" dir="ltr" key={j}>
              {s}
            </code>
          ) : (
            s
          )
        )}
      </Fragment>
    );
  });
}

function minutesText(retryAfter) {
  const n = Math.max(1, Math.ceil(Number(retryAfter) / 60) || 1);
  return n === 1 ? "דקה" : `${n} דקות`;
}

export default function TutorWidget({ courseId, lessonSlug, loggedIn, context }) {
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState(() => [newMessage("tutor", OPENING_TEXT)]);
  const [suggestions, setSuggestions] = useState(OPENING_CHIPS);
  const [levels, setLevels] = useState({});
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null); // { kind: "login" | "rate" | "server" | "generic", text, retry? }
  const [remaining, setRemaining] = useState(null);
  const [draft, setDraft] = useState("");

  const fabRef = useRef(null);
  const panelRef = useRef(null);
  const logRef = useRef(null);
  const inputRef = useRef(null);
  const lastRequest = useRef(null);
  const wasOpen = useRef(false);

  const topicKey = context?.topicKey && TOPIC_KEY.test(context.topicKey) ? context.topicKey : "general";
  const level = levels[topicKey] || 1;
  const code = typeof context?.code === "string" ? context.code.trim().slice(0, MAX_CODE) : "";
  const needsLogin = !loggedIn || error?.kind === "login";

  // פתיחה: פוקוס לצ'יפ הראשון (או לשדה הכתיבה). סגירה: הפוקוס חוזר לכפתור הצף.
  useEffect(() => {
    if (open) {
      const first = panelRef.current?.querySelector(".tw-chip, .tw-input");
      first?.focus();
    } else if (wasOpen.current) {
      fabRef.current?.focus();
    }
    wasOpen.current = open;
  }, [open]);

  // Esc סוגר את הפאנל (גם כשהפוקוס מחוץ לו).
  useEffect(() => {
    if (!open) return undefined;
    const onKey = (e) => {
      if (e.key === "Escape") setOpen(false);
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [open]);

  // גוללים לתחתית השיחה כשמגיעה הודעה, כשהטעינה משתנה או כשמוצגת שגיאה.
  useEffect(() => {
    const el = logRef.current;
    if (el) el.scrollTop = el.scrollHeight;
  }, [messages, loading, error, open]);

  const request = useCallback(
    async (payload) => {
      setLoading(true);
      setError(null);
      lastRequest.current = payload;
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), 35000);
      try {
        const res = await fetch("/api/tutor", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
          signal: controller.signal
        });
        if (res.status === 401) {
          setError({ kind: "login", text: "כדי לדבר עם החונכת צריך להתחבר." });
          return;
        }
        if (res.status === 429) {
          setError({ kind: "rate", text: `שלחת הרבה הודעות. אפשר לחזור לחונכת בעוד ${minutesText(res.headers.get("Retry-After"))}.` });
          return;
        }
        if (!res.ok) {
          // 5xx: אפשר לנסות שוב. 400/403: הבקשה עצמה לא מתאימה, ולכן בלי כפתור "נסי שוב".
          const retryable = res.status >= 500;
          setError({ kind: retryable ? "server" : "generic", text: retryable ? "החונכת לא זמינה כרגע." : "משהו השתבש. נסי לנסח את ההודעה מחדש.", retry: retryable });
          return;
        }
        const data = await res.json();
        if (typeof data?.reply !== "string" || !data.reply) throw new Error("bad response");
        const chips = Array.isArray(data.suggestions) ? data.suggestions.filter((s) => typeof s === "string" && s.trim()).slice(0, 4) : [];
        setMessages((m) => [...m, newMessage("tutor", data.reply)]);
        setSuggestions(chips);
        if (Number.isInteger(data.level)) setLevels((l) => ({ ...l, [payload.topicKey]: Math.min(Math.max(data.level, 1), 4) }));
        setRemaining(Number.isInteger(data.remaining) ? data.remaining : null);
      } catch {
        setError({ kind: "server", text: "החונכת לא זמינה כרגע.", retry: true });
      } finally {
        clearTimeout(timer);
        setLoading(false);
      }
    },
    []
  );

  const send = useCallback(
    (text, { attachCode = false } = {}) => {
      const message = String(text).trim().slice(0, MAX_MESSAGE);
      if (!message || loading) return;
      const attached = attachCode && code ? code : undefined;
      const history = messages.slice(-MAX_HISTORY).map((m) => ({ role: m.role === "tutor" ? "assistant" : "user", content: m.text.slice(0, MAX_MESSAGE) }));
      setMessages((m) => [...m, newMessage("user", message, attached)]);
      setDraft("");
      request({ courseId, lessonSlug, topicKey, message, history, ...(attached ? { code: attached } : {}) });
    },
    [code, courseId, lessonSlug, loading, messages, request, topicKey]
  );

  const retry = () => {
    if (lastRequest.current && !loading) request(lastRequest.current);
  };

  const close = () => setOpen(false);

  // ניווט במקלדת בין הצ'יפים: בעברית (RTL) חץ שמאלה מתקדם אחורה בשורה, וחץ ימינה חוזר.
  const onChipsKeyDown = (e) => {
    const chips = [...e.currentTarget.querySelectorAll(".tw-chip")];
    const i = chips.indexOf(document.activeElement);
    if (i === -1) return;
    let to = null;
    if (e.key === "ArrowLeft" || e.key === "ArrowDown") to = chips[(i + 1) % chips.length];
    else if (e.key === "ArrowRight" || e.key === "ArrowUp") to = chips[(i - 1 + chips.length) % chips.length];
    else if (e.key === "Home") to = chips[0];
    else if (e.key === "End") to = chips[chips.length - 1];
    if (to) {
      e.preventDefault();
      to.focus();
    }
  };

  // הצ'יפ הקבוע של בדיקת הקוד (רק כשיש קוד נוכחי), ובסוף "עוד רמז" שהמערכת מוסיפה כשהרמה קטנה מ-4.
  const chipList = [];
  if (code) chipList.push({ text: CHECK_CHIP, attachCode: true, accent: true });
  const isOpening = messages.length === 1;
  for (const s of suggestions) chipList.push({ text: s });
  if (!isOpening && level < 4 && !suggestions.includes(MORE_HINT)) chipList.push({ text: MORE_HINT });

  const levelLabel = level >= 4 ? "הסבר מפורט" : `רמז ${level} מתוך 3`;

  return (
    <>
      <button
        type="button"
        ref={fabRef}
        className="tw-fab"
        hidden={open}
        aria-haspopup="dialog"
        aria-expanded={open}
        aria-controls="tw-panel"
        onClick={() => setOpen(true)}
      >
        <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M21 12c0 4.4-4 8-9 8-1.2 0-2.4-.2-3.4-.6L3 21l1.7-4.5C3.6 15.2 3 13.7 3 12c0-4.4 4-8 9-8s9 3.6 9 8z" />
        </svg>
        <span>שאלי את החונכת</span>
      </button>

      {open && (
        <div id="tw-panel" ref={panelRef} className="tw-panel" role="dialog" aria-label="החונכת" aria-modal="false">
          <header className="tw-head">
            <span className="tw-avatar" aria-hidden="true">
              ח
            </span>
            <div className="tw-head__text">
              <div className="tw-title">החונכת</div>
              {!needsLogin && (
                <div className="tw-level" role="img" aria-label={levelLabel}>
                  <span className="tw-dots" aria-hidden="true">
                    {[1, 2, 3].map((n) => (
                      <i key={n} className={n <= Math.min(level, 3) ? "is-on" : ""} />
                    ))}
                  </span>
                  <span className="tw-level__label">{levelLabel}</span>
                </div>
              )}
            </div>
            <button type="button" className="tw-close" onClick={close} aria-label="סגירת החונכת">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" aria-hidden="true">
                <path d="M6 6l12 12M18 6L6 18" />
              </svg>
            </button>
          </header>

          <div ref={logRef} className="tw-log" role="log" aria-live="polite" aria-relevant="additions text">
            {needsLogin ? (
              <div className="tw-msg tw-msg--tutor">
                <p>כדי לדבר עם החונכת צריך להתחבר.</p>
                <a className="tw-link" href={LOGIN_HREF}>
                  התחברות
                </a>
              </div>
            ) : (
              <>
                {messages.map((m) => (
                  <div key={m.id} className={`tw-msg tw-msg--${m.role}`}>
                    <MessageText text={m.text} />
                    {m.code && (
                      <pre className="tw-code" dir="ltr">
                        <code>{m.code}</code>
                      </pre>
                    )}
                  </div>
                ))}
                {loading && (
                  <div className="tw-msg tw-msg--tutor tw-typing" role="status" aria-label="החונכת כותבת">
                    <span className="tw-blink" aria-hidden="true">
                      <i />
                      <i />
                      <i />
                    </span>
                  </div>
                )}
                {error && !needsLogin && (
                  <div className="tw-error" role="alert">
                    <span>{error.text}</span>
                    {error.retry && (
                      <button type="button" className="tw-retry" onClick={retry}>
                        נסי שוב
                      </button>
                    )}
                  </div>
                )}
              </>
            )}
          </div>

          {!needsLogin && (
            <>
              {!loading && chipList.length > 0 && (
                <div className="tw-chips" role="group" aria-label="הצעות לתשובה" onKeyDown={onChipsKeyDown}>
                  {chipList.map((c) => (
                    <button
                      type="button"
                      key={c.text}
                      className={`tw-chip${GHOST_CHIPS.has(c.text) ? " tw-chip--ghost" : ""}${c.accent ? " tw-chip--accent" : ""}`}
                      onClick={() => send(c.text, { attachCode: c.attachCode })}
                    >
                      {c.text}
                    </button>
                  ))}
                </div>
              )}
              {remaining !== null && remaining <= 5 && <p className="tw-note">נשארו {remaining} הודעות עד המגבלה הקרובה.</p>}
              <form
                className="tw-compose"
                onSubmit={(e) => {
                  e.preventDefault();
                  send(draft);
                }}
              >
                <input
                  ref={inputRef}
                  className="tw-input"
                  type="text"
                  value={draft}
                  maxLength={MAX_MESSAGE}
                  placeholder="או כתבי כאן…"
                  aria-label="הודעה לחונכת"
                  autoComplete="off"
                  onChange={(e) => setDraft(e.target.value)}
                />
                <button type="submit" className="tw-send" disabled={loading || !draft.trim()}>
                  שלחי
                </button>
              </form>
            </>
          )}
        </div>
      )}
    </>
  );
}
