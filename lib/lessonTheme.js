// lib/lessonTheme.js
//
// שיעורי ה-HTML נכתבו כקבצים עצמאיים, בשלוש פלטות שונות: סגול כהה (רוב שיעורי הפייתון), כחול-סגול בהיר
// (שיעור ה-AI ושיעור הפונקציות) ופלטה בהירה ישנה של האתר. כדי שכל השיעורים בכל הקורסים ייראו אותו דבר,
// בזמן ההצגה בלבד מחליפים את הצבעים לפלטה הכהה של האתר (design-reference/lesson-page.html).
// התוכן שבמסד הנתונים (טקסטים, קוד, תרגילים, לוגיקה) לא משתנה.
// שלושה שלבים: (1) החלפת צבעים קשיחים לפי משפחת הפלטה (themeLessonHtml), (2) החלפת גופני הכותרות,
// (3) דריסת משתני ה-CSS ותיקוני בלוקי קוד (lessonThemeCss, מוזרק לתוך ה-iframe).
//
// הערכים כאן מקבילים ל-:root ב-globals.css; ה-iframe מבודד ולכן צריך עותק שלהם.

const BG = "#14121f";
const SURFACE = "#1d1a2d";
const SURFACE2 = "#26223b";
const LINE = "#3a3558";
const TEXT = "#f4f1fa";
const MUTED = "#bdb7d3";
const FAINT = "#9e97ba";
const PINK = "#ff7f96";
const MINT = "#6fe0a0";
const YELLOW = "#ffd27a";
const BLUE = "#8fb8ff";
// גוונים רכים (מבטא ב-16% על משטח)
const PINK_SOFT = "#412a3e";
const MINT_SOFT = "#2a3a3f";
const YELLOW_SOFT = "#413739";
const BLUE_SOFT = "#2f334f";

