// lib/tutorCourses.js
//
// הקורסים שהחונכת פעילה בהם: קבוע אחד משותף, בלי import, כדי שגם ה-client (LessonLayout) וגם השרת (app/api/tutor/route.js)
// ישתמשו באותה רשימה. השרת ממילא אוכף אותה ב-403. התקצירים (lib/tutorLessons.js) נשארים בצד השרת בלבד.
// להרחבה: מוסיפים כאן מזהה קורס, ואת התקצירים שלו ב-TUTOR_LESSONS.
export const TUTOR_COURSES = ["python-ai-era"];
