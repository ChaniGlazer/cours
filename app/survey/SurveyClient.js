"use client";

// הסקר האינטראקטיבי: שאלה אחת בכל מסך, מעבר עדין, פס התקדמות, מסך תודה עם קונפטי ותוצאות חיות.
// נגישות: כל כרטיס בחירה הוא input אמיתי (radio/checkbox) ולכן עובד במקלדת ובקורא מסך; המעבר בין שאלות בלחיצה על "המשך"
// (לא אוטומטי), ומיקוד עובר לכותרת השאלה החדשה. prefers-reduced-motion מכובד ב-CSS וגם כאן (בלי קונפטי).
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { CONSENT_TEXT, MAX_OPEN_TEXT, QUESTIONS } from "@/lib/surveyConfig";
import SurveyResults from "./SurveyResults";
import "./survey.css";

const STORAGE_KEY = "survey-done-v1";
const EMAIL_RE = /^[^\s@]{1,64}@[^\s@.]+(\.[^\s@.]+)+$/;
const EMPTY = { stage: null, ai_usage: null, feelings: [], priorities: [], manual_first: null, junior_risk: null, open_text: "", email: "", consent: false };

function readDone() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}
function writeDone(answers) {
  try {
    // המייל לא נשמר בדפדפן: רק התשובות, כדי להדגיש "התשובה שלך" בתוצאות
    const { email, consent, ...rest } = answers;
    localStorage.setItem(STORAGE_KEY, JSON.stringify({ answers: rest, at: Date.now() }));
  } catch {
    // אחסון חסום: מדלגים, והשרת עדיין מגביל כפילויות לפי קצב
  }
}

const reducedMotion = () => typeof window !== "undefined" && window.matchMedia?.("(prefers-reduced-motion: reduce)").matches;

function Confetti() {
  const pieces = useMemo(() => {
    const colors = ["var(--gold)", "var(--moss)", "var(--mono-yellow)", "var(--ink-2)"];
    return Array.from({ length: 38 }, (_, i) => ({
      id: i,
      left: Math.random() * 100,
      delay: Math.random() * 0.9,
      dur: 3 + Math.random() * 2.2,
      size: 7 + Math.random() * 7,
      drift: (Math.random() - 0.5) * 140,
      rot: 180 + Math.random() * 540,
      color: colors[i % colors.length],
      round: i % 3 === 0
    }));
  }, []);
  return (
    <div className="sv-confetti" aria-hidden="true">
      {pieces.map((p) => (
        <i
          key={p.id}
          className={p.round ? "is-round" : undefined}
          style={{
            left: `${p.left}%`,
            width: p.size,
            height: p.round ? p.size : p.size * 1.6,
            background: p.color,
            animationDelay: `${p.delay}s`,
            animationDuration: `${p.dur}s`,
            "--drift": `${p.drift}px`,
            "--rot": `${p.rot}deg`
          }}
        />
      ))}
    </div>
  );
}

function Choice({ type, name, option, checked, disabled, onChange, wide }) {
  return (
    <label className={`sv-card${wide ? " sv-card--scale" : ""}${checked ? " is-checked" : ""}${disabled ? " is-disabled" : ""}`}>
      <input type={type} name={name} value={option.key} checked={checked} disabled={disabled} onChange={() => onChange(option.key)} />
      {option.emoji && <span className="sv-card__emoji" aria-hidden="true">{option.emoji}</span>}
      <span className="sv-card__text">
        <strong>{option.label}</strong>
        {option.hint && <small>{option.hint}</small>}
      </span>
      <span className="sv-card__mark" aria-hidden="true">
        <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12.5l4.5 4.5L19 7.5" /></svg>
      </span>
    </label>
  );
}

