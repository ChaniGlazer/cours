// scripts/check-lessons.mjs
//
// בדיקה לקריאה בלבד: האם ה-HTML שבתוך כל lessons/lesson*_insert.sql זהה לקובץ ה-HTML התואם (lessonN_name.html),
// ואם מוסיפים --remote, גם ל-html_content ששמור ב-D1 (שאילתת SELECT בלבד, לא כותבים כלום).
//
//   node scripts/check-lessons.mjs             # קבצים מול קבצים
//   node scripts/check-lessons.mjs --remote    # וגם מול D1 בפרודקשן
//
// קוד יציאה 1 אם יש אי-התאמה. שיעורי ה-AI (ai_*) לא נבדקים כאן.

import { readFileSync, readdirSync, existsSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const dir = join(root, "lessons");
const remote = process.argv.includes("--remote");

// קורא את רשימת ערכי ה-VALUES (...) הראשונה: מחרוזות SQL (עם '' כבריחה) ומספרים.
function parseValues(sql) {
  const start = sql.indexOf("VALUES (");
  if (start === -1) throw new Error("אין INSERT ... VALUES");
  let i = start + "VALUES (".length;
  const out = [];
  while (i < sql.length) {
    while (/\s/.test(sql[i])) i++;
    if (sql[i] === "'") {
      let s = "";
      i++;
      for (;;) {
        if (i >= sql.length) throw new Error("מחרוזת SQL לא נסגרה");
        if (sql[i] === "'") {
          if (sql[i + 1] === "'") { s += "'"; i += 2; continue; }
          i++;
          break;
        }
        s += sql[i++];
      }
      out.push(s);
    } else {
      const m = /^-?\d+/.exec(sql.slice(i));
      if (!m) throw new Error("ערך לא מוכר ב-VALUES במיקום " + i);
      out.push(Number(m[0]));
      i += m[0].length;
    }
    while (/\s/.test(sql[i])) i++;
    if (sql[i] === ",") { i++; continue; }
    if (sql[i] === ")") break;
    throw new Error("תו לא צפוי ב-VALUES במיקום " + i);
  }
  return out;
}

function firstDiff(a, b) {
  let k = 0;
  while (k < a.length && k < b.length && a[k] === b[k]) k++;
  return `באורך ${a.length} מול ${b.length}, שונה מהתו ${k}: ${JSON.stringify(a.slice(k, k + 40))} מול ${JSON.stringify(b.slice(k, k + 40))}`;
}

function fetchRemote(courseId, slug) {
  const q = `SELECT html_content FROM lessons WHERE course_id='${courseId}' AND slug='${slug}'`;
  // מריצים את wrangler דרך node ישירות (בלי shell), כדי שהשאילתה תעבור כארגומנט אחד בכל מערכת הפעלה.
  const bin = join(root, "node_modules", "wrangler", "bin", "wrangler.js");
  const r = spawnSync(process.execPath, [bin, "d1", "execute", "course-db", "--remote", "--json", "--command", q], {
    cwd: root, encoding: "utf8", maxBuffer: 64 * 1024 * 1024
  });
  if (r.status !== 0) throw new Error("wrangler נכשל: " + (r.stderr || "").slice(0, 200));
  const json = JSON.parse(r.stdout.slice(r.stdout.indexOf("[")));
  return json[0]?.results?.[0]?.html_content ?? null;
}

let bad = 0;
const sqlFiles = readdirSync(dir).filter((f) => /^lesson\d+_.*_insert\.sql$/.test(f)).sort();
for (const sqlName of sqlFiles) {
  const htmlName = sqlName.replace(/_insert\.sql$/, ".html");
  const problems = [];
  const notes = [];
  let slug = "?";
  try {
    const sql = readFileSync(join(dir, sqlName), "utf8");
    const [, courseId, s, , , , sqlHtml] = parseValues(sql);
    slug = s;
    if (sql.includes("\r")) problems.push("הקובץ SQL מכיל CRLF");
    if (!existsSync(join(dir, htmlName))) problems.push(`חסר ${htmlName}`);
    else {
      const html = readFileSync(join(dir, htmlName), "utf8");
      if (html.includes("\r")) problems.push("קובץ ה-HTML מכיל CRLF");
      if (html !== sqlHtml) problems.push("SQL מול HTML: " + firstDiff(sqlHtml, html));
    }
    if (remote) {
      const live = fetchRemote(courseId, slug);
      if (live === null) problems.push("אין שיעור כזה ב-D1");
      else {
        // שיעורים ישנים נשמרו ב-D1 עם CRLF. הפרש של סוף שורה בלבד לא נחשב אי-התאמה, אבל מדווחים עליו.
        const liveLf = live.split("\r\n").join("\n");
        if (liveLf !== sqlHtml) problems.push("SQL מול D1: " + firstDiff(sqlHtml, liveLf));
        else if (live !== liveLf) notes.push("ב-D1 סופי השורות הם CRLF (בקבצים LF); התוכן זהה");
      }
    }
  } catch (e) {
    problems.push(e.message);
  }
  if (problems.length) bad++;
  console.log(`${problems.length ? "FAIL" : "OK  "} ${sqlName} (${slug})${problems.map((p) => "\n       - " + p).join("")}${notes.map((n) => "\n       · " + n).join("")}`);
}
console.log(bad ? `\n${bad} שיעורים לא תקינים` : `\nכל ${sqlFiles.length} השיעורים תואמים${remote ? " (כולל D1)" : ""}`);
process.exit(bad ? 1 : 0);
