// lib/lessonTheme.js
//
// שיעורי ה-HTML נכתבו כקבצים עצמאיים עם פלטות משלהם (סגול כהה לשיעורי הפייתון,
// כחול-סגול בהיר לשיעור ה-AI). כדי שכל הקורסים ייראו חלק מהאתר, מחליפים את הצבעים
// לפלטה של האתר בזמן ההצגה בלבד - התוכן שבמסד הנתונים (טקסטים, קוד, תרגילים) לא משתנה.
// שני שלבים: (1) החלפת צבעים קשיחים (themeLessonHtml), (2) דריסת משתני ה-CSS
// ותיקוני בלוקי קוד (LESSON_THEME_CSS, מוזרק לתוך ה-iframe).
//
// הטוקנים כאן מקבילים ל-:root ב-globals.css. מקור האמת לפלטה הוא globals.css; ה-iframe
// מבודד ולכן צריך עותק של הערכים.

const GOLD_TEXT = "#8a5f14"; // זהב כהה לטקסט על רקע בהיר (ניגודיות AA)
const GOLD_SOFT = "#f4e6c8";
const MOSS_SOFT = "#dbe6e0";
const RUST_SOFT = "#f3ddd5";

// שיעורי הפייתון: פלטה כהה (#12102A) -> פלטת האתר הבהירה.
const DARK_MAP = {
  "#12102a": "#eef1ec", "#1d1a3d": "#ffffff", "#262148": "#e3e8e0",
  "#f5f3ff": "#16242b", "#b4aedb": "#4b5a60", "#6f699e": "#5c6b71",
  "#b79cff": GOLD_TEXT, "#2d2552": GOLD_SOFT,
  "#ff7a59": GOLD_TEXT, "#4a2318": GOLD_SOFT,
  "#ffb84d": GOLD_TEXT, "#4a3a1c": GOLD_SOFT, "#ffd166": GOLD_TEXT, "#4a3a14": GOLD_SOFT,
  "#5ce1a6": "#3e5c50", "#163b30": MOSS_SOFT, "#7ce38b": "#3e5c50", "#173b22": MOSS_SOFT,
  "#4dd4f0": "#3e5c50", "#14394a": MOSS_SOFT,
  "#ff6b6b": "#b6492f", "#3e1d22": RUST_SOFT, "#ff5c8a": "#b6492f", "#4a1f30": RUST_SOFT,
  // טקסט כהה על רקע הדגשה -> לבן, כי הדגשות הפכו כהות
  "#170f33": "#ffffff", "#1a1204": "#ffffff", "#2b0f08": "#ffffff", "#04202a": "#ffffff",
  "#08210f": "#ffffff", "#d6ffe0": "#ffffff", "#ffc2d6": "#ffffff", "#2b0916": "#ffffff",
  // צללים/קווי תחתית של כפתורים
  "#3f9a50": "#2c443a", "#1f8aa3": "#2c443a", "#b5762c": "#6b480e", "#b24b2f": "#6b480e",
  "#3b3562": "#c9d1c6", "#55508a": "#b4beb0", "#0b0a1c": "#16242b",
  // צבעי syntax highlighting: בהירים, על רקע קוד כהה
  "#c792ea": "#e0b565", "#a8d48a": "#9ccfb2", "#f5c97b": "#e5b98e", "#7ec1f5": "#a8cdd9"
};

// שיעור ה-AI: פלטה בהירה כחולה-סגולה -> פלטת האתר.
const LIGHT_MAP = {
  "#6c7bff": "#3e5c50", "#8b6bff": "#2c443a", "#5b6cff": "#3e5c50", "#3f4fe0": "#3e5c50", "#5a3fd8": "#3e5c50",
  "#e8ebff": MOSS_SOFT, "#f0eeff": "#e3e8e0", "#f5f3ff": "#eef1ec", "#f3f0ff": "#eef1ec", "#fff3f0": "#f7efe0",
  "#25224f": "#16242b", "#5a577f": "#4b5a60", "#8b88ae": "#5c6b71",
  "#221f55": "#16242b", "#2d2a72": "#1f343d", "#ecebff": "#dfe7e3", "#b9b6e8": "#9fb0aa",
  "#ff7b6b": "#b9842f", "#ffa06b": "#d6a24c", "#ffe8e3": GOLD_SOFT, "#fff0ec": "#f7efe0",
  "#e0553f": GOLD_TEXT, "#d9482f": "#8c3720",
  "#1fb985": "#3e5c50", "#34d6a0": "#4d7566", "#0f8f63": "#3e5c50",
  "#ddf7ec": MOSS_SOFT, "#e6faf1": MOSS_SOFT, "#d3f4e5": "#c9dbd2",
  "#e5486a": "#b6492f", "#ffe4ea": RUST_SOFT, "#ffebef": RUST_SOFT, "#ffdde4": "#ecd0c5", "#c9304f": "#8c3720",
  "#d98a00": GOLD_TEXT, "#fff0d4": GOLD_SOFT,
  "#c4a7ff": "#e0b565", "#9be8b5": "#9ccfb2", "#8fb4ff": "#a8cdd9", "#ffd08a": "#e5b98e",
  "#8c89c4": "#7f948d", "#7ce8b5": "#9ccfb2"
};

