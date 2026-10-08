-- מסמן קורס כ"בקרוב": מוצג בקטלוג עם תגית "בקרוב" במקום מחיר, ואי אפשר לרכוש אותו עדיין.
ALTER TABLE courses ADD COLUMN coming_soon INTEGER NOT NULL DEFAULT 0;

UPDATE courses SET coming_soon = 1 WHERE id = 'ai-app-dev';
