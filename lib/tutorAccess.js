// lib/tutorAccess.js
//
// מי מקבלת את החונכת: מתג כיבוי כללי (TUTOR_ENABLED) והפעלה הדרגתית לפי רשימת מיילים (TUTOR_ALLOW_EMAILS). קובץ עצמאי (בלי import).
// הערכים נקראים בצד השרת בלבד, בכל בקשה: ה-route (app/api/tutor/route.js) ועמוד השיעור (שמחליט אם להציג את הרכיב).
// ה-client מקבל רק החלטה בוליאנית אחת (להציג או לא), ולא את המשתנים עצמם או את רשימת המיילים.

// מתג כיבוי: TUTOR_ENABLED=false מכבה את החונכת לכולן. מתג כיבוי צריך להיות סלחני, ולכן גם " False " מכבה. כל ערך אחר (או לא מוגדר) = פעיל.
export function tutorEnabled() {
  return String(process.env.TUTOR_ENABLED ?? "").trim().toLowerCase() !== "false";
}

// רשימת המיילים שמותרים (אותיות קטנות, בלי רווחים ובלי ערכים ריקים). רשימה ריקה = אין הגבלה.
export function tutorAllowEmails() {
  return String(process.env.TUTOR_ALLOW_EMAILS ?? "")
    .split(",")
    .map((s) => s.trim().toLowerCase())
    .filter(Boolean);
}

// האם למשתמשת (או למי שלא מחוברת, user=null) מותר להשתמש בחונכת לפי רשימת המיילים. בלי רשימה: כולן. עם רשימה: רק מחוברת שהמייל שלה ברשימה.
export function tutorAllowedFor(user) {
  const list = tutorAllowEmails();
  if (list.length === 0) return true;
  const email = String(user?.email ?? "").trim().toLowerCase();
  return email !== "" && list.includes(email);
}

// ההחלטה היחידה שמגיעה לרכיב: האם להציג את החונכת בכלל.
export function tutorVisibleFor(user) {
  return tutorEnabled() && tutorAllowedFor(user);
}
