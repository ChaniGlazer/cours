DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='lists';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('0bb7131b951fa01dd0e9cadb9a5660a5', 'python-ai-era', 'lists', 'שיעור 5 - רשימות (list)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>רשימות (list) בפייתון — המדף של התוכנית</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;700;800;900&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #12102A;
    --bg-panel: #1D1A3D;
    --bg-panel-2: #262148;
    --ink: #F5F3FF;
    --ink-dim: #B4AEDB;
    --ink-faint: #6F699E;
    --for: #FFB84D;
    --for-soft: #4A3A1C;
    --while: #FF5C8A;
    --while-soft: #4A1F30;
    --success: #5CE1A6;
    --success-soft: #163B30;
    --danger: #FF6B6B;
    --danger-soft: #3E1D22;
    --line: rgba(245,243,255,0.10);
    --line-strong: rgba(245,243,255,0.22);
    --radius: 20px;
    --display: "Rubik", sans-serif;
    --sans: "Assistant", sans-serif;
    --mono: "JetBrains Mono", monospace;
  }

  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; }
  }

  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }

  body {
    margin: 0;
    background:
      radial-gradient(600px 400px at 15% -5%, rgba(255,184,77,0.10), transparent 60%),
      radial-gradient(600px 400px at 100% 20%, rgba(255,92,138,0.10), transparent 60%),
      var(--bg);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 17px;
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
  }

  ::selection { background: var(--for); color: #1a1204; }

  .wrap { max-width: 720px; margin: 0 auto; padding: 0 22px; }

  p { color: var(--ink-dim); margin: 0; }
  p + p { margin-top: 14px; }
  h1, h2, h3 { font-family: var(--display); font-weight: 800; color: var(--ink); margin: 0; }
  code, .mono { font-family: var(--mono); direction: ltr; unicode-bidi: isolate; }
  strong { color: var(--ink); }

  button { font-family: var(--sans); cursor: pointer; }
  button:focus-visible, input:focus-visible, textarea:focus-visible { outline: 2px solid var(--ink); outline-offset: 3px; }

  section { padding: 68px 0; }
  section + section { border-top: 1px solid var(--line); }

  .eyebrow { font-family: var(--mono); font-size: 13px; color: var(--ink-faint); margin-bottom: 12px; }
  .eyebrow.for-c { color: var(--for); }
  .eyebrow.while-c { color: var(--while); }

  h2.section-title { font-size: clamp(1.6rem, 4.5vw, 2.2rem); }
  .lede { font-size: 18px; margin-top: 14px; }

  /* ---------- HERO + TEASER ---------- */

  .hero { padding: 80px 0 60px; text-align: center; }
  .hero h1 { font-size: clamp(2.1rem, 7vw, 3.2rem); line-height: 1.18; }
  .hero h1 .accent-for { color: var(--for); }
  .hero h1 .accent-while { color: var(--while); }
  .hero-sub { max-width: 46ch; margin: 18px auto 0; font-size: 18.5px; }

  /* ---------- SHELF (boxes with indexes) ---------- */

  .shelf { display: flex; gap: 8px; direction: ltr; justify-content: center; flex-wrap: wrap; }
  .slot { display: flex; flex-direction: column; align-items: center; gap: 4px; }
  .slot-idx { font-family: var(--mono); font-size: 12px; color: var(--for); min-height: 18px; }
  .slot-neg { font-family: var(--mono); font-size: 12px; color: var(--while); min-height: 18px; }
  .box {
    min-width: 62px; height: 46px; padding: 0 10px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    background: var(--bg-panel-2); color: var(--ink-dim); border: 1px solid var(--line-strong);
    font-family: var(--sans); font-weight: 700; font-size: 15px; direction: rtl;
    transition: background 0.15s ease, color 0.15s ease, border-color 0.15s ease;
  }
  button.box:hover { border-color: var(--ink-dim); }
  .box.on { background: var(--for-soft); color: var(--for); border-color: var(--for); }
  .box.off { background: transparent; color: var(--ink-faint); border: 1px dashed var(--line-strong); }
  .box.num { font-family: var(--mono); }
  .box.pop { animation: pop-in 0.35s cubic-bezier(.34,1.56,.64,1); }
  @keyframes pop-in { from { opacity: 0; transform: scale(0.3); } to { opacity: 1; transform: scale(1); } }
  .shelf-label { font-family: var(--mono); font-size: 12.5px; color: var(--ink-faint); text-align: center; margin: 14px 0 10px; direction: ltr; }
  .shelf-empty { color: var(--ink-faint); font-style: italic; font-size: 14px; align-self: center; direction: rtl; min-height: 46px; display: flex; align-items: center; }

  /* ---------- CODE CARDS ---------- */

  .code-card { background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); overflow: hidden; }
  .code-card-label { font-size: 13.5px; font-weight: 700; color: var(--ink-faint); padding: 12px 18px; border-bottom: 1px solid var(--line); }
  .code-card.for-accent .code-card-label { color: var(--for); }
  .code-card.while-accent .code-card-label { color: var(--while); }
  .code-card pre, pre.code-static {
    direction: ltr; text-align: left; margin: 0; padding: 16px 18px 18px; overflow-x: auto;
    font-family: var(--mono); font-size: 14.5px; line-height: 1.7;
  }
  pre.code-static { background: rgba(0,0,0,0.22); border-radius: 12px; margin-top: 18px; }
  .tok-kw { color: #C792EA; }
  .tok-str { color: #A8D48A; unicode-bidi: isolate; }
  .iso { unicode-bidi: isolate; }
  .tok-num { color: #F5C97B; }
  .tok-fn { color: #7EC1F5; }
  .tok-cmt { color: var(--ink-faint); }
  .solo-code { max-width: 460px; }

  /* ---------- JAVA vs PYTHON TABLE ---------- */

  .tbl-wrap { margin-top: 24px; overflow-x: auto; border: 1px solid var(--line); border-radius: 14px; }
  .tbl { width: 100%; border-collapse: collapse; font-size: 15px; }
  .tbl th, .tbl td { padding: 11px 16px; border-bottom: 1px solid var(--line); text-align: left; direction: ltr; }
  .tbl tr:last-child td { border-bottom: 0; }
  .tbl th { background: var(--bg-panel-2); color: var(--ink); font-family: var(--display); font-weight: 800; font-size: 14px; }
  .tbl th.py, .tbl td.py { color: var(--for); }
  .tbl td { background: var(--bg-panel); font-family: var(--mono); font-size: 13.5px; color: var(--ink-dim); }

  .diff-counter { margin-top: 18px; display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .diff-counter label { font-size: 14.5px; font-weight: 600; color: var(--ink); }
  .diff-counter input[type="number"] {
    width: 60px; font-family: var(--mono); font-size: 16px; text-align: center;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 8px 10px;
  }
  .diff-remaining { font-size: 14.5px; font-weight: 700; color: var(--ink-dim); }
  .diff-remaining.done { color: var(--success); }
  .reveal-btn {
    margin-top: 18px; font-family: var(--sans); font-weight: 600; font-size: 14px;
    background: transparent; color: var(--ink-faint); border: 1px dashed var(--line-strong); border-radius: 8px; padding: 9px 16px;
  }
  .reveal-btn:hover { color: var(--ink); border-color: var(--ink-dim); }
  .diff-answer { margin-top: 14px; font-size: 14.5px; color: var(--ink-dim); background: var(--bg-panel); border: 1px solid var(--line); border-radius: 12px; padding: 14px 18px; }
  .diff-answer-row { display: flex; align-items: flex-start; gap: 10px; padding: 6px 0; }
  .diff-num-badge {
    flex-shrink: 0; display: flex; align-items: center; justify-content: center; width: 20px; height: 20px; border-radius: 50%;
    background: var(--for-soft); color: var(--for); font-family: var(--mono); font-size: 12px; font-weight: 700;
  }

  /* ---------- PLAYGROUND (demos) ---------- */

  .playground { margin-top: 36px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); overflow: hidden; }
  .playground-controls { padding: 20px 24px; border-bottom: 1px solid var(--line); display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
  .playground-controls label { font-weight: 700; font-size: 15px; }
  .slider-row { display: flex; align-items: center; gap: 12px; flex: 1; min-width: 200px; }
  input[type="range"] { flex: 1; accent-color: var(--for); }
  .slider-val { font-family: var(--mono); font-weight: 700; font-size: 18px; color: var(--for); min-width: 34px; text-align: center; direction: ltr; }
  .playground-stage { padding: 22px 24px 8px; }
  .playground-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 2; padding: 14px 0; border-top: 1px solid var(--line); margin-top: 14px; }
  .playground-code .line { padding: 2px 22px; white-space: pre; }
  .playground-code .line.out { color: var(--for); }
  .playground-code .line.err { color: var(--danger); background: var(--danger-soft); box-shadow: inset 3px 0 0 var(--danger); }
  .playground-note { padding: 0 24px 18px; font-size: 14.5px; color: var(--ink-dim); min-height: 40px; }
  .playground-note.err { color: var(--danger); font-weight: 700; }

  .pill-row { display: flex; gap: 8px; flex-wrap: wrap; }
  .pill {
    font-family: var(--mono); font-size: 13px; padding: 8px 14px; border-radius: 100px; direction: ltr;
    border: 1px solid var(--line-strong); background: var(--bg-panel-2); color: var(--ink-dim);
  }
  .pill:hover:not(:disabled) { border-color: var(--ink-dim); color: var(--ink); }
  .pill.active { background: var(--for-soft); color: var(--for); border-color: var(--for); }
  .pill.reset { font-family: var(--sans); color: var(--ink-faint); border-style: dashed; background: transparent; }
  .pill:disabled { opacity: 0.4; cursor: default; }

  .log { direction: ltr; text-align: left; font-family: var(--mono); font-size: 13.5px; line-height: 1.8; padding: 12px 24px; background: rgba(0,0,0,0.22); border-top: 1px solid var(--line); min-height: 52px; max-height: 190px; overflow-y: auto; }
  .log .row { display: flex; gap: 10px; flex-wrap: wrap; }
  .log .arrow { color: var(--ink-faint); }
  .log .res { color: var(--for); }
  .log .bad { color: var(--danger); }
  .log .empty { color: var(--ink-faint); font-family: var(--sans); direction: rtl; font-style: italic; }

  .field-row { padding: 16px 24px; border-top: 1px solid var(--line); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .field-row input[type="text"], .field-row input[type="number"], .num-in {
    font-family: var(--mono); font-size: 15px; background: var(--bg-panel-2); border: 1px solid var(--line-strong);
    border-radius: 8px; color: var(--ink); padding: 8px 10px; direction: ltr; text-align: center;
  }
  .field-row input[type="text"] { width: 120px; }
  .field-row input[type="number"], .num-in { width: 72px; }

  .tabs { display: flex; gap: 8px; margin-top: 26px; flex-wrap: wrap; }
  .tab {
    font-family: var(--mono); font-weight: 700; font-size: 14px; direction: ltr;
    padding: 9px 22px; border-radius: 100px; border: 2px solid var(--line-strong); background: transparent; color: var(--ink-dim);
  }
  .tab.active { border-color: var(--for); color: var(--for); background: var(--for-soft); }

  .names { display: flex; gap: 10px; justify-content: center; margin-bottom: 14px; direction: ltr; }
  .name-tag { font-family: var(--mono); font-weight: 800; font-size: 15px; padding: 4px 14px; border-radius: 8px; background: var(--for-soft); color: var(--for); border: 1px solid var(--for); }
  .name-tag.b { background: var(--while-soft); color: var(--while); border-color: var(--while); }
  .names.two { gap: 30px; }
  .names .group { display: flex; flex-direction: column; align-items: center; gap: 10px; }

  /* guess row */
  .guess-row { padding: 18px 24px; border-top: 1px solid var(--line); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .guess-row input { width: 110px; font-family: var(--mono); font-size: 16px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 8px 10px; text-align: center; direction: ltr; }
  .guess-row input[type="number"] { width: 70px; }
  .guess-btn { background: var(--bg-panel-2); color: var(--ink); border: 1px solid var(--line-strong); border-radius: 100px; padding: 9px 18px; font-weight: 700; font-size: 14px; }
  .guess-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .guess-feedback.correct { color: var(--success); }
  .guess-feedback.wrong { color: var(--danger); }

  .callout { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--for); border-radius: 14px; padding: 16px 20px; font-size: 15.5px; color: var(--ink-dim); }
  .callout.java { border-inline-start-color: var(--while); }

  /* ---------- BUG HUNT (choices) ---------- */

  .rescue { margin-top: 36px; background: var(--bg-panel); border: 1px solid var(--danger); border-radius: var(--radius); padding: 24px 26px 26px; }
  .rescue.fixed { border-color: var(--success); }
  .rescue-head { display: flex; align-items: center; gap: 14px; margin-bottom: 18px; }
  .rescue-head h4 { font-family: var(--sans); font-weight: 700; font-size: 15.5px; margin: 0; color: var(--ink); }
  .rescue-mark { font-size: 24px; color: var(--danger); }
  .rescue.fixed .rescue-mark { color: var(--success); }
  .rescue pre { direction: ltr; text-align: left; margin: 0 0 18px; font-family: var(--mono); font-size: 14.5px; line-height: 1.75; background: rgba(0,0,0,0.25); border-radius: 10px; padding: 16px 18px; overflow-x: auto; }
  .rescue-choices { display: flex; gap: 12px; flex-wrap: wrap; }
  .rescue-choice { flex: 1; min-width: 200px; text-align: right; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 14px; padding: 14px 16px; font-size: 14.5px; color: var(--ink); }
  .rescue-choice:hover:not(:disabled) { border-color: var(--ink-dim); }
  .rescue-choice.right { border-color: var(--success); background: var(--success-soft); color: var(--success); }
  .rescue-choice.wrong { border-color: var(--danger); background: var(--danger-soft); color: var(--danger); }
  .rescue-choice:disabled { cursor: default; }
  .rescue-feedback { margin-top: 14px; font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .rescue-feedback.correct { color: var(--success); }
  .rescue-feedback.wrong { color: var(--danger); }
  .rescue-fix { margin-top: 12px; }

  /* ---------- EXERCISES ---------- */

  .exercises-banner { margin-bottom: 8px; background: linear-gradient(135deg, var(--for-soft), var(--while-soft)); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 24px 26px; }
  .exercises-banner .badge { display: inline-block; font-family: var(--mono); font-size: 12.5px; font-weight: 700; color: var(--bg); background: var(--for); border-radius: 100px; padding: 4px 12px; margin-bottom: 10px; }
  .exercises-banner h2 { font-size: clamp(1.7rem, 4.5vw, 2.3rem); }
  .exercises-banner p { margin-top: 10px; font-size: 16px; color: var(--ink); }

  .exercise-card { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--line-strong); border-radius: 16px; padding: 22px 24px; }
  .exercise-card.for-accent { border-inline-start-color: var(--for); }
  .exercise-card.while-accent { border-inline-start-color: var(--while); }
  .exercise-num { font-family: var(--mono); font-size: 12.5px; color: var(--ink-faint); }
  .exercise-task { margin: 8px 0 16px; font-weight: 600; color: var(--ink); font-size: 15.5px; }
  .exercise-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 1.9; background: rgba(0,0,0,0.22); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px; overflow-x: auto; white-space: pre; }
  .exercise-code input { font-family: var(--mono); font-size: 14px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 6px; color: var(--for); padding: 3px 4px; text-align: center; width: 52px; }
  .exercise-code input.wide { width: 96px; }
  .exercise-controls { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .exercise-controls input { width: 70px; font-family: var(--mono); font-size: 15px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 7px 8px; text-align: center; }
  .exercise-check-btn { background: var(--bg-panel-2); border: 1px solid var(--line-strong); color: var(--ink); border-radius: 100px; padding: 9px 20px; font-weight: 700; font-size: 14px; }
  .exercise-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .exercise-feedback.correct { color: var(--success); }
  .exercise-feedback.wrong { color: var(--danger); }
  .exercise-output { margin-top: 12px; font-family: var(--mono); font-size: 13.5px; direction: ltr; text-align: left; background: rgba(0,0,0,0.18); border-radius: 8px; padding: 10px 12px; color: var(--ink-dim); white-space: pre-line; min-height: 20px; }
  .exercise-divider { margin-top: 40px; display: flex; align-items: center; gap: 14px; color: var(--ink-faint); font-family: var(--mono); font-size: 13px; }
  .exercise-divider::before, .exercise-divider::after { content: ""; flex: 1; height: 1px; background: var(--line); }
  .exercise-hint { direction: ltr; text-align: left; font-family: var(--mono); font-size: 13px; color: var(--ink-dim); background: rgba(0,0,0,0.18); border-radius: 8px; padding: 12px 14px; margin-bottom: 12px; line-height: 1.7; }
  .exercise-note { font-size: 13.5px; color: var(--ink-faint); font-style: italic; margin: 0 0 10px; }
  .exercise-answer { width: 100%; direction: ltr; text-align: left; font-family: var(--mono); font-size: 13.5px; line-height: 1.7; background: rgba(0,0,0,0.22); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 12px 14px; resize: vertical; }
  .exercise-answer.rtl { direction: rtl; text-align: right; font-family: var(--sans); font-size: 15px; }
  .exercise-answer:focus { outline: none; border-color: var(--ink-dim); }
  .ai-note { margin-top: 16px; background: var(--while-soft); border-radius: 12px; padding: 12px 16px; color: var(--ink); font-size: 14.5px; }
  .ai-note strong { color: var(--while); }

  /* ---------- SUMMARY ---------- */

  .recap { margin: 22px 0 0; padding: 0; list-style: none; display: grid; gap: 10px; }
  .recap li { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 12px; padding: 12px 16px; color: var(--ink-dim); }
  .recap li::before { content: "✓"; color: var(--success); font-weight: 800; margin-inline-end: 10px; }

  /* ---------- NAME BAR ---------- */

  .name-bar { background: var(--bg-panel); border-bottom: 1px solid var(--line); padding: 14px 0; }
  .name-bar-inner { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .name-bar-inner label { font-size: 13.5px; color: var(--ink-dim); flex-shrink: 0; }
  .name-bar-input { flex: 1; min-width: 160px; max-width: 260px; font-family: var(--sans); font-size: 15px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 10px; color: var(--ink); padding: 9px 12px; }
  .name-bar-input:focus { outline: none; border-color: var(--for); }
  .name-bar-jump { margin-inline-start: auto; font-family: var(--display); font-weight: 700; font-size: 13.5px; color: var(--for); background: transparent; border: 1px solid var(--for); border-radius: 100px; padding: 8px 16px; white-space: nowrap; }
  .name-bar-jump:hover { background: var(--for-soft); }

  .run-btn { font-family: var(--display); font-weight: 800; font-size: 15px; color: #1a1204; background: var(--for); border: none; border-radius: 100px; padding: 12px 26px; }

  /* ---------- CERTIFICATE ---------- */

  .certificate-box { margin-top: 30px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 26px 26px 22px; display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
  .cert-name-display { font-size: 15px; color: var(--ink-dim); }
  .cert-name-display strong { color: var(--for); }
  .cert-status { width: 100%; margin: 0; font-size: 14.5px; color: var(--ink-dim); }
  .cert-status.correct { color: var(--success); }
  .cert-status.wrong { color: var(--danger); }
  .cert-fallback { margin-top: 16px; }
  .cert-fallback-note { font-size: 13.5px; color: var(--ink-faint); margin: 0 0 10px; }
  .cert-fallback-text { width: 100%; direction: ltr; text-align: left; font-family: var(--mono); font-size: 12px; line-height: 1.6; background: rgba(0,0,0,0.25); border: 1px solid var(--line-strong); border-radius: 10px; color: var(--ink-dim); padding: 12px 14px; }

  footer { padding: 48px 0 76px; text-align: center; color: var(--ink-faint); font-size: 14px; }
</style>
</head>
<body>

<div class="name-bar">
  <div class="wrap name-bar-inner">
    <label for="cert-name">מי כותבת? רשמו את השם כאן — הוא יופיע בקובץ שתורידו בסוף:</label>
    <input type="text" id="cert-name" class="name-bar-input" placeholder="השם שלך">
    <button type="button" id="jump-to-exercises" class="name-bar-jump">לתרגילים ⬇</button>
  </div>
</div>

<header class="hero">
  <div class="wrap">
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור חמישי · פייתון · מגמת מחשבים</div>
    <h1>המדף של התוכנית:<br><span class="accent-for">רשימות</span> <span class="accent-while">(list)</span></h1>
    <p class="hero-sub">בקשתם פעם מ-AI 8 רעיונות לשם לאפליקציה? מה שחזר הוא <strong>רשימה</strong>.<br>רשימה שומרת הרבה ערכים בשורה אחת, וכל ערך יושב בתא משלו.</p>

    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre><code>grades = [88, 95, 72, 100, 64]
print(sum(grades) / len(grades))
# 83.8</code></pre>
    </div>
  </div>
</header>

<main>

  <!-- ================= JAVA vs PYTHON ================= -->

  <section id="diff-game">
    <div class="wrap">
      <div class="eyebrow">לפני שמתחילים</div>
      <h2 class="section-title">מה שונה כאן לעומת Java?</h2>
      <p class="lede">תסתכלו בקוד, ותגידו בקול רם: מה שונה לעומת מה שאתן מכירות מ-Java?</p>

      <div class="tbl-wrap">
        <table class="tbl">
          <thead><tr><th>Java</th><th class="py">Python</th></tr></thead>
          <tbody>
            <tr><td>ArrayList&lt;String&gt; fruits = new ArrayList&lt;&gt;();</td><td class="py">fruits = []</td></tr>
            <tr><td>fruits.add("apple");</td><td class="py">fruits.append("apple")</td></tr>
            <tr><td>fruits.get(0);</td><td class="py">fruits[0]</td></tr>
            <tr><td>fruits.size();</td><td class="py">len(fruits)</td></tr>
          </tbody>
        </table>
      </div>

      <div class="diff-counter">
        <label for="diff-count">כמה שינויים מצאתן עד עכשיו?</label>
        <input type="number" id="diff-count" min="0" max="5" value="0">
        <span class="diff-remaining" id="diff-remaining"></span>
      </div>
      <button class="reveal-btn" id="diff-reveal" type="button" aria-expanded="false" aria-controls="diff-answer">הצג תשובה (למורה)</button>
      <div class="diff-answer" id="diff-answer" hidden>
        <div class="diff-answer-row"><span class="diff-num-badge">1</span><span>אין הכרזת טיפוס ואין <span class="mono">&lt;String&gt;</span>. אפשר לשים בפנים כל דבר.</span></div>
        <div class="diff-answer-row"><span class="diff-num-badge">2</span><span>אין <span class="mono">new</span>.</span></div>
        <div class="diff-answer-row"><span class="diff-num-badge">3</span><span>גישה לתא עם סוגריים מרובעים <span class="mono">[ ]</span>, ולא עם <span class="mono">.get()</span>.</span></div>
        <div class="diff-answer-row"><span class="diff-num-badge">4</span><span>מחשבים אורך עם הפונקציה <span class="mono">len()</span>, ולא עם <span class="mono">.size()</span>.</span></div>
        <div class="diff-answer-row"><span class="diff-num-badge">5</span><span>אין נקודה-פסיק.</span></div>
      </div>
    </div>
  </section>

  <!-- ================= INDEX SHELF ================= -->

  <section id="shelf">
    <div class="wrap">
      <div class="eyebrow for-c">list</div>
      <h2 class="section-title">list — המדף עם המספרים</h2>
      <p class="lede">רשימה היא מדף עם תאים ממוספרים. המספר של כל תא נקרא <strong>אינדקס</strong>, והוא מתחיל ב-<span class="mono">0</span>, כמו ב-Java. אבל יש בונוס שאין ב-Java: <strong>אינדקס שלילי</strong> סופר מהסוף, ו-<span class="mono">-1</span> הוא תמיד האחרון. הזיזו את המחוון וראו איזה תא נדלק.</p>

      <div class="playground">
        <div class="playground-controls">
          <label for="shelf-slider">אינדקס:</label>
          <div class="slider-row">
            <input type="range" id="shelf-slider" min="-7" max="7" value="2">
            <span class="slider-val" id="shelf-val">2</span>
          </div>
        </div>
        <div class="playground-stage"><div class="shelf" id="shelf-boxes"></div></div>
        <div class="playground-code" id="shelf-code" aria-live="polite"></div>
        <div class="playground-note" id="shelf-note"></div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: מה יודפס עבור <span class="mono">fruits[-2]</span>?</span>
          <input type="text" id="g1-input" autocomplete="off" aria-label="הניחוש שלי">
          <button class="guess-btn" id="g1-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g1-fb" role="status" aria-live="polite"></span>
        </div>
      </div>

      <div class="callout"><strong>בעידן ה-AI:</strong> טעות ה״הזזה באחד״ (<span class="mono">IndexError</span>) היא אחת הטעויות הנפוצות ביותר בקוד ש-AI כותב. מי שמבינה את המדף מזהה אותה מיד.</div>
    </div>
  </section>

  <!-- ================= MUTATE ================= -->

  <section id="mutate">
    <div class="wrap">
      <div class="eyebrow for-c">append · insert · remove · pop</div>
      <h2 class="section-title">לשנות את הרשימה</h2>
      <p class="lede">רשימה היא לא קבועה: אפשר להוסיף, להכניס, להסיר ולהוציא. לחצו על הכפתורים וראו איך המדף משתנה, ומה נרשם ביומן.</p>

      <div class="playground">
        <div class="playground-controls">
          <div class="pill-row" id="mut-buttons">
            <button class="pill" data-act="append" type="button">append("ענבים")</button>
            <button class="pill" data-act="insert" type="button">insert(0, "קיווי")</button>
            <button class="pill" data-act="remove" type="button">remove("בננה")</button>
            <button class="pill" data-act="pop" type="button">pop()</button>
            <button class="pill reset" data-act="reset" type="button">אפסי</button>
          </div>
        </div>
        <div class="playground-stage"><div class="shelf" id="mut-shelf"></div></div>
        <div class="log" id="mut-log" aria-live="polite"></div>
      </div>

      <div class="callout java"><strong>שימו לב — הבדל מ-Java:</strong> <span class="mono">remove("בננה")</span> מסיר לפי <strong>ערך</strong> ולא לפי מקום. להסרה לפי מקום משתמשים ב-<span class="mono">pop(index)</span>.</div>
    </div>
  </section>

  <!-- ================= SLICES ================= -->

  <section id="slices">
    <div class="wrap">
      <div class="eyebrow for-c">[התחלה:עצירה:קפיצה]</div>
      <h2 class="section-title">פרוסות — לקחת חלק מהמדף</h2>
      <p class="lede">כותבים <span class="mono">[התחלה:עצירה:קפיצה]</span>. ההתחלה כלולה והעצירה <strong>לא</strong>, בדיוק כמו ב-<span class="mono">range()</span> שכבר מכירים. שנו את המספרים (אפשר להשאיר שדה ריק).</p>

      <div class="playground">
        <div class="playground-controls">
          <label>התחלה <input class="num-in" type="number" id="sl-start" value="1" aria-label="התחלה"></label>
          <label>עצירה <input class="num-in" type="number" id="sl-stop" value="4" aria-label="עצירה"></label>
          <label>קפיצה <input class="num-in" type="number" id="sl-step" value="1" aria-label="קפיצה"></label>
        </div>
        <div class="playground-stage"><div class="shelf" id="sl-boxes"></div></div>
        <div class="playground-code" id="sl-code" aria-live="polite"></div>
        <div class="playground-note" id="sl-note"></div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: כמה ערכים יהיו ב-<span class="mono">nums[2:5]</span>?</span>
          <input type="number" id="g3-input" min="0" max="20" aria-label="הניחוש שלי">
          <button class="guess-btn" id="g3-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g3-fb" role="status" aria-live="polite"></span>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= COPY vs SAME ================= -->

  <section id="reference">
    <div class="wrap">
      <div class="eyebrow while-c">b = a</div>
      <h2 class="section-title">עותק או אותו מדף?</h2>
      <p class="lede">בדיוק כמו הפניות ב-Java. עברו בין שני המצבים ולחצו <span class="mono">b.append(4)</span>.</p>

      <div class="tabs" id="ref-tabs">
        <button class="tab active" data-mode="alias" type="button">b = a</button>
        <button class="tab" data-mode="copy" type="button">b = a.copy()</button>
      </div>

      <div class="playground" style="margin-top:18px;">
        <div class="playground-stage" id="ref-stage"></div>
        <div class="playground-controls">
          <button class="pill" id="ref-append" type="button">b.append(4)</button>
          <button class="pill reset" id="ref-reset" type="button">אפסי</button>
        </div>
        <div class="playground-note" id="ref-note" style="padding-top:14px;" aria-live="polite"></div>
      </div>

      <div class="callout java"><strong>למי שמכירה Java:</strong> זה בדיוק כמו להעתיק הפניה לאובייקט. <span class="mono">b = a</span> מעתיק את ההפניה ולא את האובייקט.</div>
    </div>
  </section>

  <!-- ================= DETECTIVE ================= -->

  <section id="detective">
    <div class="wrap">
      <div class="eyebrow while-c">בלשית קוד</div>
      <h2 class="section-title">מה ה-AI פספס?</h2>
      <p class="lede">AI כותב קוד מהר, אבל לא תמיד נכון. בכל מקרה: קראי את הקוד, נחשי מה יודפס, ואז בחרי תשובה וקבלי משוב מיידי.</p>
      <div id="case-container"></div>
      <div class="callout"><strong>טיפ:</strong> כשמקבלים קוד מ-AI, לפני שמריצים כותבים בראש מה אנחנו מצפים שיודפס. אם התוצאה שונה, מצאנו בדיוק איפה ההבנה נשברה.</div>
    </div>
  </section>

  <!-- ================= EXERCISES ================= -->

  <section id="exercises">
    <div class="wrap">
      <div class="exercises-banner">
        <span class="badge">👇 מפה זה עלייך</span>
        <h2 class="section-title">התרגילים שלכן</h2>
        <p>חמישה תרגילים — ארבעה עם בדיקה מיידית, ואחד שכותבים בעורך הפייתון ומדביקים כאן. בסוף מורידות קובץ עם כל התוצאות.</p>
      </div>
      <p class="lede" style="margin-top:22px;">משלימות את החסר בקוד, לוחצות ״בדקי״, ורואות מיד אם זה עובד.</p>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 1 · אינדקס</div>
        <p class="exercise-task">השלימי כך שיודפס <span class="mono">אגס</span>.</p>
        <div class="exercise-code">fruits = ["תפוח", "בננה", "אגס"]
print(fruits[<input type="text" id="ex1-i" autocomplete="off" aria-label="האינדקס">])</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex1-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex1-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex1-output"></div>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 2 · פרוסה</div>
        <p class="exercise-task">השלימי כך שיודפס <span class="mono">[30, 40, 50]</span>.</p>
        <div class="exercise-code">nums = [10, 20, 30, 40, 50, 60]
print(nums[<input type="text" id="ex2-a" autocomplete="off" aria-label="התחלה">:<input type="text" id="ex2-b" autocomplete="off" aria-label="עצירה">])</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex2-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex2-output"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 3 · שמות פעולות</div>
        <p class="exercise-task">השלימי את שמות הפעולות כך שיודפס <span class="mono">[''x'', ''a'', ''c'', ''d'']</span>.</p>
        <div class="exercise-code">items = ["a", "b", "c"]
items.<input type="text" class="wide" id="ex3-a" autocomplete="off" aria-label="פעולה ראשונה">(0, "x")
items.<input type="text" class="wide" id="ex3-b" autocomplete="off" aria-label="פעולה שנייה">("b")
items.<input type="text" class="wide" id="ex3-c" autocomplete="off" aria-label="פעולה שלישית">("d")
print(items)</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex3-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex3-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex3-output"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · עותק או הפניה</div>
        <p class="exercise-task">בלי להריץ — מה יודפס?</p>
        <div class="exercise-code">a = [1, 2, 3]
b = a
b.append(9)
print(len(a))</div>
        <div class="exercise-controls">
          <span style="font-size:14.5px; font-weight:600;">הניחוש שלי:</span>
          <input type="number" id="ex4-guess" min="0" max="20" aria-label="הניחוש שלי">
          <button class="exercise-check-btn" id="ex4-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex4-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex4-output"></div>
      </div>


      <div class="exercise-divider">
        <span>כתיבה אישית — פותרות בעורך הפייתון שלכן, לא כאן</span>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 5 · כתיבה חופשית · רשימת מטלות</div>
        <p class="exercise-task">כתבי בעורך הפייתון תוכנית עם רשימה של 3 מטלות. הוסיפי מטלה רביעית, הסירי את הראשונה, והדפיסי את הרשימה ממוינת ואת מספר המטלות.</p>
        <p class="exercise-note">✍️ כתבו ושמרו את הפתרון בעורך הפייתון שלכן, ואז הדביקו אותו כאן:</p>
        <textarea class="exercise-answer" id="ex5-answer" rows="6" placeholder="# הדביקו כאן את הקוד שכתבתן..."></textarea>
        <div class="ai-note"><strong>עידן ה-AI:</strong> בקשי מ-AI לכתוב את אותה תוכנית. השווי לקוד שלך. מה הוא עשה בדרך אחרת? כתבי משפט אחד.</div>
        <textarea class="exercise-answer rtl" id="ex5-ai" rows="2" style="margin-top:12px;" placeholder="משפט אחד על ההבדל..."></textarea>
      </div>

    </div>
  </section>

  <!-- ================= SUMMARY ================= -->

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">מה למדנו</h2>
      <ul class="recap">
        <li>אינדקס מתחיל ב-0, ו-<span class="mono">-1</span> הוא האחרון.</li>
        <li><span class="mono">append</span>, <span class="mono">insert</span>, <span class="mono">remove</span>, <span class="mono">pop</span>.</li>
        <li>פרוסות <span class="mono">[התחלה:עצירה:קפיצה]</span>, והעצירה לא כלולה.</li>
        <li><span class="mono">sort()</span> מחזירה <span class="mono">None</span>, ו-<span class="mono">sorted()</span> יוצרת רשימה חדשה.</li>
        <li><span class="mono">b = a</span> מעתיק הפניה, ו-<span class="mono">a.copy()</span> יוצר מדף חדש.</li>
      </ul>
    </div>
  </section>

  <!-- ================= CERTIFICATE ================= -->

  <section id="certificate">
    <div class="wrap">
      <div class="eyebrow">לסיום</div>
      <h2 class="section-title">שלחו לי את התוצאות</h2>
      <p class="lede">לוחצות על הכפתור — יורד קובץ HTML מעוצב עם סיכום מה שפתרתן, כולל הקוד שהדבקתן בתרגיל 5, כדי שאוכל לבדוק.</p>
      <div class="certificate-box">
        <span class="cert-name-display">מורידה עבור: <strong id="cert-name-display">—</strong></span>
        <button class="run-btn" id="cert-download" type="button">⬇️ הורידי קובץ תוצאות</button>
        <p class="cert-status" id="cert-status" role="status" aria-live="polite"></p>
      </div>
      <div class="cert-fallback" id="cert-fallback" hidden>
        <p class="cert-fallback-note">ההורדה האוטומטית לא זמינה כאן. סמנו הכול בתיבה למטה (Ctrl+A / Cmd+A), העתיקו, הדביקו לקובץ טקסט חדש ושמרו אותו בסיומת .html:</p>
        <textarea class="cert-fallback-text" id="cert-fallback-text" readonly rows="8"></textarea>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">שיעור פייתון · רשימות</div></footer>

<script>
window.lessonProgress = { name: "", ex1: false, ex2: false, ex3: false, ex4: false, detectiveSolved: 0, detectiveTotal: 2 };

/* דיווח התקדמות לאתר שמציג את השיעור. window.reportProgress מוזרק על ידי האתר ושולח לו הודעה;
   בקובץ שנפתח לבד אין אותו, ולכן הקריאה מוגנת. תרגילי החובה: תרגילים 1-4. */
function reportLessonProgress() {
  if (!window.reportProgress) return;
  var p = window.lessonProgress, keys = ["ex1", "ex2", "ex3", "ex4"], done = 0;
  for (var i = 0; i < keys.length; i++) { if (p[keys[i]]) done++; }
  window.reportProgress(done, keys.length);
}
reportLessonProgress();

/*PURE-START*/
/* לוגיקת הבדיקה של התרגילים 1-4. פונקציות טהורות ללא DOM, מוכנות לעבור לשרת. */
function pyRepr(v) {
  if (Array.isArray(v)) return "[" + v.map(pyRepr).join(", ") + "]";
  if (typeof v === "string") return "''" + v + "''";
  return String(v);
}

/* חיתוך בסגנון CPython: start/stop/step יכולים להיות null (חסר) או שלילי. מחזיר מערך של אינדקסים */
function sliceIndexes(n, start, stop, step) {
  if (step === null || step === undefined) step = 1;
  if (step === 0) return { error: "ValueError: slice step cannot be zero" };
  var lower = step > 0 ? 0 : -1, upper = step > 0 ? n : n - 1;
  function norm(v, dflt) {
    if (v === null || v === undefined) return dflt;
    if (v < 0) { v += n; if (v < lower) v = lower; }
    else if (v > upper) v = upper;
    return v;
  }
  var s = norm(start, step < 0 ? upper : lower);
  var e = norm(stop, step < 0 ? lower : upper);
  var out = [];
  if (step > 0) { for (var i = s; i < e; i += step) out.push(i); }
  else { for (var j = s; j > e; j += step) out.push(j); }
  return { indexes: out };
}

function parseIntStrict(src) {
  var t = String(src == null ? "" : src).trim();
  if (!/^-?\d+$/.test(t)) return null;
  return parseInt(t, 10);
}

/* תרגיל 1: fruits[i] צריך להיות "אגס" */
function checkEx1(src) {
  var fruits = ["תפוח", "בננה", "אגס"];
  var i = parseIntStrict(src);
  if (i === null) return { ok: false, error: "שימי מספר שלם." };
  var at = i < 0 ? fruits.length + i : i;
  if (at < 0 || at >= fruits.length) return { ok: false, error: "IndexError: אין תא " + i + " במדף של " + fruits.length + " תאים.", shown: "IndexError" };
  var got = fruits[at];
  if (got === "אגס") return { ok: true, shown: got };
  return { ok: false, error: "יצא " + got + ". רוצות אגס.", shown: got };
}

/* תרגיל 2: nums[a:b] צריך להיות [30, 40, 50] */
function checkEx2(a, b) {
  var nums = [10, 20, 30, 40, 50, 60];
  var s = parseIntStrict(a), e = parseIntStrict(b);
  if (s === null || e === null) return { ok: false, error: "שימי שני מספרים שלמים." };
  var r = sliceIndexes(nums.length, s, e, null);
  var got = r.indexes.map(function (k) { return nums[k]; });
  var shown = pyRepr(got);
  if (shown === "[30, 40, 50]") return { ok: true, shown: shown };
  return { ok: false, error: "יצא " + shown + ". רוצות [30, 40, 50].", shown: shown };
}

/* תרגיל 4: אותה רשימה אחרי append, האורך הוא 4 */
function checkEx4(src) {
  var g = parseIntStrict(src);
  if (g === null) return { ok: false, error: "שימי ניחוש תחילה." };
  var a = [1, 2, 3], b = a;
  b.push(9);
  if (g === a.length) return { ok: true, shown: String(a.length) };
  return { ok: false, error: "לא בדיוק. b ו-a הם אותה רשימה, אז הוסיפו אליה ערך, והאורך יוצא " + a.length + ".", shown: String(a.length) };
}

/* תרגיל 3: מריצים את שלוש הפעולות על ["a","b","c"] ובודקים ש-items הוא [''x'',''a'',''c'',''d''] */
function checkEx3(n1, n2, n3) {
  var items = ["a", "b", "c"];
  var ops = [[String(n1).trim(), [0, "x"]], [String(n2).trim(), ["b"]], [String(n3).trim(), ["d"]]];
  for (var k = 0; k < ops.length; k++) {
    var name = ops[k][0], args = ops[k][1];
    if (!name) return { ok: false, error: "השלימי את שלושת שמות הפעולות." };
    if (name === "append") {
      if (args.length !== 1) return { ok: false, error: "TypeError: append מקבלת ערך אחד בלבד, אבל כאן יש " + args.length + "." };
      items.push(args[0]);
    } else if (name === "insert") {
      if (args.length !== 2) return { ok: false, error: "TypeError: insert צריכה שני ערכים: מקום וערך." };
      items.splice(args[0], 0, args[1]);
    } else if (name === "remove") {
      if (args.length !== 1) return { ok: false, error: "TypeError: remove מקבלת ערך אחד בלבד, אבל כאן יש " + args.length + "." };
      var at = items.indexOf(args[0]);
      if (at < 0) return { ok: false, error: "ValueError: remove לא מצאה את ''" + args[0] + "'' ברשימה." };
      items.splice(at, 1);
    } else if (name === "pop") {
      return { ok: false, error: "pop מוציאה לפי מקום ולא מקבלת ערך כזה. בדקי את הכפתורים בדמו." };
    } else {
      return { ok: false, error: "לרשימה אין פעולה בשם ''" + name + "''." };
    }
  }
  var shown = pyRepr(items);
  if (shown === "[''x'', ''a'', ''c'', ''d'']") return { ok: true, shown: shown };
  return { ok: false, error: "יצא " + shown + ". רוצות [''x'', ''a'', ''c'', ''d''].", shown: shown };
}
/*PURE-END*/

function $(id) { return document.getElementById(id); }
function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
/* מחרוזת בעברית בתוך קוד (LTR) נעטפת ב-isolate, כדי שהמירכאות והפסיקים לא יתהפכו */
var HEB_STR = /("[^"\n]*[\u0590-\u05FF][^"\n]*"|''[^''\n]*[\u0590-\u05FF][^''\n]*'')/g;
function iso(s) { return esc(s).replace(HEB_STR, ''<span class="iso">$1</span>''); }
function isolateCodeText(el) {
  var walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT), nodes = [], n;
  while ((n = walker.nextNode())) nodes.push(n);
  nodes.forEach(function (t) {
    var h = iso(t.nodeValue);
    if (h.indexOf(''class="iso"'') < 0) return;
    var span = document.createElement("span"); span.innerHTML = h;
    t.parentNode.replaceChild(span, t);
  });
}

function highlight(code) {
  return esc(code).replace(/(#.*$)|("[^"]*")|\b(for|in|if|else|and|or|not|while)\b|\b(print|len|sorted|sum|max|min|append|insert|remove|pop|copy|sort|range)\b|(-?\b\d+(?:\.\d+)?\b)/gm, function (m, cmt, str, kw, fn, num) {
    if (cmt) return ''<span class="tok-cmt">'' + cmt + "</span>";
    if (str) return ''<span class="tok-str">'' + str + "</span>";
    if (kw) return ''<span class="tok-kw">'' + kw + "</span>";
    if (fn) return ''<span class="tok-fn">'' + fn + "</span>";
    return ''<span class="tok-num">'' + num + "</span>";
  });
}
document.querySelectorAll("pre.hl, .code-card pre code, .rescue pre").forEach(function (el) { el.innerHTML = highlight(el.textContent); });
document.querySelectorAll(".exercise-code").forEach(isolateCodeText);

function renderShelf(container, items, opts) {
  opts = opts || {};
  container.innerHTML = "";
  if (!items.length) {
    var e = document.createElement("span");
    e.className = "shelf-empty";
    e.textContent = "רשימה ריקה []";
    container.appendChild(e);
    return;
  }
  items.forEach(function (v, k) {
    var slot = document.createElement("div"); slot.className = "slot";
    var pos = document.createElement("div"); pos.className = "slot-idx"; pos.textContent = opts.indexes === false ? "" : k;
    var box = document.createElement(opts.clickable ? "button" : "div");
    if (opts.clickable) box.type = "button";
    box.className = "box" + (typeof v === "number" ? " num" : "") + (opts.on && opts.on(k) ? " on" : "") + (opts.off && opts.off(k) ? " off" : "") + (opts.popAt === k ? " pop" : "");
    box.textContent = v;
    if (opts.onClick) box.addEventListener("click", function () { opts.onClick(k); });
    var neg = document.createElement("div"); neg.className = "slot-neg"; neg.textContent = opts.indexes === false ? "" : (k - items.length);
    slot.appendChild(pos); slot.appendChild(box); slot.appendChild(neg);
    container.appendChild(slot);
  });
}

function makeGuess(btnId, inputId, fbId, test, okText, badText) {
  $(btnId).addEventListener("click", function () {
    var fb = $(fbId), v = $(inputId).value.trim().replace(/^["''״׳]|["''״׳]$/g, "");
    if (!v) { fb.textContent = "כתבי ניחוש תחילה."; fb.className = "guess-feedback wrong"; return; }
    if (test(v)) { fb.textContent = okText; fb.className = "guess-feedback correct"; }
    else { fb.textContent = badText; fb.className = "guess-feedback wrong"; }
  });
}

/* ---------- jump to exercises ---------- */
(function () {
  var btn = $("jump-to-exercises"), target = $("exercises");
  if (btn && target) btn.addEventListener("click", function () { target.scrollIntoView({ behavior: "smooth", block: "start" }); });
})();

/* ---------- Java vs Python ---------- */
(function () {
  var input = $("diff-count"), remaining = $("diff-remaining"), total = 5;
  function update() {
    var found = parseInt(input.value, 10);
    if (isNaN(found) || found < 0) found = 0;
    if (found > total) found = total;
    var left = total - found;
    if (left <= 0) { remaining.textContent = "מצאתן את כולם! 🎉"; remaining.className = "diff-remaining done"; }
    else { remaining.textContent = "נשארו עוד " + left + " להגיד."; remaining.className = "diff-remaining"; }
  }
  input.addEventListener("input", update); update();
  var btn = $("diff-reveal"), ans = $("diff-answer");
  btn.addEventListener("click", function () {
    var showing = !ans.hidden;
    ans.hidden = showing;
    btn.textContent = showing ? "הצג תשובה (למורה)" : "הסתר תשובה";
    btn.setAttribute("aria-expanded", String(!showing));
  });
})();

/* ---------- index shelf ---------- */
(function () {
  var fruits = ["תפוח", "בננה", "אגס", "ענבים", "קיווי"];
  var slider = $("shelf-slider"), val = $("shelf-val"), boxes = $("shelf-boxes"), code = $("shelf-code"), note = $("shelf-note");
  function render() {
    var i = parseInt(slider.value, 10), n = fruits.length;
    var at = i < 0 ? n + i : i, valid = at >= 0 && at < n;
    val.textContent = i;
    renderShelf(boxes, fruits, { on: function (k) { return valid && k === at; } });
    code.innerHTML = ''<div class="line">'' + highlight("print(fruits[" + i + "])") + "</div>" +
      (valid ? ''<div class="line out">'' + esc(fruits[at]) + "</div>" : ''<div class="line err">IndexError: list index out of range</div>'');
    note.className = "playground-note" + (valid ? "" : " err");
    note.textContent = valid
      ? (i < 0 ? "אינדקס שלילי סופר מהסוף: " + i + " הוא התא ה-" + (-i) + " מהסוף." : "התא במקום " + i + " (סופרים מ-0).")
      : "אין תא כזה במדף.";
  }
  slider.addEventListener("input", render); render();
  makeGuess("g1-btn", "g1-input", "g1-fb", function (v) { return v === "ענבים"; },
    "נכון! -2 הוא השני מהסוף: ענבים.", "לא בדיוק. ספרי מהסוף: -1 הוא קיווי, אז -2 הוא…");
})();

/* ---------- mutate ---------- */
(function () {
  var START = ["תפוח", "בננה", "אגס"];
  var list = START.slice(), log = [], popAt = -1;
  var shelf = $("mut-shelf"), logEl = $("mut-log");
  function render() {
    renderShelf(shelf, list, { popAt: popAt });
    popAt = -1;
    if (!log.length) { logEl.innerHTML = ''<div class="empty">לחצי על כפתור, והפעולה תירשם כאן.</div>''; return; }
    logEl.innerHTML = log.map(function (r) {
      return ''<div class="row"><span>'' + iso(r.code) + ''</span><span class="arrow">→</span><span class="'' + (r.bad ? "bad" : "res") + ''">'' + iso(r.res) + "</span></div>";
    }).join("");
    logEl.scrollTop = logEl.scrollHeight;
  }
  function add(code, res, bad) { log.push({ code: code, res: res, bad: bad }); if (log.length > 12) log.shift(); }
  $("mut-buttons").addEventListener("click", function (e) {
    var b = e.target.closest("button"); if (!b) return;
    var act = b.dataset.act;
    if (act === "reset") { list = START.slice(); log = []; popAt = -1; }
    else if (act === "append") { list.push("ענבים"); popAt = list.length - 1; add(''fruits.append("ענבים")'', pyRepr(list)); }
    else if (act === "insert") { list.unshift("קיווי"); popAt = 0; add(''fruits.insert(0, "קיווי")'', pyRepr(list)); }
    else if (act === "remove") {
      var at = list.indexOf("בננה");
      if (at < 0) add(''fruits.remove("בננה")'', "ValueError: ''בננה'' לא ברשימה", true);
      else { list.splice(at, 1); add(''fruits.remove("בננה")'', pyRepr(list)); }
    } else if (act === "pop") {
      if (!list.length) add("x = fruits.pop()", "IndexError: pop from empty list", true);
      else { var x = list.pop(); add("x = fruits.pop()", "x = " + pyRepr(x)); }
    }
    render();
  });
  render();
})();

/* ---------- slices ---------- */
(function () {
  var nums = [10, 20, 30, 40, 50, 60, 70];
  var sIn = $("sl-start"), eIn = $("sl-stop"), kIn = $("sl-step");
  var boxes = $("sl-boxes"), code = $("sl-code"), note = $("sl-note");
  function val(el) { var t = el.value.trim(); if (t === "") return null; var n = parseInt(t, 10); return isNaN(n) ? null : n; }
  function render() {
    var s = val(sIn), e = val(eIn), k = val(kIn);
    var expr = "nums[" + (s === null ? "" : s) + ":" + (e === null ? "" : e) + (k === null ? "" : ":" + k) + "]";
    var r = sliceIndexes(nums.length, s, e, k);
    if (r.error) {
      renderShelf(boxes, nums, {});
      code.innerHTML = ''<div class="line">'' + highlight("print(" + expr + ")") + ''</div><div class="line err">'' + esc(r.error) + "</div>";
      note.textContent = "קפיצה של 0 אי אפשר: לא היינו זזים לשום מקום."; note.className = "playground-note err";
      return;
    }
    var set = {}; r.indexes.forEach(function (x) { set[x] = true; });
    renderShelf(boxes, nums, { on: function (x) { return set[x]; }, off: function (x) { return !set[x]; } });
    var out = r.indexes.map(function (x) { return nums[x]; });
    code.innerHTML = ''<div class="line">'' + highlight("print(" + expr + ")") + ''</div><div class="line out">'' + esc(pyRepr(out)) + "</div>";
    note.className = "playground-note";
    note.textContent = out.length ? "נבחרו " + out.length + " ערכים. ההתחלה כלולה, והעצירה לא." : "לא נבחר אף ערך, ולכן מתקבלת רשימה ריקה.";
  }
  [sIn, eIn, kIn].forEach(function (el) { el.addEventListener("input", render); });
  makeGuess("g3-btn", "g3-input", "g3-fb", function (v) { return v === "3"; },
    "נכון! 5 פחות 2 זה 3: מקומות 2, 3 ו-4. העצירה לא כלולה.", "לא בדיוק. העצירה (5) לא כלולה, אז סופרים מ-2 עד 4.");
  render();
})();

/* ---------- reference (alias vs copy) ---------- */
(function () {
  var mode = "alias", a = [1, 2, 3], b = a;
  var stage = $("ref-stage"), note = $("ref-note");
  function setup() { a = [1, 2, 3]; b = mode === "alias" ? a : a.slice(); }
  function shelfHtml(arr) { return arr.map(function (v) { return ''<div class="slot"><div class="box num">'' + v + "</div></div>"; }).join(""); }
  function render(msg) {
    if (mode === "alias") {
      stage.innerHTML = ''<div class="names"><span class="name-tag">a</span><span class="name-tag b">b</span></div><div class="shelf">'' + shelfHtml(a) + "</div>";
    } else {
      stage.innerHTML = ''<div class="names two"><div class="group"><span class="name-tag">a</span><div class="shelf">'' + shelfHtml(a) + ''</div></div><div class="group"><span class="name-tag b">b</span><div class="shelf">'' + shelfHtml(b) + "</div></div></div>";
    }
    note.textContent = msg || (mode === "alias" ? "שני השלטים מצביעים על אותו מדף." : "שני מדפים נפרדים, עם אותם ערכים בהתחלה.");
  }
  $("ref-tabs").addEventListener("click", function (e) {
    var t = e.target.closest(".tab"); if (!t) return;
    document.querySelectorAll("#ref-tabs .tab").forEach(function (x) { x.classList.toggle("active", x === t); });
    mode = t.dataset.mode; setup(); render();
  });
  $("ref-append").addEventListener("click", function () {
    b.push(4);
    render(mode === "alias" ? "אותו מדף, לכן a השתנה גם." : "השינוי ב-b לא נוגע ב-a: הם מדפים נפרדים.");
  });
  $("ref-reset").addEventListener("click", function () { setup(); render(); });
  setup(); render();
})();

/* ---------- detective cases ---------- */
(function () {
  var cases = [
    { title: "מקרה 1", code: "nums = [2, 4, 6, 7]\nfor n in nums:\n    if n % 2 == 0:\n        nums.remove(n)\nprint(nums)",
      goal: "המטרה: להשאיר רק אי-זוגיים (הרשימה [7]). מה יודפס בפועל?",
      opts: [{ t: "[4, 7]", ok: true }, { t: "[7]", ok: false }, { t: "שגיאה", ok: false }],
      why: ''כשמסירים ערך, כל מה שאחריו זז אחורה והלולאה מדלגת. הפתרון: <span class="mono">nums = [n for n in nums if n % 2 != 0]</span>.'' },
    { title: "מקרה 2", code: "scores = [3, 1, 2]\nscores = scores.sort()\nprint(scores)",
      goal: "מה יודפס, ולמה?",
      opts: [{ t: "None, כי sort() משנה את הרשימה ולא מחזירה כלום", ok: true }, { t: "הרשימה ממוינת: [1, 2, 3]", ok: false }, { t: "שגיאה", ok: false }],
      why: ''sort() משנה את הרשימה במקום ומחזירה None. הפתרון: <span class="mono">scores = sorted(scores)</span>, ש-sorted יוצרת רשימה חדשה.'' }
  ];
  var container = $("case-container");
  function shuffle(a) { for (var i = a.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)); var t = a[i]; a[i] = a[j]; a[j] = t; } return a; }
  cases.forEach(function (c) {
    var card = document.createElement("div"); card.className = "rescue";
    card.innerHTML = ''<div class="rescue-head"><div class="rescue-mark" aria-hidden="true">🔍</div><h4>'' + c.title + ''</h4></div><pre></pre><p style="color:var(--ink);font-weight:600;margin-bottom:14px;">'' + c.goal + ''</p><div class="rescue-choices"></div><div class="rescue-feedback" role="status" aria-live="polite"></div>'';
    card.querySelector("pre").innerHTML = highlight(c.code);
    var wrap = card.querySelector(".rescue-choices"), fb = card.querySelector(".rescue-feedback");
    shuffle(c.opts.slice()).forEach(function (o) {
      var b = document.createElement("button"); b.type = "button"; b.className = "rescue-choice"; b.textContent = o.t;
      if (/^[\[\d]/.test(o.t)) b.style.direction = "ltr";
      b.addEventListener("click", function () {
        if (o.ok) {
          b.classList.add("right"); card.classList.add("fixed");
          wrap.querySelectorAll("button").forEach(function (x) { x.disabled = true; });
          fb.className = "rescue-feedback correct"; fb.innerHTML = "נכון! " + c.why;
          window.lessonProgress.detectiveSolved++;
        } else {
          b.classList.add("wrong"); b.disabled = true;
          fb.className = "rescue-feedback wrong"; fb.textContent = "לא בדיוק. נסי תשובה אחרת.";
        }
      });
      wrap.appendChild(b);
    });
    container.appendChild(card);
  });
})();

/* ---------- exercises ---------- */
(function () {
  function setFeedback(el, ok, text) { el.textContent = text; el.className = "exercise-feedback " + (ok ? "correct" : "wrong"); }
  function run(n, r, okText) {
    $("ex" + n + "-output").textContent = r.shown || "";
    if (r.ok) { setFeedback($("ex" + n + "-feedback"), true, okText); window.lessonProgress["ex" + n] = true; reportLessonProgress(); }
    else setFeedback($("ex" + n + "-feedback"), false, r.error);
  }
  $("ex1-check").addEventListener("click", function () { run(1, checkEx1($("ex1-i").value), "נכון! אפשר גם 2 וגם -1."); });
  $("ex2-check").addEventListener("click", function () { run(2, checkEx2($("ex2-a").value, $("ex2-b").value), "מדויק! ההתחלה כלולה והעצירה לא."); });
  $("ex3-check").addEventListener("click", function () { run(3, checkEx3($("ex3-a").value, $("ex3-b").value, $("ex3-c").value), "יפה! insert, remove ו-append, בסדר הזה."); });
  $("ex4-check").addEventListener("click", function () { run(4, checkEx4($("ex4-guess").value), "נכון! b = a לא יוצר עותק."); });
})();

/* ---------- certificate download ---------- */
(function () {
  var nameInput = $("cert-name"), btn = $("cert-download"), statusEl = $("cert-status");
  var fallbackBox = $("cert-fallback"), fallbackText = $("cert-fallback-text"), nameDisplay = $("cert-name-display");
  function currentName() { return (nameInput.value || "").trim() || "תלמידה"; }
  nameInput.addEventListener("input", function () { nameDisplay.textContent = currentName(); });
  nameDisplay.textContent = currentName();

  function statusRow(label, done) {
    return ''<div class="row"><span class="dot '' + (done ? "done" : "") + ''"></span><span class="label">'' + label + ''</span><span class="state '' + (done ? "ok" : "no") + ''">'' + (done ? "הושלם" : "לא הושלם") + "</span></div>";
  }
  function buildCertificateHtml(name) {
    var p = window.lessonProgress;
    var ex5 = esc($("ex5-answer").value.trim()) || "(לא הוזן קוד)";
    var ai = esc($("ex5-ai").value.trim()) || "(לא הוזן)";
    var dateStr = new Date().toLocaleDateString("he-IL");
    return ''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8">'' +
      "<title>תעודת תרגול — " + esc(name) + "</title>" +
      ''<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'' +
      ''<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@700;800;900&family=Assistant:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">'' +
      "<style>" +
      ":root{--bg:#12102A;--panel:#1D1A3D;--ink:#F5F3FF;--dim:#B4AEDB;--for:#FFB84D;--ok:#5CE1A6;--no:#FF6B6B;--line:rgba(245,243,255,.12);}" +
      "*{box-sizing:border-box;}body{margin:0;background:var(--bg);color:var(--ink);font-family:Assistant,sans-serif;font-size:16px;line-height:1.7;padding:50px 20px;}" +
      ".wrap{max-width:640px;margin:0 auto;}h1{font-family:Rubik,sans-serif;font-weight:900;font-size:2rem;margin:0 0 6px;}" +
      ".meta{color:var(--dim);margin-bottom:34px;font-size:15px;}h2{font-family:Rubik,sans-serif;font-weight:800;font-size:1.1rem;margin:0 0 14px;color:var(--for);}" +
      ".card{background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:20px 22px;margin-bottom:26px;}" +
      ".row{display:flex;align-items:center;gap:10px;padding:6px 0;}.dot{width:10px;height:10px;border-radius:50%;background:var(--no);flex-shrink:0;}.dot.done{background:var(--ok);}" +
      ".label{flex:1;font-size:15px;}.state{font-family:''JetBrains Mono'',monospace;font-size:13px;font-weight:600;}.state.ok{color:var(--ok);}.state.no{color:var(--no);}" +
      ".score{font-family:''JetBrains Mono'',monospace;font-size:15px;color:var(--dim);padding:6px 0;}.score strong{color:var(--ink);}" +
      "pre{direction:ltr;text-align:left;font-family:''JetBrains Mono'',monospace;font-size:13.5px;line-height:1.7;background:rgba(0,0,0,.28);border-radius:10px;padding:16px 18px;overflow-x:auto;white-space:pre-wrap;word-break:break-word;color:var(--ink);margin:0;}" +
      ".q{font-size:14.5px;color:var(--dim);margin:0 0 10px;}.txt{margin:12px 0 0;white-space:pre-wrap;}" +
      ''</style></head><body><div class="wrap">'' +
      "<h1>תעודת תרגול — רשימות בפייתון</h1>" +
      ''<div class="meta">שם: '' + esc(name) + " · תאריך: " + dateStr + "</div>" +
      ''<h2>תרגילים עם בדיקה</h2><div class="card">'' +
      statusRow("תרגיל 1 (אינדקס)", p.ex1) + statusRow("תרגיל 2 (פרוסה)", p.ex2) + statusRow("תרגיל 3 (שמות פעולות)", p.ex3) + statusRow("תרגיל 4 (עותק או הפניה)", p.ex4) +
      "</div>" +
      ''<h2>בלשית קוד</h2><div class="card"><div class="score">מקרים שנפתרו: <strong>'' + p.detectiveSolved + "</strong> מתוך " + p.detectiveTotal + "</div></div>" +
      ''<h2>תרגיל 5 · רשימת מטלות</h2><div class="card"><p class="q">התוכנית שלי, ומה ה-AI עשה אחרת:</p><pre>'' + ex5 + ''</pre><p class="txt">'' + ai + "</p></div>" +
      "</div></body></html>";
  }
  function blobDownload(filename, html) {
    try {
      var blob = new Blob([html], { type: "text/html;charset=utf-8" });
      var url = URL.createObjectURL(blob);
      var a = document.createElement("a");
      a.href = url; a.download = filename;
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setTimeout(function () { URL.revokeObjectURL(url); }, 1500);
      return true;
    } catch (e) { return false; }
  }
  btn.addEventListener("click", async function () {
    var name = currentName();
    var html = buildCertificateHtml(name);
    var filename = name + " - תעודת תרגול.html";
    if (typeof window.claude !== "undefined" && window.claude.use) {
      var downloads = null;
      try { downloads = await window.claude.use("downloads"); } catch (e) { downloads = null; }
      if (downloads) {
        try {
          var res = await downloads.save({ filename: filename, data: html });
          statusEl.textContent = res.status === "saved" ? "הקובץ נשמר! שלחו אותו אליי." : "הקובץ נשלח.";
          statusEl.className = "cert-status correct";
          return;
        } catch (err) {
          if (err && err.code === "declined") { statusEl.textContent = "ההורדה בוטלה."; statusEl.className = "cert-status wrong"; return; }
        }
      }
    }
    if (blobDownload(filename, html)) {
      statusEl.textContent = "הקובץ ירד! שלחו אותו אליי.";
      statusEl.className = "cert-status correct";
      return;
    }
    statusEl.textContent = "ההורדה האוטומטית לא עבדה כאן — הטקסט מוכן להעתקה למטה.";
    statusEl.className = "cert-status wrong";
    fallbackText.value = html; fallbackBox.hidden = false;
  });
})();
</script>

</body>
</html>
', 5, '2026-10-08T06:54:30.328Z');
