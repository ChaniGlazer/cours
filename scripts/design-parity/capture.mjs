// scripts/design-parity/capture.mjs
//
// כלי לוודא שעיצוב מחדש לא שינה תוכן. לכל עמוד ברשימה:
//   1. מחלץ טקסט נראה (innerText), textContent מנורמל, כל ה-id, ה-data-* וה-href
//      (בעמוד עצמו ובתוך ה-iframe של השיעור).
//   2. מריץ אינטראקציות דטרמיניסטיות בשיעור (Math.random קבוע, מילוי שדות, לחיצה על כל כפתור)
//      ושומר טקסט של כל מצב.
//   3. מצלם מסך בדסקטופ ובטלפון.
// שימוש:
//   node scripts/design-parity/capture.mjs <outDir> [--base http://localhost:3000] [--only part-of-url]
//   node scripts/design-parity/compare.mjs <beforeDir> <afterDir>
// ספריית Playwright נטענת מ-PLAYWRIGHT_CORE (נתיב ל-index.mjs של playwright-core) או מ-node_modules.
import fs from "node:fs";
import path from "node:path";
import crypto from "node:crypto";
import { pathToFileURL } from "node:url";

const args = process.argv.slice(2);
const outDir = args[0];
const flag = (name, dflt) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : dflt; };
const BASE = flag("--base", "http://localhost:3000");
const ONLY = flag("--only", "");
const EDGE = process.env.EDGE_PATH || "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe";
const pwPath = process.env.PLAYWRIGHT_CORE;
const { chromium } = pwPath ? await import(pathToFileURL(pwPath).href) : await import("playwright-core");

const PYTHON_LESSONS = ["intro", "python-basics", "conditions", "for-while-loops", "short-for-loops", "lists", "dicts"];
export const PAGES = [
  ...PYTHON_LESSONS.map((s) => ({ name: `py-lesson-${s}`, url: `/courses/python-ai-era/${s}`, lesson: true, python: true })),
  { name: "py-lesson-functions", url: "/courses/python-ai-era/functions", lesson: true, python: true },
  { name: "py-course", url: "/courses/python-ai-era", python: true },
  { name: "other-ai-course", url: "/courses/ai-app-dev" },
  { name: "other-ai-lesson", url: "/courses/ai-app-dev/lesson-1-first-call", lesson: true },
  { name: "other-vibe-course", url: "/courses/vibe-coding" },
  { name: "other-catalog", url: "/courses" },
  { name: "other-home", url: "/" },
  { name: "other-login", url: "/login" }
];

const VIEWPORTS = [["desktop", 1440, 900], ["mobile", 390, 844]];
const sha = (s) => crypto.createHash("sha1").update(s).digest("hex").slice(0, 12);

// פונקציה שרצה בתוך הדף/ה-frame ומחזירה את המאפיינים שחשובים להשוואה
function extractInPage() {
  const norm = (s) => String(s || "").replace(/\s+/g, " ").trim();
  const skip = new Set(["SCRIPT", "STYLE", "NOSCRIPT", "NEXT-ROUTE-ANNOUNCER", "TITLE"]);
  const textContent = (() => {
    const parts = [];
    const walk = (n) => {
      if (n.nodeType === 3) { const t = norm(n.nodeValue); if (t) parts.push(t); return; }
      if (n.nodeType !== 1 || skip.has(n.tagName)) return;
      n.childNodes.forEach(walk);
    };
    walk(document.body);
    return parts.join("\n");
  })();
  const ids = [...document.querySelectorAll("[id]")].map((e) => e.id).filter((i) => !i.startsWith("__next")).sort();
  const data = [];
  document.querySelectorAll("*").forEach((e) => { for (const a of e.attributes) if (a.name.startsWith("data-")) data.push((e.id || e.tagName.toLowerCase()) + ":" + a.name + "=" + a.value); });
  data.sort();
  const hrefs = [...document.querySelectorAll("a[href]")].map((a) => a.getAttribute("href")).sort();
  return { innerText: document.body.innerText, textContent, ids, data, hrefs };
}

