// רכיבי UI משותפים (ללא state - מתאימים גם ל-server components).
// הסגנונות נמצאים ב-globals.css תחת "Shared UI".

export function Badge({ kind = "free", children }) {
  return <span className={`ui-badge ui-badge--${kind}`}>{children}</span>;
}

export function CourseBadge({ course }) {
  if (course.coming_soon) return <Badge kind="soon">בקרוב</Badge>;
  return course.is_paid ? <Badge kind="paid">₪{course.price_ils}</Badge> : <Badge kind="free">חינם</Badge>;
}

export function ProgressBar({ value, max, label, thin = false }) {
  const pct = max > 0 ? Math.round((value / max) * 100) : 0;
  return (
    <div
      className={`ui-progress${thin ? " ui-progress--thin" : ""}`}
      role="progressbar"
      aria-label={label}
      aria-valuemin={0}
      aria-valuemax={max}
      aria-valuenow={value}
    >
      <i style={{ width: `${pct}%` }} />
    </div>
  );
}

export function Chip({ href, active, children }) {
  return (
    <a href={href} className={`ui-chip${active ? " is-active" : ""}`} aria-current={active ? "true" : undefined}>
      {children}
    </a>
  );
}
