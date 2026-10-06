-- הופך את האתר ממכירת קורס יחיד לקטלוג ריבוי-קורסים. כל קורס קיים (חינמי או
-- בתשלום) מקבל שורה משלו; שיעורים ותשלומים משויכים אליו דרך course_id.

CREATE TABLE IF NOT EXISTS courses (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  subtitle TEXT,
  description TEXT,
  is_paid INTEGER NOT NULL DEFAULT 0,
  price_ils INTEGER,
  hero_video_url TEXT,
  position INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

ALTER TABLE lessons ADD COLUMN course_id TEXT NOT NULL DEFAULT 'ai-app-dev';
ALTER TABLE lessons ADD COLUMN slug TEXT;
ALTER TABLE payments ADD COLUMN course_id TEXT NOT NULL DEFAULT 'ai-app-dev';

INSERT INTO courses (id, title, subtitle, description, is_paid, price_ils, position, created_at) VALUES
  (
    'ai-app-dev',
    'פיתוח אפליקציות מבוססות AI',
    'ללמוד לבנות ולהוציא לפרודקשן אפליקציות אמיתיות בעזרת כלי AI',
    'ערכו את התיאור המלא של הקורס בעמוד הניהול (/admin), והוסיפו שיעורים.',
    1,
    (SELECT CAST(value AS INTEGER) FROM settings WHERE key = 'price'),
    1,
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  ),
  (
    'python-ai-era',
    'קורס לימוד פייתון בעידן ה-AI',
    'לימודי פייתון אינטראקטיביים - חינם לכולם',
    'קורס חינמי ללימוד פייתון, עם שיעורים אינטראקטיביים.',
    0,
    NULL,
    2,
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
  );

UPDATE lessons SET course_id = 'python-ai-era', slug = 'if-statements'
  WHERE title LIKE 'שיעור 1%' OR title LIKE '%תנאי%';
UPDATE lessons SET course_id = 'python-ai-era', slug = 'for-while-loops'
  WHERE title LIKE 'שיעור 2%' OR title LIKE '%לולאות%';

-- שם המותג הגלובלי שמוצג בהדר/פוטר/כותרת הדפדפן, נפרד מכותרות הקורסים עצמם.
INSERT INTO settings (key, value) VALUES
  ('site_title', 'קורסים בעידן ה-AI');
