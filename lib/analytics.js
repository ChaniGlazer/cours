// lib/analytics.js
//
// מעקב כניסות עצמאי ופשוט (בלי שירות חיצוני). לא נשמרת כתובת IP גולמית -
// רק גיבוב (HMAC) של IP + דפדפן, כך שאפשר לספור מבקרים ייחודיים בלי לשמור
// מידע מזהה. משתמש רשום שמחובר נשמר גם לפי מזהה המשתמש.
import crypto from "node:crypto";
import { db } from "./db";

const BOT_RE = /bot|crawl|spider|slurp|facebookexternalhit|preview|headless|lighthouse|monitor|curl|wget|python|axios|node-fetch/i;

export function isBot(ua) {
  return !ua || BOT_RE.test(ua);
}

export function hashVisitor(ip, ua) {
  const secret = process.env.ANALYTICS_SALT || process.env.ADMIN_PASSWORD || "course-site";
  return crypto.createHmac("sha256", secret).update(`${ip}|${ua}`).digest("hex").slice(0, 24);
}

export function parseDevice(ua) {
  const device = /ipad|tablet/i.test(ua) ? "טאבלט" : /mobi|android|iphone/i.test(ua) ? "נייד" : "מחשב";
  const browser = /edg\//i.test(ua)
    ? "Edge"
    : /chrome|crios/i.test(ua)
      ? "Chrome"
      : /firefox|fxios/i.test(ua)
        ? "Firefox"
        : /safari/i.test(ua)
          ? "Safari"
          : "אחר";
  return { device, browser };
}

export function recordVisit({ path, visitorHash, userId, referrer, ua }) {
  const { device, browser } = parseDevice(ua);
  // מניעת כפילות: אותו מבקר באותו עמוד בתוך 30 שניות (רענון / ניווט כפול)
  const since = new Date(Date.now() - 30 * 1000).toISOString();
  const dup = db
    .prepare("SELECT 1 FROM visits WHERE visitor_hash = ? AND path = ? AND created_at > ? LIMIT 1")
    .get(visitorHash, path, since);
  if (dup) return;
  db.prepare(
    "INSERT INTO visits (created_at, path, visitor_hash, user_id, referrer, device, browser) VALUES (?, ?, ?, ?, ?, ?, ?)"
  ).run(new Date().toISOString(), path, visitorHash, userId || null, referrer || null, device, browser);
  // ניקוי נתונים ישנים מ-400 ימים (מזעור שמירת מידע)
  if (Math.random() < 0.01) {
    db.prepare("DELETE FROM visits WHERE created_at < ?").run(
      new Date(Date.now() - 400 * 86400000).toISOString()
    );
  }
}

export function getAnalytics(days = 30) {
  const since = new Date(Date.now() - days * 86400000).toISOString();
  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);

  const one = (sql, ...a) => db.prepare(sql).get(...a);
  const all = (sql, ...a) => db.prepare(sql).all(...a);

  const totals = {
    today: one("SELECT COUNT(*) c, COUNT(DISTINCT visitor_hash) u FROM visits WHERE created_at >= ?", todayStart.toISOString()),
    range: one("SELECT COUNT(*) c, COUNT(DISTINCT visitor_hash) u FROM visits WHERE created_at >= ?", since),
    registered: one(
      "SELECT COUNT(DISTINCT user_id) u FROM visits WHERE user_id IS NOT NULL AND created_at >= ?",
      since
    ).u
  };

  const perDay = all(
    "SELECT substr(created_at, 1, 10) d, COUNT(*) c, COUNT(DISTINCT visitor_hash) u FROM visits WHERE created_at >= ? GROUP BY d ORDER BY d",
    since
  );
  const topPages = all(
    "SELECT path, COUNT(*) c, COUNT(DISTINCT visitor_hash) u FROM visits WHERE created_at >= ? GROUP BY path ORDER BY c DESC LIMIT 10",
    since
  );
  const referrers = all(
    "SELECT referrer, COUNT(*) c FROM visits WHERE created_at >= ? AND referrer IS NOT NULL AND referrer != '' GROUP BY referrer ORDER BY c DESC LIMIT 10",
    since
  );
  const devices = all("SELECT device, COUNT(*) c FROM visits WHERE created_at >= ? GROUP BY device ORDER BY c DESC", since);
  const recent = all(
    `SELECT v.created_at, v.path, v.referrer, v.device, v.browser, v.visitor_hash, u.name AS user_name, u.email AS user_email
     FROM visits v LEFT JOIN users u ON u.id = v.user_id
     ORDER BY v.id DESC LIMIT 100`
  );
  const registeredVisitors = all(
    `SELECT u.name, u.email, u.paid, COUNT(*) c, MAX(v.created_at) last_seen
     FROM visits v JOIN users u ON u.id = v.user_id
     WHERE v.created_at >= ? GROUP BY u.id ORDER BY last_seen DESC LIMIT 50`,
    since
  );

  return { totals, perDay, topPages, referrers, devices, recent, registeredVisitors };
}
