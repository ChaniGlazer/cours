import "./globals.css";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { logoutAction } from "@/app/actions/auth";

export async function generateMetadata() {
  const settings = getSettings();
  return {
    title: settings.course_title || "הקורס שלי",
    description: settings.course_subtitle || ""
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
