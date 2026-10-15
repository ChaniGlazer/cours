// scripts/build-lesson-outlines.mjs
//
// מחלץ מכל שיעור פייתון (lessons/lessonN_name.html) את מה שמנועי חיפוש צריכים לראות כטקסט בעמוד:
// כותרות החלקים (h2.section-title), פסקת הפתיחה של כל חלק (p.lede), כותרות משנה עם פסקה (h3) ודוגמת קוד אחת לחלק (טקסט בלבד).
// הפלט נכנס ל-lib/lessonOutlines.json, ומוצג בעמוד השיעור (app/components/LessonSeoSection.js) כ"מה לומדים בשיעור".
// גוף השיעור עצמו יושב ב-iframe srcDoc שגוגל לא קורא, ולכן בלי הקובץ הזה אין בעמוד טקסט על הנושאים.
//
//   node scripts/build-lesson-outlines.mjs          # כותב את lib/lessonOutlines.json
//   node scripts/build-lesson-outlines.mjs --check  # לא כותב; קוד יציאה 1 אם הקובץ לא עדכני (משמש את check-lessons.mjs)
//
// בלי תלויות: חילוץ בביטויים רגולריים מספיק למבנה השיעורים (כולם נכתבו באותה תבנית).

import { readFileSync, writeFileSync, readdirSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const lessonsDir = join(root, "lessons");
export const OUTLINES_PATH = join(root, "lib", "lessonOutlines.json");

// חלקים שאינם "מה לומדים": תרגילים, משחקי בדיקה, הורדת תוצאות.
const SKIP_HEADING = /תרגיל|המשימות|שלחו לי|בדיקת הבנה|בלש|^ארבעה דברים לזכור$|^לסיכום|^חוקי או שגיאה|^דף עזר|^סדרו את הקוד|^מה ידפיס|^כך נראית תשובה|^מה שונה כאן לעומת Java|^ארבעה הבדלים|^תרגמי|^הרכיבו|^for או while|^איך נראית פונקציה/;
// משפט שהוא הוראת הפעלה של רכיב אינטראקטיבי ("לחצו על...", "שחקו עם המחוון") ולא תוכן: לא נכנס לטקסט.
const INTERACTION = /(^|\s)(לחצו|לחצי|שחקו|שחקי|נסו|נסי|בחרו|בחרי|הקלידו|הקלידי|הריצו|הריצי|גררו|גררי|סדרו|סדרי|עקבו|עקבי|הזיזו|הזיזי|סמנו|סמני|ראו|תראו|הסתכלו|תסתכלו|הורידו|עברו|שנו|שימי|שימו|כתבו|כתבי|קראו|קראי|נחשו|נחשי|קבלי|חזי|חזו)(\s|$|:|,|\.)/;

const ENTITIES = { "&nbsp;": " ", "&lt;": "<", "&gt;": ">", "&amp;": "&", "&quot;": '"', "&#39;": "'", "&apos;": "'" };
function decode(s) {
  return s
    .replace(/&(nbsp|lt|gt|amp|quot|apos|#39);/g, (m) => ENTITIES[m])
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n)));
}
const textOf = (html) => decode(html.replace(/<br\s*\/?>/gi, " ").replace(/<[^>]+>/g, "")).replace(/\s+/g, " ").trim();

function proseOf(html) {
  const sentences = textOf(html).split(/(?<=[.!?:])\s+/);
  const kept = sentences.filter((s) => !INTERACTION.test(s));
  while (kept.length && /:$/.test(kept[kept.length - 1])) kept.pop(); // משפט פתיחה שנחתך באמצע ("בכל מקרה:")
  return kept.join(" ").trim();
}

// טקסט של בלוק קוד: שומר שורות והזחה, בלי תגיות.
function codeOf(html) {
  const raw = decode(html.replace(/<br\s*\/?>/gi, "\n").replace(/<\/(div|p|li)>/gi, "\n").replace(/<[^>]+>/g, ""));
  return raw.split("\n").map((l) => l.replace(/\s+$/, "")).join("\n").replace(/^\n+|\n+$/g, "");
}