// משפחה 1: סגול כהה (--bg: #12102A)
const DARK_MAP = {
  "#12102a": BG, "#1d1a3d": SURFACE, "#262148": SURFACE2, "#f5f3ff": TEXT, "#b4aedb": MUTED, "#6f699e": FAINT,
  "#7ce38b": MINT, "#5ce1a6": MINT, "#a8d48a": MINT,
  "#ff7a59": PINK, "#b79cff": PINK, "#c792ea": PINK, "#ff5c8a": PINK, "#ff6b6b": PINK,
  "#ffb84d": YELLOW, "#ffd166": YELLOW, "#f5c97b": YELLOW,
  "#4dd4f0": BLUE, "#7ec1f5": BLUE,
  "#173b22": MINT_SOFT, "#163b30": MINT_SOFT,
  "#4a3a1c": YELLOW_SOFT, "#4a3a14": YELLOW_SOFT,
  "#14394a": BLUE_SOFT,
  "#4a2318": PINK_SOFT, "#2d2552": PINK_SOFT, "#4a1f30": PINK_SOFT, "#3e1d22": PINK_SOFT,
  // טקסט כהה על רקע הדגשה
  "#170f33": BG, "#1a1204": BG, "#2b0f08": BG, "#04202a": BG, "#08210f": BG, "#2b0916": BG,
  "#d6ffe0": MINT, "#ffc2d6": PINK,
  // צללים וקווי תחתית של כפתורים
  "#3f9a50": "#3fa46f", "#1f8aa3": "#5f86c9", "#b5762c": "#c99a3f", "#b24b2f": "#c85a72",
  "#3b3562": LINE, "#55508a": "#4d4775", "#0b0a1c": "#0e0c17"
};
const DARK_RGBA = [
  [/rgba\(\s*245,\s*243,\s*255\s*,/g, "rgba(244,241,250,"],
  [/rgba\(\s*(?:255,\s*184,\s*77)\s*,/g, "rgba(255,210,122,"],
  [/rgba\(\s*(?:255,\s*92,\s*138|255,\s*122,\s*89|183,\s*156,\s*255)\s*,/g, "rgba(255,127,150,"],
  [/rgba\(\s*(?:77,\s*212,\s*240)\s*,/g, "rgba(143,184,255,"],
  [/rgba\(\s*(?:124,\s*227,\s*139|92,\s*225,\s*166)\s*,/g, "rgba(111,224,160,"]
];

// משפחה 2: כחול-סגול בהיר (--bg: #F5F3FF)
const LIGHT_MAP = {
  "#25224f": TEXT, "#5a577f": MUTED, "#8b88ae": FAINT, "#6e6ab5": FAINT,
  "#5b6cff": PINK, "#6c7bff": PINK, "#3f4fe0": PINK, "#4453e0": PINK, "#5a3fd8": PINK, "#8b6bff": PINK, "#c4a7ff": PINK,
  "#8fb4ff": BLUE,
  "#1fb985": MINT, "#34d6a0": MINT, "#0f8f63": MINT, "#7ce8b5": MINT, "#9be8b5": MINT,
  "#ff7b6b": YELLOW, "#ffa06b": YELLOW, "#e0553f": YELLOW, "#d9482f": YELLOW, "#ff9a85": YELLOW,
  "#ffd08a": YELLOW, "#d98a00": YELLOW, "#b87400": YELLOW, "#ffb547": YELLOW,
  "#ff9fb2": PINK, "#e5486a": PINK, "#c9304f": PINK,
  "#221f55": BG, "#16143e": BG, "#2d2a72": SURFACE2, "#ecebff": TEXT, "#b9b6e8": MUTED, "#8c89c4": FAINT,
  "#f5f3ff": BG, "#f0eeff": SURFACE2, "#f3f0ff": SURFACE2, "#ece9ff": LINE, "#ffffff": SURFACE,
  "#e8ebff": PINK_SOFT, "#ffe4ea": PINK_SOFT, "#ffebef": PINK_SOFT, "#ffdde4": PINK_SOFT,
  "#ddf7ec": MINT_SOFT, "#e6faf1": MINT_SOFT, "#d3f4e5": MINT_SOFT,
  "#ffe8e3": YELLOW_SOFT, "#fff0ec": YELLOW_SOFT, "#fff3e8": YELLOW_SOFT, "#fff3f0": YELLOW_SOFT, "#fff0d4": YELLOW_SOFT
};
const LIGHT_RGBA = [
  [/rgba\(\s*(?:91,\s*108,\s*255|139,\s*107,\s*255|229,\s*72,\s*106)\s*,/g, "rgba(255,127,150,"],
  [/rgba\(\s*(?:255,\s*123,\s*107|217,\s*138,\s*0|255,\s*181,\s*71)\s*,/g, "rgba(255,210,122,"],
  [/rgba\(\s*31,\s*185,\s*133\s*,/g, "rgba(111,224,160,"],
  [/rgba\(\s*(?:50,\s*40,\s*140|60,\s*50,\s*150|34,\s*31,\s*85)\s*,/g, "rgba(0,0,0,"],
  // לבן שקוף-למחצה (שכבות מעל רקע בהיר) -> משטח כהה; שכבות קלות מעל הדגשה נשארות
  [/rgba\(\s*255,\s*255,\s*255\s*,\s*(0?\.(?:[5-9]\d*)|1)\s*\)/g, "rgba(29,26,45,$1)"]
];

// משפחה 3: פלטת האתר הבהירה הישנה (--bg: #eef1ec). רוב הצבעים בה מוגדרים במשתנים ונדרסים ב-lessonThemeCss.
const SITE_MAP = {
  "#eef1ec": BG, "#ffffff": SURFACE, "#e3e8e0": SURFACE2, "#dbe6e0": MINT_SOFT, "#f3ddd5": PINK_SOFT, "#f4e6c8": YELLOW_SOFT,
  "#4b5a60": MUTED, "#5c6b71": FAINT, "#d6a24c": PINK, "#8a5f14": PINK, "#3e5c50": MINT, "#b6492f": PINK,
  "#dfe7e3": TEXT, "#9fb0aa": FAINT, "#8fd0b0": MINT, "#a8cdd9": BLUE, "#f0c77a": YELLOW, "#e8896b": PINK, "#1f343d": SURFACE2
};
const SITE_RGBA = [[/rgba\(\s*22,\s*36,\s*43\s*,/g, "rgba(58,53,88,"]];

function family(html) {
  if (/--bg:\s*#12102a/i.test(html)) return "dark";
  if (/--bg:\s*#eef1ec/i.test(html)) return "site";
  return "light";
}

const FAMILIES = {
  dark: { map: DARK_MAP, rgba: DARK_RGBA },
  light: { map: LIGHT_MAP, rgba: LIGHT_RGBA },
  site: { map: SITE_MAP, rgba: SITE_RGBA }
};

export function themeLessonHtml(html) {
  if (!html) return html;
  const fam = FAMILIES[family(html)];
  let out = html.replace(/#[0-9a-fA-F]{6}\b/g, (m) => fam.map[m.toLowerCase()] || m);
  for (const [re, to] of fam.rgba) out = out.replace(re, to);
  // #fff בקיצור: טקסט/מילוי -> טקסט כהה (על כפתורי מבטא), כל השאר (רקע, גבול) -> משטח כהה
  out = out.replace(/(?<![\w-])(color|fill|stroke)(\s*:\s*)#fff\b/gi, `$1$2${BG}`);
  out = out.replace(/#fff\b(?![0-9a-fA-F])/gi, SURFACE);
  // גופני הכותרות של השיעורים -> גופני האתר (רק בהצהרות font-family). בלי מרכאות, כי ההצהרה יכולה להופיע בתוך מחרוזת JS
  out = out.replace(/font-family\s*:[^;}]+/gi, (decl) =>
    decl.replace(/["']?(?:Rubik|Frank Ruhl Libre)["']?/gi, "Secular One").replace(/["']?Heebo["']?/gi, "Assistant")
  );
  return out;
}

// דריסת משתני השיעור (html:root מנצח :root בלי תלות בסדר), בלוקי קוד, וגופני האתר.
export function lessonThemeCss(html) {
  const siteVars =
    family(html) === "site"
      ? `--gold:${PINK};--gold-text:${PINK};--gold-soft:${PINK_SOFT};--moss:${MINT};--moss-soft:${MINT_SOFT};--rust:${PINK};--rust-soft:${PINK_SOFT};` +
        `--tok-kw:${PINK};--tok-str:${MINT};--tok-num:${BLUE};--tok-fn:${YELLOW};--tok-cmt:${FAINT};`
      : "";
  return `
html:root{
  --bg:${BG};--bg-panel:${SURFACE};--bg-panel-2:${SURFACE2};
  --ink:${TEXT};--ink-dim:${MUTED};--ink-faint:${FAINT};
  --line:${LINE};--line-strong:#4d4775;
  --code-bg:${BG};--code-head:${SURFACE2};--code-ink:${TEXT};
  --shadow:0 18px 40px -20px rgba(0,0,0,.6);--shadow-sm:0 8px 24px -12px rgba(0,0,0,.5);
  --display:"Secular One","Arial Hebrew",Arial,sans-serif;--sans:"Assistant",system-ui,"Segoe UI",Arial,sans-serif;--mono:"JetBrains Mono",ui-monospace,Menlo,Consolas,monospace;
  ${siteVars}
}
html,body{background:${BG}!important;background-image:none!important;color:${TEXT}}
body::before{display:none!important}
h1,h2,h3,h4{font-weight:400!important}
.codeblock,.code-card pre,.payload{background:${BG}!important;color:${TEXT}!important}
`;
}