export default function SurveyClient({ contactEmail }) {
  const [phase, setPhase] = useState("intro"); // intro | q | done
  const [idx, setIdx] = useState(0);
  const [dir, setDir] = useState(1);
  const [answers, setAnswers] = useState(EMPTY);
  const [results, setResults] = useState(null);
  const [mine, setMine] = useState(null);
  const [returning, setReturning] = useState(false);
  const [confetti, setConfetti] = useState(false);
  const [error, setError] = useState("");
  const [fieldError, setFieldError] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [shareMsg, setShareMsg] = useState("");
  const startedAt = useRef(0);
  const honeypot = useRef(null);
  const headingRef = useRef(null);
  const firstRender = useRef(true);

  const q = QUESTIONS[idx];
  const total = QUESTIONS.length;

  const loadResults = useCallback(async () => {
    try {
      const res = await fetch("/api/survey", { cache: "no-store" });
      const data = await res.json();
      if (data.ok) setResults(data.results);
    } catch {
      // התוצאות לא קריטיות: המסך מציג הודעה אם אין
    }
  }, []);

  // כבר ענתה בעבר בדפדפן הזה: ישר לתוצאות.
  useEffect(() => {
    const done = readDone();
    if (done) {
      setMine(done.answers);
      setReturning(true);
      setPhase("done");
      loadResults();
    }
  }, [loadResults]);

  // מעבר שאלה: מיקוד לכותרת, כדי שקורא מסך ומקלדת ימשיכו משם. לא בטעינה הראשונה.
  useEffect(() => {
    if (firstRender.current) {
      firstRender.current = false;
      return;
    }
    headingRef.current?.focus({ preventScroll: true });
    window.scrollTo({ top: 0, behavior: reducedMotion() ? "auto" : "smooth" });
  }, [phase, idx]);

  const set = (patch) => {
    setError("");
    setFieldError("");
    setAnswers((a) => ({ ...a, ...patch }));
  };

  const toggle = (id, key, max) =>
    setAnswers((a) => {
      setError("");
      const cur = a[id];
      if (cur.includes(key)) return { ...a, [id]: cur.filter((k) => k !== key) };
      if (max && cur.length >= max) return a;
      return { ...a, [id]: [...cur, key] };
    });

  const start = () => {
    startedAt.current = Date.now();
    setDir(1);
    setPhase("q");
    setIdx(0);
  };

  const canContinue =
    q.kind === "single" || q.kind === "scale" ? answers[q.id] != null : q.kind === "multi" ? answers[q.id].length > 0 : true;

  const back = () => {
    setError("");
    setFieldError("");
    setDir(-1);
    if (idx === 0) setPhase("intro");
    else setIdx(idx - 1);
  };

  const submit = async () => {
    setSubmitting(true);
    setError("");
    try {
      const res = await fetch("/api/survey", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...answers, website: honeypot.current?.value || "", elapsed: Date.now() - startedAt.current })
      });
      const data = await res.json().catch(() => ({}));
      if (!res.ok || !data.ok) {
        setError(data.error || "משהו השתבש. נסי שוב בעוד רגע.");
        return;
      }
      writeDone(answers);
      setMine(answers);
      setResults(data.results);
      setDir(1);
      setPhase("done");
      if (!reducedMotion()) {
        setConfetti(true);
        setTimeout(() => setConfetti(false), 6500);
      }
    } catch {
      setError("אין חיבור לשרת. בדקי את החיבור ונסי שוב.");
    } finally {
      setSubmitting(false);
    }
  };

  const onSubmit = (e) => {
    e.preventDefault();
    if (submitting || !canContinue) return;
    if (q.kind === "contact") {
      const email = answers.email.trim();
      if (email && !EMAIL_RE.test(email)) return setFieldError("כתובת המייל לא נראית תקינה. אפשר גם להשאיר ריק.");
      if (answers.consent && !email) return setFieldError("כדי לקבל עדכונים צריך להזין כתובת מייל.");
      return submit();
    }
    setDir(1);
    setIdx(idx + 1);
  };

  const shareUrl = () => `${window.location.origin}/survey`;
  const share = async () => {
    setShareMsg("");
    const url = shareUrl();
    let ok = false;
    try {
      await navigator.clipboard.writeText(url);
      ok = true;
    } catch {
      // גיבוי לדפדפנים בלי הרשאת clipboard
      try {
        const ta = document.createElement("textarea");
        ta.value = url;
        ta.setAttribute("readonly", "");
        ta.style.position = "fixed";
        ta.style.opacity = "0";
        document.body.appendChild(ta);
        ta.select();
        ok = document.execCommand("copy");
        document.body.removeChild(ta);
      } catch {
        ok = false;
      }
    }
    setShareMsg(ok ? "הקישור הועתק ✓" : `אפשר להעתיק את הקישור: ${url}`);
  };

  const progress = phase === "q" ? ((idx + 1) / total) * 100 : phase === "done" ? 100 : 0;

  return (
    <div className="sv">
      {confetti && <Confetti />}
      <h1 className="sv-sr">סקר: איך היית לומדת פיתוח בעידן ה-AI</h1>

      {phase !== "intro" && (
        <div
          className="sv-progress"
          role="progressbar"
          aria-label="התקדמות בסקר"
          aria-valuemin={0}
          aria-valuemax={total}
          aria-valuenow={phase === "done" ? total : idx + 1}
        >
          <i style={{ width: `${progress}%` }} />
        </div>
      )}
      <p className="sv-sr" role="status" aria-live="polite">
        {phase === "q" ? `שאלה ${idx + 1} מתוך ${total}` : phase === "done" ? "הסקר נשלח, תודה" : ""}
      </p>

      <div className={`sv-step ${dir > 0 ? "sv-step--fwd" : "sv-step--back"}`} key={`${phase}-${idx}`}>
        {phase === "intro" && (
          <div className="sv-panel sv-intro">
            <span className="sv-pill">סקר קצר · כשתי דקות</span>
            <h2 className="sv-title sv-title--xl" tabIndex={-1} ref={headingRef}>
              אם היית מתחילה ללמוד פיתוח היום, איך היית עושה את זה?
            </h2>
            <p className="sv-lead">
              בעידן שבו ה-AI כותב קוד, כולנו מנסות להבין מה באמת שווה ללמוד. עני על שבע שאלות קצרות, וגלי מיד איך ענו האחרות.
            </p>
            <ul className="sv-bullets">
              <li><span aria-hidden="true">🔒</span> אנונימי לגמרי. מייל משאירים רק אם בא לך.</li>
              <li><span aria-hidden="true">📊</span> בסוף תראי תוצאות חיות מכל מי שענתה.</li>
            </ul>
            <button type="button" className="sv-btn sv-btn--primary" onClick={start}>
              בואי נתחיל
            </button>
            <a className="sv-link" href="/survey/results">רוצה רק להציץ בתוצאות? ←</a>
          </div>
        )}

        {phase === "q" && (
          <form className="sv-panel" onSubmit={onSubmit} noValidate>
            <p className="sv-count" aria-hidden="true">שאלה {idx + 1} מתוך {total}{q.optional ? " · לא חובה" : ""}</p>
            <div role={q.kind === "text" || q.kind === "contact" ? "group" : q.kind === "multi" ? "group" : "radiogroup"} aria-labelledby="sv-q-title">
              <h2 className="sv-title" id="sv-q-title" tabIndex={-1} ref={headingRef}>{q.title}</h2>
              {q.hint && <p className="sv-hint" id="sv-q-hint">{q.hint}</p>}

              {(q.kind === "single" || q.kind === "scale") && (
                <div className={q.kind === "scale" ? "sv-grid sv-grid--scale" : "sv-grid"}>
                  {q.options.map((o, i) => (
                    <Choice
                      key={o.key}
                      type="radio"
                      name={q.id}
                      wide={q.kind === "scale"}
                      option={q.kind === "scale" ? { ...o, emoji: q.emojis[i], hint: undefined } : o}
                      checked={answers[q.id] === o.key}
                      onChange={(key) => set({ [q.id]: key })}
                    />
                  ))}
                </div>
              )}

              {q.kind === "multi" && (
                <>
                  <div className="sv-grid">
                    {q.options.map((o) => {
                      const checked = answers[q.id].includes(o.key);
                      return (
                        <Choice
                          key={o.key}
                          type="checkbox"
                          name={q.id}
                          option={o}
                          checked={checked}
                          disabled={!checked && q.max && answers[q.id].length >= q.max}
                          onChange={(key) => toggle(q.id, key, q.max)}
                        />
                      );
                    })}
                  </div>
                  {q.max && (
                    <p className="sv-counter" aria-live="polite">נבחרו {answers[q.id].length} מתוך {q.max}</p>
                  )}
                </>
              )}

              {q.kind === "text" && (
                <div className="sv-field">
                  <label className="sv-sr" htmlFor="sv-open">התשובה שלך</label>
                  <textarea
                    id="sv-open"
                    rows={5}
                    maxLength={MAX_OPEN_TEXT}
                    value={answers.open_text}
                    placeholder="למשל: לשבת איתי על הקוד ולהסביר למה, לתת לי ביטחון, להגיד לי מתי אני טועה…"
                    onChange={(e) => set({ open_text: e.target.value })}
                  />
                  <span className="sv-counter">{answers.open_text.length}/{MAX_OPEN_TEXT}</span>
                </div>
              )}

              {q.kind === "contact" && (
                <div className="sv-field">
                  <label htmlFor="sv-email">כתובת מייל (לא חובה)</label>
                  <input
                    id="sv-email"
                    type="email"
                    inputMode="email"
                    autoComplete="email"
                    dir="ltr"
                    placeholder="name@example.com"
                    value={answers.email}
                    aria-invalid={fieldError ? "true" : undefined}
                    aria-describedby={fieldError ? "sv-field-error" : undefined}
                    onChange={(e) => set({ email: e.target.value })}
                  />
                  <label className="sv-consent">
                    <input type="checkbox" checked={answers.consent} onChange={(e) => set({ consent: e.target.checked })} />
                    <span>{CONSENT_TEXT}</span>
                  </label>
                  <p className="sv-fine">
                    אפשר להסיר את עצמי בכל רגע{contactEmail ? <>, בפנייה אלינו ב-<bdi dir="ltr">{contactEmail}</bdi></> : ""}. פרטים ב
                    <a href="/privacy#survey" target="_blank" rel="noopener">מדיניות הפרטיות</a>. בלי סימון התיבה לא נצרפת לרשימת הדיוור.
                  </p>
                  {/* honeypot: שדה שמוסתר ממשתמשות. בוטים ממלאים אותו, ואז הבקשה נזרקת בשקט */}
                  <div className="sv-hp" aria-hidden="true">
                    <label>
                      אל תמלאי את השדה הזה
                      <input type="text" name="website" tabIndex={-1} autoComplete="off" ref={honeypot} />
                    </label>
                  </div>
                </div>
              )}
            </div>

            {fieldError && <p className="sv-error" id="sv-field-error" role="alert">{fieldError}</p>}
            {error && <p className="sv-error" role="alert">{error}</p>}

            <div className="sv-actions">
              <button type="button" className="sv-btn sv-btn--ghost" onClick={back} disabled={submitting}>
                חזרה
              </button>
              <button type="submit" className="sv-btn sv-btn--primary" disabled={!canContinue || submitting}>
                {q.kind === "contact" ? (submitting ? "שולחת…" : "שליחה") : "המשך"}
              </button>
            </div>
          </form>
        )}

        {phase === "done" && (
          <div className="sv-panel sv-done">
            <div className="sv-done__head">
              <span className="sv-done__emoji" aria-hidden="true">{returning ? "👋" : "🎉"}</span>
              <h2 className="sv-title sv-title--xl" tabIndex={-1} ref={headingRef}>
                {returning ? "כבר ענית, תודה!" : "תודה, את אלופה!"}
              </h2>
              <p className="sv-lead">
                {returning ? "הנה איך ענו כל האחרות עד עכשיו." : "התשובות שלך נשמרו. ככה ענו האחרות:"}
                {results?.total === 1 ? " אישה אחת כבר ענתה." : results?.total > 1 ? <> <strong>{results.total}</strong> נשים כבר ענו.</> : null}
              </p>
            </div>

            {results ? (
              <SurveyResults results={results} mine={mine} />
            ) : (
              <p className="sv-hint">טוענת את התוצאות…</p>
            )}

            <div className="sv-share">
              <h3>מכירה עוד מישהי שתרצה לענות?</h3>
              <div className="sv-share__row">
                <button type="button" className="sv-btn sv-btn--primary" onClick={share}>
                  העתקת קישור לסקר
                </button>
              </div>
              <p className="sv-hint" role="status" aria-live="polite">{shareMsg}</p>
            </div>

            <a className="sv-link" href="/survey/results">לעמוד התוצאות המלא ←</a>
            <a className="sv-link" href="/courses">רוצה להתחיל ללמוד? לקורסים החינמיים ←</a>
          </div>
        )}
      </div>
    </div>
  );
}
