import { notFound } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getSettings } from "@/lib/settings";
import { getCourseBySlug, getLessonsForCourse } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { isAdmin } from "@/lib/admin-auth";
import { getApprovedTestimonials, getUserTestimonial } from "@/lib/testimonials";
import TestimonialForm from "./TestimonialForm";
import { CourseBadge } from "@/app/components/ui";
import { CourseCta, CourseProgress, Syllabus } from "@/app/components/CourseClient";
import { GLOW_COURSES } from "@/lib/lessonTheme";
import { startPaymentAction } from "@/app/actions/payment";
import { absoluteUrl, toDescription, jsonLdString, AUTHOR_NAME, SITE_URL, OG_IMAGES } from "@/lib/seo";

export async function generateMetadata({ params }) {
  const { slug } = await params;
  const course = await getCourseBySlug(slug);
  if (!course) return { title: "הקורס לא נמצא", robots: { index: false } };
  const description = toDescription(course.description, course.subtitle || course.title);
  const path = `/courses/${course.id}`;
  return {
    title: course.title,
    description,
    alternates: { canonical: path },
    // קורס "בקרוב" לא נכנס למנועי חיפוש (ואינו ב-sitemap), עד שיפתח.
    ...(course.coming_soon ? { robots: { index: false, follow: true } } : {}),
    openGraph: { type: "website", locale: "he_IL", url: path, title: course.title, description, images: OG_IMAGES }
  };
}

