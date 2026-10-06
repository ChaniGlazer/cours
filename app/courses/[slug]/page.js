import { notFound } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug, getLessonsForCourse } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { startPaymentAction } from "@/app/actions/payment";

export default async function CoursePage({ params, searchParams }) {
  const { slug } = await params;
  const query = await searchParams;
  const course = await getCourseBySlug(slug);
  if (!course) notFound();

  const user = await getCurrentUser();
  const purchased = course.is_paid && user ? await hasPurchasedCourse(user.id, course.id) : false;
  const hasAccess = !course.is_paid || purchased;

  const lessons = await getLessonsForCourse(course.id);

  return (
    <>
      <section className="section dark-section hero-section">
        <div className="container">
          <span className={`course-badge ${course.is_paid ? "course-badge--paid" : "course-badge--free"}`}>
            {course.is_paid ? `₪${course.price_ils}` : "חינם"}
          </span>
          <h1 style={{ marginTop: 14 }}>{course.title}</h1>
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

          <div style={{ marginTop: 28, display: "flex", gap: 14, flexWrap: "wrap" }}>
            {course.is_paid && !hasAccess ? (
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
              lessons.length > 0 && (
                <a href={`/courses/${course.id}/${lessons[0].slug}`} className="btn btn-primary">
                  {hasAccess ? "המשך ללימוד" : "התחל ללמוד"}
                </a>
              )
            )}
            <a href="#syllabus" className="btn btn-ghost">
              לתוכן הקורס
            </a>
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

          {lessons.length === 0 ? (
            <p className="text-soft" style={{ marginTop: 20 }}>
              השיעורים יתעדכנו כאן בקרוב.
            </p>
          ) : (
            <ol className="spine" style={{ marginTop: 36 }}>
              {lessons.map((lesson, idx) => {
                const locked = course.is_paid && !hasAccess && idx > 0;
                return (
                  <li key={lesson.id}>
                    <span className="spine-num">{locked ? "🔒" : idx + 1}</span>
                    {locked ? (
                      <h3 className="text-soft">{lesson.title}</h3>
                    ) : (
                      <h3>
                        <a href={`/courses/${course.id}/${lesson.slug}`}>{lesson.title}</a>
                      </h3>
                    )}
                    {lesson.description && <p className="text-soft">{lesson.description}</p>}
                  </li>
                );
              })}
            </ol>
          )}
        </div>
      </section>
    </>
  );
}
