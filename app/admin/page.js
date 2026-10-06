import { isAdmin } from "@/lib/admin-auth";
import { getSettings, getAllLessons, getTestimonials } from "@/lib/settings";
import { getCourses } from "@/lib/courses";
import {
  adminLoginAction,
  adminLogoutAction,
  updateSettingsAction,
  createCourseAction,
  updateCourseAction,
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

  const settings = await getSettings();
  const courses = await getCourses();
  const lessons = await getAllLessons();
  const testimonials = await getTestimonials();

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
        {params?.saved === "course" && (
          <div className="alert alert-success">הקורס נשמר.</div>
        )}
        {params?.saved === "lesson" && (
          <div className="alert alert-success">השינוי בשיעורים נשמר.</div>
        )}
        {params?.saved === "testimonial" && (
          <div className="alert alert-success">ההמלצה נשמרה.</div>
        )}
        {params?.error === "course_title" && (
          <div className="alert alert-error">יש להזין כותרת לקורס.</div>
        )}
        {params?.error === "lesson_title" && (
          <div className="alert alert-error">יש להזין כותרת לשיעור ולבחור קורס.</div>
        )}
        {params?.error === "testimonial_fields" && (
          <div className="alert alert-error">יש להזין שם וטקסט המלצה.</div>
        )}

        <div className="admin-grid">
          <div className="card">
            <h2>הגדרות כלליות</h2>
            <p className="text-soft" style={{ fontSize: "0.9rem" }}>
              אלה מוצגות בכל האתר (הדר/פוטר/כותרת), לא בקורס ספציפי - את השם/מחיר/תיאור של כל
              קורס עורכים בכרטיס "קורסים" למטה.
            </p>
            <form action={updateSettingsAction}>
              <div className="field">
                <label htmlFor="site_title">שם האתר (מותג)</label>
                <input id="site_title" name="site_title" defaultValue={settings.site_title} required />
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
            <h2>קורסים</h2>
            <p className="text-soft">
              כל קורס מופיע בקטלוג (/courses) עם התגית "חינם" או המחיר שלו. קורס חדש נוצר תמיד
              כחינמי - יש לסמן "בתשלום" במפורש כדי לחייב רכישה לפני גישה לשיעורים.
            </p>

            {courses.map((course) => (
              <div className="lesson-row" key={course.id}>
                <form action={updateCourseAction}>
                  <input type="hidden" name="id" value={course.id} />
                  <p className="text-soft" style={{ fontSize: "0.85rem" }}>
                    כתובת: /courses/{course.id}
                  </p>
                  <div className="field">
                    <label>כותרת</label>
                    <input name="title" defaultValue={course.title} required />
                  </div>
                  <div className="field">
                    <label>כותרת משנה</label>
                    <input name="subtitle" defaultValue={course.subtitle || ""} />
                  </div>
                  <div className="field">
                    <label>תיאור מלא (שורה ריקה = פסקה חדשה)</label>
                    <textarea name="description" rows={4} defaultValue={course.description || ""} />
                  </div>
                  <div className="field">
                    <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
                      <input type="checkbox" name="is_paid" defaultChecked={Boolean(course.is_paid)} />
                      קורס בתשלום
                    </label>
                  </div>
                  <div className="field">
                    <label>מחיר (₪, רלוונטי רק אם בתשלום)</label>
                    <input
                      name="price_ils"
                      type="number"
                      min="0"
                      step="1"
                      defaultValue={course.price_ils || ""}
                      style={{ maxWidth: 140 }}
                    />
                  </div>
                  <div className="field">
                    <label>סדר תצוגה בקטלוג</label>
                    <input name="position" type="number" defaultValue={course.position} style={{ maxWidth: 100 }} />
                  </div>
                  <div className="row-actions">
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      שמירה
                    </button>
                  </div>
                </form>
              </div>
            ))}

            <div className="lesson-row" style={{ borderStyle: "dashed" }}>
              <h3>יצירת קורס חדש</h3>
              <form action={createCourseAction}>
                <div className="field">
                  <label>כותרת</label>
                  <input name="title" required />
                </div>
                <div className="field">
                  <label>כותרת משנה</label>
                  <input name="subtitle" />
                </div>
                <div className="field">
                  <label>תיאור מלא</label>
                  <textarea name="description" rows={4} />
                </div>
                <div className="field">
                  <label style={{ display: "flex", alignItems: "center", gap: 8 }}>
                    <input type="checkbox" name="is_paid" />
                    קורס בתשלום (ברירת מחדל: חינמי)
                  </label>
                </div>
                <div className="field">
                  <label>מחיר (₪, רלוונטי רק אם בתשלום)</label>
                  <input name="price_ils" type="number" min="0" step="1" style={{ maxWidth: 140 }} />
                </div>
                <button type="submit" className="btn btn-primary">
                  יצירת קורס
                </button>
              </form>
            </div>
          </div>

          <div className="card">
            <h2>המלצות תלמידים</h2>
            <p className="text-soft">
              המלצות עם תוצאה מדידה (לא רק ניסוח כללי) הן ההוכחה החברתית האפקטיבית ביותר. מוצגות
              (אם נבנה להן מקום בעמוד הקורס) רק אם יש לפחות המלצה אחת.
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
              כל שיעור שייך לקורס אחד. אפשר להדביק קישור YouTube/Vimeo/mp4, או קובץ HTML שלם
              (עדיף) - אם יש תוכן HTML הוא זה שיוצג, וקישור הווידאו יתעלם.
            </p>

            {lessons.map((lesson) => (
              <div className="lesson-row" key={lesson.id}>
                <form action={updateLessonAction}>
                  <input type="hidden" name="id" value={lesson.id} />
                  <div className="field">
                    <label>קורס</label>
                    <select name="course_id" defaultValue={lesson.course_id} required>
                      {courses.map((c) => (
                        <option key={c.id} value={c.id}>
                          {c.title}
                        </option>
                      ))}
                    </select>
                  </div>
                  <div className="field">
                    <label>כותרת</label>
                    <input name="title" defaultValue={lesson.title} required />
                  </div>
                  <div className="field">
                    <label>כתובת (slug, אנגלית - קובע את הקישור לשיעור)</label>
                    <input name="slug" dir="ltr" defaultValue={lesson.slug || ""} />
                  </div>
                  <div className="field">
                    <label>תיאור קצר</label>
                    <input name="description" defaultValue={lesson.description || ""} />
                  </div>
                  <div className="field">
                    <label>קישור לסרטון (אופציונלי, רק אם אין תוכן HTML)</label>
                    <input name="video_url" defaultValue={lesson.video_url || ""} />
                  </div>
                  <div className="field">
                    <label>תוכן HTML של השיעור (הדביקו כאן קובץ HTML שלם)</label>
                    <textarea
                      name="html_content"
                      rows={8}
                      dir="ltr"
                      style={{ fontFamily: "monospace", fontSize: "0.85rem" }}
                      defaultValue={lesson.html_content || ""}
                    />
                  </div>
                  <div className="field">
                    <label>סדר תצוגה בתוך הקורס</label>
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
                  <label>קורס</label>
                  <select name="course_id" required defaultValue="">
                    <option value="" disabled>
                      בחרו קורס
                    </option>
                    {courses.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.title}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="field">
                  <label>כותרת</label>
                  <input name="title" required />
                </div>
                <div className="field">
                  <label>כתובת (slug, אנגלית - ריק = ייווצר אוטומטית)</label>
                  <input name="slug" dir="ltr" />
                </div>
                <div className="field">
                  <label>תיאור קצר</label>
                  <input name="description" />
                </div>
                <div className="field">
                  <label>קישור לסרטון (אופציונלי, רק אם אין תוכן HTML)</label>
                  <input name="video_url" />
                </div>
                <div className="field">
                  <label>תוכן HTML של השיעור (הדביקו כאן קובץ HTML שלם)</label>
                  <textarea
                    name="html_content"
                    rows={8}
                    dir="ltr"
                    style={{ fontFamily: "monospace", fontSize: "0.85rem" }}
                  />
                </div>
                <div className="field">
                  <label>סדר תצוגה בתוך הקורס</label>
                  <input name="position" type="number" defaultValue={1} style={{ maxWidth: 100 }} />
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
