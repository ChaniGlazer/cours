import { isAdmin } from "@/lib/admin-auth";
import { getSettings, getLessons, getTestimonials } from "@/lib/settings";
import {
  adminLoginAction,
  adminLogoutAction,
  updateSettingsAction,
  createLessonAction,
  updateLessonAction,
  deleteLessonAction,
  createTestimonialAction,
  updateTestimonialAction,
  deleteTestimonialAction
} from "@/app/actions/admin";

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

  const settings = getSettings();
  const lessons = getLessons();
  const testimonials = getTestimonials();

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
        {params?.saved === "testimonial" && (
          <div className="alert alert-success">ההמלצה נשמרה.</div>
        )}
        {params?.error === "lesson_title" && (
          <div className="alert alert-error">יש להזין כותרת לשיעור.</div>
        )}
        {params?.error === "testimonial_fields" && (
          <div className="alert alert-error">יש להזין שם וטקסט המלצה.</div>
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

              <h3 style={{ marginTop: 20 }}>וידאו וסימני אמון (מסך ראשון)</h3>
              <p className="text-soft" style={{ fontSize: "0.9rem" }}>
                דירוג ומספר דירוגים מוצגים באתר רק אם שניהם מלאים - כדי לא להציג נתון חלקי או מזויף.
              </p>
              <div className="field">
                <label htmlFor="hero_video_url">קישור וידאו תדריך קצר (Hero)</label>
                <input id="hero_video_url" name="hero_video_url" defaultValue={settings.hero_video_url} />
              </div>
              <div className="field">
                <label htmlFor="rating_value">דירוג ממוצע (למשל 4.9)</label>
                <input id="rating_value" name="rating_value" defaultValue={settings.rating_value} />
              </div>
              <div className="field">
                <label htmlFor="rating_count">כמות דירוגים/תלמידים (למשל 240+)</label>
                <input id="rating_count" name="rating_count" defaultValue={settings.rating_count} />
              </div>
              <div className="field">
                <label htmlFor="stat_highlight">נתון מספרי בולט (למשל: "72% מהבוגרים דיווחו על שדרוג בשכר תוך 6 חודשים")</label>
                <input id="stat_highlight" name="stat_highlight" defaultValue={settings.stat_highlight} />
              </div>

              <h3 style={{ marginTop: 20 }}>לפני / אחרי הקורס</h3>
              <div className="field">
                <label htmlFor="problem_text">האתגר לפני הקורס</label>
                <textarea id="problem_text" name="problem_text" rows={4} defaultValue={settings.problem_text} />
              </div>
              <div className="field">
                <label htmlFor="outcome_text">התוצאה אחרי הקורס</label>
                <textarea id="outcome_text" name="outcome_text" rows={4} defaultValue={settings.outcome_text} />
              </div>

              <h3 style={{ marginTop: 20 }}>פרופיל המדריך/ה</h3>
              <p className="text-soft" style={{ fontSize: "0.9rem" }}>
                חלק זה יוצג רק אם יש שם למדריך/ה.
              </p>
              <div className="field">
                <label htmlFor="instructor_name">שם המדריך/ה</label>
                <input id="instructor_name" name="instructor_name" defaultValue={settings.instructor_name} />
              </div>
              <div className="field">
                <label htmlFor="instructor_photo_url">קישור לתמונת פרופיל</label>
                <input id="instructor_photo_url" name="instructor_photo_url" defaultValue={settings.instructor_photo_url} />
              </div>
              <div className="field">
                <label htmlFor="instructor_bio">ביוגרפיה קצרה</label>
                <textarea id="instructor_bio" name="instructor_bio" rows={4} defaultValue={settings.instructor_bio} />
              </div>

              <h3 style={{ marginTop: 20 }}>הסרת סיכון</h3>
              <div className="field">
                <label htmlFor="guarantee_text">מדיניות אחריות/החזר כספי (למשל: "30 יום החזר כספי מלא, ללא שאלות")</label>
                <input id="guarantee_text" name="guarantee_text" defaultValue={settings.guarantee_text} />
              </div>

              <button type="submit" className="btn btn-primary">
                שמירת הגדרות
              </button>
            </form>
          </div>

          <div className="card">
            <h2>המלצות תלמידים</h2>
            <p className="text-soft">
              המלצות עם תוצאה מדידה (לא רק ניסוח כללי) הן ההוכחה החברתית האפקטיבית ביותר. הרשימה
              מוצגת באתר רק אם יש בה לפחות המלצה אחת.
            </p>

            {testimonials.map((t) => (
              <div className="lesson-row" key={t.id}>
                <form action={updateTestimonialAction}>
                  <input type="hidden" name="id" value={t.id} />
                  <div className="field">
                    <label>שם</label>
                    <input name="name" defaultValue={t.name} required />
                  </div>
                  <div className="field">
                    <label>תפקיד / הקשר</label>
                    <input name="role" defaultValue={t.role || ""} />
                  </div>
                  <div className="field">
                    <label>ציטוט ההמלצה</label>
                    <textarea name="quote" rows={3} defaultValue={t.quote} required />
                  </div>
                  <div className="field">
                    <label>תוצאה מדידה (אופציונלי)</label>
                    <input name="result" defaultValue={t.result || ""} />
                  </div>
                  <div className="field">
                    <label>קישור לתמונה (אופציונלי)</label>
                    <input name="photo_url" defaultValue={t.photo_url || ""} />
                  </div>
                  <div className="field">
                    <label>סדר תצוגה</label>
                    <input name="position" type="number" defaultValue={t.position} style={{ maxWidth: 100 }} />
                  </div>
                  <div className="row-actions">
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      שמירה
                    </button>
                  </div>
                </form>
                <form action={deleteTestimonialAction}>
                  <input type="hidden" name="id" value={t.id} />
                  <div className="row-actions">
                    <button type="submit" className="muted-link">
                      מחיקת המלצה
                    </button>
                  </div>
                </form>
              </div>
            ))}

            <div className="lesson-row" style={{ borderStyle: "dashed" }}>
              <h3>הוספת המלצה חדשה</h3>
              <form action={createTestimonialAction}>
                <div className="field">
                  <label>שם</label>
                  <input name="name" required />
                </div>
                <div className="field">
                  <label>תפקיד / הקשר</label>
                  <input name="role" />
                </div>
                <div className="field">
                  <label>ציטוט ההמלצה</label>
                  <textarea name="quote" rows={3} required />
                </div>
                <div className="field">
                  <label>תוצאה מדידה (אופציונלי)</label>
                  <input name="result" />
                </div>
                <div className="field">
                  <label>קישור לתמונה (אופציונלי)</label>
                  <input name="photo_url" />
                </div>
                <div className="field">
                  <label>סדר תצוגה</label>
                  <input name="position" type="number" defaultValue={testimonials.length + 1} style={{ maxWidth: 100 }} />
                </div>
                <button type="submit" className="btn btn-primary">
                  הוספת המלצה
                </button>
              </form>
            </div>
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
