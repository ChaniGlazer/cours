// lib/surveyInsights.js
//
// ממצאים בולטים מתוצאות הסקר, לעמוד /survey/results. פונקציות טהורות (בלי DB), על המבנה של getSurveyResults():
// { total, counts: { [questionId]: { [optionKey]: n } } }. הניסוח כאן, כדי שיהיה קל לשנות במקום אחד.
import { QUESTION_BY_ID } from "./surveyConfig";

const pct = (n, total) => (total > 0 ? Math.round((n / total) * 100) : 0);
const sum = (counts, keys) => keys.reduce((s, k) => s + (counts?.[k] || 0), 0);

export function computeInsights(results) {
  const total = results?.total || 0;
  const c = results?.counts || {};

  const stats = [
    {
      id: "ai_daily",
      emoji: "⚡",
      pct: pct(sum(c.ai_usage, ["4", "5"]), total),
      text: "משתמשות ב-AI בכתיבת קוד כמעט כל יום, או כל יום"
    },
    {
      id: "not_learning",
      emoji: "😬",
      pct: pct(sum(c.feelings, ["not_learning"]), total),
      text: "חוששות שהן לא באמת לומדות כשה-AI כותב להן את הקוד"
    },
    {
      id: "manual_first",
      emoji: "🛠️",
      pct: pct(sum(c.manual_first, ["yes", "start_only"]), total),
      text: "חושבות שצריך ללמוד לכתוב קוד ידנית לפני ה-AI, לפחות בהתחלה"
    },
    {
      id: "junior_risk",
      emoji: "😰",
      pct: pct(sum(c.junior_risk, ["4", "5"]), total),
      text: "חושבות שה-AI מסכן את העתיד של מפתחות ג'וניור, די הרבה או מאוד"
    }
  ];

  // הנושא שהכי הרבה בחרו כחשוב ללמוד, ועוד שני הבאים אחריו
  const prio = QUESTION_BY_ID.priorities.options
    .map((o) => ({ ...o, n: c.priorities?.[o.key] || 0 }))
    .sort((a, b) => b.n - a.n)
    .map((o) => ({ key: o.key, emoji: o.emoji, label: o.label, pct: pct(o.n, total) }));

  return { total, stats, topPriorities: prio.slice(0, 3) };
}
