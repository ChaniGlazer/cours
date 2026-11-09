"use client";

// כרטיס הזמנה להרשמה למבקרים שאינם מחוברים. מוצג ב-layout רק כשאין משתמשת מחוברת.
// קצב: הצגה ראשונה דקה וחצי אחרי הכניסה הראשונה לאתר (לא מיד), אחר כך פעם ביום (הצגות 2 עד 4), ואז פעם בשלושה ימים.
// הדקה וחצי נספרות מטעינת האתר ולא מכל עמוד מחדש, כדי שמי שמדפדפת בין עמודים תקבל את ההזמנה בזמן. לא מציגים באמצע הקלדה או כתיבת קוד.
// מצב נשמר ב-localStorage (מקומי לדפדפן): { last: זמן ההצגה האחרונה, shown: כמה פעמים הוצג, off: ביקשו לא להציג }.
// אחרי 3 הצגות מופיע קישור "אל תציגו שוב", כדי שהכרטיס לא יציק למי שלא מעוניינת.
import { useCallback, useEffect, useRef, useState } from "react";
import { usePathname } from "next/navigation";
import "./signup-prompt.css";

const KEY = "signup-prompt-v1";
const DAY_MS = 24 * 60 * 60 * 1000;
const DELAY_MS = 90 * 1000;
const DAILY_SHOWS = 4; // עד ההצגה הרביעית כולל: פעם ביום. אחריה: פעם בשלושה ימים.
const RETRY_MS = 15 * 1000;
const OFFER_OPT_OUT_AFTER = 3;

// כמה זמן מחכים אחרי שכבר הוצג shown פעמים, עד ההצגה הבאה.
const gapAfter = (shown) => (shown < DAILY_SHOWS ? DAY_MS : 3 * DAY_MS);
const tooSoon = (st) => Boolean(st.last) && Date.now() - st.last < gapAfter(st.shown || 1);
// עמודים שבהם ההזמנה מיותרת או מפריעה: הרשמה/כניסה/איפוס, תשלום ופאנל הניהול.
const HIDDEN_ON = ["/register", "/login", "/forgot-password", "/reset-password", "/payment", "/admin"];

function readState() {
  try {
    const s = JSON.parse(localStorage.getItem(KEY) || "{}");
    return s && typeof s === "object" ? s : {};
  } catch {
    return {};
  }
}

function writeState(patch) {
  try {
    localStorage.setItem(KEY, JSON.stringify({ ...readState(), ...patch }));
  } catch {
    // אחסון חסום: ההזמנה פשוט תוצג שוב בביקור הבא.
  }
}

// האם המבקרת באמצע פעולה שלא כדאי להפריע לה (הקלדה בשדה, או עבודה בתוך שיעור/עורך קוד שבתוך iframe)?
function userIsBusy() {
  const el = document.activeElement;
  if (!el || el === document.body) return false;
  const tag = el.tagName;
  return tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT" || tag === "IFRAME" || el.isContentEditable;
}

const REASONS = [
  {
    title: "חונכת אישית בשיעורים",
    text: "שואלת שאלות שמובילות אתכם לפתרון, בלי לתת תשובה מוכנה.",
    icon: (
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path d="M21 12a8 8 0 0 1-11.6 7.1L4 20.5l1.4-4.6A8 8 0 1 1 21 12Z" />
        <path d="M9 11h6M9 14h3.5" />
      </svg>
    )
  },
  {
    title: "האזור האישי שלי",
    text: "כל הקורסים וההתקדמות שלכם במקום אחד, עם כפתור “המשך מהמקום שעצרת”.",
    icon: (
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path d="M4 12.5 12 5l8 7.5" />
        <path d="M6.5 11v8h11v-8" />
        <path d="M10 19v-4.5h4V19" />
      </svg>
    )
  },
  {
    title: "קורסים בתשלום נפתחים בחשבון",
    text: "רוכשים פעם אחת בתשלום מאובטח, והקורס מחכה לכם בחשבון.",
    icon: (
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <rect x="5" y="10.5" width="14" height="9.5" rx="2.5" />
        <path d="M8.5 10.5V8a3.5 3.5 0 0 1 7 0v2.5" />
      </svg>
    )
  }
];

