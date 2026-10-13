UPDATE lessons SET html_content = '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 2 — הקריאה הראשונה</title>
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
  --code-head: #2D2A72;
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
p code, li code, summary code {
  font-size: .86em; background: var(--cyan-soft); color: #3F4FE0; border-radius: 8px; padding: 2px 8px;
  direction: ltr; unicode-bidi: embed;
}
button { font-family: var(--sans); cursor: pointer; }
button:focus-visible, a:focus-visible, input:focus-visible, summary:focus-visible { outline: 3px solid rgba(91,108,255,.45); outline-offset: 3px; }

section { padding: clamp(60px, 7vw, 108px) 0; }
section:nth-of-type(even) { background: rgba(255,255,255,.55); }
.eyebrow { display: inline-block; font-family: var(--sans); font-weight: 700; font-size: 14px; letter-spacing: .02em; color: var(--ink-dim); background: rgba(255,255,255,.8); border-radius: 100px; padding: 4px 16px; margin-bottom: 14px; box-shadow: var(--shadow-sm); direction: rtl; }
.eyebrow.c { color: #3F4FE0; background: var(--cyan-soft); box-shadow: none; }
.eyebrow.v { color: #E0553F; background: var(--violet-soft); box-shadow: none; }
h2.section-title { font-size: clamp(1.9rem, 3.6vw, 2.9rem); line-height: 1.22; }
.lede { font-size: clamp(18px, 1.5vw, 20px); margin-top: 14px; max-width: 62ch; }

/* top bars */
.scroll-progress { position: fixed; top: 0; inset-inline: 0; height: 4px; z-index: 50; }
.scroll-progress i { display: block; height: 100%; width: 0; background: linear-gradient(90deg, var(--cyan), var(--cyan-2), var(--violet)); border-radius: 0 4px 4px 0; }
.topbar { background: rgba(255,255,255,.75); backdrop-filter: blur(14px); border-bottom: 1px solid var(--line); padding: 14px 0; position: sticky; top: 0; z-index: 40; }
.topbar-inner { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; font-size: 15px; }
.topbar .course { font-family: var(--display); font-weight: 600; color: var(--ink); }
.topbar .lesson-chip { font-weight: 700; font-size: 13.5px; color: #fff; background: linear-gradient(135deg, var(--cyan), var(--cyan-2)); border-radius: 100px; padding: 4px 16px; }

/* hero */
.hero { position: relative; padding: clamp(48px, 7vw, 100px) 0 clamp(40px, 5vw, 72px); text-align: center; }
.hero h1 { font-size: clamp(2.4rem, 5.4vw, 4.4rem); line-height: 1.12; font-weight: 800; }
.hero h1 .a1 { background: linear-gradient(90deg, var(--cyan), var(--cyan-2)); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero h1 .a2 { background: linear-gradient(90deg, var(--violet), #FFA06B); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero-sub { margin: 20px auto 0; font-size: clamp(18px, 1.6vw, 21px); max-width: 52ch; }
.time-row { margin-top: 26px; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
.pill { font-size: 14.5px; font-weight: 600; color: var(--ink-dim); background: rgba(255,255,255,.85); border-radius: 100px; padding: 6px 16px; box-shadow: var(--shadow-sm); }

.scene { direction: ltr; margin: 44px auto 0; max-width: 600px; display: grid; grid-template-columns: 96px 1fr 96px; align-items: center; gap: 8px; background: var(--bg-panel); border-radius: 30px; box-shadow: var(--shadow); border: 1px solid rgba(91,108,255,.08); padding: 28px 20px 20px; }
.sc-node { text-align: center; }
.sc-node .big { font-size: 46px; line-height: 1.1; display: block; }
.sc-node span.lbl { font-size: 13px; font-weight: 700; color: var(--ink-dim); display: block; margin-top: 4px; direction: rtl; }
.sc-brain { animation: think 6s infinite; }
@keyframes think { 0%, 42% { transform: scale(1); filter: none; } 50% { transform: scale(1.18); filter: drop-shadow(0 0 14px rgba(139,107,255,.8)); } 58%, 100% { transform: scale(1); filter: none; } }
.sc-track { position: relative; height: 60px; }
.sc-track::before { content: ""; position: absolute; inset-inline: 0; top: 50%; border-top: 3px dotted var(--line-strong); }
.mail { position: absolute; top: 50%; font-size: 30px; margin-top: -20px; opacity: 0; }
.mail.go { animation: go 6s infinite; }
.mail.back { animation: back 6s infinite; }
@keyframes go { 0% { left: 0; opacity: 0; } 4% { opacity: 1; } 40% { left: calc(100% - 30px); opacity: 1; } 46%, 100% { left: calc(100% - 30px); opacity: 0; } }
@keyframes back { 0%, 54% { left: calc(100% - 30px); opacity: 0; } 58% { opacity: 1; } 94% { left: 0; opacity: 1; } 100% { left: 0; opacity: 0; } }
.scene-caption { grid-column: 1 / -1; direction: rtl; text-align: center; font-size: 15px; color: var(--ink-dim); margin-top: 14px; }

/* today tiles */
.tiles3 { margin-top: 28px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; }
@media (max-width: 700px) { .tiles3 { grid-template-columns: minmax(0, 1fr); } }
.tile { background: #fff; border-radius: 22px; padding: 22px 20px; box-shadow: var(--shadow-sm); text-align: center; }
.tile .em { font-size: 36px; line-height: 1.2; }
.tile h4 { font-size: 17px; margin: 8px 0 4px; }
.tile p { font-size: 15px; line-height: 1.6; }

/* shared */
.callout { margin-top: 20px; border-radius: 20px; padding: 16px 20px; font-size: 16px; display: flex; gap: 14px; align-items: flex-start; border: 1px solid; text-align: start; }
.callout .ico { font-size: 22px; line-height: 1.5; }
.callout p { color: var(--ink); }
.callout.warn { background: var(--warn-soft); border-color: rgba(217,138,0,.22); }
.callout.danger { background: var(--danger-soft); border-color: rgba(229,72,106,.22); }
.callout.info { background: var(--cyan-soft); border-color: rgba(91,108,255,.2); }
.callout.ok { background: var(--success-soft); border-color: rgba(31,185,133,.25); }

.code-card { background: var(--code-bg); border-radius: 20px; overflow: hidden; margin-top: 16px; box-shadow: 0 14px 34px -16px rgba(34,31,85,.55); }
.code-card-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 9px 16px; background: var(--code-head); font-size: 13.5px; font-weight: 700; color: #B9B6E8; }
.copy-btn { font-size: 13px; font-weight: 700; color: #fff; background: rgba(255,255,255,.14); border: none; border-radius: 100px; padding: 4px 14px; transition: background .15s; }
.copy-btn:hover { background: rgba(255,255,255,.26); }
.code-card pre { direction: ltr; text-align: left; margin: 0; padding: 16px 20px 18px; overflow-x: auto; font-family: var(--mono); font-size: 14.5px; line-height: 1.8; color: var(--code-ink); }
.code-card pre.he-out { direction: rtl; text-align: right; font-family: var(--sans); font-size: 16.5px; line-height: 1.7; white-space: pre-wrap; }
.term .out { color: #B9B6E8; }
.he { direction: rtl; unicode-bidi: isolate; }
.k { color: #C4A7FF; } .s { color: #9BE8B5; } .f { color: #8FB4FF; } .cm { color: #8C89C4; font-style: italic; }

.btn { font-family: var(--display); font-weight: 600; font-size: 16px; color: #fff; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); border: none; border-radius: 100px; padding: 12px 28px; box-shadow: 0 12px 26px -12px rgba(91,108,255,.8); transition: transform .18s, box-shadow .18s, opacity .18s; }
.btn:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 16px 30px -12px rgba(91,108,255,.9); }
.btn:disabled { opacity: .4; cursor: not-allowed; box-shadow: none; }
.btn.ghost { background: #fff; color: var(--ink); box-shadow: var(--shadow-sm); }

/* quest */
.quest { margin-top: 30px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 26px 26px 20px; }
.quest-track { position: relative; height: 54px; margin: 0 22px; }
.quest-line { position: absolute; top: 34px; inset-inline: 0; height: 6px; border-radius: 6px; background: var(--bg-panel-2); }
.quest-line i { display: block; height: 100%; width: 0; border-radius: 6px; background: linear-gradient(90deg, #34D6A0, #1FB985); transition: width .5s ease; }
.quest-stop { position: absolute; top: 24px; width: 26px; height: 26px; margin-right: -13px; border-radius: 50%; background: #fff; border: 3px solid var(--line-strong); transition: all .3s; }
.quest-stop.on { background: var(--success); border-color: var(--success); }
.rocket { position: absolute; top: -2px; font-size: 30px; margin-right: -16px; transition: right .5s ease; }
.quest-labels { display: flex; justify-content: space-between; margin: 6px 0 0; font-size: 13.5px; font-weight: 700; color: var(--ink-dim); direction: rtl; }
.quest-count { margin-top: 10px; text-align: center; font-size: 15px; font-weight: 700; color: var(--ink-dim); direction: rtl; }

.steps { margin-top: 24px; display: grid; grid-template-columns: minmax(0, 1fr); gap: 22px; }
.step-card { background: #fff; border-radius: var(--radius); padding: 26px 28px; box-shadow: var(--shadow); border: 2px solid transparent; transition: border-color .25s; min-width: 0; }
.step-card.done { border-color: rgba(31,185,133,.55); }
.step-head { display: flex; align-items: center; gap: 14px; }
.step-ico { width: 48px; height: 48px; border-radius: 16px; background: var(--bg-panel-2); display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
.step-head h3 { font-size: 20px; flex: 1; }
.check { display: flex; align-items: center; gap: 8px; font-size: 14.5px; font-weight: 700; color: var(--ink-dim); cursor: pointer; flex-shrink: 0; background: var(--bg-panel-2); border-radius: 100px; padding: 5px 14px 5px 12px; }
.check input { width: 20px; height: 20px; accent-color: var(--success); cursor: pointer; }
.step-body { margin-top: 16px; }
.step-body > p { font-size: 16.5px; }
.step-body ol.plain { margin: 8px 0 0; padding-inline-start: 24px; color: var(--ink-dim); font-size: 16.5px; }
.step-body ol.plain li { margin-bottom: 5px; }

/* anatomy */
.anat { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 24px 22px; }
.stations { display: grid; grid-template-columns: repeat(6, minmax(0, 1fr)); gap: 6px; margin-bottom: 20px; }
@media (max-width: 560px) { .stations { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
.st { text-align: center; opacity: .5; transition: opacity .25s, transform .25s; }
.st .bd { width: 58px; height: 58px; margin: 0 auto 6px; border-radius: 20px; background: var(--bg-panel-2); border: 2px solid transparent; display: flex; align-items: center; justify-content: center; font-size: 26px; transition: all .25s; }
.st .nl { font-size: 13px; font-weight: 700; color: var(--ink-dim); direction: rtl; }
.st.on { opacity: 1; transform: translateY(-3px); }
.st.on .bd { border-color: var(--stc); background: #fff; box-shadow: 0 12px 26px -10px var(--stc); }
.st.on .nl { color: var(--stc); }
.cl-list { direction: ltr; display: grid; gap: 5px; }
.cl { text-align: left; background: var(--code-bg); border: 1px solid transparent; border-inline-start: 5px solid var(--stc); border-radius: 10px; padding: 5px 14px; font-family: var(--mono); font-size: 14px; line-height: 1.7; color: var(--code-ink); white-space: pre; overflow-x: auto; display: flex; gap: 14px; transition: all .15s; }
.cl .ln { color: #8C89C4; user-select: none; min-width: 1ch; }
.cl:hover { background: var(--code-head); }
.cl.on { border-color: var(--stc); background: var(--code-head); box-shadow: 0 10px 22px -12px var(--stc); }
.anat-text { margin-top: 18px; min-height: 100px; direction: rtl; }
.anat-text h4 { font-size: 18px; margin-bottom: 4px; }
.anat-text p { font-size: 16.5px; color: var(--ink); }

/* gifts */
.present { margin-top: 28px; text-align: center; }
.present .top { font-size: 16px; color: var(--ink-dim); }
.present .top code { font-size: 1em; }
.gifts { margin-top: 14px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; text-align: start; align-items: start; }
@media (max-width: 700px) { .gifts { grid-template-columns: minmax(0, 1fr); } }
.gift { background: #fff; border: 2px solid transparent; border-radius: 22px; box-shadow: var(--shadow-sm); padding: 0; color: var(--ink); text-align: center; overflow: hidden; display: block; width: 100%; transition: transform .2s, box-shadow .2s, border-color .2s; }
.gift:hover { transform: translateY(-3px); box-shadow: var(--shadow); }
.gift .front { padding: 24px 12px; }
.gift .front .em { font-size: 42px; line-height: 1.2; display: block; }
.gift .front b { font-family: var(--display); font-size: 17px; display: block; margin-top: 6px; }
.gift .front small { font-size: 13.5px; color: var(--ink-faint); display: block; }
.gift .back { display: none; padding: 16px 18px 20px; text-align: start; font-size: 15.5px; line-height: 1.6; color: var(--ink); border-top: 1px dashed var(--line-strong); }
.gift.open { border-color: var(--cyan); background: linear-gradient(135deg, var(--cyan-soft), #fff); }
.gift.open .back { display: block; }
.gift code { direction: ltr; unicode-bidi: embed; font-family: var(--mono); font-size: .86em; color: #3F4FE0; background: var(--cyan-soft); border-radius: 8px; padding: 2px 8px; }
.tokbar { direction: ltr; display: flex; height: 28px; border-radius: 10px; overflow: hidden; margin: 10px 0 6px; font-family: var(--mono); font-size: 12.5px; font-weight: 700; color: #fff; }
.tokbar span { display: flex; align-items: center; justify-content: center; }
.tokbar .tin { background: linear-gradient(135deg, #6C7BFF, #8B6BFF); flex: 17; }
.tokbar .tout { background: linear-gradient(135deg, #FF7B6B, #FFA06B); flex: 24; }

/* experiments */
.exps { margin-top: 26px; display: grid; gap: 16px; }
.exp { background: #fff; border-radius: 24px; box-shadow: var(--shadow-sm); padding: 20px 24px; display: grid; grid-template-columns: 48px minmax(0, 1fr); gap: 16px; align-items: start; }
.exp .em { font-size: 36px; line-height: 1.3; }
.exp h4 { font-size: 18px; }
.exp > div > p { font-size: 16.5px; margin-top: 2px; }
.exp .code-card { margin-top: 12px; }
.exp .code-card pre { padding: 13px 18px; font-size: 14px; }

/* quiz */
.choices { display: grid; gap: 10px; }
.choice { text-align: start; background: #fff; border: 1.5px solid var(--line); color: var(--ink); border-radius: 16px; padding: 12px 18px; font-size: 16px; transition: all .15s; box-shadow: var(--shadow-sm); }
.choice:hover:not(:disabled) { border-color: var(--cyan); transform: translateY(-1px); }
.choice.right { border-color: var(--success); background: var(--success-soft); }
.choice.wrong { border-color: var(--danger); background: var(--danger-soft); }
.choice:disabled { cursor: default; }
.fb { margin-top: 12px; font-size: 15.5px; font-weight: 700; min-height: 22px; }
.fb.correct { color: var(--success); } .fb.wrong { color: var(--danger); }
#quiz-container { margin-top: 28px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 22px; align-items: start; }
@media (max-width: 900px) { #quiz-container { grid-template-columns: minmax(0, 1fr); } }
.quiz-card { background: #fff; border-radius: 26px; padding: 24px 26px; box-shadow: var(--shadow); }
.quiz-card > p { color: var(--ink); font-weight: 700; font-size: 17.5px; margin-bottom: 14px; }
.score-box { margin-top: 26px; font-family: var(--display); font-weight: 700; font-size: 22px; color: #3F4FE0; }

/* mission */
.mission { margin-top: 30px; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); border-radius: var(--radius); padding: 32px 34px; box-shadow: 0 24px 50px -22px rgba(91,108,255,.75); }
.mission h3 { font-size: 24px; color: #fff; }
.mission ul { list-style: none; padding: 0; margin: 20px 0 0; display: grid; gap: 14px; }
.mission li label { display: flex; gap: 14px; align-items: flex-start; color: #fff; font-size: 17.5px; cursor: pointer; }
.mission li input { width: 22px; height: 22px; margin-top: 4px; accent-color: #1FB985; flex-shrink: 0; }
.mission li input:checked + span { opacity: .65; text-decoration: line-through; }
.mission li code { background: rgba(255,255,255,.2); color: #fff; padding: 2px 8px; border-radius: 8px; font-size: .86em; direction: ltr; unicode-bidi: embed; }
.mission-done { margin-top: 20px; font-weight: 700; font-family: var(--display); color: #fff; min-height: 26px; }
.next-card { margin-top: 24px; background: #fff; border-radius: var(--radius); padding: 26px 30px; box-shadow: var(--shadow); }
.next-card .eyebrow { margin-bottom: 8px; }
.next-card h3 { font-size: 22px; }

footer { padding: 56px 0 84px; text-align: center; color: var(--ink-faint); font-size: 14.5px; }
[hidden] { display: none !important; }

/* link to the prompts course */
.plink { color: #E0553F; font-weight: 700; text-decoration: underline; text-underline-offset: 3px; }
.plink:hover { text-decoration-thickness: 2px; }
</style>
</head>
<body>

<div class="scroll-progress" aria-hidden="true"><i id="scroll-bar"></i></div>

<div class="topbar">
  <div class="wrap topbar-inner">
    <span class="course">בונים אפליקציית AI עם OpenAI ו-Python</span>
    <span class="lesson-chip">שיעור 2</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap">
    <div class="eyebrow c" style="text-align:center;">שיעור 2 · הקריאה הראשונה</div>
    <h1>שבע שורות קוד,<br>ו<span class="a1">ה-AI</span> עונה <span class="a2">לכם</span></h1>
    <p class="hero-sub">הכנו הכול בשיעור הקודם. היום מגיע החלק הכי כיף: כותבים תוכנה קטנה ושולחים את השאלה הראשונה שלנו אל המודל.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-30 דקות</span>
      <span class="pill">✍️ קוד ראשון</span>
      <span class="pill">🧪 וגם ניסויים</span>
    </div>

    <div class="scene" aria-hidden="true">
      <div class="sc-node"><span class="big">💻</span><span class="lbl">התוכנה שלכם</span></div>
      <div class="sc-track"><span class="mail go">💌</span><span class="mail back">💬</span></div>
      <div class="sc-node"><span class="big sc-brain">🧠</span><span class="lbl">המודל של OpenAI</span></div>
      <div class="scene-caption">מכתב יוצא עם שאלה, ותשובה חוזרת. זה כל הסיפור.</div>
    </div>
  </div>
</header>

<main>

  <!-- ================= TODAY ================= -->
  <section id="today">
    <div class="wrap">
      <div class="eyebrow">התוכנית להיום</div>
      <h2 class="section-title">שלוש תחנות, ובסוף יש תשובה</h2>
      <div class="tiles3">
        <div class="tile"><div class="em">📦</div><h4>מתקינים</h4><p>ארגז כלים מוכן שיודע לדבר עם OpenAI</p></div>
        <div class="tile"><div class="em">✍️</div><h4>כותבים</h4><p>שבע שורות, ואפשר גם להבין כל אחת מהן</p></div>
        <div class="tile"><div class="em">🚀</div><h4>מריצים</h4><p>לוחצים Enter ורואים את התשובה מגיעה</p></div>
      </div>
      <div class="callout info">
        <span class="ico">🔑</span>
        <p>המפתח שיצרתם בשיעור 1 עובד מאחורי הקלעים. לא נצטרך לגעת בו ולא להדביק אותו בקוד.</p>
      </div>
    </div>
  </section>

  <!-- ================= QUEST ================= -->
  <section id="setup">
    <div class="wrap">
      <div class="eyebrow c">יוצאים לדרך</div>
      <h2 class="section-title">ארבעה צעדים עד התשובה הראשונה</h2>
      <p class="lede">סמנו וי אחרי כל צעד, ותראו את הטיל מתקדם.</p>

      <div class="quest" aria-label="התקדמות">
        <div class="quest-track">
          <div class="quest-line"><i id="quest-fill"></i></div>
          <span class="quest-stop" style="right:0%"></span>
          <span class="quest-stop" style="right:33.33%"></span>
          <span class="quest-stop" style="right:66.66%"></span>
          <span class="quest-stop" style="right:100%"></span>
          <span class="rocket" id="rocket" style="right:0%">🚀</span>
        </div>
        <div class="quest-labels"><span>תיקייה</span><span>התקנה</span><span>קוד</span><span>הרצה</span></div>
        <div class="quest-count" id="quest-count">0 מתוך 4 צעדים</div>
      </div>

      <div class="steps">

        <!-- 1 -->
        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">📁</div><h3>1 · פותחים תיקייה לפרויקט</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>כל פרויקט גר בתיקייה משלו, כמו מחברת נפרדת לכל נושא.</p>
            <ol class="plain">
              <li>צרו במחשב תיקייה חדשה, למשל <code>ai-course</code>, במקום שקל למצוא (שולחן העבודה או Documents).</li>
              <li>ב-VS Code בחרו <strong>File ← Open Folder</strong> ופתחו אותה. אם נשאלתם אם אתם סומכים על המחברים, אשרו.</li>
              <li>פתחו את חלון הפקודות (הטרמינל): <strong>Terminal ← New Terminal</strong>.</li>
            </ol>
            <div class="callout info">
              <span class="ico">💡</span>
              <p>לא בטוחים שאתם בתיקייה הנכונה? הריצו <code>pwd</code> כדי לראות איפה אתם, או <code>ls</code> כדי לראות מה יש בפנים.</p>
            </div>
          </div>
        </div>

        <!-- 2 -->
        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">📦</div><h3>2 · מתקינים את ארגז הכלים</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>את הדיבור עם OpenAI כבר מישהו כתב בשבילנו, בצורת <strong>ספרייה</strong>: ארגז כלים מוכן. מתקינים אותו בפקודה אחת בטרמינל:</p>
            <div class="code-card term">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python -m pip install openai</pre>
            </div>
            <p style="margin-top:12px; font-size:15px;">כמה שניות של טקסט שרץ, ובסוף שורה שמתחילה ב-<code>Successfully installed</code>. מופיעות שם גם ספריות נוספות, וזה בסדר גמור: הן באות יחד איתה.</p>
          </div>
        </div>

        <!-- 3 -->
        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">✍️</div><h3>3 · כותבים את התוכנית</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <ol class="plain">
              <li>ב-VS Code לחצו על סמל הקובץ החדש (או <strong>File ← New File</strong>).</li>
              <li>קראו לו <code>first_call.py</code>. הסיומת <code>.py</code> אומרת שזה קובץ פייתון.</li>
              <li>הדביקו את הקוד ושמרו עם <code>Ctrl + S</code>.</li>
            </ol>
            <div class="code-card">
              <div class="code-card-head"><span>first_call.py</span><button class="copy-btn" type="button">העתק</button></div>
<pre><span class="k">from</span> openai <span class="k">import</span> OpenAI
client = <span class="f">OpenAI</span>()
response = client.responses.<span class="f">create</span>(
    model=<span class="s">"gpt-4o-mini"</span>,
    input=<span class="s">"<span class="he">מה זה API? ענה בעברית, בשני משפטים</span>"</span>,
)
<span class="f">print</span>(response.output_text)</pre>
            </div>
            <div class="callout warn">
              <span class="ico">⚠️</span>
              <p><strong>שימו לב לרווחים.</strong> בשורות 4 ו-5 יש ארבעה רווחים בתחילת השורה. בפייתון זה חלק מהקוד. אם הדבקתם ושמרתם, הכול במקום.</p>
            </div>
            <div class="callout danger">
              <span class="ico">🚨</span>
              <p><strong>אין כאן מפתח, וכך זה צריך להישאר.</strong> לא מוסיפים <code>api_key="sk-..."</code> לקוד, גם לא "רק לבדיקה".</p>
            </div>
          </div>
        </div>

        <!-- 4 -->
        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">🚀</div><h3>4 · מריצים</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>בטרמינל, באותה תיקייה שבה נמצא הקובץ:</p>
            <div class="code-card term">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python first_call.py</pre>
            </div>
            <p style="margin-top:12px;">אחרי שנייה או שתיים תופיע תשובה בעברית, בערך כך. המילים שלכם יהיו קצת שונות, ובעוד רגע נבין למה:</p>
            <div class="code-card term">
              <div class="code-card-head"><span>הפלט</span></div>
<pre class="he-out"><span class="out">API (ממשק תכנות יישומים) הוא סט כללים שמאפשר לתוכנה אחת לבקש מידע או פעולה מתוכנה אחרת. הוא פועל כמו מלצר שלוקח את ההזמנה למטבח ומחזיר את האוכל לשולחן.</span></pre>
            </div>
            <div class="callout warn">
              <span class="ico">↔️</span>
              <p>בטרמינל של VS Code עברית עלולה להופיע <strong>הפוכה</strong> או עם פיסוק במקום לא נכון. זו בעיית תצוגה של הטרמינל, לא טעות שלכם ולא של המודל. כשנבנה ממשק web זה ייפתר מעצמו. אם מופיעה שגיאה או סימני שאלה, גללו למטה לחלק "קיבלתם שגיאה".</p>
            </div>
            <div class="callout ok">
              <span class="ico">🎉</span>
              <p><strong>זהו!</strong> תוכנה שכתבתם שלחה שאלה לשרתים של OpenAI וקיבלה תשובה. כל מה שנבנה בהמשך הקורס מבוסס על זה.</p>
            </div>
            <div class="callout info">
              <span class="ico">💰</span>
              <p>כל הרצה עולה שברירי סנט. 5 הדולרים משיעור 1 מספיקים לאלפי הרצות כאלה.</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

  <!-- ================= ANATOMY ================= -->
  <section id="anatomy">
    <div class="wrap">
      <div class="eyebrow v">מבינים</div>
      <h2 class="section-title">הקוד הוא מכתב עם מסע</h2>
      <p class="lede">זוכרים את המסע משיעור 1? הוא כתוב עכשיו בקוד. לחצו על כל שורה ותראו איזו תחנה במסע היא מפעילה.</p>

      <div class="anat">
        <div class="stations" id="stations"></div>
        <div class="cl-list" id="cl-list"></div>
        <div class="anat-text" id="anat-text"></div>
      </div>

      <div class="callout info">
        <span class="ico">🧩</span>
        <p>שורות 3 עד 6 הן <strong>פקודה אחת</strong> שנפרסה על כמה שורות כדי שתהיה קריאה. הסוגר שנפתח בשורה 3 נסגר רק בשורה 6.</p>
      </div>
    </div>
  </section>

  <!-- ================= RESPONSE ================= -->
  <section id="response">
    <div class="wrap">
      <div class="eyebrow c">התשובה</div>
      <h2 class="section-title">חבילה חזרה, ויש בה יותר מטקסט</h2>
      <p class="lede">המשתנה <code>response</code> הוא חבילה. הדפסנו ממנה רק את הטקסט, אבל יש בה עוד דברים. לחצו על כל מתנה כדי לפתוח אותה:</p>

      <div class="present">
        <div class="top">📦 <code>response</code></div>
        <div class="gifts">
          <button class="gift" type="button">
            <div class="front"><span class="em">💬</span><b>הטקסט</b><small>לחצו לפתיחה</small></div>
            <div class="back">התשובה עצמה. מוציאים אותה עם <code>response.output_text</code>, וזה מה שהדפסנו. זה הדבר שנציג בדרך כלל למשתמש.</div>
          </button>
          <button class="gift" type="button">
            <div class="front"><span class="em">🪙</span><b>הטוקנים</b><small>לחצו לפתיחה</small></div>
            <div class="back">כמה טוקנים (חתיכות טקסט) שלחנו וכמה קיבלנו, וממנה אפשר לחשב כמה זה עלה.
              <div class="tokbar"><span class="tin">17</span><span class="tout">24</span></div>
              <span style="font-size:12.5px;color:var(--ink-faint);">שלחנו 17, קיבלנו 24. אצלכם המספרים יהיו קצת אחרים. שולפים אותם עם <code>response.usage</code>.</span></div>
          </button>
          <button class="gift" type="button">
            <div class="front"><span class="em">🏷️</span><b>המודל</b><small>לחצו לפתיחה</small></div>
            <div class="back">איזה מודל ענה בפועל, ליתר ביטחון. שולפים עם <code>response.model</code>, ותקבלו שם כמו <code>gpt-4o-mini-...</code> עם סיומת של גרסה.</div>
          </button>
        </div>
      </div>

      <div class="callout warn">
        <span class="ico">🎲</span>
        <p><strong>הריצו שוב, והתשובה תהיה קצת שונה.</strong> המודל לא שולף תשובה שמורה אלא בונה אותה מילה אחרי מילה, ובכל מילה יש כמה המשכים סבירים. לכן הניסוח משתנה, וזה תקין. בשיעור 4 נלמד איך לשלוט בזה.</p>
      </div>
    </div>
  </section>

  <!-- ================= EXPERIMENTS ================= -->
  <section id="experiments">
    <div class="wrap">
      <div class="eyebrow c">משחקים</div>
      <h2 class="section-title">שלושה ניסויים</h2>
      <p class="lede">הדרך הכי טובה להבין קוד היא לשבור אותו קצת. אחרי כל שינוי: שמרו (<code>Ctrl + S</code>) והריצו שוב.</p>

      <div class="exps">
        <div class="exp">
          <div class="em">❓</div>
          <div>
            <h4>ניסוי 1 · שנו את השאלה</h4>
            <p>החליפו את הטקסט שבתוך <code>input</code> בכל שאלה שתרצו:</p>
            <div class="code-card"><pre>    input=<span class="s">"<span class="he">תן לי שלושה רעיונות לשם לחתול</span>"</span>,</pre></div>
          </div>
        </div>

        <div class="exp">
          <div class="em">🪙</div>
          <div>
            <h4>ניסוי 2 · בדקו כמה זה עלה</h4>
            <p>הוסיפו שורה בסוף הקובץ שמדפיסה כמה טוקנים השתמשתם:</p>
            <div class="code-card"><pre><span class="f">print</span>(response.usage.total_tokens)</pre></div>
          </div>
        </div>

        <div class="exp">
          <div class="em">🧒</div>
          <div>
            <h4>ניסוי 3 · שנו את הסגנון</h4>
            <p>אפשר לבקש גם קהל וסגנון:</p>
            <div class="code-card"><pre>    input=<span class="s">"<span class="he">הסבר מה זה API לילד בן 8, בעברית</span>"</span>,</pre></div>
            <p style="margin-top:8px; font-size:14.5px;">אותה שאלה, וניסוח אחר לגמרי. בשיעור 4 נלמד לקבוע את הסגנון הזה בצורה מסודרת.</p>
            <p style="margin-top:8px; font-size:14.5px;">💡 רוצים לדייק את הפרומפטים? ב<a class="plink" href="/courses/prompts" target="_top">קורס פרומפטים</a> שעובדים תמצאו איך.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= ERRORS ================= -->
  <section id="errors">
    <div class="wrap">
      <div class="eyebrow v">כשמשהו נשבר</div>
      <h2 class="section-title">קיבלתם שגיאה? שואלים את ה-AI</h2>
      <p class="lede">שגיאה אדומה היא לא כישלון, אלא רמז. ואת הרמז הכי קל לפענח עם AI: מדביקים לו את השגיאה, והוא אומר מה צריך לתקן.</p>

      <div class="tiles3">
        <div class="tile"><div class="em">📋</div><h4>1 · מעתיקים</h4><p>את הודעת השגיאה, או לפחות את השורות האחרונות שלה</p></div>
        <div class="tile"><div class="em">💬</div><h4>2 · שואלים</h4><p>מדביקים ב-ChatGPT וכותבים מה ניסיתם לעשות</p></div>
        <div class="tile"><div class="em">🔧</div><h4>3 · מתקנים</h4><p>עושים מה שהוא אומר, ומריצים שוב</p></div>
      </div>

      <div class="code-card">
        <div class="code-card-head"><span>נוסח לדוגמה לשאלה</span><button class="copy-btn" type="button">העתק</button></div>
<pre class="he-out">הרצתי את הקובץ first_call.py ואני מקבל את השגיאה הבאה. מה צריך לתקן?

(כאן מדביקים את השגיאה)

(ואם צריך, מדביקים גם את הקוד)</pre>
      </div>

      <div class="callout danger">
        <span class="ico">🚨</span>
        <p><strong>לפני שמדביקים או מצלמים שגיאה:</strong> ודאו שהמפתח המלא לא מופיע בה. הודעות מסוימות מציגות חלק ממנו.</p>
      </div>
    </div>
  </section>

  <!-- ================= QUIZ ================= -->
  <section id="quiz">
    <div class="wrap">
      <div class="eyebrow">בדיקה מהירה</div>
      <h2 class="section-title">ארבע שאלות לסיום</h2>
      <div id="quiz-container"></div>
      <div class="score-box" id="score-box"></div>
    </div>
  </section>

  <!-- ================= MISSION ================= -->
  <section id="mission">
    <div class="wrap">
      <div class="eyebrow c">המשימה שלכם</div>
      <h2 class="section-title">לפני שהשיעור הבא מתחיל</h2>

      <div class="mission">
        <h3>🎯 שלוש משימות</h3>
        <ul id="mission-list">
          <li><label><input type="checkbox"><span>הרצתי את <code>first_call.py</code> וקיבלתי תשובה אמיתית מהמודל</span></label></li>
          <li><label><input type="checkbox"><span>שיניתי את השאלה, הרצתי שוב, וקיבלתי תשובה שונה</span></label></li>
          <li><label><input type="checkbox"><span>הדפסתי את <code>response.usage.total_tokens</code> וראיתי כמה טוקנים השתמשתי</span></label></li>
        </ul>
        <div class="mission-done" id="mission-done"></div>
      </div>

      <div class="callout info">
        <span class="ico">⭐</span>
        <p><strong>אתגר בונוס:</strong> שלחו את אותה שאלה שלוש פעמים ברצף והשוו. כמה התשובות שונות? ומה קורה בשאלה עם תשובה אחת בלבד, כמו "כמה זה 2+2?"</p>
      </div>

      <div class="next-card">
        <div class="eyebrow">בשיעור הבא · שיעור 3</div>
        <h3>שיחה עם זיכרון</h3>
        <p style="margin-top:6px;">התוכנית של היום שואלת שאלה אחת ושוכחת הכול. בשיעור הבא נבין למה המודל לא זוכר, ונהפוך אותה לבוט צ''אט שמנהל שיחה שלמה.</p>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">בונים אפליקציית AI עם OpenAI ו-Python · שיעור 2</div></footer>

<script>
function $(id) { return document.getElementById(id); }
function el(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text) e.textContent = text; return e; }

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

/* ---------- copy buttons ---------- */
(function () {
  document.querySelectorAll(".copy-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var text = btn.closest(".code-card").querySelector("pre").textContent.trim();
      var original = btn.textContent;
      function done(ok) {
        btn.textContent = ok ? "הועתק ✓" : "סמנו והעתיקו ידנית";
        setTimeout(function () { btn.textContent = original; }, 1600);
      }
      try { navigator.clipboard.writeText(text).then(function () { done(true); }, function () { done(false); }); }
      catch (e) { done(false); }
    });
  });
})();

/* ---------- quest + checklist ---------- */
(function () {
  var checks = document.querySelectorAll(".step-check");
  var stops = document.querySelectorAll(".quest-stop");
  function upd() {
    var n = 0;
    checks.forEach(function (c) { c.closest(".step-card").classList.toggle("done", c.checked); if (c.checked) n++; });
    var gaps = checks.length - 1;
    var pos = n === 0 ? 0 : (n - 1) / gaps * 100;
    $("quest-fill").style.width = pos + "%";
    $("rocket").style.right = pos + "%";
    stops.forEach(function (s, i) { s.classList.toggle("on", i < n); });
    $("quest-count").textContent = n === checks.length ? "🎉 כל הצעדים הושלמו!" : n + " מתוך " + checks.length + " צעדים";
  }
  checks.forEach(function (c) { c.addEventListener("change", upd); });
  upd();
})();

/* ---------- anatomy: code as a letter ---------- */
(function () {
  var stations = [
    { e: "📦", n: "הספרייה", c: "#3F6FD9" },
    { e: "🔑", n: "הלקוח והמפתח", c: "#D98A00" },
    { e: "💌", n: "הבקשה", c: "#E0558A" },
    { e: "🧠", n: "המודל", c: "#0F9F86" },
    { e: "❓", n: "השאלה", c: "#2E9E3E" },
    { e: "💬", n: "התשובה", c: "#E0553F" }
  ];
  var lines = [
    { c: "from openai import OpenAI", s: 0, t: "פותחים את ארגז הכלים", x: "אומרים לפייתון: \"מתוך הספרייה openai שהתקנו, תביא לי את OpenAI\". זה ה\"שליח\" שיודע איך מדברים עם השרתים של OpenAI." },
    { c: "client = OpenAI()", s: 1, t: "מזמינים שליח, והמפתח עולה איתו", x: "יוצרים את השליח וקוראים לו client. הסוגריים ריקים בכוונה: השליח מחפש בעצמו את OPENAI_API_KEY במחשב, זה שהגדרתם בשיעור 1. לכן המפתח לא מופיע בקוד." },
    { c: "response = client.responses.create(", s: 2, t: "כותבים מכתב ושולחים", x: "create אומר \"צור בקשה ושלח\". כאן נפתח המכתב: עוד רגע נכתוב בו מה לשאול ומי יענה. מה שיחזור יישמר בתוך response. הסוגר נשאר פתוח, כי המכתב עוד לא גמור." },
    { c: ''    model="gpt-4o-mini",'', s: 3, t: "בוחרים למי כותבים", x: "איזה \"מוח\" יענה. gpt-4o-mini הוא מודל קטן, מהיר וזול, ומספיק בהחלט בשבילנו. שמות מודלים מתעדכנים עם הזמן, ולכן אם יש שגיאה על המודל, בדקו את הרשימה העדכנית של OpenAI." },
    { c: [''    input="'', { he: "מה זה API? ענה בעברית, בשני משפטים" }, ''",''], s: 4, t: "כותבים את השאלה", x: "הטקסט שנשלח למודל. זה החלק שתשנו הכי הרבה. הוא בתוך מרכאות, כי בפייתון כך מסמנים טקסט. ביקשנו במפורש \"ענה בעברית\": המודל בדרך כלל עונה בשפת השאלה, אבל בקשה מפורשת מבטיחה את זה." },
    { c: ")", s: 2, t: "סוגרים את המעטפה", x: "הסוגר הזה סוגר את create. שורות 3 עד 6 יחד הן פקודה אחת: \"שלח למודל הזה את השאלה הזו, ושמור את התשובה ב-response\"." },
    { c: "print(response.output_text)", s: 5, t: "קוראים את התשובה", x: "response הוא החבילה שחזרה, ו-output_text הוא הטקסט שבתוכה. print מציג אותו בטרמינל." }
  ];
  var stBox = $("stations"), list = $("cl-list"), txt = $("anat-text");
  var stEls = [], btns = [];
  stations.forEach(function (s) {
    var d = el("div", "st"); d.style.setProperty("--stc", s.c);
    d.appendChild(el("div", "bd", s.e)); d.appendChild(el("div", "nl", s.n));
    stBox.appendChild(d); stEls.push(d);
  });
  function pick(i) {
    var l = lines[i];
    btns.forEach(function (b, j) { b.classList.toggle("on", j === i); });
    stEls.forEach(function (d, j) { d.classList.toggle("on", j === l.s); });
    txt.innerHTML = "";
    var h = el("h4", "", "שורה " + (i + 1) + " · " + l.t);
    h.style.color = stations[l.s].c;
    txt.appendChild(h); txt.appendChild(el("p", "", l.x));
  }
  lines.forEach(function (l, i) {
    var b = el("button", "cl"); b.type = "button";
    b.style.setProperty("--stc", stations[l.s].c);
    b.appendChild(el("span", "ln", String(i + 1)));
    var code = el("span", "");
    (Array.isArray(l.c) ? l.c : [l.c]).forEach(function (part) {
      if (typeof part === "string") code.appendChild(document.createTextNode(part));
      else code.appendChild(el("span", "he", part.he));
    });
    b.appendChild(code);
    b.addEventListener("click", function () { pick(i); });
    list.appendChild(b); btns.push(b);
  });
  pick(0);
})();

/* ---------- gifts ---------- */
(function () {
  document.querySelectorAll(".gift").forEach(function (g) {
    g.addEventListener("click", function () {
      var open = g.classList.toggle("open");
      g.querySelector(".front small").textContent = open ? "לחצו לסגירה" : "לחצו לפתיחה";
    });
  });
})();

/* ---------- quiz ---------- */
(function () {
  var qs = [
    { q: "הקוד שלנו הוא client = OpenAI(), בלי שום מפתח. איך הספרייה יודעת באיזה מפתח להשתמש?", opts: ["היא מנחשת", "היא קוראת אותו ממשתנה הסביבה OPENAI_API_KEY במחשב", "המפתח מוטבע בספרייה בהתקנה"], ok: 1, why: "זו בדיוק הסיבה שהגדרנו את המשתנה בשיעור 1: הקוד נשאר נקי, והמפתח נשאר אצלנו במחשב." },
    { q: "הרצתם את אותה תוכנית פעמיים וקיבלתם שתי תשובות עם ניסוח שונה. מה קרה?", opts: ["יש באג בקוד", "המודל בונה את התשובה בכל פעם מחדש, ובכל מילה בוחר מתוך כמה אפשרויות", "OpenAI שינתה את המודל באמצע"], ok: 1, why: "בכל מילה יש כמה המשכים סבירים, והמודל בוחר אחד מהם. זו התנהגות רגילה ולא תקלה." },
    { q: "איזה חלק מהחבילה response מכיל את טקסט התשובה?", opts: ["response.usage", "response.output_text", "response.model"], ok: 1, why: "usage מדווח על הטוקנים, ו-model אומר איזה מודל ענה. הטקסט נמצא ב-output_text." },
    { q: "הרצתם והופיעה השגיאה ModuleNotFoundError: No module named ''openai''. מה עושים?", opts: ["יוצרים מפתח API חדש", "מריצים בטרמינל python -m pip install openai", "מוחקים את הקובץ וכותבים אותו מחדש"], ok: 1, why: "השגיאה אומרת שהספרייה לא מותקנת. התקנה פותרת את זה, ואין קשר למפתח או לקוד." }
  ];
  var host = $("quiz-container");
  var answered = 0, right = 0;
  qs.forEach(function (item, i) {
    var card = el("div", "quiz-card");
    card.appendChild(el("p", "", (i + 1) + ". " + item.q));
    var choices = el("div", "choices"); var fb = el("div", "fb");
    card.appendChild(choices); card.appendChild(fb);
    item.opts.forEach(function (o, j) {
      var b = el("button", "choice", o); b.type = "button";
      b.addEventListener("click", function () {
        var all = choices.querySelectorAll(".choice");
        all.forEach(function (x) { x.disabled = true; });
        answered++;
        if (j === item.ok) { right++; b.classList.add("right"); fb.textContent = "נכון! " + item.why; fb.className = "fb correct"; }
        else { b.classList.add("wrong"); all[item.ok].classList.add("right"); fb.textContent = "לא בדיוק. " + item.why; fb.className = "fb wrong"; }
        if (answered === qs.length) {
          $("score-box").textContent = right === qs.length ? "🏆 " + right + " מתוך " + qs.length + ". מושלם!" : right + " מתוך " + qs.length + ". כדאי לחזור לחלקים שלא היו ברורים.";
        }
      });
      choices.appendChild(b);
    });
    host.appendChild(card);
  });
})();

/* ---------- mission ---------- */
(function () {
  var boxes = document.querySelectorAll("#mission-list input");
  function upd() {
    var n = 0;
    boxes.forEach(function (b) { if (b.checked) n++; });
    $("mission-done").textContent = n === boxes.length ? "🎉 מעולה! נתראה בשיעור 3, ונלמד את הבוט לזכור." : (n ? n + " מתוך " + boxes.length + " הושלמו" : "");
  }
  boxes.forEach(function (b) { b.addEventListener("change", upd); });
})();
</script>

</body>
</html>
' WHERE course_id='ai-app-dev' AND slug='lesson-2-first-call';
UPDATE lessons SET html_content = '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 4 — אישיות והנחיות</title>
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
  --code-head: #2D2A72;
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
p code, li code, summary code {
  font-size: .86em; background: var(--cyan-soft); color: #3F4FE0; border-radius: 8px; padding: 2px 8px;
  direction: ltr; unicode-bidi: embed;
}
button { font-family: var(--sans); cursor: pointer; }
button:focus-visible, a:focus-visible, input:focus-visible, summary:focus-visible { outline: 3px solid rgba(91,108,255,.45); outline-offset: 3px; }

section { padding: clamp(60px, 7vw, 108px) 0; }
section:nth-of-type(even) { background: rgba(255,255,255,.55); }
.eyebrow { display: inline-block; font-family: var(--sans); font-weight: 700; font-size: 14px; letter-spacing: .02em; color: var(--ink-dim); background: rgba(255,255,255,.8); border-radius: 100px; padding: 4px 16px; margin-bottom: 14px; box-shadow: var(--shadow-sm); direction: rtl; }
.eyebrow.c { color: #3F4FE0; background: var(--cyan-soft); box-shadow: none; }
.eyebrow.v { color: #E0553F; background: var(--violet-soft); box-shadow: none; }
h2.section-title { font-size: clamp(1.9rem, 3.6vw, 2.9rem); line-height: 1.22; }
.lede { font-size: clamp(18px, 1.5vw, 20px); margin-top: 14px; max-width: 62ch; }

/* top bars */
.scroll-progress { position: fixed; top: 0; inset-inline: 0; height: 4px; z-index: 50; }
.scroll-progress i { display: block; height: 100%; width: 0; background: linear-gradient(90deg, var(--cyan), var(--cyan-2), var(--violet)); border-radius: 0 4px 4px 0; }
.topbar { background: rgba(255,255,255,.75); backdrop-filter: blur(14px); border-bottom: 1px solid var(--line); padding: 14px 0; position: sticky; top: 0; z-index: 40; }
.topbar-inner { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; font-size: 15px; }
.topbar .course { font-family: var(--display); font-weight: 600; color: var(--ink); }
.topbar .lesson-chip { font-weight: 700; font-size: 13.5px; color: #fff; background: linear-gradient(135deg, var(--cyan), var(--cyan-2)); border-radius: 100px; padding: 4px 16px; }

/* hero */
.hero { position: relative; padding: clamp(48px, 7vw, 100px) 0 clamp(40px, 5vw, 72px); text-align: center; }
.hero h1 { font-size: clamp(2.4rem, 5.4vw, 4.4rem); line-height: 1.12; font-weight: 800; }
.hero h1 .a1 { background: linear-gradient(90deg, var(--cyan), var(--cyan-2)); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero h1 .a2 { background: linear-gradient(90deg, var(--violet), #FFA06B); -webkit-background-clip: text; background-clip: text; color: transparent; }
.hero-sub { margin: 20px auto 0; font-size: clamp(18px, 1.6vw, 21px); max-width: 52ch; }
.time-row { margin-top: 26px; display: flex; gap: 10px; flex-wrap: wrap; justify-content: center; }
.pill { font-size: 14.5px; font-weight: 600; color: var(--ink-dim); background: rgba(255,255,255,.85); border-radius: 100px; padding: 6px 16px; box-shadow: var(--shadow-sm); }

.scene { direction: ltr; margin: 44px auto 0; max-width: 600px; display: grid; grid-template-columns: 96px 1fr 96px; align-items: center; gap: 8px; background: var(--bg-panel); border-radius: 30px; box-shadow: var(--shadow); border: 1px solid rgba(91,108,255,.08); padding: 28px 20px 20px; }
.sc-node { text-align: center; }
.sc-node .big { font-size: 46px; line-height: 1.1; display: block; }
.sc-node span.lbl { font-size: 13px; font-weight: 700; color: var(--ink-dim); display: block; margin-top: 4px; direction: rtl; }
.sc-brain { animation: think 6s infinite; }
@keyframes think { 0%, 42% { transform: scale(1); filter: none; } 50% { transform: scale(1.18); filter: drop-shadow(0 0 14px rgba(139,107,255,.8)); } 58%, 100% { transform: scale(1); filter: none; } }
.sc-track { position: relative; height: 60px; }
.sc-track::before { content: ""; position: absolute; inset-inline: 0; top: 50%; border-top: 3px dotted var(--line-strong); }
.mail { position: absolute; top: 50%; font-size: 30px; margin-top: -20px; opacity: 0; }
.mail.go { animation: go 6s infinite; }
.mail.back { animation: back 6s infinite; }
@keyframes go { 0% { left: 0; opacity: 0; } 4% { opacity: 1; } 40% { left: calc(100% - 30px); opacity: 1; } 46%, 100% { left: calc(100% - 30px); opacity: 0; } }
@keyframes back { 0%, 54% { left: calc(100% - 30px); opacity: 0; } 58% { opacity: 1; } 94% { left: 0; opacity: 1; } 100% { left: 0; opacity: 0; } }
.scene-caption { grid-column: 1 / -1; direction: rtl; text-align: center; font-size: 15px; color: var(--ink-dim); margin-top: 14px; }

/* today tiles */
.tiles3 { margin-top: 28px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; }
@media (max-width: 700px) { .tiles3 { grid-template-columns: minmax(0, 1fr); } }
.tile { background: #fff; border-radius: 22px; padding: 22px 20px; box-shadow: var(--shadow-sm); text-align: center; }
.tile .em { font-size: 36px; line-height: 1.2; }
.tile h4 { font-size: 17px; margin: 8px 0 4px; }
.tile p { font-size: 15px; line-height: 1.6; }

/* shared */
.callout { margin-top: 20px; border-radius: 20px; padding: 16px 20px; font-size: 16px; display: flex; gap: 14px; align-items: flex-start; border: 1px solid; text-align: start; }
.callout .ico { font-size: 22px; line-height: 1.5; }
.callout p { color: var(--ink); }
.callout.warn { background: var(--warn-soft); border-color: rgba(217,138,0,.22); }
.callout.danger { background: var(--danger-soft); border-color: rgba(229,72,106,.22); }
.callout.info { background: var(--cyan-soft); border-color: rgba(91,108,255,.2); }
.callout.ok { background: var(--success-soft); border-color: rgba(31,185,133,.25); }

.code-card { background: var(--code-bg); border-radius: 20px; overflow: hidden; margin-top: 16px; box-shadow: 0 14px 34px -16px rgba(34,31,85,.55); }
.code-card-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 9px 16px; background: var(--code-head); font-size: 13.5px; font-weight: 700; color: #B9B6E8; }
.copy-btn { font-size: 13px; font-weight: 700; color: #fff; background: rgba(255,255,255,.14); border: none; border-radius: 100px; padding: 4px 14px; transition: background .15s; }
.copy-btn:hover { background: rgba(255,255,255,.26); }
.code-card pre { direction: ltr; text-align: left; margin: 0; padding: 16px 20px 18px; overflow-x: auto; font-family: var(--mono); font-size: 14.5px; line-height: 1.8; color: var(--code-ink); }
.code-card pre.he-out { direction: rtl; text-align: right; font-family: var(--sans); font-size: 16.5px; line-height: 1.7; white-space: pre-wrap; }
.term .out { color: #B9B6E8; }
.he { direction: rtl; unicode-bidi: isolate; }
.k { color: #C4A7FF; } .s { color: #9BE8B5; } .f { color: #8FB4FF; } .cm { color: #8C89C4; font-style: italic; }

.btn { font-family: var(--display); font-weight: 600; font-size: 16px; color: #fff; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); border: none; border-radius: 100px; padding: 12px 28px; box-shadow: 0 12px 26px -12px rgba(91,108,255,.8); transition: transform .18s, box-shadow .18s, opacity .18s; }
.btn:hover:not(:disabled) { transform: translateY(-2px); box-shadow: 0 16px 30px -12px rgba(91,108,255,.9); }
.btn:disabled { opacity: .4; cursor: not-allowed; box-shadow: none; }
.btn.ghost { background: #fff; color: var(--ink); box-shadow: var(--shadow-sm); }

/* quest */
.quest { margin-top: 30px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 26px 26px 20px; }
.quest-track { position: relative; height: 54px; margin: 0 22px; }
.quest-line { position: absolute; top: 34px; inset-inline: 0; height: 6px; border-radius: 6px; background: var(--bg-panel-2); }
.quest-line i { display: block; height: 100%; width: 0; border-radius: 6px; background: linear-gradient(90deg, #34D6A0, #1FB985); transition: width .5s ease; }
.quest-stop { position: absolute; top: 24px; width: 26px; height: 26px; margin-right: -13px; border-radius: 50%; background: #fff; border: 3px solid var(--line-strong); transition: all .3s; }
.quest-stop.on { background: var(--success); border-color: var(--success); }
.rocket { position: absolute; top: -2px; font-size: 30px; margin-right: -16px; transition: right .5s ease; }
.quest-labels { display: flex; justify-content: space-between; margin: 6px 0 0; font-size: 13.5px; font-weight: 700; color: var(--ink-dim); direction: rtl; }
.quest-count { margin-top: 10px; text-align: center; font-size: 15px; font-weight: 700; color: var(--ink-dim); direction: rtl; }

.steps { margin-top: 24px; display: grid; grid-template-columns: minmax(0, 1fr); gap: 22px; }
.step-card { background: #fff; border-radius: var(--radius); padding: 26px 28px; box-shadow: var(--shadow); border: 2px solid transparent; transition: border-color .25s; min-width: 0; }
.step-card.done { border-color: rgba(31,185,133,.55); }
.step-head { display: flex; align-items: center; gap: 14px; }
.step-ico { width: 48px; height: 48px; border-radius: 16px; background: var(--bg-panel-2); display: flex; align-items: center; justify-content: center; font-size: 24px; flex-shrink: 0; }
.step-head h3 { font-size: 20px; flex: 1; }
.check { display: flex; align-items: center; gap: 8px; font-size: 14.5px; font-weight: 700; color: var(--ink-dim); cursor: pointer; flex-shrink: 0; background: var(--bg-panel-2); border-radius: 100px; padding: 5px 14px 5px 12px; }
.check input { width: 20px; height: 20px; accent-color: var(--success); cursor: pointer; }
.step-body { margin-top: 16px; }
.step-body > p { font-size: 16.5px; }
.step-body ol.plain { margin: 8px 0 0; padding-inline-start: 24px; color: var(--ink-dim); font-size: 16.5px; }
.step-body ol.plain li { margin-bottom: 5px; }

/* anatomy */
.anat { margin-top: 28px; background: #fff; border-radius: var(--radius); box-shadow: var(--shadow); padding: 28px 24px 22px; }
.stations { display: grid; grid-template-columns: repeat(6, minmax(0, 1fr)); gap: 6px; margin-bottom: 20px; }
@media (max-width: 560px) { .stations { grid-template-columns: repeat(3, minmax(0, 1fr)); } }
.st { text-align: center; opacity: .5; transition: opacity .25s, transform .25s; }
.st .bd { width: 58px; height: 58px; margin: 0 auto 6px; border-radius: 20px; background: var(--bg-panel-2); border: 2px solid transparent; display: flex; align-items: center; justify-content: center; font-size: 26px; transition: all .25s; }
.st .nl { font-size: 13px; font-weight: 700; color: var(--ink-dim); direction: rtl; }
.st.on { opacity: 1; transform: translateY(-3px); }
.st.on .bd { border-color: var(--stc); background: #fff; box-shadow: 0 12px 26px -10px var(--stc); }
.st.on .nl { color: var(--stc); }
.cl-list { direction: ltr; display: grid; gap: 5px; }
.cl { text-align: left; background: var(--code-bg); border: 1px solid transparent; border-inline-start: 5px solid var(--stc); border-radius: 10px; padding: 5px 14px; font-family: var(--mono); font-size: 14px; line-height: 1.7; color: var(--code-ink); white-space: pre; overflow-x: auto; display: flex; gap: 14px; transition: all .15s; }
.cl .ln { color: #8C89C4; user-select: none; min-width: 1ch; }
.cl:hover { background: var(--code-head); }
.cl.on { border-color: var(--stc); background: var(--code-head); box-shadow: 0 10px 22px -12px var(--stc); }
.anat-text { margin-top: 18px; min-height: 100px; direction: rtl; }
.anat-text h4 { font-size: 18px; margin-bottom: 4px; }
.anat-text p { font-size: 16.5px; color: var(--ink); }

/* gifts */
.present { margin-top: 28px; text-align: center; }
.present .top { font-size: 16px; color: var(--ink-dim); }
.present .top code { font-size: 1em; }
.gifts { margin-top: 14px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; text-align: start; align-items: start; }
@media (max-width: 700px) { .gifts { grid-template-columns: minmax(0, 1fr); } }
.gift { background: #fff; border: 2px solid transparent; border-radius: 22px; box-shadow: var(--shadow-sm); padding: 0; color: var(--ink); text-align: center; overflow: hidden; display: block; width: 100%; transition: transform .2s, box-shadow .2s, border-color .2s; }
.gift:hover { transform: translateY(-3px); box-shadow: var(--shadow); }
.gift .front { padding: 24px 12px; }
.gift .front .em { font-size: 42px; line-height: 1.2; display: block; }
.gift .front b { font-family: var(--display); font-size: 17px; display: block; margin-top: 6px; }
.gift .front small { font-size: 13.5px; color: var(--ink-faint); display: block; }
.gift .back { display: none; padding: 16px 18px 20px; text-align: start; font-size: 15.5px; line-height: 1.6; color: var(--ink); border-top: 1px dashed var(--line-strong); }
.gift.open { border-color: var(--cyan); background: linear-gradient(135deg, var(--cyan-soft), #fff); }
.gift.open .back { display: block; }
.gift code { direction: ltr; unicode-bidi: embed; font-family: var(--mono); font-size: .86em; color: #3F4FE0; background: var(--cyan-soft); border-radius: 8px; padding: 2px 8px; }
.tokbar { direction: ltr; display: flex; height: 28px; border-radius: 10px; overflow: hidden; margin: 10px 0 6px; font-family: var(--mono); font-size: 12.5px; font-weight: 700; color: #fff; }
.tokbar span { display: flex; align-items: center; justify-content: center; }
.tokbar .tin { background: linear-gradient(135deg, #6C7BFF, #8B6BFF); flex: 17; }
.tokbar .tout { background: linear-gradient(135deg, #FF7B6B, #FFA06B); flex: 24; }

/* experiments */
.exps { margin-top: 26px; display: grid; gap: 16px; }
.exp { background: #fff; border-radius: 24px; box-shadow: var(--shadow-sm); padding: 20px 24px; display: grid; grid-template-columns: 48px minmax(0, 1fr); gap: 16px; align-items: start; }
.exp .em { font-size: 36px; line-height: 1.3; }
.exp h4 { font-size: 18px; }
.exp > div > p { font-size: 16.5px; margin-top: 2px; }
.exp .code-card { margin-top: 12px; }
.exp .code-card pre { padding: 13px 18px; font-size: 14px; }

/* quiz */
.choices { display: grid; gap: 10px; }
.choice { text-align: start; background: #fff; border: 1.5px solid var(--line); color: var(--ink); border-radius: 16px; padding: 12px 18px; font-size: 16px; transition: all .15s; box-shadow: var(--shadow-sm); }
.choice:hover:not(:disabled) { border-color: var(--cyan); transform: translateY(-1px); }
.choice.right { border-color: var(--success); background: var(--success-soft); }
.choice.wrong { border-color: var(--danger); background: var(--danger-soft); }
.choice:disabled { cursor: default; }
.fb { margin-top: 12px; font-size: 15.5px; font-weight: 700; min-height: 22px; }
.fb.correct { color: var(--success); } .fb.wrong { color: var(--danger); }
#quiz-container { margin-top: 28px; display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 22px; align-items: start; }
@media (max-width: 900px) { #quiz-container { grid-template-columns: minmax(0, 1fr); } }
.quiz-card { background: #fff; border-radius: 26px; padding: 24px 26px; box-shadow: var(--shadow); }
.quiz-card > p { color: var(--ink); font-weight: 700; font-size: 17.5px; margin-bottom: 14px; }
.score-box { margin-top: 26px; font-family: var(--display); font-weight: 700; font-size: 22px; color: #3F4FE0; }

/* mission */
.mission { margin-top: 30px; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); border-radius: var(--radius); padding: 32px 34px; box-shadow: 0 24px 50px -22px rgba(91,108,255,.75); }
.mission h3 { font-size: 24px; color: #fff; }
.mission ul { list-style: none; padding: 0; margin: 20px 0 0; display: grid; gap: 14px; }
.mission li label { display: flex; gap: 14px; align-items: flex-start; color: #fff; font-size: 17.5px; cursor: pointer; }
.mission li input { width: 22px; height: 22px; margin-top: 4px; accent-color: #1FB985; flex-shrink: 0; }
.mission li input:checked + span { opacity: .65; text-decoration: line-through; }
.mission li code { background: rgba(255,255,255,.2); color: #fff; padding: 2px 8px; border-radius: 8px; font-size: .86em; direction: ltr; unicode-bidi: embed; }
.mission-done { margin-top: 20px; font-weight: 700; font-family: var(--display); color: #fff; min-height: 26px; }
.next-card { margin-top: 24px; background: #fff; border-radius: var(--radius); padding: 26px 30px; box-shadow: var(--shadow); }
.next-card .eyebrow { margin-bottom: 8px; }
.next-card h3 { font-size: 22px; }

footer { padding: 56px 0 84px; text-align: center; color: var(--ink-faint); font-size: 14.5px; }
[hidden] { display: none !important; }

/* ===== lesson 4 ===== */
.masks { margin-top: 30px; font-size: 44px; letter-spacing: 10px; }
.hl-line { display: inline-block; background: rgba(255,184,77,.24); border-radius: 4px; margin: 0 -4px; padding: 0 4px; }
.tile .eg { margin-top: 8px; font-size: 14px; font-weight: 700; color: #3F4FE0; }

.personas { display: flex; gap: 8px; padding: 14px 20px; background: linear-gradient(90deg, var(--cyan-soft), #fff); flex-wrap: wrap; }
.persona-btn { font-size: 14.5px; font-weight: 700; padding: 7px 18px; border-radius: 100px; border: none; background: #fff; color: var(--ink-dim); box-shadow: var(--shadow-sm); transition: all .15s; }
.persona-btn:hover { transform: translateY(-1px); }
.persona-btn.active { background: linear-gradient(135deg, #6C7BFF, #8B6BFF); color: #fff; }
.demo-body { padding: 22px; display: grid; gap: 12px; }
.note { background: var(--warn-soft); border: 1px solid rgba(217,138,0,.22); border-radius: 18px; padding: 12px 18px; font-size: 16px; color: var(--ink); }
.note b { display: block; font-size: 13px; color: var(--warn); margin-bottom: 2px; font-family: var(--display); }
.bubble.user { justify-self: start; background: linear-gradient(135deg, #6C7BFF, #8B6BFF); color: #fff; border-end-start-radius: 6px; }
.bubble.bot { justify-self: end; background: var(--bg-panel-2); color: var(--ink); border-end-end-radius: 6px; }
.demo-note { padding: 10px 22px 14px; font-size: 13.5px; color: var(--ink-faint); background: var(--bg-panel-2); }
.bubble { max-width: 86%; padding: 11px 18px; border-radius: 22px; font-size: 16.5px; line-height: 1.6; animation: pop .25s ease; }
@keyframes pop { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }
.demo { margin-top: 28px; background: #fff; border-radius: 30px; box-shadow: var(--shadow); overflow: hidden; border: 1px solid rgba(91,108,255,.08); }

.temp { margin-top: 28px; max-width: 820px; margin-inline: auto; background: #fff; border-radius: 30px; box-shadow: var(--shadow); border: 1px solid rgba(91,108,255,.08); padding: 28px 26px 22px; }
.temp-q { text-align: center; font-size: 16px; color: var(--ink-dim); }
.temp-q b { color: var(--ink); }
.thermo { direction: ltr; margin: 20px 0 8px; display: grid; grid-template-columns: 34px 1fr 34px; gap: 12px; align-items: center; font-size: 26px; text-align: center; }
.thermo input { width: 100%; height: 12px; border-radius: 8px; -webkit-appearance: none; appearance: none; background: linear-gradient(90deg, #6CC8FF, #FFB84D, #FF6B6B); outline-offset: 6px; }
.thermo input::-webkit-slider-thumb { -webkit-appearance: none; width: 28px; height: 28px; border-radius: 50%; background: #fff; border: 4px solid var(--cyan); box-shadow: var(--shadow-sm); cursor: pointer; }
.thermo input::-moz-range-thumb { width: 22px; height: 22px; border-radius: 50%; background: #fff; border: 4px solid var(--cyan); cursor: pointer; }
.temp-val { text-align: center; font-family: var(--mono); font-size: 15px; font-weight: 600; color: #3F4FE0; direction: ltr; }
.runs { margin-top: 18px; display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
.run { background: var(--bg-panel-2); border-radius: 16px; padding: 12px 6px; text-align: center; }
.run small { display: block; font-size: 12.5px; color: var(--ink-faint); }
.run b { font-family: var(--display); font-size: 18px; color: var(--ink); }
.temp-desc { margin-top: 16px; text-align: center; font-size: 16.5px; color: var(--ink); min-height: 52px; }
.temp-note { margin-top: 8px; font-size: 13.5px; color: var(--ink-faint); text-align: center; }

/* link to the prompts course */
.plink { color: #E0553F; font-weight: 700; text-decoration: underline; text-underline-offset: 3px; }
.plink:hover { text-decoration-thickness: 2px; }
</style>
</head>
<body>

<div class="scroll-progress" aria-hidden="true"><i id="scroll-bar"></i></div>

<div class="topbar">
  <div class="wrap topbar-inner">
    <span class="course">בונים אפליקציית AI עם OpenAI ו-Python</span>
    <span class="lesson-chip">שיעור 4</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap">
    <div class="eyebrow c" style="text-align:center;">שיעור 4 · אישיות והנחיות</div>
    <h1>הבוט שלכם יכול להיות <span class="a1">כל מי</span><br>שתרצו, ו<span class="a2">גם לשלוט</span> בו</h1>
    <p class="hero-sub">בשיעור 3 הבוט למד לזכור. היום נלמד אותו מי הוא, ואיך לשלוט בכמה הוא יצירתי.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-25 דקות</span>
      <span class="pill">🎭 אישיות</span>
      <span class="pill">🌡️ יצירתיות</span>
    </div>
    <div class="masks" aria-hidden="true">💪 👨‍🍳 🕵️ 👽</div>
  </div>
</header>

<main>

  <!-- ================= PERSONA ================= -->
  <section id="persona">
    <div class="wrap">
      <div class="eyebrow">הרעיון</div>
      <h2 class="section-title">פתק אחד משנה את הבוט כולו</h2>
      <p class="lede">לפני השיחה אפשר לתת למודל <strong style="color:var(--ink)">הנחיות</strong>: פתק קצר שאומר לו מי הוא ואיך לענות. אותה שאלה, והנחיות שונות. בחרו דמות:</p>

      <div class="demo">
        <div class="personas" id="personas"></div>
        <div class="demo-body">
          <div class="note" id="note"></div>
          <div class="bubble user">מה כדאי לי לאכול לארוחת בוקר?</div>
          <div class="bubble bot" id="answer"></div>
        </div>
        <div class="demo-note">* המחשה בלבד. התשובות האמיתיות יהיו קצת שונות.</div>
      </div>
    </div>
  </section>

  <!-- ================= BUILD ================= -->
  <section id="build">
    <div class="wrap">
      <div class="eyebrow c">בונים</div>
      <h2 class="section-title">שורה אחת, ואישיות חדשה</h2>

      <div class="steps">

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">✍️</div><h3>1 · מוסיפים הנחיות וטמפרטורה</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>פתחו את <code>chat.py</code> משיעור 3 והחליפו את כל התוכן בקוד הבא. השורות החדשות מסומנות, והן בתוך הפנייה למודל, עם שמונה רווחים בהתחלה:</p>
            <div class="code-card">
              <div class="code-card-head"><span>chat.py</span><button class="copy-btn" type="button">העתק</button></div>
<pre><span class="k">from</span> openai <span class="k">import</span> OpenAI
client = <span class="f">OpenAI</span>()
history = []
<span class="k">while</span> <span class="k">True</span>:
    text = <span class="f">input</span>(<span class="s">"You: "</span>)
    <span class="k">if</span> text == <span class="s">"exit"</span>:
        <span class="k">break</span>
    history.<span class="f">append</span>({<span class="s">"role"</span>: <span class="s">"user"</span>, <span class="s">"content"</span>: text})
    response = client.responses.<span class="f">create</span>(
        model=<span class="s">"gpt-4o-mini"</span>,
<span class="hl-line">        instructions=<span class="s">"<span class="he">אתה מאמן כושר אנרגטי ומעודד. ענה בעברית, בקצרה.</span>"</span>,</span>
<span class="hl-line">        temperature=<span class="s">0.7</span>,</span>
        input=history,
    )
    answer = response.output_text
    history.<span class="f">append</span>({<span class="s">"role"</span>: <span class="s">"assistant"</span>, <span class="s">"content"</span>: answer})
    <span class="f">print</span>(<span class="s">"Bot:"</span>, answer)</pre>
            </div>
          </div>
        </div>

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">🎭</div><h3>2 · מריצים ומחליפים דמות</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <div class="code-card">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python chat.py</pre>
            </div>
            <p style="margin-top:12px;">שאלו משהו ושימו לב איך הוא עונה. אחר כך עצרו (<code>exit</code>), החליפו את הטקסט שבתוך <code>instructions</code> לדמות אחרת, והריצו שוב.</p>
            <div class="callout ok">
              <span class="ico">🎉</span>
              <p>ההנחיות לא נשמרות ברשימה <code>history</code>. הן נשלחות מחדש בכל פנייה, ולכן הבוט לא "שוכח" מי הוא.</p>
            </div>
          </div>
        </div>

      </div>

      <div class="callout info">
        <span class="ico">💡</span>
        <p>קיבלתם שגיאה? העתיקו אותה ושאלו את ChatGPT מה לתקן (בלי המפתח!).</p>
      </div>
    </div>
  </section>

  <!-- ================= RECIPE ================= -->
  <section id="recipe">
    <div class="wrap">
      <div class="eyebrow v">איך כותבים</div>
      <h2 class="section-title">שלושה דברים בהנחיה טובה</h2>
      <div class="tiles3">
        <div class="tile"><div class="em">🎭</div><h4>מי אתה</h4><p>התפקיד והאישיות</p><div class="eg">"אתה מאמן כושר"</div></div>
        <div class="tile"><div class="em">✏️</div><h4>איך לענות</h4><p>סגנון, אורך ושפה</p><div class="eg">"בקצרה, בעברית"</div></div>
        <div class="tile"><div class="em">🚫</div><h4>מה לא</h4><p>גבולות ברורים</p><div class="eg">"אל תמציא עובדות"</div></div>
      </div>
      <div class="callout info">
        <span class="ico">💡</span>
        <p>הנחיה ברורה וקצרה עובדת יותר טוב מהנחיה ארוכה ומבולבלת.</p>
      </div>
      <div class="callout ok">
        <span class="ico">📚</span>
        <p><strong>רוצים ללמוד לכתוב פרומפטים בצורה מדויקת, טובה ומקצועית יותר?</strong> יש באתר <a class="plink" href="/courses/prompts" target="_top">קורס פרומפטים</a> נפרד, שמוקדש לנושא הזה בלבד.</p>
      </div>
    </div>
  </section>

  <!-- ================= TEMPERATURE ================= -->
  <section id="temperature">
    <div class="wrap">
      <div class="eyebrow c">יצירתיות</div>
      <h2 class="section-title">מד חום: כמה הוא מעז?</h2>
      <p class="lede">זוכרים שכל תשובה יוצאת קצת שונה? הפרמטר <code>temperature</code> שולט בזה. הזיזו את המחוג:</p>

      <div class="temp">
        <div class="temp-q">השאלה: <b>"תן לי שם אחד לחתול"</b>, שלוש הרצות</div>
        <div class="thermo">
          <span>🧊</span>
          <input id="temp-range" type="range" min="0" max="20" step="1" value="7" aria-label="temperature">
          <span>🔥</span>
        </div>
        <div class="temp-val" id="temp-val"></div>
        <div class="runs" id="runs"></div>
        <div class="temp-desc" id="temp-desc"></div>
        <div class="temp-note">* המחשה מפושטת. הערכים נעים בין 0 ל-2.</div>
      </div>

      <div class="callout warn">
        <span class="ico">⚠️</span>
        <p>חלק מהמודלים החדשים לא תומכים בפרמטר <code>temperature</code>, ואז תקבלו שגיאה. אם זה קרה, פשוט מחקו את השורה.</p>
      </div>
    </div>
  </section>

  <!-- ================= EXPERIMENTS ================= -->
  <section id="experiments">
    <div class="wrap">
      <div class="eyebrow v">משחקים</div>
      <h2 class="section-title">שני ניסויים</h2>
      <div class="exps">
        <div class="exp">
          <div class="em">🏴‍☠️</div>
          <div>
            <h4>המציאו דמות</h4>
            <p>כתבו ב-<code>instructions</code> דמות משלכם: שף, פיראט, סבתא, בלש. שאלו אותה את אותה שאלה כמה פעמים.</p>
          </div>
        </div>
        <div class="exp">
          <div class="em">🌡️</div>
          <div>
            <h4>קרח מול אש</h4>
            <p>שאלו "תן לי שם אחד לחתול" עם <code>temperature=0</code>, ואז עם <code>temperature=1.8</code>. הריצו כל אחד כמה פעמים והשוו.</p>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= QUIZ ================= -->
  <section id="quiz">
    <div class="wrap">
      <div class="eyebrow">בדיקה מהירה</div>
      <h2 class="section-title">שלוש שאלות</h2>
      <div id="quiz-container"></div>
      <div class="score-box" id="score-box"></div>
    </div>
  </section>

  <!-- ================= MISSION ================= -->
  <section id="mission">
    <div class="wrap">
      <div class="eyebrow c">המשימה שלכם</div>
      <h2 class="section-title">לפני שהשיעור הבא מתחיל</h2>

      <div class="mission">
        <h3>🎯 שלוש משימות</h3>
        <ul id="mission-list">
          <li><label><input type="checkbox"><span>הרצתי את <code>chat.py</code> והבוט ענה בדמות שהגדרתי</span></label></li>
          <li><label><input type="checkbox"><span>המצאתי דמות חדשה והשוויתי את הסגנון</span></label></li>
          <li><label><input type="checkbox"><span>ניסיתי <code>temperature</code> נמוך וגבוה וראיתי את ההבדל</span></label></li>
        </ul>
        <div class="mission-done" id="mission-done"></div>
      </div>

      <div class="next-card">
        <div class="eyebrow">בשיעור הבא · שיעור 5</div>
        <h3>פלט מסודר</h3>
        <p style="margin-top:6px;">עד עכשיו הבוט החזיר טקסט חופשי. בשיעור הבא נבקש ממנו תשובה במבנה קבוע (JSON), כדי שהקוד שלנו יוכל להשתמש בה.</p>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">בונים אפליקציית AI עם OpenAI ו-Python · שיעור 4</div></footer>

<script>
function $(id) { return document.getElementById(id); }
function el(tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text) e.textContent = text; return e; }

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

/* ---------- copy buttons ---------- */
(function () {
  document.querySelectorAll(".copy-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var text = btn.closest(".code-card").querySelector("pre").textContent.trim();
      var original = btn.textContent;
      function done(ok) {
        btn.textContent = ok ? "הועתק ✓" : "סמנו והעתיקו ידנית";
        setTimeout(function () { btn.textContent = original; }, 1600);
      }
      try { navigator.clipboard.writeText(text).then(function () { done(true); }, function () { done(false); }); }
      catch (e) { done(false); }
    });
  });
})();

/* ---------- step checklist ---------- */
(function () {
  document.querySelectorAll(".step-check").forEach(function (c) {
    c.addEventListener("change", function () { c.closest(".step-card").classList.toggle("done", c.checked); });
  });
})();

/* ---------- persona demo ---------- */
(function () {
  var people = [
    { e: "💪", n: "מאמן כושר", i: "אתה מאמן כושר אנרגטי ומעודד. ענה בעברית, בקצרה, עם דגש על אנרגיה ובריאות.", a: "קדימה, אלוף! 💪 ביצים, פרוסת לחם מלא וקערת פירות. חלבון ופחמימות לבוקר חזק. ואחרי זה? הולכים להזיע!" },
    { e: "👨‍🍳", n: "שף איטלקי", i: "אתה שף איטלקי נלהב ודרמטי. ענה בעברית, בקצרה, עם קצת איטלקית.", a: "מאמה מיה! 🍝 קפוצ''ינו וקורנטו חמאתי, כך מתחילים יום! ואם יש זמן, ביצה עם עגבניות ובזיליקום. בון אפטיטו!" },
    { e: "🕵️", n: "בלש", i: "אתה בלש ממולח. ענה בעברית, בקצרה, כאילו אתה חוקר תעלומה.", a: "אה, תעלומת ארוחת הבוקר... 🕵️ הרמזים ברורים: ביצה, קפה וטוסט. המסקנה אחת: אל תדלג על הארוחה הזו, חבר." },
    { e: "👽", n: "חייזר", i: "אתה חייזר שהגיע לכדור הארץ הבוקר. ענה בעברית, בקצרה, ותהה על מנהגי בני האדם.", a: "מעניין! 👽 אצלנו אוכלים אור כוכבים. אצלכם, כך הבנתי, מקובל ביצים ולחם. נסה, ותספר לי אם זה מתאים גם לגוף חייזרי." }
  ];
  var box = $("personas"), note = $("note"), ans = $("answer");
  var btns = [];
  function pick(k) {
    var p = people[k];
    btns.forEach(function (b, j) { b.classList.toggle("active", j === k); });
    note.innerHTML = "";
    note.appendChild(el("b", "", "📝 ההנחיה (instructions)"));
    note.appendChild(document.createTextNode(p.i));
    var a = ans.cloneNode(false); a.textContent = p.a;
    ans.parentNode.replaceChild(a, ans); ans = a;
  }
  people.forEach(function (p, k) {
    var b = el("button", "persona-btn", p.e + " " + p.n); b.type = "button";
    b.addEventListener("click", function () { pick(k); });
    box.appendChild(b); btns.push(b);
  });
  pick(0);
})();

/* ---------- temperature ---------- */
(function () {
  var pools = [
    { max: 3, names: ["מיצי", "מיצי", "מיצי"], d: "כמעט אותה תשובה בכל פעם. מתאים כשצריך דיוק ויציבות." },
    { max: 10, names: ["מיצי", "פלפל", "מיצי"], d: "קצת גיוון, אבל עדיין צפוי. זו ברירת המחדל הרגילה." },
    { max: 15, names: ["זיגזג", "נוגט", "פרופסור"], d: "יותר הפתעות ורעיונות. מתאים לשמות, סיפורים ופיתוח רעיונות." },
    { max: 20, names: ["בלובלוב", "קרקרון", "זאזא"], d: "פרוע ויצירתי. לפעמים יוצא משהו מוזר, ולפעמים אפילו חסר היגיון." }
  ];
  var range = $("temp-range");
  function upd() {
    var v = parseInt(range.value, 10);
    var p = pools.filter(function (x) { return v <= x.max; })[0];
    $("temp-val").textContent = "temperature = " + (v / 10).toFixed(1);
    var runs = $("runs"); runs.innerHTML = "";
    p.names.forEach(function (n, i) {
      var r = el("div", "run"); r.appendChild(el("small", "", "הרצה " + (i + 1))); r.appendChild(el("b", "", n));
      runs.appendChild(r);
    });
    $("temp-desc").textContent = p.d;
  }
  range.addEventListener("input", upd);
  upd();
})();

/* ---------- quiz ---------- */
(function () {
  var qs = [
    { q: "איך נותנים לבוט אישיות?", opts: ["כותבים בפרמטר instructions מי הוא ואיך לענות", "מתקינים ספרייה מיוחדת", "מוחקים את ההיסטוריה"], ok: 0, why: "ההנחיות הן פתק קצר שנשלח למודל בכל פנייה ומגדיר את התפקיד והסגנון." },
    { q: "מה עושה temperature נמוך (קרוב ל-0)?", opts: ["תשובות יציבות וצפויות, כמעט אותו דבר בכל פעם", "תשובות פרועות ויצירתיות", "תשובות קצרות יותר"], ok: 0, why: "טמפרטורה נמוכה אומרת פחות הפתעות. טמפרטורה גבוהה אומרת יותר יצירתיות." },
    { q: "אתם בונים בוט שנותן רעיונות יצירתיים לשמות. איזו טמפרטורה מתאימה?", opts: ["נמוכה, כמו 0", "גבוהה יחסית, כמו 1.3", "אין קשר"], ok: 1, why: "כשרוצים גיוון ורעיונות חדשים, טמפרטורה גבוהה יותר עובדת טוב. לתשובות עובדתיות עדיף נמוך." }
  ];
  var host = $("quiz-container");
  var answered = 0, right = 0;
  qs.forEach(function (item, i) {
    var card = el("div", "quiz-card");
    card.appendChild(el("p", "", (i + 1) + ". " + item.q));
    var choices = el("div", "choices"); var fb = el("div", "fb");
    card.appendChild(choices); card.appendChild(fb);
    item.opts.forEach(function (o, j) {
      var b = el("button", "choice", o); b.type = "button";
      b.addEventListener("click", function () {
        var all = choices.querySelectorAll(".choice");
        all.forEach(function (x) { x.disabled = true; });
        answered++;
        if (j === item.ok) { right++; b.classList.add("right"); fb.textContent = "נכון! " + item.why; fb.className = "fb correct"; }
        else { b.classList.add("wrong"); all[item.ok].classList.add("right"); fb.textContent = "לא בדיוק. " + item.why; fb.className = "fb wrong"; }
        if (answered === qs.length) {
          $("score-box").textContent = right === qs.length ? "🏆 " + right + " מתוך " + qs.length + ". מושלם!" : right + " מתוך " + qs.length + ". כדאי לחזור לחלקים שלא היו ברורים.";
        }
      });
      choices.appendChild(b);
    });
    host.appendChild(card);
  });
})();

/* ---------- mission ---------- */
(function () {
  var boxes = document.querySelectorAll("#mission-list input");
  function upd() {
    var n = 0;
    boxes.forEach(function (b) { if (b.checked) n++; });
    $("mission-done").textContent = n === boxes.length ? "🎉 מעולה! נתראה בשיעור 5, ונלמד את הבוט לענות במבנה קבוע." : (n ? n + " מתוך " + boxes.length + " הושלמו" : "");
  }
  boxes.forEach(function (b) { b.addEventListener("change", upd); });
})();
</script>

</body>
</html>
' WHERE course_id='ai-app-dev' AND slug='lesson-4-persona';
