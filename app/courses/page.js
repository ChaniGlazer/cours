import { getCourses, getLessonsByCourse } from "@/lib/courses";
import { CardAction, ResumeCard } from "@/app/components/CourseClient";
import "./courses-design.css";

export const metadata = {
  title: "קטלוג קורסים בפייתון ו-AI בעברית",
  description:
    "קטלוג קורסים בעברית: לימוד פייתון אינטראקטיבי בחינם ופיתוח אפליקציות מבוססות AI. שיעורים עם תרגילים ובדיקה אוטומטית.",
  alternates: { canonical: "/courses" }
};

// קטע הקוד שמוצג בראש כרטיס. אין לו שדה במסד, ולכן הוא ממופה לפי מזהה קורס; לקורס אחר מוצג </>.
const COVER_SNIPPETS = {
  "python-ai-era": "for i in range(8):\n    learn(i)",
  "vibe-coding": "> build me a quiz game\nok: 3 files created",
  "ai-app-dev":"app = build(idea)\napp.ship()"
};

function lessonsLabel(n) {
  return n === 1 ? "שיעור אחד" : `${n} שיעורים`;
}

function Arrow({ size = 20 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M19 12H5" />
      <path d="M11 6l-6 6 6 6" />
    </svg>
  );
}

export default async function CoursesCatalogPage({ searchParams }) {
  const params = await searchParams;
  const filter = params?.filter === "free" || params?.filter === "paid" ? params.filter : "all";

  const allCourses = await getCourses();
  const lessonsByCourse = await getLessonsByCourse();
  const courses = allCourses
    .map((c, i) => ({ ...c, stage: i + 1 }))
    .filter((c) => {
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

  // כפתורי "התחל ללמוד" בראש ובתחתית הדף: הקורס החינמי הראשון שאפשר ללמוד בו עכשיו.
  const startCourse = resumable[0];
  const startHref = startCourse ? `/courses/${startCourse.id}` : "#courses";

  return (
    <div className="cx">
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
      <link
        rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap"
        precedence="default"
      />

      {/* HERO */}
      <section className="cx-hero">
        <div className="cx-wrap cx-hero__grid">
          <div className="cx-hero__text">
            <span className="cx-pill">
              <span className="cx-pill__dot" />
              חלק מהקורסים חינם לגמרי
            </span>
            <h1 className="cx-h1">
              מהשורה הראשונה <span className="cx-accent">ועד אפליקציה</span> שעובדת
            </h1>
            <p className="cx-hero__sub">
              שיעורים אינטראקטיביים עם תרגילים ובדיקה אוטומטית, כדי שתראו מיד אם הקוד שלכם עובד. מלווה אתכם חני שטיינמץ, מורה למדעי המחשב.
            </p>
            <div className="cx-hero__actions">
              <a href={startHref} className="cx-btn cx-btn--lg">
                התחל ללמוד פייתון בחינם
                <Arrow size={22} />
              </a>
              <a href="#courses" className="cx-link-under">
                לכל הקורסים
              </a>
            </div>
          </div>

          <div className="cx-hero__mock">
            <div className="cx-editor">
              <div className="cx-editor__bar" dir="ltr">
                <span className="cx-dot cx-dot--accent" />
                <span className="cx-dot cx-dot--yellow" />
                <span className="cx-dot cx-dot--mint" />
                <span className="cx-editor__file">lesson_08.py</span>
              </div>
              <pre className="cx-code" dir="ltr">
                <span className="cx-kw">def</span> <span className="cx-fn">bloom</span>(skill):{"\n"}
                {"    "}
                <span className="cx-kw">return</span> skill + <span className="cx-num">1</span>
                {"\n\n"}level = <span className="cx-num">0</span>
                {"\n"}
                <span className="cx-kw">for</span> lesson <span className="cx-kw">in</span> <span className="cx-fn">range</span>(<span className="cx-num">8</span>):{"\n"}
                {"    "}level = bloom(level){"\n\n"}
                <span className="cx-fn">print</span>(level)  <span className="cx-cm"># 8</span>
              </pre>
              <div className="cx-editor__result">
                <div className="cx-editor__row">
                  <span className="cx-strong">בדיקה אוטומטית</span>
                  <span dir="ltr" className="cx-mono cx-mint">3 / 3 passed</span>
                </div>
                <div className="cx-bars">
                  <span />
                  <span />
                  <span />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* CATALOG */}
      <section id="courses" className="cx-catalog">
        <div className="cx-wrap cx-catalog__inner">
          <div className="cx-catalog__head">
            <div className="cx-catalog__title">
              <h2 className="cx-h2">המסלול שלכם, שלב אחרי שלב</h2>
              <p className="cx-lede">מתחילים בבסיס, ממשיכים לבנות עם AI, ובסוף מפרסמים משהו אמיתי.</p>
            </div>
            <nav className="cx-tabs" aria-label="סינון קורסים">
              {tabs.map((t) => (
                <a
                  key={t.key}
                  href={t.key === "all" ? "/courses#courses" : `/courses?filter=${t.key}#courses`}
                  className={`cx-tab${filter === t.key ? " is-active" : ""}`}
                  aria-current={filter === t.key ? "true" : undefined}
                >
                  {t.label}
                </a>
              ))}
            </nav>
          </div>

          <ResumeCard courses={resumable} />

          {courses.length === 0 ? (
            <div className="cx-empty">
              {filter === "paid"
                ? "קורסים בתשלום יתווספו בקרוב. בינתיים, כל מה שפתוח כאן הוא בחינם."
                : "אין כרגע קורסים בקטגוריה הזו."}
            </div>
          ) : (
            <div className="cx-grid">
              {courses.map((course) => {
                const lessons = lessonsByCourse[course.id] || [];
                const soon = Boolean(course.coming_soon);
                const snippet = COVER_SNIPPETS[course.id] || "</>";
                return (
                  <article className={`cx-card${soon ? " is-soon" : ""}`} key={course.id}>
                    <div className="cx-card__cover">
                      <div className="cx-card__covertop">
                        <span className="cx-card__stage">שלב {course.stage}</span>
                        {soon ? (
                          <span className="cx-tag cx-tag--soon">בקרוב</span>
                        ) : course.is_paid ? (
                          <span className="cx-tag cx-tag--paid">₪{course.price_ils}</span>
                        ) : (
                          <span className="cx-tag cx-tag--free">חינם</span>
                        )}
                      </div>
                      <pre dir="ltr" className="cx-card__code">{snippet}</pre>
                    </div>
                    <div className="cx-card__body">
                      <h3 className="cx-card__title">{course.title}</h3>
                      {course.subtitle && <p className="cx-card__desc">{course.subtitle}</p>}
                      {soon ? (
                        <p className="cx-card__meta">נפתח בקרוב</p>
                      ) : (
                        lessons.length > 0 && <p className="cx-card__meta">{lessonsLabel(lessons.length)}</p>
                      )}
                      {!soon && (
                        <div className="cx-card__action">
                          {course.is_paid ? (
                            <a href={`/courses/${course.id}`} className="btn btn-primary">
                              לפרטים והרשמה
                              <Arrow />
                            </a>
                          ) : lessons.length > 0 ? (
                            <CardAction courseId={course.id} slugs={lessons.map((l) => l.slug)} arrow={<Arrow />} />
                          ) : (
                            <a href={`/courses/${course.id}`} className="btn btn-primary">
                              לפרטים על הקורס
                              <Arrow />
                            </a>
                          )}
                        </div>
                      )}
                    </div>
                  </article>
                );
              })}
            </div>
          )}
        </div>
      </section>

      {/* LESSON ANATOMY */}
      <section className="cx-wrap cx-anatomy">
        <div className="cx-anatomy__text">
          <h2 className="cx-h2">ככה לומדים פיתוח היום</h2>
          <p className="cx-anatomy__lede">
            את הפרטים הקטנים, כמו סוגריים ופסיקים, אפשר להשאיר לכלי ה-AI. אנחנו מתעסקים במה שחשוב באמת: להבין מה רוצים לבנות ולמה זה עובד.{" "}
            <span className="cx-accent cx-strong">פחות להיתקע, יותר ליהנות מהדרך.</span>
          </p>
          <ol className="cx-steps">
            <li>
              <span className="cx-steps__n">1</span>
              <div>
                <div className="cx-steps__t">לומדים רעיון אחד</div>
                <div className="cx-muted">הסבר בעברית פשוטה, עם דוגמה שאפשר להריץ.</div>
              </div>
            </li>
            <li>
              <span className="cx-steps__n">2</span>
              <div>
                <div className="cx-steps__t">מתרגלים בעצמכם</div>
                <div className="cx-muted">תרגיל קטן ישר בדף.</div>
              </div>
            </li>
            <li>
              <span className="cx-steps__n">3</span>
              <div>
                <div className="cx-steps__t">הבדיקה האוטומטית עונה</div>
                <div className="cx-muted">עברתם? ממשיכים. נתקעתם? מקבלים רמז למה לתקן.</div>
              </div>
            </li>
          </ol>
        </div>

        <div className="cx-anatomy__demo">
          <div className="cx-exercise">
            <div className="cx-exercise__head">
              <span className="cx-exercise__title">תרגיל: פונקציית חיבור</span>
              <span className="cx-exercise__tag">תרגיל לדוגמה</span>
            </div>
            <pre className="cx-code cx-code--inset" dir="ltr">
              <span className="cx-kw">def</span> <span className="cx-fn">add</span>(a, b):{"\n"}
              {"    "}
              <span className="cx-kw">return</span> a - b
            </pre>
            <div className="cx-tests">
              <div className="cx-test">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#6FE0A0" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M5 12.5l4.5 4.5L19 7.5" />
                </svg>
                <span dir="ltr" className="cx-mono">add(0, 0) == 0</span>
              </div>
              <div className="cx-test cx-test--fail">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#FF7F96" strokeWidth="2.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                  <path d="M6 6l12 12" />
                  <path d="M18 6L6 18" />
                </svg>
                <span dir="ltr" className="cx-mono">add(1, 2) == 3</span>
              </div>
              <div className="cx-tests__hint">קיבלנו -1 במקום 3. שימו לב לסימן בשורת ה-return.</div>
            </div>
          </div>
        </div>
      </section>

      {/* INSTRUCTOR */}
      <section className="cx-instructor">
        <div className="cx-wrap cx-instructor__inner">
          <div className="cx-instructor__text">
            <span className="cx-accent cx-strong">מי מלמדת אתכם</span>
            <h2 className="cx-h2 cx-h2--sm">חני שטיינמץ, מורה למדעי המחשב</h2>
            <p className="cx-instructor__p">
              מלמדת פייתון ופיתוח עם כלי AI, ובונה בעצמה מערכות שעובדות באמת. הקורסים כאן נבנו מתוך הכיתה: מה שמסביר טוב, נשאר.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