export default function SignupPrompt() {
  const pathname = usePathname() || "/";
  const [open, setOpen] = useState(false);
  const [offerOptOut, setOfferOptOut] = useState(false);
  const cardRef = useRef(null);
  const startedAt = useRef(Date.now()); // ה-layout נשאר טעון בין עמודים, אז זו תחילת הביקור

  const hidden = HIDDEN_ON.some((p) => pathname === p || pathname.startsWith(`${p}/`));

  // תזמון ההצגה. מתבטל ומתחיל מחדש בכל מעבר עמוד, כך שהספירה של 20 השניות היא לעמוד הנוכחי.
  useEffect(() => {
    if (hidden) {
      setOpen(false);
      return;
    }
    const st = readState();
    if (st.off) return;
    if (tooSoon(st)) return;

    let timer;
    const attempt = () => {
      const fresh = readState();
      if (fresh.off || tooSoon(fresh)) return; // לשונית אחרת כבר הציגה
      if (document.visibilityState !== "visible" || userIsBusy()) {
        timer = setTimeout(attempt, RETRY_MS);
        return;
      }
      const shown = (fresh.shown || 0) + 1;
      writeState({ last: Date.now(), shown });
      setOfferOptOut(shown > OFFER_OPT_OUT_AFTER);
      setOpen(true);
    };
    timer = setTimeout(attempt, Math.max(0, startedAt.current + DELAY_MS - Date.now()));
    return () => clearTimeout(timer);
  }, [pathname, hidden]);

  const close = useCallback(() => setOpen(false), []);

  // Esc סוגר. הכרטיס לא חוסם את העמוד ולא לוכד מיקוד, אז זה רק קיצור נוח.
  useEffect(() => {
    if (!open) return;
    const onKey = (e) => {
      if (e.key === "Escape") close();
    };
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
  }, [open, close]);

  if (!open || hidden) return null;

  return (
    <aside className="sp" role="dialog" aria-labelledby="sp-title" aria-describedby="sp-lead" ref={cardRef}>
      <button type="button" className="sp__x" onClick={close} aria-label="סגירה">
        <svg viewBox="0 0 24 24" aria-hidden="true">
          <path d="M6 6l12 12M18 6 6 18" />
        </svg>
      </button>

      <span className="sp__badge">בחינם · בלי כרטיס אשראי</span>
      <h2 className="sp__title" id="sp-title">
        הצטרפו ללומדים באתר
      </h2>
      <p className="sp__lead" id="sp-lead">
        יצירת חשבון לוקחת פחות מדקה, ופותחת לכם:
      </p>

      <ul className="sp__list">
        {REASONS.map((r) => (
          <li key={r.title}>
            <span className="sp__icon">{r.icon}</span>
            <span>
              <strong>{r.title}</strong>
              <span className="sp__text">{r.text}</span>
            </span>
          </li>
        ))}
      </ul>

      <a className="btn btn-primary sp__cta" href={`/register?next=${encodeURIComponent(pathname)}`}>
        יוצרים חשבון חינם
      </a>
      <div className="sp__foot">
        <button type="button" className="sp__link" onClick={close}>
          לא עכשיו
        </button>
        <a className="sp__link" href={`/login?next=${encodeURIComponent(pathname)}`}>
          כבר יש לי חשבון
        </a>
        {offerOptOut && (
          <button
            type="button"
            className="sp__link"
            onClick={() => {
              writeState({ off: true });
              close();
            }}
          >
            אל תציגו שוב
          </button>
        )}
      </div>
    </aside>
  );
}