// אינטראקציות: Math.random קבוע, מילוי כל השדות, ואז לחיצה על כל כפתור לפי הסדר
async function interact(frame) {
  const states = [];
  await frame.evaluate(() => {
    document.querySelectorAll('input[type=text], input[type=number], textarea').forEach((el) => {
      if (el.id === "cert-name") return;
      el.value = el.type === "number" ? "3" : "abc";
      el.dispatchEvent(new Event("input", { bubbles: true }));
    });
  });
  const count = await frame.evaluate(() => document.querySelectorAll("button").length);
  for (let i = 0; i < count; i++) {
    const info = await frame.evaluate((k) => {
      const b = document.querySelectorAll("button")[k];
      if (!b || b.id === "cert-download" || b.disabled) return null;
      const label = (b.innerText || b.textContent || "").trim().slice(0, 40);
      b.click();
      return label;
    }, i);
    if (info === null) continue;
    await frame.page().clock.runFor(4000); // שעון מזויף: טיימרים של האינטראקציה מסתיימים אותו דבר בכל הרצה
    const text = await frame.evaluate(() => document.body.innerText);
    states.push({ i, label: info, hash: sha(text), len: text.length });
  }
  return states;
}

fs.mkdirSync(path.join(outDir, "shots"), { recursive: true });
const browser = await chromium.launch({ executablePath: EDGE, headless: true });
const result = {};
for (const pg of PAGES.filter((p) => !ONLY || p.url.includes(ONLY) || p.name.includes(ONLY))) {
  result[pg.name] = { url: pg.url, errors: [] };
  for (const [label, width, height] of VIEWPORTS) {
    const ctx = await browser.newContext({ viewport: { width, height }, locale: "he-IL" });
    await ctx.addInitScript(() => {
      let seed = 123456789;
      Math.random = () => { seed = (seed * 1664525 + 1013904223) % 4294967296; return seed / 4294967296; };
    });
    const page = await ctx.newPage();
    page.on("console", (m) => { if (m.type() === "error" && !/favicon/.test(m.location().url || "")) result[pg.name].errors.push(`${label}: ${m.text()}`); });
    page.on("pageerror", (e) => result[pg.name].errors.push(`${label} pageerror: ${e.message}`));
    await page.goto(BASE + pg.url, { waitUntil: "domcontentloaded", timeout: 90000 });
    await page.waitForTimeout(2500);
    let frame = null;
    if (pg.lesson) {
      const handle = await page.$("iframe.lesson-html-frame");
      if (handle) { frame = await handle.contentFrame(); await frame.waitForLoadState("load"); await page.waitForTimeout(800); }
    }
    if (label === "desktop") {
      // התוכן נשלף פעם אחת (בדסקטופ), ובטלפון רק מצלמים
      const parent = await page.evaluate(extractInPage);
      if (frame) {
        // הטקסט של ה-iframe נשלף בנפרד כדי שהשוואה תבדיל בין מעטפת לשיעור
        result[pg.name].frame = await frame.evaluate(extractInPage);
        await page.clock.install();
        result[pg.name].interactions = await interact(frame);
      }
      // בעמוד האב מוציאים את תוכן ה-iframe (אין בו טקסט, רק את תגית ה-iframe)
      result[pg.name].page = parent;
    }
    const total = await page.evaluate(() => document.documentElement.scrollHeight);
    await page.screenshot({ path: path.join(outDir, "shots", `${pg.name}-${label}.png`), fullPage: false, clip: { x: 0, y: 0, width, height: Math.min(total, 6000) }, timeout: 60000 }).catch(async () => {
      await page.screenshot({ path: path.join(outDir, "shots", `${pg.name}-${label}.png`) });
    });
    await ctx.close();
  }
  console.log("captured", pg.name, result[pg.name].errors.length ? "ERRORS: " + result[pg.name].errors.join(" | ") : "");
}
await browser.close();
fs.writeFileSync(path.join(outDir, "content.json"), JSON.stringify(result, null, 1), "utf8");
console.log("wrote", path.join(outDir, "content.json"));
