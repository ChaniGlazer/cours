// lib/visitStore.js
//
// מעקב כניסות אנונימי (migrations/0010_site_visits.sql): כתיבת צפיית עמוד מה-client וקריאה מסוכמת לפאנל הניהול.
// לא נשמרת כתובת IP ולא User-Agent מלא, רק מדינה/עיר (מ-Cloudflare), מקור הגעה (דומיין בלבד), סוג מכשיר ודפדפן.
import { getDb, nowIso } from "./db";

const MAX_PER_VISITOR_PER_HOUR = 120;
const RETENTION_DAYS = 365;
const OVERVIEW_DAYS = 30;
const RECENT_VISITORS = 100;

// יום לפי שעון ישראל (YYYY-MM-DD), כדי שהסיכום היומי יתחלף בחצות המקומית ולא ב-UTC.
export function israelDay(date = new Date()) {
  return date.toLocaleDateString("sv-SE", { timeZone: "Asia/Jerusalem" });
}

export function parseDevice(ua = "") {
  const device = /ipad|tablet/i.test(ua) ? "tablet" : /mobi|android|iphone/i.test(ua) ? "mobile" : "desktop";
  const browser = /edg\//i.test(ua)
    ? "Edge"
    : /opr\/|opera/i.test(ua)
      ? "Opera"
      : /firefox|fxios/i.test(ua)
        ? "Firefox"
        : /chrome|crios/i.test(ua)
          ? "Chrome"
          : /safari/i.test(ua)
            ? "Safari"
            : "אחר";
  return { device, browser };
}

export function isBot(ua = "") {
  return !ua || /bot|crawl|spider|slurp|facebookexternalhit|preview|headless|lighthouse|curl|wget|python-requests/i.test(ua);
}

// מקור ההגעה: דומיין ה-referrer בלבד. אותו אתר או ריק = "ישיר".
export function referrerSource(referrer, ownHosts) {
  if (!referrer) return "ישיר";
  try {
    const host = new URL(referrer).hostname.replace(/^www\./, "");
    if (!host || ownHosts.has(host)) return "ישיר";
    return host.slice(0, 80);
  } catch {
    return "ישיר";
  }
}

// visit: { path, visitorId, userId, country, city, source, device, browser }. מחזיר true אם נשמר.
export async function recordVisit(visit) {
  const db = await getDb();
  const now = nowIso();
  const hourAgo = new Date(Date.now() - 3600000).toISOString();
  const res = await db
    .prepare(
      `INSERT INTO site_visits (visited_at, day, path, visitor_id, user_id, country, city, source, device, browser)
       SELECT ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10
       WHERE (SELECT COUNT(*) FROM site_visits WHERE visitor_id = ?4 AND visited_at > ?11) < ?12`
    )
    .bind(
      now, israelDay(), visit.path, visit.visitorId, visit.userId || null,
      visit.country || null, visit.city || null, visit.source || null, visit.device || null, visit.browser || null,
      hourAgo, MAX_PER_VISITOR_PER_HOUR
    )
    .run();
  // ניקוי רשומות ישנות, לא בכל בקשה
  if (Math.random() < 0.005) {
    const cutoff = new Date(Date.now() - RETENTION_DAYS * 86400000).toISOString();
    await db.prepare("DELETE FROM site_visits WHERE visited_at < ?").bind(cutoff).run();
  }
  return (res.meta?.changes ?? 0) > 0;
}

// לפאנל הניהול: סיכום 30 הימים האחרונים + רשימת המבקרים האחרונים.
export async function getVisitsOverview() {
  const db = await getDb();
  const today = israelDay();
  const since = (n) => israelDay(new Date(Date.now() - n * 86400000));
  const from30 = since(OVERVIEW_DAYS - 1);
  const from7 = since(6);

  const group = (col) =>
    db
      .prepare(
        `SELECT COALESCE(${col}, 'לא ידוע') AS label, COUNT(*) AS views, COUNT(DISTINCT visitor_id) AS visitors
         FROM site_visits WHERE day >= ?1 GROUP BY 1 ORDER BY views DESC LIMIT 10`
      )
      .bind(from30)
      .all();

  const [totals, daily, pages, countries, sources, devices, visitors] = await Promise.all([
    db
      .prepare(
        `SELECT
           COUNT(*) AS views30, COUNT(DISTINCT visitor_id) AS visitors30,
           SUM(day >= ?2) AS views7, COUNT(DISTINCT CASE WHEN day >= ?2 THEN visitor_id END) AS visitors7,
           SUM(day = ?3) AS views1, COUNT(DISTINCT CASE WHEN day = ?3 THEN visitor_id END) AS visitors1
         FROM site_visits WHERE day >= ?1`
      )
      .bind(from30, from7, today)
      .first(),
    db
      .prepare("SELECT day, COUNT(*) AS views, COUNT(DISTINCT visitor_id) AS visitors FROM site_visits WHERE day >= ? GROUP BY day ORDER BY day")
      .bind(from30)
      .all(),
    group("path"),
    group("country"),
    group("source"),
    group("device"),
    db
      .prepare(
        `SELECT v.visitor_id, COUNT(*) AS views, COUNT(DISTINCT v.day) AS days,
                MIN(v.visited_at) AS first_at, MAX(v.visited_at) AS last_at,
                MAX(v.user_id) AS user_id, MAX(v.country) AS country, MAX(v.city) AS city,
                MAX(v.device) AS device, MAX(v.browser) AS browser, MAX(v.source) AS source,
                (SELECT path FROM site_visits WHERE visitor_id = v.visitor_id ORDER BY visited_at DESC LIMIT 1) AS last_path,
                u.name AS user_name, u.email AS user_email
         FROM site_visits v LEFT JOIN users u ON u.id = v.user_id
         WHERE v.day >= ?1 GROUP BY v.visitor_id ORDER BY last_at DESC LIMIT ?2`
      )
      .bind(from30, RECENT_VISITORS)
      .all()
  ]);

  // ימים בלי כניסות מוצגים כאפס כדי שהגרף יהיה רציף
  const byDay = new Map(daily.results.map((d) => [d.day, d]));
  const days = [];
  for (let i = OVERVIEW_DAYS - 1; i >= 0; i--) {
    const day = since(i);
    days.push({ day, views: byDay.get(day)?.views || 0, visitors: byDay.get(day)?.visitors || 0 });
  }

  return {
    days: OVERVIEW_DAYS,
    totals: {
      views30: totals?.views30 || 0, visitors30: totals?.visitors30 || 0,
      views7: totals?.views7 || 0, visitors7: totals?.visitors7 || 0,
      views1: totals?.views1 || 0, visitors1: totals?.visitors1 || 0
    },
    daily: days,
    pages: pages.results,
    countries: countries.results,
    sources: sources.results,
    devices: devices.results,
    visitors: visitors.results
  };
}
