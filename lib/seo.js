// lib/seo.js
// עזרים משותפים ל-SEO: כתובת האתר הקנונית, וכתיבת JSON-LD.

export const SITE_URL = (process.env.SITE_URL || "https://course.codebloom.co.il").replace(/\/$/, "");
export const AUTHOR_NAME = "חני שטיינמץ";

// תמונת שיתוף (Open Graph) ברירת מחדל לכל עמוד. הקובץ public/og-default.png (מקור: scripts/og). נתיב יחסי: metadataBase הופך אותו למלא.
// חשוב: openGraph שמוגדר בעמוד מחליף לגמרי את זה של ה-layout (אין מיזוג), ולכן כל עמוד עם openGraph משלו חייב לכלול images: OG_IMAGES.
export const OG_IMAGES = [
  {
    url: "/og-default.png",
    width: 1200,
    height: 630,
    alt: "קורסים בעידן ה-AI: לומדים פייתון בעברית, בחינם, עם תרגילים ובדיקה אוטומטית"
  }
];

export function absoluteUrl(path = "/") {
  return `${SITE_URL}${path.startsWith("/") ? path : `/${path}`}`;
}

// מקצר טקסט לתיאור meta (עד ~155 תווים, חיתוך במילה שלמה).
export function toDescription(text, fallback = "") {
  const clean = (text || "").replace(/\s+/g, " ").trim() || fallback;
  if (clean.length <= 155) return clean;
  return clean.slice(0, 155).replace(/\s+\S*$/, "") + "…";
}

// תאריך הפריסה: next.config.mjs מזריק אותו בזמן build (env.BUILD_TIME). משמש כ-lastmod לעמודים בלי תאריך עדכון משלהם.
export const BUILD_TIME = process.env.BUILD_TIME || new Date().toISOString();

// ממיר תאריך ממסד הנתונים (ISO או "YYYY-MM-DD HH:MM:SS" של SQLite, שהוא UTC) ל-Date תקין, או null.
export function parseDbDate(value) {
  if (!value) return null;
  const s = String(value).trim();
  const d = new Date(/^\d{4}-\d{2}-\d{2} \d/.test(s) ? s.replace(" ", "T") + "Z" : s);
  return Number.isNaN(d.getTime()) ? null : d;
}

// התאריך המאוחר ביותר מתוך רשימת ערכים ממסד הנתונים; בלי אף אחד תקין: תאריך הפריסה.
export function latestDate(values) {
  let best = null;
  for (const v of values) {
    const d = parseDbDate(v);
    if (d && (!best || d > best)) best = d;
  }
  return best || new Date(BUILD_TIME);
}

// עמודים שאסור לאנדקס (אזור אישי/תשלום/ניהול).
export const NOINDEX = { robots: { index: false, follow: false } };

// מסדרג JSON-LD בבטחה לתוך <script>: מונע סגירה מוקדמת של התג דרך "<" בתוכן.
const BACKSLASH = String.fromCharCode(92);
export function jsonLdString(data) {
  return JSON.stringify(data).split("<").join(BACKSLASH + "u003c");
}
