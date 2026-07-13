// app/robots.js
function siteUrl() {
  const url = process.env.SITE_URL;
  return url ? url.replace(/\/$/, "") : "http://localhost:3000";
}

export default function robots() {
  const base = siteUrl();

  return {
    rules: {
      userAgent: "*",
      allow: "/",
      // /admin - עמוד ניהול, לא לתוכן ציבורי בשום מקרה.
      // /course - מוגן בהתחברות + תשלום, מציג מסך התחברות/תשלום לבוט ללא ערך לחיפוש.
      // /payment - עמודי ביניים טרנזקציוניים (הצלחה/ביטול), לא תוכן.
      disallow: ["/admin", "/course", "/payment"]
    },
    sitemap: `${base}/sitemap.xml`
  };
}
