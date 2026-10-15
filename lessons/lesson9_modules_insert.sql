DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='modules';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('66cbd72566c4596f352f06acf6088889', 'python-ai-era', 'modules', 'שיעור 9 - מודולים (import)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>מודולים (import) בפייתון — ארגז הכלים</title>
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
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור שמיני · פייתון · מגמת מחשבים</div>
    <h1>ארגז הכלים:<br><span class="accent-for">מודולים</span> <span class="accent-while">(import)</span></h1>
    <p class="hero-sub">כתבתן פונקציות משלכן. עכשיו נלמד להשתמש בפונקציות ש<strong>מישהו אחר כבר כתב</strong>: להטיל קובייה, לחשב שורש ולדעת מה התאריך, בשורה אחת.</p>
    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre class="hl"><code>import random
print(random.randint(1, 6))
# 4</code></pre>
    </div>
  </div>
</header>

<main>

  <section id="toolbox">
    <div class="wrap">
      <div class="eyebrow for-c">import</div>
      <h2 class="section-title">מודול הוא ארגז כלים</h2>
      <p class="lede">מודול הוא קובץ פייתון מלא בפונקציות מוכנות. כותבים <span class="mono">import</span> כדי להביא את הארגז, ואז נקודה כדי לבחור כלי: <span class="mono">math.sqrt(49)</span>.</p>

      <div class="playground">
        <div class="playground-controls">
          <label>בחרי ארגז:</label>
          <div class="pill-row" id="tb-tabs"></div>
        </div>
        <div class="playground-code" id="tb-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><span style="font-size:14.5px;font-weight:600">לחצי על כלי כדי להריץ אותו:</span><div class="pill-row" id="tb-pills"></div></div>
        <div class="log" id="tb-log" aria-live="polite"><div class="empty">עוד לא הרצת כלום.</div></div>
        <div class="guess-row">
          <span style="font-size:14.5px;font-weight:600;">נחשי לפני שמריצות: מה יודפס עבור <span class="mono">math.sqrt(49)</span>?</span>
          <input type="text" id="g1-input" autocomplete="off" aria-label="הניחוש שלי">
          <button class="guess-btn" id="g1-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g1-fb" role="status" aria-live="polite"></span>
        </div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🧰</span><div><b class="ek-tag">איך זוכרים</b><p><span class="m">import</span> מוציא ארגז מהמחסן, והנקודה בוחרת כלי מתוכו. בלי <span class="m">import</span> הארגז נשאר במחסן.</p></div></div>
    </div>
  </section>

  <section id="dice">
    <div class="wrap">
      <div class="eyebrow while-c">random</div>
      <h2 class="section-title">random: מקריות בשורה אחת</h2>
      <p class="lede"><span class="mono">random.randint(1, 6)</span> מחזירה מספר שלם אקראי בין 1 ל-6, וגם 1 וגם 6 כלולים. <span class="mono">random.choice(רשימה)</span> בוחרת פריט אקראי מתוך רשימה.</p>

      <div class="playground">
        <div class="playground-controls"><label>🎲 הקובייה</label><span class="mono" style="color:var(--for)">random.randint(1, 6)</span></div>
        <div class="playground-stage" style="text-align:center">
          <div id="die" style="font-size:96px;line-height:1.1;transition:transform .2s" aria-live="polite">⚀</div>
          <div class="pill-row" style="justify-content:center;margin:14px 0 6px"><button class="run-btn" id="roll" type="button">הטילי</button></div>
          <div class="diff-remaining" id="roll-stat">עוד לא הוטלה קובייה</div>
        </div>
        <div class="log" id="roll-log"><div class="empty">ההטלות יופיעו כאן.</div></div>
        <div class="field-row">
          <label for="ch-in" style="font-weight:700;font-size:15px">מה לאכול?</label>
          <input type="text" id="ch-in" value="פיצה, סושי, פסטה, שווארמה" style="width:260px;direction:rtl">
          <button class="guess-btn" id="ch-btn" type="button">בחרי בשבילי</button>
          <span class="mono" id="ch-out" style="color:var(--for);font-weight:700;direction:rtl"></span>
        </div>
        <div class="playground-code" style="padding-top:8px"><div class="line" id="ch-code">random.choice(["פיצה", "סושי", "פסטה", "שווארמה"])</div></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🎯</span><div><b class="ek-tag">איך זוכרים</b><p><span class="m">randint</span> בוחרת <b>מספר</b> מתוך טווח, ו-<span class="m">choice</span> בוחרת <b>פריט</b> מתוך רשימה.</p></div></div>
    </div>
  </section>

  <section id="styles">
    <div class="wrap">
      <div class="eyebrow for-c">3 דרכים</div>
      <h2 class="section-title">שלוש דרכים להביא כלים</h2>
      <p class="lede">אפשר להביא את כל הארגז, כלי אחד בלבד, או לתת לארגז כינוי קצר. לכל דרך יש דרך קריאה אחרת. בחרי דרך ונסי להריץ את שלוש הקריאות.</p>

      <div class="playground">
        <div class="playground-controls"><label>בחרי דרך:</label><div class="pill-row" id="st-tabs"></div></div>
        <div class="playground-code" id="st-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><span style="font-size:14.5px;font-weight:600">נסי לקרוא לכלי:</span><div class="pill-row" id="st-pills"></div></div>
        <div class="log" id="st-log" aria-live="polite"><div class="empty">בחרי קריאה כדי לראות מה קורה.</div></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🏷️</span><div><b class="ek-tag">איך זוכרים</b><p>מה שכתבת אחרי <span class="m">import</span> או <span class="m">as</span> הוא השם שחייבים להשתמש בו בקוד. כל שם אחר ייתן <span class="m">NameError</span>.</p></div></div>
    </div>
  </section>

  <section id="bughunt">
    <div class="wrap">
      <div class="eyebrow while-c">תרגול</div>
      <h2 class="section-title">מצאי את הטעות</h2>
      <p class="lede">הקוד הזה קורס. מה מתקנים?</p>
      <div class="rescue" id="rescue1">
        <div class="rescue-head"><span class="rescue-mark">✗</span><h4>NameError: name ''randint'' is not defined</h4></div>
<pre class="hl">import random
print(randint(1, 6))</pre>
        <div class="rescue-choices">
          <button class="rescue-choice" type="button" data-ok="0">להוסיף שורה <span class="mono">import randint</span></button>
          <button class="rescue-choice" type="button" data-ok="1">לכתוב <span class="mono">random.randint(1, 6)</span></button>
          <button class="rescue-choice" type="button" data-ok="0">לכתוב <span class="mono">random(1, 6)</span></button>
        </div>
        <div class="rescue-feedback" id="rescue1-fb" role="status" aria-live="polite"></div>
      </div>
    </div>
  </section>

  <section id="ownmod">
    <div class="wrap">
      <div class="eyebrow for-c">מודול משלך</div>
      <h2 class="section-title">גם קובץ שלך הוא מודול</h2>
      <p class="lede">כל קובץ <span class="mono">.py</span> שכתבת יכול להיות ארגז כלים לקובץ אחר, ולכן אפשר לחלק תוכנית גדולה לכמה קבצים קטנים. שם הקובץ בלי <span class="mono">.py</span> הוא שם המודול.</p>

      <div class="playground">
        <div class="playground-stage" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(260px,100%),1fr));gap:14px;padding-bottom:18px">
          <div class="code-card for-accent"><div class="code-card-label">helpers.py</div><pre class="hl">def greet(name):
    return "Hello, " + name</pre></div>
          <div class="code-card while-accent"><div class="code-card-label">main.py</div><pre class="hl">from helpers import greet
