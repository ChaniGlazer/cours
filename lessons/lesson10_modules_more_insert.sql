DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='modules-more';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('44280d479263531eaeec8d0c7904b192', 'python-ai-era', 'modules-more', 'שיעור 10 - מודולים בהרחבה', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>מודולים בהרחבה — ארגז הכלים הגדול</title>
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

.log .row span{white-space:pre-wrap}[hidden]{display:none!important}</style>
</head>
<body>
<header class="hero">
  <div class="wrap">
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור פייתון · מודולים, חלק ב׳</div>
    <h1>ארגז הכלים הגדול:<br><span class="accent-for">כל המודולים</span> <span class="accent-while">בעולם</span></h1>
    <p class="hero-sub">בשיעור הקודם הכרנו כמה מודולים. היום נלמד את מה שחשוב יותר: <strong>איך עובדים עם כל מודול</strong>, גם כאלה שעוד לא שמעת עליהם: מאיפה הם באים, איך מתקינים אותם, איך מגלים מה יש בהם, ולמה לפעמים הם קורסים.</p>
    <div class="code-card for-accent solo-code" style="margin:36px auto 0; text-align:left;">
      <div class="code-card-label">Python</div>
      <pre class="hl">import math
print(dir(math))
help(math.sqrt)</pre>
    </div>
  </div>
</header>

<main>

  <section id="sources">
    <div class="wrap">
      <div class="eyebrow for-c">משימה 1</div>
      <h2 class="section-title">מאיפה מגיע מודול?</h2>
      <p class="lede">יש שלושה מקורות. <strong>מובנה</strong> בא יחד עם פייתון ואין צורך להתקין. <strong>מותקן</strong> נכתב על ידי אנשים אחרים ומתקינים אותו עם <span class="mono">pip</span>. ו<strong>שלך</strong> הוא קובץ <span class="mono">.py</span> שכתבת בעצמך. מיינו כל מודול למקור שלו.</p>

      <div class="playground">
        <div class="playground-controls"><span class="diff-remaining" id="src-count">0 מתוך 8</span></div>
        <div id="src-list" style="padding:6px 18px 14px"></div>
        <div class="guess-row"><span class="guess-feedback" id="src-fb" role="status" aria-live="polite"></span></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🏬</span><div><b class="ek-tag">איך זוכרים</b><p>מובנה הוא מה שיש בבית. מותקן הוא מה שמזמינים מהחנות עם <span class="m">pip</span>. ושלך הוא מה שאת מכינה בעצמך.</p></div></div>
    </div>
  </section>

  <section id="explore">
    <div class="wrap">
      <div class="eyebrow while-c">משימה 2</div>
      <h2 class="section-title">איך מגלים מה יש בתוך מודול?</h2>
      <p class="lede">אין צורך לשנן. <span class="mono">dir(מודול)</span> מציגה את כל השמות שבתוכו, ו-<span class="mono">help(כלי)</span> מסבירה מה הוא עושה. בחרי מודול ולחצי על כלי כדי לראות מה <span class="mono">help</span> עונה. אלה תשובות אמיתיות מפייתון.</p>

      <div class="playground">
        <div class="playground-controls"><label>בחרי מודול:</label><div class="pill-row" id="ex-tabs"></div></div>
        <div class="playground-code" id="ex-code" style="border-top:0;margin-top:0"></div>
        <div class="field-row"><span style="font-size:14.5px;font-weight:600">כמה כלים נבחרים מתוכו (ללחוץ):</span><div class="pill-row" id="ex-pills"></div></div>
        <div class="log" id="ex-log" aria-live="polite"><div class="empty">לחצי על כלי כדי להריץ help.</div></div>
        <div class="guess-row">
          <span style="font-size:14.5px;font-weight:600;">חידה: איזה כלי במודול <span class="mono">random</span> מערבב רשימה? (שם הכלי)</span>
          <input type="text" id="g1-input" autocomplete="off" aria-label="התשובה שלי">
          <button class="guess-btn" id="g1-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g1-fb" role="status" aria-live="polite"></span>
        </div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🔎</span><div><b class="ek-tag">איך זוכרים</b><p><span class="m">dir</span> היא תפריט המסעדה: כל מה שאפשר להזמין. <span class="m">help</span> היא המלצר שמסביר מה יש בכל מנה.</p></div></div>
    </div>
  </section>

  <section id="pip">
    <div class="wrap">
      <div class="eyebrow for-c">משימה 3</div>
      <h2 class="section-title">להתקין מודול חדש עם pip</h2>
      <p class="lede">מודולים שהם לא מובנים צריך להתקין פעם אחת במחשב, בטרמינל של VS Code. כאן יש טרמינל לדוגמה. הריצי את <span class="mono">main.py</span>, תראי שגיאה, ותתקיני את המודול החסר.</p>

      <div class="playground">
        <div class="playground-stage"><div class="code-card for-accent"><div class="code-card-label">main.py</div><pre class="hl">import colorama
print("Hello, agent!")</pre></div></div>
        <div class="field-row"><span style="font-size:14.5px;font-weight:600">פקודות לדוגמה:</span><div class="pill-row" id="tm-pills"></div></div>
        <div class="log" id="tm-log" style="min-height:150px;max-height:260px" aria-live="polite"></div>
        <div class="field-row"><span class="mono" style="color:var(--ink-faint)">&gt;</span><input type="text" id="tm-in" autocomplete="off" spellcheck="false" style="width:min(360px,100%)!important;direction:ltr;text-align:left" aria-label="פקודה"><button class="guess-btn" id="tm-go" type="button">הריצי</button><span class="guess-feedback" id="tm-fb" role="status" aria-live="polite"></span></div>
      </div>

      <div class="callout java"><strong>זהירות:</strong> מתקינים רק חבילות שמכירים או שהמורה ביקשה. שמות דומים הם לפעמים חבילות מזויפות, ולכן בודקים שכתבתם את השם בדיוק. נסי להתקין <span class="mono">pip install colorma</span> ותראי מה קורה כשהשם לא נכון.</div>

      <div class="ek-insight"><span class="ek-ic">📦</span><div><b class="ek-tag">איך זוכרים</b><p><span class="m">pip install</span> מתבצע <b>בטרמינל</b>, פעם אחת. <span class="m">import</span> מתבצע <b>בקוד</b>, בכל קובץ שמשתמש במודול.</p></div></div>
    </div>
  </section>

  <section id="order">
    <div class="wrap">
      <div class="eyebrow while-c">משימה 4</div>
      <h2 class="section-title">איפה פייתון מחפשת?</h2>
      <p class="lede">כשכותבים <span class="mono">import random</span>, פייתון מחפשת קודם <b>בתיקייה שלך</b>, ורק אחר כך בין המובנים והמותקנים. אם בתיקייה יש קובץ באותו שם, הוא ינצח. הפעילי את המתג וראי מה קורה.</p>

      <div class="playground">
        <div class="playground-stage" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(260px,100%),1fr));gap:14px">
          <div class="code-card for-accent"><div class="code-card-label">main.py</div><pre class="hl">import random
