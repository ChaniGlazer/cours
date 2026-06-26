import { getCurrentUser } from "@/lib/auth";
import { getSettings, getLessons } from "@/lib/settings";

export default async function HomePage() {
  const user = await getCurrentUser();
  const settings = getSettings();
  const lessons = getLessons();

  let ctaHref = "/register";
  let ctaText = "הרשמה והתחלת הלימוד";
  if (user) {
    ctaHref = "/course";
    ctaText = user.paid ? "כניסה לקורס" : "להשלמת ההרשמה והתשלום";
  }

  const price = settings.price || "0";
  const descriptionParagraphs = (settings.course_description || "")
    .split("\n")
    .map((p) => p.trim())
    .filter(Boolean);

  return (
    <>
      <section className="section dark-section">
        <div className="container">
          <span className="eyebrow">קורס וידאו אונליין</span>
          <h1 style={{ marginTop: 14 }}>{settings.course_title}</h1>
          <p className="text-soft" style={{ fontSize: "1.15rem", maxWidth: 560 }}>
            {settings.course_subtitle}
          </p>
          <div style={{ marginTop: 28, display: "flex", gap: 14, flexWrap: "wrap" }}>
            <a href={ctaHref} className="btn btn-primary">
              {ctaText}
            </a>
            <a href="#syllabus" className="btn btn-ghost">
              לתוכן הקורס
            </a>
          </div>
        </div>
      </section>

      {descriptionParagraphs.length > 0 && (
        <section className="section section--tight">
          <div className="container" style={{ maxWidth: 680 }}>
            <span className="eyebrow">על הקורס</span>
            <div style={{ marginTop: 14 }}>
              {descriptionParagraphs.map((p, i) => (
                <p key={i} style={{ fontSize: "1.05rem" }}>
                  {p}
                </p>
              ))}
            </div>
          </div>
        </section>
      )}

      <section className="section" id="syllabus">
        <div className="container">
          <span className="eyebrow">סדר הלימוד</span>
          <h2 style={{ marginTop: 10 }}>מה כלול בקורס</h2>
          <ol className="spine" style={{ marginTop: 36 }}>
            {lessons.map((lesson, idx) => (
              <li key={lesson.id}>
                <span className="spine-num">{idx + 1}</span>
                <h3>{lesson.title}</h3>
                {lesson.description && <p className="text-soft">{lesson.description}</p>}
              </li>
            ))}
          </ol>
        </div>
      </section>

      <section className="section">
        <div className="container" style={{ maxWidth: 480 }}>
          <div className="price-card">
            <span className="eyebrow">הצטרפות לקורס</span>
            <div className="price-amount">
              {price} {settings.currency === "ILS" ? "₪" : settings.currency}
            </div>
            <ul className="price-includes">
              <li>{lessons.length} שיעורי וידאו</li>
              <li>גישה מיידית לאחר התשלום</li>
              <li>צפייה בקצב האישי שלכם, ללא הגבלת זמן</li>
              <li>תשלום מאובטח</li>
            </ul>
            <div>
              <a href={ctaHref} className="btn btn-primary btn-block">
                {ctaText}
              </a>
            </div>
          </div>
        </div>
      </section>

      <section className="section section--tight">
        <div className="container" style={{ maxWidth: 680 }}>
          <span className="eyebrow">שאלות נפוצות</span>
          <h2 style={{ marginTop: 10 }}>שאלות ותשובות</h2>
          <div style={{ marginTop: 20 }}>
            <details className="lesson">
              <summary>איך אני מקבל/ת גישה לקורס אחרי התשלום?</summary>
              <div className="lesson-body text-soft">
                לאחר תשלום מאובטח תועברו אוטומטית לאזור הקורס, ותקבלו גישה מיידית לכל השיעורים
                באותו חשבון שנרשמתם איתו.
              </div>
            </details>
            <details className="lesson">
              <summary>לכמה זמן יש גישה לתוכן?</summary>
              <div className="lesson-body text-soft">
                הגישה אינה מוגבלת בזמן - תוכלו לחזור ולצפות בשיעורים בכל עת מהחשבון שלכם.
              </div>
            </details>
            <details className="lesson">
              <summary>איך מתבצע התשלום?</summary>
              <div className="lesson-body text-soft">
                התשלום מתבצע בדף סליקה מאובטח, ולא נשמרים פרטי כרטיס האשראי באתר זה.
              </div>
            </details>
          </div>
        </div>
      </section>
    </>
  );
}
