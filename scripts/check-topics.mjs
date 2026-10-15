// scripts/check-topics.mjs
//
// בודק את lib/topics.js: כל דוגמת קוד רצה עם python3 והפלט שווה למה שכתוב בעמוד, מבנה (פסקאות, מילים, שאלות), אורך description,
// ייחודיות של slug ו-title ו-description, וקישורים (נושאים קשורים ושיעור מקושר קיימים).
//
//   node scripts/check-topics.mjs [--words]     (קוד יציאה 1 אם משהו נכשל)

import { spawnSync } from "node:child_process";
import { mkdtempSync, writeFileSync, readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join, dirname } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const { TOPICS, COURSE_ID } = await import(pathToFileURL(join(root, "lib", "topics.js")).href);
const outlines = JSON.parse(readFileSync(join(root, "lib", "lessonOutlines.json"), "utf8"));
const lessonSlugs = new Set(Object.keys(outlines).filter((k) => k.startsWith(COURSE_ID + "/")).map((k) => k.split("/")[1]));

const dir = mkdtempSync(join(tmpdir(), "topics-"));
const problems = [];
const bad = (slug, msg) => problems.push(`${slug}: ${msg}`);
const slugs = new Set(TOPICS.map((t) => t.slug));
const seen = { slug: new Set(), title: new Set(), description: new Set(), h1: new Set() };
const rows = [];

let n = 0;
for (const t of TOPICS) {
  for (const f of ["slug", "title", "description", "h1"]) {
    if (seen[f].has(t[f])) bad(t.slug, `${f} כפול`);
    seen[f].add(t[f]);
  }
  if (!/^[a-z0-9-]+$/.test(t.slug)) bad(t.slug, "slug לא באנגלית");
  if (t.description.length > 155) bad(t.slug, `description באורך ${t.description.length}`);
  const shortWords = String(t.short || "").split(/\s+/).filter(Boolean).length;
  if (!t.short) bad(t.slug, "חסר short");
  else if (shortWords > 40) bad(t.slug, `short ארוך מדי: ${shortWords} מילים (עד 40)`);
  if (!lessonSlugs.has(t.lessonSlug)) bad(t.slug, `שיעור לא קיים: ${t.lessonSlug}`);
  for (const r of t.related) if (!slugs.has(r) || r === t.slug) bad(t.slug, `נושא קשור לא תקין: ${r}`);
  if (t.related.length < 2) bad(t.slug, "פחות משני נושאים קשורים");
  if (t.faq.length < 2 || t.faq.length > 3) bad(t.slug, `מספר שאלות: ${t.faq.length}`);

  const paragraphs = t.sections.flatMap((s) => s.paragraphs);
  const words = paragraphs.join(" ").split(/\s+/).filter(Boolean).length;
  const examples = t.sections.flatMap((s) => s.examples || []);
  rows.push({ slug: t.slug, paragraphs: paragraphs.length, words, examples: examples.length, shortWords });
  if (paragraphs.length < 3 || paragraphs.length > 4) bad(t.slug, `מספר פסקאות: ${paragraphs.length}`);
  if (words < 250 || words > 400) bad(t.slug, `מספר מילים: ${words}`);
  if (examples.length < 1 || examples.length > 2) bad(t.slug, `מספר דוגמאות: ${examples.length}`);

  for (const ex of examples) {
    const file = join(dir, `ex${n++}.py`);
    writeFileSync(file, ex.code + "\n", "utf8");
    const r = spawnSync("python3", ["-X", "utf8", file], { input: ex.stdin || "", encoding: "utf8", timeout: 10000 });
    const got = (r.stdout || "").replace(/\r\n/g, "\n").trimEnd();
    const want = (ex.piped ?? ex.output).trimEnd();
    if (r.status !== 0) bad(t.slug, `הדוגמה נכשלה: ${(r.stderr || "").trim().split("\n").pop()}\n${ex.code}`);
    else if (got !== want) bad(t.slug, `פלט שונה.\n--- בטקסט:\n${want}\n--- בפועל:\n${got}\n--- קוד:\n${ex.code}`);
  }
}

if (process.argv.includes("--words")) console.table(rows);
console.log(problems.length ? problems.join("\n\n") + `\n\n${problems.length} בעיות` : `כל ${TOPICS.length} הנושאים תקינים (${n} דוגמאות קוד רצו והפלט תואם)`);
process.exit(problems.length ? 1 : 0);