print(random.randint(1, 6))</pre></div>
          <div class="code-card while-accent" id="od-file" hidden><div class="code-card-label">random.py (קובץ שלך)</div><pre class="hl">x = 5</pre></div>
        </div>
        <div class="field-row"><label style="font-weight:700;font-size:15px"><input type="checkbox" id="od-same"> יצרתי בטעות קובץ בשם random.py באותה תיקייה</label></div>
        <div class="field-row"><div class="pill-row" id="od-steps" style="direction:ltr"></div></div>
        <div class="log" id="od-log" aria-live="polite"></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🧭</span><div><b class="ek-tag">איך זוכרים</b><p>פייתון מחפשת <b>קודם בבית שלך</b>. לכן לא קוראים לקובץ בשם של מודול קיים, כמו <span class="m">random.py</span>, <span class="m">math.py</span> או <span class="m">string.py</span>.</p></div></div>
    </div>
  </section>

  <section id="mainguard">
    <div class="wrap">
      <div class="eyebrow for-c">משימה 5</div>
      <h2 class="section-title">להריץ או לייבא?</h2>
      <p class="lede">קובץ יכול לרוץ בשתי דרכים: ישירות (<span class="mono">python helpers.py</span>), או כשקובץ אחר מייבא אותו. השורה <span class="mono">if __name__ == "__main__":</span> מבדילה ביניהם. נסי עם השורה ובלעדיה.</p>

      <div class="playground">
        <div class="playground-stage" style="display:grid;grid-template-columns:repeat(auto-fit,minmax(min(260px,100%),1fr));gap:14px">
          <div class="code-card for-accent"><div class="code-card-label">helpers.py</div><pre class="hl" id="mg-code"></pre></div>
          <div class="code-card while-accent"><div class="code-card-label">main.py</div><pre class="hl">import helpers
