DELETE FROM lessons WHERE course_id='prompts' AND slug='lesson-4-catch-the-ai';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('bf34e7fdcb2506b3fe21177fa545973e', 'prompts', 'lesson-4-catch-the-ai', 'שיעור 4 - לתפוס את ה-AI לפני שהוא תופס אתכם', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 4 — לתפוס את ה-AI לפני שהוא תופס אתכם</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;700;800;900&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
:root {
  --bg: #F5F3FF;
  --bg-panel: #FFFFFF;
  --bg-panel-2: #F0EEFF;
  --ink: #25224F;
  --ink-dim: #5A577F;
  --ink-faint: #8B88AE;
  --cyan: #5B6CFF;
  --cyan-2: #8B6BFF;
  --cyan-soft: #E8EBFF;
  --violet: #FF7B6B;
  --violet-soft: #FFE8E3;
  --success: #1FB985;
  --success-soft: #DDF7EC;
  --danger: #E5486A;
  --danger-soft: #FFE4EA;
  --warn: #D98A00;
  --warn-soft: #FFF0D4;
  --line: rgba(91,108,255,.12);
  --line-strong: rgba(91,108,255,.26);
  --radius: 28px;
  --shadow: 0 1px 2px rgba(50,40,140,.05), 0 16px 48px -16px rgba(60,50,150,.24);
  --shadow-sm: 0 1px 2px rgba(50,40,140,.05), 0 8px 24px -10px rgba(60,50,150,.20);
  --code-bg: #221F55;
  --code-ink: #ECEBFF;
  --display: "Rubik", sans-serif;
  --sans: "Assistant", sans-serif;
  --mono: "JetBrains Mono", monospace;
}
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; scroll-behavior: auto !important; }
}
* { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body {
  margin: 0; background: var(--bg); color: var(--ink);
  font-family: var(--sans); font-size: 18px; line-height: 1.75; -webkit-font-smoothing: antialiased;
  overflow-x: hidden;
}
body::before {
  content: ""; position: fixed; inset: 0; z-index: -1; pointer-events: none;
  background:
    radial-gradient(900px 620px at 4% -4%, rgba(139,107,255,.20), transparent 62%),
    radial-gradient(820px 600px at 100% 8%, rgba(255,123,107,.17), transparent 62%),
    radial-gradient(900px 700px at 62% 108%, rgba(31,185,133,.13), transparent 60%);
}
::selection { background: var(--cyan); color: #fff; }

.wrap { width: 100%; max-width: 1560px; margin: 0 auto; padding: 0 clamp(20px, 5vw, 84px); }
p { color: var(--ink-dim); margin: 0; }
p strong, li strong { color: var(--ink); }
h1, h2, h3, h4 { font-family: var(--display); font-weight: 700; color: var(--ink); margin: 0; letter-spacing: -0.005em; }
code, .mono { font-family: var(--mono); }
p code, li code, summary code, label code {
  font-size: .86em; background: var(--cyan-soft); color: #3F4FE0; border-radius: 8px; padding: 2px 8px;
  direction: ltr; unicode-bidi: embed;
}
button { font-family: var(--sans); cursor: pointer; }
button:focus-visible, a:focus-visible, textarea:focus-visible, summary:focus-visible { outline: 3px solid rgba(91,108,255,.45); outline-offset: 3px; }

section { padding: clamp(60px, 7vw, 108px) 0; }
section:nth-of-type(even) { background: rgba(255,255,255,.55); }
.eyebrow { display: inline-block; font-family: var(--sans); font-weight: 700; font-size: 14px; letter-spacing: .02em; color: var(--ink-dim); background: rgba(255,255,255,.8); border-radius: 100px; padding: 4px 16px; margin-bottom: 14px; box-shadow: var(--shadow-sm); direction: rtl; }
.eyebrow.c { color: #3F4FE0; background: var(--cyan-soft); box-shadow: none; }
.eyebrow.v { color: #E0553F; background: var(--violet-soft); box-shadow: none; }
h2.section-title { font-size: clamp(1.9rem, 3.6vw, 2.9rem); line-height: 1.22; }
.lede { font-size: clamp(18px, 1.5vw, 20px); margin-top: 14px; max-width: 68ch; }

/* top bars */
.scroll-progress { position: fixed; top: 0; inset-inline: 0; height: 4px; z-index: 50; }
.scroll-progress i { display: block; height: 100%; width: 0; background: linear-gradient(90deg, var(--cyan), var(--cyan-2), var(--violet)); border-radius: 0 4px 4px 0; }
.topbar { background: rgba(255,255,255,.75); backdrop-filter: blur(14px); border-bottom: 1px solid var(--line); padding: 14px 0; position: sticky; top: 0; z-index: 40; }
.topbar-inner { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; font-size: 15px; }
.topbar .course { font-family: var(--display); font-weight: 600; color: var(--ink); }
.topbar .lesson-chip { font-weight: 700; font-size: 13.5px; color: #fff; background: linear-gradient(135deg, var(--cyan), var(--cyan-2)); border-radius: 100px; padding: 4px 16px; }

/* hero */
.hero { position: relative; padding: clamp(48px, 7vw, 100px) 0 clamp(40px, 5vw, 72px); }
.hero-grid { display: grid; grid-template-columns: minmax(0, 1.1fr) minmax(0, 1fr); gap: clamp(28px, 5vw, 90px); align-items: center; }
@media (max-width: 980px) { .hero-grid { grid-template-columns: minmax(0, 1fr); } }
.hero h1 { font-size: clamp(2.1rem, 4.4vw, 3.5rem); line-height: 1.2; font-weight: 800; }
.hero h1 .a1 { background: linear-gradient(90deg, var(--cyan), var(--cyan-2)); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero h1 .a2 { background: linear-gradient(90deg, var(--violet), #FFA06B); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero-sub { margin-top: 20px; font-size: clamp(18px, 1.6vw, 21px); max-width: 54ch; }
.time-row { margin-top: 26px; display: flex; gap: 10px; flex-wrap: wrap; }
.pill { font-size: 14.5px; font-weight: 600; color: var(--ink-dim); background: rgba(255,255,255,.85); border-radius: 100px; padding: 6px 16px; box-shadow: var(--shadow-sm); }

.chat-demo { background: #fff; border-radius: 30px; box-shadow: var(--shadow); overflow: hidden; border: 1px solid rgba(91,108,255,.08); }
.chat-demo-head { padding: 14px 22px; font-size: 14.5px; font-weight: 700; color: var(--ink-dim); display: flex; align-items: center; gap: 10px; background: linear-gradient(90deg, var(--cyan-soft), #fff); }
.chat-demo-head .dot { width: 10px; height: 10px; border-radius: 50%; background: var(--success); box-shadow: 0 0 0 4px rgba(31,185,133,.2); }
.chat-body { padding: 22px; min-height: 210px; display: flex; flex-direction: column; gap: 14px; }
.bubble { max-width: 90%; padding: 12px 18px; border-radius: 22px; font-size: 16px; line-height: 1.6; }
.bubble.user { align-self: flex-start; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); color: #fff; border-end-start-radius: 6px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; }
.bubble.ai { align-self: flex-end; background: var(--bg-panel-2); color: var(--ink); border-end-end-radius: 6px; }
.bubble.ai.typing::after { content: "▍"; color: var(--cyan); animation: blink .8s steps(1) infinite; }
@keyframes blink { 50% { opacity: 0; } }
.chat-empty { color: var(--ink-faint); font-size: 16px; text-align: center; margin: auto; }
.chips { padding: 0 22px 20px; display: flex; gap: 10px; flex-wrap: wrap; }
.chip { font-size: 14.5px; font-weight: 600; color: #3F4FE0; background: var(--cyan-soft); border: none; border-radius: 100px; padding: 9px 16px; transition: all .15s; }
.chip:hover:not(:disabled) { background: var(--cyan); color: #fff; transform: translateY(-1px); }
.chip:disabled { opacity: .45; cursor: default; }
.demo-note { padding: 0 22px 18px; font-size: 13px; color: var(--ink-faint); }
.demo-after { margin-top: 20px; font-size: 16px; color: var(--ink); opacity: 0; transform: translateY(6px); transition: opacity .4s, transform .4s; }
.demo-after.show { opacity: 1; transform: none; }

/* tiles */
.tiles4 { margin-top: 30px; display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 16px; }
@media (max-width: 900px) { .tiles4 { grid-template-columns: repeat(2, minmax(0, 1fr)); } }
@media (max-width: 540px) { .tiles4 { grid-template-columns: minmax(0, 1fr); } }
.tile { background: #fff; border-radius: 22px; padding: 22px 20px; box-shadow: var(--shadow-sm); text-align: center; }
.tile .em { font-size: 34px; line-height: 1.2; }
.tile h4 { font-size: 16px; margin: 10px 0 4px; }
.tile p { font-size: 14px; line-height: 1.6; }

/* shared */
.callout { margin-top: 20px; border-radius: 20px; padding: 16px 20px; font-size: 16px; display: flex; gap: 14px; align-items: flex-start; border: 1px solid; text-align: start; }
.callout .ico { font-size: 22px; line-height: 1.5; }
.callout p { color: var(--ink); }
.callout.warn { background: var(--warn-soft); border-color: rgba(217,138,0,.22); }
.callout.danger { background: var(--danger-soft); border-color: rgba(229,72,106,.22); }
.callout.info { background: var(--cyan-soft); border-color: rgba(91,108,255,.2); }
.callout.ok { background: var(--success-soft); border-color: rgba(31,185,133,.25); }

.btn { font-family: var(--display); font-weight: 600; font-size: 16px; color: #fff; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); border: none; border-radius: 100px; padding: 12px 28px; box-shadow: 0 12px 26px -12px rgba(91,108,255,.8); transition: transform .18s, box-shadow .18s, opacity .18s; }
.btn:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 16px 30px -12px rgba(91,108,255,.9); }
.btn:disabled { opacity: .5; cursor: not-allowed; box-shadow: none; }

/* citation */
.cite { margin-top: 14px; display: flex; align-items: flex-start; gap: 10px; font-size: 13.5px; color: var(--ink-faint); line-height: 1.6; }
.cite .ico { flex-shrink: 0; }
.cite a { color: inherit; text-decoration: underline; text-underline-offset: 2px; }
.cite a:hover { color: var(--ink); }

/* quote blocks */
.prompt-quote { background: rgba(255,255,255,.75); border-radius: 14px; padding: 14px 18px; font-style: italic; color: var(--ink); font-size: 16px; line-height: 1.65; white-space: pre-line; }
.prompt-quote.en { direction: ltr; text-align: left; font-style: normal; font-family: var(--mono); font-size: 14.5px; }
.dd { margin-top: 24px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
@media (max-width: 720px) { .dd { grid-template-columns: minmax(0, 1fr); } }
.dd-col { border-radius: 26px; padding: 24px 26px; box-shadow: var(--shadow-sm); }
.dd-col.yes { background: linear-gradient(160deg, #E6FAF1, #D3F4E5); }
.dd-col.no { background: linear-gradient(160deg, #FFEBEF, #FFDDE4); }
.dd-col h4 { font-size: 18px; margin-bottom: 12px; }
.dd-col.yes h4 { color: #0F8F63; } .dd-col.no h4 { color: #C9304F; }
.dd-note { margin-top: 12px; font-size: 14.5px; color: var(--ink); }

/* compact before/after rows */
.ba-row { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; margin-top: 12px; background: #fff; border-radius: 16px; padding: 14px 18px; box-shadow: var(--shadow-sm); }
.ba-row .bad { color: #9A2F47; background: var(--danger-soft); border-radius: 10px; padding: 6px 12px; font-size: 13.5px; font-family: var(--mono); direction: ltr; }
.ba-row .good { color: #0F8F63; background: var(--success-soft); border-radius: 10px; padding: 6px 12px; font-size: 13.5px; font-family: var(--mono); direction: ltr; flex: 1; min-width: 220px; }
.ba-row .arr { color: var(--ink-faint); font-size: 18px; }
@media (max-width: 680px) { .ba-row { flex-direction: column; align-items: stretch; } .ba-row .arr { transform: rotate(90deg); align-self: center; } }

/* generic card */
.subcard { background: #fff; border-radius: 22px; padding: 24px 26px; box-shadow: var(--shadow-sm); }
.subcard h4 { font-size: 17px; margin-bottom: 10px; }
.subcard p { font-size: 15.5px; }
.subcard .prompt-quote { margin-top: 12px; }
.subcard ul, .subcard ol { margin: 12px 0 0; padding-inline-start: 20px; color: var(--ink-dim); font-size: 15px; }
.subcard li { margin-bottom: 6px; }

/* debug ticket builder (principle 1) */
.tb { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 30px; }
.tb-bad { font-family: var(--mono); direction: ltr; text-align: left; font-size: 15px; color: #9A2F47; background: var(--danger-soft); border-radius: 12px; padding: 10px 16px; display: inline-block; }
.tb-chips { margin-top: 18px; display: flex; gap: 10px; flex-wrap: wrap; }
.tb-chip { font-size: 14.5px; font-weight: 700; color: #3F4FE0; background: var(--cyan-soft); border: none; border-radius: 100px; padding: 9px 18px; transition: all .15s; }
.tb-chip:hover:not(:disabled) { background: var(--cyan); color: #fff; transform: translateY(-1px); }
.tb-chip:disabled { opacity: .4; cursor: default; }
.tb-preview { margin-top: 18px; min-height: 90px; background: var(--code-bg); border-radius: 18px; padding: 18px 20px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 2; color: var(--code-ink); }
.tb-empty { color: #8C89C4; font-style: italic; font-family: var(--sans); direction: rtl; text-align: right; display: block; }
.tb-line { opacity: 0; transform: translateY(6px); animation: tbin .35s ease forwards; }
@keyframes tbin { to { opacity: 1; transform: none; } }
.tb-line .src { color: #8C89C4; font-size: 12px; margin-inline-start: 8px; }
.tb-done { margin-top: 16px; font-weight: 700; font-family: var(--display); color: var(--success); }

/* correct-order vs cheating simulator (principle 2) */
.sim { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 30px; }
.sim-chips { display: flex; gap: 10px; flex-wrap: wrap; }
.sim-chip { font-size: 14px; font-weight: 600; color: #3F4FE0; background: var(--cyan-soft); border: none; border-radius: 100px; padding: 10px 18px; transition: all .15s; }
.sim-chip:hover:not(:disabled) { background: var(--cyan); color: #fff; }
.sim-chip:disabled { opacity: .45; }
.sim-out { margin-top: 20px; min-height: 120px; }
.sim-card { border-radius: 18px; padding: 18px 20px; }
.sim-card.suggest { background: var(--warn-soft); }
.sim-card.execute { background: var(--success-soft); }
.sim-card h5 { font-family: var(--display); font-size: 15px; margin-bottom: 10px; }
.sim-card.suggest h5 { color: #A66200; } .sim-card.execute h5 { color: #0F8F63; }
.sim-card ul { margin: 0; padding-inline-start: 20px; font-size: 15px; color: var(--ink); }
.sim-card li { margin-bottom: 6px; }
.sim-empty { color: var(--ink-faint); font-size: 15px; }

/* hallucinated package checker (principle 3) */
.pkgsim { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 30px; }
.pkg-agent { margin-top: 18px; background: var(--code-bg); border-radius: 18px; padding: 16px 20px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; color: var(--code-ink); line-height: 1.8; }
.pkg-agent .cmd { color: #9FFFD1; }
.pkg-list { margin-top: 20px; display: flex; flex-direction: column; gap: 10px; }
.pkg-row { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; background: var(--bg-panel-2); border-radius: 16px; padding: 12px 18px; }
.pkg-row .pkg-name { font-family: var(--mono); direction: ltr; font-size: 15px; font-weight: 700; color: var(--ink); }
.pkg-row .pkg-check { font-size: 13.5px; font-weight: 700; color: #3F4FE0; background: var(--cyan-soft); border: none; border-radius: 100px; padding: 8px 16px; transition: all .15s; flex-shrink: 0; }
.pkg-row .pkg-check:hover:not(:disabled) { background: var(--cyan); color: #fff; }
.pkg-row .pkg-check:disabled { opacity: .4; }
.pkg-result { font-size: 14px; font-weight: 700; flex: 1; min-width: 200px; }
.pkg-result.real { color: #0F8F63; } .pkg-result.fake { color: #9A2F47; }
.pkg-summary { margin-top: 18px; font-size: 15px; font-weight: 700; min-height: 24px; color: var(--ink); }

/* rule sorting boards (shared markup, used in principle 4) */
.board { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 30px; }
.board-row { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; padding: 14px 0; border-top: 1px dashed var(--line-strong); }
.board-row:first-of-type { border-top: none; padding-top: 0; }
.board-rule { flex: 1; min-width: 240px; font-size: 15.5px; color: var(--ink); }
.board-rule code { direction: ltr; unicode-bidi: embed; }
.board-btns { display: flex; gap: 8px; }
.board-btn { font-size: 13.5px; font-weight: 700; border-radius: 100px; padding: 8px 14px; border: 1.5px solid var(--line); background: #fff; color: var(--ink-dim); transition: all .15s; }
.board-btn:hover:not(:disabled) { border-color: var(--cyan); }
.board-btn:disabled { cursor: default; }
.board-btn.right { border-color: var(--success); background: var(--success-soft); color: #0F8F63; }
.board-btn.wrong { border-color: var(--danger); background: var(--danger-soft); color: #9A2F47; }
.board-score { margin-top: 16px; font-family: var(--display); font-weight: 700; font-size: 15px; color: #3F4FE0; }

/* quiz (capstone) */
.choices { display: grid; gap: 10px; }
.choice { text-align: start; background: #fff; border: 1.5px solid var(--line); color: var(--ink); border-radius: 16px; padding: 12px 18px; font-size: 15.5px; line-height: 1.6; transition: all .15s; box-shadow: var(--shadow-sm); white-space: pre-line; }
.choice:hover:not(:disabled) { border-color: var(--cyan); transform: translateY(-1px); }
.choice.right { border-color: var(--success); background: var(--success-soft); }
.choice.wrong { border-color: var(--danger); background: var(--danger-soft); }
.choice:disabled { cursor: default; }
.choice.en { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; }
.fb { margin-top: 12px; font-size: 15px; font-weight: 700; min-height: 22px; }
.fb.correct { color: var(--success); } .fb.wrong { color: var(--danger); }

/* recap swap rows */
.recap { margin-top: 30px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 30px 32px; }
.swap-row { display: grid; grid-template-columns: 1fr auto 1fr; align-items: center; gap: 16px; padding: 16px 0; border-top: 1px dashed var(--line-strong); }
.swap-row:first-child { border-top: none; padding-top: 0; }
@media (max-width: 760px) { .swap-row { grid-template-columns: minmax(0,1fr); gap: 8px; } .swap-row .sw-arrow { display: none; } }
.sw-old, .sw-new { border-radius: 16px; padding: 14px 18px; font-size: 15px; line-height: 1.55; }
.sw-old { background: var(--danger-soft); color: #9A2F47; }
.sw-new { background: var(--success-soft); color: #0F6B4A; }
.sw-old b, .sw-new b { display: block; font-family: var(--display); font-size: 13px; margin-bottom: 4px; }
.sw-old b { color: #C9304F; } .sw-new b { color: #0F8F63; }
.sw-arrow { font-size: 22px; color: var(--ink-faint); }
@media (max-width: 760px) { .sw-arrow { transform: rotate(90deg); } }
.mission-done { margin-top: 20px; font-weight: 700; font-family: var(--display); color: var(--ink); min-height: 26px; }

/* exercise */
.exsummary { margin-top: 30px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 20px 28px; display: flex; align-items: center; gap: 18px; flex-wrap: wrap; }
.exsummary b { font-family: var(--display); font-size: 17px; white-space: nowrap; }
.exsummary .bar { flex: 1; min-width: 160px; height: 10px; border-radius: 10px; background: var(--bg-panel-2); overflow: hidden; }
.exsummary .bar i { display: block; height: 100%; width: 0; background: linear-gradient(90deg, #34D6A0, #1FB985); border-radius: 10px; transition: width .4s ease; }
.excard { margin-top: 22px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 30px; border: 2px solid transparent; transition: border-color .25s; }
.excard.passed { border-color: rgba(31,185,133,.55); }
.exhead { display: flex; align-items: center; gap: 16px; margin-bottom: 18px; flex-wrap: wrap; }
.exnum { width: 42px; height: 42px; border-radius: 14px; background: var(--bg-panel-2); color: var(--cyan); font-family: var(--display); font-weight: 700; font-size: 17px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.exhead .prompt-quote.bad { flex: 1; min-width: 220px; border: 1px dashed rgba(229,72,106,.35); background: var(--danger-soft); color: #9A2F47; }
.exintro { margin-bottom: 18px; font-size: 15px; color: var(--ink-dim); }
.exdiag { margin-bottom: 24px; }
.exdiag:last-of-type { margin-bottom: 0; }
.exdiag p { color: var(--ink); font-weight: 700; font-size: 16px; margin-bottom: 10px; }
.exrow { display: flex; align-items: center; gap: 18px; margin-top: 22px; flex-wrap: wrap; }
.exbadge { font-family: var(--display); font-weight: 700; font-size: 15px; color: var(--ink-dim); }
.excard.passed .exbadge { color: var(--success); }

footer { padding: 56px 0 84px; text-align: center; color: var(--ink-faint); font-size: 14.5px; }
[hidden] { display: none !important; }
</style>
</head>
<body>

<div class="scroll-progress" aria-hidden="true"><i id="scroll-bar"></i></div>

<div class="topbar">
  <div class="wrap topbar-inner">
    <span class="course">הנדסת פרומפטים למפתחים</span>
    <span class="lesson-chip">שיעור 4</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap hero-grid">
   <div class="hero-text">
    <div class="eyebrow c">שיעור 4 · דיבוג, TDD והזיות קוד</div>
    <h1>תפסו את ה-AI <span class="a1">לפני</span> שהוא <span class="a2">תופס אתכם</span></h1>
    <p class="hero-sub">תיקון עיוור, טסט שמתאים לבאג, חבילת npm שלא קיימת, בדיקה עצמית שמאשרת לעצמה — כל אלה קורים בשקט. היום: ארבעה הרגלים שתופסים את זה לפני ה-production.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-35 דקות</span>
      <span class="pill">🤖 Claude Code · Cursor ועוד</span>
      <span class="pill">📚 שיעור 4 מתוך 5</span>
    </div>
   </div>
   <div class="hero-visual">
    <div class="chat-demo">
      <div class="chat-demo-head"><span class="dot"></span> אותו באג, שתי בקשות דיבוג</div>
      <div class="chat-body" id="chat-body"><div class="chat-empty">לחצו על אחת הבקשות למטה, ותראו איך הסוכן מגיב</div></div>
      <div class="chips" id="chips">
        <button class="chip" type="button" data-i="0">❌ just fix it</button>
        <button class="chip" type="button" data-i="1">✅ דיבוג שיטתי</button>
      </div>
      <div class="demo-note">* הדגמה מוקלטת להמחשה בלבד.</div>
    </div>
    <p class="demo-after" id="demo-after">שתי התשובות "נשמעות" בטוחות באותה מידה. ההבדל האמיתי לא נראה בטקסט של הסוכן — הוא נראה בשאלה אם הבאג חוזר מחר.</p>
   </div>
  </div>
</header>

<div class="wrap">
  <div class="callout info">
    <span class="ico">👋</span>
    <p><strong>בשבילכם אם:</strong> אתם נותנים לסוכן לתקן באגים, לכתוב טסטים, או להציע חבילות — ולפעמים מתגלה בדיעבד שהתיקון שטחי, הטסט "מתאים" לבאג, או שהחבילה לא קיימת בכלל.</p>
  </div>
</div>

<main>

  <!-- ================= ROADMAP ================= -->
  <section id="roadmap">
    <div class="wrap">
      <div class="eyebrow">המפה</div>
      <h2 class="section-title">מה נלמד היום?</h2>
      <p class="lede">ארבעה הרגלים שתופסים הזיות ועבודה שטחית של סוכן קידוד — לפני שהן מגיעות ל-production.</p>

      <div class="tiles4">
        <div class="tile"><div class="em">🩺</div><h4>עקרון 1</h4><p>דיבוג שיטתי, לא "תתקן את זה"</p></div>
        <div class="tile"><div class="em">🧪</div><h4>עקרון 2</h4><p>TDD עם סוכן בלי לרמות</p></div>
        <div class="tile"><div class="em">📦</div><h4>עקרון 3</h4><p>חבילות מומצאות</p></div>
        <div class="tile"><div class="em">🔎</div><h4>עקרון 4</h4><p>Review בהקשר נקי</p></div>
      </div>
    </div>
  </section>

  <!-- ================= PRINCIPLE 1 — SYSTEMATIC DEBUGGING ================= -->
  <section id="p1">
    <div class="wrap">
      <div class="eyebrow c">עקרון 1</div>
      <h2 class="section-title">דיבוג שיטתי, לא "תתקן את זה"</h2>
      <p class="lede">"תתקן את זה" נותן לסוכן רשות לנחש. תבנית מתועדת (Anthropic) מחייבת אותו לעבוד כמו מפתח בכיר: השערות לפני שינוי קוד, טסט שמשחזר, תיקון שורש, והוכחה שזה עבד.</p>

      <div class="dd">
        <div class="dd-col no">
          <h4>❌ before</h4>
          <p class="prompt-quote en">fix this bug</p>
          <p class="dd-note">אין סימפטום, אין השערות, אין טסט שמשחזר — הסוכן ינחש ויתקן את הסימפטום הראשון שהוא מוצא.</p>
        </div>
        <div class="dd-col yes">
          <h4>✅ after</h4>
          <p class="prompt-quote en">the checkout returns 500 intermittently since deploy abc123 [stack trace attached]. the service is in src/payments/, with idempotency keys in Redis.
1. build 2-3 hypotheses ranked by likelihood before changing any code.
2. write a failing test that reproduces the bug.
3. fix the root cause — don''t suppress the error or add a retry as a workaround.
4. run the payments test suite and show the output.</p>
          <p class="dd-note">סימפטום + stack trace + מיקום בקוד, ואז תהליך מחייב: השערות ← טסט שמשחזר ← תיקון שורש ← הוכחה שהסוויט עובר.</p>
        </div>
      </div>

      <div class="ba-row">
        <span class="bad">catch the error and retry a few times</span>
        <span class="arr">←</span>
        <span class="good">fix the root cause — don''t suppress the error or add a retry as a workaround</span>
      </div>

      <div class="tb">
        <div class="eyebrow">נסו בעצמכם</div>
        <h3>בנו את בקשת הדיבוג המלאה</h3>
        <p style="margin-top:6px;">הבקשה הגרועה למטה לא נותנת לסוכן שום דבר לעבוד איתו. לחצו על הרכיבים לפי הסדר, וצפו בבקשה האמיתית מתרכבת:</p>
        <div class="tb-bad">fix this bug</div>
        <div class="tb-chips" id="tb-chips">
          <button class="tb-chip" type="button" data-part="0">+ סימפטום + stack trace</button>
          <button class="tb-chip" type="button" data-part="1">+ השערות מדורגות</button>
          <button class="tb-chip" type="button" data-part="2">+ טסט שמשחזר</button>
          <button class="tb-chip" type="button" data-part="3">+ תיקון שורש (לא לדכא)</button>
          <button class="tb-chip" type="button" data-part="4">+ הרצת הסוויט + פלט</button>
        </div>
        <div class="tb-preview" id="tb-preview"><span class="tb-empty">לחצו על הרכיבים למעלה, לפי הסדר</span></div>
        <div class="tb-done" id="tb-done" hidden>✅ זו בקשה שסוכן קידוד יכול לעקוב אחריה שלב-שלב — ולא בקשה שמזמינה ניחוש.</div>
      </div>
    </div>
  </section>

  <!-- ================= PRINCIPLE 2 — TDD WITHOUT CHEATING ================= -->
  <section id="p2">
    <div class="wrap">
      <div class="eyebrow c">עקרון 2</div>
      <h2 class="section-title">TDD עם סוכן — בלי "לרמות"</h2>
      <p class="lede">כשסוכן כותב גם את הטסט וגם את המימוש, הוא עלול "לרמות" בלי כוונה: טסט שמתאים למה שהקוד כבר מחזיר, כולל הבאג. הסדר הבא (מתועד בקהילת Cursor) מונע את זה:</p>

      <div class="subcard" style="margin-top:24px;">
        <h4>חמשת השלבים, בסדר הזה</h4>
        <ol>
          <li>כתיבת טסטים לפי זוגות input/output, עם ציון מפורש <strong>שזו TDD</strong> — כדי שהסוכן לא ייצור mocks לקוד שעדיין לא קיים</li>
          <li>הרצה ואישור שהטסטים <strong>נכשלים</strong>, בלי מימוש</li>
          <li>commit לטסטים</li>
          <li>מימוש "without modifying the tests" עד שהכול עובר</li>
          <li>commit למימוש</li>
        </ol>
        <p class="prompt-quote en" style="margin-top:14px;">this is TDD: write tests from these input/output pairs first, don''t mock code that doesn''t exist yet. run them and confirm they fail. then implement without modifying the tests until they all pass.</p>
      </div>

      <div class="sim">
        <div class="eyebrow">נסו בעצמכם</div>
        <h3>מה קורה כשהסדר מתהפך?</h3>
        <p style="margin-top:6px;">לחצו על אחת הגישות, וראו מה בפועל יוצא מהסוכן:</p>
        <div class="sim-chips" style="margin-top:16px;">
          <button class="sim-chip" type="button" data-tdd="correct">✅ טסטים קודם, מאושרים שנכשלים, ואז מימוש</button>
          <button class="sim-chip" type="button" data-tdd="wrong">❌ מימוש קודם, "ואז תכתוב טסטים שמוכיחים שזה עובד"</button>
        </div>
        <div aria-live="polite" class="sim-out" id="tdd-out"><p class="sim-empty">לחצו על אחת הגישות למעלה</p></div>
      </div>
    </div>
  </section>

  <!-- ================= PRINCIPLE 3 — HALLUCINATED PACKAGES ================= -->
  <section id="p3">
    <div class="wrap">
      <div class="eyebrow c">עקרון 3</div>
      <h2 class="section-title">הזיות בקוד: חבילות שלא קיימות</h2>
      <p class="lede">מודלי שפה לא רק טועים בלוגיקה — הם ממציאים שמות חבילות שנשמעים סבירים אבל לא קיימים ב-npm/PyPI. התופעה נקראת <strong style="color:var(--ink)">slopsquatting</strong>: מי שירשום חבילה בשם שסוכן ממציא שוב ושוב, "תופס" אלפי התקנות.</p>

      <div class="cite"><span class="ico">🔬</span><span>מקור: <a href="https://www.usenix.org/system/files/usenixsecurity25-spracklen.pdf" target="_blank" rel="noopener noreferrer">Spracklen et al., USENIX Security Symposium 2025</a>. 576,000 דגימות קוד, 16 מודלים: בממוצע 19.7% מהחבילות המומלצות לא היו קיימות. GPT-4 Turbo המציא שמות חבילות רק ב-3.59% מהמקרים, ואילו בחלק מהמודלים הפתוחים הקטנים השיעור עלה על שליש. 43% מהשמות המומצאים חזרו בכל אחת מעשר הרצות חוזרות על אותה בקשה — דפוס שחוזר, לא תקלה חד-פעמית.</span></div>

      <div class="pkgsim">
        <div class="eyebrow">נסו בעצמכם</div>
        <h3>תפסו את החבילה המומצאת</h3>
        <p style="margin-top:6px;">ביקשתם מסוכן קידוד להוסיף retry עם exponential backoff. הוא הציע להתקין שלוש חבילות. לפני שמתקינים משהו — בדקו כל אחת:</p>
        <div class="pkg-agent"><span class="cmd">npm install</span> p-retry retry-backoff-pro async-retry</div>
        <div class="pkg-list" id="pkg-list">
          <div class="pkg-row"><span class="pkg-name">p-retry</span><button class="pkg-check" type="button">בדקו ב-npm registry</button><span class="pkg-result" hidden></span></div>
          <div class="pkg-row"><span class="pkg-name">retry-backoff-pro</span><button class="pkg-check" type="button">בדקו ב-npm registry</button><span class="pkg-result" hidden></span></div>
          <div class="pkg-row"><span class="pkg-name">async-retry</span><button class="pkg-check" type="button">בדקו ב-npm registry</button><span class="pkg-result" hidden></span></div>
        </div>
        <div aria-live="polite" class="pkg-summary" id="pkg-summary" hidden></div>
      </div>

      <div class="subcard" style="margin-top:24px;">
        <h4>מה שכן עוזר</h4>
        <ul>
          <li>לנעול lockfiles, ולבדוק שכל חבילה חדשה קיימת ומוכרת לפני התקנה</li>
          <li>להנחות בקובץ ההוראות: <code>no new dependencies without asking</code></li>
          <li>לתת לסוכן הרשאה מפורשת לא לדעת — לפי Anthropic, זה מצמצם מאוד מידע שגוי</li>
          <li>לבקש ראיות, לא הצהרות: "all tests pass" כשלעצמו לא אומר הרבה</li>
        </ul>
      </div>
      <div class="ba-row">
        <span class="bad">"all tests pass ✅"</span>
        <span class="arr">←</span>
        <span class="good">ran `npm test` — paste the exact command and the full output here</span>
      </div>
    </div>
  </section>

  <!-- ================= PRINCIPLE 4 — CLEAN-CONTEXT REVIEW ================= -->
  <section id="p4">
    <div class="wrap">
      <div class="eyebrow c">עקרון 4</div>
      <h2 class="section-title">Review בהקשר נקי, לא "תבדוק את עצמך"</h2>
      <p class="lede">reviewer שרואה רק את ה-diff ואת הקריטריונים — ולא את כל השיחה שהובילה לפתרון — מעריך את התוצאה בלי "להתאהב" בפתרון שהוא עצמו הציע.</p>

      <p class="prompt-quote en" style="margin-top:20px;">use a subagent to review the rate limiter diff against SPEC.md, check every requirement is implemented and the listed edge cases have tests, report gaps that affect correctness and skip style.</p>

      <div class="callout warn">
        <span class="ico">⚠️</span>
        <p>חשוב להגביל את הקריטריונים (correctness, לא style): reviewer שמתבקש "למצוא בעיות" ימצא כמעט תמיד משהו, ותיקון כל הערה מוביל ל-over-engineering.</p>
      </div>

      <div class="board">
        <div class="eyebrow">נסו בעצמכם</div>
        <h3>מיינו: בקשת review ממוקדת, או פתוחה מדי?</h3>
        <p style="margin-top:6px;">לכל בקשה, בחרו לאיזו קטגוריה היא שייכת:</p>
        <div id="board2-rows">
          <div class="board-row" data-ok="focused">
            <div class="board-rule">"use a subagent to review this diff against <code>SPEC.md</code>, check every requirement is implemented and the listed edge cases have tests, report gaps that affect correctness only"</div>
            <div class="board-btns">
              <button class="board-btn" type="button" data-choice="focused">🎯 ממוקד</button>
              <button class="board-btn" type="button" data-choice="open">🌊 פתוח מדי</button>
            </div>
          </div>
          <div class="board-row" data-ok="open">
            <div class="board-rule">"תבדוק את הקוד שכתבת ותגיד לי אם הכול תקין"</div>
            <div class="board-btns">
              <button class="board-btn" type="button" data-choice="focused">🎯 ממוקד</button>
              <button class="board-btn" type="button" data-choice="open">🌊 פתוח מדי</button>
            </div>
          </div>
          <div class="board-row" data-ok="open">
            <div class="board-rule">"use a subagent to find any problems with this code"</div>
            <div class="board-btns">
              <button class="board-btn" type="button" data-choice="focused">🎯 ממוקד</button>
              <button class="board-btn" type="button" data-choice="open">🌊 פתוח מדי</button>
            </div>
          </div>
          <div class="board-row" data-ok="focused">
            <div class="board-rule">"use a subagent to check this diff matches SPEC.md section 3 (rate limit reset logic) and that the two edge cases listed there have tests"</div>
            <div class="board-btns">
              <button class="board-btn" type="button" data-choice="focused">🎯 ממוקד</button>
              <button class="board-btn" type="button" data-choice="open">🌊 פתוח מדי</button>
            </div>
          </div>
        </div>
        <div aria-live="polite" class="board-score" id="board2-score">0 / 4 נכונים</div>
      </div>
    </div>
  </section>

  <!-- ================= EXERCISE ================= -->
  <section id="exercise">
    <div class="wrap">
      <div class="eyebrow">תרגיל סיום</div>
      <h2 class="section-title">זהו את הבעיה, ובחרו את הניסוח הנכון</h2>
      <p class="lede">שלושה תרחישים עם סוכן קידוד. לכל אחד: זהו איזו בעיה מופיעה, ובחרו את הניסוח הנכון.</p>

      <div aria-live="polite" class="exsummary">
        <b id="ex-count">0 / 3 תרגילים עברו</b>
        <div class="bar"><i id="ex-bar"></i></div>
      </div>

      <!-- exercise 1: no systematic debugging -->
      <div class="excard" data-ex data-principle="debug">
        <div class="exhead">
          <div class="exnum">1</div>
          <p class="prompt-quote bad en">the checkout keeps failing, just patch it and redeploy</p>
        </div>
        <p class="exintro">ענו על שתי השאלות:</p>
        <div class="exdiag">
          <p>1. מה הבעיה כאן?</p>
          <div class="choices">
            <button class="choice" type="button" data-diag="0">אין השערות מדורגות, אין טסט שמשחזר את הבאג, ואין דרישה לתקן את שורש הבעיה</button>
            <button class="choice" type="button" data-diag="1">אין הבחנה בין טסטים שבודקים את ההתנהגות הרצויה, לבין טסטים שמתאימים להתנהגות (הבאגית) הקיימת</button>
            <button class="choice" type="button" data-diag="2">שם חבילה שלא אומת שהוא קיים בפועל — יכול להיות הזיה (slopsquatting)</button>
          </div>
          <div aria-live="polite" class="fb" data-diagfb></div>
        </div>
        <div class="exdiag">
          <p>2. איזה שכתוב מתקן את הבעיה?</p>
          <div class="choices">
            <button class="choice en" type="button" data-fix="0">add a try/catch and retry a few times, that should cover it</button>
            <button class="choice en" type="button" data-fix="1">the checkout returns 500 intermittently since deploy abc123 [stack trace]. build 2-3 hypotheses ranked by likelihood before changing code, write a failing test that reproduces it, fix the root cause — don''t suppress the error — then run the payments test suite and show the output</button>
            <button class="choice en" type="button" data-fix="2">explain in general how checkout flows usually work</button>
          </div>
          <div aria-live="polite" class="fb" data-fixfb></div>
        </div>
        <div class="exrow"><span class="exbadge" data-badge></span></div>
      </div>

      <!-- exercise 2: TDD cheating -->
      <div class="excard" data-ex data-principle="tdd">
        <div class="exhead">
          <div class="exnum">2</div>
          <p class="prompt-quote bad en">fix calculatePrice so all the tests pass</p>
        </div>
        <p class="exintro">ענו על שתי השאלות:</p>
        <div class="exdiag">
          <p>1. מה הבעיה כאן?</p>
          <div class="choices">
            <button class="choice" type="button" data-diag="0">אין השערות מדורגות, אין טסט שמשחזר את הבאג, ואין דרישה לתקן את שורש הבעיה</button>
            <button class="choice" type="button" data-diag="1">אין הבחנה בין טסטים שבודקים את ההתנהגות הרצויה, לבין טסטים שמתאימים להתנהגות (הבאגית) הקיימת</button>
            <button class="choice" type="button" data-diag="2">שם חבילה שלא אומת שהוא קיים בפועל — יכול להיות הזיה (slopsquatting)</button>
          </div>
          <div aria-live="polite" class="fb" data-diagfb></div>
        </div>
        <div class="exdiag">
          <p>2. איזה שכתוב מתקן את הבעיה?</p>
          <div class="choices">
            <button class="choice en" type="button" data-fix="0">look at what the function currently returns and write assertions that match it</button>
            <button class="choice en" type="button" data-fix="1">make the tests pass however you need to, I don''t mind which approach</button>
            <button class="choice en" type="button" data-fix="2">this is TDD: write tests from these input/output pairs first, don''t mock code that doesn''t exist yet. run them and confirm they fail without any implementation. then implement without modifying the tests until they all pass</button>
          </div>
          <div aria-live="polite" class="fb" data-fixfb></div>
        </div>
        <div class="exrow"><span class="exbadge" data-badge></span></div>
      </div>

      <!-- exercise 3: hallucinated package -->
      <div class="excard" data-ex data-principle="packages">
        <div class="exhead">
          <div class="exnum">3</div>
          <p class="prompt-quote bad en">npm install turbo-json-parser-pro for faster JSON parsing</p>
        </div>
        <p class="exintro">ענו על שתי השאלות:</p>
        <div class="exdiag">
          <p>1. מה הבעיה כאן?</p>
          <div class="choices">
            <button class="choice" type="button" data-diag="0">אין השערות מדורגות, אין טסט שמשחזר את הבאג, ואין דרישה לתקן את שורש הבעיה</button>
            <button class="choice" type="button" data-diag="1">אין הבחנה בין טסטים שבודקים את ההתנהגות הרצויה, לבין טסטים שמתאימים להתנהגות (הבאגית) הקיימת</button>
            <button class="choice" type="button" data-diag="2">שם חבילה שלא אומת שהוא קיים בפועל — יכול להיות הזיה (slopsquatting)</button>
          </div>
          <div aria-live="polite" class="fb" data-diagfb></div>
        </div>
        <div class="exdiag">
          <p>2. איזה שכתוב מתקן את הבעיה?</p>
          <div class="choices">
            <button class="choice en" type="button" data-fix="0">just install it, agents usually get package names right</button>
            <button class="choice en" type="button" data-fix="1">search the npm registry for this exact package name first. if it doesn''t exist, suggest a real, verified alternative — and don''t add new dependencies without asking</button>
            <button class="choice en" type="button" data-fix="2">rename it to a package that sounds similar and install that instead</button>
          </div>
          <div aria-live="polite" class="fb" data-fixfb></div>
        </div>
        <div class="exrow"><span class="exbadge" data-badge></span></div>
      </div>
    </div>
  </section>

  <!-- ================= RECAP ================= -->
  <section id="recap">
    <div class="wrap">
      <div class="eyebrow c">סיכום</div>
      <h2 class="section-title">מה לקחת איתכם</h2>
      <div class="recap">
        <div class="swap-row">
          <div class="sw-old"><b>❌ הרגל ישן</b>"תתקן את זה" — ומקווים לטוב</div>
          <div class="sw-arrow">←</div>
          <div class="sw-new"><b>✅ במקום זה</b>השערות מדורגות ← טסט שמשחזר ← תיקון שורש ← הרצת הסוויט ופלט</div>
        </div>
        <div class="swap-row">
          <div class="sw-old"><b>❌ הרגל ישן</b>"תממש, ואז תכתוב טסטים שמוכיחים שזה עובד"</div>
          <div class="sw-arrow">←</div>
          <div class="sw-new"><b>✅ במקום זה</b>טסטים מ-input/output קודם, לאשר שנכשלים, commit, מימוש בלי לשנות טסטים, commit</div>
        </div>
        <div class="swap-row">
          <div class="sw-old"><b>❌ הרגל ישן</b>להתקין חבילה שהסוכן הציע כי השם נשמע סביר</div>
          <div class="sw-arrow">←</div>
          <div class="sw-new"><b>✅ במקום זה</b>לבדוק שהחבילה קיימת ב-npm/PyPI, lockfiles, "no new dependencies without asking"</div>
        </div>
        <div class="swap-row">
          <div class="sw-old"><b>❌ הרגל ישן</b>"תבדוק את הקוד שכתבת" / "מצא כל בעיה"</div>
          <div class="sw-arrow">←</div>
          <div class="sw-new"><b>✅ במקום זה</b>subagent עם diff + קריטריוני correctness בלבד, בלי כל השיחה שהובילה לפתרון</div>
        </div>
      </div>
      <div class="callout info" style="margin-top:28px;">
        <span class="ico">🚀</span>
        <p><strong>בשיעור הבא, האחרון בקורס:</strong> ניהול הקשר בשיחות ארוכות, ספריית תבניות אישית, ופרויקט מסכם על בעיה אמיתית משלכם.</p>
      </div>
      <div class="mission-done" id="mission-done"></div>
    </div>
  </section>

</main>

<footer><div class="wrap">הנדסת פרומפטים למפתחים · שיעור 4</div></footer>

<script>
function $(id) { return document.getElementById(id); }
var reduceMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

/* ---------- scroll progress ---------- */
(function () {
  var bar = $("scroll-bar");
  function upd() {
    var h = document.documentElement;
    var max = h.scrollHeight - h.clientHeight;
    bar.style.width = (max > 0 ? (h.scrollTop / max) * 100 : 0) + "%";
  }
  window.addEventListener("scroll", upd, { passive: true });
  upd();
})();

/* ---------- hero debug demo ---------- */
(function () {
  var answers = [
    { q: "just fix it", a: "בודק... מוסיף try/catch סביב הקריאה ל-Redis ו-retry של 3 ניסיונות. זה אמור לפתור את זה. ✅" },
    { q: "the checkout returns 500 intermittently since deploy abc123 [stack trace]. build 2-3 hypotheses ranked by likelihood before changing code, write a failing test that reproduces it, fix the root cause — don''t suppress the error — then run the payments test suite and show the output", a: "קולט. 3 השערות מדורגות: (1) race condition במפתח ה-idempotency אחרי timeout, (2) Redis מחזיר מפתח ישן, (3) retry בצד הלקוח שולח כפל בקשות. בודק את (1) ראשון — הכי סביר לפי הזמן שבין הדיפלוי לתחילת השגיאות. כותב טסט שמשחזר... נכשל כצפוי. מתקן את התחרות על המפתח. מריץ את הסוויט: 142 עברו, 0 נכשלו." }
  ];
  var body = $("chat-body");
  var chips = document.querySelectorAll("#chips .chip");
  var after = $("demo-after");
  var busy = false;
  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      if (busy) return;
      busy = true;
      chips.forEach(function (c) { c.disabled = true; });
      var item = answers[parseInt(chip.dataset.i, 10)];
      body.innerHTML = "";
      var u = document.createElement("div"); u.className = "bubble user"; u.textContent = item.q; body.appendChild(u);
      var ai = document.createElement("div"); ai.className = "bubble ai typing"; body.appendChild(ai);
      var i = 0;
      function finish() {
        ai.classList.remove("typing");
        chips.forEach(function (c) { c.disabled = false; });
        busy = false;
        after.classList.add("show");
      }
      if (reduceMotion) { ai.textContent = item.a; finish(); return; }
      setTimeout(function tick() {
        i += 2;
        ai.textContent = item.a.slice(0, i);
        if (i < item.a.length) setTimeout(tick, 16); else finish();
      }, 400);
    });
  });
})();

/* ---------- debug request builder (principle 1) ---------- */
(function () {
  var parts = [
    { src: "payments", text: "the checkout returns 500 intermittently since deploy abc123 [stack trace attached]. the service is in src/payments/, with idempotency keys in Redis." },
    { src: "payments", text: "1. build 2-3 hypotheses ranked by likelihood before changing any code." },
    { src: "payments", text: "2. write a failing test that reproduces the bug." },
    { src: "payments", text: "3. fix the root cause — don''t suppress the error or add a retry as a workaround." },
    { src: "payments", text: "4. run the payments test suite and show the output." }
  ];
  var preview = $("tb-preview");
  var done = $("tb-done");
  var chips = document.querySelectorAll("#tb-chips .tb-chip");
  var revealed = 0;
  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      if (chip.disabled) return;
      chip.disabled = true;
      if (revealed === 0) preview.innerHTML = "";
      var part = parts[parseInt(chip.dataset.part, 10)];
      var line = document.createElement("div");
      line.className = "tb-line";
      line.innerHTML = part.text + ''<span class="src">// '' + part.src + "</span>";
      preview.appendChild(line);
      revealed++;
      if (revealed === chips.length) done.hidden = false;
    });
  });
})();

/* ---------- TDD order simulator (principle 2) ---------- */
(function () {
  var out = $("tdd-out");
  var chips = document.querySelectorAll(".sim-chip");
  chips.forEach(function (chip) {
    chip.addEventListener("click", function () {
      var mode = chip.dataset.tdd;
      if (mode === "correct") {
        out.innerHTML = ''<div class="sim-card execute"><h5>✅ הסדר הנכון — אי אפשר "לרמות"</h5><ul>'' +
          "<li>טסטים נכתבים מזוגות input/output, עם ציון מפורש שזו TDD</li>" +
          "<li>מריצים — כולם נכשלים (המימוש עדיין לא קיים) — זה המצב התקין</li>" +
          "<li>commit לטסטים</li>" +
          ''<li>מימוש "without modifying the tests" עד שהכול עובר</li>'' +
          "<li>commit למימוש — הטסטים בדקו את ההתנהגות הרצויה, לא את מה שהקוד עשה בפועל</li>" +
          "</ul></div>";
      } else {
        out.innerHTML = ''<div class="sim-card suggest"><h5>⚠️ מימוש קודם, טסטים אחר כך</h5><ul>'' +
          "<li>הסוכן מימש ראשון — ויש בקוד קצה שבור (סכום שלילי לא נבדק)</li>" +
          "<li>עכשיו הוא כותב טסט לקצה הזה... לפי מה שהקוד כבר מחזיר</li>" +
          "<li>הטסט עובר ✅ — אבל הוא מוכיח רק שהקוד עקבי עם עצמו, לא שהוא נכון</li>" +
          "<li>הבאג עדיין בפנים, מוסתר מתחת לטסט ירוק</li>" +
          "</ul></div>";
      }
    });
  });
})();

/* ---------- hallucinated package checker (principle 3) ---------- */
(function () {
  var pkgs = [
    { real: true, note: "קיימת ב-npm — חבילה אמיתית ונפוצה לניסיונות חזרה עם backoff." },
    { real: false, note: "404 Not Found — לא קיימת. שם שנשמע סביר להפליא, אבל הומצא." },
    { real: true, note: "קיימת ב-npm — חבילה אמיתית ונפוצה, גם היא." }
  ];
  var rows = document.querySelectorAll("#pkg-list .pkg-row");
  var checked = 0, fakeFound = 0;
  rows.forEach(function (row, idx) {
    var btn = row.querySelector(".pkg-check");
    var res = row.querySelector(".pkg-result");
    btn.addEventListener("click", function () {
      btn.disabled = true;
      var p = pkgs[idx];
      res.hidden = false;
      res.textContent = (p.real ? "✅ " : "❌ ") + p.note;
      res.className = "pkg-result " + (p.real ? "real" : "fake");
      checked++;
      if (!p.real) fakeFound++;
      if (checked === rows.length) {
        var summary = $("pkg-summary");
        summary.hidden = false;
        summary.textContent = fakeFound + " מתוך " + rows.length + " חבילות שהוצעו הייתה מומצאת. במחקר שבדק 576,000 דגימות קוד מ-16 מודלים, בממוצע 19.7% מהחבילות המומלצות לא היו קיימות — לא תקלה חד-פעמית, אלא דפוס שחוזר.";
      }
    });
  });
})();

/* ---------- review-request sorting board (principle 4) ---------- */
(function () {
  var rows = document.querySelectorAll("#board2-rows .board-row");
  var score = $("board2-score");
  var correct = 0;
  rows.forEach(function (row) {
    var ok = row.dataset.ok;
    var btns = row.querySelectorAll(".board-btn");
    btns.forEach(function (b) {
      b.addEventListener("click", function () {
        btns.forEach(function (x) { x.disabled = true; });
        if (b.dataset.choice === ok) {
          b.classList.add("right");
          correct++;
        } else {
          b.classList.add("wrong");
          row.querySelector(''[data-choice="'' + ok + ''"]'').classList.add("right");
        }
        score.textContent = correct + " / " + rows.length + " נכונים";
      });
    });
  });
})();

/* ---------- exercise: diagnose + pick the fix ---------- */
(function () {
  var diagLabels = [
    "אין השערות מדורגות, אין טסט שמשחזר את הבאג, ואין דרישה לתקן את שורש הבעיה",
    "אין הבחנה בין טסטים שבודקים את ההתנהגות הרצויה, לבין טסטים שמתאימים להתנהגות (הבאגית) הקיימת",
    "שם חבילה שלא אומת שהוא קיים בפועל — יכול להיות הזיה (slopsquatting)"
  ];
  var diagKeyByPrinciple = { debug: 0, tdd: 1, packages: 2 };
  var fixWhyByPrinciple = {
    debug: "זו האפשרות היחידה עם stack trace, בקשה להשערות מדורגות, טסט שמשחזר, ותיקון שורש בלי לדכא את השגיאה.",
    tdd: "זו האפשרות היחידה שמבקשת טסטים מזוגות input/output מוגדרים מראש, מאשרת שהם נכשלים לפני מימוש, ואוסרת לשנות אותם אחר כך.",
    packages: "זו האפשרות היחידה שמבקשת לאמת שהחבילה קיימת בפועל לפני התקנה, ולא להוסיף תלויות בלי רשות."
  };
  var fixOkIndex = { debug: 1, tdd: 2, packages: 1 };
  var cards = document.querySelectorAll("[data-ex]");

  function updateSummary() {
    var passed = 0;
    cards.forEach(function (c) { if (c.classList.contains("passed")) passed++; });
    $("ex-count").textContent = passed + " / " + cards.length + " תרגילים עברו";
    $("ex-bar").style.width = (passed / cards.length * 100) + "%";
    if (window.reportProgress) window.reportProgress(passed, cards.length);
    $("mission-done").textContent = passed === cards.length ? "🎉 כל הכבוד! זיהיתם ובחרתם נכון בכל שלושת התרחישים." : (passed ? passed + " מתוך " + cards.length + " תרגילים עברו" : "");
  }

  cards.forEach(function (card) {
    var principle = card.dataset.principle;
    var okDiagIndex = diagKeyByPrinciple[principle];
    var okFixIndex = fixOkIndex[principle];
    var diagCorrect = false, fixCorrect = false;

    function updateCard() {
      var okCount = (diagCorrect ? 1 : 0) + (fixCorrect ? 1 : 0);
      card.classList.toggle("passed", okCount === 2);
      card.querySelector("[data-badge]").textContent = okCount + " / 2 נכונים";
      updateSummary();
    }

    var diagChoices = card.querySelectorAll("[data-diag]");
    diagChoices.forEach(function (b) {
      b.addEventListener("click", function () {
        diagChoices.forEach(function (x) { x.disabled = true; });
        var j = parseInt(b.dataset.diag, 10);
        var fb = card.querySelector("[data-diagfb]");
        if (j === okDiagIndex) {
          b.classList.add("right");
          diagCorrect = true;
          fb.textContent = "נכון! " + diagLabels[okDiagIndex] + ".";
          fb.className = "fb correct";
        } else {
          b.classList.add("wrong");
          diagChoices[okDiagIndex].classList.add("right");
          fb.textContent = "לא בדיוק. הבעיה כאן היא: " + diagLabels[okDiagIndex] + ".";
          fb.className = "fb wrong";
        }
        updateCard();
      });
    });

    var fixChoices = card.querySelectorAll("[data-fix]");
    fixChoices.forEach(function (b) {
      b.addEventListener("click", function () {
        fixChoices.forEach(function (x) { x.disabled = true; });
        var j = parseInt(b.dataset.fix, 10);
        var fb = card.querySelector("[data-fixfb]");
        if (j === okFixIndex) {
          b.classList.add("right");
          fixCorrect = true;
          fb.textContent = "נכון! " + fixWhyByPrinciple[principle];
          fb.className = "fb correct";
        } else {
          b.classList.add("wrong");
          fixChoices[okFixIndex].classList.add("right");
          fb.textContent = "לא בדיוק. " + fixWhyByPrinciple[principle];
          fb.className = "fb wrong";
        }
        updateCard();
      });
    });

    updateCard();
  });

  if (window.reportProgress) window.reportProgress(0, cards.length);
})();
/* ---------- a11y: expose the selected state of toggle buttons to screen readers ---------- */
(function () {
  var sel = "button.otbtn, button.fstep, .rn-tab, .fsc, .tpl-add-btn";
  function sync(b) { b.setAttribute("aria-pressed", /(^|\s)(active|on)(\s|$)/.test(b.className) ? "true" : "false"); }
  document.querySelectorAll(sel).forEach(function (b) {
    sync(b);
    new MutationObserver(function () { sync(b); }).observe(b, { attributes: true, attributeFilter: ["class"] });
  });
})();
</script>

</body>
</html>
', 4, '2026-11-22T00:00:00.000Z');
