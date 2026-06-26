// app/api/payment/webhook/route.js
//
// כתובת זו צריכה להיות מוגדרת כ-notifyUrl בבקשת createPaymentProcess (זה קורה אוטומטית
// בקובץ app/actions/payment.js). Grow קוראים לכתובת הזו ישירות מהשרת שלהם (לא מהדפדפן
// של הלקוח) לאחר שהתשלום מתבצע, כדי לעדכן את האתר שלנו שהעסקה אושרה.

import { db, nowIso } from "@/lib/db";
import { markUserPaid } from "@/lib/auth";
import { approveTransaction, pickField } from "@/lib/grow";

export async function POST(request) {
  const contentType = request.headers.get("content-type") || "";
  let body = {};

  try {
    if (contentType.includes("application/json")) {
      body = await request.json();
    } else {
      const formData = await request.formData();
      body = {};
      for (const [key, value] of formData.entries()) {
        body[key] = value;
      }
    }
  } catch (err) {
    console.error("[Grow webhook] שגיאה בפענוח גוף הבקשה:", err);
    return new Response("bad request", { status: 400 });
  }

  const orderId = pickField(body, "cField1");
  const transactionId = pickField(body, "transactionId");
  const statusCode = pickField(body, "statusCode");
  const sum = pickField(body, "sum");

  console.log("[Grow webhook] התקבלה הודעה:", { orderId, transactionId, statusCode, sum });

  // מגיבים 200 כברירת מחדל למצבים לא תקינים, כדי ש-Grow לא ינסה לשלוח את ההודעה
  // שוב ושוב על נתונים שלא נוכל בכל מקרה לעבד.
  if (!orderId) {
    return new Response("missing order id", { status: 200 });
  }

  const payment = db.prepare("SELECT * FROM payments WHERE id = ?").get(orderId);
  if (!payment) {
    console.warn("[Grow webhook] לא נמצא תשלום מתאים ל-order:", orderId);
    return new Response("unknown order", { status: 200 });
  }

  // אם כבר עיבדנו את התשלום הזה בעבר (Grow עשויים לשלוח את ההודעה יותר מפעם אחת) - לא עושים כלום
  if (payment.status === "paid") {
    return new Response("already processed", { status: 200 });
  }

  const isPaidStatus = String(statusCode) === "2";
  if (!isPaidStatus) {
    db.prepare(
      "UPDATE payments SET status = 'failed', grow_transaction_id = ?, raw_log = ?, updated_at = ? WHERE id = ?"
    ).run(transactionId || null, JSON.stringify(body).slice(0, 2000), nowIso(), orderId);
    return new Response("payment not completed", { status: 200 });
  }

  // בדיקת התאמת סכום, עם סבילות קטנה לעיגולים
  const paidSum = parseFloat(sum);
  if (Number.isFinite(paidSum) && Math.abs(paidSum - payment.amount) > 0.5) {
    console.error("[Grow webhook] אי-התאמה בסכום:", { expected: payment.amount, received: paidSum });
    db.prepare("UPDATE payments SET raw_log = ?, updated_at = ? WHERE id = ?").run(
      JSON.stringify(body).slice(0, 2000),
      nowIso(),
      orderId
    );
    return new Response("amount mismatch", { status: 200 });
  }

  if (!transactionId) {
    console.error("[Grow webhook] חסר transactionId - לא ניתן לאמת את העסקה מול Grow");
    return new Response("missing transaction id", { status: 200 });
  }

  // שלב אימות קריטי: קוראים בחזרה לשרתי Grow (server-to-server, עם pageCode שלנו) כדי
  // לוודא שהעסקה אכן קיימת ותקינה, ולא להסתפק רק בתוכן ה-webhook שהתקבל.
  let approveResult;
  try {
    approveResult = await approveTransaction({ transactionId });
  } catch (err) {
    console.error("[Grow webhook] קריאה ל-approveTransaction נכשלה:", err);
    return new Response("approve call failed", { status: 200 });
  }

  if (!approveResult.ok) {
    console.error("[Grow webhook] Grow לא אישרו את העסקה:", approveResult.raw);
    return new Response("not approved", { status: 200 });
  }

  db.prepare(
    "UPDATE payments SET status = 'paid', grow_transaction_id = ?, raw_log = ?, updated_at = ? WHERE id = ?"
  ).run(transactionId, JSON.stringify(body).slice(0, 2000), nowIso(), orderId);

  markUserPaid(payment.user_id);

  return new Response("ok", { status: 200 });
}

export async function GET() {
  // נוח לבדיקת זמינות הכתובת בדפדפן בעת ההגדרה
  return new Response("webhook endpoint is up", { status: 200 });
}
