import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getSettings, getLessons, getUserTestimonial } from "@/lib/settings";
import { submitTestimonialAction } from "@/app/actions/testimonial";
import { parseVideoEmbed } from "@/lib/video";
import { startPaymentAction } from "@/app/actions/payment";

export default async function CoursePage({ searchParams }) {
  const params = await searchParams;
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }

  const settings = getSettings();

  if (!user.paid) {
    return (
      <section className="section">
        <div className="container" style={{ maxWidth: 520 }}>
          <span className="eyebrow">שלב אחרון</span>
          <h1>תשלום וקבלת גישה</h1>
          <p className="text-soft">
            שלום {user.name}, נשאר רק לבצע תשלום מאובטח כדי לקבל גישה מיידית לכל שיעורי הקורס.
          </p>

          {params?.error === "price_not_set" && (
            <div className="alert alert-error">
              לא הוגדר מחיר לקורס. יש להגדיר מחיר בעמוד הניהול (/admin) ולנסות שוב.
            </div>
          )}

          <div className="price-card" style={{ marginTop: 24 }}>
            <span className="eyebrow">{settings.course_title}</span>
            <div className="price-amount">
              {settings.price} {settings.currency === "ILS" ? "₪" : settings.currency}
            </div>
            <form action={startPaymentAction}>
              <button type="submit" className="btn btn-primary btn-block">
                לתשלום מאובטח
              </button>
            </form>
          </div>
        </div>
      </section>
    );
  }

  const lessons = getLessons();
  const myTestimonial = getUserTestimonial(user.id);

  return (
    <section className="section">
      <div className="container" style={{ maxWidth: 760 }}>
        <span className="eyebrow">האזור האישי שלך</span>
        <h1>{settings.course_title}</h1>
        <p className="text-soft">שלום {user.name}, בהצלחה בלימודים!</p>

        <div style={{ marginTop: 28 }}>
          {lessons.map((lesson, idx) => {
            const embed = parseVideoEmbed(lesson.video_url);
            return (
              <details key={lesson.id} className="lesson" open={idx === 0}>
                <summary>
                  <span className="lesson-num">{idx + 1}</span>
                  {lesson.title}
                </summary>
                <div className="lesson-body">
                  {lesson.description && <p className="text-soft">{lesson.description}</p>}
                  {embed ? (
                    <div className="video-wrap">
                      {embed.type === "video" ? (
                        <video controls src={embed.src} />
                      ) : (
                        <iframe
                          src={embed.src}
                          allow="autoplay; fullscreen; picture-in-picture"
                          allowFullScreen
                          title={lesson.title}
                        />
                      )}
                    </div>
                  ) : (
                    <p className="text-soft">קישור לסרטון יתעדכן כאן בקרוב.</p>
                  )}
                </div>
              </details>
            );
          })}
        </div>

        <div className="card" style={{ marginTop: 36 }}>
          <h2>{myTestimonial ? "ההמלצה שלך" : "איך היה הקורס?"}</h2>
          <p className="text-soft">
            ההמלצה תפורסם באתר לאחר אישור, עם סימון שהיא נכתבה על ידי תלמיד/ה שרכש/ה את הקורס.
          </p>
          {params?.testimonial === "sent" && (
            <div className="alert alert-success">תודה! ההמלצה התקבלה ותפורסם לאחר אישור.</div>
          )}
          {params?.testimonial === "invalid" && (
            <div className="alert alert-error">יש לבחור דירוג ולכתוב לפחות כמה מילים.</div>
          )}
          {myTestimonial && (
            <p className="text-soft">
              סטטוס:{" "}
              {myTestimonial.status === "approved"
                ? "פורסמה"
                : myTestimonial.status === "rejected"
                  ? "לא אושרה לפרסום"
                  : "ממתינה לאישור"}
              . שמירה מחדש תעדכן את ההמלצה ותחזיר אותה לאישור.
            </p>
          )}
          <form action={submitTestimonialAction}>
            <div className="field">
              <label htmlFor="rating">דירוג</label>
              <select id="rating" name="rating" defaultValue={myTestimonial?.rating || ""} required>
                <option value="" disabled>
                  בחרו דירוג
                </option>
                {[5, 4, 3, 2, 1].map((n) => (
                  <option key={n} value={n}>
                    {"★".repeat(n)} ({n})
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label htmlFor="quote">ההמלצה שלך</label>
              <textarea id="quote" name="quote" rows={4} maxLength={1200} defaultValue={myTestimonial?.quote || ""} required />
            </div>
            <div className="field">
              <label htmlFor="result">מה השגת בעקבות הקורס? (אופציונלי)</label>
              <input id="result" name="result" maxLength={200} defaultValue={myTestimonial?.result || ""} />
            </div>
            <div className="field">
              <label htmlFor="role">תפקיד / הקשר (אופציונלי)</label>
              <input id="role" name="role" maxLength={80} defaultValue={myTestimonial?.role || ""} />
            </div>
            <button type="submit" className="btn btn-primary">
              {myTestimonial ? "עדכון ההמלצה" : "שליחת המלצה"}
            </button>
          </form>
        </div>
      </div>
    </section>
  );
}
