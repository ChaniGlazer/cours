// lib/rate-limit.js
//
// הגבלת קצב פשוטה בזיכרון (in-memory), לפי כתובת IP + סוג הפעולה, בחלון זמן
// נגלל (sliding window). מספיקה לאתר בהיקף קטן-בינוני שרץ כתהליך שרת יחיד; אם
// בעתיד תרוצו כמה instances מאחורי load balancer, יש להחליף במימוש משותף
// (Redis וכו').
import { headers } from "next/headers";

const buckets = new Map();

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

  const entry = buckets.get(key);
  if (!entry || now - entry.start > windowMs) {
    buckets.set(key, { start: now, count: 1 });
    return true;
  }

  entry.count += 1;
  return entry.count <= max;
}
