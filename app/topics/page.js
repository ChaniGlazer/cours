import { TOPICS } from "@/lib/topics";
import { absoluteUrl, jsonLdString, OG_IMAGES } from "@/lib/seo";
import "./topics.css";

const TITLE = "נושאים בפייתון: תשובות קצרות לשאלות של מתחילים ומתחילות";
const DESCRIPTION = "תשובות קצרות לשאלות נפוצות בפייתון: משתנים, תנאים, לולאות, רשימות, מילונים, פונקציות ועוד. כל נושא עם דוגמת קוד וקישור לשיעור המלא.";

export const metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/topics" },
  openGraph: { type: "website", locale: "he_IL", url: "/topics", title: TITLE, description: DESCRIPTION, images: OG_IMAGES }
};

export default function TopicsIndexPage() {
  const breadcrumbLd = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "דף הבית", item: absoluteUrl("/") },
      { "@type": "ListItem", position: 2, name: "נושאים", item: absoluteUrl("/topics") }
    ]
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(breadcrumbLd) }} />
      <div className="tp">
        <div className="container tp-wrap">
          <nav className="tp-crumbs" aria-label="נתיב">
            <a href="/">דף הבית</a>
            <span aria-hidden="true">›</span>
            <span aria-current="page">נושאים</span>
          </nav>
          <h1 className="tp-h1">נושאים בפייתון</h1>
          <p className="tp-lede">שאלה אחת בכל עמוד, תשובה קצרה ודוגמת קוד. מי שרוצה להעמיק ממשיכה משם לשיעור המלא.</p>

          <ul className="tp-index">
            {TOPICS.map((t) => (
              <li key={t.slug}>
                <h2>
                  <a href={`/topics/${t.slug}`}>{t.h1}</a>
                </h2>
                <p>{t.description}</p>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </>
  );
}
