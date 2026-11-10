// lib/surveyStore.js
//
// הסקר בצד השרת (migrations/0011_survey.sql): ולידציה מחמירה, שמירה, הגבלת קצב, סיכום תוצאות וייצוא CSV.
// תשובות (survey_responses) ופרטי קשר (survey_subscribers) נשמרים בנפרד ובלי קישור ביניהן.
import { getDb, nowIso } from "./db";
import { israelDay } from "./visitStore";
import { CONSENT_TEXT, MAX_HELP_FORMAT, MAX_OPEN_TEXT, MAX_PRIORITIES, QUESTION_BY_ID, RESULT_QUESTIONS, optionKeys } from "./surveyConfig";

const RATE_LIMIT_PER_HOUR = 8; // תשובות לשעה מאותה כתובת (רשת משותפת, למשל בית ספר, עדיין עוברת)
const MIN_FILL_MS = 6000; // מילוי מהיר מזה הוא בוט
const EMAIL_RE = /^[^\s@]{1,64}@[^\s@.]+(\.[^\s@.]+)+$/;

const fail = (error) => ({ ok: false, error });

// ולידציה של גוף הבקשה. מחזיר { ok, value } עם ערכים נקיים בלבד, או { ok:false, error }.
export function validateSubmission(body) {
  if (!body || typeof body !== "object") return fail("בקשה לא תקינה.");

  const single = (id) => {
    const v = body[id];
    return typeof v === "string" && optionKeys(id).includes(v) ? v : null;
  };
  const stage = single("stage");
  const manual_first = single("manual_first");
  const ai_usage = single("ai_usage");
  const junior_risk = single("junior_risk");
  if (!stage || !manual_first || !ai_usage || !junior_risk) return fail("חסרות תשובות לשאלות החובה.");

  const multi = (id, max) => {
    const v = body[id];
    if (!Array.isArray(v)) return null;
    const keys = [...new Set(v)];
    if (keys.length < 1 || keys.length > max) return null;
    const allowed = optionKeys(id);
    return keys.every((k) => typeof k === "string" && allowed.includes(k)) ? keys : null;
  };
  const feelings = multi("feelings", QUESTION_BY_ID.feelings.options.length);
  const priorities = multi("priorities", MAX_PRIORITIES);
  if (!feelings || !priorities) return fail("חסרות תשובות לשאלות החובה.");
  // שאלה שנוספה מאוחר יותר: אם חסרה (דפדפן עם גרסה ישנה של הדף) לא נכשלים, ואם נשלחה היא חייבת להיות תקינה
  let help_format = null;
  if (body.help_format !== undefined) {
    help_format = multi("help_format", MAX_HELP_FORMAT);
    if (!help_format) return fail("חסרות תשובות לשאלות החובה.");
  }

  let open_text = typeof body.open_text === "string" ? body.open_text.replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, "").trim() : "";
  if (open_text.length > MAX_OPEN_TEXT) return fail(`התשובה החופשית ארוכה מדי (עד ${MAX_OPEN_TEXT} תווים).`);

  const email = typeof body.email === "string" ? body.email.trim().toLowerCase() : "";
  if (email && (email.length > 254 || !EMAIL_RE.test(email))) return fail("כתובת המייל לא נראית תקינה.");
  const consent = body.consent === true;
  if (consent && !email) return fail("כדי לקבל עדכונים צריך להזין כתובת מייל.");

  return {
    ok: true,
    value: {
      stage, manual_first, feelings, priorities, help_format, open_text,
      ai_usage: Number(ai_usage), junior_risk: Number(junior_risk),
      email, consent
    }
  };
}

export function isFillTooFast(elapsedMs) {
  return !(typeof elapsedMs === "number" && Number.isFinite(elapsedMs) && elapsedMs >= MIN_FILL_MS);
}

async function hashIp(ip) {
  const data = new TextEncoder().encode(`${ip}|${israelDay()}|${process.env.SURVEY_SALT || ""}`);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return [...new Uint8Array(digest)].map((b) => b.toString(16).padStart(2, "0")).join("");
}

// מחזיר false אם עברה את המכסה. בלי כתובת IP (פיתוח מקומי) לא מגבילים. הטבלה נוקה משורות ישנות בכל קריאה.
export async function takeRateSlot(ip) {
  if (!ip) return true;
  const db = await getDb();
  const hourAgo = new Date(Date.now() - 3600000).toISOString();
  const hash = await hashIp(ip);
  await db.prepare("DELETE FROM survey_rate WHERE at < ?").bind(hourAgo).run();
  const res = await db
    .prepare(
      `INSERT INTO survey_rate (ip_hash, at) SELECT ?1, ?2
       WHERE (SELECT COUNT(*) FROM survey_rate WHERE ip_hash = ?1 AND at > ?3) < ?4`
    )
    .bind(hash, nowIso(), hourAgo, RATE_LIMIT_PER_HOUR)
    .run();
  return (res.meta?.changes ?? 0) > 0;
}

