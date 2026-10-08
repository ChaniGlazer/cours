// scripts/design-parity/navcheck.mjs
// בודק את הניווט הצדדי של עמוד השיעור בגבהי חלון שונים ובשלושה מצבים (שיעור ראשון/אמצעי/אחרון).
// שימוש: node navcheck.mjs <outDir> <label>   (label = before | after)
// מודד: האם הכרטיס חורג מהחלון, האם יש גלילה פנימית, רוחב פס גלילה, וכותרות השיעורים (להשוואת טקסט).
import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";
const pwPath = process.env.PLAYWRIGHT_CORE;
const { chromium } = pwPath ? await import(pathToFileURL(pwPath).href) : await import("playwright-core");
const EDGE = process.env.EDGE_PATH || "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe";
const [outDir, label = "run"] = process.argv.slice(2);
fs.mkdirSync(outDir, { recursive: true });
const base = process.env.BASE || "http://localhost:3000";
const STATES = [["first", "intro"], ["middle", "conditions"], ["last", "functions"]];
const HEIGHTS = [600, 800, 1000];

const browser = await chromium.launch({ executablePath: EDGE, headless: true });
const report = [];
for (const H of HEIGHTS) {
  for (const [state, slug] of STATES) {
    const ctx = await browser.newContext({ viewport: { width: 1440, height: H }, locale: "he-IL" });
    const page = await ctx.newPage();
    const errs = [];
    page.on("console", (m) => { if (m.type() === "error" && !/favicon/.test(m.location().url || "")) errs.push(m.text()); });
    page.on("pageerror", (e) => errs.push(e.message));
    await page.goto(`${base}/courses/python-ai-era/${slug}`, { waitUntil: "domcontentloaded", timeout: 90000 });
    await page.waitForTimeout(3500);
    await page.evaluate(() => window.scrollTo(0, 400));
    await page.waitForTimeout(500);
    const m = await page.evaluate(() => {
      const nav = document.getElementById("lesson-side");
      const list = nav.querySelector(".lesson-side__list") || nav;
      const r = nav.getBoundingClientRect();
      const header = document.querySelector(".site-header").getBoundingClientRect();
      return {
        navTop: Math.round(r.top), navBottom: Math.round(r.bottom), viewport: window.innerHeight, headerBottom: Math.round(header.bottom),
        overflowsViewport: r.bottom > window.innerHeight + 1,
        listScrolls: list.scrollHeight > list.clientHeight + 1,
        listScrollHeight: list.scrollHeight, listClientHeight: list.clientHeight,
        scrollbarWidth: list.offsetWidth - list.clientWidth,
        items: [...nav.querySelectorAll(".side-item")].map((e) => (e.querySelector(".side-item__t") || e).textContent.trim().replace(/\s+/g, " ")),
        ring: (() => {
          const n = nav.querySelector(".ring-num"); const t = nav.querySelector(".progress-text b"); const rg = nav.querySelector(".progress-ring");
          if (!n) return null;
          const [d, tot] = n.textContent.split("/").map(Number);
          const m = t.textContent.match(/(\d+)\D+(\d+)/);
          const fill = nav.querySelector(".ring-fill"); const C = 2 * Math.PI * 18;
          const off = parseFloat(getComputedStyle(fill).strokeDashoffset);
          return { ring: n.textContent, text: t.textContent.trim(), consistent: Number(m[1]) === d && Number(m[2]) === tot, fillMatches: Math.abs((1 - off / C) - d / tot) < 0.01, label: rg.getAttribute("aria-label"), dir: getComputedStyle(n).direction };
        })(),
        lineAlign: (() => {
          const els = [...nav.querySelectorAll(".side-item")]; if (els.length < 2) return null;
          const a = els[0], i = a.querySelector("i").getBoundingClientRect(); const ar = a.getBoundingClientRect();
          const cs = getComputedStyle(a, "::before"); const w = parseFloat(cs.width);
          const rtl = getComputedStyle(a).direction === "rtl";
          const startOffset = parseFloat(rtl ? cs.right : cs.left);
          const lineCenter = rtl ? ar.right - startOffset - w / 2 : ar.left + startOffset + w / 2;
          return Math.round(Math.abs(lineCenter - (i.left + i.width / 2)) * 100) / 100;
        })(),
        currentVisible: (() => { const c = nav.querySelector(".side-item.is-current"); if (!c) return null; const cr = c.getBoundingClientRect(), lr = list.getBoundingClientRect(); return cr.top >= lr.top - 1 && cr.bottom <= lr.bottom + 1; })(),
        bottomButtonVisible: (() => { const b = nav.querySelector(".lesson-side__next"); if (!b) return null; const r = b.getBoundingClientRect(); return r.bottom <= window.innerHeight && r.top >= 0; })()
      };
    });
    await page.screenshot({ path: path.join(outDir, `${label}-${H}-${state}.png`) });
    report.push({ H, state, slug, errors: errs, ...m });
    await ctx.close();
  }
}
await browser.close();
fs.writeFileSync(path.join(outDir, `${label}.json`), JSON.stringify(report, null, 1), "utf8");
for (const r of report) console.log(`${label} H=${r.H} ${r.state.padEnd(6)} nav ${r.navTop}-${r.navBottom} (viewport ${r.viewport}) overflow:${r.overflowsViewport} scrolls:${r.listScrolls} (${r.listScrollHeight}/${r.listClientHeight}) scrollbar:${r.scrollbarWidth}px currentVisible:${r.currentVisible} errors:${r.errors.length} btn:${r.bottomButtonVisible} ring:${r.ring ? r.ring.ring + "|" + r.ring.consistent + "|" + r.ring.fillMatches : "-"} lineOff:${r.lineAlign}px`);
