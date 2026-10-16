-- מעקב לומדות לפאנל הניהול: כניסות והתקדמות לפי שיעור (עד עכשיו ההתקדמות נשמרה רק ב-localStorage).
-- לא מכיל תוכן של שיחות או קוד, רק מי נכנס, מתי, ואילו שיעורים נפתחו / הושלמו.

ALTER TABLE users ADD COLUMN last_login_at TEXT;
ALTER TABLE users ADD COLUMN login_count INTEGER NOT NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN last_active_at TEXT;

CREATE TABLE IF NOT EXISTS lesson_progress (
  user_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  lesson_slug TEXT NOT NULL,
  first_seen_at TEXT,
  last_seen_at TEXT,
  visits INTEGER NOT NULL DEFAULT 0,
  done INTEGER NOT NULL DEFAULT 0,
  done_at TEXT,
  auto INTEGER NOT NULL DEFAULT 0,
  ex_done INTEGER NOT NULL DEFAULT 0,
  ex_total INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, course_id, lesson_slug)
);
CREATE INDEX IF NOT EXISTS idx_lesson_progress_user ON lesson_progress (user_id);
