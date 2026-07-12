import { isAdmin } from "@/lib/admin-auth";
import { getSettings, getLessons } from "@/lib/settings";
import { getCoupons, formatDiscount } from "@/lib/coupons";
import { getRecentPayments } from "@/lib/payments";
import {
  adminLoginAction,
  adminLogoutAction,
  updateSettingsAction,
  createLessonAction,
  updateLessonAction,
  deleteLessonAction,
  createCouponAction,
  toggleCouponAction,
  deleteCouponAction,
  recheckPaymentAction,
  markPaymentPaidAction
} from "@/app/actions/admin";

const PAYMENT_STATUS_LABELS = {
  pending: "ממתין",
  paid: "שולם",
  failed: "נכשל"
};

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
  const coupons = getCoupons();
  const payments = getRecentPayments();
  const currencySymbol = settings.currency === "ILS" ? "₪" : settings.currency;

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
        {params?.saved === "coupon" && (
          <div className="alert alert-success">השינוי בקופונים נשמר.</div>
        )}
        {params?.saved === "payment_paid" && (
          <div className="alert alert-success">התשלום סומן כשולם, ולמשתמש נפתחה גישה לקורס.</div>
        )}
        {params?.saved === "payment_failed" && (
          <div className="alert alert-error">מול Invoice4U התשלום הזה נכשל - סומן בהתאם.</div>
        )}
        {params?.saved === "payment_still_pending" && (
          <div className="alert alert-error">התשלום עדיין ממתין אצל Invoice4U - נסו לבדוק שוב מאוחר יותר.</div>
        )}
        {params?.error === "lesson_title" && (
          <div className="alert alert-error">יש להזין כותרת לשיעור.</div>
        )}
        {params?.error === "coupon_invalid" && (
          <div className="alert alert-error">יש להזין קוד קופון, סוג הנחה וערך הנחה חיובי.</div>
        )}
        {params?.error === "coupon_duplicate" && (
          <div className="alert alert-error">קוד הקופון הזה כבר קיים.</div>
        )}
        {params?.error === "payment_check_failed" && (
          <div className="alert alert-error">הבדיקה מול Invoice4U נכשלה. נסו שוב, או סמנו את התשלום כשולם ידנית.</div>
        )}
        {params?.error === "payment_not_found" && (
          <div className="alert alert-error">התשלום לא נמצא.</div>
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

          <div className="card">
            <h2>קופוני הנחה</h2>
            <p className="text-soft">
              לקוח שמזין קוד קופון תקף בעמוד התשלום יקבל את ההנחה על מחיר הקורס.
            </p>

            {coupons.map((coupon) => (
              <div className="lesson-row" key={coupon.id}>
                <div className="field">
                  <strong>{coupon.code}</strong> - הנחה של {formatDiscount(coupon)}
                </div>
                <p className="text-soft" style={{ margin: 0 }}>
                  שימושים: {coupon.used_count}
                  {coupon.max_uses != null ? ` מתוך ${coupon.max_uses}` : " (ללא הגבלה)"}
                  {coupon.expires_at &&
                    ` · בתוקף עד ${new Date(coupon.expires_at).toLocaleDateString("he-IL")}`}
                  {!coupon.active && " · מושבת"}
                </p>
                <div className="row-actions" style={{ marginTop: 10 }}>
                  <form action={toggleCouponAction}>
                    <input type="hidden" name="id" value={coupon.id} />
                    <input type="hidden" name="active" value={coupon.active ? "0" : "1"} />
                    <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                      {coupon.active ? "השבתה" : "הפעלה"}
                    </button>
                  </form>
                  <form action={deleteCouponAction}>
                    <input type="hidden" name="id" value={coupon.id} />
                    <button type="submit" className="muted-link">
                      מחיקת קופון
                    </button>
                  </form>
                </div>
              </div>
            ))}

            <div className="lesson-row" style={{ borderStyle: "dashed" }}>
              <h3>הוספת קופון חדש</h3>
              <form action={createCouponAction}>
                <div className="field">
                  <label>קוד קופון</label>
                  <input name="code" placeholder="למשל: SUMMER25" required />
                </div>
                <div className="field">
                  <label>סוג הנחה</label>
                  <select name="discount_type" defaultValue="percent">
                    <option value="percent">אחוזים</option>
                    <option value="amount">סכום קבוע (₪)</option>
                  </select>
                </div>
                <div className="field">
                  <label>ערך ההנחה</label>
                  <input name="discount_value" type="number" min="0" step="0.01" required />
                </div>
                <div className="field">
                  <label>מספר שימושים מקסימלי (אופציונלי)</label>
                  <input name="max_uses" type="number" min="1" step="1" />
                </div>
                <div className="field">
                  <label>תוקף עד תאריך (אופציונלי)</label>
                  <input name="expires_at" type="date" />
                </div>
                <button type="submit" className="btn btn-primary">
                  הוספת קופון
                </button>
              </form>
            </div>
          </div>

          <div className="card">
            <h2>תשלומים אחרונים</h2>
            <p className="text-soft">
              Invoice4U לא שולח לנו התראה אוטומטית על תשלום שהושלם - האתר מתעדכן כשהמשתמש
              נשאר בדף האישור עד שהתשלום מאומת. אם משתמש שילם אך התשלום נשאר &quot;ממתין&quot;
              (למשל סגר את הדפדפן באמצע), אפשר לבדוק כאן שוב מול הסליקה, או לסמן ידנית כשולם.
            </p>

            {payments.length === 0 && <p className="text-soft">עדיין אין תשלומים.</p>}

            {payments.map((payment) => (
              <div className="lesson-row" key={payment.id}>
                <div className="field">
                  <strong>{payment.user_name}</strong> ({payment.user_email})
                </div>
                <p className="text-soft" style={{ margin: 0 }}>
                  {payment.amount} {currencySymbol} · {PAYMENT_STATUS_LABELS[payment.status] || payment.status} ·{" "}
                  {new Date(payment.created_at).toLocaleString("he-IL")}
                  {payment.coupon_code && ` · קופון: ${payment.coupon_code}`}
                </p>
                {payment.status !== "paid" && (
                  <div className="row-actions" style={{ marginTop: 10 }}>
                    <form action={recheckPaymentAction}>
                      <input type="hidden" name="id" value={payment.id} />
                      <button type="submit" className="btn btn-ghost" style={{ padding: "8px 18px" }}>
                        בדיקה שוב מול הסליקה
                      </button>
                    </form>
                    <form action={markPaymentPaidAction}>
                      <input type="hidden" name="id" value={payment.id} />
                      <button type="submit" className="muted-link">
                        סימון ידני כשולם
                      </button>
                    </form>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
