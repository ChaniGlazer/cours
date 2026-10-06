import { getCourses } from "@/lib/courses";

export const metadata = {
  title: "קטלוג קורסים"
};

export default async function CoursesCatalogPage({ searchParams }) {
  const params = await searchParams;
  const filter = params?.filter === "free" || params?.filter === "paid" ? params.filter : "all";

  const allCourses = await getCourses();
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

  return (
    <section className="section">
      <div className="container">
        <span className="eyebrow">קטלוג קורסים</span>
        <h1 style={{ marginTop: 10 }}>הקורסים שלנו</h1>
        <p className="text-soft" style={{ maxWidth: 560 }}>
          קורסים בפיתוח בעידן ה-AI - חלקם חינמיים, חלקם בתשלום עם גישה מלאה לאחר רכישה.
        </p>

        <div className="course-tabs">
          {tabs.map((t) => (
            <a
              key={t.key}
              href={t.key === "all" ? "/courses" : `/courses?filter=${t.key}`}
              className={`course-tab${filter === t.key ? " active" : ""}`}
            >
              {t.label}
            </a>
          ))}
        </div>

        {courses.length === 0 ? (
          <p className="text-soft" style={{ marginTop: 24 }}>
            אין כרגע קורסים בקטגוריה הזו.
          </p>
        ) : (
          <div className="course-grid">
            {courses.map((course) => (
              <div className="course-card" key={course.id}>
                <span className={`course-badge ${course.is_paid ? "course-badge--paid" : "course-badge--free"}`}>
                  {course.is_paid ? `₪${course.price_ils}` : "חינם"}
                </span>
                <h3>{course.title}</h3>
                {course.subtitle && <p className="text-soft">{course.subtitle}</p>}
                <a href={`/courses/${course.id}`} className="btn btn-primary btn-block" style={{ marginTop: "auto" }}>
                  {course.is_paid ? "לפרטים והרשמה" : "התחל ללמוד"}
                </a>
              </div>
            ))}
          </div>
        )}
      </div>
    </section>
  );
}