function firstCode(sectionHtml) {
  const blocks = [];
  for (const m of sectionHtml.matchAll(/<pre\b[^>]*>([\s\S]*?)<\/pre>/g)) blocks.push(codeOf(m[1]));
  // תיבות קוד סטטיות שבנויות משורות (<div class="line">)
  for (const m of sectionHtml.matchAll(/<div class="codeblock[^"]*"[^>]*>([\s\S]*?)<\/div>\s*(?=<(?:div|\/div|p|h|section))/g)) {
    if (/class="line"/.test(m[1])) blocks.push(codeOf(m[1]));
  }
  for (const code of blocks) {
    const lines = code.split("\n");
    if (code.length < 8 || code.length > 600 || lines.length > 12) continue;
    if (!/[=()\[\]{}:]/.test(code)) continue; // לא קוד (למשל כיתוב)
    if (/^\s*#/.test(code) && lines.length === 1) continue;
    return code;
  }
  return null;
}

export function extractOutline(rawHtml) {
  const html = rawHtml.replace(/\r\n/g, "\n");
  const mainStart = html.indexOf("<main");
  const mainEnd = html.indexOf("</main>");
  const main = mainStart >= 0 ? html.slice(mainStart, mainEnd > mainStart ? mainEnd : undefined) : html;
  const sections = [];
  const seenCode = new Set();
  // כל h2 פותח חלק (יש <section> שמכיל כמה h2), והחלק נמשך עד ה-h2 הבא.
  const chunks = [];
  for (const sm of main.matchAll(/<section\b[^>]*>([\s\S]*?)<\/section>/g)) {
    for (const part of sm[1].split(/(?=<h2\b)/)) if (/^<h2\b/.test(part)) chunks.push(part);
  }
  for (const body of chunks) {
    const h2 = /<h2\b[^>]*>([\s\S]*?)<\/h2>/.exec(body);
    if (!h2) continue;
    const heading = textOf(h2[1]);
    if (!heading || SKIP_HEADING.test(heading)) continue;
    const lede = /<p class="lede"[^>]*>([\s\S]*?)<\/p>/.exec(body);
    const text = lede ? proseOf(lede[1]) : "";
    const items = [];
    for (const hm of body.matchAll(/<h3\b[^>]*>([\s\S]*?)<\/h3>\s*(?:<[^p][^>]*>\s*)?<p\b[^>]*>([\s\S]*?)<\/p>/g)) {
      const h = textOf(hm[1]);
      const p = proseOf(hm[2]);
      if (h && p && !SKIP_HEADING.test(h) && !/^\d+\s*·/.test(h)) items.push({ heading: h, text: p });
    }
    const points = [];
    const recap = /<ul class="recap">([\s\S]*?)<\/ul>/.exec(body);
    if (recap) for (const li of recap[1].matchAll(/<li\b[^>]*>([\s\S]*?)<\/li>/g)) points.push(textOf(li[1]));
    let code = firstCode(body);
    if (code && seenCode.has(code)) code = null;
    if (code) seenCode.add(code);
    if (text.length < 40 && items.length === 0 && points.length === 0) continue; // חלק בלי טקסט (משחק בלבד) לא נכנס
    const section = { heading, text };
    if (items.length) section.items = items;
    if (points.length) section.points = points;
    if (code) section.code = [code];
    sections.push(section);
  }
  return { sections };
}

// "course/slug" לכל קובץ שיעור, לפי שורת ה-DELETE שבקובץ ה-SQL הצמוד אליו.
function lessonKeys() {
  const out = [];
  for (const sqlName of readdirSync(lessonsDir).filter((f) => /^lesson\d+_.*_insert\.sql$/.test(f)).sort()) {
    const sql = readFileSync(join(lessonsDir, sqlName), "utf8");
    const m = /DELETE FROM lessons WHERE course_id='([^']+)' AND slug='([^']+)'/.exec(sql);
    if (!m) throw new Error(`${sqlName}: חסרה שורת DELETE עם course_id ו-slug`);
    out.push({ key: `${m[1]}/${m[2]}`, htmlFile: sqlName.replace(/_insert\.sql$/, ".html") });
  }
  return out;
}

export function buildAllOutlines() {
  const all = {};
  for (const { key, htmlFile } of lessonKeys()) all[key] = extractOutline(readFileSync(join(lessonsDir, htmlFile), "utf8"));
  return all;
}

export function serializeOutlines(all) {
  return JSON.stringify(all, null, 2) + "\n";
}

// האם lib/lessonOutlines.json תואם למה שהסקריפט מפיק עכשיו מקבצי ה-HTML.
export function outlinesAreCurrent() {
  let current = "";
  try {
    current = readFileSync(OUTLINES_PATH, "utf8").replace(/\r\n/g, "\n");
  } catch {
    return false;
  }
  return current === serializeOutlines(buildAllOutlines());
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  if (process.argv.includes("--check")) {
    const ok = outlinesAreCurrent();
    console.log(ok ? "lib/lessonOutlines.json עדכני" : "lib/lessonOutlines.json לא עדכני: להריץ node scripts/build-lesson-outlines.mjs");
    process.exit(ok ? 0 : 1);
  }
  const all = buildAllOutlines();
  writeFileSync(OUTLINES_PATH, serializeOutlines(all));
  for (const [key, o] of Object.entries(all)) {
    console.log(`${key}: ${o.sections.length} חלקים, ${o.sections.filter((s) => s.code).length} דוגמאות קוד`);
  }
}
