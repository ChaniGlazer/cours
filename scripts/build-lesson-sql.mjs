// scripts/build-lesson-sql.mjs
//
// בונה מחדש את lessons/lessonN_name_insert.sql מתוך lessons/lessonN_name.html (ה-HTML הוא המקור, ה-SQL נגזר ממנו).
// שומר את כל שאר העמודות (id, slug, כותרת, position, created_at) מה-SQL הקיים, ומחלק שיעור גדול לכמה פקודות:
// INSERT של החלק הראשון, ואחריו UPDATE ... html_content = html_content || '...' לכל חלק נוסף (D1 מגביל פקודה אחת לכ-100KB).
//
//   node scripts/build-lesson-sql.mjs lessons/lesson3_loops.html [עוד קבצים...]
//
// אחרי הבנייה מריצים את check-lessons.mjs כדי לוודא ש-SQL == HTML.

import { readFileSync, writeFileSync } from "node:fs";
import { join, dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const MAX_BYTES = 88000; // הרבה מתחת ל-100,000 של D1, כולל התקורה של הפקודה

function readLiteral(sql, i) {
  let s = "";
  i++;
  for (;;) {
    if (i >= sql.length) throw new Error("מחרוזת SQL לא נסגרה");
    if (sql[i] === "'") {
      if (sql[i + 1] === "'") { s += "'"; i += 2; continue; }
      return { value: s, end: i + 1 };
    }
    s += sql[i++];
  }
}

function parseValues(sql) {
  const start = sql.indexOf("VALUES (");
  if (start === -1) throw new Error("אין INSERT ... VALUES");
  let i = start + "VALUES (".length;
  const out = [];
  while (i < sql.length) {
    while (/\s/.test(sql[i])) i++;
    if (sql[i] === "'") {
      const lit = readLiteral(sql, i);
      out.push(lit.value);
      i = lit.end;
    } else {
      const m = /^-?\d+/.exec(sql.slice(i));
      if (!m) throw new Error("ערך לא מוכר ב-VALUES");
      out.push(Number(m[0]));
      i += m[0].length;
    }
    while (/\s/.test(sql[i])) i++;
    if (sql[i] === ",") { i++; continue; }
    if (sql[i] === ")") return out;
    throw new Error("תו לא צפוי ב-VALUES");
  }
  throw new Error("VALUES לא נסגר");
}

const q = (s) => "'" + String(s).replace(/'/g, "''") + "'";

function chunkHtml(html) {
  const lines = html.split("\n");
  const chunks = [];
  let cur = "";
  let bytes = 0;
  for (let k = 0; k < lines.length; k++) {
    const piece = lines[k] + (k < lines.length - 1 ? "\n" : "");
    const b = Buffer.byteLength(piece.replace(/'/g, "''"), "utf8");
    if (bytes + b > MAX_BYTES && cur) { chunks.push(cur); cur = ""; bytes = 0; }
    cur += piece;
    bytes += b;
  }
  if (cur) chunks.push(cur);
  return chunks;
}

for (const arg of process.argv.slice(2)) {
  const htmlPath = resolve(root, arg);
  const sqlPath = htmlPath.replace(/\.html$/, "_insert.sql");
  const html = readFileSync(htmlPath, "utf8");
  if (html.includes("\r")) throw new Error(htmlPath + ": הקובץ מכיל CRLF");
  const [id, courseId, slug, title, description, videoUrl, , position, createdAt] = parseValues(readFileSync(sqlPath, "utf8"));
  const chunks = chunkHtml(html);
  let sql = `DELETE FROM lessons WHERE course_id=${q(courseId)} AND slug=${q(slug)};\n`;
  sql += `INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES (${q(id)}, ${q(courseId)}, ${q(slug)}, ${q(title)}, ${q(description)}, ${q(videoUrl)}, ${q(chunks[0])}, ${position}, ${q(createdAt)});\n`;
  for (let k = 1; k < chunks.length; k++) sql += `UPDATE lessons SET html_content = html_content || ${q(chunks[k])} WHERE id=${q(id)};\n`;
  writeFileSync(sqlPath, sql);
  console.log(`${arg}: ${chunks.length} פקודות, ${Buffer.byteLength(sql, "utf8")} בתים`);
}
