// אזור "מה לומדים בשיעור" מתחת לתוכן השיעור (server component, בלי JS בצד הלקוח).
// גוף השיעור יושב ב-iframe srcDoc שמנועי חיפוש לא קוראים, ולכן הנושאים, הדוגמאות והשאלות נפוצות מוצגים כאן כטקסט אמיתי וגלוי.
// הנתונים: outline מ-lib/lessonOutlines.json (נבנה מקובצי ה-HTML של השיעורים בסקריפט build-lesson-outlines),
// ו-seo מ-lib/lessonSeo.js (שאלות ותשובות כתובות ביד). העיצוב ב-lesson-design.css (lx-seo).

// שמות קבצים כמו .py ו-random.py בתוך פסקה בעברית: בלי עטיפה LTR הנקודה "קופצת" לסוף ויוצג py. במקום .py.
// לכן כל טוקן שנגמר ב-.py נעטף ב-<code> עם dir="ltr".
const FILE_TOKEN = /([A-Za-z0-9_-]*\.py)(?![A-Za-z0-9_])/g;
function Inline({ text }) {
  const parts = String(text).split(FILE_TOKEN);
  return parts.map((p, i) =>
    i % 2 === 1 ? (
      <code className="lx-seo__file" dir="ltr" key={i}>
        {p}
      </code>
    ) : (
      p
    )
  );
}

export default function LessonSeoSection({ outline, seo, course, prev, next, topics = [] }) {
  const sections = outline?.sections || [];
  const faq = seo?.faq || [];
  if (sections.length === 0 && faq.length === 0) return null;

  return (
    <section className="lx-seo" aria-labelledby="lx-seo-h">
      {sections.length > 0 && (
        <>
          <h2 className="lx-seo__h" id="lx-seo-h">
            מה לומדים בשיעור
          </h2>
          {sections.map((s, i) => (
            <div className="lx-seo__part" key={`${i}-${s.heading}`}>
              <h3>{s.heading}</h3>
              {s.text && (
                <p>
                  <Inline text={s.text} />
                </p>
              )}
              {s.items && (
                <ul>
                  {s.items.map((it) => (
                    <li key={it.heading}>
                      <strong>{it.heading}:</strong> <Inline text={it.text} />
                    </li>
                  ))}
                </ul>
              )}
              {s.points && (
                <ul>
                  {s.points.map((p) => (
                    <li key={p}>
                      <Inline text={p} />
                    </li>
                  ))}
                </ul>
              )}
              {s.code &&
                s.code.map((c) => (
                  <pre className="lx-seo__code" dir="ltr" key={c}>
                    <code>{c}</code>
                  </pre>
                ))}
            </div>
          ))}
        </>
      )}

      {faq.length > 0 && (
        <div className="lx-seo__faq">
          <h2 className="lx-seo__h">שאלות ותשובות על השיעור</h2>
          {faq.map((f) => (
            <div className="lx-seo__part" key={f.q}>
              <h3>{f.q}</h3>
              <p>
                <Inline text={f.a} />
              </p>
            </div>
          ))}
        </div>
      )}

      {topics.length > 0 && (
        <div className="lx-seo__topics">
          <h2 className="lx-seo__h">נושאים קשורים</h2>
          <ul>
            {topics.map((t) => (
              <li key={t.slug}>
                <a href={`/topics/${t.slug}`}>{t.h1}</a>
              </li>
            ))}
          </ul>
        </div>
      )}

      <nav className="lx-seo__nav" aria-label="המשך בקורס">
        {prev && (
          <p>
            שיעור קודם: <a href={`/courses/${course.id}/${prev.slug}`}>{prev.title}</a>
          </p>
        )}
        {next && (
          <p>
            שיעור הבא: <a href={`/courses/${course.id}/${next.slug}`}>{next.title}</a>
          </p>
        )}
        <p>
          <a href={`/courses/${course.id}`}>כל שיעורי הקורס</a>
        </p>
      </nav>
    </section>
  );
}
