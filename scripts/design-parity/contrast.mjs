// scripts/design-parity/contrast.mjs
// בדיקת ניגודיות (AA) לטקסט בתוך שיעור. שימוש: node contrast.mjs <url-path> (למשל courses/python-ai-era/intro)
// מחשב לכל אלמנט עם טקסט ישיר את צבע הטקסט מול הרקע האפקטיבי (עולה בעץ עד רקע אטום), ומדווח מתחת ל-4.5:1
// (או 3:1 לטקסט גדול). לא מנסה לפענח גרדיאנטים/תמונות: אלמנטים עם background-clip:text מדולגים.
import { pathToFileURL } from "node:url";
const pwPath = process.env.PLAYWRIGHT_CORE;
const { chromium } = pwPath ? await import(pathToFileURL(pwPath).href) : await import("playwright-core");
const EDGE = process.env.EDGE_PATH || "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe";
const url = process.argv[2].replace(/^\/+/, "");
const base = process.env.BASE || "http://localhost:3000";

const audit = () => {
  const parse = (c) => { const m = c.match(/rgba?\(([^)]+)\)/); if (!m) return null; const p = m[1].split(/[ ,\/]+/).filter(Boolean).map(Number); return { r: p[0], g: p[1], b: p[2], a: p[3] === undefined ? 1 : p[3] }; };
  const lum = ({ r, g, b }) => { const f = (v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4); }; return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b); };
  const over = (top, bot) => ({ r: top.r * top.a + bot.r * (1 - top.a), g: top.g * top.a + bot.g * (1 - top.a), b: top.b * top.a + bot.b * (1 - top.a), a: 1 });
  const bgOf = (el) => {
    const stack = [];
    for (let e = el; e; e = e.parentElement) { const c = parse(getComputedStyle(e).backgroundColor); if (c && c.a > 0) { stack.push(c); if (c.a >= 0.99) break; } }
    let bg = { r: 245, g: 243, b: 255, a: 1 }; // רקע הדף המשוער (lilac)
    for (let i = stack.length - 1; i >= 0; i--) bg = over(stack[i], bg);
    return bg;
  };
  const out = [];
  const seen = new Set();
  document.querySelectorAll("body *").forEach((el) => {
    if (["SCRIPT", "STYLE"].includes(el.tagName)) return;
    const hasText = [...el.childNodes].some((n) => n.nodeType === 3 && n.nodeValue.trim());
    if (!hasText) return;
    const cs = getComputedStyle(el);
    if (cs.visibility === "hidden" || cs.display === "none" || parseFloat(cs.opacity) < 0.5) return;
    if (cs.webkitBackgroundClip === "text" || cs.backgroundClip === "text") return;
    // אלמנט על גרדיאנט (כפתור ראשי): הצבע האפקטיבי לא נגזר מ-background-color. נבדק ידנית מול קצות הגרדיאנט.
    for (let e = el; e; e = e.parentElement) { if (getComputedStyle(e).backgroundImage.includes("gradient")) return; }
    const fg0 = parse(cs.color); if (!fg0) return;
    const bg = bgOf(el), fg = over(fg0, bg);
    const L1 = lum(fg), L2 = lum(bg), ratio = (Math.max(L1, L2) + 0.05) / (Math.min(L1, L2) + 0.05);
    const size = parseFloat(cs.fontSize), bold = parseInt(cs.fontWeight, 10) >= 700;
    const large = size >= 24 || (size >= 18.66 && bold);
    const need = large ? 3 : 4.5;
    if (ratio < need) {
      const key = el.tagName + "." + el.className + "|" + cs.color + "|" + JSON.stringify(bg);
      if (seen.has(key)) return; seen.add(key);
      out.push({ ratio: +ratio.toFixed(2), need, text: el.textContent.trim().slice(0, 40), tag: el.tagName.toLowerCase() + (el.className && typeof el.className === "string" ? "." + el.className.split(" ").join(".") : ""), color: cs.color, bg: `rgb(${Math.round(bg.r)},${Math.round(bg.g)},${Math.round(bg.b)})` });
    }
  });
  return out;
};

const browser = await chromium.launch({ executablePath: EDGE, headless: true });
const ctx = await browser.newContext({ viewport: { width: 1440, height: 900 }, locale: "he-IL" });
const page = await ctx.newPage();
await page.goto(`${base}/${url}`, { waitUntil: "domcontentloaded", timeout: 90000 });
await page.waitForTimeout(3000);
const handle = await page.$("iframe.lesson-html-frame");
const target = handle ? await handle.contentFrame() : page;
const res = await target.evaluate(audit);
console.log(res.length ? `${res.length} low-contrast spots:` : "0 low-contrast spots");
res.forEach((r) => console.log(`  ${r.ratio} (need ${r.need}) ${r.tag} «${r.text}» fg ${r.color} on ${r.bg}`));
await browser.close();
