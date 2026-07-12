import { redirect } from "next/navigation";
import { db } from "@/lib/db";
import { getCurrentUser } from "@/lib/auth";
import PaymentStatusPoller from "./PaymentStatusPoller";

export default async function PaymentSuccessPage({ searchParams }) {
  const params = await searchParams;
  const orderId = params?.order;
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }

  let payment = orderId
    ? db.prepare("SELECT status, user_id FROM payments WHERE id = ?").get(orderId)
    : null;
  if (payment && payment.user_id !== user.id) payment = null;

  // כבר יש גישה (התשלום הזה אושר, או שהמשתמש כבר מסומן כמשלם ממקור אחר,
  // כמו סימון ידני בעמוד הניהול) - אין צורך במסך ביניים, ממשיכים ישר לקורס.
  if (user.paid || payment?.status === "paid") {
    redirect("/course");
  }

  if (!payment) {
    // אין תשלום תקף לבדוק כאן (orderId חסר/שגוי, או שייך למשתמש אחר) - אין
    // מה "לאשר". חוזרים לעמוד הקורס, שיציג בעצמו את המסך הנכון (תשלום/שיעורים).
    redirect("/course");
  }

  if (payment.status === "failed") {
    return (
      <section className="section">
        <div className="container form-narrow" style={{ textAlign: "center" }}>
          <h1>התשלום לא הושלם</h1>
          <p className="text-soft">משהו לא הסתדר עם התשלום. ניתן לנסות שוב.</p>
          <a href="/course" className="btn btn-primary">
            חזרה לתשלום
          </a>
        </div>
      </section>
    );
  }

  return (
    <section className="section">
      <div className="container form-narrow" style={{ textAlign: "center" }}>
        <h1>מאשרים את התשלום…</h1>
        <p className="text-soft">זה אורך כמה שניות בלבד. הדף יתעדכן אוטומטית.</p>
        <PaymentStatusPoller orderId={orderId} />
      </div>
    </section>
  );
}
