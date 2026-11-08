DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='course-summary';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('62cd2a0a3bc0066a10d94c7b75788bf6', 'python-ai-era', 'course-summary', 'שיעור סיכום - כל הקורס במקום אחד', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>סיכום הקורס: כל מה שלמדנו</title>
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
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור סיכום · פייתון · מגמת מחשבים</div>
    <h1>סיכום הקורס:<br><span class="accent-for">כל מה שלמדנו</span> <span class="accent-while">במקום אחד</span></h1>
    <p class="hero-sub">התחלנו ב-<span class="mono">print</span> אחד, ועכשיו אפשר לכתוב תוכניות שמחליטות, חוזרות, זוכרות ולא קורסות. בשיעור הזה <strong>מחברים הכול</strong>, בודקים מה נשאר, ומתרגלים את מה שחשוב באמת.</p>
    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre class="hl"><code>topics = ["print", "if", "for", "list", "dict", "def", "str", "import", "try", "open"]
for t in topics:
    print("✓", t)</code></pre>
    </div>
  </div>
</header>

<main>

  <section id="map">
    <div class="wrap">
      <div class="eyebrow for-c">מפת הקורס</div>
      <h2 class="section-title">אחד עשר כלים בארגז</h2>
      <p class="lede">כל שיעור הוסיף לארגז כלי אחד. לכל כלי יש כאן כרטיס עם דוגמה קצרה. נסי לנחש מה היא תדפיס, ואז לחצי "הריצי" כדי לבדוק.</p>
      <div class="rf-grid" id="map-grid"></div>
      <div class="ek-insight"><span class="ek-ic">🧰</span><div><b class="ek-tag">איך זוכרים</b><p>אין צורך לשנן הכול. צריך לדעת <b>שהכלי קיים</b> ומה הוא עושה, ואת הפרטים אפשר תמיד לבדוק. מי שיודעת שיש <span class="m">try</span> יודעת לחפש אותו.</p></div></div>
    </div>
  </section>

  <section id="program">
    <div class="wrap">
      <div class="eyebrow while-c">הכול ביחד</div>
      <h2 class="section-title">תוכנית אחת, כל הנושאים</h2>
      <p class="lede">תוכנית אמיתית כמעט אף פעם לא משתמשת בכלי אחד. זו תוכנית קצרה שנותנת ציונים לתלמידות. לחצי על נושא כדי לראות אילו שורות שייכות לו, ואז הריצי אותה.</p>

      <div class="playground">
        <div class="playground-controls"><label>הדגישי נושא:</label><div class="pill-row" id="pg-topics"></div></div>
        <div class="playground-code" id="pg-code" style="border-top:0;margin-top:0"></div>
        <div class="tb-note" id="pg-note">בחרי נושא כדי לראות את השורות שלו.</div>
        <div class="field-row"><button class="run-btn" id="pg-run" type="button">▶ הרצת התוכנית</button></div>
        <div class="log" id="pg-log" aria-live="polite"><div class="empty">הפלט יופיע כאן.</div></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🧩</span><div><b class="ek-tag">שימי לב</b><p>שורה אחת יכולה להשתייך לכמה נושאים. למשל <span class="m">scores[name]</span> היא גם מילון וגם חלק מ-<span class="m">try</span>. מתכנתות לא חושבות "איזה שיעור זה", אלא "איזה כלי פותר את הבעיה".</p></div></div>
    </div>
  </section>

  <section id="choose">
    <div class="wrap">
      <div class="eyebrow for-c">איזה כלי?</div>
      <h2 class="section-title">מה בוחרים?</h2>
      <p class="lede">הקושי האמיתי בתכנות הוא לא לכתוב את הקוד, אלא לדעת באיזה כלי להשתמש. מופיעה בעיה. בחרי את הכלי שהכי מתאים לה. תשע שאלות.</p>
      <div class="playground" id="ch">
        <div class="playground-controls"><label id="ch-title">שאלה 1 מתוך 9</label></div>
        <div class="playground-note" id="ch-q" style="font-size:17px;color:var(--ink);padding-top:18px;min-height:64px"></div>
        <div class="field-row"><div class="pill-row" id="ch-opts"></div></div>
        <div class="guess-row"><span class="zg-msg" id="ch-msg" role="status" aria-live="polite"></span></div>
      </div>
    </div>
  </section>

  <section id="bughunt">
    <div class="wrap">
      <div class="eyebrow while-c">תרגול</div>
      <h2 class="section-title">מצאי את הטעות</h2>
      <p class="lede">התוכנית אמורה להדפיס את הסכום של הרשימה, כלומר 60. במקום זה היא מדפיסה 30. מה מתקנים?</p>
      <div class="rescue" id="rescue1">
        <div class="rescue-head"><span class="rescue-mark">✗</span><h4>מודפס 30 במקום 60</h4></div>
<pre class="hl">nums = [10, 20, 30]
total = 0
for n in nums:
    total = n
print(total)</pre>
        <div class="rescue-choices">
          <button class="rescue-choice" type="button" data-ok="0">להחליף את <span class="mono">0</span> ב-<span class="mono">1</span> בשורה השנייה</button>
          <button class="rescue-choice" type="button" data-ok="1">לכתוב <span class="mono">total = total + n</span> בתוך הלולאה</button>
          <button class="rescue-choice" type="button" data-ok="0">להזיז את ה-<span class="mono">print</span> לתוך הלולאה</button>
        </div>
        <div class="rescue-feedback" id="rescue1-fb" role="status" aria-live="polite"></div>
      </div>
    </div>
  </section>

  <section id="understanding">
    <div class="wrap">
      <div class="eyebrow">בדיקת הבנה</div>
      <h2 class="section-title">בדיקת הבנה קצרה</h2>
      <p class="lede">חמש שאלות מכל הקורס. כל תשובה נכונה מוסיפה כוכב.</p>
      <div class="ek-quiz" id="ek-quiz-host"></div>
    </div>
  </section>

  <section id="exercises">
    <div class="wrap">
      <div class="exercises-banner">
        <span class="badge">תרגילים</span>
        <h2>תרגילי סיכום</h2>
        <p>שני תרגילים קצרים כאן, ושני תרגילים לכתוב ב-VS Code. בתרגיל 3 משתמשים כמעט בכל מה שלמדנו.</p>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 1</div>
        <div class="exercise-task">השלימי את המילה החסרה כדי להגדיר פונקציה.</div>
        <div class="exercise-code"><input type="text" id="ex1-a" class="wide" style="width:70px;direction:ltr;text-align:center" autocomplete="off" aria-label="השלמה"><span> square(x):
    return x * x</span></div>
        <div class="exercise-controls"><button class="exercise-check-btn" id="ex1-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex1-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 2</div>
        <div class="exercise-task">מה יודפס? כתבי מספר.</div>
        <div class="exercise-code"><span>d = {"a": 1, "b": 2}
d["c"] = 3
d["a"] = 10
print(len(d))</span></div>
        <div class="exercise-controls"><input type="text" id="ex2-in" autocomplete="off" style="width:120px;direction:ltr" aria-label="התשובה" placeholder="מספר"><button class="exercise-check-btn" id="ex2-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-divider">ב-VS Code</div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 3</div>
        <div class="exercise-task">מחברת ציונים: התוכנית שואלת שם ואחר כך ציון, שוב ושוב, עד שהמשתמשת מקלידה <span class="mono">stop</span> בתור שם. הציונים נשמרים במילון. אם הציון אינו מספר, מדפיסים הודעה ושואלים שוב. בסוף עוברים על המילון, ולכל תלמידה מדפיסים את שמה (אות ראשונה גדולה) ואת הדרגה שלה לפי פונקציה: 90 ומעלה A, 56 ומעלה pass, אחרת fail.</div>
        <p class="exercise-note">רמז: <span class="mono">while True</span>, <span class="mono">try</span> עם <span class="mono">except ValueError</span>, <span class="mono">def grade(score)</span>, ו-<span class="mono">.title()</span> לשם.</p>
        <textarea class="exercise-answer" rows="8" aria-label="התשובה לתרגיל 3" placeholder="הדביקי כאן את הקוד שלך"></textarea>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · אתגר</div>
        <div class="exercise-task">הוסיפי לתרגיל 3 עוד שני דברים בסוף התוכנית: הדפיסי את שם התלמידה עם הציון הגבוה ביותר, ובחרי תלמידה אחת באקראי עם <span class="mono">random.choice</span> שתהיה "התלמידה של היום".</div>
        <p class="exercise-note">רמז: משתנים <span class="mono">best_name</span> ו-<span class="mono">best_score</span> שמתעדכנים בתוך הלולאה כשמוצאים ציון גבוה יותר. לבחירה אקראית צריך רשימה, ואפשר להשיג אותה עם <span class="mono">list(scores)</span>.</p>
        <textarea class="exercise-answer" rows="8" aria-label="התשובה לתרגיל 4" placeholder="הדביקי כאן את הקוד שלך"></textarea>
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
      <h2 class="section-title">דף עזר לכל הקורס</h2>
      <ul class="recap">
        <li><span class="mono">print()</span> מדפיסה, ו-<span class="mono">input()</span> שואלת ומחזירה תמיד טקסט. כדי לחשב עם מספר: <span class="mono">int(input())</span>.</li>
        <li><span class="mono">if</span> / <span class="mono">elif</span> / <span class="mono">else</span>: פייתון בודקת מלמעלה ומריצה רק את הענף הראשון שנכון.</li>
        <li><span class="mono">for</span> עוברת על רשימה או על <span class="mono">range</span>, ו-<span class="mono">while</span> חוזרת כל עוד התנאי נכון. מה שמוזח מתחתיהן הוא מה שחוזר.</li>
        <li>for מקוצר: <span class="mono">[n * 2 for n in nums if n &gt; 2]</span> בונה רשימה בשורה אחת.</li>
        <li>רשימה: <span class="mono">[ ]</span>, אינדקס מ-0, <span class="mono">-1</span> האחרון, <span class="mono">append</span> מוסיפה, <span class="mono">len</span> סופרת.</li>
        <li>מילון: זוגות <span class="mono">מפתח: ערך</span>. מפתח שלא קיים גורם ל-<span class="mono">KeyError</span>.</li>
        <li>פונקציה: <span class="mono">def</span> מגדירה, <span class="mono">return</span> מחזירה ערך החוצה, ו-<span class="mono">print</span> רק מציגה.</li>
        <li>מחרוזת: אינדקסים ופרוסות, שיטות כמו <span class="mono">upper</span>, <span class="mono">strip</span>, <span class="mono">replace</span>, ו-f-string כמו <span class="mono">f"Hi {name}"</span>.</li>
        <li>מודולים: <span class="mono">import</span> מביא ארגז כלים (<span class="mono">random</span>, <span class="mono">math</span>), ו-<span class="mono">pip</span> מתקין מודולים חדשים.</li>
        <li>שגיאות: קוראים מלמטה. <span class="mono">try</span> מנסה, <span class="mono">except</span> תופס את הסוג שכתבנו, והתוכנית ממשיכה.</li>
        <li>קבצים: <span class="mono">with open("שם.txt", מצב) as f:</span> עם <span class="mono">"w"</span> לכתיבה מחדש, <span class="mono">"a"</span> להוספה ו-<span class="mono">"r"</span> לקריאה. כך המידע נשאר אחרי שהתוכנית נגמרת.</li>
        <li>הדרך הכי טובה ללמוד: להריץ, לטעות, לקרוא את השגיאה ולתקן.</li>
      </ul>
    </div>
  </section>
</main>

<footer><div class="wrap">שיעור פייתון · סיכום הקורס</div></footer>

<script>window.EK_CFG={"quiz": [{"t": "מה יודפס?", "code": "word = \"ha\"\nprint(word * 3)", "opts": ["hahaha", "ha3", "ha ha ha", "שגיאה"], "ans": 0, "why": "כפל של מחרוזת במספר חוזר על המחרוזת: \"ha\" שלוש פעמים נותן hahaha.", "hint": "איזה סוג מידע הוא word?"}, {"t": "מה יקרה?", "code": "ages = {\"dan\": 16}\nprint(ages[\"rut\"])", "opts": ["יודפס 16", "יודפס None", "KeyError וקריסה", "יודפס 0"], "ans": 2, "why": "המפתח \"rut\" לא קיים במילון, ולכן פייתון זורקת KeyError. אפשר לתפוס אותה עם try / except.", "hint": "אילו מפתחות יש במילון?"}, {"t": "מה יודפס?", "code": "def add(a, b):\n    print(a + b)\n\nr = add(2, 3)\nprint(r)", "opts": ["5 ואז 5", "5 ואז None", "None ואז 5", "שגיאה"], "ans": 1, "why": "add מדפיסה 5 אבל לא מחזירה כלום, ולכן r הוא None. print זה לא return!", "hint": "מה שווה r אחרי שורה 4?"}, {"t": "מה יודפס?", "code": "nums = [1, 2, 3, 4]\nprint([n * 2 for n in nums if n > 2])", "opts": ["[2, 4, 6, 8]", "[6, 8]", "[3, 4]", "[8]"], "ans": 1, "why": "ה-if מסנן רק את 3 ו-4, וה-n * 2 מכפיל אותם: [6, 8].", "hint": "קודם בודקים את ה-if, ורק אחר כך מכפילים."}, {"t": "מה יודפס?", "code": "try:\n    print(int(\"7\") + 1)\n    print(1 / 0)\nexcept ZeroDivisionError:\n    print(\"oops\")\nprint(\"end\")", "opts": ["8 ואז oops ואז end", "oops ואז end", "8 ואז end", "שגיאה"], "ans": 0, "why": "השורה הראשונה מצליחה ומדפיסה 8. החילוק ב-0 נופל, ה-except מדפיס oops, והתוכנית ממשיכה ל-end.", "hint": "מה מודפס לפני שהתוכנית נופלת?"}]};
(function(){
var $=function(i){return document.getElementById(i)};
var RM=window.matchMedia&&matchMedia(''(prefers-reduced-motion: reduce)'').matches;
function esc(s){return String(s).replace(/&/g,''&amp;'').replace(/</g,''&lt;'').replace(/>/g,''&gt;'')}
function highlight(code){
  return esc(code).replace(/(#.*$)|("[^"\n]*")|\b(try|except|while|break|True|False|if|elif|else|for|in|import|from|as|def|return)\b|\b(print|int|input|float|len|range|str|list)\b|\b(\d+\.?\d*)\b/gm,function(m,c,s,k,f,n){
    if(c)return ''<span class="tok-cmt">''+c+''</span>'';
    if(s)return ''<span class="tok-str''+(/[֐-׿]/.test(s)?'' he'':'''')+''">''+s+''</span>'';
    if(k)return ''<span class="tok-kw">''+k+''</span>'';
    if(f)return ''<span class="tok-fn">''+f+''</span>'';
    return ''<span class="tok-num">''+n+''</span>''});
}
function hlAll(){document.querySelectorAll(''pre.hl'').forEach(function(p){var t=p.textContent;p.innerHTML=''<code>''+highlight(t)+''</code>''})}
hlAll();
function row(el,code){var e=el.querySelector(''.empty'');if(e)e.remove();var d=document.createElement(''div'');d.className=''row'';
  d.innerHTML=''<span><bdi>''+esc(code)+''</bdi></span>'';el.appendChild(d);el.scrollTop=el.scrollHeight}
function pillRow(host,items,onclick){host.innerHTML='''';items.forEach(function(it,i){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.textContent=it;b.onclick=function(){onclick(i)};host.appendChild(b)})}
function activate(host,i){host.querySelectorAll(''.pill'').forEach(function(p,j){p.classList.toggle(''active'',i===j)})}
function codeLines(host,lines){host.innerHTML=lines.map(function(l,i){return ''<div class="line" data-i="''+i+''">''+highlight(l)+''</div>''}).join('''')}

// ---- course map ----
(function(){
  var C=[
   [''print / input'',''שיעור 1. print מדפיסה, ו-input שואלת את המשתמשת ומחזירה תמיד טקסט.'',''# המשתמשת מקלידה Dana\nname = input("name: ")\nprint("hello", name)'',''hello Dana''],
   [''if / elif / else'',''שיעור 2. התוכנית מחליטה. רק הענף הראשון שנכון מורץ.'',''x = 7\nif x > 10:\n    print("big")\nelif x > 5:\n    print("medium")\nelse:\n    print("small")'',''medium''],
   [''for / while'',''שיעורים 3 ו-4. חוזרים על קוד. for לפי רשימה או range, ו-while כל עוד התנאי נכון.'',''for i in range(3):\n    print(i)'',''0\n1\n2''],
   [''[n * n for n in ...]'',''שיעור 4. for מקוצר: בונים רשימה שלמה בשורה אחת.'',''squares = [n * n for n in range(4)]\nprint(squares)'',''[0, 1, 4, 9]''],
   [''list'',''שיעור 5. רשימה: הרבה ערכים במשתנה אחד. האינדקס מתחיל ב-0, ו-1- הוא האחרון.'',''nums = [10, 20, 30]\nnums.append(40)\nprint(nums[-1], len(nums))'',''40 4''],
   [''dict'',''שיעור 6. מילון: ערכים לפי מפתח, ולא לפי מקום.'',''ages = {"dan": 16}\nages["rut"] = 17\nprint(ages["rut"])'',''17''],
   [''def / return'',''שיעור 7. פונקציה: קוד עם שם שאפשר להריץ שוב ושוב. return מחזירה ערך.'',''def double(x):\n    return x * 2\n\nprint(double(5))'',''10''],
   [''str'',''שיעור 8. מחרוזת: שרשרת תווים עם אינדקסים, פרוסות ושיטות.'',''name = "dana"\nprint(name.upper(), name[0], len(name))'',''DANA d 4''],
   [''import'',''שיעורים 9 ו-10. מודול הוא ארגז כלים מוכן שמביאים עם import.'',''import math\nprint(math.sqrt(16))'',''4.0''],
   [''try / except'',''שיעור 11. תופסים שגיאה במקום ליפול, והתוכנית ממשיכה.'',''try:\n    n = int("abc")\nexcept ValueError:\n    print("not a number")'',''not a number''],
   [''open'',''שיעור 12. קבצים: התוכנית כותבת וקוראת מהמחשב, והמידע נשאר גם אחרי שהיא נגמרת.'',''with open("notes.txt", "a") as f:\n    f.write("hi\\n")'',''added "hi" to notes.txt'']
  ],g=$(''map-grid'');
  C.forEach(function(c){var d=document.createElement(''div'');d.className=''rf'';
    var h=document.createElement(''h4'');h.textContent=c[0];var p=document.createElement(''p'');p.textContent=c[1];
    var ex=document.createElement(''div'');ex.className=''ex'';ex.style.whiteSpace=''pre-wrap'';ex.textContent=c[2];
    var rr=document.createElement(''div'');rr.className=''rr'';rr.style.alignItems=''flex-start'';var b=document.createElement(''button'');b.type=''button'';b.className=''run-btn'';b.textContent=''הריצי'';
    var r=document.createElement(''span'');r.className=''res'';r.setAttribute(''aria-live'',''polite'');b.onclick=function(){r.textContent=c[3]};
    rr.appendChild(b);rr.appendChild(r);[h,p,ex,rr].forEach(function(x){d.appendChild(x)});g.appendChild(d)});
})();

// ---- one program, all topics ----
var PG=[''import random'',''def grade(score):'',''    if score >= 90:'',''        return "A"'',''    elif score >= 56:'',''        return "pass"'',''    return "fail"'',''scores = {"dana": 95, "ruth": 60, "noa": 40}'',''names = ["dana", "ruth", "noa", "tal"]'',''for name in names:'',''    try:'',''        s = scores[name]'',''        print(f"{name.title()}: {grade(s)}")'',''    except KeyError:'',''        print(name, "has no score")'',''print("lucky:", random.choice(names).upper())''];
var PT=[
 [''מודולים'',[0,15],''import random מביאה את ארגז הכלים, ו-random.choice בוחרת פריט אקראי מהרשימה.''],
 [''פונקציות'',[1,3,5,6],''def grade מגדירה פונקציה, ו-return מחזירה ממנה את הדרגה. אפשר לקרוא לה שוב ושוב.''],
 [''תנאים'',[2,4],''if ו-elif בודקים את הציון מלמעלה למטה. אם שניהם לא נכונים, מגיעים ל-return "fail".''],
 [''מילונים'',[7,11],''scores מחבר שם לציון, ו-scores[name] שולף את הציון לפי המפתח.''],
 [''רשימות'',[8],''names היא רשימה של שמות, והלולאה עוברת עליה לפי הסדר.''],
 [''לולאות'',[9],''for עוברת על כל שם ברשימה, והשורות המוזחות מתחתיה רצות בכל סיבוב.''],
 [''שגיאות'',[10,13,14],''ל-"tal" אין ציון, ולכן scores[name] זורקת KeyError. ה-except תופס אותה, והתוכנית ממשיכה.''],
 [''מחרוזות'',[12,15],''name.title() הופכת את האות הראשונה לגדולה, f-string מדביקה ערכים בתוך טקסט, ו-upper הופכת הכול לגדול.'']
];
codeLines($(''pg-code''),PG);
pillRow($(''pg-topics''),PT.map(function(t){return t[0]}),function(i){
  activate($(''pg-topics''),i);
  $(''pg-code'').querySelectorAll(''.line'').forEach(function(l,j){l.classList.toggle(''run'',PT[i][1].indexOf(j)>-1)});
  $(''pg-note'').textContent=PT[i][2]});
$(''pg-run'').onclick=function(){
  var log=$(''pg-log''),names=[''dana'',''ruth'',''noa'',''tal''];log.innerHTML='''';
  row(log,''Dana: A'');row(log,''Ruth: pass'');row(log,''Noa: fail'');row(log,''tal has no score'');
  row(log,''lucky: ''+names[Math.floor(Math.random()*names.length)].toUpperCase())};

// ---- which tool ----
var CH=[
 [''צריך לבדוק אם הציון מספיק גבוה כדי לעבור.'',''if''],
 [''צריך להדפיס את השם של כל תלמידה ברשימה, אחת אחרי השנייה.'',''for''],
 [''צריך לשאול סיסמה שוב ושוב עד שהמשתמשת מקלידה את הנכונה, ואין לדעת כמה פעמים זה ייקח.'',''while''],
 [''צריך לשמור את הגיל של כל תלמידה ולמצוא אותו לפי השם שלה.'',''dict''],
 [''צריך לשמור 30 ציונים בסדר מסוים בתוך משתנה אחד.'',''list''],
 [''יש קוד שרוצים להריץ בחמישה מקומות בתוכנית, בלי להעתיק אותו חמש פעמים.'',''def''],
 [''המשתמשת עלולה להקליד אותיות במקום מספר, ולא רוצים שהתוכנית תקרוס.'',''try / except''],
 [''צריך להגריל מספר בין 1 ל-6, וזה כבר כתוב בפייתון.'',''import''],
 [''צריך לשמור את הציונים כך שיישארו גם אחרי שהתוכנית נגמרת.'',''open'']
],CN=[''if'',''for'',''while'',''list'',''dict'',''def'',''try / except'',''import'',''open''],ci=0,cscore=0,ctry=0;
function cround(){
  if(ci>=CH.length){$(''ch-title'').textContent=''סיימת!'';$(''ch-q'').textContent='''';$(''ch-opts'').innerHTML='''';
    $(''ch-msg'').className=''zg-msg good'';$(''ch-msg'').textContent=''בחרת נכון בניסיון ראשון ''+cscore+'' מתוך ''+CH.length+''.'';return}
  $(''ch-title'').textContent=''שאלה ''+(ci+1)+'' מתוך ''+CH.length;ctry=0;$(''ch-msg'').className=''zg-msg'';$(''ch-msg'').textContent='''';
  $(''ch-q'').textContent=CH[ci][0];
  pillRow($(''ch-opts''),CN,function(j){
    var btn=$(''ch-opts'').children[j];
    if(CN[j]===CH[ci][1]){$(''ch-msg'').className=''zg-msg good'';$(''ch-msg'').textContent=''✔ נכון, ''+CH[ci][1]+''.'';
      if(ctry===0){cscore++;if(window.EK_award)EK_award(btn)}
      $(''ch-opts'').querySelectorAll(''button'').forEach(function(x){x.disabled=true});ci++;setTimeout(cround,RM?1000:1700)}
    else{ctry++;btn.disabled=true;btn.classList.add(''wrong'');$(''ch-msg'').className=''zg-msg bad'';$(''ch-msg'').textContent=''לא ''+CN[j]+''. חשבי איזה כלי מתאים לבעיה, ונסי שוב.''}
  });
}
cround();

// ---- bug hunt ----
var rs=$(''rescue1'');
rs.querySelectorAll(''.rescue-choice'').forEach(function(b){b.onclick=function(){
  var fb=$(''rescue1-fb'');
  if(b.dataset.ok===''1''){b.classList.add(''right'');rs.classList.add(''fixed'');rs.querySelector(''.rescue-mark'').textContent=''✓'';
    rs.querySelectorAll(''.rescue-choice'').forEach(function(x){x.disabled=true});
    fb.className=''rescue-feedback correct'';fb.textContent=''נכון! total = n מחליפה את הסכום בכל סיבוב, ולכן נשאר רק האחרון (30). כדי לצבור צריך total = total + n.''}
  else{b.classList.add(''wrong'');b.disabled=true;fb.className=''rescue-feedback wrong'';fb.textContent=''לא בדיוק. תסתכלי מה קורה ל-total בתוך הלולאה בכל סיבוב: האם הוא צובר, או מוחלף?''}
}});

// ---- download / submit ----
(function(){
  var Q=[
    [''תרגיל 1'',''השלימי את המילה החסרה כדי להגדיר פונקציה.'',''______ square(x):\n    return x * x''],
    [''תרגיל 2'',''מה יודפס?'',''d = {"a": 1, "b": 2}\nd["c"] = 3\nd["a"] = 10\nprint(len(d))''],
    [''תרגיל 3 (ב-VS Code)'',''מחברת ציונים: שואלים שם וציון שוב ושוב עד ש-stop בתור שם. שומרים במילון. ציון שאינו מספר: הודעה ושואלים שוב. בסוף לכל תלמידה מדפיסים שם (אות ראשונה גדולה) ודרגה לפי פונקציה: 90 ומעלה A, 56 ומעלה pass, אחרת fail.'',''''],
    [''תרגיל 4 · אתגר (ב-VS Code)'',''מדפיסים את שם התלמידה עם הציון הגבוה ביותר, ובוחרים תלמידה אחת באקראי עם random.choice.'','''']];
  function E(t){return String(t).replace(/[&<>"]/g,function(c){return{''&'':''&amp;'',''<'':''&lt;'',''>'':''&gt;'',''"'':''&quot;''}[c]})}
  var CSS=''<style>body{font-family:Arial,sans-serif;max-width:760px;margin:30px auto;padding:0 16px;line-height:1.7;color:#222}h1{font-size:24px}.q{border:1px solid #bbb;border-radius:8px;padding:12px 18px;margin:16px 0;page-break-inside:avoid}pre{background:#f3f3f3;padding:10px;direction:ltr;text-align:left;white-space:pre-wrap;border-radius:6px}.a{min-height:90px;border:1px dashed #999;border-radius:6px;margin-top:8px}.ok{color:#0a7a2f;font-weight:bold}.no{color:#b3261e;font-weight:bold}</style>'';
  function save(html,name){
    try{var b=new Blob([html],{type:''text/html;charset=utf-8''}),u=URL.createObjectURL(b),a=document.createElement(''a'');a.href=u;a.download=name;document.body.appendChild(a);a.click();a.remove();setTimeout(function(){URL.revokeObjectURL(u)},1500);return true}
    catch(e){return false}}
  document.getElementById(''sub-dl-ex'').onclick=function(){
    var h=''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>תרגילי סיכום</title>''+CSS+''</head><body><h1>תרגילי סיכום בפייתון</h1><p>שם: ______________________</p>'';
    Q.forEach(function(q){h+=''<div class="q"><b>''+E(q[0])+''</b><br>''+E(q[1])+(q[2]?''<pre>''+E(q[2])+''</pre>'':'''')+''<div class="a"></div></div>''});
    save(h+''</body></html>'',''python-summary-exercises.html'')};
  document.getElementById(''sub-dl'').onclick=function(){
    var name=document.getElementById(''sub-name'').value.trim(),fb=document.getElementById(''sub-fb''),fbk=document.getElementById(''sub-fallback'');
    if(!name){fb.className=''exercise-feedback'';fb.textContent=''קודם כתבי את שמך.'';return}
    var a1=document.getElementById(''ex1-a'').value.trim(),a2=document.getElementById(''ex2-in'').value.trim(),
      a3=document.querySelector(''[aria-label="התשובה לתרגיל 3"]'').value,a4=document.querySelector(''[aria-label="התשובה לתרגיל 4"]'').value,
      ok1=a1===''def'',ok2=a2===''3'';
    function mark(ok,v){return v?''<span class="''+(ok?''ok'':''no'')+''">''+(ok?''נכון'':''לא נכון'')+''</span>'':''<span class="no">לא נענה</span>''}
    var date=new Date().toLocaleDateString(''he-IL'');
    var h=''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>תשובות: ''+E(name)+''</title>''+CSS+''</head><body><h1>תרגילי סיכום: ''+E(name)+''</h1><p>תאריך: ''+E(date)+''</p>''
     +''<div class="q"><b>''+Q[0][0]+''</b><pre>''+E(Q[0][2])+''</pre>תשובה (המילה החסרה): <pre>''+E(a1||''(ריק)'')+''</pre>''+mark(ok1,a1)+''</div>''
     +''<div class="q"><b>''+Q[1][0]+''</b><pre>''+E(Q[1][2])+''</pre>תשובה: <pre>''+E(a2||''(ריק)'')+''</pre>''+mark(ok2,a2)+''</div>''
     +''<div class="q"><b>''+Q[2][0]+''</b><pre>''+E(a3||''(לא נענה)'')+''</pre></div>''
     +''<div class="q"><b>''+Q[3][0]+''</b><pre>''+E(a4||''(לא נענה)'')+''</pre></div></body></html>'';
    if(save(h,''python-summary-answers.html'')){fb.className=''exercise-feedback correct'';fb.textContent=''הקובץ ירד! שלחי אותו למורה.''}
    else{fb.className=''exercise-feedback'';fb.textContent=''ההורדה לא עבדה. העתיקי את הטקסט שלמטה ושמרי כקובץ html.'';fbk.hidden=false;fbk.value=h}};
})();

// דיווח התקדמות לאתר שמציג את השיעור (window.reportProgress מוזרק על ידיו; בקובץ שנפתח לבד אין אותו). תרגילי החובה: 1 ו-2.
var exSolved={};
function reportEx(){if(window.reportProgress)window.reportProgress(Object.keys(exSolved).length,2)}
reportEx();
function chk(btn,fn,fbId,okMsg,badMsg){$(btn).onclick=function(){var f=$(fbId);if(fn()){f.className=''exercise-feedback correct'';f.textContent=okMsg;exSolved[btn]=true;reportEx()}else{f.className=''exercise-feedback wrong'';f.textContent=badMsg}}}
chk(''ex1-btn'',function(){return $(''ex1-a'').value.trim()===''def''},''ex1-feedback'',''נכון! def מגדירה פונקציה חדשה.'',''לא בדיוק. איזו מילה פותחת הגדרה של פונקציה?'');
chk(''ex2-btn'',function(){return $(''ex2-in'').value.trim()===''3''},''ex2-feedback'',''נכון! נוספו a, b ו-c, ושינוי הערך של a לא מוסיף מפתח. בסך הכול 3.'',''לא בדיוק. כמה מפתחות שונים יש במילון בסוף? האם d["a"] = 10 מוסיפה מפתח חדש?'');
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
', 13, '2026-11-08T00:00:00.000Z');
