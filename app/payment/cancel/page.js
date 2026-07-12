import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";

export default async function PaymentCancelPage({ searchParams }) {
  const params = await searchParams;
  const reason = params?.reason;

  const user = await getCurrentUser();
  if (user?.paid) {
    redirect("/course");
  }

  return (
    <section className="section">
      <div className="container form-narrow" style={{ textAlign: "center" }}>
        <h1>התשלום בוטל</h1>
        <p className="text-soft">
          {reason === "init_failed"
            ? "לא הצלחנו לפתוח את דף התשלום כרגע. נסו שוב בעוד כמה דקות."
            : "התשלום בוטל ולא חויבתם."}
        </p>
        <a href="/course" className="btn btn-primary">
          חזרה לתשלום
        </a>
      </div>
    </section>
  );
}
