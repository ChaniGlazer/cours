-- מבנה הטבלאות הראשוני של האתר (זהה למה שהיה ב-migrate() ב-lib/db.js בגרסת node:sqlite)
-- וה-seed ההתחלתי של settings/lessons (זהה למה שהיה ב-seedIfEmpty()).
-- מורץ דרך: wrangler d1 migrations apply <db-name> --local|--remote

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  paid INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS sessions (
  token TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  expires_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS admin_sessions (
  token TEXT PRIMARY KEY,
  expires_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS payments (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  amount REAL NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  clearing_log_id TEXT,
  raw_log TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS lessons (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  video_url TEXT,
  position INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS testimonials (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT,
  quote TEXT NOT NULL,
  result TEXT,
  photo_url TEXT,
  position INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS settings (
  key TEXT PRIMARY KEY,
  value TEXT
);

CREATE TABLE IF NOT EXISTS password_resets (
  token_hash TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL
);

INSERT INTO settings (key, value) VALUES
  ('course_title', 'שם הקורס שלך'),
  ('course_subtitle', 'כתבו כאן משפט קצר שמסביר למי הקורס ומה הוא נותן'),
  ('course_description', 'זהו טקסט לדוגמה. ערכו אותו בעמוד הניהול (/admin) וכתבו כמה פסקאות שמסבירות מה כלול בקורס, למי הוא מתאים ולמה כדאי להירשם.'),
  ('price', '490'),
  ('currency', 'ILS'),
  ('hero_video_url', ''),
  ('rating_value', ''),
  ('rating_count', ''),
  ('stat_highlight', ''),
  ('problem_text', 'ערכו טקסט זה בעמוד הניהול (/admin) וכתבו כאן את האתגר או התסכול המרכזי שהלומדים שלכם מתמודדים איתו לפני הקורס.'),
  ('outcome_text', 'ערכו טקסט זה בעמוד הניהול (/admin) וכתבו כאן את התוצאה והשינוי שהלומדים מקבלים אחרי הקורס.'),
  ('instructor_name', ''),
  ('instructor_bio', ''),
  ('instructor_photo_url', ''),
  ('guarantee_text', '');

INSERT INTO lessons (id, title, description, video_url, position, created_at) VALUES
  (lower(hex(randomblob(16))), 'שיעור 1 - ערכו אותי בעמוד הניהול', 'תיאור קצר של השיעור. הדביקו כאן קישור לסרטון (מומלץ Vimeo עם הגבלת דומיין, או YouTube לא רשום).', '', 1, strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
  (lower(hex(randomblob(16))), 'שיעור 2 - לדוגמה', 'אפשר להוסיף, לערוך ולמחוק שיעורים בעמוד /admin.', '', 2, strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));
