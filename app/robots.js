import { SITE_URL } from "@/lib/seo";

export default function robots() {
  return {
    rules: [
      {
        userAgent: "*",
        allow: "/",
        disallow: ["/admin", "/login", "/register", "/forgot-password", "/reset-password", "/my-courses", "/payment/"]
      }
    ],
    sitemap: `${SITE_URL}/sitemap.xml`
  };
}
