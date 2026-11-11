import { getCourses, getLessonsByCourse } from "@/lib/courses";
import { CardAction, ResumeCard } from "@/app/components/CourseClient";
import { getLatestApprovedTestimonials } from "@/lib/testimonials";
import { NEW_COURSES } from "@/lib/lessonTheme";
import { absoluteUrl, jsonLdString, SEARCH_KEYWORDS } from "@/lib/seo";
import { CONTACT_EMAIL, CONTACT_PHONE } from "@/lib/site";
import "./courses-design.css";
import "@/app/survey/survey-banner.css";
import { getSurveyResults } from "@/lib/surveyStore";
import { computeInsights } from "@/lib/surveyInsights";

export const metadata = {
  title: "לימוד פייתון בחינם: קורסים אינטראקטיביים בעברית",
  description:
    "לימוד פייתון בחינם בעידן ה-AI: קורסים אינטראקטיביים בעברית, שיעורים עם תרגילים ובדיקה אוטומטית, ופיתוח אפליקציות מבוססות AI.",
  keywords: SEARCH_KEYWORDS,
  alternates: { canonical: "/courses" }
};

// קטע הקוד שמוצג בראש כרטיס. אין לו שדה במסד, ולכן הוא ממופה לפי מזהה קורס; לקורס אחר מוצג </>.
const COVER_SNIPPETS = {
  "python-ai-era": "for i in range(8):\n    learn(i)",
  "vibe-coding": "> build me a quiz game\nok: 3 files created",
  "ai-app-dev":"app = build(idea)\napp.ship()",
  "prompts": "prompt = role + task\nai.ask(prompt)"
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
  const testimonials = await getLatestApprovedTestimonials(60);
  // תקציר תוצאות הסקר לעמוד הבית. אם הטעינה נכשלת או שיש עדיין מעט תשובות, הרצועה פשוט לא מוצגת
  let survey = null;
  try {
    const ins = computeInsights(await getSurveyResults());
    if (ins.total >= 3) survey = ins;
  } catch {}
  // מעט המלצות: חוזרים עליהן עד שהרצועה ארוכה מספיק כדי שלא יופיעו רווחים בלולאה
  const marqueeBase = testimonials.length >= 3 ? Array.from({ length: Math.ceil(8 / testimonials.length) * testimonials.length }, (_, k) => testimonials[k % testimonials.length]) : [];
  const renderTestimonial = (t, key) => (
    <figure className="testimonial-card" key={key || t.id}>
      <blockquote>“{t.quote}”</blockquote>
      {t.result && <p className="testimonial-card__result">✓ {t.result}</p>}
      <figcaption>
        {t.photo_url && <img src={t.photo_url} alt="" width="40" height="40" loading="lazy" />}
        <span>
          <strong>{t.name}</strong>
          {t.role && <small>{t.role}</small>}
          {t.course_title && <small>{t.course_title}</small>}
        </span>
      </figcaption>
    </figure>
  );
  // קורסים פתוחים קודם (כרגע קורס הפייתון), ואחריהם קורסי "בקרוב". המיון יציב, אז בתוך כל קבוצה נשמר סדר ה-position מהמסד.
  const courses = [...allCourses]
    .sort((a, b) => Number(Boolean(a.coming_soon)) - Number(Boolean(b.coming_soon)))
    .filter((c) => {
      if (filter === "free") return !c.is_paid && !c.coming_soon;
      if (filter === "paid") return Boolean(c.is_paid);
      return true;
    });

  // סינון הקורסים (הכל / חינמי / בתשלום) מוסתר בינתיים: כל הקורסים חינמיים. להחזיר: SHOW_FILTER_TABS = true
  const SHOW_FILTER_TABS = false;
  const tabs = [
    { key: "all", label: "הכל" },
    { key: "free", label: "חינמי" }
    // { key: "paid", label: "בתשלום" } - מוסתר בינתיים: אין קורסים בתשלום. לשחזר כשיהיו (הסינון ?filter=paid עדיין עובד)
  ];

  // כרטיס "המשך מהמקום שעצרת" רלוונטי רק לקורסים שאפשר ללמוד בהם עכשיו.
  const resumable = allCourses
    .filter((c) => !c.coming_soon && !c.is_paid)
    .map((c) => ({ id: c.id, title: c.title, lessons: lessonsByCourse[c.id] || [] }))
    .filter((c) => c.lessons.length > 0);

  // כפתורי "התחל ללמוד" בראש ובתחתית הדף: הקורס החינמי הראשון שאפשר ללמוד בו עכשיו.
  const startCourse = resumable[0];
  const startHref = startCourse ? `/courses/${startCourse.id}` : "#courses";

  // ItemList לקטלוג: רק קורסים פעילים (בלי "בקרוב"), בלי קשר למסנן הכרטיסיות שנבחר.
  const activeCourses = allCourses.filter((c) => !c.coming_soon);
  const itemListLd = {
    "@context": "https://schema.org",
    "@type": "ItemList",
    name: "קטלוג הקורסים",
    itemListElement: activeCourses.map((c, i) => ({
      "@type": "ListItem",
      position: i + 1,
      url: absoluteUrl(`/courses/${c.id}`),
      name: c.title
    }))
  };

  return (
    <div className="cx">
      {activeCourses.length > 0 && (
        <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(itemListLd) }} />
      )}
      {/* HERO */}
      <section className="cx-hero">
        <div className="cx-wrap cx-hero__grid">
          <div className="cx-hero__text">
            <h1 className="cx-h1">
              מהשורה הראשונה <span className="cx-accent">ועד אפליקציה</span> שעובדת
            </h1>
            <p className="cx-hero__sub">
              שיעורים אינטראקטיביים עם תרגילים ובדיקה אוטומטית, כדי שתראו מיד אם הקוד שלכם עובד. מלווה אתכם חני שטיינמץ, מפתחת ומורה למדעי המחשב.
            </p>
            <div className="cx-hero__actions">
              <a href={startHref} className="cx-btn cx-btn--lg">
                התחל ללמוד פייתון בחינם
                <Arrow size={22} />
              </a>
              <a href="#testimonials" className="cx-reco-btn">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
                  <path d="M12 2.5l2.9 6.1 6.6.8-4.9 4.6 1.3 6.6L12 17.3 6.1 20.6l1.3-6.6L2.5 9.4l6.6-.8L12 2.5z" />
                </svg>
                המלצות
              </a>
              <a href="#courses" className="cx-link-under">
                לכל הקורסים
              </a>
            </div>
          </div>

          <div className="cx-hero__mock">
            {/* כפתור הסקר: מדבקה עגולה ומוטה על פינת חלון הקוד */}
            <a className="svb-fab" href="/survey" aria-label="לסקר קצר של שתי דקות: איך הייתם לומדים פיתוח בעידן ה-AI">
              <span className="svb-fab__icon" aria-hidden="true">📝</span>
              <span className="svb-fab__text">
                סקר קצר, 2 דקות
                <small>איך הייתם לומדים פיתוח היום, בעידן ה-AI? ותראו איך ענו האחרים</small>
              </span>
            </a>
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

      {/* תקציר תוצאות הסקר */}
      {survey && (
        <section className="svm" aria-label="תוצאות הסקר בקצרה">
          <div className="svm__inner">
            <div className="svm__head">
              <h2>מה ענו בסקר</h2>
              <span className="svm__count">{survey.total} אנשים כבר ענו</span>
              <a className="svm__link" href="/survey/results">לכל התוצאות <span aria-hidden="true">←</span></a>
            </div>
            <ul className="svm__stats">
              {survey.stats.map((st) => (
                <li key={st.id} style={{ "--p": st.pct }}>
                  <div className="svm__top">
                    <span className="svm__emoji" aria-hidden="true">{st.emoji}</span>
                    <strong>{st.pct}%</strong>
                  </div>
                  <p>{st.short}</p>
                  <span className="svm__bar" aria-hidden="true"><i /></span>
                </li>
              ))}
            </ul>
          </div>
        </section>
      )}

      {/* CATALOG */}
      <section id="courses" className="cx-catalog">
        <div className="cx-wrap cx-catalog__inner">
          <div className="cx-catalog__head">
            <div className="cx-catalog__title">
              <h2 className="cx-h2">הקורסים שלנו</h2>
              <p className="cx-lede">קורס הפייתון כבר פתוח וחינמי, ועוד קורסים בדרך.</p>
            </div>
            {SHOW_FILTER_TABS && (
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
            )}
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
                        <span className="cx-card__tags">
                          {NEW_COURSES.includes(course.id) && !soon && <span className="cx-tag cx-tag--new">✦ חדש</span>}
                          {soon ? (
                            <span className="cx-tag cx-tag--soon">בקרוב</span>
                          ) : course.is_paid ? (
                            <span className="cx-tag cx-tag--paid">₪{course.price_ils}</span>
                          ) : (
                            <span className="cx-tag cx-tag--free">חינם</span>
                          )}
                        </span>
                      </div>
                      <pre dir="ltr" className="cx-card__code">{snippet}</pre>
                    </div>
                    <div className="cx-card__body">
                      <h3 className="cx-card__title">{course.title}</h3>
                      {course.subtitle && <p className="cx-card__desc">{course.subtitle}</p>}
                      {soon ? null : (
                        lessons.length > 0 && <p className="cx-card__meta">{lessonsLabel(lessons.length)}</p>
                      )}
                      {soon && (
                        <div className="cx-card__action">
                          <span className="btn btn-off" aria-disabled="true">
                            בקרוב
                          </span>
                        </div>
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

      {/* TESTIMONIALS */}
      <section id="testimonials" className="cx-wrap cx-testimonials">
        <h2 className="cx-h2">מה אומרים התלמידים</h2>
        {testimonials.length === 0 ? (
          <p className="cx-empty">ההמלצות הראשונות יופיעו כאן בקרוב.</p>
        ) : testimonials.length < 3 ? (
          <div className="testimonial-grid">{testimonials.map((t) => renderTestimonial(t))}</div>
        ) : (
          // כל ההמלצות עוברות ברצף (גלילה אוטומטית ואינסופית). הרצועה משוכפלת פעמיים כדי שהלולאה תהיה חלקה; העותק השני מוסתר מקוראי מסך.
          <div className="cx-marquee" role="region" aria-label="המלצות תלמידים">
            <div className="cx-marquee__track" style={{ "--cx-marquee-time": `${Math.max(30, marqueeBase.length * 7)}s` }}>
              {marqueeBase.map((t, i) => renderTestimonial(t, `a${i}`))}
              <div className="cx-marquee__copy" aria-hidden="true">
                {marqueeBase.map((t, i) => renderTestimonial(t, `b${i}`))}
              </div>
            </div>
          </div>
        )}
      </section>

      {/* ORDER / CONTACT */}
      <section id="order" className="cx-order">
        <div className="cx-wrap cx-order__inner">
          <div className="cx-order__head">
            <span className="cx-accent cx-strong">הזמנות ופיתוח</span>
            <h2 className="cx-h2">רוצים קורס, שיעורים או משהו שנבנה במיוחד בשבילכם?</h2>
            <p className="cx-lede">
              אפשר להזמין אצלי קורס מותאם, שיעורים פרטיים או קבוצתיים, ופיתוח של אתרים, אפליקציות וכלים מבוססי AI. ספרו לי מה אתם צריכים ונחזור אליכם.
            </p>
          </div>

          <div className="cx-order__cards">
            <div className="cx-order__card">
              <span className="cx-order__icon" aria-hidden="true">🎓</span>
              <h3>קורסים</h3>
              <p>קורס אינטראקטיבי בעברית, מותאם לקבוצה, לבית ספר או לארגון.</p>
            </div>
            <div className="cx-order__card">
              <span className="cx-order__icon" aria-hidden="true">💬</span>
              <h3>שיעורים</h3>
              <p>שיעורים פרטיים או קבוצתיים בפייתון, בתכנות ובעבודה עם כלי AI.</p>
            </div>
            <div className="cx-order__card">
              <span className="cx-order__icon" aria-hidden="true">🛠️</span>
              <h3>פיתוח</h3>
              <p>בניית אתרים, אפליקציות ומערכות לפי הצורך שלכם, מהרעיון ועד שזה עובד.</p>
            </div>
          </div>

          <div className="cx-order__contact">
            <div className="cx-order__who">
              <strong>חני שטיינמץ</strong>
              <span className="cx-muted">מפתחת ומורה למדעי המחשב</span>
            </div>
            <div className="cx-order__actions">
              <a href={`tel:${CONTACT_PHONE}`} className="cx-btn" dir="ltr">
                <span aria-hidden="true">📞</span> {CONTACT_PHONE}
              </a>
              <a href={`mailto:${CONTACT_EMAIL}`} className="cx-order__link" dir="ltr">
                <span aria-hidden="true">✉️</span> {CONTACT_EMAIL}
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* INSTRUCTOR */}
      <section className="cx-instructor">
        <div className="cx-wrap cx-instructor__inner">
          <div className="cx-instructor__text">
            <span className="cx-accent cx-strong">מי מלמדת אתכם</span>
            <h2 className="cx-h2 cx-h2--sm">חני שטיינמץ, מפתחת ומורה למדעי המחשב</h2>
            <p className="cx-instructor__p">
              מלמדת פייתון ופיתוח עם כלי AI, ובונה בעצמה מערכות שעובדות באמת. הקורסים כאן נבנו מתוך הכיתה: מה שמסביר טוב, נשאר.
            </p>
          </div>
        </div>
      </section>
    </div>
  );
}
