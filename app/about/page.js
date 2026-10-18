import { absoluteUrl, jsonLdString, OG_IMAGES } from "@/lib/seo";
import { INSTRUCTOR, CONTACT_EMAIL, aboutIsFilled } from "@/lib/site";
import { COURSE_ID } from "@/lib/topics";

const TITLE = `אודות ${INSTRUCTOR.name}, המדריכה בקורסים`;
const DESCRIPTION = `מי מלווה את הלימוד באתר: ${INSTRUCTOR.name}, מדריכת הקורסים בפייתון ובפיתוח עם AI.`;

export const metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/about" },
  // כל עוד לא מולאו פרטים ב-lib/site.js, העמוד ריק ולכן לא נכנס למנועי חיפוש.
  ...(aboutIsFilled() ? {} : { robots: { index: false, follow: true } }),
  openGraph: { type: "profile", locale: "he_IL", url: "/about", title: TITLE, description: DESCRIPTION, images: OG_IMAGES }
};

export default function AboutPage() {
  const filled = aboutIsFilled();
  const personLd = {
    "@context": "https://schema.org",
    "@type": "Person",
    name: INSTRUCTOR.name,
    url: absoluteUrl("/about"),
    ...(INSTRUCTOR.title ? { jobTitle: INSTRUCTOR.title } : {}),
    ...(INSTRUCTOR.photo ? { image: absoluteUrl(INSTRUCTOR.photo) } : {})
  };

  return (
    <section className="section doc-page">
      {filled && <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(personLd) }} />}
      <div className="container doc-wrap">
        <nav className="crumbs" aria-label="נתיב">
          <a href="/">דף הבית</a>
          <span aria-hidden="true">›</span>
          <span aria-current="page">אודות</span>
        </nav>
        <span className="eyebrow">אודות</span>

        <header className="doc-person">
          {INSTRUCTOR.photo && (
            <img className="doc-person__photo" src={INSTRUCTOR.photo} alt={INSTRUCTOR.photoAlt || INSTRUCTOR.name} width="120" height="120" />
          )}
          <div>
            <h1>{INSTRUCTOR.name}</h1>
            {INSTRUCTOR.title && <p className="doc-person__title">{INSTRUCTOR.title}</p>}
          </div>
        </header>

        {INSTRUCTOR.bio.map((p, i) => (
          <p key={i}>{p}</p>
        ))}

        {INSTRUCTOR.background.length > 0 && (
          <>
            <h2>רקע מקצועי</h2>
            <ul>
              {INSTRUCTOR.background.map((item, i) => (
                <li key={i}>{item}</li>
              ))}
            </ul>
          </>
        )}

        {!filled && <p className="text-soft">פרטים על המדריכה יתווספו כאן בקרוב.</p>}

        <h2>איפה מתחילים</h2>
        <p>
          הקורסים מלווים בשיעורים אינטראקטיביים, תרגילים ובדיקה אוטומטית. קורס הפייתון פתוח וחינמי, ואפשר להתחיל בו עכשיו.
        </p>
        <div className="doc-actions">
          <a className="btn btn-primary" href={`/courses/${COURSE_ID}`}>
            לקורס הפייתון
          </a>
          <a className="btn btn-ghost" href="/courses">
            לקטלוג הקורסים
          </a>
        </div>

        {CONTACT_EMAIL && (
          <p>
            לשאלות ופניות: <a href={`mailto:${CONTACT_EMAIL}`}>{CONTACT_EMAIL}</a>
          </p>
        )}
      </div>
    </section>
  );
}
