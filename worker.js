// worker.js - נקודת הכניסה של ה-Worker (wrangler.jsonc: main).
//
// עוטף את ה-Worker שנוצר ע"י OpenNext (.open-next/worker.js) וחוסם את כל האתר בשבת:
// כל בקשה שמגיעה בין כניסת השבת ליציאתה מקבלת את הדף "אתר זה שומר שבת" ולא מגיעה בכלל ל-Next או ל-D1.
// הזמנים מחושבים ב-lib/shabbat.js. קבצים סטטיים (CSS/JS/גופנים) מוגשים ע"י Cloudflare Assets לפני ה-Worker,
// אבל בלי ה-HTML אי אפשר להגיע אליהם ממילא.

import openNextWorker from "./.open-next/worker.js";
import { shabbatStatus, shabbatPageHtml } from "./lib/shabbat.js";

export { DOQueueHandler, DOShardedTagCache, BucketCachePurge } from "./.open-next/worker.js";

export default {
  async fetch(request, env, ctx) {
    const status = shabbatStatus(new Date());
    if (status.blocked) {
      // 503 + Retry-After: מנועי חיפוש מבינים שזו הפסקה זמנית ולא מורידים את האתר מהאינדקס.
      return new Response(request.method === "HEAD" ? null : shabbatPageHtml(status.endsAt), {
        status: 503,
        headers: {
          "Content-Type": "text/html; charset=utf-8",
          "Cache-Control": "no-store",
          "Retry-After": String(Math.max(60, Math.ceil((status.endsAt - Date.now()) / 1000)))
        }
      });
    }
    return openNextWorker.fetch(request, env, ctx);
  }
};
