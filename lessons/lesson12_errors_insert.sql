DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='errors';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('4e3c4657a254aa74d3f266f81b0e1111', 'python-ai-era', 'errors', 'שיעור 11 - שגיאות (try / except)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שגיאות בפייתון: try / except</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;700;800;900&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #14121f;
    --bg-panel: #1d1a2d;
    --bg-panel-2: #26223b;
    --ink: #f4f1fa;
    --ink-dim: #bdb7d3;
    --ink-faint: #9e97ba;
    --for: #ffd27a;
    --for-soft: #413739;
    --while: #ff7f96;
    --while-soft: #412a3e;
    --success: #6fe0a0;
    --success-soft: #2a3a3f;
    --danger: #ff7f96;
    --danger-soft: #412a3e;
    --line: rgba(244,241,250,0.10);
    --line-strong: rgba(244,241,250,0.22);
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
      radial-gradient(600px 400px at 15% -5%, rgba(255,210,122,0.10), transparent 60%),
      radial-gradient(600px 400px at 100% 20%, rgba(255,127,150,0.10), transparent 60%),
      var(--bg);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 17px;
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
  }

  ::selection { background: var(--for); color: #14121f; }

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
  .tok-kw { color: #ff7f96; }
  .tok-str { color: #6fe0a0; unicode-bidi: isolate; }
  .iso { unicode-bidi: isolate; }
  .tok-num { color: #ffd27a; }
  .tok-fn { color: #8fb8ff; }
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

  .rf-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(280px,1fr)); gap:14px; margin-top:22px; }
  .rf { background:var(--bg-panel); border:1px solid var(--line); border-radius:14px; padding:16px 18px; display:flex; flex-direction:column; gap:8px; }
  .rf h4 { margin:0; font-family:var(--mono); font-size:15px; direction:ltr; text-align:left; color:var(--for); font-weight:700; }
  .rf p { margin:0; font-size:14.5px; color:var(--ink-dim); line-height:1.6; }
  .rf .ex { font-family:var(--mono); font-size:13.5px; direction:ltr; text-align:left; background:var(--code-bg); color:var(--code-ink); border-radius:8px; padding:8px 10px; }
  .rf .rr { display:flex; align-items:center; gap:10px; margin-top:auto; }
  .rf .res { font-family:var(--mono); font-size:14px; direction:ltr; color:var(--while); font-weight:700; min-height:20px; }
  .rf-title { margin-top:34px; font-size:1.25rem; font-weight:700; }
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

  .run-btn { font-family: var(--display); font-weight: 800; font-size: 15px; color: #14121f; background: var(--for); border: none; border-radius: 100px; padding: 12px 26px; }

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

  .tb { background:rgba(255,127,150,.07); border-inline-start:3px solid var(--danger); padding:10px 16px; margin:4px 0; line-height:1.7; }
  .tb span[data-p] { border-radius:4px; padding:0 3px; transition:background .2s; }
  .tb span[data-p].on { background:rgba(255,210,122,.28); outline:1px solid var(--for); }
  .tb-pills { display:flex; gap:8px; flex-wrap:wrap; padding:8px 0 0; direction:rtl; }
  .tb-note { padding:12px 24px; font-size:14.5px; color:var(--ink-dim); border-top:1px solid var(--line); line-height:1.7; }
  .net-status { padding:10px 24px; font-weight:700; font-size:15px; color:var(--ink-dim); border-top:1px solid var(--line); min-height:24px; }
  .net-status.good { color:var(--success); } .net-status.bad { color:var(--danger); }
  .playground-code .line { transition: background .25s; }
  .playground-code .line.run { background:rgba(255,210,122,.14); box-shadow:inset 3px 0 0 var(--for); }
  .playground-code .line.caught { background:var(--success-soft); box-shadow:inset 3px 0 0 var(--success); }
  .rf .res.bad2 { color:var(--danger); font-size:13px; white-space:normal; word-break:break-word; }
  .tok-str.he { direction:rtl; unicode-bidi:isolate; }
  .zg-msg { font-size:14.5px; font-weight:700; line-height:1.7; min-height:24px; }
  .zg-msg.good { color:var(--success); } .zg-msg.bad { color:var(--danger); }
  .pill.wrong { border-color:var(--danger); color:var(--danger); opacity:.6; }
  @keyframes shk { 20%{transform:translateX(-8px)} 40%{transform:translateX(8px)} 60%{transform:translateX(-5px)} 80%{transform:translateX(5px)} }
  .shake { animation: shk .45s; }
  @media (prefers-reduced-motion: reduce) { .shake { animation:none } }
</style>
<style>/* ===== engagement kit ===== */
.ek-progress{position:fixed;top:0;right:0;left:0;height:4px;z-index:9998;background:transparent;pointer-events:none}
.ek-progress i{display:block;height:100%;width:0;background:linear-gradient(90deg,var(--for,#ffd27a),var(--while,#ff7f96));border-radius:0 4px 4px 0;float:right;transition:width .15s}
.ek-hud{position:fixed;bottom:14px;right:14px;z-index:9997;display:flex;align-items:center;gap:10px;background:rgba(29,26,45,.92);backdrop-filter:blur(8px);border:1px solid var(--line-strong,rgba(255,255,255,.2));border-radius:999px;padding:8px 16px;font:700 14px var(--sans,sans-serif);color:var(--ink,#f4f1fa);box-shadow:0 8px 28px rgba(0,0,0,.35)}
.ek-hud .ek-star{font-size:18px;display:inline-block}
.ek-hud.pop .ek-star{animation:ekpop .6s}
.ek-hud .ek-lvl{color:var(--for,#ffd27a)}
@keyframes ekpop{30%{transform:scale(1.8) rotate(-15deg)}100%{transform:scale(1)}}
.ek-toast{position:fixed;bottom:70px;right:50%;transform:translate(50%,20px);opacity:0;z-index:9999;background:linear-gradient(135deg,var(--for,#ffd27a),var(--while,#ff7f96));color:#2a1f36;font:800 17px var(--display,sans-serif);padding:12px 24px;border-radius:999px;box-shadow:0 10px 30px rgba(0,0,0,.4);transition:.35s;pointer-events:none}
.ek-toast.show{opacity:1;transform:translate(50%,0)}
.ek-bit{position:fixed;z-index:9999;width:9px;height:9px;border-radius:2px;pointer-events:none;animation:ekfly 1s ease-out forwards}
@keyframes ekfly{to{transform:translate(var(--dx),var(--dy)) rotate(var(--rot));opacity:0}}
.ek-js .ek-reveal{opacity:0;transform:translateY(22px);transition:opacity .6s ease,transform .6s ease}
.ek-js .ek-reveal.in{opacity:1;transform:none}
.playground,.exercise,.code-card,.callout{transition:transform .25s,box-shadow .25s}
.playground:hover,.exercise:hover{transform:translateY(-3px);box-shadow:0 14px 34px rgba(0,0,0,.28)}
/* insight cards */
.ek-insight{display:flex;gap:16px;align-items:flex-start;margin:28px 0 0;padding:18px 22px;border-radius:20px;background:linear-gradient(135deg,rgba(255,210,122,.14),rgba(255,127,150,.12));border:1px dashed var(--for,#ffd27a);position:relative}
.ek-insight .ek-ic{font-size:34px;line-height:1;flex:none;animation:ekbob 3s ease-in-out infinite}
@keyframes ekbob{50%{transform:translateY(-5px) rotate(-6deg)}}
.ek-insight b.ek-tag{display:block;color:var(--for,#ffd27a);font:800 13px var(--display,sans-serif);letter-spacing:.04em;margin-bottom:4px}
.ek-insight p{margin:0;font-size:17px;line-height:1.7;color:var(--ink,#f4f1fa)}
.ek-insight code,.ek-insight .m{font-family:var(--mono,monospace);direction:ltr;unicode-bidi:isolate;background:rgba(0,0,0,.28);padding:1px 7px;border-radius:6px;font-size:.92em}
/* hero strip */
.ek-strip{margin:34px auto 0;max-width:760px}
.ek-cells{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;direction:ltr}
.ek-cell{min-width:86px;padding:12px 10px 10px;border-radius:16px;background:var(--bg-panel-2,#26223b);border:2px solid var(--line-strong,rgba(255,255,255,.2));text-align:center;cursor:pointer;transition:.3s;font-family:var(--mono,monospace);color:var(--ink,#f4f1fa)}
.ek-cell small{display:block;color:var(--ink-faint,#9e97ba);font-size:12px;margin-bottom:4px}
.ek-cell strong{font-size:22px}
.ek-cell.on{border-color:var(--for,#ffd27a);background:rgba(255,210,122,.16);transform:translateY(-8px) scale(1.07);box-shadow:0 12px 26px rgba(255,210,122,.2)}
.ek-cell.on small{color:var(--for,#ffd27a)}
.ek-cap{margin-top:16px;text-align:center;font:700 18px var(--mono,monospace);direction:ltr;color:var(--while,#ff7f96);min-height:28px}
.ek-hint{text-align:center;font-size:13px;color:var(--ink-faint,#9e97ba);margin-top:6px}
/* quiz */
.ek-quiz{display:grid;grid-template-columns:minmax(0,1fr);gap:18px;margin-top:22px}
.ek-q{min-width:0;background:var(--bg-panel,#1d1a2d);border:1px solid var(--line-strong,rgba(255,255,255,.2));border-radius:20px;padding:20px 22px}
.ek-q h3{margin:0 0 4px;font:800 18px var(--display,sans-serif);color:var(--ink,#f4f1fa)}
.ek-q pre{direction:ltr;text-align:left;background:#221F55;border-radius:14px;padding:12px 16px;margin:12px 0;overflow-x:auto;font:500 15px/1.6 var(--mono,monospace);color:#f4f1fa}
.ek-opts{display:grid;grid-template-columns:repeat(auto-fit,minmax(min(150px,100%),1fr));gap:10px}
.ek-opt{padding:11px 12px;border-radius:14px;border:2px solid var(--line-strong,rgba(255,255,255,.2));background:var(--bg-panel-2,#26223b);color:var(--ink,#f4f1fa);font:600 15px var(--mono,monospace);direction:ltr;cursor:pointer;transition:.2s}
.ek-opt:hover:not(:disabled){border-color:var(--for,#ffd27a);transform:translateY(-2px)}
.ek-opt.good{border-color:var(--success,#6fe0a0);background:rgba(111,224,160,.16)}
.ek-opt.bad{border-color:var(--danger,#ff7f96);background:rgba(255,127,150,.14);animation:ekshake .4s}
@keyframes ekshake{25%{transform:translateX(-6px)}75%{transform:translateX(6px)}}
.ek-why{margin-top:12px;font-size:15.5px;line-height:1.7;color:var(--ink-dim,#bdb7d3);min-height:0}
.ek-why.good{color:var(--success,#6fe0a0)}
.ek-why.bad{color:var(--danger,#ff7f96)}
@media (max-width:600px){.ek-hud{right:8px;bottom:8px;font-size:13px;padding:6px 12px}.ek-insight{flex-direction:column;gap:8px}.ek-cell{min-width:62px}}
</style>
</head>
<body>
<header class="hero">
  <div class="wrap">
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור · פייתון · מגמת מחשבים</div>
    <h1>כשהתוכנית קורסת:<br><span class="accent-for">שגיאות</span> <span class="accent-while">(try / except)</span></h1>
    <p class="hero-sub">כל מתכנתת רואה שגיאות כל יום, וגם הטובות ביותר. היום נלמד <strong>לקרוא אותן</strong>, להבין מה הן אומרות, ולגרום לתוכנית <strong>לא ליפול</strong>.</p>
    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre class="hl"><code>try:
    age = int(input("גיל? "))
except ValueError:
    print("זה לא מספר!")</code></pre>
    </div>
  </div>
</header>

<main>

  <section id="crash">
    <div class="wrap">
      <div class="eyebrow while-c">💥 הקריסה</div>
      <h2 class="section-title">תוכנית שנופלת</h2>
      <p class="lede">התוכנית הזאת מבקשת גיל ומדפיסה מה יהיה בשנה הבאה. כתבי גיל רגיל, ואחר כך כתבי אותיות במקום מספר, ותראי מה קורה.</p>

      <div class="playground" id="crash-box">
        <div class="playground-controls">
          <label for="cr-in">הקלידי גיל:</label>
          <input type="text" id="cr-in" value="16" autocomplete="off" class="num-in" style="width:120px;direction:ltr">
          <button class="run-btn" id="cr-run" type="button">הריצי</button>
          <div class="pill-row" id="cr-quick"></div>
        </div>
        <div class="playground-code" id="cr-code" style="border-top:0;margin-top:0"></div>
        <div class="log" id="cr-log" aria-live="polite"><div class="empty">לחצי "הריצי".</div></div>
        <div class="tb-note" id="cr-note" hidden></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🔎</span><div><b class="ek-tag">איך קוראים שגיאה</b><p>קוראים את השגיאה <b>מלמטה למעלה</b>. השורה האחרונה אומרת <b>איזה סוג</b> של בעיה ומה בדיוק. השורות שמעליה מראות <b>איפה</b> זה קרה.</p></div></div>
    </div>
  </section>

  <section id="zoo">
    <div class="wrap">
      <div class="eyebrow for-c">סוגי שגיאות</div>
      <h2 class="section-title">גן החיות של השגיאות</h2>
      <p class="lede">יש כמה שגיאות שחוזרות שוב ושוב. לכל אחת יש שם, ואם יודעים את השם, יודעים מה לחפש. לחצי "הריצי" ותראי איך כל אחת נראית.</p>
      <div class="rf-grid" id="zoo-grid"></div>

      <h3 class="rf-title">מי אשם? זהי את השגיאה</h3>
      <p class="lede" style="font-size:15px">מופיע קוד שקורס. בחרי איזו שגיאה הוא יזרוק. שש שאלות.</p>
      <div class="playground" id="zg">
        <div class="playground-controls"><label id="zg-title">שאלה 1 מתוך 6</label></div>
        <div class="playground-code" id="zg-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><div class="pill-row" id="zg-opts"></div></div>
        <div class="guess-row"><span class="zg-msg" id="zg-msg" role="status" aria-live="polite"></span></div>
      </div>
    </div>
  </section>

  <section id="net">
    <div class="wrap">
      <div class="eyebrow while-c">try / except</div>
      <h2 class="section-title">רשת הביטחון</h2>
      <p class="lede">אקרובטית עובדת עם רשת מתחתיה: אם היא נופלת, הרשת תופסת אותה וההצגה ממשיכה. ב-<span class="mono">try</span> כותבים את הקוד המסוכן, וב-<span class="mono">except</span> כותבים מה לעשות אם הוא נפל.</p>

      <div class="playground">
        <div class="playground-controls"><label>בחרי רשת:</label><div class="pill-row" id="net-tabs"></div></div>
        <div class="playground-code" id="net-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><label for="net-in" style="font-weight:700;font-size:15px">מה המשתמשת מקלידה:</label>
          <input type="text" id="net-in" value="5" autocomplete="off" class="num-in" style="width:110px;direction:ltr">
          <div class="pill-row" id="net-quick"></div>
          <button class="run-btn" id="net-run" type="button">הריצי</button></div>
        <div class="net-status" id="net-status" role="status" aria-live="polite">בחרי קלט והריצי.</div>
        <div class="log" id="net-log" aria-live="polite"><div class="empty">הפלט יופיע כאן.</div></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🛟</span><div><b class="ek-tag">איך זוכרים</b><p><span class="m">try</span> = מנסים. <span class="m">except</span> = אם נפלנו, נתפוס כאן. כל <span class="m">except</span> תופס רק את סוג השגיאה שכתבנו לידו, ואחרי התפיסה התוכנית <b>ממשיכה</b>.</p></div></div>
    </div>
  </section>

  <section id="again">
    <div class="wrap">
      <div class="eyebrow for-c">לולאה + try</div>
      <h2 class="section-title">עד שמצליחים</h2>
      <p class="lede">אפשר לשלב לולאה עם try: התוכנית שואלת שוב ושוב עד שהקלט תקין. <span class="mono">break</span> יוצאת מהלולאה רק כשהכול הצליח.</p>

      <div class="playground">
        <div class="playground-code" id="ag-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><label for="ag-in" style="font-weight:700;font-size:15px">גיל:</label>
          <input type="text" id="ag-in" autocomplete="off" class="num-in" style="width:120px;direction:ltr">
          <button class="run-btn" id="ag-send" type="button">שלחי</button>
          <button class="pill" id="ag-reset" type="button">↺ מההתחלה</button>
          <span class="diff-remaining" id="ag-count">ניסיונות: 0</span></div>
        <div class="log" id="ag-log" aria-live="polite"><div class="empty">נסי להקליד קודם אותיות, ואז מספר.</div></div>
      </div>
    </div>
  </section>

  <section id="bughunt">
    <div class="wrap">
      <div class="eyebrow while-c">תרגול</div>
      <h2 class="section-title">מצאי את הטעות</h2>
      <p class="lede">התוכנית הזאת מטפלת באותיות, אבל כשמקלידים 0 היא קורסת. מה מתקנים?</p>
      <div class="rescue" id="rescue1">
        <div class="rescue-head"><span class="rescue-mark">✗</span><h4>ZeroDivisionError: division by zero</h4></div>
<pre class="hl">try:
    x = int(input())
    print(100 / x)
except ValueError:
    print("לא מספר")</pre>
        <div class="rescue-choices">
          <button class="rescue-choice" type="button" data-ok="0">להחליף את <span class="mono">ValueError</span> ב-<span class="mono">ZeroDivisionError</span></button>
          <button class="rescue-choice" type="button" data-ok="1">להוסיף עוד <span class="mono">except ZeroDivisionError:</span> מתחת</button>
          <button class="rescue-choice" type="button" data-ok="0">למחוק את שורת ה-<span class="mono">try</span></button>
        </div>
        <div class="rescue-feedback" id="rescue1-fb" role="status" aria-live="polite"></div>
      </div>
    </div>
  </section>

  <section id="understanding">
    <div class="wrap">
      <div class="eyebrow">בדיקת הבנה</div>
      <h2 class="section-title">בדיקת הבנה קצרה</h2>
      <p class="lede">שלוש שאלות על מה שלמדנו. כל תשובה נכונה מוסיפה כוכב.</p>
      <div class="ek-quiz" id="ek-quiz-host"></div>
    </div>
  </section>

  <section id="exercises">
    <div class="wrap">
      <div class="exercises-banner">
        <span class="badge">תרגילים</span>
        <h2>תרגילים לכל הכיתה</h2>
        <p>שני תרגילים קצרים כאן, ושני תרגילים לכתוב ב-VS Code.</p>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 1</div>
        <div class="exercise-task">השלימי את המילה החסרה כך שהתוכנית תתפוס שגיאה של מספר לא תקין.</div>
        <div class="exercise-code"><span>try:
    n = int(input())
</span><input type="text" id="ex1-a" class="wide" autocomplete="off" aria-label="השלמה"><span> ValueError:
    print("לא מספר")</span></div>
        <div class="exercise-controls"><button class="exercise-check-btn" id="ex1-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex1-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 2</div>
        <div class="exercise-task">מה יודפס? כתבי בדיוק מה שמופיע על המסך.</div>
        <div class="exercise-code"><span>try:
    print("a" + 1)
except TypeError:
    print("oops")</span></div>
        <div class="exercise-controls"><input type="text" id="ex2-in" autocomplete="off" style="width:200px;direction:ltr" aria-label="התשובה"><button class="exercise-check-btn" id="ex2-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-divider">ב-VS Code</div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 3</div>
        <div class="exercise-task">מחשבון בטוח: בקשי מהמשתמשת שני מספרים וחלקי את הראשון בשני. אם הקלידו אותיות, הדפיסי "זה לא מספר". אם הקלידו 0 בתור המחלק, הדפיסי "אי אפשר לחלק ב-0". בלי שהתוכנית תקרוס.</div>
        <p class="exercise-note">רמז: שני <span class="mono">except</span> אחד אחרי השני, אחד לכל סוג שגיאה.</p>
        <textarea class="exercise-answer" rows="6" aria-label="התשובה לתרגיל 3" placeholder="הדביקי כאן את הקוד שלך"></textarea>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · אתגר</div>
        <div class="exercise-task">ניחוש מספר בטוח: התוכנית מגרילה מספר בין 1 ל-10 עם <span class="mono">random.randint</span>, ושואלת ניחוש שוב ושוב עד שהמשתמשת צודקת. אם היא מקלידה אותיות, התוכנית לא קורסת אלא מבקשת שוב.</div>
        <p class="exercise-note">רמז: <span class="mono">while True</span> עם <span class="mono">try</span> ו-<span class="mono">except ValueError</span> בפנים.</p>
        <textarea class="exercise-answer" rows="6" aria-label="התשובה לתרגיל 4" placeholder="הדביקי כאן את הקוד שלך"></textarea>
      </div>

      <div class="exercise-divider">הורדה ושליחה למורה</div>

      <div class="exercise-card">
        <div class="exercise-num">דף התרגילים</div>
        <div class="exercise-task">אפשר להוריד את כל התרגילים לקובץ, כדי לפתור אותם גם מחוץ לדף הזה.</div>
        <div class="exercise-controls"><button class="exercise-check-btn" id="sub-dl-ex" type="button">הורדת התרגילים</button></div>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">שליחה לבדיקה</div>
        <div class="exercise-task">כשסיימת, כתבי את שמך, הורידי את קובץ התשובות ושלחי אותו למורה. הקובץ כולל את מה שכתבת בכל ארבעת התרגילים.</div>
        <div class="exercise-controls"><input type="text" id="sub-name" autocomplete="off" placeholder="שם מלא" aria-label="שם מלא" style="width:200px"><button class="exercise-check-btn" id="sub-dl" type="button">הורדת התשובות שלי</button><span class="exercise-feedback" id="sub-fb" role="status" aria-live="polite"></span></div>
        <textarea id="sub-fallback" class="exercise-answer" rows="6" hidden readonly aria-label="העתקה ידנית"></textarea>
      </div>
    </div>
  </section>

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">מה למדנו</h2>
      <ul class="recap">
        <li>שגיאה קוראים מלמטה: השורה האחרונה אומרת איזה סוג שגיאה ומה בדיוק קרה.</li>
        <li>שגיאות נפוצות: <span class="mono">ValueError</span>, <span class="mono">TypeError</span>, <span class="mono">ZeroDivisionError</span>, <span class="mono">IndexError</span>, <span class="mono">KeyError</span>, <span class="mono">NameError</span>.</li>
        <li><span class="mono">try</span> מנסה, ו-<span class="mono">except</span> תופס את סוג השגיאה שכתבנו, והתוכנית ממשיכה.</li>
        <li>אפשר לכתוב כמה <span class="mono">except</span>, אחד לכל סוג שגיאה.</li>
        <li><span class="mono">while True</span> + <span class="mono">try</span> + <span class="mono">break</span>: שואלים שוב עד שהקלט תקין.</li>
      </ul>
    </div>
  </section>
</main>

<footer><div class="wrap">שיעור פייתון · שגיאות</div></footer>

<script>window.EK_CFG={"quiz": [{"t": "מה יודפס?", "code": "try:\n    print(10 / 2)\nexcept ZeroDivisionError:\n    print(\"oops\")\nprint(\"end\")", "opts": ["5.0 ואז end", "oops ואז end", "5.0 ואז oops", "שגיאה"], "ans": 0, "why": "אין שגיאה: 10 / 2 היא 5.0, ה-except מדלג, ואחרי כל הבלוק מודפס end.", "hint": "האם בכלל קרתה שגיאה?"}, {"t": "מה יודפס?", "code": "try:\n    x = int(\"abc\")\n    print(\"A\")\nexcept ValueError:\n    print(\"B\")\nprint(\"C\")", "opts": ["A ואז C", "B ואז C", "B בלבד", "שגיאה"], "ans": 1, "why": "int(\"abc\") נופלת עם ValueError לפני ש-A מודפס. ה-except מדפיס B, והתוכנית ממשיכה ל-C.", "hint": "ברגע שנופלים, הקוד שנשאר בתוך try מדולג."}, {"t": "מה יקרה?", "code": "try:\n    print(1 / 0)\nexcept ValueError:\n    print(\"caught\")", "opts": ["יודפס caught", "התוכנית תקרוס עם ZeroDivisionError", "יודפס 0", "לא יקרה כלום"], "ans": 1, "why": "ה-except תופס רק ValueError, אבל השגיאה היא ZeroDivisionError, ולכן היא לא נתפסת והתוכנית קורסת.", "hint": "איזה סוג שגיאה זורק חילוק ב-0?"}]};
(function(){
var $=function(i){return document.getElementById(i)};
var RM=window.matchMedia&&matchMedia(''(prefers-reduced-motion: reduce)'').matches;
function esc(s){return String(s).replace(/&/g,''&amp;'').replace(/</g,''&lt;'').replace(/>/g,''&gt;'')}
function highlight(code){
  return esc(code).replace(/(#.*$)|("[^"\n]*")|\b(try|except|while|break|True|False|if|else|for|in|import|from|as|def|return)\b|\b(print|int|input|float|len|range|str)\b|\b(\d+\.?\d*)\b/gm,function(m,c,s,k,f,n){
    if(c)return ''<span class="tok-cmt">''+c+''</span>'';
    if(s)return ''<span class="tok-str''+(/[\u0590-\u05FF]/.test(s)?'' he'':'''')+''">''+s+''</span>'';
    if(k)return ''<span class="tok-kw">''+k+''</span>'';
    if(f)return ''<span class="tok-fn">''+f+''</span>'';
    return ''<span class="tok-num">''+n+''</span>''});
}
function hlAll(){document.querySelectorAll(''pre.hl'').forEach(function(p){var t=p.textContent;p.innerHTML=''<code>''+highlight(t)+''</code>''})}
hlAll();
function row(el,code,res,bad){var e=el.querySelector(''.empty'');if(e)e.remove();var d=document.createElement(''div'');d.className=''row'';
  d.innerHTML=''<span><bdi>''+esc(code)+''</bdi></span>''+(res!==undefined?''<span class="arrow">→</span><span class="''+(bad?''bad'':''res'')+''">''+esc(res)+''</span>'':'''');el.appendChild(d);el.scrollTop=el.scrollHeight}
function pillRow(host,items,onclick){host.innerHTML='''';items.forEach(function(it,i){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.textContent=it;b.onclick=function(){onclick(i)};host.appendChild(b)})}
function activate(host,i){host.querySelectorAll(''.pill'').forEach(function(p,j){p.classList.toggle(''active'',i===j)})}
function codeLines(host,lines){host.innerHTML=lines.map(function(l,i){return ''<div class="line" data-i="''+i+''">''+highlight(l)+''</div>''}).join('''')}
function repr(s){var q=(s.indexOf("''")>-1&&s.indexOf(''"'')===-1)?''"'':"''";return q+s.replace(/\\/g,''\\\\'').replace(q==="''"?/''/g:/"/g,''\\''+q)+q}
function isInt(s){return /^\s*[+-]?\d+(_\d+)*\s*$/.test(s)}
function toInt(s){return parseInt(s.replace(/_/g,''''),10)}
function shake(el){if(RM)return;el.classList.remove(''shake'');void el.offsetWidth;el.classList.add(''shake'')}

// ---- crash ----
codeLines($(''cr-code''),[''age = int(input("מה הגיל שלך? "))'',''print("בשנה הבאה תהיי", age + 1)'']);
function crash(){
  var v=$(''cr-in'').value,log=$(''cr-log''),note=$(''cr-note'');log.innerHTML='''';note.hidden=true;
  var lines=$(''cr-code'').querySelectorAll(''.line'');lines.forEach(function(l){l.classList.remove(''err'')});
  if(isInt(v)){row(log,''בשנה הבאה תהיי ''+(toInt(v)+1));return}
  lines[0].classList.add(''err'');shake($(''crash-box''));
  var msg="invalid literal for int() with base 10: "+repr(v);
  log.innerHTML=''<div class="tb"><div>Traceback (most recent call last):</div><div>&nbsp;&nbsp;<span data-p="where">File "main.py", line 1</span>, in &lt;module&gt;</div><div>&nbsp;&nbsp;&nbsp;&nbsp;age = int(input("..."))</div><div><span data-p="kind">ValueError</span>: <span data-p="what">''+esc(msg)+''</span></div></div><div class="tb-pills" id="cr-pills"></div>'';
  var ex={where:[''איפה? שם הקובץ ומספר השורה שבה התוכנית נפלה: שורה 1.'',''where''],kind:[''איזה סוג? ValueError אומרת: קיבלתי ערך מהסוג הנכון (טקסט) אבל לא מתאים להמרה למספר.'',''kind''],what:[''מה בדיוק? הטקסט שהוקלד הוא זה שלא הצליח להפוך למספר.'',''what'']};
  var P=[[''איפה?'',''where''],[''איזה סוג?'',''kind''],[''מה בדיוק?'',''what'']],ph=$(''cr-pills'');
  P.forEach(function(p){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.textContent=p[0];b.onclick=function(){
    log.querySelectorAll(''[data-p]'').forEach(function(s){s.classList.toggle(''on'',s.dataset.p===p[1])});
    ph.querySelectorAll(''.pill'').forEach(function(x){x.classList.toggle(''active'',x===b)});
    note.hidden=false;note.textContent=ex[p[1]][0]};ph.appendChild(b)});
}
$(''cr-run'').onclick=crash;$(''cr-in'').onkeydown=function(e){if(e.key===''Enter'')crash()};
pillRow($(''cr-quick''),[''16'',''abc'',''12.5''],function(i){$(''cr-in'').value=[''16'',''abc'',''12.5''][i];crash()});

// ---- zoo ----
function refCards(gid,C){var g=$(gid);
  C.forEach(function(c){var d=document.createElement(''div'');d.className=''rf'';
    var h=document.createElement(''h4'');h.textContent=c[0];var p=document.createElement(''p'');p.textContent=c[1];
    var ex=document.createElement(''div'');ex.className=''ex'';ex.style.whiteSpace=''pre-wrap'';ex.textContent=c[2];
    var rr=document.createElement(''div'');rr.className=''rr'';var b=document.createElement(''button'');b.type=''button'';b.className=''run-btn'';b.textContent=''הריצי'';
    var r=document.createElement(''span'');r.className=''res bad2'';r.setAttribute(''aria-live'',''polite'');b.onclick=function(){r.textContent=c[3]};
    rr.appendChild(b);rr.appendChild(r);[h,p,ex,rr].forEach(function(x){d.appendChild(x)});g.appendChild(d)})}
refCards(''zoo-grid'',[
 [''ValueError'',''הערך מהסוג הנכון, אבל לא מתאים לפעולה. למשל להפוך אותיות למספר.'',''int("hello")'',''ValueError: invalid literal for int() with base 10: \''hello\''''],
 [''TypeError'',''ניסית פעולה על סוג מידע שלא מתאים, כמו לחבר טקסט ומספר.'',''"5" + 3'',''TypeError: can only concatenate str (not "int") to str''],
 [''ZeroDivisionError'',''חילוק ב-0. במתמטיקה אי אפשר, וגם בפייתון.'',''10 / 0'',''ZeroDivisionError: division by zero''],
 [''IndexError'',''ביקשת מקום ברשימה שלא קיים.'',''colors = ["red", "blue"]\nprint(colors[5])'',''IndexError: list index out of range''],
 [''KeyError'',''ביקשת מפתח שלא קיים במילון.'',''ages = {"dan": 16}\nprint(ages["rut"])'',''KeyError: \''rut\''''],
 [''NameError'',''השתמשת בשם שלא הגדרת (או שטעית באיות).'',''print(score)'',''NameError: name \''score\'' is not defined'']
]);
var ZG=[
 [''print(10 % 0)'',''ZeroDivisionError'',''שארית של חילוק ב-0 היא גם חילוק ב-0.''],
 [''nums = [1, 2, 3]\nprint(nums[3])'',''IndexError'',''ברשימה יש מקומות 0, 1, 2. מקום 3 לא קיים.''],
 [''int("12.5")'',''ValueError'',''"12.5" הוא טקסט של מספר עשרוני, ו-int לא יודעת להמיר אותו ישירות.''],
 [''price = 20\nprint("Price: " + price)'',''TypeError'',''אי אפשר לחבר טקסט ומספר עם +.''],
 [''d = {"a": 1}\nprint(d["b"])'',''KeyError'',''המפתח "b" לא קיים במילון.''],
 [''print(total)'',''NameError'',''total אף פעם לא הוגדר.'']
],ZN=[''ValueError'',''TypeError'',''ZeroDivisionError'',''IndexError'',''KeyError'',''NameError''],zi=0,zscore=0,ztry=0;
function zround(){
  if(zi>=ZG.length){$(''zg-title'').textContent=''סיימת!'';$(''zg-code'').innerHTML='''';$(''zg-opts'').innerHTML='''';
    $(''zg-msg'').className=''zg-msg good'';$(''zg-msg'').textContent=''זיהית נכון בניסיון ראשון ''+zscore+'' מתוך ''+ZG.length+''.'';return}
  $(''zg-title'').textContent=''שאלה ''+(zi+1)+'' מתוך ''+ZG.length;ztry=0;$(''zg-msg'').className=''zg-msg'';$(''zg-msg'').textContent='''';
  codeLines($(''zg-code''),ZG[zi][0].split(''\n''));
  pillRow($(''zg-opts''),ZN,function(j){
    var btn=$(''zg-opts'').children[j];
    if(ZN[j]===ZG[zi][1]){$(''zg-msg'').className=''zg-msg good'';$(''zg-msg'').textContent=''✔ ''+ZG[zi][1]+''. ''+ZG[zi][2];
      if(ztry===0){zscore++;if(window.EK_award)EK_award(btn)}
      $(''zg-opts'').querySelectorAll(''button'').forEach(function(x){x.disabled=true});zi++;setTimeout(zround,RM?1400:2200)}
    else{ztry++;btn.disabled=true;btn.classList.add(''wrong'');$(''zg-msg'').className=''zg-msg bad'';$(''zg-msg'').textContent=''לא ''+ZN[j]+''. נסי שוב.''}
  });
}
zround();

// ---- safety net ----
var NET=[
 {n:''בלי רשת'',lines:[''x = int(input("מספר: "))'',''print("התוצאה:", 100 / x)'',''print("סיימנו!")'']},
 {n:''רשת אחת'',lines:[''try:'',''    x = int(input("מספר: "))'',''    print("התוצאה:", 100 / x)'',''except ValueError:'',''    print("זה לא מספר!")'',''print("סיימנו!")'']},
 {n:''שתי רשתות'',lines:[''try:'',''    x = int(input("מספר: "))'',''    print("התוצאה:", 100 / x)'',''except ValueError:'',''    print("זה לא מספר!")'',''except ZeroDivisionError:'',''    print("אי אפשר לחלק ב-0!")'',''print("סיימנו!")'']}
],netCur=0,netBusy=false;
function fmtDiv(x){var r=100/x;return Number.isInteger(r)?r+''.0'':String(r)}
function netSim(m,v){
  var ok=isInt(v),x=ok?toInt(v):0,zero=ok&&x===0,res=ok&&!zero?fmtDiv(x):null,out=[],ran=[],crash=null,caught=null;
  if(m===0){ran.push(0);
    if(!ok)crash={i:0,msg:''ValueError: invalid literal for int() with base 10: ''+repr(v)};
    else{ran.push(1);if(zero)crash={i:1,msg:''ZeroDivisionError: division by zero''};else{out.push(''התוצאה: ''+res);ran.push(2);out.push(''סיימנו!'')}}}
  else{ran.push(0,1);
    if(!ok){ran.push(3,4);out.push(''זה לא מספר!'');caught=''ValueError'';ran.push(m===1?5:7);out.push(''סיימנו!'')}
    else{ran.push(2);
      if(zero){if(m===2){ran.push(5,6,7);out.push(''אי אפשר לחלק ב-0!'');caught=''ZeroDivisionError'';out.push(''סיימנו!'')}else crash={i:2,msg:''ZeroDivisionError: division by zero''}}
      else{out.push(''התוצאה: ''+res);ran.push(m===1?5:7);out.push(''סיימנו!'')}}}
  return {ran:ran,out:out,crash:crash,caught:caught};
}
function netRender(){codeLines($(''net-code''),NET[netCur].lines);$(''net-log'').innerHTML=''<div class="empty">הפלט יופיע כאן.</div>'';$(''net-status'').className=''net-status'';$(''net-status'').textContent=''בחרי קלט והריצי.''}
function netRun(){
  if(netBusy)return;var r=netSim(netCur,$(''net-in'').value),lines=$(''net-code'').querySelectorAll(''.line''),log=$(''net-log''),st=$(''net-status'');
  lines.forEach(function(l){l.classList.remove(''run'',''err'',''caught'')});log.innerHTML='''';st.className=''net-status'';st.textContent=''רצה...'';
  netBusy=true;var k=0;
  function finish(){
    r.out.forEach(function(o){row(log,o)});
    if(r.crash){row(log,r.crash.msg,undefined);log.lastChild.firstChild.className=''bad'';
      lines[r.crash.i].classList.add(''err'');st.className=''net-status bad'';st.textContent=''💥 התוכנית קרסה, והשורה האחרונה לא הודפסה.'';shake($(''net-code''))}
    else if(r.caught){st.className=''net-status good'';st.textContent=''🛟 ''+r.caught+'' נתפסה, והתוכנית המשיכה עד הסוף.''}
    else{st.className=''net-status good'';st.textContent=''✅ הכול עבד, ולא הייתה שגיאה.''}
    netBusy=false}
  function step(){
    if(k>=r.ran.length||(r.crash&&k>r.ran.length-1)){finish();return}
    var i=r.ran[k++];lines[i].classList.add(''run'');
    if(r.caught&&/^except/.test(NET[netCur].lines[i]))lines[i].classList.add(''caught'');
    if(RM)step();else setTimeout(step,330)}
  step();
}
pillRow($(''net-tabs''),NET.map(function(x){return x.n}),function(i){if(netBusy)return;netCur=i;activate($(''net-tabs''),i);netRender()});
activate($(''net-tabs''),0);netRender();
pillRow($(''net-quick''),[''5'',''abc'',''0''],function(i){$(''net-in'').value=[''5'',''abc'',''0''][i];netRun()});
$(''net-run'').onclick=netRun;$(''net-in'').onkeydown=function(e){if(e.key===''Enter'')netRun()};

// ---- again ----
codeLines($(''ag-code''),[''while True:'',''    try:'',''        age = int(input("גיל: "))'',''        break'',''    except ValueError:'',''        print("זה לא מספר, נסי שוב")'',''print("הגיל שלך:", age)'']);
var agN=0,agDone=false;
function agSend(){
  if(agDone)return;var v=$(''ag-in'').value,log=$(''ag-log'');agN++;$(''ag-count'').textContent=''ניסיונות: ''+agN;
  row(log,''גיל: ''+v);
  var L=$(''ag-code'').querySelectorAll(''.line'');L.forEach(function(l){l.classList.remove(''run'',''caught'')});
  if(isInt(v)){L[1].classList.add(''run'');L[2].classList.add(''run'');L[3].classList.add(''run'');row(log,''הגיל שלך: ''+toInt(v));agDone=true;
    var d=document.createElement(''div'');d.className=''row'';d.innerHTML=''<span class="res">✔ break: יצאנו מהלולאה אחרי ''+agN+'' ניסיונות.</span>'';log.appendChild(d);
    if(window.EK_award)EK_award($(''ag-send''))}
  else{L[1].classList.add(''run'');L[2].classList.add(''err'');L[4].classList.add(''caught'');L[5].classList.add(''run'');row(log,''זה לא מספר, נסי שוב'')}
  $(''ag-in'').value='''';$(''ag-in'').focus();
}
$(''ag-send'').onclick=agSend;$(''ag-in'').onkeydown=function(e){if(e.key===''Enter'')agSend()};
$(''ag-reset'').onclick=function(){agN=0;agDone=false;$(''ag-count'').textContent=''ניסיונות: 0'';$(''ag-log'').innerHTML=''<div class="empty">נסי להקליד קודם אותיות, ואז מספר.</div>'';$(''ag-code'').querySelectorAll(''.line'').forEach(function(l){l.classList.remove(''run'',''err'',''caught'')})};

// ---- bug hunt ----
var rs=$(''rescue1'');
rs.querySelectorAll(''.rescue-choice'').forEach(function(b){b.onclick=function(){
  var fb=$(''rescue1-fb'');
  if(b.dataset.ok===''1''){b.classList.add(''right'');rs.classList.add(''fixed'');rs.querySelector(''.rescue-mark'').textContent=''✓'';
    rs.querySelectorAll(''.rescue-choice'').forEach(function(x){x.disabled=true});
    fb.className=''rescue-feedback correct'';fb.textContent=''נכון! לכל סוג שגיאה צריך except משלו, ואפשר לכתוב כמה שצריך.''}
  else{b.classList.add(''wrong'');b.disabled=true;fb.className=''rescue-feedback wrong'';fb.textContent=''לא בדיוק. אז אותיות יפילו שוב את התוכנית, ובלי try השגיאה לא תיתפס בכלל. צריך לתפוס את שני הסוגים.''}
}});

// ---- download / submit ----
(function(){
  var Q=[
    [''תרגיל 1'',''השלימי את המילה החסרה כך שהתוכנית תתפוס שגיאה של מספר לא תקין.'',''try:\n    n = int(input())\n______ ValueError:\n    print("לא מספר")''],
    [''תרגיל 2'',''מה יודפס?'',''try:\n    print("a" + 1)\nexcept TypeError:\n    print("oops")''],
    [''תרגיל 3 (ב-VS Code)'',''מחשבון בטוח: בקשי שני מספרים וחלקי את הראשון בשני. אותיות: הדפיסי "זה לא מספר". מחלק 0: הדפיסי "אי אפשר לחלק ב-0". בלי שהתוכנית תקרוס.'',''''],
    [''תרגיל 4 · אתגר (ב-VS Code)'',''ניחוש מספר בטוח: מגרילים מספר בין 1 ל-10 עם random.randint, ושואלים ניחוש שוב ושוב עד שצודקת. אותיות לא קורסות אלא מבקשות שוב.'','''']];
  function E(t){return String(t).replace(/[&<>"]/g,function(c){return{''&'':''&amp;'',''<'':''&lt;'',''>'':''&gt;'',''"'':''&quot;''}[c]})}
  var CSS=''<style>body{font-family:Arial,sans-serif;max-width:760px;margin:30px auto;padding:0 16px;line-height:1.7;color:#222}h1{font-size:24px}.q{border:1px solid #bbb;border-radius:8px;padding:12px 18px;margin:16px 0;page-break-inside:avoid}pre{background:#f3f3f3;padding:10px;direction:ltr;text-align:left;white-space:pre-wrap;border-radius:6px}.a{min-height:90px;border:1px dashed #999;border-radius:6px;margin-top:8px}.ok{color:#0a7a2f;font-weight:bold}.no{color:#b3261e;font-weight:bold}</style>'';
  function save(html,name,fb,fbEl){
    try{var b=new Blob([html],{type:''text/html;charset=utf-8''}),u=URL.createObjectURL(b),a=document.createElement(''a'');a.href=u;a.download=name;document.body.appendChild(a);a.click();a.remove();setTimeout(function(){URL.revokeObjectURL(u)},1500);return true}
    catch(e){return false}}
  document.getElementById(''sub-dl-ex'').onclick=function(){
    var h=''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>תרגילי שגיאות</title>''+CSS+''</head><body><h1>תרגילי שגיאות בפייתון</h1><p>שם: ______________________</p>'';
    Q.forEach(function(q){h+=''<div class="q"><b>''+E(q[0])+''</b><br>''+E(q[1])+(q[2]?''<pre>''+E(q[2])+''</pre>'':'''')+''<div class="a"></div></div>''});
    save(h+''</body></html>'',''python-errors-exercises.html'')};
  document.getElementById(''sub-dl'').onclick=function(){
    var name=document.getElementById(''sub-name'').value.trim(),fb=document.getElementById(''sub-fb''),fbk=document.getElementById(''sub-fallback'');
    if(!name){fb.className=''exercise-feedback'';fb.textContent=''קודם כתבי את שמך.'';return}
    var a1=document.getElementById(''ex1-a'').value.trim(),a2=document.getElementById(''ex2-in'').value.trim(),
      a3=document.querySelector(''[aria-label="התשובה לתרגיל 3"]'').value,a4=document.querySelector(''[aria-label="התשובה לתרגיל 4"]'').value,
      ok1=a1===''except'',ok2=a2.replace(/^["'']|["'']$/g,'''')===''oops'';
    function mark(ok,v){return v?''<span class="''+(ok?''ok'':''no'')+''">''+(ok?''נכון'':''לא נכון'')+''</span>'':''<span class="no">לא נענה</span>''}
    var date=new Date().toLocaleDateString(''he-IL'');
    var h=''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>תשובות: ''+E(name)+''</title>''+CSS+''</head><body><h1>תרגילי שגיאות: ''+E(name)+''</h1><p>תאריך: ''+E(date)+''</p>''
     +''<div class="q"><b>''+Q[0][0]+''</b><pre>''+E(Q[0][2])+''</pre>תשובה (המילה החסרה): <pre>''+E(a1||''(ריק)'')+''</pre>''+mark(ok1,a1)+''</div>''
     +''<div class="q"><b>''+Q[1][0]+''</b><pre>''+E(Q[1][2])+''</pre>תשובה: <pre>''+E(a2||''(ריק)'')+''</pre>''+mark(ok2,a2)+''</div>''
     +''<div class="q"><b>''+Q[2][0]+''</b><pre>''+E(a3||''(לא נענה)'')+''</pre></div>''
     +''<div class="q"><b>''+Q[3][0]+''</b><pre>''+E(a4||''(לא נענה)'')+''</pre></div></body></html>'';
    if(save(h,''python-errors-answers.html'')){fb.className=''exercise-feedback correct'';fb.textContent=''הקובץ ירד! שלחי אותו למורה.''}
    else{fb.className=''exercise-feedback'';fb.textContent=''ההורדה לא עבדה. העתיקי את הטקסט שלמטה ושמרי כקובץ html.'';fbk.hidden=false;fbk.value=h}};
})();

// דיווח התקדמות לאתר שמציג את השיעור (window.reportProgress מוזרק על ידיו; בקובץ שנפתח לבד אין אותו). תרגילי החובה: 1 ו-2.
var exSolved={};
function reportEx(){if(window.reportProgress)window.reportProgress(Object.keys(exSolved).length,2)}
reportEx();
function chk(btn,fn,fbId,okMsg,badMsg){$(btn).onclick=function(){var f=$(fbId);if(fn()){f.className=''exercise-feedback correct'';f.textContent=okMsg;exSolved[btn]=true;reportEx()}else{f.className=''exercise-feedback wrong'';f.textContent=badMsg}}}
chk(''ex1-btn'',function(){return $(''ex1-a'').value.trim()===''except''},''ex1-feedback'',''נכון! except תופסת את השגיאה.'',''לא בדיוק. איזו מילה באה אחרי try כדי לתפוס שגיאה?'');
chk(''ex2-btn'',function(){return $(''ex2-in'').value.trim().replace(/^["'']|["'']$/g,'''')===''oops''},''ex2-feedback'',''נכון! "a" + 1 זורקת TypeError, וה-except תופס אותה ומדפיס oops.'',''לא בדיוק. "a" + 1 היא טקסט + מספר. איזה סוג שגיאה זה, ומה ה-except מדפיס?'');
})();

(function(){
  var C=window.EK_CFG||{},doc=document,stars=0;
  var RM=window.matchMedia&&matchMedia(''(prefers-reduced-motion: reduce)'').matches;
  doc.documentElement.classList.add(''ek-js'');
  // progress
  var pr=doc.createElement(''div'');pr.className=''ek-progress'';pr.innerHTML=''<i></i>'';doc.body.appendChild(pr);
  function onScroll(){var h=doc.documentElement.scrollHeight-innerHeight;pr.firstChild.style.width=(h>0?Math.min(100,scrollY/h*100):0)+''%''}
  addEventListener(''scroll'',onScroll,{passive:true});onScroll();
  // hud
  var hud=doc.createElement(''div'');hud.className=''ek-hud'';hud.setAttribute(''aria-live'',''polite'');
  hud.innerHTML=''<span class="ek-star">⭐</span><span id="ek-n">0</span><span class="ek-lvl" id="ek-l"></span>'';doc.body.appendChild(hud);
  var LV=[[0,''מתחילה''],[3,''חוקרת''],[6,''מפתחת''],[10,''מומחית'']];
  function lvl(){var t='''';LV.forEach(function(l){if(stars>=l[0])t=l[1]});return t}
  doc.getElementById(''ek-l'').textContent=lvl();
  var toast=doc.createElement(''div'');toast.className=''ek-toast'';doc.body.appendChild(toast);
  var PR=[''יפה מאוד! 🎉'',''בול! 👏'',''את על זה! 🚀'',''מדויק! ✨'',''כל הכבוד! 💪'',''וואו, מצוין! 🌟''],pi=0,tt;
  function burst(x,y){
    if(RM)return;var cols=[''#ffd27a'',''#ff7f96'',''#6fe0a0'',''#8b6bff'',''#5bd1ff''];
    for(var i=0;i<22;i++){var b=doc.createElement(''i'');b.className=''ek-bit'';
      var a=Math.random()*6.28,d=60+Math.random()*110;
      b.style.cssText=''left:''+x+''px;top:''+y+''px;background:''+cols[i%5]+'';--dx:''+Math.cos(a)*d+''px;--dy:''+(Math.sin(a)*d-40)+''px;--rot:''+Math.random()*540+''deg'';
      doc.body.appendChild(b);setTimeout(function(e){e.remove()},1100,b)}
  }
  function award(el){
    stars++;doc.getElementById(''ek-n'').textContent=stars;doc.getElementById(''ek-l'').textContent=lvl();
    hud.classList.remove(''pop'');void hud.offsetWidth;hud.classList.add(''pop'');
    toast.textContent=PR[pi++%PR.length]+'' ⭐ ''+stars;toast.classList.add(''show'');clearTimeout(tt);tt=setTimeout(function(){toast.classList.remove(''show'')},1800);
    var r=(el||hud).getBoundingClientRect();burst(r.left+r.width/2,r.top+r.height/2);
  }
  window.EK_award=award;
  // watch feedback elements
  var seen={},auto=0;
  var SEL=''.guess-feedback,.exercise-feedback,.rescue-feedback,.gv-fb'';
  function check(el){
    if(!el.matches||!el.matches(SEL))return;
    if(!(el.classList.contains(''correct'')||el.classList.contains(''good'')))return;
    var k=el.id||el.dataset.ek||(el.dataset.ek=''a''+(auto++));
    if(seen[k])return;seen[k]=1;award(el);
  }
  new MutationObserver(function(ms){ms.forEach(function(m){check(m.target)})}).observe(doc.body,{attributes:true,attributeFilter:[''class''],subtree:true});
  // reveal
  var targets=doc.querySelectorAll(''section .wrap > *, .hero .wrap > *'');
  if(''IntersectionObserver'' in window&&!RM){
    var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add(''in'');io.unobserve(e.target)}})},{threshold:.08});
    targets.forEach(function(t){t.classList.add(''ek-reveal'');io.observe(t)});
    setTimeout(function(){targets.forEach(function(t){t.classList.add(''in'')})},6000);
  }
  // hero strip
  if(C.strip){
    var s=C.strip,host=doc.querySelector(''.hero .wrap''),box=doc.createElement(''div'');box.className=''ek-strip'';
    box.innerHTML=''<div class="ek-cells">''+s.cells.map(function(c,i){return ''<div class="ek-cell" tabindex="0" data-i="''+i+''"><small>''+c[0]+''</small><strong>''+c[1]+''</strong></div>''}).join('''')+''</div><div class="ek-cap" aria-live="polite"></div><div class="ek-hint">''+s.hint+''</div>'';
    host.appendChild(box);
    var cells=box.querySelectorAll(''.ek-cell''),cap=box.querySelector(''.ek-cap''),cur=0,timer;
    function show(i){cells.forEach(function(c,j){c.classList.toggle(''on'',i===j)});cap.textContent=s.cap(i,s.cells[i])}
    function loop(){clearInterval(timer);timer=setInterval(function(){cur=(cur+1)%cells.length;show(cur)},1600)}
    cells.forEach(function(c,i){var f=function(){cur=i;show(i);loop()};c.addEventListener(''click'',f);c.addEventListener(''keydown'',function(e){if(e.key===''Enter''||e.key==='' ''){e.preventDefault();f()}})});
    show(0);if(!RM)loop();
  }
  // quiz
  var qz=doc.querySelector(''#ek-quiz-host'');
  if(qz&&C.quiz){
    var done=0;
    C.quiz.forEach(function(q,qi){
      var d=doc.createElement(''div'');d.className=''ek-q'';
      d.innerHTML=''<h3>''+(qi+1)+''. ''+q.t+''</h3><pre>''+q.code.replace(/&/g,''&amp;'').replace(/</g,''&lt;'')+''</pre><div class="ek-opts"></div><div class="ek-why" role="status" aria-live="polite"></div>'';
      var o=d.querySelector(''.ek-opts''),why=d.querySelector(''.ek-why''),solved=false;
      q.opts.forEach(function(t,oi){var b=doc.createElement(''button'');b.type=''button'';b.className=''ek-opt'';b.textContent=t;
        b.onclick=function(){
          if(solved)return;
          if(oi===q.ans){solved=true;b.classList.add(''good'');why.className=''ek-why good'';why.textContent=''✔ ''+q.why;o.querySelectorAll(''button'').forEach(function(x){x.disabled=true});award(b);done++}
          else{b.classList.add(''bad'');b.disabled=true;why.className=''ek-why bad'';why.textContent=''לא בדיוק. ''+(q.hint||''נסי שוב.'')}
        };o.appendChild(b)});
      qz.appendChild(d);
    });
  }
})();
</script>
</body>
</html>
', 11, '2026-11-01T00:00:00.000Z');
