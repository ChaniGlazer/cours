import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";
import { publicCacheHeaders } from "./lib/publicCache.js";

// מפעיל גישה ל-bindings של Cloudflare (למשל D1 דרך env.DB) גם בזמן `next dev`
// רגיל, לא רק בפריסה בפועל - ראו lib/db.js.
initOpenNextCloudflareForDev();

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,

  // תאריך הפריסה (נקבע בזמן build) ל-lastmod ב-sitemap של עמודים סטטיים. ראו lib/seo.js.
  env: { BUILD_TIME: new Date().toISOString() },

  // Cache-Control ציבורי לעמודי נושאים ולשיעורי קורס חינמי, רק למי שאין לה עוגיית התחברות. ראו lib/publicCache.js.
  async headers() {
    return publicCacheHeaders();
  }
};

export default nextConfig;
