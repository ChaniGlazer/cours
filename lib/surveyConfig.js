// lib/surveyConfig.js
//
// הגדרת הסקר: שאלות, אפשרויות ותוויות. משותף ללקוח (app/survey) ולשרת (lib/surveyStore.js, ולידציה לפי רשימת מפתחות סגורה),
// ולכן אסור לייבא לכאן שום דבר שרץ רק בשרת. כדי לשנות ניסוח או להוסיף אפשרות עורכים רק כאן.

export const MAX_OPEN_TEXT = 600;
export const MAX_PRIORITIES = 3;
export const MAX_HELP_FORMAT = 2;

// הנוסח המדויק שהמשתמשת מאשרת. נשמר ב-DB לצד המייל, כך שיש ראיה למה בדיוק הסכימה.
export const CONSENT_TEXT = "אשמח לקבל למייל עדכונים על קורסים חדשים שנפתחים, תכנים ותוצאות הסקר.";

const scale = (labels) => labels.map((label, i) => ({ key: String(i + 1), label, value: i + 1 }));

export const QUESTIONS = [
  {
    id: "stage",
    kind: "single",
    title: "קודם כל, איפה אתם בדרך?",
    resultTitle: "באיזה שלב הם",
    options: [
      { key: "beginner", emoji: "🌱", label: "בתחילת הדרך", hint: "רק נכנסים לעולם הקוד" },
      { key: "switching", emoji: "🔄", label: "מחליפים קריירה", hint: "עוברים לפיתוח מתחום אחר" },
      { key: "learning", emoji: "📚", label: "באמצע לימוד", hint: "באמצע קורס או לימוד עצמי" },
      { key: "developer", emoji: "💻", label: "עובדים בפיתוח", hint: "כותבים קוד בעבודה" },
      { key: "lead", emoji: "🧭", label: "מובילים צוות", hint: "אחראים על קוד ועל אנשים" }
    ]
  },
  {
    id: "ai_usage",
    kind: "scale",
    title: "כמה אתם משתמשים ב-AI כשאתם כותבים קוד?",
    resultTitle: "כמה משתמשים ב-AI בקוד",
    options: scale(["אף פעם", "לפעמים", "כמה פעמים בשבוע", "כמעט כל יום", "כל יום"]),
    emojis: ["🚫", "🌤️", "📅", "⚡", "🔥"]
  },
  {
    id: "priorities",
    kind: "multi",
    max: MAX_PRIORITIES,
    title: "מה הכי חשוב ללמוד היום?",
    hint: `בחרו עד ${MAX_PRIORITIES}`,
    resultTitle: "מה הכי חשוב ללמוד",
    options: [
      { key: "syntax", emoji: "⌨️", label: "תחביר ושפות" },
      { key: "algorithms", emoji: "🧩", label: "חשיבה אלגוריתמית" },
      { key: "review_ai", emoji: "🔍", label: "קריאה ובדיקה של קוד AI" },
      { key: "architecture", emoji: "🏗️", label: "ארכיטקטורה ותכנון" },
      { key: "prompting", emoji: "💬", label: "ניסוח פרומפטים" },
      { key: "debugging", emoji: "🐞", label: "דיבאגינג" }
    ]
  },
  {
    id: "help_format",
    kind: "multi",
    private: true, // התוצאות רק בפאנל הניהול (לא בעמוד הציבורי, לא במסך הסיום ולא ב-API הציבורי)
    max: MAX_HELP_FORMAT,
    title: "מה הכי היה עוזר לכם ללמוד?",
    hint: `בחרו עד ${MAX_HELP_FORMAT}`,
    resultTitle: "מה הכי עוזר ללמוד",
    options: [
      { key: "auto_check", emoji: "✅", label: "תרגול עם בדיקה אוטומטית" },
      { key: "tutor", emoji: "🧑‍🏫", label: "חונך שמלווה אישית" },
      { key: "projects", emoji: "🏗️", label: "פרויקטים אמיתיים" },
      { key: "community", emoji: "👥", label: "קהילה לשאול בה" },
      { key: "video", emoji: "🎬", label: "שיעורי וידאו" }
    ]
  },
  {
    id: "manual_first",
    kind: "single",
    title: "צריך ללמוד לכתוב קוד ידנית לפני שמשתמשים ב-AI?",
    resultTitle: "קוד ידני לפני AI?",
    options: [
      { key: "yes", emoji: "🛠️", label: "כן, חייבים" },
      { key: "start_only", emoji: "🌱", label: "רק בהתחלה" },
      { key: "no", emoji: "🚀", label: "לא, ישר עם AI" }
    ]
  },
  {
    id: "junior_risk",
    kind: "scale",
    title: "האם ה-AI מסכן את העתיד של מפתחים בתחילת דרכם?",
    hint: "1 = בכלל לא, 5 = מאוד",
    resultTitle: "האם ה-AI מסכן מפתחים בתחילת דרכם",
    options: scale(["בכלל לא", "קצת", "באמצע", "די הרבה", "מאוד"]),
    emojis: ["😌", "🙂", "😐", "😟", "😰"]
  },
  {
    id: "open_text",
    kind: "text",
    optional: true,
    title: "מה ה-AI עדיין לא יכול ללמד אתכם, ובשביל זה אתם צריכים בן אדם?",
    hint: "לא חובה, אבל זו השאלה שהכי מעניינת אותי"
  },
  {
    id: "contact",
    kind: "contact",
    optional: true,
    title: "רוצים לקבל את סיכום התוצאות למייל?",
    hint: "נשלח לכם סיכום של מה שיצא, בלי ספאם. לא חובה, והתשובות עצמן נשארות אנונימיות."
  }
];

// שאלות שנספרות בתוצאות (בלי טקסט חופשי ויצירת קשר)
export const RESULT_QUESTIONS = QUESTIONS.filter((q) => ["single", "scale", "multi"].includes(q.kind));
// מה שמוצג לציבור: בלי שאלות שסומנו private
export const PUBLIC_RESULT_QUESTIONS = RESULT_QUESTIONS.filter((q) => !q.private);

export const QUESTION_BY_ID = Object.fromEntries(QUESTIONS.map((q) => [q.id, q]));

export const optionKeys = (id) => QUESTION_BY_ID[id].options.map((o) => o.key);