print(greet("Dana"))</pre></div>
        </div>
        <div class="field-row"><label style="font-weight:700;font-size:15px"><input type="checkbox" id="om-same" checked> שני הקבצים באותה תיקייה</label></div>
        <div class="log" id="om-log" aria-live="polite"></div>
      </div>

      <div class="callout java"><strong>זהירות:</strong> לא קוראים לקובץ שלך בשם של מודול קיים, כמו <span class="mono">random.py</span> או <span class="mono">math.py</span>. אחרת פייתון תביא את הקובץ שלך במקום הארגז האמיתי, והכל יתבלבל.</div>
    </div>
  </section>

  <section id="pwgen">
    <div class="wrap">
      <div class="eyebrow while-c">מיני־פרויקט</div>
      <h2 class="section-title">מחולל סיסמאות</h2>
      <p class="lede">נחבר שני מודולים: <span class="mono">string</span> מביא מוכנים את כל האותיות והספרות, ו-<span class="mono">random</span> בוחר מהם. שחקי עם ההגדרות וראי איך הקוד משתנה.</p>

      <div class="playground">
        <div class="playground-controls">
          <label for="pw-len">אורך:</label>
          <div class="slider-row"><input type="range" id="pw-len" min="6" max="20" value="12"><span class="slider-val" id="pw-len-v">12</span></div>
        </div>
        <div class="field-row">
          <label><input type="checkbox" id="pw-dig" checked> ספרות</label>
          <label><input type="checkbox" id="pw-sym"> סימנים</label>
          <button class="run-btn" id="pw-go" type="button">צרי סיסמה</button>
        </div>
        <div class="log" id="pw-out" style="font-size:20px;text-align:center;letter-spacing:.06em;color:var(--for)" aria-live="polite">&nbsp;</div>
        <pre class="code-static hl" id="pw-code" style="margin:0;border-radius:0"></pre>
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
        <p>שני תרגילים קצרים, ושני תרגילים לכתוב ולהריץ כאן.</p>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 1</div>
        <div class="exercise-task">השלימי את החסר: החליפי את שני ה-___ והריצי.</div>
        <div id="ex1-ed"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 2</div>
        <div class="exercise-task">מה יודפס?</div>
        <div class="exercise-code"><span>from math import sqrt, pi
