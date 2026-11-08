DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='course-summary';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('62cd2a0a3bc0066a10d94c7b75788bf6', 'python-ai-era', 'course-summary', 'שיעור סיכום - תרגילים ותעודה', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>סיכום הקורס: תרגילים ותעודה</title>
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
<style>
  /* ---------- שיעור סיכום: כרטיסי תרגיל, התקדמות ותעודה ---------- */
  .sx-prog { margin-top:26px; max-width:520px; margin-inline:auto; }
  .sx-prog-t { font:700 15px var(--sans); color:var(--ink); margin-bottom:8px; }
  .sx-bar { height:10px; border-radius:100px; background:var(--bg-panel-2); border:1px solid var(--line); overflow:hidden; }
  .sx-bar i { display:block; height:100%; width:0; background:linear-gradient(90deg,var(--for),var(--while)); border-radius:100px; transition:width .4s ease; }
  .sx-nav { display:flex; flex-wrap:wrap; gap:8px; margin-top:22px; }
  .sx-nav .pill { direction:rtl; font-family:var(--sans); font-size:14px; font-weight:600; }
  .sx-nav .pill.done { background:var(--success-soft); color:var(--success); border-color:var(--success); }
  .sx-tasks .exercise-card:first-child { margin-top:26px; }
  .sx-box { direction:ltr; text-align:left; background:rgba(0,0,0,0.22); border-radius:10px; overflow:hidden; margin-bottom:14px; }
  .sx-line { display:block; width:100%; text-align:left; direction:ltr; background:transparent; border:0; border-bottom:1px dashed var(--line); color:var(--ink); font:500 14.5px/1.9 var(--mono); white-space:pre; padding:2px 14px; cursor:pointer; transition:background .15s; }
  .sx-line:last-child { border-bottom:0; }
  .sx-line:hover:not(:disabled) { background:rgba(255,210,122,.12); }
  .sx-line .n { color:var(--ink-faint); margin-inline-end:12px; }
  .sx-line.good { background:var(--success-soft); box-shadow:inset 3px 0 0 var(--success); }
  .sx-line.bad { background:var(--danger-soft); box-shadow:inset 3px 0 0 var(--danger); }
  .sx-line:disabled { cursor:default; }
  .sx-ord { display:grid; grid-template-columns:repeat(auto-fit,minmax(min(260px,100%),1fr)); gap:12px; margin-bottom:14px; }
  .sx-ord h5 { margin:0 0 6px; font:600 13px var(--sans); color:var(--ink-faint); }
  .sx-ord .ob { min-height:62px; border:2px dashed var(--line-strong); border-radius:10px; padding:4px 0; direction:ltr; background:rgba(0,0,0,.14); }
  .sx-ctl { margin-top:2px; }
  .rescue-choice { text-align:start; }
  .exercise-code .sx-in, .sx-inp { font-family:var(--mono); font-size:14px; background:var(--bg-panel-2); border:1px solid var(--line-strong); border-radius:6px; color:var(--for); padding:3px 6px; text-align:center; direction:ltr; width:110px; }
  .exercise-controls .sx-inp { width:150px; padding:7px 8px; font-size:15px; color:var(--ink); border-radius:8px; }
  .sx-sum { margin:8px 0 0; padding-inline-start:20px; line-height:1.9; font-size:15px; color:var(--ink-dim); }
  .sx-sum code { font-family:var(--mono); direction:ltr; unicode-bidi:isolate; background:var(--bg-panel-2); padding:1px 6px; border-radius:5px; color:var(--ink); }
  .callout b.sx-h { color:var(--ink); }
  /* תעודה */
  .sx-cert { margin-top:30px; text-align:center; background:radial-gradient(120% 80% at 50% 0%,#3a2a66,#1d1a2d 70%); border:3px double var(--for); border-radius:28px; padding:36px 24px 30px; box-shadow:0 0 60px -14px rgba(255,210,122,.4); }
  .sx-cert[hidden] { display:none; }
  .sx-cert .tr { font-size:44px; line-height:1; }
  .sx-cert h3 { font:900 clamp(26px,5vw,38px) var(--display); margin:6px 0 2px; background:linear-gradient(90deg,#ffd27a,#ff9ec0,#ffd27a); -webkit-background-clip:text; background-clip:text; color:transparent; }
  .sx-cert .sub { color:var(--ink-dim); font-size:15px; }
  .sx-cert .nm { font:800 32px var(--display); margin:12px 0 4px; }
  .sx-seal { width:124px; height:124px; margin:14px auto; border-radius:50%; background:radial-gradient(circle at 30% 25%,#fff3c4,#ffd27a 55%,#b9822a); color:#4a2f06; display:flex; flex-direction:column; align-items:center; justify-content:center; gap:2px; box-shadow:0 10px 30px rgba(0,0,0,.5), inset 0 0 0 5px rgba(255,255,255,.35); outline:3px dashed rgba(255,210,122,.6); outline-offset:6px; }
  .sx-seal span { font-size:36px; line-height:1; }
  .sx-seal b { font:900 16px/1.1 var(--display); }
  .sx-cert .big { font:900 60px var(--display); color:var(--for); line-height:1; text-shadow:0 0 30px rgba(255,210,122,.5); }
  .sx-cert .of { color:var(--ink-dim); font-size:14.5px; margin-top:4px; }
  .sx-kpis { display:flex; gap:12px; justify-content:center; flex-wrap:wrap; margin:18px 0 6px; }
  .sx-kpis div { background:rgba(255,255,255,.06); border:1px solid var(--line); border-radius:14px; padding:6px 20px; min-width:92px; }
  .sx-kpis b { display:block; font:800 20px var(--display); } .sx-kpis span { font-size:12px; color:var(--ink-faint); }
  .sx-cert .date { margin-top:10px; color:var(--ink-faint); font-size:13.5px; }
  .sx-acts { display:flex; gap:10px; flex-wrap:wrap; justify-content:center; margin-top:20px; }
  .sx-note { margin-top:10px; font-size:13.5px; color:var(--ink-faint); }
</style>
</head>
<body>
<header class="hero">
  <div class="wrap">
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור סיכום · פייתון · מגמת מחשבים</div>
    <h1>סיכום הקורס:<br><span class="accent-for">כל מה שלמדנו</span> <span class="accent-while">בתרגילים</span></h1>
    <p class="hero-sub">אחד עשר נושאים, שתי משימות בכל אחד, ובסוף <strong>תעודה אישית</strong> עם דרגה. אפשר לפי הסדר או לקפוץ לנושא. טעות או רמז מורידים נקודות, אבל תמיד אפשר לנסות שוב.</p>
    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre class="hl"><code>topics = ["print", "if", "for", "def", "try"]
for t in topics:
    print("✓", t)</code></pre>
    </div>
  </div>
</header>

<main>

  <section id="map">
    <div class="wrap">
      <div class="eyebrow for-c">איפה אני</div>
      <h2 class="section-title">מפת הנושאים</h2>
      <p class="lede">נושא שפתרת במלואו מקבל וי. כשכל הנושאים פתורים, התעודה נפתחת בסוף העמוד.</p>
      <div class="sx-prog"><div class="sx-prog-t" id="sx-prog-t" role="status" aria-live="polite">פתרת 0 מתוך 26 משימות</div><div class="sx-bar"><i id="sx-bar"></i></div></div>
      <div class="sx-nav" id="sx-nav"></div>
    </div>
  </section>

  <section id="t0">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 1 · print ו-input</div>
      <h2 class="section-title">פלט וקלט</h2>
      <p class="lede">הכלים הראשונים שלמדנו: print מדפיסה למסך, ו-input שואלת את המשתמשת. שתי משימות קצרות.</p>
      <div class="sx-tasks" id="tasks-0"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>print()</code> מדפיסה, <code>input()</code> שואלת ומחזירה <b>טקסט</b>.</li><li>כדי לחשב עם מספר: <code>int(input())</code>.</li></ul><pre class="code-static hl">age = int(input("גיל: "))
print("בשנה הבאה:", age + 1)</pre></div>
    </div>
  </section>

  <section id="t1">
    <div class="wrap">
      <div class="eyebrow while-c">נושא 2 · if / elif / else</div>
      <h2 class="section-title">תנאים</h2>
      <p class="lede">if, elif ו-else: התוכנית מחליטה מה לעשות. פייתון בודקת מלמעלה ומריצה את הענף הראשון שנכון.</p>
      <div class="sx-tasks" id="tasks-1"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>if</code> בודק, <code>elif</code> בודק עוד, <code>else</code> תופס את השאר.</li><li>רק הענף הראשון שנכון מורץ.</li><li>השוואות: <code>==</code> <code>!=</code> <code>&gt;</code> <code>&lt;</code> <code>&gt;=</code> <code>&lt;=</code>.</li></ul><pre class="code-static hl">if score &gt;= 56:
    print("עבר")
else:
    print("לא עבר")</pre></div>
    </div>
  </section>

  <section id="t2">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 3 · for ו-while</div>
      <h2 class="section-title">לולאות</h2>
      <p class="lede">for ו-while: חוזרים על קוד כמה פעמים שצריך. מה שמוזח מתחת ללולאה הוא מה שחוזר.</p>
      <div class="sx-tasks" id="tasks-2"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>for</code> עוברת על רשימה או על <code>range</code>.</li><li><code>while</code> חוזרת כל עוד התנאי נכון.</li><li>מה שמוזח מתחת ללולאה הוא מה שחוזר.</li></ul><pre class="code-static hl">for i in range(1, 4):
    print(i)</pre></div>
    </div>
  </section>

  <section id="t3">
    <div class="wrap">
      <div class="eyebrow while-c">נושא 4 · list</div>
      <h2 class="section-title">רשימות</h2>
      <p class="lede">רשימות: הרבה ערכים במשתנה אחד, עם אינדקסים שמתחילים מאפס.</p>
      <div class="sx-tasks" id="tasks-3"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li>אינדקס מתחיל ב-<code>0</code>, ו-<code>-1</code> הוא האחרון.</li><li><code>append</code> מוסיפה, <code>len</code> סופרת, <code>[a:b]</code> חותכת.</li></ul><pre class="code-static hl">nums = [10, 20, 30]
nums.append(40)
print(nums[0], nums[-1])</pre></div>
    </div>
  </section>

  <section id="t4">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 5 · dict</div>
      <h2 class="section-title">מילונים</h2>
      <p class="lede">מילונים: ערכים לפי מפתח, ולא לפי מקום. מפתח שלא קיים זורק KeyError.</p>
      <div class="sx-tasks" id="tasks-4"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li>מילון הוא זוגות <code>מפתח: ערך</code> בסוגריים מסולסלים.</li><li><code>d["key"] = value</code> מוסיפה או משנה. מפתח שלא קיים גורם ל-<code>KeyError</code>.</li></ul><pre class="code-static hl">ages = {"dan": 16}
ages["rut"] = 17
print(ages["rut"])</pre></div>
    </div>
  </section>

  <section id="t5">
    <div class="wrap">
      <div class="eyebrow while-c">נושא 6 · def ו-return</div>
      <h2 class="section-title">פונקציות</h2>
      <p class="lede">פונקציות: קוד עם שם שאפשר להריץ שוב ושוב. שימי לב להבדל בין print ל-return.</p>
      <div class="sx-tasks" id="tasks-5"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>def שם(פרמטרים):</code> מגדירה, ו-<code>שם(ערכים)</code> קוראת.</li><li><code>return</code> מחזירה ערך החוצה, ו-<code>print</code> רק מציגה.</li></ul><pre class="code-static hl">def double(x):
    return x * 2

print(double(5))</pre></div>
    </div>
  </section>

  <section id="t6">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 7 · import</div>
      <h2 class="section-title">מודולים</h2>
      <p class="lede">מודולים: ארגז כלים מוכן שמביאים עם import. איך קוראים לכלי שבתוכו?</p>
      <div class="sx-tasks" id="tasks-6"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>import math</code> ואז <code>math.sqrt(9)</code>.</li><li><code>from math import sqrt</code> ואז <code>sqrt(9)</code>.</li><li>ב-<code>random</code>: <code>randint</code> בוחרת מספר, <code>choice</code> בוחרת פריט.</li></ul><pre class="code-static hl">import random
print(random.choice(["a", "b", "c"]))</pre></div>
    </div>
  </section>

  <section id="t7">
    <div class="wrap">
      <div class="eyebrow while-c">נושא 8 · str</div>
      <h2 class="section-title">מחרוזות</h2>
      <p class="lede">מחרוזות: שרשרת תווים עם אינדקסים, פרוסות ושיטות כמו upper ו-strip.</p>
      <div class="sx-tasks" id="tasks-7"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li>מחרוזת היא שרשרת תווים עם אינדקסים: <code>word[0]</code>, <code>word[-1]</code>, <code>word[1:3]</code>.</li><li>שיטות כמו <code>upper</code>, <code>strip</code>, <code>replace</code> מחזירות מחרוזת חדשה.</li><li>f-string: <code>f"Hi {name}"</code>.</li></ul><pre class="code-static hl">name = "dana"
print(f"Hi {name.upper()}!")</pre></div>
    </div>
  </section>

  <section id="t8">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 9 · try / except</div>
      <h2 class="section-title">שגיאות</h2>
      <p class="lede">שגיאות: try ו-except תופסים שגיאה, והתוכנית ממשיכה במקום ליפול.</p>
      <div class="sx-tasks" id="tasks-8"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li>שגיאה נקראת מלמטה: סוג ההודעה בשורה האחרונה.</li><li><code>try</code> מנסה, <code>except סוג:</code> תופס, והתוכנית ממשיכה.</li><li>כל סוג שגיאה צריך <code>except</code> משלו.</li></ul><pre class="code-static hl">try:
    x = int(input())
except ValueError:
    print("לא מספר")</pre></div>
    </div>
  </section>

  <section id="t9">
    <div class="wrap">
      <div class="eyebrow while-c">נושא 10 · open</div>
      <h2 class="section-title">קבצים</h2>
      <p class="lede">קבצים: open כותב וקורא מהמחשב, והמידע נשאר גם אחרי שהתוכנית נגמרת.</p>
      <div class="sx-tasks" id="tasks-9"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>with open(name, mode) as f:</code> פותח וסוגר אוטומטית.</li><li><code>"w"</code> כותב מחדש, <code>"a"</code> מוסיף, <code>"r"</code> קורא.</li><li><code>FileNotFoundError</code> נתפסת עם <code>try</code>.</li></ul><pre class="code-static hl">with open("notes.txt", "a") as f:
    f.write("hello\n")</pre></div>
    </div>
  </section>

  <section id="t10">
    <div class="wrap">
      <div class="eyebrow for-c">נושא 11 · כל הקורס</div>
      <h2 class="section-title">שאלות כלליות</h2>
      <p class="lede">שאלות מכל הקורס, כולל הטעויות הנפוצות ביותר. שש שאלות.</p>
      <div class="sx-tasks" id="tasks-10"></div>
      <div class="callout"><b class="sx-h">📌 מה לזכור</b><ul class="sx-sum"><li><code>=</code> שומר ערך, <code>==</code> משווה.</li><li><code>input</code> מחזירה תמיד טקסט.</li><li>הזחה קובעת מה שייך לבלוק.</li><li>שגיאה קוראים מלמטה: סוג ההודעה בשורה האחרונה.</li><li>הדרך הכי טובה ללמוד: להריץ, לטעות ולתקן.</li></ul><pre class="code-static hl">name = input("name: ")
if name == "dana":
    print("hello!")</pre></div>
    </div>
  </section>

  <section id="cert">
    <div class="wrap">
      <div class="eyebrow while-c">🏆 התעודה</div>
      <h2 class="section-title">התעודה שלך</h2>
      <p class="lede">אחרי שפתרת את כל המשימות, כתבי את שמך המלא והפיקי תעודה עם הניקוד והדרגה. את הקובץ אפשר להוריד ולשלוח למורה.</p>
      <div class="certificate-box">
        <div class="cert-name-display" id="sx-cert-prog">פתרת 0 מתוך 26 משימות</div>
        <input type="text" id="sx-name" class="name-bar-input" autocomplete="off" placeholder="שם מלא" aria-label="שם מלא" maxlength="40">
        <button type="button" class="run-btn" id="sx-cert-go">הפיקי תעודה</button>
        <p class="cert-status" id="sx-cert-msg" role="status" aria-live="polite"></p>
      </div>
      <div class="sx-cert" id="sx-cert-card" hidden></div>
    </div>
  </section>
</main>

<footer><div class="wrap">שיעור פייתון · סיכום הקורס</div></footer>

<script>window.SX_DATA=[{"ic":"🖨️","t":"פלט וקלט","sub":"print ו-input","sum":"<li><code>print()<\/code> מדפיסה, <code>input()<\/code> שואלת ומחזירה <b>טקסט<\/b>.<\/li><li>כדי לחשב עם מספר: <code>int(input())<\/code>.<\/li>","ex":"age = int(input(\"גיל: \"))\nprint(\"בשנה הבאה:\", age + 1)","tasks":[{"k":"mc","q":"המשתמשת מקלידה Dana. מה יודפס?","code":"name = input(\"שם: \")\nprint(\"שלום\", name)","opts":["שלום Dana","שלום name","שלוםDana","שגיאה"],"ans":0,"why":"print מדפיסה את שני הערכים עם רווח ביניהם, ו-name מחזיק את מה שהוקלד.","hint":"קראי שוב את print: כמה דברים יש בתוכה, ומה מפריד ביניהם?"},{"k":"bug","q":"באיזו שורה הבעיה? (המשתמשת מקלידה 16)","ans":1,"lines":["age = input(\"גיל: \")","print(age + 1)"],"why":"input מחזירה תמיד טקסט, ולכן age + 1 הוא טקסט + מספר, ופייתון זורקת TypeError. צריך int(input(...)).","hint":"איזה סוגי מידע מופיעים בשורה 2? האם אפשר לחבר אותם?"}]},{"ic":"🚦","t":"תנאים","sub":"if / elif / else","sum":"<li><code>if<\/code> בודק, <code>elif<\/code> בודק עוד, <code>else<\/code> תופס את השאר.<\/li><li>רק הענף הראשון שנכון מורץ.<\/li><li>השוואות: <code>==<\/code> <code>!=<\/code> <code>&gt;<\/code> <code>&lt;<\/code> <code>&gt;=<\/code> <code>&lt;=<\/code>.<\/li>","ex":"if score >= 56:\n    print(\"עבר\")\nelse:\n    print(\"לא עבר\")","tasks":[{"k":"mc","q":"מה יודפס?","code":"x = 15\nif x > 10:\n    print(\"A\")\nelif x > 5:\n    print(\"B\")\nelse:\n    print(\"C\")","opts":["A","B","C","A ואז B"],"ans":0,"why":"פייתון בודקת מלמעלה ועוצרת בתנאי הראשון שנכון. x > 10 נכון, ולכן רק A.","hint":"עברי על התנאים מלמעלה, אחד אחרי השני."},{"k":"fill","q":"השלימי כך שיודפס \"עבר\" גם כשהציון הוא בדיוק 56.","code":"score = 56\nif score ___ 56:\n    print(\"עבר\")","acc":[">="],"why":">= אומר \"גדול או שווה\", ולכן גם 56 עובר. עם > בלבד 56 היה נכשל.","hint":"מה ההבדל בין \"גדול מ\" לבין \"לפחות\"?"}]},{"ic":"🔁","t":"לולאות","sub":"for ו-while","sum":"<li><code>for<\/code> עוברת על רשימה או על <code>range<\/code>.<\/li><li><code>while<\/code> חוזרת כל עוד התנאי נכון.<\/li><li>מה שמוזח מתחת ללולאה הוא מה שחוזר.<\/li>","ex":"for i in range(1, 4):\n    print(i)","tasks":[{"k":"mc","q":"מה יודפס?","code":"for i in range(3):\n    print(i)","opts":["0 ואז 1 ואז 2","1 ואז 2 ואז 3","0 ואז 1 ואז 2 ואז 3","1 ואז 2"],"ans":0,"why":"range(3) נותנת 0, 1, 2. היא מתחילה מאפס ולא כוללת את 3.","hint":"מאיפה range מתחילה לספור, ואיפה היא עוצרת?"},{"k":"order","q":"סדרי את השורות כך שהתוכנית תדפיס את הסכום 6.","lines":["total = 0","for n in [1, 2, 3]:","    total = total + n","print(total)"],"why":"קודם מאפסים, אחר כך הלולאה מוסיפה בכל סיבוב, ורק בסוף מדפיסים. השורה בתוך הלולאה מוזחת.","hint":"מה צריך לקרות לפני שמתחילים לסכם, ומתי כדאי להדפיס?"}]},{"ic":"📋","t":"רשימות","sub":"list","sum":"<li>אינדקס מתחיל ב-<code>0<\/code>, ו-<code>-1<\/code> הוא האחרון.<\/li><li><code>append<\/code> מוסיפה, <code>len<\/code> סופרת, <code>[a:b]<\/code> חותכת.<\/li>","ex":"nums = [10, 20, 30]\nnums.append(40)\nprint(nums[0], nums[-1])","tasks":[{"k":"mc","q":"מה יודפס?","code":"colors = [\"red\", \"blue\", \"green\"]\ncolors.append(\"pink\")\nprint(len(colors))","opts":["3","4","\"pink\"","שגיאה"],"ans":1,"why":"append מוסיפה פריט בסוף, ו-len סופרת: עכשיו יש 4.","hint":"מה הפעולה בשורה 2 עושה לרשימה, לפני שסופרים?"},{"k":"fill","q":"מה יודפס? כתבי את התוצאה.","code":"nums = [10, 20, 30, 40]\nprint(nums[-1])","acc":["40"],"ph":"מספר","blank":false,"why":"-1 הוא האיבר האחרון ברשימה.","hint":"איך אפשר להסתכל על רשימה מהצד ההפוך?"}]},{"ic":"📖","t":"מילונים","sub":"dict","sum":"<li>מילון הוא זוגות <code>מפתח: ערך<\/code> בסוגריים מסולסלים.<\/li><li><code>d[\"key\"] = value<\/code> מוסיפה או משנה. מפתח שלא קיים גורם ל-<code>KeyError<\/code>.<\/li>","ex":"ages = {\"dan\": 16}\nages[\"rut\"] = 17\nprint(ages[\"rut\"])","tasks":[{"k":"mc","q":"מה יודפס?","code":"ages = {\"dan\": 16, \"rut\": 17}\nprint(ages[\"rut\"])","opts":["16","17","\"rut\"","KeyError"],"ans":1,"why":"במילון ניגשים לערך דרך המפתח, וערך המפתח \"rut\" הוא 17.","hint":"במילון מחפשים לפי שם, לא לפי מקום. איזה שם מחפשים כאן?"},{"k":"bug","q":"באיזו שורה התוכנית תקרוס?","ans":2,"lines":["ages = {\"dan\": 16}","ages[\"rut\"] = 17","print(ages[\"noa\"])"],"why":"המפתח \"noa\" לא קיים במילון, ולכן KeyError. שורה 2 רק מוסיפה מפתח חדש.","hint":"בדקי אילו שמות באמת נכנסו למילון עד השורה האחרונה."}]},{"ic":"🧰","t":"פונקציות","sub":"def ו-return","sum":"<li><code>def שם(פרמטרים):<\/code> מגדירה, ו-<code>שם(ערכים)<\/code> קוראת.<\/li><li><code>return<\/code> מחזירה ערך החוצה, ו-<code>print<\/code> רק מציגה.<\/li>","ex":"def double(x):\n    return x * 2\n\nprint(double(5))","tasks":[{"k":"mc","q":"מה יודפס?","code":"def double(x):\n    return x * 2\n\nprint(double(5) + 1)","opts":["10","11","12","double(5) + 1"],"ans":1,"why":"double(5) מחזירה 10, ואז מוסיפים 1 ומקבלים 11.","hint":"פתרי מבפנים החוצה: קודם הקריאה, אחר כך שאר החישוב."},{"k":"mc","q":"מה יודפס?","code":"def greet(name):\n    print(\"Hi\", name)\n\nresult = greet(\"Dana\")\nprint(result)","opts":["Hi Dana ואז Hi Dana","Hi Dana ואז None","Hi Dana בלבד","שגיאה"],"ans":1,"why":"greet מדפיסה אבל לא מחזירה כלום, ולכן result הוא None. print זה לא return!","hint":"מה שווה result אחרי שורה 4?"}]},{"ic":"📦","t":"מודולים","sub":"import","sum":"<li><code>import math<\/code> ואז <code>math.sqrt(9)<\/code>.<\/li><li><code>from math import sqrt<\/code> ואז <code>sqrt(9)<\/code>.<\/li><li>ב-<code>random<\/code>: <code>randint<\/code> בוחרת מספר, <code>choice<\/code> בוחרת פריט.<\/li>","ex":"import random\nprint(random.choice([\"a\", \"b\", \"c\"]))","tasks":[{"k":"fill","q":"השלימי את המילה החסרה כדי להביא את המודול.","code":"___ random\nprint(random.randint(1, 6))","acc":["import"],"why":"import מביאה ארגז כלים, ואז random.randint בוחרת כלי ממנו.","hint":"איך מתחילה שורה שמביאה מודול?"},{"k":"mc","q":"מה יקרה?","code":"from math import sqrt\nprint(math.sqrt(9))","opts":["3.0","NameError","3","SyntaxError"],"ans":1,"why":"ה-from הביא רק את sqrt, ואת השם math אף אחד לא הביא, ולכן NameError.","hint":"בדקי איזה שם באמת הובא בשורה הראשונה."}]},{"ic":"🔤","t":"מחרוזות","sub":"str","sum":"<li>מחרוזת היא שרשרת תווים עם אינדקסים: <code>word[0]<\/code>, <code>word[-1]<\/code>, <code>word[1:3]<\/code>.<\/li><li>שיטות כמו <code>upper<\/code>, <code>strip<\/code>, <code>replace<\/code> מחזירות מחרוזת חדשה.<\/li><li>f-string: <code>f\"Hi {name}\"<\/code>.<\/li>","ex":"name = \"dana\"\nprint(f\"Hi {name.upper()}!\")","tasks":[{"k":"mc","q":"מה יודפס?","code":"word = \"python\"\nprint(word[0].upper() + word[1:])","opts":["Python","PYTHON","python","ython"],"ans":0,"why":"word[0].upper() הופכת את האות הראשונה לגדולה, ו-word[1:] היא כל השאר.","hint":"פצלי את הביטוי לשני חלקים וחשבי כל אחד לחוד."},{"k":"fill","q":"השלימי את שם השיטה שמסירה רווחים מההתחלה ומהסוף.","code":"text = \"  hi  \"\nprint(text.___())","acc":["strip","strip()"],"why":"strip() מוחקת רווחים בקצוות, ולכן יודפס hi.","hint":"חשבי על שיטה שמנקה את קצוות המחרוזת."}]},{"ic":"🛟","t":"שגיאות","sub":"try / except","sum":"<li>שגיאה נקראת מלמטה: סוג ההודעה בשורה האחרונה.<\/li><li><code>try<\/code> מנסה, <code>except סוג:<\/code> תופס, והתוכנית ממשיכה.<\/li><li>כל סוג שגיאה צריך <code>except<\/code> משלו.<\/li>","ex":"try:\n    x = int(input())\nexcept ValueError:\n    print(\"לא מספר\")","tasks":[{"k":"mc","q":"מה יודפס?","code":"try:\n    n = int(\"abc\")\n    print(\"A\")\nexcept ValueError:\n    print(\"B\")\nprint(\"C\")","opts":["A ואז C","B ואז C","B בלבד","שגיאה"],"ans":1,"why":"int(\"abc\") נופלת עם ValueError לפני ש-A מודפס. ה-except מדפיס B, והתוכנית ממשיכה ל-C.","hint":"באיזו שורה התוכנית נופלת, ומה קורה אחרי הנפילה?"},{"k":"order","q":"סדרי את השורות: התוכנית מחלקת, ותופסת חילוק ב-0.","lines":["try:","    x = int(input())","    print(10 / x)","except ZeroDivisionError:","    print(\"אי אפשר\")"],"why":"קודם try עם הקוד המסוכן, ואחריו except שתופס את סוג השגיאה המתאים.","hint":"מה בא קודם: הקוד שמנסים, או התפיסה?"}]},{"ic":"📄","t":"קבצים","sub":"open","sum":"<li><code>with open(name, mode) as f:<\/code> פותח וסוגר אוטומטית.<\/li><li><code>\"w\"<\/code> כותב מחדש, <code>\"a\"<\/code> מוסיף, <code>\"r\"<\/code> קורא.<\/li><li><code>FileNotFoundError<\/code> נתפסת עם <code>try<\/code>.<\/li>","ex":"with open(\"notes.txt\", \"a\") as f:\n    f.write(\"hello\\n\")","tasks":[{"k":"mc","q":"כמה שורות יהיו בקובץ a.txt בסוף?","code":"with open(\"a.txt\", \"w\") as f:\n    f.write(\"one\\n\")\nwith open(\"a.txt\", \"a\") as f:\n    f.write(\"two\\n\")","opts":["0","1","2","שגיאה"],"ans":2,"why":"\"w\" כותב את one, ו-\"a\" מוסיף את two בסוף בלי למחוק. סך הכול שתי שורות.","hint":"מה כל אחת משתי הפתיחות עושה למה שכבר כתוב בקובץ?"},{"k":"bug","q":"באיזו שורה הבעיה?","ans":1,"lines":["with open(\"data.txt\", \"r\") as f:","    f.write(\"hello\")"],"why":"\"r\" פותח לקריאה בלבד, ולכן אי אפשר לכתוב בו. לכתיבה צריך \"w\" או \"a\".","hint":"קראי שוב את מצב הפתיחה: מה מותר לעשות איתו?"}]},{"ic":"🏁","t":"שאלות כלליות","sub":"כל הקורס","sum":"<li><code>=<\/code> שומר ערך, <code>==<\/code> משווה.<\/li><li><code>input<\/code> מחזירה תמיד טקסט.<\/li><li>הזחה קובעת מה שייך לבלוק.<\/li><li>שגיאה קוראים מלמטה: סוג ההודעה בשורה האחרונה.<\/li><li>הדרך הכי טובה ללמוד: להריץ, לטעות ולתקן.<\/li>","ex":"name = input(\"name: \")\nif name == \"dana\":\n    print(\"hello!\")","tasks":[{"k":"mc","q":"מה ההבדל בין = ל-== בפייתון?","code":"x = 5\nif x == 5:\n    print(\"yes\")","opts":["= מכניס ערך למשתנה, ו-== משווה בין שני ערכים","= משווה, ו-== מכניס ערך","אין הבדל, שניהם עושים אותו דבר","== משמש רק בלולאות"],"ans":0,"why":"סימן = הוא השמה (שומר ערך במשתנה), ו-== שואל \"האם שווה?\" ומחזיר True או False.","hint":"אחד מהם נותן ערך, והשני שואל שאלה."},{"k":"mc","q":"איזה סוג מידע מחזירה הפונקציה input()?","code":"age = input(\"גיל: \")\nprint(type(age))","opts":["טקסט (str), תמיד","מספר שלם (int)","מספר עשרוני (float)","תלוי במה שהוקלד"],"ans":0,"why":"input תמיד מחזירה טקסט, גם אם הוקלדו ספרות. כדי לחשב צריך להמיר עם int או float.","hint":"האם פייתון מנחשת מה התכוונת?"},{"k":"mc","q":"מה יודפס?","code":"x = \"5\"\ny = 3\nprint(x * y)","opts":["15","555","שגיאה","8"],"ans":1,"why":"כפל של מחרוזת במספר חוזר על המחרוזת: \"5\" שלוש פעמים נותן \"555\".","hint":"שימי לב איזה סוג מידע הוא x."},{"k":"mc","q":"מה עושה break בתוך לולאה?","code":"for i in range(10):\n    if i == 3:\n        break\n    print(i)","opts":["יוצאת מהלולאה מיד","מדלגת לסיבוב הבא","עוצרת את כל התוכנית","מאפסת את i"],"ans":0,"why":"break מפסיקה את הלולאה מיד. כאן יודפס 0, 1, 2 ואז הלולאה נגמרת.","hint":"מה קורה כש-i מגיע ל-3?"},{"k":"bug","q":"באיזו שורה התוכנית תקרוס?","ans":3,"lines":["total = 0","for i in range(3):","    total += i","print(\"Total: \" + total)"],"why":"אי אפשר לחבר טקסט ומספר עם +, וזו TypeError. צריך str(total) או f-string.","hint":"חפשי חיבור בין שני סוגי מידע שונים."},{"k":"fill","q":"השלימי את המילה שמגדירה פונקציה.","code":"___ add(a, b):\n    return a + b","acc":["def"],"why":"def מגדירה פונקציה חדשה, ואחריה שם, פרמטרים ונקודתיים.","hint":"הפועל באנגלית שמקצרים ל-3 אותיות."}]}];
(function(){
var $=function(i){return document.getElementById(i)};
var RM=window.matchMedia&&matchMedia(''(prefers-reduced-motion: reduce)'').matches;
function esc(s){return String(s).replace(/&/g,''&amp;'').replace(/</g,''&lt;'').replace(/>/g,''&gt;'')}
function highlight(code){
  return esc(code).replace(/(#.*$)|("[^"\n]*")|\b(try|except|with|as|while|break|True|False|if|elif|else|for|in|import|from|def|return)\b|\b(print|int|input|open|len|range|str|append|float|type)\b|\b(\d+\.?\d*)\b/gm,function(m,c,s,k,f,n){
    if(c)return ''<span class="tok-cmt">''+c+''</span>'';
    if(s)return ''<span class="tok-str''+(/[֐-׿]/.test(s)?'' he'':'''')+''">''+s+''</span>'';
    if(k)return ''<span class="tok-kw">''+k+''</span>'';
    if(f)return ''<span class="tok-fn">''+f+''</span>'';
    return ''<span class="tok-num">''+n+''</span>''});
}
function hlAll(){document.querySelectorAll(''pre.hl'').forEach(function(p){var t=p.textContent;p.innerHTML=''<code>''+highlight(t)+''</code>''})}
hlAll();
function shuffle(a){var r=a.slice();for(var i=r.length-1;i>0;i--){var j=Math.floor(Math.random()*(i+1)),t=r[i];r[i]=r[j];r[j]=t}return r}
function nk(n){return String(n||'''').trim().replace(/\s+/g,'' '')}

var ST=window.SX_DATA,BASE=50,state={},total=0;
var RANKS=[[0,''מתלמדת''],[.5,''חוקרת''],[.7,''בלשית''],[.85,''מהנדסת''],[.95,''פרופסורית'']];
ST.forEach(function(s){total+=s.tasks.length});
function maxScore(){return total*BASE}
function keys(){return Object.keys(state)}
function doneCount(){return keys().filter(function(k){return state[k].done}).length}
function sum(f){return keys().reduce(function(a,k){return a+state[k][f]},0)}
function rankIdx(sc){var r=0,f=sc/maxScore();RANKS.forEach(function(x,i){if(f>=x[0])r=i});return r}
function stationDone(i){return ST[i].tasks.every(function(_,ti){var r=state[i+''-''+ti];return r&&r.done})}

// ---- progress ----
var navBtns=[];
function refresh(){
  var d=doneCount(),txt=''פתרת ''+d+'' מתוך ''+total+'' משימות'';
  $(''sx-prog-t'').textContent=txt;$(''sx-cert-prog'').textContent=txt;$(''sx-bar'').style.width=Math.round(d/total*100)+''%'';
  navBtns.forEach(function(b,i){var ok=stationDone(i);b.classList.toggle(''done'',ok);b.textContent=(ok?''✓ '':'''')+(i+1)+''. ''+ST[i].t});
  // דיווח התקדמות לאתר שמציג את השיעור (window.reportProgress מוזרק על ידיו; בקובץ שנפתח לבד אין אותו). השיעור הושלם כשכל המשימות פתורות.
  if(window.reportProgress)window.reportProgress(d,total);
}

// ---- exercise cards ----
function build(si,ti){
  var s=ST[si],t=s.tasks[ti],key=si+''-''+ti,r=state[key]={done:false,att:0,hint:0,pts:0};
  var card=document.createElement(''div'');card.className=''exercise-card ''+((si+ti)%2?''while-accent'':''for-accent'');
  card.innerHTML=''<div class="exercise-num">משימה ''+(ti+1)+'' מתוך ''+s.tasks.length+''</div><div class="exercise-task"></div><div class="sx-body"></div><div class="exercise-controls sx-ctl"></div><p class="exercise-note sx-hint" hidden style="margin:10px 0 0"></p><div class="exercise-feedback" id="fb-''+key+''" role="status" aria-live="polite" style="margin-top:10px"></div>'';
  card.querySelector(''.exercise-task'').textContent=t.q;
  var body=card.querySelector(''.sx-body''),ctl=card.querySelector(''.sx-ctl''),hintEl=card.querySelector(''.sx-hint''),fb=card.querySelector(''.exercise-feedback'');
  function lock(){card.querySelectorAll(''button,input'').forEach(function(x){x.disabled=true})}
  function win(){r.done=true;r.pts=Math.max(10,BASE-10*(r.att+r.hint));lock();fb.className=''exercise-feedback correct'';fb.textContent=''נכון! ''+t.why+'' (+''+r.pts+'' נקודות)'';refresh()}
  function wrong(msg){r.att++;fb.className=''exercise-feedback wrong'';fb.textContent=msg||''לא בדיוק. נסי שוב.''}
  function hintBtn(){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.style.fontFamily=''var(--sans)'';b.textContent=''💡 רמז (-10)'';
    b.onclick=function(){r.hint=1;hintEl.hidden=false;hintEl.textContent=''💡 ''+t.hint;b.disabled=true};ctl.appendChild(b)}
  function checkBtn(fn){var b=document.createElement(''button'');b.type=''button'';b.className=''exercise-check-btn'';b.textContent=''בדקי'';b.onclick=function(){if(!r.done)fn()};ctl.appendChild(b)}

  if(t.k===''mc''){
    body.innerHTML=''<div class="exercise-code">''+highlight(t.code)+''</div><div class="rescue-choices"></div>'';
    var box=body.querySelector(''.rescue-choices'');
    shuffle(t.opts.map(function(o,k){return {o:o,k:k}})).forEach(function(x){
      var b=document.createElement(''button'');b.type=''button'';b.className=''rescue-choice'';b.dir=''auto'';b.textContent=x.o;
      b.onclick=function(){if(r.done)return;
        if(x.k===t.ans){b.classList.add(''right'');win()}else{b.classList.add(''wrong'');b.disabled=true;wrong()}};
      box.appendChild(b)});
    hintBtn();
  }else if(t.k===''bug''){
    body.innerHTML=''<div class="sx-box"></div>'';var bx=body.firstChild;
    t.lines.forEach(function(l,k){var b=document.createElement(''button'');b.type=''button'';b.className=''sx-line'';b.innerHTML=''<span class="n">''+(k+1)+''</span>''+highlight(l);
      b.onclick=function(){if(r.done)return;
        if(k===t.ans){b.classList.add(''good'');win()}else{b.classList.add(''bad'');b.disabled=true;wrong(''זו לא השורה הבעייתית. נסי שוב.'')}};
      bx.appendChild(b)});
    hintBtn();
  }else if(t.k===''fill''){
    var inline=t.code.indexOf(''___'')>-1,inp;
    if(inline){var pp=t.code.split(''___'');
      body.innerHTML=''<div class="exercise-code">''+highlight(pp[0])+''<input type="text" class="sx-in" autocomplete="off" aria-label="השלמה">''+highlight(pp[1])+''</div>'';inp=body.querySelector(''input'')}
    else{body.innerHTML=''<div class="exercise-code">''+highlight(t.code)+''</div>'';
      inp=document.createElement(''input'');inp.type=''text'';inp.className=''sx-inp'';inp.autocomplete=''off'';inp.placeholder=t.ph||''התשובה'';inp.setAttribute(''aria-label'',''התשובה'');ctl.appendChild(inp)}
    var chk=function(){var v=inp.value.replace(/\s+/g,'''');if(!v)return;
      if(t.acc.indexOf(v)>-1||t.acc.indexOf(v.replace(/["'']/g,''''))>-1)win();else wrong()};
    checkBtn(chk);hintBtn();
    inp.onkeydown=function(e){if(e.key===''Enter''&&!r.done)chk()};
  }else if(t.k===''order''){
    var src=t.lines.map(function(l,k){return {l:l,k:k}}),pool,ans=[];
    do{pool=shuffle(src)}while(pool.every(function(x,k){return x.k===k}));
    body.innerHTML=''<div class="sx-ord"><div><h5>השורות (לחצי כדי להוסיף)</h5><div class="ob" data-p="pool"></div></div><div><h5>הסדר שלך (לחצי כדי להחזיר)</h5><div class="ob" data-p="ans"></div></div></div>'';
    var draw=function(){
      [[''pool'',pool,function(x){pool.splice(pool.indexOf(x),1);ans.push(x);draw()}],[''ans'',ans,function(x){ans.splice(ans.indexOf(x),1);pool.push(x);draw()}]].forEach(function(z){
        var h=body.querySelector(''[data-p="''+z[0]+''"]'');h.innerHTML='''';
        z[1].forEach(function(x){var b=document.createElement(''button'');b.type=''button'';b.className=''sx-line'';b.innerHTML=highlight(x.l);b.disabled=r.done;b.onclick=function(){z[2](x)};h.appendChild(b)})})};
    draw();
    checkBtn(function(){
      if(ans.length<src.length){fb.className=''exercise-feedback wrong'';fb.textContent=''צריך להניח את כל השורות.'';return}
      var okN=ans.filter(function(x,k){return x.k===k}).length;
      if(okN===src.length){draw();win()}else wrong(''עדיין לא. ''+okN+'' מתוך ''+src.length+'' שורות במקום הנכון.'')});
    hintBtn();
  }
  return card;
}
ST.forEach(function(s,si){var host=$(''tasks-''+si);s.tasks.forEach(function(_,ti){host.appendChild(build(si,ti))})});

// ---- topic navigation ----
(function(){var nav=$(''sx-nav'');
  ST.forEach(function(s,i){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.onclick=function(){var e=$(''t''+i);try{e.scrollIntoView({behavior:RM?''auto'':''smooth'',block:''start''})}catch(x){}};nav.appendChild(b);navBtns.push(b)})})();
refresh();

// ---- certificate ----
var CSS=''<style>body{font-family:Arial,sans-serif;max-width:800px;margin:30px auto;padding:0 16px;line-height:1.7;color:#222}h1{font-size:26px}table{border-collapse:collapse;width:100%;margin:12px 0}td,th{border:1px solid #bbb;padding:6px 10px;text-align:right}th{background:#eee}pre{background:#f3f3f3;padding:10px;direction:ltr;text-align:left;white-space:pre-wrap;border-radius:6px}code{direction:ltr;unicode-bidi:isolate;background:#eee;padding:0 4px}.c{border:1px solid #bbb;border-radius:8px;padding:6px 18px;margin:14px 0;page-break-inside:avoid}</style>'';
function resultsHtml(name,when){
  var sc=sum(''pts''),ri=rankIdx(sc),rows='''';
  ST.forEach(function(s,i){s.tasks.forEach(function(_,ti){var r=state[i+''-''+ti];rows+=''<tr><td>''+(i+1)+''. ''+esc(s.t)+''</td><td>''+(ti+1)+''</td><td>''+(r.done?''✔'':''✘'')+''</td><td>''+r.pts+''</td><td>''+r.att+''</td><td>''+r.hint+''</td></tr>''})});
  return ''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>תעודה: ''+esc(name)+''</title>''+CSS+''</head><body><h1>תעודת סיום סיכום הקורס: ''+esc(name)+''</h1><p>תאריך: ''+esc(when)+''</p><p><b>ניקוד: ''+sc+'' מתוך ''+maxScore()+'' · דרגה: ''+RANKS[ri][1]+''</b></p><table><tr><th>נושא</th><th>משימה</th><th>נפתרה</th><th>נקודות</th><th>טעויות</th><th>רמזים</th></tr>''+rows+''</table></body></html>''}
function summaryHtml(name){
  var h=''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8"><title>סיכום קורס פייתון</title>''+CSS+''</head><body><h1>סיכום קורס פייתון</h1><p>''+esc(name)+''</p>'';
  ST.forEach(function(s,i){h+=''<div class="c"><h2>''+s.ic+'' ''+(i+1)+''. ''+esc(s.t)+'' (''+esc(s.sub)+'')</h2><ul>''+s.sum+''</ul><pre>''+esc(s.ex)+''</pre></div>''});
  return h+''</body></html>''}
function dl(html,name,okMsg){
  var fb=$(''sx-dlfb''),fk=$(''sx-fallback'');
  try{var b=new Blob([html],{type:''text/html;charset=utf-8''}),u=URL.createObjectURL(b),a=document.createElement(''a'');a.href=u;a.download=name;document.body.appendChild(a);a.click();a.remove();setTimeout(function(){URL.revokeObjectURL(u)},1500);fb.className=''cert-status correct'';fb.textContent=okMsg}
  catch(e){fb.className=''cert-status wrong'';fb.textContent=''ההורדה לא עבדה. העתיקי את הטקסט למטה ושמרי כקובץ html.'';fk.hidden=false;fk.value=html}
}
function renderCert(name){
  var sc=sum(''pts''),ri=rankIdx(sc),mx=maxScore(),pct=Math.round(sc/mx*100),when=new Date().toLocaleDateString(''he-IL'');
  var c=$(''sx-cert-card'');c.hidden=false;
  c.innerHTML=''<div class="tr">🏆</div><h3>תעודת סיום</h3><div class="sub">סיכום קורס פייתון · מגמת מחשבים</div><div class="nm"></div>''+
   ''<div class="sx-seal"><span>🏅</span><b>''+RANKS[ri][1]+''</b></div><div class="big">''+sc+''</div><div class="of">מתוך ''+mx+'' נקודות · ''+pct+''%</div>''+
   ''<div class="sx-kpis"><div><b>''+doneCount()+''/''+total+''</b><span>משימות</span></div><div><b>''+sum(''att'')+''</b><span>טעויות</span></div><div><b>''+sum(''hint'')+''</b><span>רמזים</span></div></div>''+
   ''<div class="date">''+esc(when)+''</div>''+
   ''<div class="sx-acts"><button type="button" class="run-btn" id="sx-dl">📨 הורדת התעודה והתוצאות למורה</button><button type="button" class="exercise-check-btn" id="sx-dl2">📚 הורדת סיכום הקורס</button></div>''+
   ''<div class="sx-note">מורידים קובץ אחד ושולחים אותו למורה.</div><div class="cert-status" id="sx-dlfb" role="status" aria-live="polite" style="margin-top:8px"></div><textarea id="sx-fallback" class="exercise-answer" rows="6" hidden readonly aria-label="העתקה ידנית"></textarea>'';
  c.querySelector(''.nm'').textContent=name;
  $(''sx-dl'').onclick=function(){dl(resultsHtml(name,when),''python-summary-certificate.html'',''הקובץ ירד! שלחי אותו למורה.'')};
  $(''sx-dl2'').onclick=function(){dl(summaryHtml(name),''python-course-summary.html'',''דף הסיכום ירד!'')};
  try{c.scrollIntoView({behavior:RM?''auto'':''smooth'',block:''start''})}catch(e){}
  if(window.EK_award)EK_award($(''sx-dl''));
}
$(''sx-cert-go'').onclick=function(){
  var name=nk($(''sx-name'').value),msg=$(''sx-cert-msg'');
  if(!name){msg.className=''cert-status wrong'';msg.textContent=''קודם כתבי את שמך המלא.'';return}
  var left=total-doneCount();
  if(left>0){msg.className=''cert-status wrong'';msg.textContent=''עוד ''+left+'' משימות לפתרון, ואז אפשר להפיק את התעודה.'';return}
  msg.className=''cert-status correct'';msg.textContent=''כל הכבוד! התעודה מוכנה.'';renderCert(name)};
$(''sx-name'').onkeydown=function(e){if(e.key===''Enter'')$(''sx-cert-go'').click()};

window.__SX={ST:ST,state:state,total:total};
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
