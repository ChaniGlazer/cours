// גרפי התוצאות של הסקר. CSS בלבד (בלי ספריית גרפים). משותף לעמוד /survey ולפאנל הניהול.
// results: { total, counts: { [questionId]: { [optionKey]: n } } }. mine: התשובות של הגולשת עצמה (להדגשה) או null.
import { RESULT_QUESTIONS } from "@/lib/surveyConfig";
import "./survey.css";

const pct = (n, total) => (total > 0 ? Math.round((n / total) * 100) : 0);

function isMine(mine, q, key) {
  const v = mine?.[q.id];
  return Array.isArray(v) ? v.includes(key) : v === key;
}

// שאלה עם בחירה אחת או כמה: עמודות אופקיות, ממוינות מהנפוץ לנדיר (חוץ מ"באיזה שלב", שנשאר בסדר טבעי).
function BarsQuestion({ q, counts, total, mine }) {
  const rows = q.options.map((o) => ({ ...o, n: counts[o.key] || 0 }));
  if (q.id !== "stage" && q.id !== "manual_first") rows.sort((a, b) => b.n - a.n);
  const top = Math.max(...rows.map((r) => r.n));
  return (
    <ul className="svr-bars">
      {rows.map((o, i) => {
        const p = pct(o.n, total);
        const me = isMine(mine, q, o.key);
        const lead = top > 0 && o.n === top;
        return (
          <li key={o.key} className={[me ? "is-mine" : "", lead ? "is-top" : ""].join(" ").trim() || undefined}>
            <div className="svr-bars__top">
              <span>
                <span aria-hidden="true">{o.emoji} </span>
                {o.label}
                {me && <span className="svr-me"> · התשובה שלך</span>}
              </span>
              <strong>{p}%</strong>
            </div>
            <div className="svr-track" aria-hidden="true">
              <i style={{ width: `${p}%`, animationDelay: `${i * 70}ms` }} />
            </div>
          </li>
        );
      })}
    </ul>
  );
}

// סקאלה 1 עד 5: חמש עמודות אנכיות וממוצע.
function ScaleQuestion({ q, counts, total, mine }) {
  const max = Math.max(1, ...q.options.map((o) => counts[o.key] || 0));
  const sum = q.options.reduce((s, o) => s + o.value * (counts[o.key] || 0), 0);
  const avg = total > 0 ? (sum / total).toFixed(1) : "–";
  return (
    <>
      <ol className="svr-cols">
        {q.options.map((o, i) => {
          const n = counts[o.key] || 0;
          const me = isMine(mine, q, o.key);
          const lead = n > 0 && n === max;
          return (
            <li key={o.key} className={[me ? "is-mine" : "", lead ? "is-top" : ""].join(" ").trim() || undefined}>
              <span className="svr-cols__pct">{pct(n, total)}%</span>
              <span className="svr-cols__bar" aria-hidden="true">
                <i style={{ height: n ? `${Math.max(6, (n / max) * 100)}%` : 0, animationDelay: `${i * 70}ms` }} />
              </span>
              <span className="svr-cols__emoji" aria-hidden="true">{q.emojis[i]}</span>
              <span className="svr-cols__label">{o.label}</span>
              {me && <span className="svr-me">את</span>}
            </li>
          );
        })}
      </ol>
      <p className="svr-avg">ממוצע: <strong>{avg}</strong> מתוך 5</p>
    </>
  );
}

export default function SurveyResults({ results, mine = null, headingLevel = 3 }) {
  const H = `h${headingLevel}`;
  const total = results?.total || 0;
  if (!total) return <p className="svr-empty">עוד אין תשובות. את הראשונה!</p>;
  return (
    <div className="svr">
      {RESULT_QUESTIONS.map((q) => (
        <section className="svr-card" key={q.id} aria-label={q.resultTitle}>
          <H className="svr-card__title">{q.resultTitle}</H>
          {q.kind === "scale" ? (
            <ScaleQuestion q={q} counts={results.counts[q.id] || {}} total={total} mine={mine} />
          ) : (
            <BarsQuestion q={q} counts={results.counts[q.id] || {}} total={total} mine={mine} />
          )}
          {q.kind === "multi" && <p className="svr-note">אפשר היה לבחור יותר מתשובה אחת, לכן הסכום עולה על 100%.</p>}
        </section>
      ))}
    </div>
  );
}
