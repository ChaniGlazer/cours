// אזור "מה לומדים בשיעור" מתחת לתוכן השיעור (server component, בלי JS בצד הלקוח).
// גוף השיעור יושב ב-iframe srcDoc שמנועי חיפוש לא קוראים, ולכן הנושאים, הדוגמאות והשאלות נפוצות מוצגים כאן כטקסט אמיתי וגלוי.
// הנתונים: outline מ-lib/lessonOutlines.json (נבנה מקובצי ה-HTML של השיעורים בסקריפט build-lesson-outlines),
// ו-seo מ-lib/lessonSeo.js (שאלות ותשובות כתובות ביד). העיצוב ב-lesson-design.css (lx-seo).

export default function LessonSeoSection({ outline, seo, course, prev, next }) {
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
              {s.text && <p>{s.text}</p>}
              {s.items && (
                <ul>
                  {s.items.map((it) => (
                    <li key={it.heading}>
                      <strong>{it.heading}:</strong> {it.text}
                    </li>
                  ))}
                </ul>
              )}
              {s.points && (
                <ul>
                  {s.points.map((p) => (
                    <li key={p}>{p}</li>
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
              <p>{f.a}</p>
            </div>
          ))}
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
