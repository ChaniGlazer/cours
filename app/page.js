import { getCurrentUser } from "@/lib/auth";
import { getSettings, getLessons, getTestimonials } from "@/lib/settings";
import { parseVideoEmbed } from "@/lib/video";
import MobileStickyCta from "@/app/components/MobileStickyCta";

function Stars() {
  return (
    <span aria-hidden="true" style={{ color: "var(--gold)", letterSpacing: "1px" }}>
      ★★★★★
    </span>
  );
}

export default async function HomePage() {
  const user = await getCurrentUser();
  const settings = getSettings();
  const lessons = getLessons();
  const testimonials = getTestimonials();

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

  const heroEmbed = parseVideoEmbed(settings.hero_video_url);
  const showTrustBanner = Boolean(settings.rating_value && settings.rating_count);
  const showTransformation = Boolean(settings.problem_text || settings.outcome_text);
  const showInstructor = Boolean(settings.instructor_name);
  const showTestimonials = testimonials.length > 0;
  const showGuarantee = Boolean(settings.guarantee_text);

  return (
    <>
      <section className="section dark-section hero-section">
        <div className={`container hero-grid${heroEmbed ? " hero-grid--split" : ""}`}>
          <div>
            <span className="eyebrow">קורס וידאו אונליין</span>
            <h1 style={{ marginTop: 14 }}>{settings.course_title}</h1>
            <p className="text-soft" style={{ fontSize: "1.15rem", maxWidth: 560 }}>
              {settings.course_subtitle}
            </p>

            {showTrustBanner && (
              <p style={{ display: "flex", alignItems: "center", gap: 8, fontSize: "0.95rem" }}>
                <Stars />
                <span>
                  {settings.rating_value} מתוך 5 ({settings.rating_count} תלמידים)
                </span>
              </p>
            )}

            <div style={{ marginTop: 28, display: "flex", gap: 14, flexWrap: "wrap" }}>
              <a href={ctaHref} className="btn btn-primary">
                {ctaText}
              </a>
              <a href="#syllabus" className="btn btn-ghost">
                לתוכן הקורס
              </a>
            </div>

            <p className="text-soft" style={{ marginTop: 14, fontSize: "0.9rem" }}>
              ✓ גישה לכל החיים &nbsp; ✓ תשלום מאובטח
              {showGuarantee ? <> &nbsp; ✓ {settings.guarantee_text}</> : null}
            </p>
          </div>

          {heroEmbed && (
            <div className="video-wrap hero-video">
              {heroEmbed.type === "video" ? (
                <video controls src={heroEmbed.src} />
              ) : (
                <iframe
                  src={heroEmbed.src}
                  allow="autoplay; fullscreen; picture-in-picture"
                  allowFullScreen
                  title={`תצוגה מקדימה - ${settings.course_title}`}
                />
              )}
            </div>
          )}
        </div>
      </section>

      {showTrustBanner && settings.stat_highlight && (
        <section className="trust-banner">
          <div className="container">
            <p>{settings.stat_highlight}</p>
          </div>
        </section>
      )}

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

      {showTransformation && (
        <section className="section section--tight">
          <div className="container">
            <span className="eyebrow">לפני ואחרי</span>
            <h2 style={{ marginTop: 10 }}>מה משתנה כשלומדים את הקורס</h2>
            <div className="transformation-grid" style={{ marginTop: 28 }}>
              <div className="transformation-card transformation-card--before">
                <span className="eyebrow">לפני</span>
                <p>{settings.problem_text}</p>
              </div>
              <div className="transformation-card transformation-card--after">
                <span className="eyebrow">אחרי</span>
                <p>{settings.outcome_text}</p>
              </div>
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

      {showInstructor && (
        <section className="section section--tight">
          <div className="container" style={{ maxWidth: 760 }}>
            <span className="eyebrow">מי מלמד/ת</span>
            <div className="instructor-block" style={{ marginTop: 20 }}>
              {settings.instructor_photo_url && (
                <img
                  className="instructor-photo"
                  src={settings.instructor_photo_url}
                  alt={settings.instructor_name}
                />
              )}
              <div>
                <h3>{settings.instructor_name}</h3>
                {settings.instructor_bio && <p className="text-soft">{settings.instructor_bio}</p>}
              </div>
            </div>
          </div>
        </section>
      )}

      {showTestimonials && (
        <section className="section">
          <div className="container">
            <span className="eyebrow">מה אומרים הבוגרים</span>
            <h2 style={{ marginTop: 10 }}>הוכחה חברתית</h2>
            <div className="testimonial-grid" style={{ marginTop: 28 }}>
              {testimonials.map((t) => (
                <figure className="testimonial-card" key={t.id}>
                  {t.photo_url && <img src={t.photo_url} alt={t.name} className="testimonial-photo" />}
                  <blockquote>&laquo;{t.quote}&raquo;</blockquote>
                  {t.result && <p className="testimonial-result">{t.result}</p>}
                  <figcaption>
                    <strong>{t.name}</strong>
                    {t.role && <span className="text-soft"> · {t.role}</span>}
                  </figcaption>
                </figure>
              ))}
            </div>
          </div>
        </section>
      )}

      <section className="section" style={{ paddingTop: 0 }}>
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
              {showGuarantee && <li>{settings.guarantee_text}</li>}
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
            {showGuarantee && (
              <details className="lesson">
                <summary>מה מדיניות הביטולים וההחזרים?</summary>
                <div className="lesson-body text-soft">{settings.guarantee_text}</div>
              </details>
            )}
          </div>
        </div>
      </section>

      <section className="section dark-section" style={{ textAlign: "center" }}>
        <div className="container">
          <h2>מוכנים להתחיל?</h2>
          <p className="text-soft" style={{ maxWidth: 480, margin: "0 auto" }}>
            {settings.course_subtitle}
          </p>
          <div style={{ marginTop: 24 }}>
            <a href={ctaHref} className="btn btn-primary">
              {ctaText}
            </a>
          </div>
        </div>
      </section>

      <MobileStickyCta href={ctaHref} text={ctaText} price={price} currency={settings.currency} />
    </>
  );
}
