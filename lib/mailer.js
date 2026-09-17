// lib/mailer.js
//
// שולח אימיילים (כרגע רק איפוס סיסמה) דרך Resend (REST API). ב-Cloudflare Workers
// אין תמיכה אמינה בחיבורי SMTP גולמיים, ולכן במקום nodemailer/SMTP משתמשים כאן
// ב-fetch מול ה-API של Resend (https://resend.com).
//
// אם לא הוגדרו RESEND_API_KEY/EMAIL_FROM ב-.env - לא נכשלים בשקט. הקישור לאיפוס
// מודפס ללוג של השרת, כך שבזמן ההקמה הראשונית (לפני שמגדירים מייל) אפשר עדיין
// לעזור למשתמש לאפס סיסמה ע"י בדיקת הלוג.

const RESEND_API_URL = "https://api.resend.com/emails";

function isConfigured() {
  return Boolean(process.env.RESEND_API_KEY && process.env.EMAIL_FROM);
}

export async function sendPasswordResetEmail({ to, resetUrl, courseTitle }) {
  if (!isConfigured()) {
    console.warn(
      `[איפוס סיסמה] לא הוגדרו RESEND_API_KEY/EMAIL_FROM ב-.env. קישור האיפוס עבור ${to} (תקף לשעה אחת): ${resetUrl}`
    );
    return;
  }

  try {
    const res = await fetch(RESEND_API_URL, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        from: `${courseTitle} <${process.env.EMAIL_FROM}>`,
        to,
        subject: "איפוס סיסמה",
        text: `התקבלה בקשה לאיפוס הסיסמה שלך ב${courseTitle}.\n\nלאיפוס הסיסמה, היכנסו לקישור הבא (תקף לשעה אחת):\n${resetUrl}\n\nאם לא ביקשתם זאת - אפשר להתעלם מהמייל הזה, הסיסמה שלך לא תשתנה.`,
        html: `
          <div dir="rtl" style="font-family:Arial,Helvetica,sans-serif;font-size:16px;line-height:1.7;color:#16242b;max-width:480px;margin:0 auto;">
            <p>התקבלה בקשה לאיפוס הסיסמה שלך ב<strong>${courseTitle}</strong>.</p>
            <p style="margin:28px 0;">
              <a href="${resetUrl}" style="background:#d6a24c;color:#16242b;padding:14px 28px;border-radius:999px;text-decoration:none;font-weight:bold;display:inline-block;">
                איפוס סיסמה
              </a>
            </p>
            <p style="color:#4b5a60;font-size:14px;">הקישור תקף לשעה אחת. אם לא ביקשתם זאת - אפשר להתעלם מהמייל הזה, הסיסמה שלך לא תשתנה.</p>
          </div>
        `
      })
    });

    if (!res.ok) {
      const errText = await res.text();
      throw new Error(`Resend החזיר שגיאה (${res.status}): ${errText.slice(0, 500)}`);
    }
  } catch (err) {
    // לא מעבירים את השגיאה למשתמש (כדי לא לחשוף אם המייל קיים במערכת) -
    // אבל מדפיסים אותה ללוג של השרת כדי שתוכלו לדבג בעיות Resend, ועדיין
    // מדפיסים את הקישור כגיבוי כדי שתוכלו לעזור למשתמש באופן ידני.
    console.error("[איפוס סיסמה] שליחת המייל נכשלה:", err);
    console.warn(`[איפוס סיסמה] קישור גיבוי עבור ${to}: ${resetUrl}`);
  }
}
