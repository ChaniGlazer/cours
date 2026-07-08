import { isAdmin } from "@/lib/admin-auth";
import { getSettings, getLessons } from "@/lib/settings";
import {
  adminLoginAction,
  adminLogoutAction,
  updateSettingsAction,
  createLessonAction,
  updateLessonAction,
  deleteLessonAction
} from "@/app/actions/admin";

export default async function AdminPage({ searchParams }) {
  const params = await searchParams;
  if (!(await isAdmin())) {
    return (
      <section className="section">
        <div className="container form-narrow">
          <h1 style={{ textAlign: "center" }}>כניסת ניהול</h1>
          <div className="card-elevated">
            {params?.error === "rate_limited" && (
              <div className="alert alert-error">יותר מדי ניסיונות. נסו שוב בעוד כמה דקות.</div>
            )}
            {params?.error && params.error !== "rate_limited" && (
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

  const settings = getSettings();
  const lessons = getLessons();

  return (
    <section className="section">
      <div className="container" style={{ maxWidth: 760 }}>
        <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
          <h1>ניהול האתר</h1>
          <form action={adminLogoutAction}>
            <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
              התנתקות
            </button>
          </form>
        </div>

        {params?.saved === "settings" && (
          <div className="alert alert-success">ההגדרות נשמרו.</div>
        )}
        {params?.saved === "lesson" && (
          <div className="alert alert-success">השינוי בשיעורים נשמר.</div>
        )}
        {params?.error === "lesson_title" && (
          <div className="alert alert-error">יש להזין כותרת לשיעור.</div>
        )}

        <div className="admin-grid">
          <div className="card">
            <h2>הגדרות הקורס</h2>
            <form action={updateSettingsAction}>
              <div className="field">
                <label htmlFor="course_title">שם הקורס</label>
                <input id="course_title" name="course_title" defaultValue={settings.course_title} required />
              </div>
              <div className="field">
                <label htmlFor="course_subtitle">כותרת משנה (מופיעה מתחת לשם בעמוד הבית)</label>
                <input id="course_subtitle" name="course_subtitle" defaultValue={settings.course_subtitle} />
              </div>
              <div className="field">
                <label htmlFor="course_description">תיאור הקורס (אפשר כמה פסקאות, שורה ריקה = פסקה חדשה)</label>
                <textarea
                  id="course_description"
                  name="course_description"
                  rows={6}
                  defaultValue={settings.course_description}
                />
              </div>
              <div className="field">
                <label htmlFor="price">מחיר (₪)</label>
                <input id="price" name="price" type="number" min="0" step="1" defaultValue={settings.price} required />
              </div>
              <button type="submit" className="btn btn-primary">
                שמירת הגדרות
              </button>
            </form>
          </div>

          <div className="card">
            <h2>שיעורים</h2>
            <p className="text-soft">
              הדביקו קישור YouTube, Vimeo, או קישור לקובץ וידאו (mp4). השיעורים מוצגים בעמוד
              הבית ובאזור הקורס לפי שדה הסדר.
            </p>

            {lessons.map((lesson) => (
              <div className="lesson-row" key={lesson.id}>
                <form action={updateLessonAction}>
                  <input type="hidden" name="id" value={lesson.id} />
                  <div className="field">
                    <label>כותרת</label>
                    <input name="title" defaultValue={lesson.title} required />
                  </div>
                  <div className="field">
                    <label>תיאור קצר</label>
                    <input name="description" defaultValue={lesson.description || ""} />
                  </div>
                  <div className="field">
                    <label>קישור לסרטון</label>
                    <input name="video_url" defaultValue={lesson.video_url || ""} />
                  </div>
                  <div className="field">
                    <label>סדר תצוגה</label>
                    <input name="position" type="number" defaultValue={lesson.position} style={{ maxWidth: 100 }} />
                  </div>
                  <div className="row-actions">
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      שמירה
                    </button>
                  </div>
                </form>
                <form action={deleteLessonAction}>
                  <input type="hidden" name="id" value={lesson.id} />
                  <div className="row-actions">
                    <button type="submit" className="muted-link">
                      מחיקת שיעור
                    </button>
                  </div>
                </form>
              </div>
            ))}

            <div className="lesson-row" style={{ borderStyle: "dashed" }}>
              <h3>הוספת שיעור חדש</h3>
              <form action={createLessonAction}>
                <div className="field">
                  <label>כותרת</label>
                  <input name="title" required />
                </div>
                <div className="field">
                  <label>תיאור קצר</label>
                  <input name="description" />
                </div>
                <div className="field">
                  <label>קישור לסרטון</label>
                  <input name="video_url" />
                </div>
                <div className="field">
                  <label>סדר תצוגה</label>
                  <input name="position" type="number" defaultValue={lessons.length + 1} style={{ maxWidth: 100 }} />
                </div>
                <button type="submit" className="btn btn-primary">
                  הוספת שיעור
                </button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
