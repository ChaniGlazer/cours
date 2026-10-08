-- המלצות שתלמידים כותבים בעצמם. הן נשמרות כ-'pending' ומוצגות באתר רק אחרי אישור בעמוד הניהול.
-- המלצות קיימות (שנוצרו ע"י המנהל) נשארות 'approved' ומוצגות בכל הקורסים (course_id ריק).
ALTER TABLE testimonials ADD COLUMN status TEXT NOT NULL DEFAULT 'approved';
ALTER TABLE testimonials ADD COLUMN user_id TEXT;
ALTER TABLE testimonials ADD COLUMN course_id TEXT;
CREATE UNIQUE INDEX IF NOT EXISTS idx_testimonials_user_course ON testimonials (user_id, course_id) WHERE user_id IS NOT NULL;
