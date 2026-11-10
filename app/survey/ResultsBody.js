// גוף תוצאות הסקר: הערה, ממצאים בולטים בעיגולי אחוזים, הנושא המוביל, וכל הגרפים.
// משותף לעמוד /survey/results ולמסך הסיום של הסקר (embedded), כדי שהתוצאות ייראו אותו דבר בשניהם.
// בלי hooks, ולכן עובד גם בשרת וגם בלקוח. מצפה ל-results עם total > 0.
import { computeInsights } from "@/lib/surveyInsights";
import SurveyResults from "./SurveyResults";
import "./survey.css";
import "./results/results.css";

export default function ResultsBody({ results, mine = null, embedded = false }) {
  const { total, stats, topPriorities } = computeInsights(results);
  const [winner, ...runnersUp] = topPriorities;
  const wrap = embedded ? "svd svd--embedded" : undefined;

  const body = (
    <>
      <p className="svd-note">סקר בלתי רשמי של מי שבחרו לענות, ולכן זו תמונה כללית ולא מחקר מייצג.</p>
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
              <p className="svd-winner__next">אחריו: {runnersUp.map((r) => `${r.label} (${r.pct}%)`).join(", ")}</p>
            )}
          </div>
        </section>
      )}

      <section aria-labelledby="svd-all">
        <h2 className="svd-h2" id="svd-all">כל התוצאות, שאלה אחרי שאלה</h2>
        <SurveyResults results={results} mine={mine} headingLevel={3} />
      </section>
    </>
  );

  // בעמוד התוצאות העטיפה (.svd) כבר קיימת; במסך הסיום עוטפים כאן
  return wrap ? <div className={wrap}>{body}</div> : body;
}