print("C")</pre></div>
        </div>
        <div class="field-row"><label style="font-weight:700;font-size:15px"><input type="checkbox" id="mg-guard" checked> יש את שורת <bdi dir="ltr">__name__</bdi></label><div class="pill-row" id="mg-run"></div></div>
        <div class="log" id="mg-log" aria-live="polite"></div>
      </div>

      <div class="ek-insight"><span class="ek-ic">🚪</span><div><b class="ek-tag">איך זוכרים</b><p>מה שבתוך <span class="m">if __name__ == "__main__":</span> רץ רק כשמריצים את הקובץ <b>ישירות</b>, ולא כשמייבאים אותו.</p></div></div>
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
        <div class="exercise-task">השלימי את הפקודה שמתקינה את החבילה <span class="mono">pyfiglet</span>.</div>
        <div class="exercise-code"><span>pip </span><input type="text" id="ex1-a" class="wide" autocomplete="off" aria-label="השלמה"><span> pyfiglet</span></div>
        <div class="exercise-controls"><button class="exercise-check-btn" id="ex1-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex1-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 2</div>
        <div class="exercise-task">מה יודפס כשמריצים את <span class="mono">main.py</span>? כתבי את האותיות לפי הסדר.</div>
        <div class="exercise-code"><span># helpers.py
print("A")
if __name__ == "__main__":
    print("B")

# main.py
import helpers
print("C")</span></div>
        <div class="exercise-controls"><input type="text" id="ex2-in" autocomplete="off" style="width:120px;direction:ltr" aria-label="התשובה"><button class="exercise-check-btn" id="ex2-btn" type="button">בדקי</button><span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span></div>
      </div>

      <div class="exercise-divider">ב-VS Code</div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 3</div>
        <div class="exercise-task">חוקרת מודולים: בחרי מודול מובנה שלא למדנו, כמו <span class="mono">statistics</span>, <span class="mono">calendar</span> או <span class="mono">textwrap</span>. הריצי עליו <span class="mono">dir()</span>, קראי <span class="mono">help()</span> על שני כלים, והשתמשי בהם בתוכנית קצרה.</div>
        <textarea class="exercise-answer" rows="6" aria-label="התשובה לתרגיל 3" placeholder="הדביקי כאן את הקוד שלך"></textarea>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · אתגר</div>
        <div class="exercise-task">התקיני בטרמינל את <span class="mono">pyfiglet</span>, והדפיסי את שמך ככתובת ענקית עם <span class="mono">pyfiglet.figlet_format("Dana")</span>. שימי את הקוד בקובץ נפרד <span class="mono">banner.py</span>, עם <span class="mono">if __name__ == "__main__":</span>, וייבאי אותו מקובץ אחר.</div>
        <textarea class="exercise-answer" rows="6" aria-label="התשובה לתרגיל 4" placeholder="הדביקי כאן את הקוד שלך"></textarea>
      </div>
    </div>
  </section>

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">מה למדנו</h2>
      <ul class="recap">
        <li>שלושה מקורות למודולים: מובנים, מותקנים עם <span class="mono">pip</span>, ושלך.</li>
        <li><span class="mono">dir(module)</span> ו-<span class="mono">help(tool)</span> מגלות כל מודול בלי לשנן.</li>
        <li><span class="mono">pip install</span> בטרמינל, <span class="mono">import</span> בקוד.</li>
        <li>פייתון מחפשת קודם בתיקייה שלך, ולכן לא קוראים לקובץ בשם של מודול קיים.</li>
        <li><span class="mono">if __name__ == "__main__":</span> מפריד בין הרצה ישירה לייבוא.</li>
      </ul>
    </div>
  </section>
</main>

<footer><div class="wrap">שיעור פייתון · מודולים בהרחבה</div></footer>

