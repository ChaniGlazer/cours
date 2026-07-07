// lib/cardcom.js
//
// אינטגרציה עם שירות הסליקה קארדקום (Cardcom), דרך ה-API הרשמי (LowProfile, גרסה v11).
//
// ⚠️ חשוב לדעת: התיעוד הרשמי המלא של קארדקום (כולל ה-Swagger ב-
// https://secure.cardcom.solutions/Api/v11/Docs) נמצא מאחורי התחברות לחשבון סוחר,
// ולכן הקובץ הזה נכתב על סמך הדוגמאות הציבוריות הקיימות בתיעוד שלהם. לפני מעבר
// לסביבת אמת (production) חשוב לבדוק את הפרטים הבאים מול נציג קארדקום/התיעוד
// בחשבון שלכם:
//   1. שמות השדות המדויקים שמוחזרים מ-LowProfile/Create (כאן: json.Url, json.LowProfileId)
//   2. הפורמט המדויק שבו קארדקום קוראים ל-WebHookUrl (הקוד כאן לא מסתמך על שדות
//      ספציפיים מתוך גוף/query string של הקריאה עצמה - הוא רק מחלץ ממנה את
//      LowProfileId, ואז מאמת את כל שאר הפרטים בקריאת שרת-לשרת חוזרת ל-GetLpResult)
//   3. האם צריך להוסיף פרטי חשבונית (Document) אם רוצים הפקת חשבונית אוטומטית -
//      זה לא ממומש כאן כרגע
//
// כל הקריאות נעשות מהשרת בלבד (כפי שדורש קארדקום) ולא מהדפדפן.

const BASE_URL = "https://secure.cardcom.solutions/api/v11";

function requiredCreds() {
  const terminalNumber = process.env.CARDCOM_TERMINAL_NUMBER;
  const apiName = process.env.CARDCOM_API_NAME;
  if (!terminalNumber || !apiName) {
    throw new Error(
      "חוסרים פרטי חיבור לקארדקום: יש להגדיר CARDCOM_TERMINAL_NUMBER ו-CARDCOM_API_NAME בקובץ .env (מתקבלים מהתמיכה של קארדקום)"
    );
  }
  return { terminalNumber: Number(terminalNumber), apiName };
}

/**
 * פותח תהליך תשלום חדש (LowProfile) ומחזיר כתובת לדף תשלום מאובטח של קארדקום.
 */
export async function createLowProfile({
  sum,
  description,
  successUrl,
  cancelUrl,
  notifyUrl,
  returnValue
}) {
  const { terminalNumber, apiName } = requiredCreds();

  const res = await fetch(`${BASE_URL}/LowProfile/Create`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      TerminalNumber: terminalNumber,
      ApiName: apiName,
      ReturnValue: returnValue,
      Amount: sum,
      Operation: "ChargeOnly",
      Language: "he",
      ISOCoinId: 1,
      ProductName: description || "רכישת קורס",
      SuccessRedirectUrl: successUrl,
      FailedRedirectUrl: cancelUrl,
      WebHookUrl: notifyUrl
    })
  });

  const text = await res.text();
  let json;
  try {
    json = JSON.parse(text);
  } catch {
    throw new Error(`תגובה לא תקינה מקארדקום בעת יצירת תשלום: ${text.slice(0, 500)}`);
  }

  const okStatus = Number(json?.ResponseCode) === 0;
  if (!okStatus || !json?.Url) {
    throw new Error(
      `קארדקום דחו את יצירת התשלום: ${json?.Description || JSON.stringify(json).slice(0, 500)}`
    );
  }

  return {
    url: json.Url,
    lowProfileId: json.LowProfileId,
    raw: json
  };
}

/**
 * שולף את תוצאת העסקה בפועל ישירות משרתי קארדקום (server-to-server, עם
 * TerminalNumber/ApiName שלנו). משמש כאן כבדיקת-אבטחה: רק אם קארדקום מאשרים
 * בפועל שהעסקה הזו קיימת ותקינה - נסמן את המשתמש כ"שילם", ולא מסתפקים
 * בתוכן ה-webhook שהתקבל.
 */
export async function getLowProfileResult({ lowProfileId }) {
  const { terminalNumber, apiName } = requiredCreds();

  const res = await fetch(`${BASE_URL}/LowProfile/GetLpResult`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      TerminalNumber: terminalNumber,
      ApiName: apiName,
      LowProfileId: lowProfileId
    })
  });

  const text = await res.text();
  let json;
  try {
    json = JSON.parse(text);
  } catch {
    return { ok: false, raw: text };
  }

  const ok = Number(json?.ResponseCode) === 0 && Boolean(json?.TranzactionId);
  const amount = json?.TranzactionInfo?.Amount ?? json?.Amount;

  return {
    ok,
    returnValue: json?.ReturnValue,
    transactionId: json?.TranzactionId,
    amount: amount !== undefined ? parseFloat(amount) : undefined,
    raw: json
  };
}

/**
 * מחלץ את מזהה ה-LowProfile מתוך גוף/כתובת בקשת ה-webhook שמתקבלת מקארדקום,
 * בלי תלות בפורמט המדויק (query string, JSON, או form-data) או ברישיות
 * המדויקת של שם השדה.
 */
export function pickLowProfileId(body, searchParams) {
  const candidates = ["LowProfileId", "lowprofilecode", "lowProfileId", "LowProfileID"];
  for (const key of candidates) {
    if (body && body[key]) return body[key];
    if (searchParams && searchParams.get(key)) return searchParams.get(key);
  }
  return undefined;
}
