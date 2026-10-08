import { isAdmin } from "@/lib/admin-auth";
import { getSettings, getAllLessons, getTestimonials } from "@/lib/settings";
import { getCourses } from "@/lib/courses";
import { adminLoginAction, adminLogoutAction } from "@/app/actions/admin";
import AdminApp from "./AdminApp";

export default async function AdminPage({ searchParams }) {
  const params = await searchParams;
  if (!(await isAdmin())) {
    return (
      <section className="section">
        <div className="container form-narrow">
          <h1 style={{ textAlign: "center" }}>כניסת ניהול</h1>
          <div className="card-elevated">
            {params?.error && (
              <div className="alert alert-error">סיסמה שגויה.</div>
            )}
            <form action={adminLoginAction}>
              <div className="field">
                <label htmlFor="password">סיסמת ניהול</label>
                <input id="password" name="password" type="password" required autoFocus />
              </div>
              <button type="submit" className="btn btn-primary btn-block">
                כניסה
              </button>
            </form>
          </div>
        </div>
      </section>
    );
  }

  const [settings, courses, lessons, testimonials] = await Promise.all([
    getSettings(),
    getCourses(),
    getAllLessons(),
    getTestimonials()
  ]);

  return (
    <AdminApp
      settings={settings}
      courses={courses}
      lessons={lessons}
      testimonials={testimonials}
      logoutAction={adminLogoutAction}
    />
  );
}

export const metadata = { robots: { index: false, follow: false } };