<script>window.MODS={"math": {"count": 62, "items": {"sqrt": {"sig": "sqrt(x, /)", "doc": "Return the square root of x."}, "pi": {"sig": "math.pi", "doc": "ערך קבוע: 3.141592653589793"}, "floor": {"sig": "floor(x, /)", "doc": "Return the floor of x as an Integral."}, "factorial": {"sig": "factorial(n, /)", "doc": "Find n!."}, "gcd": {"sig": "gcd(*integers)", "doc": "Greatest Common Divisor."}, "hypot": {"sig": "hypot(...)", "doc": "hypot(*coordinates) -> value"}}}, "random": {"count": 33, "items": {"randint": {"sig": "randint(a, b)", "doc": "Return random integer in range [a, b], including both end points."}, "choice": {"sig": "choice(seq)", "doc": "Choose a random element from a non-empty sequence."}, "shuffle": {"sig": "shuffle(x)", "doc": "Shuffle list x in place, and return None."}, "sample": {"sig": "sample(population, k, *, counts=None)", "doc": "Chooses k unique random elements from a population sequence."}, "random": {"sig": "random()", "doc": "random() -> x in the interval [0, 1)."}}}, "string": {"count": 12, "items": {"ascii_letters": {"sig": "string.ascii_letters", "doc": "ערך קבוע: ''abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ''"}, "digits": {"sig": "string.digits", "doc": "ערך קבוע: ''0123456789''"}, "punctuation": {"sig": "string.punctuation", "doc": "ערך קבוע: ''!\"#$%&\\''()*+,-./:;<=>?@[\\\\]^_`{|}~''"}}}, "time": {"count": 38, "items": {"sleep": {"sig": "sleep(seconds)", "doc": "Delay execution for a given number of seconds."}, "time": {"sig": "time()", "doc": "time() -> floating-point number"}, "strftime": {"sig": "strftime(...)", "doc": "strftime(format[, time_tuple]) -> string"}}}, "json": {"count": 12, "items": {"dumps": {"sig": "dumps(obj, *, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, default=None, sort_keys=False, **kw)", "doc": "Serialize ``obj`` to a JSON formatted ``str``."}, "loads": {"sig": "loads(s, *, cls=None, object_hook=None, parse_float=None, parse_int=None, parse_constant=None, object_pairs_hook=None, **kw)", "doc": "Deserialize ``s`` (a ``str``, ``bytes`` or ``bytearray`` instance"}, "dump": {"sig": "dump(obj, fp, *, skipkeys=False, ensure_ascii=True, check_circular=True, allow_nan=True, cls=None, indent=None, separators=None, default=None, sort_keys=False, **kw)", "doc": "Serialize ``obj`` as a JSON formatted stream to ``fp`` (a"}}}, "os": {"count": 400, "items": {"getcwd": {"sig": "getcwd()", "doc": "Return a unicode string representing the current working directory."}, "listdir": {"sig": "listdir(path=None)", "doc": "Return a list containing the names of the files in the directory."}, "mkdir": {"sig": "mkdir(path, mode=511, *, dir_fd=None)", "doc": "Create a directory."}}}};window.EK_CFG={"strip": {"cells": [["📦 מובנה", "math"], ["🌐 מותקן", "requests"], ["📄 שלך", "helpers"]], "hint": "לחצי על כרטיס כדי לראות איך מייבאים", "cap": function(i,c){return "import "+c[1]}}, "quiz": [{"t": "איזה מודול מחכה 2 שניות?", "code": "____.sleep(2)", "opts": ["time", "math", "random", "sleep"], "ans": 0, "why": "sleep נמצאת במודול time, והוא מובנה ולא צריך להתקין.", "hint": "חשבי על מודול של זמן."}, {"t": "קיבלת שגיאה. מה עושים בטרמינל?", "code": "ModuleNotFoundError: No module named ''requests''", "opts": ["pip install requests", "pip remove requests", "import pip requests", "python requests"], "ans": 0, "why": "המודול לא מותקן, ולכן מתקינים אותו עם pip install, ואז הקוד יעבוד.", "hint": "המודול חסר, צריך להביא אותו."}, {"t": "מה קורה כשמריצים קובץ בשם random.py?", "code": "# random.py\nimport random\nprint(random.randint(1, 6))", "opts": ["4", "AttributeError", "SyntaxError", "NameError"], "ans": 1, "why": "פייתון מחפשת קודם בתיקייה שלך, מוצאת את random.py עצמו ולא את המודול האמיתי, ואין בו randint.", "hint": "איפה פייתון מחפשת קודם?"}]};
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

