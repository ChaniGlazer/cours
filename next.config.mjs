import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";

// מפעיל גישה ל-bindings של Cloudflare (למשל D1 דרך env.DB) גם בזמן `next dev`
// רגיל, לא רק בפריסה בפועל - ראו lib/db.js.
initOpenNextCloudflareForDev();

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,

  // האתר עבר ל-Cloudflare. כל כניסה לכתובת הישנה ב-Render מופנית לכתובת החדשה,
  // כולל הנתיב (למשל /course -> https://course.codebloom.co.il/course).
  async redirects() {
    return [
      {
        source: "/:path*",
        destination: "https://course.codebloom.co.il/:path*",
        permanent: false
      }
    ];
  }
};

export default nextConfig;
