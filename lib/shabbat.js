// lib/shabbat.js
//
// חישוב זמני שבת (כניסה ויציאה) לפי שקיעת החמה בירושלים. קובץ ESM נקי בלי imports ובלי תלויות,
// כדי שיעבוד ב-Cloudflare Worker (worker.js בשורש הפרויקט) וגם בבדיקות ב-Node.
//
// השבת נכנסת לפני השקיעה של יום שישי ויוצאת אחרי השקיעה של יום שבת.
// כל הזמנים הם הלכתיים-חומרתיים בכוונה (כדי שהאתר ייסגר מוקדם ויפתח מאוחר, לא להפך):
//   כניסה = שקיעה פחות 40 דקות (המנהג הירושלמי, המוקדם ביותר בארץ)
//   יציאה = שקיעה ועוד 50 דקות (מעבר לצאת הכוכבים של 8.5 מעלות בכל עונות השנה, ובכל רחבי הארץ)
// השינוי נעשה בקבועים כאן בלבד.

export const SHABBAT_TIMEZONE = "Asia/Jerusalem";
const LATITUDE = 31.7683; // ירושלים
const LONGITUDE = 35.2137;
export const CANDLE_LIGHTING_MINUTES_BEFORE_SUNSET = 40;
export const HAVDALAH_MINUTES_AFTER_SUNSET = 50;

const RAD = Math.PI / 180;

// שקיעת החמה (שעה אסטרונומית, כולל שבירת האטמוספירה) לתאריך לוח נתון, כ-ms של UTC.
// אלגוריתם NOAA Solar Calculator, דיוק של בערך דקה, מספיק לכאן.
function sunsetUtcMs(year, month, day) {
  const jd = Date.UTC(year, month - 1, day, 12) / 86400000 + 2440587.5;
  const t = (jd - 2451545) / 36525;
  const l0 = (280.46646 + t * (36000.76983 + t * 0.0003032)) % 360;
  const m = 357.52911 + t * (35999.05029 - 0.0001537 * t);
  const e = 0.016708634 - t * (0.000042037 + 0.0000001267 * t);
  const c =
    Math.sin(m * RAD) * (1.914602 - t * (0.004817 + 0.000014 * t)) +
    Math.sin(2 * m * RAD) * (0.019993 - 0.000101 * t) +
    Math.sin(3 * m * RAD) * 0.000289;
  const omega = 125.04 - 1934.136 * t;
  const lambda = l0 + c - 0.00569 - 0.00478 * Math.sin(omega * RAD);
  const eps0 = 23 + (26 + (21.448 - t * (46.815 + t * (0.00059 - t * 0.001813))) / 60) / 60;
  const eps = eps0 + 0.00256 * Math.cos(omega * RAD);
  const decl = Math.asin(Math.sin(eps * RAD) * Math.sin(lambda * RAD));
  const y = Math.tan((eps * RAD) / 2) ** 2;
  const eqTime =
    4 *
    ((y * Math.sin(2 * l0 * RAD) -
      2 * e * Math.sin(m * RAD) +
      4 * e * y * Math.sin(m * RAD) * Math.cos(2 * l0 * RAD) -
      0.5 * y * y * Math.sin(4 * l0 * RAD) -
      1.25 * e * e * Math.sin(2 * m * RAD)) /
      RAD);
  const ha =
    Math.acos(
      Math.cos(90.833 * RAD) / (Math.cos(LATITUDE * RAD) * Math.cos(decl)) -
        Math.tan(LATITUDE * RAD) * Math.tan(decl)
    ) / RAD;
  const sunsetMinutesUtc = 720 - 4 * (LONGITUDE - ha) - eqTime;
  return Date.UTC(year, month - 1, day) + sunsetMinutesUtc * 60000;
}

// התאריך (שנה, חודש, יום) ויום בשבוע (0=ראשון ... 6=שבת) כפי שהם עכשיו בישראל.
function israelDateParts(date) {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone: SHABBAT_TIMEZONE,
    year: "numeric",
    month: "numeric",
    day: "numeric",
    weekday: "short"
  }).formatToParts(date);
  const get = (type) => parts.find((p) => p.type === type).value;
  const weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
  return {
    year: Number(get("year")),
    month: Number(get("month")),
    day: Number(get("day")),
    weekday: weekdays.indexOf(get("weekday"))
  };
}

/** שעה בפורמט HH:MM לפי שעון ישראל (כולל שעון קיץ). */
export function formatIsraelTime(ms) {
  return new Intl.DateTimeFormat("he-IL", {
    timeZone: SHABBAT_TIMEZONE,
    hour: "2-digit",
    minute: "2-digit",
    hour12: false
  }).format(new Date(ms));
}

/**
 * האם עכשיו שבת? מחזיר { blocked, startsAt, endsAt } (ms של UTC) לשבת הרלוונטית.
 * שבת יכולה להיות רק בשישי או בשבת לפי שעון ישראל (היציאה תמיד לפני חצות), לכן בשאר הימים אין חישוב בכלל.
 */
export function shabbatStatus(now = new Date()) {
  const { year, month, day, weekday } = israelDateParts(now);
  if (weekday !== 5 && weekday !== 6) return { blocked: false };

  // תאריכי שישי ושבת של אותה שבת (חשבון תאריכים ב-UTC כדי להימנע מבעיות שעון קיץ).
  const friday = new Date(Date.UTC(year, month - 1, day - (weekday === 6 ? 1 : 0)));
  const saturday = new Date(friday.getTime() + 86400000);
  const startsAt =
    sunsetUtcMs(friday.getUTCFullYear(), friday.getUTCMonth() + 1, friday.getUTCDate()) -
    CANDLE_LIGHTING_MINUTES_BEFORE_SUNSET * 60000;
  const endsAt =
    sunsetUtcMs(saturday.getUTCFullYear(), saturday.getUTCMonth() + 1, saturday.getUTCDate()) +
    HAVDALAH_MINUTES_AFTER_SUNSET * 60000;

  const t = now.getTime();
  return { blocked: t >= startsAt && t < endsAt, startsAt, endsAt };
}

/** דף "האתר שומר שבת" (HTML מלא ועצמאי, בלי תלות בשאר האתר). */
export function shabbatPageHtml(endsAt) {
  const endsText = endsAt ? `השבת יוצאת היום בשעה ${formatIsraelTime(endsAt)} (שעון ישראל), ואז האתר נפתח שוב.` : "";
  return `<!doctype html>
<html lang="he" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="robots" content="noindex">
<title>האתר שומר שבת</title>
<style>
  html, body { height: 100%; margin: 0; }
  body { display: flex; align-items: center; justify-content: center; padding: 16px; box-sizing: border-box;
    background: #f7f5ef; color: #2b2b2b; font-family: system-ui, "Segoe UI", Arial, sans-serif; text-align: center; }
  main { max-width: 32rem; }
  h1 { font-size: 2rem; margin: 0 0 1rem; }
  p { font-size: 1.15rem; line-height: 1.7; margin: 0.4rem 0; }
  .sub { color: #666; }
  @media (prefers-color-scheme: dark) {
    body { background: #1c1b19; color: #eee; }
    .sub { color: #aaa; }
  }
</style>
</head>
<body>
<main>
  <h1>אתר זה שומר שבת</h1>
  <p>האתר סגור במהלך השבת ולא ניתן להיכנס אליו.</p>
  <p class="sub">${endsText}</p>
  <p>שבת שלום!</p>
</main>
</body>
</html>`;
}
