"use client";

import { useActionState } from "react";
import { submitTestimonialAction } from "@/app/actions/testimonials";

const STATUS_TEXT = {
  pending: "ההמלצה שלך ממתינה לאישור. אפשר לערוך אותה עד אז, ושינוי יחזיר אותה לאישור מחדש.",
  approved: "ההמלצה שלך מוצגת באתר. עריכה תחזיר אותה לאישור מחדש.",
  rejected: "ההמלצה שלך לא אושרה לפרסום. אפשר לערוך ולשלוח שוב."
};

export default function TestimonialForm({ courseId, defaultName, existing }) {
  const [state, run, pending] = useActionState(submitTestimonialAction.bind(null, courseId), null);

  return (
    <form action={run} className="card testimonial-form">
      <h3>{existing ? "ההמלצה שלך" : "למדת בקורס? שתפו אחרים בחוויה"}</h3>
      {existing && <p className="text-soft">{STATUS_TEXT[existing.status] || STATUS_TEXT.pending}</p>}

      {state?.ok && (
        <div className="alert alert-success" role="status">
          {state.message}
        </div>
      )}
      {state && !state.ok && (
        <div className="alert alert-error" role="alert">
          {state.error}
        </div>
      )}

      <div className="field">
        <label htmlFor="tf-quote">מה חשבת על הקורס?</label>
        <textarea id="tf-quote" name="quote" rows={4} maxLength={600} required defaultValue={existing?.quote || ""} />
      </div>
      <div className="field">
        <label htmlFor="tf-result">מה השגת בעקבות הקורס? (אופציונלי)</label>
        <input id="tf-result" name="result" maxLength={160} defaultValue={existing?.result || ""} placeholder="למשל: בניתי את האפליקציה הראשונה שלי" />
      </div>
      <div className="testimonial-form__row">
        <div className="field">
          <label htmlFor="tf-name">שם שיוצג באתר</label>
          <input id="tf-name" name="name" maxLength={60} required defaultValue={existing?.name || defaultName || ""} />
        </div>
        <div className="field">
          <label htmlFor="tf-role">תפקיד / הקשר (אופציונלי)</label>
          <input id="tf-role" name="role" maxLength={80} defaultValue={existing?.role || ""} />
        </div>
      </div>
      <p className="text-soft" style={{ fontSize: "0.85rem" }}>
        ההמלצה תפורסם רק לאחר אישור.
      </p>
      <button type="submit" className="btn btn-primary" disabled={pending}>
        {pending ? "שולח…" : existing ? "עדכון המלצה" : "שליחת המלצה"}
      </button>
    </form>
  );
}
