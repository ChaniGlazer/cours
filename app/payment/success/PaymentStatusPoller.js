"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { checkPaymentStatusAction } from "@/app/actions/payment";

const MAX_ATTEMPTS = 15; // כ-30 שניות בקצב של בדיקה כל 2 שניות

export default function PaymentStatusPoller({ orderId }) {
  const router = useRouter();
  const [attempts, setAttempts] = useState(0);

  useEffect(() => {
    if (!orderId) return;
    let active = true;

    const interval = setInterval(async () => {
      const { status } = await checkPaymentStatusAction(orderId);
      if (!active) return;

      if (status === "paid") {
        clearInterval(interval);
        router.push("/course");
      } else if (status === "failed") {
        clearInterval(interval);
        router.refresh();
      } else {
        setAttempts((a) => a + 1);
      }
    }, 2000);

    return () => {
      active = false;
      clearInterval(interval);
    };
  }, [orderId, router]);

  if (attempts > MAX_ATTEMPTS) {
    return (
      <p className="text-soft" style={{ marginTop: 16 }}>
        זה לוקח יותר זמן מהרגיל. אפשר לרענן את הדף, ואם זה ממשיך - פנו אלינו ונבדוק את התשלום.
      </p>
    );
  }

  return (
    <div style={{ marginTop: 16, fontSize: "2rem" }} aria-hidden="true">
      ⏳
    </div>
  );
}
