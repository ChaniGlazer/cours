// app/robots.js
import { siteUrl } from "@/lib/site";

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
