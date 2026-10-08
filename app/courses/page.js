import { getCourses, getLessonsByCourse } from "@/lib/courses";
import { Chip, CourseBadge } from "@/app/components/ui";
import { CardAction, ResumeCard } from "@/app/components/CourseClient";

export const metadata = {
  title: "קטלוג קורסים בפייתון ו-AI בעברית",
  description:
    "קטלוג קורסים בעברית: לימוד פייתון אינטראקטיבי בחינם ופיתוח אפליקציות מבוססות AI. שיעורים עם תרגילים ובדיקה אוטומטית.",
  alternates: { canonical: "/courses" }
};

export default async function CoursesCatalogPage({ searchParams }) {
  const params = await searchParams;
  const filter = params?.filter === "free" || params?.filter === "paid" ? params.filter : "all";

  const allCourses = await getCourses();
  const lessonsByCourse = await getLessonsByCourse();
  const courses = allCourses.filter((c) => {
    if (filter === "free") return !c.is_paid;
    if (filter === "paid") return Boolean(c.is_paid);
    return true;
  });

  const tabs = [
    { key: "all", label: "הכל" },
    { key: "free", label: "חינמי" },
    { key: "paid", label: "בתשלום" }
  ];

  // כרטיס "המשך מהמקום שעצרת" רלוונטי רק לקורסים שאפשר ללמוד בהם עכשיו.
  const resumable = allCourses
    .filter((c) => !c.coming_soon && !c.is_paid)
    .map((c) => ({ id: c.id, title: c.title, lessons: lessonsByCourse[c.id] || [] }))
    .filter((c) => c.lessons.length > 0);

  return (
    <section className="section">
      <div className="container">
        <div className="catalog-hero">
          <span className="eyebrow">קטלוג קורסים</span>
          <h1 style={{ marginTop: 10 }}>הקורסים שלנו</h1>
          <p style={{ fontWeight: 600 }}>חני שטיינמץ – מורה למדעי המחשב</p>
          <p className="text-soft">
            קורסים בפיתוח בעידן ה-AI - חלקם חינמיים, חלקם בתשלום עם גישה מלאה לאחר רכישה.
          </p>
        </div>

        <nav className="ui-chips" aria-label="סינון קורסים">
          {tabs.map((t) => (
            <Chip key={t.key} href={t.key === "all" ? "/courses" : `/courses?filter=${t.key}`} active={filter === t.key}>
              {t.label}
            </Chip>
          ))}
        </nav>

        <ResumeCard courses={resumable} />

        {courses.length === 0 ? (
          <p className="text-soft" style={{ marginTop: 24 }}>
            אין כרגע קורסים בקטגוריה הזו.
          </p>
        ) : (
          <div className="course-grid">
            {courses.map((course) => {
              const lessons = lessonsByCourse[course.id] || [];
              const soon = Boolean(course.coming_soon);
              return (
                <article className={`course-card${soon ? " is-soon" : ""}`} key={course.id}>
                  <div className="course-card__cover" aria-hidden="true">
                    {"</>"}
                  </div>
                  <div className="course-card__body">
                    <CourseBadge course={course} />
                    <h3>{course.title}</h3>
                    {course.subtitle && <p className="text-soft">{course.subtitle}</p>}
                    <div className="course-card__meta">
                      {lessons.length > 0 && <span>{lessons.length} שיעורים</span>}
                    </div>
                  </div>
                  <div className="course-card__foot">
                    {soon ? (
                      <span className="btn btn-off btn-block" aria-disabled="true">
                        נפתח בקרוב
                      </span>
                    ) : course.is_paid ? (
                      <a href={`/courses/${course.id}`} className="btn btn-primary btn-block">
                        לפרטים והרשמה
                      </a>
                    ) : lessons.length > 0 ? (
                      <CardAction courseId={course.id} slugs={lessons.map((l) => l.slug)} />
                    ) : (
                      <a href={`/courses/${course.id}`} className="btn btn-primary btn-block">
                        לפרטים
                      </a>
                    )}
                  </div>
                </article>
              );
            })}
          </div>
        )}
      </div>
    </section>
  );
}
