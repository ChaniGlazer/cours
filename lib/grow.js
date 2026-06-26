// lib/grow.js
//
// אינטגרציה עם שירות הסליקה Grow (לשעבר "משולם").
//
// ⚠️ חשוב לדעת: התיעוד הרשמי המלא של Grow נמצא מאחורי התחברות לחשבון
// (https://grow-il.readme.io/ ו-https://doc.meshulam.co.il/), ולכן הקובץ הזה נכתב
// על סמך הדוגמאות הציבוריות הקיימות בתיעוד שלהם. לפני מעבר לסביבת אמת (production)
// חשוב לבדוק את הפרטים הבאים מול נציג Grow/התיעוד בחשבון שלכם:
//   1. שמות השדות המדויקים שמוחזרים בקריאה ל-createPaymentProcess (כאן: data.url)
//   2. הפורמט המדויק של ה-webhook שנשלח ל-notifyUrl (כאן: תומך גם ב-JSON וגם בטופס)
//   3. האם נדרשת קריאה ל-approveTransaction בסוג העסקה שלכם (כאן: כן, כצעד אימות)
//
// כל הקריאות נעשות מהשרת בלבד (כפי שדורש Grow) ולא מהדפדפן.

const ENV = process.env.GROW_ENV === "production" ? "production" : "sandbox";
const BASE_URL =
  ENV === "production" ? "https://api.meshulam.co.il" : "https://sandbox.meshulam.co.il";
const LIGHT_API = `${BASE_URL}/api/light/server/1.0`;

function requiredCreds() {
  const userId = process.env.GROW_USER_ID;
  const pageCode = process.env.GROW_PAGE_CODE;
  if (!userId || !pageCode) {
    throw new Error(
      "חוסרים פרטי חיבור ל-Grow: יש להגדיר GROW_USER_ID ו-GROW_PAGE_CODE בקובץ .env (מתקבלים מהתמיכה של Grow)"
    );
  }
  return { userId, pageCode };
}

/**
 * פותח תהליך תשלום חדש ומחזיר כתובת לדף תשלום מאובטח של Grow.
 */
export async function createPaymentProcess({
  sum,
  description,
  fullName,
  email,
  phone,
  successUrl,
  cancelUrl,
  notifyUrl,
  cField1
}) {
  const { userId, pageCode } = requiredCreds();

  const form = new FormData();
  form.append("pageCode", pageCode);
  form.append("userId", userId);
  if (process.env.GROW_API_KEY) form.append("apiKey", process.env.GROW_API_KEY);
  form.append("sum", String(sum));
  form.append("description", description || "");
  form.append("successUrl", successUrl);
  form.append("cancelUrl", cancelUrl);
  form.append("notifyUrl", notifyUrl);
  form.append("paymentNum", "1");
  form.append("cField1", cField1);
  if (fullName) form.append("pageField[fullName]", fullName);
  if (email) form.append("pageField[email]", email);
  if (phone) form.append("pageField[phone]", phone);

  const res = await fetch(`${LIGHT_API}/createPaymentProcess`, {
    method: "POST",
    body: form
  });

  const text = await res.text();
  let json;
  try {
    json = JSON.parse(text);
  } catch {
    throw new Error(`תגובה לא תקינה מ-Grow בעת יצירת תשלום: ${text.slice(0, 500)}`);
  }

  const url = json?.data?.url || json?.url;
  const okStatus = String(json?.status) === "1";

  if (!okStatus || !url) {
    throw new Error(`Grow דחה את יצירת התשלום: ${json?.err || JSON.stringify(json).slice(0, 500)}`);
  }

  return {
    url,
    processId: json?.data?.processId || json?.data?.authCode || null,
    raw: json
  };
}

/**
 * שלב אישור עסקה. נדרש (לפי תיעוד Grow) ברוב זרימות התשלום הרגילות כדי לסגור את העסקה בפועל.
 * משמש כאן גם כבדיקת-אבטחה נוספת: רק אם Grow מאשר בפועל שהעסקה הזו קיימת ותקינה
 * (server-to-server, עם pageCode שלנו) - נסמן את המשתמש כ"שילם".
 */
export async function approveTransaction({ transactionId }) {
  const { pageCode } = requiredCreds();

  const form = new FormData();
  form.append("pageCode", pageCode);
  form.append("transactionId", transactionId);

  const res = await fetch(`${LIGHT_API}/approveTransaction`, {
    method: "POST",
    body: form
  });

  const text = await res.text();
  let json;
  try {
    json = JSON.parse(text);
  } catch {
    return { ok: false, raw: text };
  }

  return { ok: String(json?.status) === "1", raw: json };
}

/**
 * מחלץ שדה מתוך גוף ה-webhook שמתקבל מ-Grow, בלי תלות בכך שהוא מגיע
 * כ-JSON מקונן ({ data: { ... } }) או כשדות שטוחים (form-data / x-www-form-urlencoded).
 */
export function pickField(body, name) {
  if (!body) return undefined;
  if (body[name] !== undefined) return body[name];
  if (body.data && body.data[name] !== undefined) return body.data[name];
  return undefined;
}

export const GROW_ENV = ENV;
