-- מעקב כניסות לאתר לפאנל הניהול: צפיות בעמודים של מבקרים (גם כאלה שלא נרשמו).
-- אנונימי: לא נשמרת כתובת IP ולא User-Agent מלא. visitor_id הוא מזהה אקראי שנוצר בדפדפן של המבקר ומבדיל
-- בין מבקר חוזר למבקר חדש. user_id מתמלא רק כשהמבקרת מחוברת לחשבון.

CREATE TABLE IF NOT EXISTS site_visits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  visited_at TEXT NOT NULL,
  day TEXT NOT NULL,
  path TEXT NOT NULL,
  visitor_id TEXT NOT NULL,
  user_id TEXT,
  country TEXT,
  city TEXT,
  source TEXT,
  device TEXT,
  browser TEXT
);
CREATE INDEX IF NOT EXISTS idx_site_visits_day ON site_visits (day);
CREATE INDEX IF NOT EXISTS idx_site_visits_visitor ON site_visits (visitor_id, visited_at);
