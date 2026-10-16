// lib/learnerStore.js
//
// מעקב לומדות (migrations/0009_learner_tracking.sql): כתיבת אירועי התקדמות מה-client וקריאה לפאנל הניהול.
// הכתיבה היא UPSERT אטומי; הערכים מגיעים מה-client ולכן נבדקים מול השיעורים האמיתיים ב-D1 לפני שנכתבים.
import { getDb, nowIso } from "./db";

const MAX_SYNC_ITEMS = 200;

// events: [{ courseId, slug, seen?, done?, auto?, exDone?, exTotal? }]. מחזיר כמה אירועים נשמרו.
export async function recordProgress(userId, events) {
  const db = await getDb();
  const { results: known } = await db.prepare("SELECT course_id, slug FROM lessons WHERE slug IS NOT NULL").all();
  const valid = new Set(known.map((l) => `${l.course_id}/${l.slug}`));
  const now = nowIso();
  const stmts = [];
  for (const e of events.slice(0, MAX_SYNC_ITEMS)) {
    if (!valid.has(`${e.courseId}/${e.slug}`)) continue;
    const seen = e.seen ? 1 : 0;
    // done: true = הושלם, false = בוטל, undefined = לא נוגעים.
    const doneSet = e.done === true ? 1 : e.done === false ? 0 : null;
    const hasEx = Number.isInteger(e.exDone) && Number.isInteger(e.exTotal) && e.exTotal > 0 && e.exDone >= 0 && e.exDone <= e.exTotal;
    stmts.push(
      db
        .prepare(
          `INSERT INTO lesson_progress (user_id, course_id, lesson_slug, first_seen_at, last_seen_at, visits, done, done_at, auto, ex_done, ex_total)
           VALUES (?1, ?2, ?3, ?4, ?4, ?5, ?6, CASE WHEN ?6 = 1 THEN ?4 END, ?7, ?8, ?9)
           ON CONFLICT (user_id, course_id, lesson_slug) DO UPDATE SET
             last_seen_at = ?4,
             visits = visits + ?5,
             done = COALESCE(?10, done),
             done_at = CASE WHEN ?10 = 1 AND done = 0 THEN ?4 WHEN ?10 = 0 THEN NULL ELSE done_at END,
             auto = CASE WHEN ?10 IS NULL THEN auto ELSE ?7 END,
             ex_done = CASE WHEN ?11 = 1 THEN ?8 ELSE ex_done END,
             ex_total = CASE WHEN ?11 = 1 THEN ?9 ELSE ex_total END`
        )
        .bind(
          userId, e.courseId, e.slug, now, seen,
          doneSet ?? 0, e.auto && doneSet === 1 ? 1 : 0,
          hasEx ? e.exDone : 0, hasEx ? e.exTotal : 0,
          doneSet, hasEx ? 1 : 0
        )
    );
  }
  if (stmts.length) {
    stmts.push(db.prepare("UPDATE users SET last_active_at = ? WHERE id = ?").bind(now, userId));
    await db.batch(stmts);
  }
  return stmts.length ? stmts.length - 1 : 0;
}

// לפאנל הניהול: כל המשתמשות עם סיכום התקדמות לפי קורס (מספר שיעורים שהושלמו / נפתחו).
export async function getLearnersOverview() {
  const db = await getDb();
  const [{ results: users }, { results: prog }, { results: lessons }] = await Promise.all([
    db.prepare("SELECT id, name, email, paid, created_at, last_login_at, login_count, last_active_at FROM users ORDER BY COALESCE(last_active_at, last_login_at, created_at) DESC").all(),
    db.prepare("SELECT user_id, course_id, lesson_slug, first_seen_at, last_seen_at, visits, done, done_at, auto, ex_done, ex_total FROM lesson_progress").all(),
    db.prepare("SELECT course_id, slug FROM lessons WHERE slug IS NOT NULL").all()
  ]);
  const totals = {};
  for (const l of lessons) totals[l.course_id] = (totals[l.course_id] || 0) + 1;
  const byUser = new Map();
  for (const p of prog) {
    if (!byUser.has(p.user_id)) byUser.set(p.user_id, []);
    byUser.get(p.user_id).push(p);
  }
  return {
    totals,
    learners: users.map((u) => ({ ...u, progress: byUser.get(u.id) || [] }))
  };
}