// שומר תשובות ואת המייל (אם יש) באותה batch אך בלי שום שדה משותף. בשורת התשובות רק היום, לא שעה.
export async function saveSubmission(v) {
  const db = await getDb();
  const now = nowIso();
  const stmts = [
    db
      .prepare(
        `INSERT INTO survey_responses (day, stage, ai_usage, feelings, priorities, manual_first, junior_risk, open_text, help_format)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
      )
      .bind(israelDay(), v.stage, v.ai_usage, JSON.stringify(v.feelings), JSON.stringify(v.priorities), v.manual_first, v.junior_risk, v.open_text || null, v.help_format ? JSON.stringify(v.help_format) : null)
  ];
  if (v.email) {
    // מייל קיים: הסכמה שכבר ניתנה לא נמחקת בגלל שליחה חוזרת בלי סימון. סימון חדש מעדכן את ההסכמה.
    stmts.push(
      db
        .prepare(
          `INSERT INTO survey_subscribers (email, marketing_consent, consent_at, consent_text, source, created_at)
           VALUES (?1, ?2, ?3, ?4, 'survey', ?5)
           ON CONFLICT(email) DO UPDATE SET
             marketing_consent = CASE WHEN ?2 = 1 THEN 1 ELSE marketing_consent END,
             consent_at = CASE WHEN ?2 = 1 THEN ?3 ELSE consent_at END,
             consent_text = CASE WHEN ?2 = 1 THEN ?4 ELSE consent_text END`
        )
        .bind(v.email, v.consent ? 1 : 0, v.consent ? now : null, v.consent ? CONSENT_TEXT : null, now)
    );
  }
  await db.batch(stmts);
}

// סיכום מצטבר לכל שאלה: { total, counts: { [questionId]: { [optionKey]: n } } }. אפסים מוצגים במפורש.
export async function getSurveyResults() {
  const db = await getDb();
  const total = (await db.prepare("SELECT COUNT(*) AS n FROM survey_responses").first())?.n || 0;
  const counts = {};
  const jobs = RESULT_QUESTIONS.map(async (q) => {
    const zero = Object.fromEntries(q.options.map((o) => [o.key, 0]));
    const sql =
      q.kind === "multi"
        ? `SELECT j.value AS k, COUNT(*) AS n FROM survey_responses, json_each(survey_responses.${q.id}) j GROUP BY j.value`
        : `SELECT CAST(${q.id} AS TEXT) AS k, COUNT(*) AS n FROM survey_responses GROUP BY ${q.id}`;
    // q.id מגיע מהקובץ surveyConfig.js (קבוע), לא מקלט של משתמשת
    const rows = (await db.prepare(sql).all()).results;
    for (const r of rows) if (r.k in zero) zero[r.k] = r.n;
    counts[q.id] = zero;
  });
  await Promise.all(jobs);
  return { total, counts };
}

// לפאנל הניהול: תוצאות + תשובות חופשיות אחרונות + רשימת המיילים.
export async function getSurveyAdminData() {
  const db = await getDb();
  const [results, open, subs, days] = await Promise.all([
    getSurveyResults(),
    db.prepare("SELECT day, open_text FROM survey_responses WHERE open_text IS NOT NULL ORDER BY id DESC LIMIT 100").all(),
    db.prepare("SELECT id, email, marketing_consent, consent_at, created_at FROM survey_subscribers ORDER BY id DESC LIMIT 500").all(),
    db.prepare("SELECT day, COUNT(*) AS n FROM survey_responses GROUP BY day ORDER BY day DESC LIMIT 14").all()
  ]);
  return { results, openAnswers: open.results, subscribers: subs.results, perDay: days.results };
}

export async function removeFromMailingList(id) {
  const db = await getDb();
  await db.prepare("UPDATE survey_subscribers SET marketing_consent = 0 WHERE id = ?").bind(id).run();
}

// ----- CSV -----
// BOM בתחילת הקובץ כדי ש-Excel יפתח עברית נכון. תא שמתחיל ב-= + - @ מקבל גרש, נגד הזרקת נוסחאות.
function csvCell(value) {
  let s = value == null ? "" : String(value);
  if (/^[=+\-@\t\r]/.test(s)) s = `'${s}`;
  return /[",\n\r]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
}
const toCsv = (header, rows) => "﻿" + [header, ...rows].map((r) => r.map(csvCell).join(",")).join("\r\n") + "\r\n";

// רק מי שאישרה דיוור.
export async function subscribersCsv() {
  const db = await getDb();
  const rows = (
    await db.prepare("SELECT email, consent_at, source, consent_text FROM survey_subscribers WHERE marketing_consent = 1 ORDER BY id").all()
  ).results;
  return toCsv(["email", "consent_at", "source", "consent_text"], rows.map((r) => [r.email, r.consent_at, r.source, r.consent_text]));
}

// תשובות אנונימיות בלבד, ללא מיילים.
export async function responsesCsv() {
  const db = await getDb();
  const rows = (await db.prepare("SELECT * FROM survey_responses ORDER BY id").all()).results;
  const list = (json) => (JSON.parse(json || "[]") || []).join("|");
  return toCsv(
    ["day", "stage", "ai_usage", "feelings", "priorities", "manual_first", "junior_risk", "open_text", "help_format"],
    rows.map((r) => [r.day, r.stage, r.ai_usage, list(r.feelings), list(r.priorities), r.manual_first, r.junior_risk, r.open_text, list(r.help_format)])
  );
}
