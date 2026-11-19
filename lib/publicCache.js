// lib/publicCache.js
//
// קובץ ESM נקי (בלי imports) כדי ש-next.config.mjs יוכל לטעון אותו, וגם lib/auth.js ו-lib/admin-auth.js.
// מקור אחד לשמות עוגיות ההתחברות, כדי שכללי ה-cache לא ידלגו עליהן בטעות אם שם משתנה.

export const SESSION_COOKIE = "session_token"; // לומדת מחוברת (lib/auth.js)
export const ADMIN_COOKIE = "admin_session"; // מנהלת מחוברת (lib/admin-auth.js)

// קורסים חינמיים שאפשר ללמוד בהם ללא התחברות: שיעוריהם נגישים לכולם ולכן אפשר לשמור אותם ב-cache ציבורי.
export const PUBLIC_FREE_COURSES = ["python-ai-era"];

// s-maxage: כמה זמן שכבת cache משותפת (CDN) רשאית להגיש את העמוד בלי לפנות לשרת.
// stale-while-revalidate: אחריו עוד חלון קצר שבו מוגשת הגרסה הישנה בזמן שמרעננים ברקע.
// max-age=0: הדפדפן עצמו תמיד בודק מחדש (כך שהתחברות מוצגת מיד).
// החלון הכולל קצר בכוונה (שעתיים): HTML ששמור ב-cache מפנה לקובצי JS עם hash של הפריסה, ואחרי פריסה חדשה הם נעלמים.
export const PUBLIC_CACHE_CONTROL = "public, max-age=0, s-maxage=3600, stale-while-revalidate=3600";

// עמודי תוצאות הסקר (/survey/results, /survey/insights): getSurveyResults() עושה סריקה מלאה
// של survey_responses לכל שאלה (אין אינדקס על עמודות הסקר), ובלי cache כל צפיה מריצה את זה
// מחדש. ב-2026-11-19 שיתוף בקבוצה גדולה הציף ככה את מכסת הקריאות היומית של D1 תוך דקות.
// חלון קצר (דקה) מספיק כדי לקרוס N צפיות בו-זמניות לקריאה אחת למסד, ועדיין "חי" כמעט בזמן אמת.
export const SURVEY_CACHE_CONTROL = "public, max-age=0, s-maxage=60, stale-while-revalidate=300";

// מחזיר את כללי ה-headers של next.config. הכלל חל רק כשאין שום עוגיית התחברות (missing):
// למחוברת/מנהלת אין התאמה, והעמוד ממשיך לצאת עם ברירת המחדל של Next (private, no-store). גם בקשות RSC מוחרגות.
export function publicCacheHeaders() {
  const publicOnly = [
    { type: "cookie", key: SESSION_COOKIE },
    { type: "cookie", key: ADMIN_COOKIE },
    // בקשת RSC (ניווט פנימי של Next) מקבלת תגובה אחרת לאותה כתובת (ולפעמים הפניה בלי Vary), ולכן לא נכנסת ל-cache המשותף.
    { type: "header", key: "rsc" }
  ];
  const sources = [
    "/topics",
    "/topics/:slug",
    ...PUBLIC_FREE_COURSES.map((id) => `/courses/${id}/:lessonSlug`)
  ];
  const surveySources = ["/survey/results", "/survey/insights"];
  return [
    ...sources.map((source) => ({
      source,
      missing: publicOnly,
      headers: [{ key: "Cache-Control", value: PUBLIC_CACHE_CONTROL }]
    })),
    ...surveySources.map((source) => ({
      source,
      missing: publicOnly,
      headers: [{ key: "Cache-Control", value: SURVEY_CACHE_CONTROL }]
    }))
  ];
}
