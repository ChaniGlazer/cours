"use client";

// כרטיס הזמנה להרשמה למבקרים שאינם מחוברים. מוצג ב-layout רק כשאין משתמשת מחוברת.
// קצב: הצגה ראשונה דקה וחצי אחרי הכניסה הראשונה לאתר (לא מיד), אחר כך פעם ביום (הצגות 2 עד 4), ואז פעם בשלושה ימים.
// הדקה וחצי נספרות רק בזמן שהלשונית נראית, ומתחילת הביקור ולא מכל עמוד מחדש, כדי שמי שמדפדפת בין עמודים תקבל את ההזמנה בזמן. לא מציגים באמצע הקלדה או כתיבת קוד.
// מצב נשמר ב-localStorage (מקומי לדפדפן): { last: זמן ההצגה האחרונה, shown: כמה פעמים הוצג, off: ביקשו לא להציג }.
// אחרי 3 הצגות מופיע קישור "אל תציגו שוב", כדי שהכרטיס לא יציק למי שלא מעוניינת.
import { useCallback, useEffect, useRef, useState } from "react";
import { usePathname } from "next/navigation";
import "./signup-prompt.css";

const KEY = "signup-prompt-v1";
// סך שניות הצפייה בביקור הנוכחי (sessionStorage = לשונית אחת). הקישורים באתר טוענים עמוד מלא, אז בלי שמירה הספירה הייתה מתאפסת בכל מעבר עמוד.
const VISIBLE_KEY = "signup-visible-ms";

function readVisible() {
  try {
    return Number(sessionStorage.getItem(VISIBLE_KEY)) || 0;
  } catch {
    return 0;
  }
}
function writeVisible(ms) {
  try {
    sessionStorage.setItem(VISIBLE_KEY, String(ms));
  } catch {
    // לא קריטי: הספירה תהיה לעמוד הנוכחי בלבד
  }
}
const DAY_MS = 24 * 60 * 60 * 1000;
const DELAY_MS = 90 * 1000;
const DAILY_SHOWS = 4; // עד ההצגה הרביעית כולל: פעם ביום. אחריה: פעם בשלושה ימים.
const PAGE_MIN_MS = 8 * 1000; // לפחות כמה שניות בעמוד הנוכחי לפני שמציגים
const OFFER_OPT_OUT_AFTER = 3;

// כמה זמן מחכים אחרי שכבר הוצג shown פעמים, עד ההצגה הבאה.
const gapAfter = (shown) => (shown < DAILY_SHOWS ? DAY_MS : 3 * DAY_MS);
const tooSoon = (st) => Boolean(st.last) && Date.now() - st.last < gapAfter(st.shown || 1);
// עמודים שבהם ההזמנה מיותרת או מפריעה: הרשמה/כניסה/איפוס, תשלום ופאנל הניהול.
const HIDDEN_ON = ["/register", "/login", "/forgot-password", "/reset-password", "/payment", "/admin", "/survey"];

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

// האם המבקרת באמצע הקלדה בשדה בעמוד? (פוקוס בתוך iframe של שיעור לא נחשב: אחרי כל לחיצה בשיעור הפוקוס שם, והכרטיס לא היה מופיע לעולם.
// הכרטיס לא גונב מיקוד, כך שהקלדה בתוך השיעור ממשיכה כרגיל.)
function userIsBusy() {
  const el = document.activeElement;
  if (!el || el === document.body) return false;
  const tag = el.tagName;
  return tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT" || el.isContentEditable;
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
  }
];

export default function SignupPrompt() {
  const pathname = usePathname() || "/";
  const [open, setOpen] = useState(false);
  const [offerOptOut, setOfferOptOut] = useState(false);
  const cardRef = useRef(null);
  const visibleMs = useRef(0); // סך הזמן הנראה בביקור (נקרא מ-sessionStorage בהתחלה)
  const pageMs = useRef(0);

  const hidden = HIDDEN_ON.some((p) => pathname === p || pathname.startsWith(`${p}/`));

  // תזמון ההצגה. מתבטל ומתחיל מחדש בכל מעבר עמוד, כך שהספירה של 20 השניות היא לעמוד הנוכחי.
  useEffect(() => {
    if (hidden) {
      setOpen(false);
      return;
    }
    // לבדיקה: הוספת ?signup-prompt=reset לכתובת מאפסת את הזיכרון, והכרטיס מופיע שוב אחרי הדקה וחצי.
    try {
      if (new URLSearchParams(window.location.search).get("signup-prompt") === "reset") localStorage.removeItem(KEY);
    } catch {
      // לא קריטי
    }
    const st = readState();
    if (st.off) return;
    if (tooSoon(st)) return;

    // סופרים שניות שבהן הלשונית פתוחה ונראית (לא ברקע), מתחילת הביקור. מציגים כשצבר 90 שניות, וגם רק אחרי כמה שניות בעמוד הנוכחי,
    // כדי שהכרטיס לא יקפוץ ברגע שחוזרים ללשונית או עוברים עמוד.
    pageMs.current = 0;
    visibleMs.current = Math.max(visibleMs.current, readVisible());
    const tick = setInterval(() => {
      if (document.visibilityState !== "visible") return;
      visibleMs.current += 1000;
      pageMs.current += 1000;
      writeVisible(visibleMs.current);
      if (visibleMs.current < DELAY_MS || pageMs.current < PAGE_MIN_MS) return;
      const fresh = readState();
      if (fresh.off || tooSoon(fresh)) {
        clearInterval(tick); // לשונית אחרת כבר הציגה
        return;
      }
      if (userIsBusy()) return; // מנסים שוב בשנייה הבאה
      clearInterval(tick);
      const shown = (fresh.shown || 0) + 1;
      writeState({ last: Date.now(), shown });
      setOfferOptOut(shown > OFFER_OPT_OUT_AFTER);
      setOpen(true);
    }, 1000);
    return () => clearInterval(tick);
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
