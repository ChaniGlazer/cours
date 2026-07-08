// lib/invoice4u.js
//
// אינטגרציה עם ה-Clearing API של Invoice4U (סליקת אשראי + יצירת מסמך/לקוח אוטומטית
// באותה קריאה, דרך הפעולה ProcessApiRequestV2).
//
// הקובץ הזה אומת מול קריאות אמיתיות לחשבון Invoice4U אמיתי (לא sandbox - אין כזה
// מתועד ל-Clearing API), כולל תגובות אמיתיות שנשמרו ונבדקו. כמה פרטים לא היו
// מתועדים בתיעוד הציבורי וגולו רק מבדיקה בפועל:
//   - כל תגובות ה-API עטופות במעטפת "d" (מוסכמת JSON קלאסית של ASMX/WCF) - השדות
//     האמיתיים נמצאים תחת json.d.*, לא ברמה העליונה.
//   - ProcessApiRequestV2 מזדהה עם Invoice4UUserApiKey (כפי שמתועד), אבל
//     GetClearingLogById משתמש בפרמטר "token" (לא Invoice4UUserApiKey) ו-
//     "clearingLogId" (camelCase, לא ClearingLogId) - זה לא מופיע בתיעוד הציבורי.
//   - GetClearingLogByParams (שכן מתועד) החזיר ECONNRESET בכל ניסיון קריאה -
//     כנראה כי "PaymentId" שם מתייחס למספר הפנימי של Invoice4U (מתחיל מ-0 ומתעדכן
//     רק אחרי חיוב מוצלח), לא ל-OrderIdClientUsage שלנו. השתמשנו במקום זאת ב-
//     GetClearingLogById עם המזהה המספרי I4UClearingLogId שמוחזר כבר בתגובת
//     ProcessApiRequestV2 (בתוך מערך OpenInfo).
//   - IsSuccess בתגובת GetClearingLogById הוא true גם לפני שהתשלום בפועל הושלם -
//     הוא מציין רק שרשומת ה-clearing נוצרה בהצלחה, לא שהחיוב אושר. הזיהוי בפועל
//     של תשלום מוצלח מתבסס על PaymentId שהופך למספר אמיתי (לא "0") ו/או
//     TransactionId/ClearingConfirmationNumber שהופכים לא-ריקים.
//
// כל הקריאות נעשות מהשרת בלבד (לעולם לא מהדפדפן), כי הן כוללות את מפתח ה-API.

const BASE_URL = "https://api.invoice4u.co.il/Services/ApiService.svc";

// קוד חברת הסליקה שמוגדרת בחשבון Invoice4U שלכם: Meshulam=7, UPay=6, YaadSarig=12, Cardcom=15
const DEFAULT_CC_COMPANY = 15;

function requiredApiKey() {
  const apiKey = process.env.INVOICE4U_API_KEY;
  if (!apiKey) {
    throw new Error(
      "חסר מפתח API של Invoice4U: יש להגדיר INVOICE4U_API_KEY בקובץ .env (נוצר ב-private.invoice4u.co.il -> הגדרות חשבון -> API -> Generate)"
    );
  }
  return apiKey;
}

function ccCompanyType() {
  const parsed = parseInt(process.env.INVOICE4U_CC_COMPANY, 10);
  return Number.isFinite(parsed) ? parsed : DEFAULT_CC_COMPANY;
}

async function postJson(path, body) {
  const res = await fetch(`${BASE_URL}/${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body)
  });

  const text = await res.text();
  try {
    return JSON.parse(text);
  } catch {
    throw new Error(`תגובה לא תקינה מ-Invoice4U (${path}): ${text.slice(0, 500)}`);
  }
}

/**
 * פותח בקשת סליקה חדשה ומחזיר כתובת iframe לתשלום מאובטח, יחד עם המזהה המספרי
 * (clearingLogId) שצריך לשמור אצלנו כדי לבדוק סטטוס אחר כך עם getClearingLogById.
 * orderId הוא המזהה הפנימי שלנו (payments.id), נשלח כ-OrderIdClientUsage.
 */
export async function createClearingRequest({
  sum,
  description,
  fullName,
  email,
  phone,
  orderId,
  returnUrl,
  docHeadline,
  createDocument = true
}) {
  const apiKey = requiredApiKey();

  const request = {
    Invoice4UUserApiKey: apiKey,
    Type: 1, // Regular
    CreditCardCompanyType: ccCompanyType(),
    IsAutoCreateCustomer: true,
    FullName: fullName,
    Email: email,
    Phone: phone,
    Sum: sum,
    Description: description,
    PaymentsNum: 1,
    Currency: "ILS",
    OrderIdClientUsage: orderId,
    ReturnUrl: returnUrl,
    IsDocCreate: createDocument,
    DocHeadline: docHeadline || description,
    DocLanguage: "he"
  };

  const json = await postJson("ProcessApiRequestV2", { request });
  const body = json?.d || json;

  // לא לשמור את מפתח ה-API בחזרה בלוג (הוא מוחזר ב-echo בתגובה של Invoice4U)
  if (body && typeof body === "object") delete body.Invoice4UUserApiKey;

  const url = body?.ClearingRedirectUrl;

  if (!url) {
    const errors = body?.Errors?.length ? JSON.stringify(body.Errors) : null;
    throw new Error(
      `Invoice4U לא החזיר כתובת סליקה${errors ? `: ${errors}` : ""}: ${JSON.stringify(json).slice(0, 500)}`
    );
  }

  const openInfo = Array.isArray(body?.OpenInfo) ? body.OpenInfo : [];
  const clearingLogId = openInfo.find((kv) => kv?.Key === "I4UClearingLogId")?.Value || null;

  return { url, clearingLogId, raw: json };
}

/**
 * שולף את סטטוס עסקת הסליקה לפי המזהה המספרי clearingLogId (מוחזר מ-createClearingRequest).
 * מחזיר { ok, raw } כאשר ok הוא true/false/null - null כשעדיין לא ברור מהתגובה (התשלום
 * עדיין לא הושלם ע"י המשתמש). שימו לב: IsSuccess בתגובה תמיד true גם לפני תשלום בפועל,
 * לכן לא ניתן להסתמך עליו לבד - ראו interpretClearingLog למטה.
 */
export async function getClearingLogById({ clearingLogId }) {
  const apiKey = requiredApiKey();

  const json = await postJson("GetClearingLogById", {
    clearingLogId: Number(clearingLogId),
    token: apiKey
  });

  const log = json?.d || json;
  const ok = interpretClearingLog(log);

  return { ok, raw: json };
}

function interpretClearingLog(log) {
  if (!log) return null;

  const errors = Array.isArray(log.Errors) ? log.Errors : [];
  const errorMessage = log.ErrorMessage || "";
  if (errors.length > 0 || errorMessage) return false;

  const paymentId = log.PaymentId;
  const hasRealPaymentId = paymentId !== undefined && paymentId !== null && String(paymentId) !== "0";
  const hasTransactionId = Boolean(log.TransactionId);
  const hasConfirmationNumber = Boolean(log.ClearingConfirmationNumber);

  if (hasRealPaymentId || hasTransactionId || hasConfirmationNumber) return true;

  return null;
}
