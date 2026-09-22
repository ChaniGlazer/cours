import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourses } from "@/lib/courses";
import { getPurchasedCourseIds } from "@/lib/purchases";

export default async function MyCoursesPage() {
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/my-courses");
  }

  const allCourses = await getCourses();
  const purchasedIds = await getPurchasedCourseIds(user.id);
  const myCourses = allCourses.filter((c) => !c.is_paid || purchasedIds.includes(c.id));

  return (
    <section className="section">
      <div className="container">
        <span className="eyebrow">האזור שלי</span>
        <h1 style={{ marginTop: 10 }}>שלום {user.name}</h1>

        {myCourses.length === 0 ? (
          <p className="text-soft" style={{ marginTop: 20 }}>
            עדיין לא נרשמת לאף קורס. <a href="/courses">מוזמנים לעיין בקטלוג הקורסים</a>.
          </p>
        ) : (
          <div className="course-grid" style={{ marginTop: 28 }}>
            {myCourses.map((course) => (
              <div className="course-card" key={course.id}>
                <span className={`course-badge ${course.is_paid ? "course-badge--paid" : "course-badge--free"}`}>
                  {course.is_paid ? "נרכש" : "חינם"}
                </span>
                <h3>{course.title}</h3>
                {course.subtitle && <p className="text-soft">{course.subtitle}</p>}
                <a href={`/courses/${course.id}`} className="btn btn-primary btn-block" style={{ marginTop: "auto" }}>
                  המשך ללימוד
                </a>
              </div>
            ))}
          </div>
        )}

        <p style={{ marginTop: 32 }}>
          <a href="/courses">← לכל הקורסים בקטלוג</a>
        </p>
      </div>
    </section>
  );
}
