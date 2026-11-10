import { OG_IMAGES } from "@/lib/seo";
import { getSurveyResults } from "@/lib/surveyStore";
import { computeInsights } from "@/lib/surveyInsights";
import SurveyResults from "../SurveyResults";
import CopyLinkButton from "../CopyLinkButton";
import "../survey.css";
import "./results.css";

export const dynamic = "force-dynamic";

const TITLE = "תוצאות הסקר: איך לומדים פיתוח בעידן ה-AI";
const DESCRIPTION = "מה ענו אנשים שלומדים ועובדים בפיתוח על ה-AI, על לימוד קוד ועל העתיד של ג'וניורס. תוצאות חיות, בגרפים.";

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
  const { total, stats, topPriorities } = computeInsights(results);
  const [winner, ...runnersUp] = topPriorities;

  return (
    <div className="svd">
      <header className="svd-hero">
        <span className="sv-pill">תוצאות חיות</span>
        <h1>איך לומדים פיתוח בעידן ה-AI?</h1>
        <p className="svd-hero__lead">מה ענו אנשים שלומדים ועובדים בפיתוח. הכול אנונימי, והמספרים מתעדכנים עם כל תשובה חדשה.</p>
        {total > 0 && (
          <p className="svd-count">
            <strong>{total}</strong>
            <span>{total === 1 ? "אדם אחד ענה" : "אנשים ענו"}</span>
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
          {total < 10 && (
            <p className="svd-small" role="note">
              עד עכשיו ענו רק {total}, ולכן האחוזים עוד יזוזו הרבה כשיצטרפו עוד תשובות.
            </p>
          )}

          <section aria-labelledby="svd-highlights">
            <h2 className="svd-h2" id="svd-highlights">הממצאים הבולטים</h2>
            <ul className="svd-stats">
              {stats.map((s) => (
                <li className="svd-stat" key={s.id}>
                  <div className="svd-ring" style={{ "--p": s.pct }} role="img" aria-label={`${s.pct} אחוז`}>
                    <span className="svd-ring__in">
                      <span aria-hidden="true" className="svd-ring__emoji">{s.emoji}</span>
                      <strong>{s.pct}%</strong>
                    </span>
                  </div>
                  <p>{s.text}</p>
                </li>
              ))}
            </ul>
          </section>

          {winner && (
            <section className="svd-winner" aria-labelledby="svd-winner-h">
              <span className="svd-winner__emoji" aria-hidden="true">{winner.emoji}</span>
              <div>
                <h2 className="svd-winner__kicker" id="svd-winner-h">הכי חשוב ללמוד היום, לפי מי שענו</h2>
                <p className="svd-winner__name">{winner.label} <span>· {winner.pct}%</span></p>
                {runnersUp.length > 0 && (
                  <p className="svd-winner__next">
                    אחריו: {runnersUp.map((r) => `${r.label} (${r.pct}%)`).join(", ")}
                  </p>
                )}
              </div>
            </section>
          )}

          <section aria-labelledby="svd-all">
            <h2 className="svd-h2" id="svd-all">כל התוצאות, שאלה אחרי שאלה</h2>
            <SurveyResults results={results} headingLevel={3} />
          </section>
        </>
      )}

      <section className="svd-cta">
        <h2>ענית כבר?</h2>
        <p>כל תשובה נוספת משפרת את התמונה. הסקר לוקח שתי דקות.</p>
        <div className="svd-cta__row">
          <a className="sv-btn sv-btn--primary" href="/survey">למילוי הסקר</a>
          <CopyLinkButton path="/survey" className="sv-btn sv-btn--ghost">העתקת קישור לסקר</CopyLinkButton>
        </div>
      </section>
    </div>
  );
}