print(sqrt(16) + 1)</span></div>
        <div class="exercise-controls"><input type="text" id="ex2-in" autocomplete="off" aria-label="התשובה"><button class="exercise-check-btn" id="ex2-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-divider">כתיבה והרצה</div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 3</div>
        <div class="exercise-task">נחשי את המספר: התוכנית בוחרת מספר בין 1 ל-20 עם <span class="mono">randint</span>, ואת מנחשת עד שתצליחי. אחרי כל ניחוש היא מדפיסה "גבוה מדי" או "נמוך מדי".</div>
        <p class="exercise-note">רמז: לולאת <span class="mono">while</span> ו-<span class="mono">input</span>, ואל תשכחי <span class="mono">int()</span>.</p>
        <div id="ex3-ed"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · אתגר</div>
        <div class="exercise-task">מגרילת שמות: צרי רשימה עם שמות של בנות הכיתה, והגרילי באמצעות <span class="mono">random.choice</span> מי תנהל את השיעור הבא. הוסיפי קובץ נפרד <span class="mono">names.py</span> שמחזיק את הרשימה, והביאי אותה עם <span class="mono">import</span>.</div>
        <div id="ex4-ed"></div>
      </div>
    </div>
  </section>

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">מה למדנו</h2>
      <ul class="recap">
        <li><span class="mono">import</span> מביא ארגז כלים מוכן, והנקודה בוחרת כלי ממנו.</li>
        <li><span class="mono">random.randint</span> בוחרת מספר, ו-<span class="mono">random.choice</span> בוחרת פריט מרשימה.</li>
        <li>שלוש דרכים: <span class="mono">import math</span>, <span class="mono">from math import sqrt</span>, <span class="mono">import math as m</span>.</li>
        <li>כל קובץ שלך הוא מודול, ואסור לקרוא לו בשם של מודול קיים.</li>
      </ul>
    </div>
  </section>
