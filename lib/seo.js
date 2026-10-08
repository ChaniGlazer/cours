// lib/seo.js
// עזרים משותפים ל-SEO: כתובת האתר הקנונית, וכתיבת JSON-LD.

export const SITE_URL = (process.env.SITE_URL || "https://course.codebloom.co.il").replace(/\/$/, "");
export const AUTHOR_NAME = "חני שטיינמץ";

export function absoluteUrl(path = "/") {
  return `${SITE_URL}${path.startsWith("/") ? path : `/${path}`}`;
}

// מקצר טקסט לתיאור meta (עד ~155 תווים, חיתוך במילה שלמה).
export function toDescription(text, fallback = "") {
  const clean = (text || "").replace(/\s+/g, " ").trim() || fallback;
  if (clean.length <= 155) return clean;
  return clean.slice(0, 155).replace(/\s+\S*$/, "") + "…";
}

// עמודים שאסור לאנדקס (אזור אישי/תשלום/ניהול).
export const NOINDEX = { robots: { index: false, follow: false } };

// מסדרג JSON-LD בבטחה לתוך <script>: מונע סגירה מוקדמת של התג דרך "<" בתוכן.
const BACKSLASH = String.fromCharCode(92);
export function jsonLdString(data) {
  return JSON.stringify(data).split("<").join(BACKSLASH + "u003c");
}
