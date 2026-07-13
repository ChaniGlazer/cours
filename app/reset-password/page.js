import { resetPasswordAction } from "@/app/actions/password-reset";

export const metadata = {
  title: "איפוס סיסמה",
  robots: { index: false, follow: false }
};

const ERROR_MESSAGES = {
  password: "הסיסמה צריכה להיות באורך 8 תווים לפחות.",
  mismatch: "הסיסמאות אינן תואמות.",
  rate_limited: "יותר מדי ניסיונות. נסו שוב בעוד כמה דקות."
};

export default async function ResetPasswordPage({ searchParams }) {
  const params = await searchParams;
  const token = params?.token || "";
  const error = ERROR_MESSAGES[params?.error] || null;

  if (!token) {
    return (
      <section className="section">
        <div className="container form-narrow" style={{ textAlign: "center" }}>
          <h1>קישור לא תקין</h1>
          <p className="text-soft">הקישור הזה לא תקין או שכבר נוצל.</p>
          <a href="/forgot-password" className="btn btn-primary">
            בקשת קישור איפוס חדש
          </a>
        </div>
      </section>
    );
  }

  return (
    <section className="section">
      <div className="container form-narrow">
        <h1 style={{ textAlign: "center" }}>בחירת סיסמה חדשה</h1>

        <div className="card-elevated" style={{ marginTop: 20 }}>
          {error && <div className="alert alert-error">{error}</div>}

          <form action={resetPasswordAction}>
            <input type="hidden" name="token" value={token} />
            <div className="field">
              <label htmlFor="password">סיסמה חדשה</label>
              <input
                id="password"
                name="password"
                type="password"
                required
                minLength={8}
                autoComplete="new-password"
              />
            </div>
            <div className="field">
              <label htmlFor="confirmPassword">אימות סיסמה</label>
              <input
                id="confirmPassword"
                name="confirmPassword"
                type="password"
                required
                minLength={8}
                autoComplete="new-password"
              />
            </div>
            <button type="submit" className="btn btn-primary btn-block">
              שמירת סיסמה חדשה
            </button>
          </form>
        </div>
      </div>
    </section>
  );
}
