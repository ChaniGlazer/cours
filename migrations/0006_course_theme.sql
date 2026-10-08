-- ערכת נושא לקורס: מזהה אילו קורסים מקבלים את העיצוב המיוחד (למשל 'python-soft'),
-- במקום זיהוי לפי שם. NULL = העיצוב הרגיל של האתר.
ALTER TABLE courses ADD COLUMN theme TEXT;

UPDATE courses SET theme = 'python-soft' WHERE id = 'python-ai-era';
