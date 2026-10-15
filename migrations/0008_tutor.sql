-- החונך הסוקרטי (POST /api/tutor): מצב בשרת שלא ניתן לסמוך עליו בקליינט, ושלא נשמר בזיכרון של Workers.
-- מורץ דרך: wrangler d1 migrations apply course-db --local|--remote  (בפרודקשן: רק באישור מפורש)

-- מספר הניסיון לכל לומדת ונושא. השרת מגדיל ב-1 בכל הודעת user ומחשב משם את רמת הרמז; הקליינט לא שולח מספר ניסיון בכלל.
-- אחרי 24 שעות בלי פעילות באותו נושא הספירה מתאפסת. מספר הרשומות לכל משתמש מוגבל (ראו lib/tutorStore.js).
CREATE TABLE IF NOT EXISTS tutor_attempts (
  user_id TEXT NOT NULL,
  lesson_slug TEXT NOT NULL,
  topic_key TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL,
  PRIMARY KEY (user_id, lesson_slug, topic_key)
);
CREATE INDEX IF NOT EXISTS idx_tutor_attempts_user_updated ON tutor_attempts (user_id, updated_at);

-- הגבלת קצב: מונה לכל משתמש ולכל "דלי" זמן (שעה או יום, ב-UTC), מתעדכן באטומיות ב-UPSERT.
-- bucket: 'h:YYYYMMDDHH' או 'd:YYYYMMDD'.
CREATE TABLE IF NOT EXISTS tutor_usage (
  user_id TEXT NOT NULL,
  bucket TEXT NOT NULL,
  count INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT NOT NULL,
  PRIMARY KEY (user_id, bucket)
);

-- לוג שימוש מינימלי, בלי תוכן שיחה: מי, מתי, איזה מודל, וכמה טוקנים בתשובה. שורות ישנות מ-30 יום נמחקות.
CREATE TABLE IF NOT EXISTS tutor_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  model TEXT NOT NULL,
  tokens INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX IF NOT EXISTS idx_tutor_log_created ON tutor_log (created_at);
