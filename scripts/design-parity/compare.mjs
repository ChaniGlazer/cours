// scripts/design-parity/compare.mjs
// משווה שני קבצי content.json (לפני/אחרי עיצוב מחדש). כל הבדל בטקסט, id, data-*, href
// או בתוצאות האינטראקציות הוא כשל. שימוש: node compare.mjs <beforeDir> <afterDir> [--only name-prefix]
import fs from "node:fs";
import path from "node:path";

const [beforeDir, afterDir] = process.argv.slice(2);
const only = process.argv.includes("--only") ? process.argv[process.argv.indexOf("--only") + 1] : "";
const load = (d) => JSON.parse(fs.readFileSync(path.join(d, "content.json"), "utf8"));
const a = load(beforeDir), b = load(afterDir);

// סימוני ערכת הנושא שהעיצוב עצמו מוסיף (לא תוכן): data-theme על <html> של השיעור, ו-data-precedence ש-React מוסיף ל-<link> של הערכה.
// data-fade-top/bottom: סימוני מצב הדהייה בגלילת הניווט הצדדי (עיצוב בלבד).
const THEME_MARKERS = new Set(["html:data-theme=python-soft", "link:data-precedence=default", "div:data-fade-top=0", "div:data-fade-top=1", "div:data-fade-bottom=0", "div:data-fade-bottom=1"]);
const diffList = (x0, y0) => {
  const x = x0.filter((v) => !THEME_MARKERS.has(v)), y = y0.filter((v) => !THEME_MARKERS.has(v));
  const sx = new Map(), sy = new Map();
  x.forEach((v) => sx.set(v, (sx.get(v) || 0) + 1)); y.forEach((v) => sy.set(v, (sy.get(v) || 0) + 1));
  const out = [];
  for (const [v, n] of sx) if ((sy.get(v) || 0) < n) out.push("- " + v);
  for (const [v, n] of sy) if ((sx.get(v) || 0) < n) out.push("+ " + v);
  return out;
};
const firstDiff = (s, t) => { let i = 0; while (i < s.length && i < t.length && s[i] === t[i]) i++; return `at ${i}: «${s.slice(Math.max(0, i - 20), i + 40)}» vs «${t.slice(Math.max(0, i - 20), i + 40)}»`; };

let totalDiffs = 0;
const rows = [];
for (const name of Object.keys(a).filter((n) => !only || n.startsWith(only))) {
  const A = a[name], B = b[name];
  const issues = [];
  if (!B) { issues.push("missing in after"); }
  else {
    for (const part of ["page", "frame"]) {
      if (!A[part] && !B[part]) continue;
      if (!A[part] || !B[part]) { issues.push(`${part}: present only on one side`); continue; }
      for (const key of ["textContent", "innerText"]) {
        if (A[part][key] !== B[part][key]) issues.push(`${part}.${key} differs ${firstDiff(A[part][key], B[part][key])}`);
      }
      for (const key of ["ids", "data", "hrefs"]) {
        const d = diffList(A[part][key], B[part][key]);
        if (d.length) issues.push(`${part}.${key}: ${d.slice(0, 8).join(" | ")}${d.length > 8 ? " ..." : ""}`);
      }
    }
    if (A.interactions || B.interactions) {
      const ia = A.interactions || [], ib = B.interactions || [];
      if (ia.length !== ib.length) issues.push(`interactions count ${ia.length} vs ${ib.length}`);
      for (let k = 0; k < Math.min(ia.length, ib.length); k++) {
        if (ia[k].hash !== ib[k].hash || ia[k].label !== ib[k].label) { issues.push(`interaction #${ia[k].i} («${ia[k].label}») result differs`); }
      }
    }
    if ((B.errors || []).length) issues.push("console errors: " + B.errors.join(" | "));
  }
  totalDiffs += issues.length;
  rows.push({ name, issues });
  console.log((issues.length ? "FAIL " : "ok   ") + name + (issues.length ? "\n   " + issues.join("\n   ") : ""));
}
console.log(totalDiffs ? `\n${totalDiffs} content differences` : "\n0 content differences");
process.exitCode = totalDiffs ? 1 : 0;
