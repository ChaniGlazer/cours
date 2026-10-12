import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getSettings, getLessons } from "@/lib/settings";
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
      </div>
    </section>
  );
}