// ---- sources game ----
var SRC=[[''math'',0,''בא עם פייתון.''],[''requests'',1,''מתקינים עם pip install requests.''],[''helpers.py'',2,''קובץ שכתבת בעצמך.''],[''json'',0,''בא עם פייתון.''],[''openai'',1,''מתקינים עם pip.''],[''game.py'',2,''קובץ שלך.''],[''os'',0,''בא עם פייתון.''],[''pandas'',1,''מתקינים עם pip.'']],LAB=[''מובנה'',''מותקן'',''שלך''],done=0;
(function(){var host=$(''src-list'');
SRC.forEach(function(s,i){var r=document.createElement(''div'');r.style.cssText=''display:flex;align-items:center;gap:12px;flex-wrap:wrap;padding:10px 6px;border-bottom:1px solid var(--line)'';
  var n=document.createElement(''span'');n.className=''mono'';n.style.cssText=''min-width:110px;font-weight:700;color:var(--ink)'';n.textContent=s[0];r.appendChild(n);
  var pr=document.createElement(''div'');pr.className=''pill-row'';
  var note=document.createElement(''span'');note.style.cssText=''font-size:13.5px;color:var(--ink-faint)'';
  LAB.forEach(function(l,j){var b=document.createElement(''button'');b.type=''button'';b.className=''pill'';b.style.fontFamily=''var(--sans)'';b.textContent=l;
    b.onclick=function(){if(j===s[1]){b.classList.add(''active'');pr.querySelectorAll(''button'').forEach(function(x){x.disabled=true});note.textContent=''✓ ''+s[2];note.style.color=''var(--success)'';done++;$(''src-count'').textContent=done+'' מתוך ''+SRC.length;
      if(done===SRC.length){var fb=$(''src-fb'');fb.className=''guess-feedback correct'';fb.textContent=''כל הכבוד! מיינת את כולם נכון.''}}
      else{b.disabled=true;b.style.opacity=.4;note.textContent=''לא בדיוק, נסי שוב.'';note.style.color=''var(--danger)''}};pr.appendChild(b)});
  r.appendChild(pr);r.appendChild(note);host.appendChild(r)});})();

// ---- explore ----
var MD=window.MODS,mn=Object.keys(MD),exPills=$(''ex-pills''),exLog=$(''ex-log'');
function pickMod(i){var m=mn[i];activate($(''ex-tabs''),i);
  $(''ex-code'').innerHTML=''<div class="line">''+highlight(''import ''+m)+''</div><div class="line">''+highlight(''print(len(dir(''+m+'')))'')+''</div><div class="line out">''+MD[m].count+''</div>'';
  pillRow(exPills,Object.keys(MD[m].items).map(function(k){return m+''.''+k}),function(j){var k=Object.keys(MD[m].items)[j],it=MD[m].items[k];
    var e=exLog.querySelector(''.empty'');if(e)e.remove();
    var d=document.createElement(''div'');d.innerHTML=''<div class="row"><span>help(''+esc(m+''.''+k)+'')</span></div><div class="row"><span class="res">''+esc(it.sig)+''</span></div><div class="row"><span style="color:var(--ink-dim);font-family:var(--sans);direction:rtl">''+esc(it.doc)+''</span></div><div style="height:8px"></div>'';
    exLog.appendChild(d);exLog.scrollTop=exLog.scrollHeight})}
