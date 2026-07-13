import { requestPasswordResetAction } from "@/app/actions/password-reset";

export const metadata = {
  title: "שכחתי סיסמה",
  robots: { index: false, follow: false }
};

const ERROR_MESSAGES = {
  missing_token: "הקישור לא תקין. בקשו קישור איפוס חדש.",
  expired: "הקישור פג תוקף או שלא היה תקין. בקשו קישור איפוס חדש."
};

export default async function ForgotPasswordPage({ searchParams }) {
  const params = await searchParams;
  const sent = params?.sent === "1";
  const error = ERROR_MESSAGES[params?.error] || null;

  return (
    <section className="section">
      <div className="container form-narrow">
        <h1 style={{ textAlign: "center" }}>שכחתם סיסמה?</h1>

        <div className="card-elevated" style={{ marginTop: 20 }}>
          {sent ? (
            <div className="alert alert-success">
              אם קיים חשבון עם כתובת האימייל הזו, שלחנו לשם קישור לאיפוס סיסמה.
              בדקו את תיבת הדואר (וגם את תיקיית הספאם).
            </div>
          ) : (
            <>
              {error && <div className="alert alert-error">{error}</div>}
              <p className="text-soft">
                הזינו את כתובת האימייל שנרשמתם איתה, ונשלח לכם קישור לאיפוס הסיסמה.
              </p>
              <form action={requestPasswordResetAction}>
                <div className="field">
                  <label htmlFor="email">אימייל</label>
                  <input id="email" name="email" type="email" required autoComplete="email" />
                </div>
                <button type="submit" className="btn btn-primary btn-block">
                  שליחת קישור לאיפוס
                </button>
              </form>
            </>
          )}
        </div>

        <p className="text-soft" style={{ textAlign: "center", marginTop: 18 }}>
          <a href="/login">חזרה להתחברות</a>
        </p>
      </div>
    </section>
  );
}
