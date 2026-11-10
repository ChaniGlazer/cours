-- סקר "איך היית לומדת פיתוח בעידן ה-AI". שלוש טבלאות, בכוונה בלי שום קישור ביניהן:
--
-- survey_responses: תשובות הסקר. אנונימיות לגמרי: בלי מייל, בלי IP, בלי מזהה דפדפן, ורק היום (לא שעה)
--   כדי שאי אפשר יהיה להצליב תשובה עם מייל לפי זמן השליחה. שדות מרובי בחירה נשמרים כ-JSON.
-- survey_subscribers: מי שהשאירה מייל. marketing_consent=1 רק אם סימנה בעצמה את תיבת הדיוור (לא מסומנת מראש).
--   consent_at/consent_text/source נשמרים כראיה להסכמה. ייצוא לדיוור כולל רק marketing_consent=1.
-- survey_rate: הגבלת קצב. hash של כתובת IP (מומלח בתאריך) בלבד, נמחק אחרי שעה.

CREATE TABLE IF NOT EXISTS survey_responses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  day TEXT NOT NULL,
  stage TEXT NOT NULL,
  ai_usage INTEGER NOT NULL,
  feelings TEXT NOT NULL,
  priorities TEXT NOT NULL,
  manual_first TEXT NOT NULL,
  junior_risk INTEGER NOT NULL,
  open_text TEXT
);
CREATE INDEX IF NOT EXISTS idx_survey_responses_day ON survey_responses (day);

CREATE TABLE IF NOT EXISTS survey_subscribers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT NOT NULL UNIQUE,
  marketing_consent INTEGER NOT NULL DEFAULT 0,
  consent_at TEXT,
  consent_text TEXT,
  source TEXT NOT NULL DEFAULT 'survey',
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS survey_rate (
  ip_hash TEXT NOT NULL,
  at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_survey_rate_ip ON survey_rate (ip_hash, at);
