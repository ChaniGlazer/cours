import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";

// מפעיל גישה ל-bindings של Cloudflare (למשל D1 דרך env.DB) גם בזמן `next dev`
// רגיל, לא רק בפריסה בפועל - ראו lib/db.js.
initOpenNextCloudflareForDev();

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true
};

export default nextConfig;
