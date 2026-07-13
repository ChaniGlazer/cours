import "./globals.css";
import Script from "next/script";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { logoutAction } from "@/app/actions/auth";

// מזהה מעקב Google Ads (ניתן ע"י צוות Google Ads) - לא סוד: מזהה כזה תמיד
// גלוי ב-HTML הציבורי של כל דף, כך שאין סיבה לשמור אותו כמשתנה סביבה.
const GOOGLE_ADS_ID = "AW-18320465832";

function siteUrl() {
  const url = process.env.SITE_URL;
  return url ? url.replace(/\/$/, "") : "http://localhost:3000";
}

export async function generateMetadata() {
  const settings = getSettings();
  const courseTitle = settings.course_title || "הקורס שלי";
  const description = settings.course_subtitle || "";

  return {
    // נדרש כדי ש-Next.js יוכל להפוך קישורים יחסיים (כמו תמונת ה-Open Graph
    // הדינמית ב-app/opengraph-image.js) לכתובות מלאות בתגיות ה-meta.
    metadataBase: new URL(siteUrl()),
    title: {
      default: courseTitle,
      // עמודים שמגדירים metadata.title משלהם (מחרוזת פשוטה) מקבלים אותו
      // מוצג כ-"<כותרת העמוד> | <שם הקורס>" - ראו למשל app/login/page.js.
      template: `%s | ${courseTitle}`
    },
    description,
    openGraph: {
      title: courseTitle,
      description,
      type: "website",
      locale: "he_IL",
      siteName: courseTitle
    },
    twitter: {
      card: "summary_large_image",
      title: courseTitle,
      description
    }
  };
}

export default async function RootLayout({ children }) {
  const user = await getCurrentUser();
  const settings = getSettings();

  return (
    <html lang="he" dir="rtl">
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link
          href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@500;700&family=Heebo:wght@400;500;600;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>
        {/* Google tag (gtag.js) - מוטמע עם next/script (afterInteractive) לפי
            ההנחיה הרשמית של Next.js לתגי אנליטיקס/פרסום של צד שלישי, במקום
            תגית <script> גולמית ב-<head> כפי שמופיע בהוראות הגנריות של גוגל. */}
        <Script
          src={`https://www.googletagmanager.com/gtag/js?id=${GOOGLE_ADS_ID}`}
          strategy="afterInteractive"
        />
        <Script id="google-tag" strategy="afterInteractive">
          {`
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '${GOOGLE_ADS_ID}');
          `}
        </Script>

        <header className="site-header">
          <div className="container">
            <a className="brand" href="/">
              {settings.course_title || "הקורס שלי"}
            </a>
            <nav className="nav-links">
              {user ? (
                <>
                  <a href="/course">{user.paid ? "לקורס" : "האזור האישי"}</a>
                  <form action={logoutAction}>
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      התנתקות
                    </button>
                  </form>
                </>
              ) : (
                <>
                  <a href="/login">התחברות</a>
                  <a href="/register" className="btn btn-primary" style={{ padding: "8px 20px" }}>
                    הרשמה
                  </a>
                </>
              )}
            </nav>
          </div>
        </header>

        <main>{children}</main>

        <footer className="site-footer">
          <div className="container">
            <div>
              © {new Date().getFullYear()} {settings.course_title || "הקורס שלי"}
            </div>
            <div style={{ marginTop: 8, display: "flex", gap: 14, justifyContent: "center" }}>
              <a href="/terms">תקנון</a>
              <a href="/privacy">מדיניות פרטיות</a>
            </div>
            <div className="text-soft" style={{ marginTop: 8, fontSize: "0.85rem" }}>
              מופעל על ידי{" "}
              <a href="https://codebloom.co.il" target="_blank" rel="noopener noreferrer">
                codebloom.co.il
              </a>
            </div>
          </div>
        </footer>
      </body>
    </html>
  );
}
