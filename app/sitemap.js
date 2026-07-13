// app/sitemap.js
//
// כולל רק עמודי תוכן ציבוריים בעלי ערך לחיפוש. עמודים דינמיים/מוגנים
// (למשל /course, /login, /admin, /payment/*) לא נכללים בכוונה - ראו הסבר
// ב-app/robots.js.
function siteUrl() {
  const url = process.env.SITE_URL;
  return url ? url.replace(/\/$/, "") : "http://localhost:3000";
}

export default function sitemap() {
  const base = siteUrl();
  const now = new Date();

  return [
    { url: `${base}/`, lastModified: now, changeFrequency: "weekly", priority: 1 },
    { url: `${base}/terms`, lastModified: now, changeFrequency: "yearly", priority: 0.3 },
    { url: `${base}/privacy`, lastModified: now, changeFrequency: "yearly", priority: 0.3 }
  ];
}
