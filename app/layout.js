import "./globals.css";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { logoutAction } from "@/app/actions/auth";
import { SITE_URL, AUTHOR_NAME, OG_IMAGES } from "@/lib/seo";
import { CONTACT_EMAIL } from "@/lib/site";
import VisitTracker from "@/app/components/VisitTracker";

const DEFAULT_DESCRIPTION =
  "קורסים בעברית ללימוד פייתון ופיתוח אפליקציות בעידן ה-AI, עם שיעורים אינטראקטיביים ותרגילים. חלק מהקורסים חינמיים.";

export async function generateMetadata() {
  const settings = await getSettings();
  const brand = settings.site_title || "קורסים בעידן ה-AI";
  return {
    metadataBase: new URL(SITE_URL),
    title: { default: brand, template: `%s | ${brand}` },
    description: DEFAULT_DESCRIPTION,
    authors: [{ name: AUTHOR_NAME }],
    openGraph: {
      type: "website",
      locale: "he_IL",
      siteName: brand,
      title: brand,
      description: DEFAULT_DESCRIPTION,
      images: OG_IMAGES
    },
    twitter: { card: "summary_large_image", title: brand, description: DEFAULT_DESCRIPTION, images: OG_IMAGES }
  };
}

export default async function RootLayout({ children }) {
  const user = await getCurrentUser();
  const settings = await getSettings();
  const brand = settings.site_title || "קורסים בעידן ה-AI";

  return (
    <html lang="he" dir="rtl">
      <head>
        {/* הגופנים מאוחסנים באתר (@font-face ב-globals.css). preload רק לעברית של גופן הגוף ושל הכותרות: הם בחלק העליון של כל עמוד.
            crossOrigin חובה גם לאותו דומיין, אחרת הדפדפן מוריד את הגופן פעמיים. */}
        <link rel="preload" href="/fonts/assistant-hebrew.woff2" as="font" type="font/woff2" crossOrigin="anonymous" />
        <link rel="preload" href="/fonts/secular-one-hebrew.woff2" as="font" type="font/woff2" crossOrigin="anonymous" />
      </head>
      <body>
        <VisitTracker />
        <header className="site-header">
          <div className="container">
            <a className="brand" href="/courses">
              <span className="brand__icon" aria-hidden="true">
                {"</>"}
              </span>
              <span>{brand}</span>
            </a>
            <nav className="nav-links">
              <a href="/courses">קטלוג קורסים</a>
              {user ? (
                <>
                  <a href="/my-courses">האזור שלי</a>
                  <form action={logoutAction}>
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      התנתקות
                    </button>
                  </form>
                </>
              ) : (
                <>
                  <a href="/login">התחברות</a>
                  <a href="/register" className="btn btn-primary btn-outline" style={{ padding: "0 20px" }}>
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
            <span>
              © {new Date().getFullYear()} {brand}
            </span>
            {CONTACT_EMAIL && <a href={`mailto:${CONTACT_EMAIL}`}>{CONTACT_EMAIL}</a>}
            <nav aria-label="קישורי תחתית">
              <a href="/courses">קטלוג קורסים</a>
              <a href="/topics">נושאים</a>
              <a href="/about">אודות</a>
              <a href="/privacy">פרטיות</a>
              {user ? (
                <a href="/my-courses">האזור שלי</a>
              ) : (
                <>
                  <a href="/login">התחברות</a>
                  <a href="/register">הרשמה</a>
                </>
              )}
            </nav>
          </div>
        </footer>
      </body>
    </html>
  );
}
