import { OG_IMAGES } from "@/lib/seo";
import { getSurveyResults } from "@/lib/surveyStore";
import { CATEGORIES, FEATURED, SNAPSHOT, buildConclusions } from "@/lib/surveyStories";
import CopyLinkButton from "../CopyLinkButton";
import "../survey.css";
import "../results/results.css";
import "./insights.css";

export const dynamic = "force-dynamic";

const TITLE = "מה למדנו מהסקר: מסקנות ומה אמרתם";
const DESCRIPTION = `תשובות לסקר על לימוד פיתוח בעידן ה-AI: ארבע מסקנות, והתשובות החופשיות ממוינות לנושאים, עם ציטוטים אנונימיים.`;

export const metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/survey/insights" },
  openGraph: { type: "website", locale: "he_IL", url: "/survey/insights", title: TITLE, description: DESCRIPTION, images: OG_IMAGES },
  twitter: { card: "summary_large_image", title: TITLE, description: DESCRIPTION, images: OG_IMAGES }
};

const pctOfOpen = (n) => Math.round((n / SNAPSHOT.openAnswers) * 100);

export default async function SurveyInsightsPage() {
  let results = null;
  try {
    results = await getSurveyResults();
  } catch (err) {
    console.error("survey insights page failed", err?.message);
  }
  const total = results?.total || 0;
  const conclusions = buildConclusions(results);
  const maxN = Math.max(...CATEGORIES.map((c) => c.n));

  return (
    <div className="svd svi">
      <header className="svd-hero">
        <span className="sv-pill">מסקנות ותשובות</span>
        <h1>מה למדנו מהסקר, ומה אמרתם</h1>
        <p className="svd-hero__lead">
          {total} בנות ענו על השאלה איך לומדים פיתוח בעידן ה-AI, ו-{SNAPSHOT.openAnswers} מהן כתבו גם תשובה במילים שלהן. הנה מה שעולה מהמספרים, ומה שעולה מהמילים.
        </p>
        <p className="svd-count">
          <strong>{total}</strong>
          <span>בנות ענו · מתעדכן חי</span>
        </p>
      </header>

      <p className="svd-note">
        סקר בלתי רשמי של מי שבחרו לענות, ולכן זו תמונה כללית ולא מחקר מייצג. רוב העונות עובדות כבר בפיתוח.
      </p>

      <section aria-labelledby="svi-conclusions">
        <h2 className="svd-h2" id="svi-conclusions">ארבע מסקנות</h2>
        <ul className="svi-conclusions">
          {conclusions.map((c) => (
            <li className="svi-conclusion" key={c.id}>
              <div className="svd-ring" style={{ "--p": c.pct }} role="img" aria-label={`${c.pct} אחוז`}>
                <span className="svd-ring__in">
                  <span aria-hidden="true" className="svd-ring__emoji">{c.emoji}</span>
                  <strong>{c.pct}%</strong>
                </span>
              </div>
              <div>
                <h3>{c.title}</h3>
                <p>{c.text}</p>
              </div>
            </li>
          ))}
        </ul>
      </section>

      <section aria-labelledby="svi-featured">
        <h2 className="svd-h2" id="svi-featured">משפטים שנשארו איתי</h2>
        <div className="svi-featured">
          {FEATURED.map((q) => (
            <figure className="svi-quote svi-quote--big" key={q}>
              <blockquote>{q}</blockquote>
            </figure>
          ))}
        </div>
      </section>

      <aside className="svi-pin" aria-label="התשובה שהכי אהבתי">
        <span className="svi-pin__tag">📌 התשובה שהכי אהבתי</span>
        <p>תורה, מצוות ומעשים טובים :)</p>
        <span className="svi-pin__sub">על השאלה מה ה-AI לא יכול ללמד</span>
      </aside>

      <section aria-labelledby="svi-themes">
        <h2 className="svd-h2" id="svi-themes">מה כתבתם? {SNAPSHOT.openAnswers} תשובות חופשיות לפי נושאים</h2>
        <p className="svi-lead">
          השאלה הייתה: "מה ה-AI עדיין לא יכול ללמד אתכם, ובשביל זה אתם צריכים בן אדם?" מיינתי כל תשובה לנושא אחד עיקרי (המיון נכון ל-{SNAPSHOT.date}, ל-{SNAPSHOT.openAnswers} התשובות הראשונות). הציטוטים אנונימיים ותוקנו בהם רק שגיאות הקלדה.
        </p>

        <div className="svi-cats">
          {CATEGORIES.map((cat) => (
            <article className="svi-cat" key={cat.id}>
              <header className="svi-cat__head">
                <span className="svi-cat__emoji" aria-hidden="true">{cat.emoji}</span>
                <div>
                  <h3>{cat.title}</h3>
                  <p>{cat.blurb}</p>
                </div>
              </header>
              <div className="svi-bar" role="img" aria-label={`${cat.n} מתוך ${SNAPSHOT.openAnswers} תשובות, ${pctOfOpen(cat.n)} אחוז`}>
                <span className="svi-bar__fill" style={{ width: `${Math.round((cat.n / maxN) * 100)}%` }} />
                <span className="svi-bar__label">{cat.n} תשובות · {pctOfOpen(cat.n)}%</span>
              </div>
              <div className="svi-quotes">
                {cat.quotes.map((q) => (
                  <figure className="svi-quote" key={q}>
                    <blockquote>{q}</blockquote>
                  </figure>
                ))}
              </div>
            </article>
          ))}
        </div>
      </section>

      <section className="svd-cta">
        <h2>רוצים לראות את כל המספרים?</h2>
        <p>התוצאות המלאות בגרפים מתעדכנות עם כל תשובה חדשה. ואם עוד לא ענית, זה לוקח שתי דקות.</p>
        <div className="svd-cta__row">
          <a className="sv-btn sv-btn--primary" href="/survey/results">לכל התוצאות בגרפים</a>
          <a className="sv-btn sv-btn--ghost" href="/survey">למילוי הסקר</a>
          <CopyLinkButton path="/survey/insights" className="sv-btn sv-btn--ghost">העתקת קישור לעמוד</CopyLinkButton>
        </div>
      </section>
    </div>
  );
}
