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
          const n = nav.querySelector(".ring-num"); const rg = nav.querySelector(".progress-ring"); const sp = nav.querySelector(".progress-text span");
          if (!n) return null;
          const [d, tot] = n.textContent.split("/").map(Number);
          const fill = nav.querySelector(".ring-fill"); const C = 2 * Math.PI * 24;
          const off = parseFloat(getComputedStyle(fill).strokeDashoffset);
          const sm = sp.textContent.match(/\d+/); const spN = /אחד/.test(sp.textContent) ? 1 : /עוד לא/.test(sp.textContent) ? 0 : Number(sm && sm[0]);
          return { ring: n.textContent, text: sp.textContent.trim(), consistent: spN === d, fillMatches: Math.abs((1 - off / C) - d / tot) < 0.01, label: rg.getAttribute("aria-label"), dir: getComputedStyle(n).direction };
        })(),
        lineAlign: (() => {
          const tr = nav.querySelector(".lesson-side__track"), fl = nav.querySelector(".lesson-side__track-fill");
          const dots = [...nav.querySelectorAll(".side-item > i")]; if (!tr || dots.length < 2) return null;
          const cx = (r) => r.left + r.width / 2, cy = (r) => r.top + r.height / 2;
          const t = tr.getBoundingClientRect(), f = fl.getBoundingClientRect();
          const d0 = dots[0].getBoundingClientRect(), dN = dots[dots.length - 1].getBoundingClientRect();
          const cur = nav.querySelector(".is-current > i").getBoundingClientRect();
          return { xOff: Math.round(Math.abs(cx(t) - cx(d0)) * 100) / 100, trackTopOff: Math.round(Math.abs(t.top - cy(d0)) * 10) / 10, trackBottomOff: Math.round(Math.abs(t.bottom - cy(dN)) * 10) / 10, fillBottomOff: Math.round(Math.abs(f.bottom - cy(cur)) * 10) / 10, fillH: Math.round(f.height), trackW: t.width };
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
for (const r of report) console.log(`${label} H=${r.H} ${r.state.padEnd(6)} nav ${r.navTop}-${r.navBottom} (viewport ${r.viewport}) overflow:${r.overflowsViewport} scrolls:${r.listScrolls} (${r.listScrollHeight}/${r.listClientHeight}) scrollbar:${r.scrollbarWidth}px currentVisible:${r.currentVisible} errors:${r.errors.length} btn:${r.bottomButtonVisible} ring:${r.ring ? r.ring.ring + "|" + r.ring.consistent + "|" + r.ring.fillMatches : "-"} line:${JSON.stringify(r.lineAlign)}`);
