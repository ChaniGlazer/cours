import { loginAction } from "@/app/actions/auth";

const ERROR_MESSAGES = {
  invalid: "אימייל או סיסמה שגויים."
};

export default async function LoginPage({ searchParams }) {
  const params = await searchParams;
  const error = ERROR_MESSAGES[params?.error] || null;
  const next = params?.next || "/course";

  return (
    <section className="section">
      <div className="container form-narrow">
        <h1 style={{ textAlign: "center" }}>התחברות</h1>

        <div className="card-elevated" style={{ marginTop: 20 }}>
          {error && <div className="alert alert-error">{error}</div>}

          <form action={loginAction}>
            <input type="hidden" name="next" value={next} />
            <div className="field">
              <label htmlFor="email">אימייל</label>
              <input id="email" name="email" type="email" required autoComplete="email" />
            </div>
            <div className="field">
              <label htmlFor="password">סיסמה</label>
              <input
                id="password"
                name="password"
                type="password"
                required
                autoComplete="current-password"
              />
            </div>
            <button type="submit" className="btn btn-primary btn-block">
              התחברות
            </button>
          </form>
        </div>

        <p className="text-soft" style={{ textAlign: "center", marginTop: 18 }}>
          אין לכם חשבון? <a href={`/register?next=${encodeURIComponent(next)}`}>הרשמה</a>
        </p>
      </div>
    </section>
  );
}
