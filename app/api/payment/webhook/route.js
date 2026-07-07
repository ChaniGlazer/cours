// app/api/payment/webhook/route.js
//
// כתובת זו מוגדרת כ-WebHookUrl בבקשת LowProfile/Create (זה קורה אוטומטית בקובץ
// app/actions/payment.js). קארדקום קוראים לכתובת הזו ישירות מהשרת שלהם (לא
// מהדפדפן של הלקוח) לאחר שהתשלום מתבצע, כדי לעדכן את האתר שלנו שהעסקה בוצעה.
//
// מכיוון שהפורמט המדויק של קריאת ה-webhook (query string מול גוף הבקשה, ושמות
// השדות המדויקים בו) לא מתועד באופן ציבורי מלא, אנחנו לא מסתמכים עליו לשום דבר
// מלבד חילוץ LowProfileId. את כל שאר הפרטים (האם התשלום אכן הצליח, הסכום, ומזהה
// העסקה) שולפים בקריאת שרת-לשרת חוזרת ל-GetLpResult, עם TerminalNumber/ApiName
// שלנו - כך שאי אפשר "לזייף" קריאת webhook כדי לסמן תשלום כמוצלח.

import { db, nowIso } from "@/lib/db";
import { markUserPaid } from "@/lib/auth";
import { getLowProfileResult, pickLowProfileId } from "@/lib/cardcom";

async function handleWebhook(request) {
  const searchParams = request.nextUrl.searchParams;
  const contentType = request.headers.get("content-type") || "";
  let body = {};

  try {
    if (request.method === "POST") {
      if (contentType.includes("application/json")) {
        body = await request.json();
      } else if (contentType) {
        const formData = await request.formData();
        for (const [key, value] of formData.entries()) {
          body[key] = value;
        }
      }
    }
  } catch (err) {
    console.error("[קארדקום webhook] שגיאה בפענוח גוף הבקשה:", err);
    return new Response("bad request", { status: 400 });
  }

  const lowProfileId = pickLowProfileId(body, searchParams);

  console.log("[קארדקום webhook] התקבלה הודעה:", { lowProfileId });

  // מגיבים 200 כברירת מחדל למצבים לא תקינים, כדי שקארדקום לא ינסו לשלוח את
  // ההודעה שוב ושוב על נתונים שלא נוכל בכל מקרה לעבד.
  if (!lowProfileId) {
    return new Response("missing low profile id", { status: 200 });
  }

  // שלב אימות קריטי: קוראים בחזרה לשרתי קארדקום (server-to-server, עם
  // TerminalNumber/ApiName שלנו) כדי לוודא שהעסקה אכן קיימת ותקינה, ולא
  // להסתפק רק בתוכן ה-webhook שהתקבל.
  let result;
  try {
    result = await getLowProfileResult({ lowProfileId });
  } catch (err) {
    console.error("[קארדקום webhook] קריאה ל-GetLpResult נכשלה:", err);
    return new Response("verification call failed", { status: 200 });
  }

  const orderId = result.returnValue;
  if (!orderId) {
    console.warn("[קארדקום webhook] לא התקבל ReturnValue מ-GetLpResult:", result.raw);
    return new Response("missing return value", { status: 200 });
  }

  const payment = db.prepare("SELECT * FROM payments WHERE id = ?").get(orderId);
  if (!payment) {
    console.warn("[קארדקום webhook] לא נמצא תשלום מתאים ל-order:", orderId);
    return new Response("unknown order", { status: 200 });
  }

  // אם כבר עיבדנו את התשלום הזה בעבר (קארדקום עשויים לשלוח את ההודעה יותר
  // מפעם אחת) - לא עושים כלום
  if (payment.status === "paid") {
    return new Response("already processed", { status: 200 });
  }

  if (!result.ok) {
    db.prepare(
      "UPDATE payments SET status = 'failed', raw_log = ?, updated_at = ? WHERE id = ?"
    ).run(JSON.stringify(result.raw).slice(0, 2000), nowIso(), orderId);
    return new Response("payment not completed", { status: 200 });
  }

  // בדיקת התאמת סכום, עם סבילות קטנה לעיגולים
  if (Number.isFinite(result.amount) && Math.abs(result.amount - payment.amount) > 0.5) {
    console.error("[קארדקום webhook] אי-התאמה בסכום:", {
      expected: payment.amount,
      received: result.amount
    });
    db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
      JSON.stringify(result.raw).slice(0, 2000),
      nowIso(),
      orderId
    );
    return new Response("amount mismatch", { status: 200 });
  }

  db.prepare(
    "UPDATE payments SET status = 'paid', cardcom_transaction_id = ?, raw_log = ?, updated_at = ? WHERE id = ?"
  ).run(String(result.transactionId), JSON.stringify(result.raw).slice(0, 2000), nowIso(), orderId);

  markUserPaid(payment.user_id);

  return new Response("ok", { status: 200 });
}

export async function POST(request) {
  return handleWebhook(request);
}

export async function GET(request) {
  // קארדקום קוראים ל-WebHookUrl לרוב ב-GET; זו גם דרך נוחה לבדוק זמינות
  // הכתובת בדפדפן בעת ההגדרה (בלי lowProfileId זה פשוט יחזיר תשובה ריקה)
  return handleWebhook(request);
}