pillRow($(''ex-tabs''),mn,pickMod);pickMod(0);
$(''g1-btn'').onclick=function(){var v=$(''g1-input'').value.trim().replace(/^random\./,'''').replace(/\(.*\)$/,''''),fb=$(''g1-fb'');
  if(v===''shuffle''){fb.className=''guess-feedback correct'';fb.textContent=''נכון! random.shuffle(x) מערבבת את הרשימה במקום.''}
  else{fb.className=''guess-feedback wrong'';fb.textContent=''לא בדיוק. לחצי על random למעלה וחפשי כלי שמערבב.''}};

// ---- terminal ----
var installed={},KNOWN={colorama:''0.4.6'',requests:''2.32.3'',openai:''1.54.0'',pyfiglet:''1.0.2'',pandas:''2.2.3''},tl=$(''tm-log''),tdone=false;
function tline(t,cls){var d=document.createElement(''div'');d.className=''row'';d.style.whiteSpace=''pre-wrap'';var s=document.createElement(''span'');s.className=cls||'''';s.style.whiteSpace=''pre-wrap'';s.textContent=t;d.appendChild(s);tl.appendChild(d)}
function run(cmd){cmd=cmd.trim();if(!cmd)return;tline(''> ''+cmd,''arrow'');
  var m;
  if(/^(python|py)\s+main\.py$/.test(cmd)){
    if(installed.colorama){tline(''Hello, agent!'',''res'');if(!tdone){tdone=true;var fb=$(''tm-fb'');fb.className=''guess-feedback correct'';fb.textContent=''עובד! אחרי ההתקנה ה-import הצליח.''}}
    else{tline(''Traceback (most recent call last):\n  File "main.py", line 1, in <module>\n    import colorama\nModuleNotFoundError: No module named \''colorama\'''',''bad'')}}
  else if(m=cmd.match(/^(?:python -m )?pip install ([A-Za-z0-9_.-]+)$/)){var n=m[1].toLowerCase();
    if(KNOWN[n]){installed[n]=1;tline(''Collecting ''+n+''\n  Downloading ''+n+''-''+KNOWN[n]+''-py3-none-any.whl\nInstalling collected packages: ''+n+''\nSuccessfully installed ''+n+''-''+KNOWN[n],''res'')}
    else tline(''ERROR: Could not find a version that satisfies the requirement ''+n+'' (from versions: none)\nERROR: No matching distribution found for ''+n,''bad'')}
  else if(/^pip list$/.test(cmd)){var ks=Object.keys(installed);tline(''Package    Version\n---------- -------\npip        24.3.1''+ks.map(function(k){return ''\n''+k+Array(Math.max(1,11-k.length)).join('' '')+KNOWN[k]}).join(''''),''res'')}
  else tline(''הפקודה הזו לא קיימת בטרמינל לדוגמה. נסי אחת מהפקודות בכפתורים.'',''bad'');
  tl.scrollTop=tl.scrollHeight}
$(''tm-go'').onclick=function(){run($(''tm-in'').value);$(''tm-in'').value=''''};
$(''tm-in'').onkeydown=function(e){if(e.key===''Enter'')$(''tm-go'').click()};
pillRow($(''tm-pills''),[''python main.py'',''pip install colorama'',''pip list'',''pip install colorma''],function(j){$(''tm-in'').value=[''python main.py'',''pip install colorama'',''pip list'',''pip install colorma''][j];$(''tm-in'').focus()});

// ---- search order ----
var od=$(''od-same'');
function ordr(){var on=od.checked;$(''od-file'').hidden=!on;var l=$(''od-log'');l.innerHTML='''';
  row(l,''python main.py'',on?"AttributeError: module ''random'' has no attribute ''randint''":String(1+Math.floor(Math.random()*6)),on);
  $(''od-steps'').innerHTML='''';
  [[''1. התיקייה שלך'',on],[''2. מובנים'',false],[''3. מותקנים'',false]].forEach(function(s,i){var b=document.createElement(''span'');b.className=''pill''+(i===0&&on?'' active'':'''');b.style.fontFamily=''var(--sans)'';b.textContent=s[0]+(i===0&&on?'' ← כאן נמצאה random.py'':'''');$(''od-steps'').appendChild(b)})}
od.onchange=ordr;ordr();

// ---- __name__ ----
var guard=$(''mg-guard'');
function mgc(){$(''mg-code'').innerHTML=highlight(guard.checked?''print("A")\nif __name__ == "__main__":\n    print("B")'':''print("A")\nprint("B")'');$(''mg-log'').innerHTML=''''}
guard.onchange=mgc;mgc();
pillRow($(''mg-run''),[''python helpers.py'',''python main.py''],function(j){var g=guard.checked,out=j===0?[''A'',''B'']:(g?[''A'',''C'']:[''A'',''B'',''C'']);row($(''mg-log''),[''python helpers.py'',''python main.py''][j],out.join(''  ''))});

// ---- exercises ----
// דיווח התקדמות לאתר שמציג את השיעור (window.reportProgress מוזרק על ידיו; בקובץ שנפתח לבד אין אותו). תרגילי החובה: 1 ו-2.
var exSolved={};
function reportEx(){if(window.reportProgress)window.reportProgress(Object.keys(exSolved).length,2)}
reportEx();
function chk(btn,fn,fbId,okMsg,badMsg){$(btn).onclick=function(){var f=$(fbId);if(fn()){f.className=''exercise-feedback correct'';f.textContent=okMsg;exSolved[btn]=true;reportEx()}else{f.className=''exercise-feedback wrong'';f.textContent=badMsg}}}
chk(''ex1-btn'',function(){return $(''ex1-a'').value.trim()===''install''},''ex1-feedback'',''נכון! pip install pyfiglet.'',''כמעט. איזו פקודה מורידה ומתקינה חבילה?'');
chk(''ex2-btn'',function(){return $(''ex2-in'').value.replace(/[\s,]+/g,'''').toUpperCase()===''AC''},''ex2-feedback'',''נכון! A מודפס בכל מקרה, B רק בהרצה ישירה, ואז C מ-main.py.'',''לא בדיוק. כשמייבאים את helpers.py, מה קורה לשורה שבתוך if __name__ == "__main__"?'');
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
', 10, '2026-10-18T00:00:00.000Z');