export default async function CoursePage({ params, searchParams }) {
  const { slug } = await params;
  const query = await searchParams;
  const course = await getCourseBySlug(slug);
  if (!course) notFound();

  const user = await getCurrentUser();
  const purchased = course.is_paid && user ? await hasPurchasedCourse(user.id, course.id) : false;
  const ownsCourse = !course.is_paid || purchased;
  // מנהל מחובר (סיסמת /admin) רואה את כל השיעורים בלי תשלום, וגם קורס "בקרוב" כתצוגה מקדימה.
  // קורס "בקרוב" סגור לכל השאר, גם אם הוא חינמי: אין רשימת שיעורים ואין כפתור כניסה.
  const admin = await isAdmin();
  const hasAccess = course.coming_soon ? admin : ownsCourse || admin;

  const lessons = await getLessonsForCourse(course.id);
  const openSlugs = lessons.filter((_, i) => !(course.is_paid && !hasAccess && i > 0)).map((l) => l.slug);
  const testimonials = await getApprovedTestimonials(course.id);
  const canReview = Boolean(user) && ownsCourse && !course.coming_soon;
  const myTestimonial = canReview ? await getUserTestimonial(user.id, course.id) : null;

  // Course לפי הדרישות של Google: name, description ו-provider (הארגון שמפרסם: האתר עצמו). המדריכה היא instructor של המופע המקוון.
  // אין courseWorkload, כי אין לנו נתון אמיתי על משך הקורס.
  const settings = await getSettings();
  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Course",
    name: course.title,
    description: toDescription(course.description, course.subtitle || course.title),
    url: absoluteUrl(`/courses/${course.id}`),
    inLanguage: "he",
    provider: { "@type": "Organization", name: settings.site_title || "קורסים בעידן ה-AI", url: SITE_URL },
    offers: {
      "@type": "Offer",
      category: course.is_paid ? "Paid" : "Free",
      price: course.is_paid ? String(course.price_ils || 0) : "0",
      priceCurrency: "ILS",
      url: absoluteUrl(`/courses/${course.id}`),
      availability: course.coming_soon ? "https://schema.org/PreOrder" : "https://schema.org/InStock"
    },
    hasCourseInstance: {
      "@type": "CourseInstance",
      courseMode: "online",
      instructor: { "@type": "Person", name: AUTHOR_NAME }
    }
  };

  return (
    <div className={GLOW_COURSES.includes(course.id) ? "vibe-bg" : undefined}>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(jsonLd) }} />
      <section className="section dark-section course-hero">
        <div className="container">
          <nav className="crumbs" aria-label="פירורי לחם">
            <a href="/courses">קורסים</a>
            <span aria-hidden="true">›</span>
            <span>{course.title}</span>
          </nav>
          <CourseBadge course={course} />
          <h1>{course.title}</h1>
          {course.subtitle && (
            <p className="text-soft" style={{ fontSize: "1.15rem", maxWidth: 560 }}>
              {course.subtitle}
            </p>
          )}

          {query?.error === "price_not_set" && (
            <div className="alert alert-error" style={{ marginTop: 16, maxWidth: 480 }}>
              לא הוגדר מחיר לקורס הזה. יש להגדיר מחיר בעמוד הניהול (/admin) ולנסות שוב.
            </div>
          )}

          <div className="course-hero__actions">
            {course.coming_soon && !hasAccess ? (
              <span className="btn btn-off" aria-disabled="true">
                הקורס ייפתח בקרוב
              </span>
            ) : course.is_paid && !hasAccess ? (
              user ? (
                <form action={startPaymentAction.bind(null, course.id)}>
                  <button type="submit" className="btn btn-primary">
                    לרכישה - ₪{course.price_ils}
                  </button>
                </form>
              ) : (
                <a href={`/login?next=${encodeURIComponent(`/courses/${course.id}`)}`} className="btn btn-primary">
                  התחברות/הרשמה לרכישה
                </a>
              )
            ) : (
              openSlugs.length > 0 && (
                <>
                  <CourseCta courseId={course.id} slugs={openSlugs} />
                  <CourseProgress courseId={course.id} slugs={openSlugs} />
                </>
              )
            )}
          </div>
        </div>
      </section>

      {course.description && (
        <section className="section section--tight">
          <div className="container" style={{ maxWidth: 680 }}>
            <span className="eyebrow">על הקורס</span>
            <div style={{ marginTop: 14 }}>
              {course.description
                .split("\n")
                .map((p) => p.trim())
                .filter(Boolean)
                .map((p, i) => (
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
          <span className="eyebrow">סילבוס</span>
          <h2 style={{ marginTop: 10 }}>שיעורי הקורס</h2>

          {course.coming_soon && !hasAccess ? (
            <div className="notice-soon">
              הקורס הזה עדיין בהכנה ויפתח בקרוב. בינתיים אפשר לעבור לקורסים האחרים בקטלוג.{" "}
              <a href="/courses">לקטלוג הקורסים</a>
            </div>
          ) : lessons.length === 0 ? (
            <p className="text-soft" style={{ marginTop: 20 }}>
              השיעורים יתעדכנו כאן בקרוב.
            </p>
          ) : (
            <Syllabus
              courseId={course.id}
              lessons={lessons.map((l, i) => ({
                slug: l.slug,
                title: l.title,
                description: l.description,
                locked: course.is_paid && !hasAccess && i > 0
              }))}
            />
          )}
        </div>
      </section>

      {(testimonials.length > 0 || canReview) && (
        <section className="section section--tight" id="testimonials">
          <div className="container">
            <span className="eyebrow">המלצות</span>
            <h2 style={{ marginTop: 10 }}>מה אומרים התלמידים</h2>

            {testimonials.length === 0 && (
              <p className="empty-note">עדיין אין המלצות על הקורס. אחרי שתסיימו ללמוד, אפשר להיות הראשונים לכתוב.</p>
            )}

            {testimonials.length > 0 && (
              <div className="testimonial-grid">
                {testimonials.map((t) => (
                  <figure className="testimonial-card" key={t.id}>
                    <blockquote>“{t.quote}”</blockquote>
                    {t.result && <p className="testimonial-card__result">✓ {t.result}</p>}
                    <figcaption>
                      {t.photo_url && <img src={t.photo_url} alt="" width="40" height="40" loading="lazy" />}
                      <span>
                        <strong>{t.name}</strong>
                        {t.role && <small>{t.role}</small>}
                      </span>
                    </figcaption>
                  </figure>
                ))}
              </div>
            )}

            {!course.coming_soon && (
              <div style={{ marginTop: 32, maxWidth: 640 }}>
                {canReview ? (
                  <TestimonialForm courseId={course.id} defaultName={user.name} existing={myTestimonial} />
                ) : !user ? (
                  <p className="text-soft">
                    למדתם בקורס?{" "}
                    <a href={`/login?next=${encodeURIComponent(`/courses/${course.id}#testimonials`)}`}>
                      התחברו כדי לכתוב המלצה
                    </a>
                    .
                  </p>
                ) : (
                  <p className="text-soft">כתיבת המלצה פתוחה לתלמידים שרכשו את הקורס.</p>
                )}
              </div>
            )}
          </div>
        </section>
      )}
    </div>
  );
}
