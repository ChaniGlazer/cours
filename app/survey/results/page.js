import { OG_IMAGES } from "@/lib/seo";
import { getSurveyResults } from "@/lib/surveyStore";
import ResultsBody from "../ResultsBody";
import CopyLinkButton from "../CopyLinkButton";
import "../survey.css";
import "./results.css";

export const dynamic = "force-dynamic";

const TITLE = "תוצאות הסקר: איך לומדים פיתוח בעידן ה-AI";
const DESCRIPTION = "מה ענו בנות שלומדות ועובדות בפיתוח על ה-AI, על לימוד קוד ועל העתיד של ג'וניורס. תוצאות חיות, בגרפים.";

export const metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/survey/results" },
  openGraph: { type: "website", locale: "he_IL", url: "/survey/results", title: TITLE, description: DESCRIPTION, images: OG_IMAGES },
  twitter: { card: "summary_large_image", title: TITLE, description: DESCRIPTION, images: OG_IMAGES }
};

export default async function SurveyResultsPage() {
  let results = null;
  try {
    results = await getSurveyResults();
  } catch (err) {
    console.error("survey results page failed", err?.message);
  }
  const total = results?.total || 0;

  return (
    <div className="svd">
      <header className="svd-hero">
        <span className="sv-pill">תוצאות חיות</span>
        <h1>איך לומדים פיתוח בעידן ה-AI?</h1>
        <p className="svd-hero__lead">מה ענו בנות שלומדות ועובדות בפיתוח. הכול אנונימי, והמספרים מתעדכנים עם כל תשובה חדשה.</p>
        {total > 0 && (
          <p className="svd-count">
            <strong>{total}</strong>
            <span>{total === 1 ? "בת אחת ענתה" : "בנות ענו"}</span>
          </p>
        )}
      </header>

      {!results ? (
        <p className="svr-empty">לא הצלחנו לטעון את התוצאות. נסו לרענן בעוד רגע.</p>
      ) : total === 0 ? (
        <section className="svd-empty">
          <p>עוד אין תשובות. אפשר להיות הראשונים!</p>
          <a className="sv-btn sv-btn--primary" href="/survey">לסקר</a>
        </section>
      ) : (
        <>
          <ResultsBody results={results} />
        </>
      )}

      <section className="svd-cta">
        <h2>ענית כבר?</h2>
        <p>כל תשובה נוספת משפרת את התמונה. הסקר לוקח שתי דקות.</p>
        <div className="svd-cta__row">
          <a className="sv-btn sv-btn--primary" href="/survey">למילוי הסקר</a>
          <a className="sv-btn sv-btn--ghost" href="/survey/insights">מסקנות ותשובות חופשיות</a>
          <CopyLinkButton path="/survey" className="sv-btn sv-btn--ghost">העתקת קישור לסקר</CopyLinkButton>
        </div>
      </section>
    </div>
  );
}
