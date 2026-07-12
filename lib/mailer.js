// lib/mailer.js
//
// שולח אימיילים (איפוס סיסמה + קבלת פנים בהרשמה) דרך SMTP. עובד עם כל ספק
// SMTP - גם Gmail (עם App Password), וגם ספקי דואר טרנזקציוני כמו
// SendGrid/Mailgun/Resend (לכולם יש ממשק SMTP).
//
// אם לא הוגדרו פרטי SMTP ב-.env - לא נכשלים בשקט. הקישור לאיפוס מודפס
// ללוג של השרת, כך שבזמן ההקמה הראשונית (לפני שמגדירים מייל) אפשר עדיין
// לעזור למשתמש לאפס סיסמה ע"י בדיקת הלוג.

import nodemailer from "nodemailer";

function isConfigured() {
  return Boolean(process.env.SMTP_HOST && process.env.SMTP_USER && process.env.SMTP_PASS);
}

function getTransport() {
  return nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: parseInt(process.env.SMTP_PORT || "587", 10),
    secure: String(process.env.SMTP_PORT) === "465",
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS
    }
  });
}

export async function sendPasswordResetEmail({ to, resetUrl, courseTitle }) {
  if (!isConfigured()) {
    console.warn(
      `[איפוס סיסמה] לא הוגדרו פרטי SMTP ב-.env. קישור האיפוס עבור ${to} (תקף לשעה אחת): ${resetUrl}`
    );
    return;
  }

  const from = process.env.SMTP_FROM || process.env.SMTP_USER;
  const transport = getTransport();

  try {
    await transport.sendMail({
      from: `"${courseTitle}" <${from}>`,
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
    });
  } catch (err) {
    // לא מעבירים את השגיאה למשתמש (כדי לא לחשוף אם המייל קיים במערכת) -
    // אבל מדפיסים אותה ללוג של השרת כדי שתוכלו לדבג בעיות SMTP, ועדיין
    // מדפיסים את הקישור כגיבוי כדי שתוכלו לעזור למשתמש באופן ידני.
    console.error("[איפוס סיסמה] שליחת המייל נכשלה:", err);
    console.warn(`[איפוס סיסמה] קישור גיבוי עבור ${to}: ${resetUrl}`);
  }
}

// שימו לב: בכוונה אין כאן פרמטר של סיסמה, וזה לא מקרי - לעולם לא שולחים
// סיסמה בטקסט גלוי במייל, גם לא את הסיסמה שהמשתמש/ת עצמם בחרו. מדיניות
// הפרטיות של האתר (app/privacy/page.js) מבטיחה שהסיסמה נשמרת רק כ-hash
// ואינה נגישה לעיון גם עבורנו - שליחתה במייל תפר את ההבטחה הזו, ותשאיר
// עותק קריא בתיבת הדואר של המשתמש/ת (ובלוגים של ספק המייל) לצמיתות.
export async function sendWelcomeEmail({ to, name, courseTitle, siteUrl }) {
  if (!isConfigured()) {
    console.warn(`[ברוכים הבאים] לא הוגדרו פרטי SMTP ב-.env. לא נשלח מייל קבלת פנים ל-${to}.`);
    return;
  }

  const from = process.env.SMTP_FROM || process.env.SMTP_USER;
  const transport = getTransport();
  const courseUrl = siteUrl ? `${siteUrl}/course` : null;

  try {
    await transport.sendMail({
      from: `"${courseTitle}" <${from}>`,
      to,
      subject: `ברוכים הבאים ל${courseTitle}!`,
      text: `שלום ${name},\n\nברוכים הבאים ל${courseTitle}! ההרשמה שלך התקבלה בהצלחה.\n\nלכניסה לחשבון תמיד אפשר להשתמש בכתובת האימייל והסיסמה שבחרת בהרשמה.${courseUrl ? `\n${courseUrl}` : ""}\n\nבהצלחה בלימודים!`,
      html: `
        <div dir="rtl" style="font-family:Arial,Helvetica,sans-serif;font-size:16px;line-height:1.7;color:#16242b;max-width:480px;margin:0 auto;">
          <p>שלום ${name},</p>
          <p>ברוכים הבאים ל<strong>${courseTitle}</strong>! ההרשמה שלך התקבלה בהצלחה.</p>
          <p>לכניסה לחשבון תמיד אפשר להשתמש בכתובת האימייל והסיסמה שבחרת בהרשמה.</p>
          ${
            courseUrl
              ? `<p style="margin:28px 0;">
            <a href="${courseUrl}" style="background:#d6a24c;color:#16242b;padding:14px 28px;border-radius:999px;text-decoration:none;font-weight:bold;display:inline-block;">
              כניסה לקורס
            </a>
          </p>`
              : ""
          }
          <p style="color:#4b5a60;font-size:14px;">בהצלחה בלימודים!</p>
        </div>
      `
    });
  } catch (err) {
    // לא מעכבים/נכשלים את ההרשמה בגלל תקלת SMTP - רק מתעדים ללוג.
    console.error("[ברוכים הבאים] שליחת מייל קבלת הפנים נכשלה:", err);
  }
}
