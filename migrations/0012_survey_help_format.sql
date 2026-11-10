-- שאלה חדשה בסקר: "מה הכי היה עוזר לכם ללמוד?" (עד שתי בחירות, נשמר כ-JSON כמו feelings/priorities).
-- עמודה אופציונלית: תשובות ישנות נשארות NULL, ודפדפן עם גרסה ישנה של הדף עדיין יכול לשלוח בלי השדה.
-- ALTER TABLE ADD COLUMN אינו idempotent: להריץ פעם אחת בלבד.
ALTER TABLE survey_responses ADD COLUMN help_format TEXT;
