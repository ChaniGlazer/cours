import { registerAction } from "@/app/actions/auth";

const ERROR_MESSAGES = {
  name: "יש להזין שם מלא (לפחות 2 תווים).",
  email: "יש להזין כתובת אימייל תקינה.",
  password: "הסיסמה צריכה להיות באורך 8 תווים לפחות.",
  exists: "כתובת האימייל הזו כבר רשומה במערכת. נסו להתחבר במקום זאת."
};

export default async function RegisterPage({ searchParams }) {
  const params = await searchParams;
  const error = ERROR_MESSAGES[params?.error] || null;
  const next = params?.next || "/course";

  return (
    <section className="section">
      <div className="container form-narrow">
        <h1 style={{ textAlign: "center" }}>הרשמה</h1>
        <p className="text-soft" style={{ textAlign: "center", marginBottom: 28 }}>
          יוצרים חשבון, ואז ממשיכים לתשלום מאובטח לקבלת גישה לקורס.
        </p>

        <div className="card-elevated">
          {error && <div className="alert alert-error">{error}</div>}

          <form action={registerAction}>
            <input type="hidden" name="next" value={next} />
            <div className="field">
              <label htmlFor="name">שם מלא</label>
              <input id="name" name="name" type="text" required minLength={2} autoComplete="name" />
            </div>
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
                minLength={8}
                autoComplete="new-password"
              />
            </div>
            <button type="submit" className="btn btn-primary btn-block">
              המשך לתשלום
            </button>
          </form>
        </div>

        <p className="text-soft" style={{ textAlign: "center", marginTop: 18 }}>
          יש לכם כבר חשבון? <a href={`/login?next=${encodeURIComponent(next)}`}>התחברות</a>
        </p>
      </div>
    </section>
  );
}
