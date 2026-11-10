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
      short: "משתמשים ב-AI בקוד כמעט כל יום",
      emoji: "⚡",
      pct: pct(sum(c.ai_usage, ["4", "5"]), total),
      text: "משתמשים ב-AI בכתיבת קוד כמעט כל יום, או כל יום"
    },
    {
      id: "auto_check",
      short: "רוצים תרגול עם בדיקה אוטומטית",
      emoji: "✅",
      pct: pct(sum(c.help_format, ["auto_check"]), total),
      text: "רוצים תרגול עם בדיקה אוטומטית, כדי לראות מיד אם הקוד עובד"
    },
    {
      id: "manual_first",
      short: "בעד ללמוד קוד ידנית קודם",
      emoji: "🛠️",
      pct: pct(sum(c.manual_first, ["yes", "start_only"]), total),
      text: "חושבים שצריך ללמוד לכתוב קוד ידנית לפני ה-AI, לפחות בהתחלה"
    },
    {
      id: "junior_risk",
      short: "חוששים על מפתחים בתחילת דרכם",
      emoji: "😰",
      pct: pct(sum(c.junior_risk, ["4", "5"]), total),
      text: "חושבים שה-AI מסכן את העתיד של מפתחים בתחילת דרכם, די הרבה או מאוד"
    }
  ];

  // הנושא שהכי הרבה בחרו כחשוב ללמוד, ועוד שני הבאים אחריו
  const prio = QUESTION_BY_ID.priorities.options
    .map((o) => ({ ...o, n: c.priorities?.[o.key] || 0 }))
    .sort((a, b) => b.n - a.n)
    .map((o) => ({ key: o.key, emoji: o.emoji, label: o.label, pct: pct(o.n, total) }));

  return { total, stats, topPriorities: prio.slice(0, 3) };
}
