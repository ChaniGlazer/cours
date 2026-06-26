import { db } from "@/lib/db";
import PaymentStatusPoller from "./PaymentStatusPoller";

export default async function PaymentSuccessPage({ searchParams }) {
  const params = await searchParams;
  const orderId = params?.order;
  let payment = null;
  if (orderId) {
    payment = db.prepare("SELECT status FROM payments WHERE id = ?").get(orderId);
  }

  if (payment?.status === "paid") {
    return (
      <section className="section">
        <div className="container form-narrow" style={{ textAlign: "center" }}>
          <h1>התשלום התקבל 🎉</h1>
          <p className="text-soft">הגישה לקורס נפתחה עבורכם.</p>
          <a href="/course" className="btn btn-primary">
            כניסה לקורס
          </a>
        </div>
      </section>
    );
  }

  if (payment?.status === "failed") {
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
