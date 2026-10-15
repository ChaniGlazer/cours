import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourses, getLessonsByCourse } from "@/lib/courses";
import { getPurchasedCourseIds } from "@/lib/purchases";
import { tutorVisibleFor } from "@/lib/tutorAccess";
import { TUTOR_COURSES } from "@/lib/tutorCourses";
import MyArea from "@/app/components/MyArea";
import "./my-area.css";

export default async function MyCoursesPage() {
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/my-courses");
  }

  const allCourses = await getCourses();
  const lessonsByCourse = await getLessonsByCourse();
  const purchasedIds = await getPurchasedCourseIds(user.id);

  // "הקורסים שלי": קורסים שאפשר ללמוד בהם עכשיו (חינמיים, או בתשלום ונרכשו). קורס "בקרוב" עובר ל"עוד קורסים".
  const mine = allCourses.filter((c) => !c.coming_soon && (!c.is_paid || purchasedIds.includes(c.id)));
  const mineIds = new Set(mine.map((c) => c.id));
  const others = allCourses.filter((c) => !mineIds.has(c.id));

  // לרכיב ה-client עוברים רק השדות שהוא צריך (serializable): ההתקדמות עצמה נקראת שם מה-localStorage.
  const clientCourses = mine.map((c) => ({
    id: c.id,
    title: c.title,
    subtitle: c.subtitle || "",
    is_paid: Boolean(c.is_paid),
    lessons: lessonsByCourse[c.id] || []
  }));

  const firstName = String(user.name || "").trim().split(/\s+/)[0] || "";
  // רמז על החונכת רק אם היא פעילה עבור המשתמשת (לפי השרת) ויש לה קורס שהחונכת פעילה בו.
  const showTutorHint = tutorVisibleFor(user) && mine.some((c) => TUTOR_COURSES.includes(c.id));

  return (
    <div className="ma">
      <div className="container ma-wrap">
        <MyArea firstName={firstName} courses={clientCourses} />

        {others.length > 0 && (
          <section className="ma-section" aria-labelledby="ma-more-h">
            <h2 className="ma-section__h" id="ma-more-h">
              עוד קורסים בשבילך
            </h2>
            <ul className="ma-grid ma-grid--small" role="list">
              {others.map((c) => (
                <li className="ma-li" key={c.id}>
                  <article className="ma-mini" aria-labelledby={`ma-m-${c.id}`}>
                    <span className={`ui-badge ${c.coming_soon ? "ui-badge--soon" : "ui-badge--paid"}`}>
                      {c.coming_soon ? "בקרוב" : `₪${c.price_ils}`}
                    </span>
                    <h3 className="ma-mini__title" id={`ma-m-${c.id}`}>
                      {c.title}
                    </h3>
                    {c.subtitle && <p className="ma-mini__sub">{c.subtitle}</p>}
                    <a href={`/courses/${c.id}`} className="ma-mini__link">
                      לעמוד הקורס
                      <span className="sr-only"> {c.title}</span>
                      <span aria-hidden="true"> ←</span>
                    </a>
                  </article>
                </li>
              ))}
            </ul>
          </section>
        )}

        <footer className="ma-foot">
          <a href="/courses" className="ma-foot__link">
            ← לכל הקורסים בקטלוג
          </a>
          {showTutorHint && (
            <p className="ma-foot__hint">
              <span aria-hidden="true">💡</span> בשיעורי הפייתון יש חונכת AI שעוזרת להבין, בלי לתת את הפתרון.
            </p>
          )}
        </footer>
      </div>
    </div>
  );
}

export const metadata = { robots: { index: false, follow: false } };