const RGBA_MAP = [
  [/rgba\(\s*(?:91,\s*108,\s*255|139,\s*107,\s*255|255,\s*123,\s*107)\s*,/g, "rgba(214,162,76,"],
  [/rgba\(\s*(?:31,\s*185,\s*133|217,\s*138,\s*0)\s*,/g, "rgba(62,92,80,"],
  [/rgba\(\s*(?:229,\s*72,\s*106)\s*,/g, "rgba(182,73,47,"],
  [/rgba\(\s*(?:50,\s*40,\s*140|60,\s*50,\s*150|34,\s*31,\s*85|245,\s*243,\s*255)\s*,/g, "rgba(22,36,43,"],
  [/rgba\(\s*(?:183,\s*156,\s*255|92,\s*225,\s*166)\s*,/g, "rgba(214,162,76,"]
];

export function themeLessonHtml(html) {
  if (!html) return html;
  const dark = /--bg:\s*#12102a/i.test(html);
  const map = dark ? DARK_MAP : LIGHT_MAP;
  let out = html.replace(/#[0-9a-fA-F]{6}\b/g, (m) => map[m.toLowerCase()] || m);
  for (const [re, to] of RGBA_MAP) out = out.replace(re, to);
  return out;
}

// דריסת המשתנים של השיעור (html:root מנצח :root בלי תלות בסדר) + בלוקי קוד כהים עם
// טקסט בהיר, ופונטים של האתר. משתנים שלא קיימים בשיעור מסוים פשוט לא משפיעים.
export const LESSON_THEME_CSS = `
html:root{
  --bg:#eef1ec;--bg-panel:#fff;--bg-panel-2:#e3e8e0;
  --ink:#16242b;--ink-dim:#4b5a60;--ink-faint:#5c6b71;
  --line:rgba(22,36,43,.14);--line-strong:rgba(22,36,43,.28);
  --main:${GOLD_TEXT};--main-soft:${GOLD_SOFT};
  --for:${GOLD_TEXT};--for-soft:${GOLD_SOFT};--var:${GOLD_TEXT};--var-soft:${GOLD_SOFT};
  --star:${GOLD_TEXT};--star-soft:${GOLD_SOFT};--amber:${GOLD_TEXT};
  --while:#b6492f;--while-soft:${RUST_SOFT};--pink:#b6492f;--pink-soft:${RUST_SOFT};
  --short:#3e5c50;--short-soft:${MOSS_SOFT};--teal:#3e5c50;--teal-soft:${MOSS_SOFT};--inp:#3e5c50;--inp-soft:${MOSS_SOFT};
  --yes:#3e5c50;--yes-soft:${MOSS_SOFT};--success:#3e5c50;--success-soft:${MOSS_SOFT};
  --no:#b6492f;--no-soft:${RUST_SOFT};--danger:#b6492f;--danger-soft:${RUST_SOFT};
  --warn:${GOLD_TEXT};--warn-soft:${GOLD_SOFT};
  --cyan:#3e5c50;--cyan-2:#2c443a;--cyan-soft:${MOSS_SOFT};--violet:#b9842f;--violet-soft:${GOLD_SOFT};
  --code-bg:#16242b;--code-head:#1f343d;--code-ink:#dfe7e3;
  --shadow:0 18px 40px -20px rgba(22,36,43,.35);--shadow-sm:0 8px 24px -12px rgba(22,36,43,.25);
  --display:"Frank Ruhl Libre","Times New Roman",serif;--sans:"Heebo","Segoe UI",Arial,sans-serif;
}
body{background:var(--bg)!important;background-image:none!important;color:var(--ink)}
body::before{display:none!important}
.codeblock,.code-card pre,.payload{background:#16242b!important;color:#dfe7e3!important}
.codeblock .line,.codeblock .note{color:inherit}
.codeblock .note{color:#9fb0aa}
.codeblock .note.on{color:#9ccfb2}
.codeblock .line.hit{background:rgba(214,162,76,.18)!important;box-shadow:inset 3px 0 0 #d6a24c!important}
`;
