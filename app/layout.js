import "./globals.css";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { logoutAction } from "@/app/actions/auth";

export async function generateMetadata() {
  const settings = await getSettings();
  return {
    title: settings.site_title || "קורסים בעידן ה-AI"
  };
}

export default async function RootLayout({ children }) {
  const user = await getCurrentUser();
  const settings = await getSettings();
  const brand = settings.site_title || "קורסים בעידן ה-AI";

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
        <header className="site-header">
          <div className="container">
            <a className="brand" href="/courses">
              {brand}
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
            © {new Date().getFullYear()} {brand}
          </div>
        </footer>
      </body>
    </html>
  );
}
