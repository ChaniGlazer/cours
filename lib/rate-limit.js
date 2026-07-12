// lib/rate-limit.js
//
// הגבלת קצב פשוטה בזיכרון (in-memory), לפי כתובת IP + סוג הפעולה, בחלון זמן
// נגלל (sliding window). מספיקה לאתר בהיקף קטן-בינוני שרץ כתהליך שרת יחיד; אם
// בעתיד תרוצו כמה instances מאחורי load balancer, יש להחליף במימוש משותף
// (Redis וכו').
//
// שימו לב: המפתח מבוסס על כותרת x-forwarded-for, שאמינה רק אם השרת רץ
// מאחורי reverse proxy מהימן שמגדיר אותה בעצמו (כך זה עובד ב-Render ובדומיו).
// אם אי פעם תריצו את השרת חשוף ישירות לאינטרנט בלי כזה proxy, הכותרת הזו
// ניתנת לזיוף ע"י הלקוח וההגבלה תהיה קלה לעקיפה.
import { headers } from "next/headers";

const buckets = new Map();

// כדי שה-Map לא יגדל ללא הגבלה לאורך חיי התהליך (רשומה לכל צירוף IP+פעולה
// שנראה אי פעם), מנקים מדי פעם רשומות שכבר יצאו מהחלון שלהן.
const CLEANUP_INTERVAL_MS = 60 * 60 * 1000;
let lastCleanup = Date.now();

function cleanupStaleBuckets(now) {
  if (now - lastCleanup < CLEANUP_INTERVAL_MS) return;
  lastCleanup = now;
  for (const [key, entry] of buckets) {
    if (now - entry.start > entry.windowMs) {
      buckets.delete(key);
    }
  }
}

async function clientKey(action) {
  const hdrs = await headers();
  const ip =
    hdrs.get("x-forwarded-for")?.split(",")[0].trim() ||
    hdrs.get("x-real-ip") ||
    "unknown";
  return `${action}:${ip}`;
}

/**
 * מחזיר true אם מותר להמשיך, false אם נחצתה מכסת הבקשות בחלון הזמן.
 */
export async function allowRequest(action, { max = 10, windowMs = 15 * 60 * 1000 } = {}) {
  const key = await clientKey(action);
  const now = Date.now();
  cleanupStaleBuckets(now);

  const entry = buckets.get(key);
  if (!entry || now - entry.start > windowMs) {
    buckets.set(key, { start: now, count: 1, windowMs });
    return true;
  }

  entry.count += 1;
  return entry.count <= max;
}
