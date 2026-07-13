// lib/site.js
//
// עוטף את משתנה הסביבה SITE_URL במקום אחד, כדי שכל מקום שצריך את כתובת
// האתר (sitemap, robots, ה-OG image, החזרה מ-Invoice4U) יתנהג אותו דבר.
//
// חשוב: אם מגדירים SITE_URL בלי סכימה (https://) - למשל רק "example.com" -
// זו טעות הגדרה נפוצה (בדיוק ככה זה קרה בפועל: SITE_URL=course.codebloom.co.il
// בלי https://) שגורמת ל-new URL() לזרוק שגיאה בכל בקשה ובקשה (ולכן לכל
// האתר להישבר), ובמקומות אחרים (sitemap.xml, robots.txt, ה-returnUrl
// שנשלח ל-Invoice4U) לייצר כתובות שבורות בלי לזרוק שגיאה גלויה בכלל. לכן
// מוסיפים https:// אוטומטית אם חסרה סכימה, במקום להניח שהיא תמיד שם.
export function siteUrl({ required = false } = {}) {
  let url = process.env.SITE_URL;

  if (!url) {
    if (required) {
      throw new Error("יש להגדיר את משתנה הסביבה SITE_URL (כתובת האתר בפועל) לפני קבלת תשלומים");
    }
    return "http://localhost:3000";
  }

  url = url.trim().replace(/\/$/, "");
  if (!/^https?:\/\//i.test(url)) {
    url = `https://${url}`;
  }
  return url;
}
