import { redirect } from "next/navigation";
import { isAdmin } from "@/lib/admin-auth";
import { getAnalytics } from "@/lib/analytics";

export const dynamic = "force-dynamic";

const fmt = (iso) =>
  new Date(iso).toLocaleString("he-IL", { dateStyle: "short", timeStyle: "short", timeZone: "Asia/Jerusalem" });

export default async function AnalyticsPage({ searchParams }) {
  if (!(await isAdmin())) redirect("/admin");
  const params = await searchParams;
  const days = [7, 30, 90].includes(Number(params?.days)) ? Number(params.days) : 30;
  const a = getAnalytics(days);
  const max = Math.max(1, ...a.perDay.map((d) => d.c));

  return (
    <section className="section">
      <div className="container" style={{ maxWidth: 960 }}>
        <p>
          <a href="/admin">← חזרה לניהול האתר</a>
        </p>
        <h1>מי נכנס לאתר</h1>
        <p className="text-soft">
          תקופה:{" "}
          {[7, 30, 90].map((d) => (
            <a key={d} href={`/admin/analytics?days=${d}`} style={{ marginInlineEnd: 12, fontWeight: d === days ? 700 : 400 }}>
              {d} ימים
            </a>
          ))}
          · כניסות שלך כמנהל/ת ובוטים אינם נספרים.
        </p>

        <div className="stat-grid">
          <div className="stat-tile"><strong>{a.totals.today.u}</strong>מבקרים היום</div>
          <div className="stat-tile"><strong>{a.totals.today.c}</strong>צפיות היום</div>
          <div className="stat-tile"><strong>{a.totals.range.u}</strong>מבקרים ייחודיים ({days} ימים)</div>
          <div className="stat-tile"><strong>{a.totals.range.c}</strong>צפיות ({days} ימים)</div>
          <div className="stat-tile"><strong>{a.totals.registered}</strong>נרשמים שנכנסו</div>
        </div>

        <div className="card">
          <h2>צפיות ליום</h2>
          {a.perDay.length === 0 ? (
            <p className="text-soft">עדיין אין נתונים.</p>
          ) : (
            <>
              <div className="bar-chart">
                {a.perDay.map((d) => (
                  <div key={d.d} className="bar" style={{ height: `${(d.c / max) * 100}%` }} title={`${d.d}: ${d.c} צפיות, ${d.u} מבקרים`} />
                ))}
              </div>
              <p className="text-soft" style={{ fontSize: "0.8rem" }}>
                {a.perDay[0].d} — {a.perDay[a.perDay.length - 1].d}
              </p>
            </>
          )}
        </div>

        <div className="admin-grid" style={{ marginTop: 20 }}>
          <div className="card">
            <h2>עמודים פופולריים</h2>
            <table className="data-table">
              <thead><tr><th>עמוד</th><th>צפיות</th><th>מבקרים</th></tr></thead>
              <tbody>{a.topPages.map((p) => <tr key={p.path}><td dir="ltr">{p.path}</td><td>{p.c}</td><td>{p.u}</td></tr>)}</tbody>
            </table>
          </div>
          <div className="card">
            <h2>מאיפה הגיעו</h2>
            {a.referrers.length === 0 ? <p className="text-soft">כניסות ישירות / אין נתוני הפניה.</p> : (
              <table className="data-table">
                <thead><tr><th>מקור</th><th>כניסות</th></tr></thead>
                <tbody>{a.referrers.map((r) => <tr key={r.referrer}><td dir="ltr">{r.referrer}</td><td>{r.c}</td></tr>)}</tbody>
              </table>
            )}
            <h3 style={{ marginTop: 16 }}>מכשירים</h3>
            <table className="data-table">
              <tbody>{a.devices.map((d) => <tr key={d.device}><td>{d.device}</td><td>{d.c}</td></tr>)}</tbody>
            </table>
          </div>
        </div>

        <div className="card" style={{ marginTop: 20 }}>
          <h2>נרשמים שנכנסו לאתר</h2>
          {a.registeredVisitors.length === 0 ? <p className="text-soft">אין עדיין.</p> : (
            <div className="table-scroll">
              <table className="data-table">
                <thead><tr><th>שם</th><th>מייל</th><th>שילם</th><th>כניסות</th><th>אחרונה</th></tr></thead>
                <tbody>{a.registeredVisitors.map((u) => (
                  <tr key={u.email}><td>{u.name}</td><td dir="ltr">{u.email}</td><td>{u.paid ? "כן" : "לא"}</td><td>{u.c}</td><td>{fmt(u.last_seen)}</td></tr>
                ))}</tbody>
              </table>
            </div>
          )}
        </div>

        <div className="card" style={{ marginTop: 20 }}>
          <h2>100 הכניסות האחרונות</h2>
          <div className="table-scroll">
            <table className="data-table">
              <thead><tr><th>זמן</th><th>מי</th><th>עמוד</th><th>מקור</th><th>מכשיר</th></tr></thead>
              <tbody>{a.recent.map((v, i) => (
                <tr key={i}>
                  <td>{fmt(v.created_at)}</td>
                  <td>{v.user_name ? `${v.user_name}` : `אורח/ת #${v.visitor_hash.slice(0, 5)}`}</td>
                  <td dir="ltr">{v.path}</td>
                  <td dir="ltr">{v.referrer || "ישיר"}</td>
                  <td>{v.device} · {v.browser}</td>
                </tr>
              ))}</tbody>
            </table>
          </div>
          <p className="text-soft" style={{ fontSize: "0.85rem" }}>
            אורחים שלא נרשמו מוצגים כמזהה אנונימי (כתובת ה־IP אינה נשמרת). נרשמים מזוהים לפי שמם.
          </p>
        </div>
      </div>
    </section>
  );
}
