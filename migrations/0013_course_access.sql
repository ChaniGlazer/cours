-- גישה ידנית לקורס: המנהלת מוסיפה לומדת מסוימת (לפי מייל) שרשאית לראות קורס, גם אם הוא "בקרוב" או בתשלום.
-- לא נוגע בתשלומים: זו טבלה נפרדת.
CREATE TABLE IF NOT EXISTS course_access (
  user_id TEXT NOT NULL,
  course_id TEXT NOT NULL,
  created_at TEXT NOT NULL,
  PRIMARY KEY (user_id, course_id)
);