</main>

<footer><div class="wrap">שיעור פייתון · מודולים</div></footer>

<script>window.EK_CFG={"quiz": [{"t": "מה יודפס?", "code": "import math\nprint(math.floor(3.9))", "opts": ["3", "4", "3.9", "שגיאה"], "ans": 0, "why": "floor מעגלת כלפי מטה לשלם הקרוב, ולכן 3.", "hint": "floor היא הרצפה: יורדים למטה."}, {"t": "מה יודפס?", "code": "from random import randint\nprint(random.randint(1, 2))", "opts": ["1 או 2", "NameError", "None", "SyntaxError"], "ans": 1, "why": "ה-from הביא רק את randint, ואת השם random אף אחד לא הביא, לכן NameError.", "hint": "איזה שם הובא בפועל בשורת ה-import?"}, {"t": "מה יודפס?", "code": "import math as m\nprint(m.pi > 3)", "opts": ["True", "False", "NameError", "3.14"], "ans": 0, "why": "m הוא כינוי ל-math, ו-pi הוא בערך 3.14, שגדול מ-3.", "hint": "כינוי הוא סתם שם קצר לאותו ארגז."}]};
(function(){
var $=function(i){return document.getElementById(i)};
function esc(s){return s.replace(/&/g,''&amp;'').replace(/</g,''&lt;'').replace(/>/g,''&gt;'')}
function highlight(code){
  return esc(code).replace(/(#.*$)|("[^"]*")|\b(import|from|as|for|in|def|return|while)\b|\b(print|range)\b|\b(\d+\.?\d*)\b/gm,function(m,c,s,k,f,n){
    if(c)return ''<span class="tok-cmt">''+c+''</span>'';
    if(s)return ''<span class="tok-str">''+s+''</span>'';
    if(k)return ''<span class="tok-kw">''+k+''</span>'';
    if(f)return ''<span class="tok-fn">''+f+''</span>'';
    return ''<span class="tok-num">''+n+''</span>''});
}
function hlAll(){document.querySelectorAll(''pre.hl'').forEach(function(p){var t=p.textContent;p.innerHTML=''<code>''+highlight(t)+''</code>''})}
hlAll();
function row(el,code,res,bad){
  var e=el.querySelector(''.empty'');if(e)e.remove();
  var d=document.createElement(''div'');d.className=''row'';
  d.innerHTML=''<span>''+esc(code)+''</span><span class="arrow">→</span><span class="''+(bad?''bad'':''res'')+''">''+esc(res)+''</span>'';
  el.appendChild(d);el.scrollTop=el.scrollHeight;
}
function pillRow(host,items,onclick){host.innerHTML='''';items.forEach(function(it,i){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.textContent=it;b.onclick=function(){onclick(i,b)};host.appendChild(b)})}
function activate(host,i){host.querySelectorAll(''.pill'').forEach(function(p,j){p.classList.toggle(''active'',i===j)})}

// ---- toolbox ----
var rnd=function(a,b){return Math.floor(Math.random()*(b-a+1))+a};
var now=new Date(),pad=function(n){return String(n).padStart(2,''0'')};
var MODS={
 math:[[''math.sqrt(49)'',function(){return ''7.0''}],[''math.pi'',function(){return ''3.141592653589793''}],[''math.floor(3.9)'',function(){return ''3''}],[''math.ceil(3.1)'',function(){return ''4''}],[''math.pow(2, 10)'',function(){return ''1024.0''}]],
 random:[[''random.randint(1, 6)'',function(){return String(rnd(1,6))}],[''random.choice(["🍕", "🍔", "🥗"])'',function(){return [''🍕'',''🍔'',''🥗''][rnd(0,2)]}],[''random.random()'',function(){return ''0.''+String(Math.random()).slice(2,18)}]],
 datetime:[[''datetime.date.today()'',function(){return now.getFullYear()+''-''+pad(now.getMonth()+1)+''-''+pad(now.getDate())}],[''datetime.datetime.now().year'',function(){return String(now.getFullYear())}],[''datetime.datetime.now().hour'',function(){return String(new Date().getHours())}]]
};
var names=Object.keys(MODS),tbHost=$(''tb-tabs''),tbPills=$(''tb-pills''),tbCode=$(''tb-code''),tbLog=$(''tb-log'');
function pickMod(i){
  var n=names[i];activate(tbHost,i);
  tbCode.innerHTML=''<div class="line">''+highlight(''import ''+n)+''</div>'';
  pillRow(tbPills,MODS[n].map(function(x){return x[0]}),function(j){var it=MODS[n][j];row(tbLog,''print(''+it[0]+'')'',it[1]())});
}
pillRow(tbHost,names,pickMod);pickMod(0);
$(''g1-btn'').onclick=function(){var v=$(''g1-input'').value.trim(),fb=$(''g1-fb'');
  if(v===''7.0''||v===''7''){fb.className=''guess-feedback correct'';fb.textContent=v===''7.0''?''נכון! התוצאה היא 7.0.'':''כמעט: זה 7.0, כי sqrt מחזירה מספר עשרוני.''}
  else{fb.className=''guess-feedback wrong'';fb.textContent=''לא בדיוק. נסי להריץ את הכלי למעלה.''}};

// ---- dice ----
var FACES=[''⚀'',''⚁'',''⚂'',''⚃'',''⚄'',''⚅''],RM=window.matchMedia&&matchMedia(''(prefers-reduced-motion: reduce)'').matches,rolls=[],busy=false;
$(''roll'').onclick=function(){
  if(busy)return;busy=true;var fin=rnd(1,6),n=0,die=$(''die'');
  function step(){
    if(n<(RM?0:8)){die.textContent=FACES[rnd(0,5)];n++;setTimeout(step,70)}
    else{die.textContent=FACES[fin-1];rolls.push(fin);busy=false;
      row($(''roll-log''),''random.randint(1, 6)'',String(fin));
      var sixes=rolls.filter(function(x){return x===6}).length;
      $(''roll-stat'').textContent=''הוטלו ''+rolls.length+'' פעמים, ויצא 6 ''+sixes+'' פעמים''}
  }step();
};
function chooseFood(){
  var items=$(''ch-in'').value.split('','').map(function(s){return s.trim()}).filter(Boolean);
  if(!items.length){$(''ch-out'').textContent=''כתבי כמה אפשרויות עם פסיקים ביניהן'';return}
  $(''ch-code'').textContent=''random.choice([''+items.map(function(s){return ''"''+s+''"''}).join('', '')+''])'';
  $(''ch-out'').textContent=''← ''+items[rnd(0,items.length-1)];
}
$(''ch-btn'').onclick=chooseFood;

// ---- 3 styles ----
var ST=[
 {n:''import math'',ok:''math.sqrt(9)'',name:''math''},
 {n:''from math import sqrt'',ok:''sqrt(9)'',name:''sqrt''},
 {n:''import math as m'',ok:''m.sqrt(9)'',name:''m''}];
var CALLS=[''math.sqrt(9)'',''sqrt(9)'',''m.sqrt(9)''],NAMEOF={''math.sqrt(9)'':''math'',''sqrt(9)'':''sqrt'',''m.sqrt(9)'':''m''},stCur=0;
function pickStyle(i){stCur=i;activate($(''st-tabs''),i);$(''st-code'').innerHTML=''<div class="line">''+highlight(ST[i].n)+''</div>'';$(''st-log'').innerHTML=''<div class="empty">בחרי קריאה כדי לראות מה קורה.</div>''}
pillRow($(''st-tabs''),ST.map(function(s){return s.n}),pickStyle);
pillRow($(''st-pills''),CALLS,function(j){var c=CALLS[j];
  if(c===ST[stCur].ok)row($(''st-log''),''print(''+c+'')'',''3.0'');
  else row($(''st-log''),''print(''+c+'')'',"NameError: name ''"+NAMEOF[c]+"'' is not defined",true)});
pickStyle(0);

// ---- bug hunt ----
var rs=$(''rescue1'');
rs.querySelectorAll(''.rescue-choice'').forEach(function(b){b.onclick=function(){
  var fb=$(''rescue1-fb'');
  if(b.dataset.ok===''1''){b.classList.add(''right'');rs.classList.add(''fixed'');rs.querySelector(''.rescue-mark'').textContent=''✓'';
    rs.querySelectorAll(''.rescue-choice'').forEach(function(x){x.disabled=true});
    fb.className=''rescue-feedback correct'';fb.textContent=''נכון! אחרי import random הכלי נמצא בתוך random, לכן כותבים random.randint.''}
  else{b.classList.add(''wrong'');b.disabled=true;fb.className=''rescue-feedback wrong'';fb.textContent=''לא בדיוק. ל-randint אין ארגז משלה, היא נמצאת בתוך random.''}
}});

// ---- own module ----
function om(){var ok=$(''om-same'').checked,l=$(''om-log'');l.innerHTML='''';
  row(l,''python main.py'',ok?''Hello, Dana'':"ModuleNotFoundError: No module named ''helpers''",!ok)}
$(''om-same'').onchange=om;om();

// ---- password generator ----
function pwCode(){var len=$(''pw-len'').value,d=$(''pw-dig'').checked,s=$(''pw-sym'').checked;
  var c=''string.ascii_letters''+(d?'' + string.digits'':'''')+(s?'' + string.punctuation'':'''');
  $(''pw-len-v'').textContent=len;
  $(''pw-code'').innerHTML=highlight(''import random\nimport string\n\nchars = ''+c+''\npassword = ""\nfor i in range(''+len+''):\n    password += random.choice(chars)\nprint(password)'')}
function pwMake(){var l=+$(''pw-len'').value,chars=''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'';
  if($(''pw-dig'').checked)chars+=''0123456789'';if($(''pw-sym'').checked)chars+=''!#$%&*+-?@'';
  var out='''';for(var i=0;i<l;i++)out+=chars[rnd(0,chars.length-1)];$(''pw-out'').textContent=out}
[''pw-len'',''pw-dig'',''pw-sym''].forEach(function(i){$(i).addEventListener(''input'',pwCode)});
$(''pw-go'').onclick=pwMake;pwCode();

// ---- exercises ----

/* עורך פייתון אמיתי: התשתית (Pyodide) מוזרקת על ידי האתר כ-window.pyxRunner. בקובץ שנפתח לבד אין אותה, ולכן יש גיבוי: תיבת טקסט רגילה. */
function pyEditor(cfg) {
  if (window.pyxRunner && window.pyxRunner.mountCode) return window.pyxRunner.mountCode(cfg);
  var host = document.getElementById(cfg.el);
  if (host) {
    var note = document.createElement("p");
    note.style.cssText = "font-size:14px;opacity:.8;margin:0 0 8px";
    note.textContent = "הרצת הקוד זמינה כשהשיעור נפתח באתר הקורס. כאן אפשר לכתוב ולהעתיק.";
    var ta = document.createElement("textarea");
    ta.id = (cfg.id || cfg.el) + "-code"; ta.rows = 6; ta.dir = "ltr"; ta.value = (cfg.files ? cfg.files[0].code : cfg.code) || "";
    ta.style.cssText = "width:100%;box-sizing:border-box;font-family:var(--mono,monospace);font-size:14px";
    host.textContent = ""; host.appendChild(note); host.appendChild(ta);
  }
  return null;
}
function edCode(ed, id) {
  if (ed) return ed.getCode();
  var t = document.getElementById(id + "-code");
  return t ? t.value : "";
}
// דיווח התקדמות לאתר שמציג את השיעור (window.reportProgress מוזרק על ידיו; בקובץ שנפתח לבד אין אותו). תרגילי החובה: 1 ו-2.
var exSolved={};
function reportEx(){if(window.reportProgress)window.reportProgress(Object.keys(exSolved).length,2)}
reportEx();
function chk(btn,fn,fbId,okMsg,badMsg){$(btn).onclick=function(){var f=$(fbId);if(fn()){f.className=''exercise-feedback correct'';f.textContent=okMsg;exSolved[btn]=true;reportEx()}else{f.className=''exercise-feedback wrong'';f.textContent=badMsg}}}
function randTest(seed) {
  return { label: "הרצה " + seed, seed: seed, verify: function (r) {
    var n = r.printed.trim();
    return /^\d+$/.test(n) && +n >= 1 && +n <= 10 ? true : "אמור להיות מודפס מספר שלם בין 1 ל-10.";
  } };
}
pyEditor({
  el: "ex1-ed", id: "ex1", rows: 4, maxRows: 6, code: ''___ random\nnumber = random.___(1, 10)\nprint(number)\n'', hint: "החליפי את שני ה-___ והריצי.",
  tests: [randTest(1), randTest(2), randTest(3)],
  passText: "נכון! import random ואז random.randint.",
  onPass: function () { exSolved["ex1-btn"] = true; reportEx(); }
});
var ASC = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"], DESC = ASC.slice().reverse();
pyEditor({
  el: "ex3-ed", id: "ex3", rows: 9, maxRows: 18, code: ''# נחשי את המספר: randint בין 1 ל-20, ולולאת while\n'',
  tests: [
    { label: "ניחושים עולים (1,2,3...)", seed: 3, inputs: ASC, needMsg: "התוכנית ביקשה ניחוש גם אחרי שכל המספרים נוסו. בדקי שהלולאה נעצרת כשהניחוש נכון.",
      verify: function (r) { return /נמוך מדי/.test(r.printed) ? true : "כשהניחוש קטן מהמספר צריך להדפיס: נמוך מדי"; } },
    { label: "ניחושים יורדים (20,19,18...)", seed: 3, inputs: DESC, needMsg: "התוכנית ביקשה ניחוש גם אחרי שכל המספרים נוסו. בדקי שהלולאה נעצרת כשהניחוש נכון.",
      verify: function (r) { return /גבוה מדי/.test(r.printed) ? true : "כשהניחוש גדול מהמספר צריך להדפיס: גבוה מדי"; } }
  ]
});
pyEditor({
  el: "ex4-ed", id: "ex4", rows: 8, maxRows: 16,
  files: [
    { name: "main.py", code: ''import random\nfrom names import names\n\n# הגרילי מי תנהל את השיעור הבא\n'' },
    { name: "names.py", code: ''# רשימת השמות של בנות הכיתה\nnames = []\n'' }
  ],
  hint: "יש שני קבצים: main.py ו-names.py. עברי בין הלשוניות. הרצה היא תמיד של main.py.",
  tests: [{ label: "מגרילת שמות", verify: function (r) {
    var list = (r.files[0] ? r.files[0].code : "").match(/["''][^"''\n]+["'']/g) || [];
    list = list.map(function (q) { return q.slice(1, -1); });
    if (list.length < 3) return "ב-names.py צריכה להיות רשימה של 3 שמות לפחות.";
    if (!/\bimport\b/.test(r.code) || !/names/.test(r.code)) return "ב-main.py הביאי את הרשימה מ-names.py עם import.";
    if (!/choice/.test(r.code)) return "הגרילי עם random.choice.";
    return list.some(function (n) { return r.printed.indexOf(n) >= 0; }) ? true : "התוכנית צריכה להדפיס שם אחד מהרשימה.";
  } }]
});
chk(''ex2-btn'',function(){var v=$(''ex2-in'').value.trim();return v===''5.0''},''ex2-feedback'',''נכון! sqrt(16) היא 4.0, ועוד 1 זה 5.0.'',''לא בדיוק. שימי לב ש-sqrt מחזירה מספר עשרוני.'');
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
', 9, '2026-10-13T00:00:00.000Z');
