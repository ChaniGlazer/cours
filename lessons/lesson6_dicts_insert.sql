DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='dicts';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('1dc32f032e4139e5832650a29aa9b0b7', 'python-ai-era', 'dicts', 'שיעור 6 - מילונים (dict)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>מילונים (dict) בפייתון — ספר הטלפונים של התוכנית</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@500;700&family=Heebo:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    /* פלטת האתר: כל הצבעים כאן, ובשאר הקובץ רק var() */
    --bg: #14121f;
    --bg-panel: #1d1a2d;
    --bg-panel-2: #26223b;
    --ink: #f4f1fa;
    --ink-dim: #bdb7d3;
    --ink-faint: #9e97ba;
    --gold: #ff7f96;
    --gold-text: #ff7f96;
    --gold-soft: #413739;
    --moss: #6fe0a0;
    --moss-soft: #2a3a3f;
    --rust: #ff7f96;
    --rust-soft: #412a3e;
    --line: rgba(58,53,88,0.14);
    --line-strong: rgba(58,53,88,0.28);
    --code-bg: #16242b;
    --code-head: #26223b;
    --code-ink: #f4f1fa;
    --tok-kw: #ffd27a;
    --tok-str: #6fe0a0;
    --tok-num: #ff7f96;
    --tok-fn: #8fb8ff;
    --tok-cmt: #9e97ba;
    --radius: 20px;
    --display: "Frank Ruhl Libre", "Times New Roman", serif;
    --sans: "Heebo", "Segoe UI", Arial, sans-serif;
    --mono: "JetBrains Mono", ui-monospace, Menlo, Consolas, monospace;
  }

  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation-duration: 0.01ms !important; animation-iteration-count: 1 !important; transition-duration: 0.01ms !important; }
  }

  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }

  body {
    margin: 0;
    background: var(--bg);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 17px;
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
  }

  ::selection { background: var(--gold); color: var(--ink); }

  .wrap { max-width: 720px; margin: 0 auto; padding: 0 22px; }

  p { color: var(--ink-dim); margin: 0; }
  p + p { margin-top: 14px; }
  h1, h2, h3 { font-family: var(--display); font-weight: 700; color: var(--ink); margin: 0; }
  code, .mono { font-family: var(--mono); direction: ltr; unicode-bidi: isolate; }
  strong { color: var(--ink); }

  button { font-family: var(--sans); cursor: pointer; }
  button:focus-visible, input:focus-visible, textarea:focus-visible { outline: 3px solid var(--gold-text); outline-offset: 2px; }

  section { padding: 68px 0; }
  section + section { border-top: 1px solid var(--line); }

  .eyebrow { font-family: var(--mono); font-size: 13px; color: var(--ink-faint); margin-bottom: 12px; }
  .eyebrow.gold { color: var(--gold-text); }
  .eyebrow.rust { color: var(--rust); }

  h2.section-title { font-size: clamp(1.6rem, 4.5vw, 2.2rem); line-height: 1.25; }
  .lede { font-size: 18px; margin-top: 14px; }

  /* ---------- HERO ---------- */

  .hero { padding: 70px 0 56px; text-align: center; }
  .hero h1 { font-size: clamp(2.1rem, 7vw, 3.2rem); line-height: 1.2; }
  .hero h1 .accent { color: var(--gold-text); }
  .hero-sub { max-width: 50ch; margin: 18px auto 0; font-size: 18.5px; }

  /* ---------- CODE ---------- */

  .code-card { background: var(--code-bg); border-radius: 14px; overflow: hidden; color: var(--code-ink); }
  .code-card-label { font-size: 12.5px; font-weight: 600; color: var(--tok-cmt); padding: 8px 18px; background: var(--code-head); text-align: left; direction: ltr; }
  .code-card pre, pre.code-static { direction: ltr; text-align: left; margin: 0; padding: 16px 20px 18px; overflow-x: auto; font-family: var(--mono); font-size: 14.5px; line-height: 1.75; color: var(--code-ink); }
  pre.code-static { background: var(--code-bg); border-radius: 12px; margin-top: 18px; }
  .solo-code { max-width: 540px; }
  .tok-kw { color: var(--tok-kw); }
  .tok-str { color: var(--tok-str); unicode-bidi: isolate; }
  .iso { unicode-bidi: isolate; }
  .tok-num { color: var(--tok-num); }
  .tok-fn { color: var(--tok-fn); }
  .tok-cmt { color: var(--tok-cmt); }

  /* ---------- JAVA vs PYTHON TABLE ---------- */

  .tbl-wrap { margin-top: 24px; overflow-x: auto; border: 1px solid var(--line); border-radius: 14px; background: var(--bg-panel); }
  .tbl { width: 100%; border-collapse: collapse; font-size: 14px; }
  .tbl th, .tbl td { padding: 11px 16px; border-bottom: 1px solid var(--line); text-align: left; direction: ltr; }
  .tbl tr:last-child td { border-bottom: 0; }
  .tbl th { background: var(--bg-panel-2); color: var(--ink); font-family: var(--sans); font-weight: 700; font-size: 14px; }
  .tbl th.py, .tbl td.py { color: var(--gold-text); }
  .tbl td { font-family: var(--mono); font-size: 13.5px; color: var(--ink-dim); }

  
  
  
  
  
  
  
  
  
  

  /* ---------- PLAYGROUND ---------- */

  .playground { margin-top: 32px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); overflow: hidden; }
  .pg-bar { padding: 16px 24px; border-bottom: 1px solid var(--line); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .pg-bar label { font-weight: 700; font-size: 14.5px; display: flex; align-items: center; gap: 8px; }
  .pg-stage { padding: 20px 24px 10px; }
  .pg-note { padding: 4px 24px 16px; font-size: 14.5px; color: var(--ink-dim); min-height: 36px; }
  .pg-note.err { color: var(--rust); font-weight: 700; }

  .txt-in { font-family: var(--mono); font-size: 15px; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 8px 10px; direction: rtl; text-align: center; width: 120px; }
  .txt-in.wide { width: 100%; max-width: 380px; text-align: start; font-family: var(--sans); }

  .pill-row { display: flex; gap: 8px; flex-wrap: wrap; }
  .pill { font-family: var(--mono); font-size: 13px; padding: 8px 14px; border-radius: 100px; direction: ltr; border: 1px solid var(--line-strong); background: var(--bg-panel-2); color: var(--ink); }
  .pill:hover:not(:disabled) { border-color: var(--ink-dim); }
  .pill.active { background: var(--gold-soft); color: var(--gold-text); border-color: var(--gold); }
  .pill.reset { font-family: var(--sans); color: var(--ink-dim); border-style: dashed; background: transparent; }

  .log { direction: ltr; text-align: left; font-family: var(--mono); font-size: 13.5px; line-height: 1.8; padding: 12px 24px; background: var(--code-bg); color: var(--code-ink); min-height: 52px; max-height: 200px; overflow-y: auto; }
  .log .row { display: flex; gap: 10px; flex-wrap: wrap; }
  .log .arrow { color: var(--tok-cmt); }
  .log .res { color: var(--tok-kw); }
  .log .bad { color: var(--tok-num); }
  .log .empty { color: var(--tok-cmt); font-family: var(--sans); direction: rtl; font-style: italic; }

  /* key/value cards */
  .cards { display: flex; flex-wrap: wrap; gap: 10px; min-height: 52px; }
  .kv { display: flex; align-items: center; gap: 10px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 12px; padding: 8px 14px; font-weight: 700; }
  .kv .k { color: var(--gold-text); }
  .kv .arrow { color: var(--ink-faint); }
  .kv .v { color: var(--ink); font-family: var(--mono); direction: ltr; unicode-bidi: isolate; }
  .kv.pop { animation: pop-in 0.35s cubic-bezier(.34,1.56,.64,1); }
  .kv.hit { background: var(--gold-soft); border-color: var(--gold); }
  @keyframes pop-in { from { opacity: 0; transform: scale(0.4); } to { opacity: 1; transform: scale(1); } }
  .cards-empty { color: var(--ink-faint); font-style: italic; font-size: 14px; align-self: center; }

  /* get vs [] outputs */
  .two-out { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; padding: 4px 24px 18px; }
  @media (max-width: 560px) { .two-out { grid-template-columns: 1fr; } }
  .out-box { background: var(--code-bg); color: var(--code-ink); border-radius: 12px; padding: 12px 14px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 13.5px; min-height: 66px; }
  .out-box .cap { color: var(--tok-cmt); font-size: 12px; margin-bottom: 4px; }
  .out-box .ok { color: var(--tok-kw); }
  .out-box .bad { color: var(--tok-num); }

  /* iterate demo */
  .run-out { padding: 4px 24px 18px; }
  .run-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14px; line-height: 1.9; background: var(--code-bg); color: var(--code-ink); border-radius: 12px; padding: 12px 0; }
  .run-code .line { padding: 1px 18px; white-space: pre; }
  .run-code .line.active { background: var(--code-head); box-shadow: inset 3px 0 0 var(--gold); }
  .run-print { margin-top: 10px; direction: rtl; font-family: var(--sans); font-size: 15px; background: var(--moss-soft); border-radius: 10px; padding: 10px 14px; color: var(--ink); min-height: 44px; }
  .run-print div { padding: 1px 0; }
  .run-got { font-family: var(--mono); font-size: 14px; color: var(--gold-text); direction: ltr; text-align: left; margin-bottom: 10px; }

  /* tree */
  .tree { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14px; line-height: 2; background: var(--code-bg); color: var(--code-ink); border-radius: 12px; padding: 14px 18px; }
  .tree ul { list-style: none; margin: 0; padding: 0 0 0 22px; border-left: 1px dashed var(--tok-cmt); }
  .tree > ul { border-left: 0; padding-left: 0; }
  .tree .key { color: var(--tok-fn); }
  .tree .leaf { font-family: var(--mono); font-size: 13.5px; background: var(--code-head); color: var(--tok-kw); border: 1px solid var(--tok-cmt); border-radius: 8px; padding: 1px 10px; margin-left: 6px; }
  .tree .leaf:hover { border-color: var(--tok-kw); }
  .tree .leaf.on { background: var(--gold); color: var(--ink); border-color: var(--gold); }
  .tree .leaf:focus-visible { outline: 3px solid var(--tok-kw); }
  .expr-box { margin-top: 12px; font-family: var(--mono); direction: ltr; text-align: left; font-size: 14.5px; color: var(--gold-text); min-height: 28px; }

  /* emoji translator */
  .em-out { display: flex; flex-wrap: wrap; gap: 10px; direction: rtl; min-height: 54px; margin-top: 14px; }
  .em-chip { display: flex; flex-direction: column; align-items: center; gap: 2px; padding: 8px 14px; border-radius: 12px; background: var(--gold-soft); border: 1px solid var(--gold); min-width: 64px; }
  .em-chip .big { font-size: 24px; line-height: 1.3; }
  .em-chip .src { font-size: 12px; color: var(--ink-dim); unicode-bidi: isolate; }
  .em-chip.keep { background: var(--bg-panel-2); border-color: var(--line-strong); border-style: dashed; }
  .em-chip.keep .big { font-size: 17px; font-weight: 700; color: var(--ink-faint); padding: 4px 0; }
  .em-chip.pop { animation: pop-in 0.35s cubic-bezier(.34,1.56,.64,1); }
  .em-legend { font-size: 13.5px; color: var(--ink-faint); margin-top: 10px; }
  .em-ask { margin: 16px 24px 4px; background: var(--gold-soft); border-radius: 12px; padding: 12px 16px; color: var(--ink); font-size: 15px; }

  /* guess row */
  .guess-row { padding: 16px 24px; border-top: 1px solid var(--line); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .guess-row input { width: 110px; font-family: var(--mono); font-size: 16px; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 8px 10px; text-align: center; direction: ltr; }
  .guess-btn { background: var(--bg-panel-2); color: var(--ink); border: 1px solid var(--line-strong); border-radius: 100px; padding: 9px 18px; font-weight: 700; font-size: 14px; }
  .guess-btn:hover { border-color: var(--ink-dim); }
  .guess-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .guess-feedback.correct { color: var(--moss); }
  .guess-feedback.wrong { color: var(--rust); }

  .callout { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--gold); border-radius: 14px; padding: 16px 20px; font-size: 15.5px; color: var(--ink-dim); }

  /* ---------- BUG HUNT ---------- */

  .rescue { margin-top: 30px; background: var(--bg-panel); border: 1px solid var(--rust); border-radius: var(--radius); padding: 24px 26px 26px; }
  .rescue.fixed { border-color: var(--moss); }
  .rescue-head { display: flex; align-items: center; gap: 14px; margin-bottom: 18px; }
  .rescue-head h4 { font-family: var(--sans); font-weight: 700; font-size: 15.5px; margin: 0; color: var(--ink); }
  .rescue-mark { font-size: 24px; color: var(--rust); }
  .rescue.fixed .rescue-mark { color: var(--moss); }
  .rescue pre { direction: ltr; text-align: left; margin: 0 0 18px; font-family: var(--mono); font-size: 14.5px; line-height: 1.75; background: var(--code-bg); color: var(--code-ink); border-radius: 10px; padding: 16px 18px; overflow-x: auto; }
  .rescue-q { color: var(--ink); font-weight: 600; margin-bottom: 14px; }
  .rescue-choices { display: flex; gap: 12px; flex-wrap: wrap; }
  .rescue-choice { flex: 1; min-width: 180px; text-align: right; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 14px; padding: 14px 16px; font-size: 14.5px; color: var(--ink); }
  .rescue-choice.ltr { direction: ltr; text-align: left; font-family: var(--mono); }
  .rescue-choice:hover:not(:disabled) { border-color: var(--ink-dim); }
  .rescue-choice.right { border-color: var(--moss); background: var(--moss-soft); color: var(--moss); }
  .rescue-choice.wrong { border-color: var(--rust); background: var(--rust-soft); color: var(--rust); }
  .rescue-choice:disabled { cursor: default; }
  .rescue-feedback { margin-top: 14px; font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .rescue-feedback.correct { color: var(--moss); }
  .rescue-feedback.wrong { color: var(--rust); }

  /* ---------- EXERCISES ---------- */

  .exercises-banner { margin-bottom: 8px; background: var(--gold-soft); border: 1px solid var(--gold); border-radius: var(--radius); padding: 24px 26px; }
  .exercises-banner .badge { display: inline-block; font-family: var(--mono); font-size: 12.5px; font-weight: 700; color: var(--ink); background: var(--gold); border-radius: 100px; padding: 4px 12px; margin-bottom: 10px; }
  .exercises-banner h2 { font-size: clamp(1.7rem, 4.5vw, 2.3rem); }
  .exercises-banner p { margin-top: 10px; font-size: 16px; color: var(--ink); }

  .exercise-card { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--gold); border-radius: 16px; padding: 22px 24px; }
  .exercise-card.rust { border-inline-start-color: var(--rust); }
  .exercise-num { font-family: var(--mono); font-size: 12.5px; color: var(--ink-faint); }
  .exercise-task { margin: 8px 0 16px; font-weight: 600; color: var(--ink); font-size: 15.5px; }
  .exercise-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 1.9; background: var(--code-bg); color: var(--code-ink); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px; overflow-x: auto; white-space: pre; }
  .exercise-code input { font-family: var(--mono); font-size: 14px; background: var(--bg); border: 1px solid var(--line-strong); border-radius: 6px; color: var(--ink); padding: 3px 6px; text-align: center; width: 92px; direction: rtl; }
  .exercise-code input.short { width: 76px; }
  .exercise-controls { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .exercise-controls input { width: 110px; font-family: var(--mono); font-size: 15px; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 7px 8px; text-align: center; direction: ltr; }
  .exercise-check-btn { background: var(--bg-panel-2); border: 1px solid var(--line-strong); color: var(--ink); border-radius: 100px; padding: 9px 20px; font-weight: 700; font-size: 14px; }
  .exercise-check-btn:hover { border-color: var(--ink-dim); }
  .exercise-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .exercise-feedback.correct { color: var(--moss); }
  .exercise-feedback.wrong { color: var(--rust); }
  .exercise-output { margin-top: 12px; font-family: var(--mono); font-size: 13.5px; direction: ltr; text-align: left; background: var(--bg-panel-2); border-radius: 8px; padding: 10px 12px; color: var(--ink-dim); white-space: pre-line; min-height: 20px; }
  .exercise-divider { margin-top: 40px; display: flex; align-items: center; gap: 14px; color: var(--ink-faint); font-family: var(--mono); font-size: 13px; }
  .exercise-divider::before, .exercise-divider::after { content: ""; flex: 1; height: 1px; background: var(--line); }
  .exercise-note { font-size: 13.5px; color: var(--ink-faint); font-style: italic; margin: 0 0 10px; }
  .exercise-answer { width: 100%; direction: ltr; text-align: left; font-family: var(--mono); font-size: 13.5px; line-height: 1.7; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 12px 14px; resize: vertical; }
  .exercise-answer.rtl { direction: rtl; text-align: right; font-family: var(--sans); font-size: 15px; }
  .ai-note { margin-top: 16px; background: var(--gold-soft); border-radius: 12px; padding: 12px 16px; color: var(--ink); font-size: 14.5px; }

  /* ---------- SUMMARY ---------- */

  .recap { margin: 22px 0 0; padding: 0; list-style: none; display: grid; gap: 10px; }
  .recap li { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 12px; padding: 12px 16px; color: var(--ink-dim); }
  .recap li::before { content: "✓"; color: var(--moss); font-weight: 800; margin-inline-end: 10px; }

  /* ---------- NAME BAR ---------- */

  .name-bar { background: var(--bg-panel); border-bottom: 1px solid var(--line); padding: 14px 0; }
  .name-bar-inner { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .name-bar-inner label { font-size: 13.5px; color: var(--ink-dim); flex-shrink: 0; }
  .name-bar-input { flex: 1; min-width: 160px; max-width: 260px; font-family: var(--sans); font-size: 15px; background: var(--bg); border: 1px solid var(--line-strong); border-radius: 10px; color: var(--ink); padding: 9px 12px; }
  .name-bar-jump { margin-inline-start: auto; font-family: var(--sans); font-weight: 700; font-size: 13.5px; color: var(--gold-text); background: transparent; border: 1px solid var(--gold-text); border-radius: 100px; padding: 8px 16px; white-space: nowrap; }
  .name-bar-jump:hover { background: var(--gold-soft); }

  .run-btn { font-family: var(--sans); font-weight: 700; font-size: 15px; color: var(--ink); background: var(--gold); border: none; border-radius: 100px; padding: 12px 26px; }
  .run-btn:hover { background: var(--tok-kw); }

  /* ---------- CERTIFICATE ---------- */

  .certificate-box { margin-top: 30px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 26px 26px 22px; display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
  .cert-name-display { font-size: 15px; color: var(--ink-dim); }
  .cert-name-display strong { color: var(--gold-text); }
  .cert-status { width: 100%; margin: 0; font-size: 14.5px; color: var(--ink-dim); }
  .cert-status.correct { color: var(--moss); }
  .cert-status.wrong { color: var(--rust); }
  .cert-fallback { margin-top: 16px; }
  .cert-fallback-note { font-size: 13.5px; color: var(--ink-faint); margin: 0 0 10px; }
  .cert-fallback-text { width: 100%; direction: ltr; text-align: left; font-family: var(--mono); font-size: 12px; line-height: 1.6; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 10px; color: var(--ink-dim); padding: 12px 14px; }

  footer { padding: 48px 0 76px; text-align: center; color: var(--ink-faint); font-size: 14px; }

  /* ---------- GUIDE: הסבר מסודר על מילונים ---------- */
  .gsec .wrap, #game-valid .wrap { max-width: 860px; }
  .g-nav { margin-top: 26px; display: flex; flex-wrap: wrap; gap: 8px; }
  .g-nav a { display: inline-flex; align-items: center; gap: 8px; text-decoration: none; font-size: 14px; font-weight: 600; color: var(--ink-dim); background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 100px; padding: 6px 14px; transition: border-color .15s, color .15s; }
  .g-nav a b { display: inline-flex; width: 22px; height: 22px; border-radius: 50%; align-items: center; justify-content: center; background: var(--gold-soft); color: var(--gold-text); font-size: 12px; }
  .g-nav a:hover { border-color: var(--gold-text); color: var(--ink); }
  .g-step { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 26px 28px 28px; scroll-margin-top: 20px; }
  .g-head { display: flex; align-items: center; gap: 14px; margin-bottom: 12px; }
  .g-num { flex-shrink: 0; width: 40px; height: 40px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-family: var(--display); font-weight: 700; font-size: 19px; background: var(--gold-soft); color: var(--gold-text); }
  .g-head h3 { font-size: 1.45rem; line-height: 1.3; }
  .g-step p { font-size: 17px; }
  .g-step .code-card { margin-top: 16px; }
  .g-step p + .code-card, .g-step .g-pair + p { margin-top: 16px; }
  .g-out { direction: ltr; text-align: left; margin: 0; padding: 12px 20px 14px; font-family: var(--mono); font-size: 14px; line-height: 1.7; color: var(--moss); background: #0f1b20; border-top: 1px dashed var(--line-strong); white-space: pre-wrap; }
  .g-out::before { content: "פלט"; display: block; font-family: var(--sans); font-size: 11.5px; font-weight: 700; color: var(--ink-faint); margin-bottom: 4px; direction: rtl; text-align: right; }
  .g-note { margin-top: 16px; border-radius: 14px; padding: 14px 18px; font-size: 15.5px; border: 1px solid; display: flex; gap: 12px; align-items: flex-start; }
  .g-note .i { font-size: 19px; line-height: 1.5; }
  .g-note p { font-size: 15.5px; color: var(--ink); margin: 0; }
  .g-note.tip { background: var(--moss-soft); border-color: rgba(111,224,160,.4); }
  .g-note.warn { background: var(--rust-soft); border-color: rgba(255,127,150,.4); }
  .g-pair { margin-top: 18px; display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
  @media (max-width: 620px) { .g-pair { grid-template-columns: 1fr; } }
  .g-pair .col { background: var(--bg-panel-2); border: 1px solid var(--line); border-radius: 14px; padding: 14px 16px; min-width: 0; }
  .g-pair .col h4 { font-family: var(--sans); font-size: 14px; font-weight: 700; color: var(--gold-text); margin: 0 0 8px; }
  .g-pair .col pre { direction: ltr; text-align: left; margin: 0; font-family: var(--mono); font-size: 13.5px; line-height: 1.7; color: var(--code-ink); overflow-x: auto; }
  .g-pair .col p { font-size: 14.5px; margin-top: 8px; }
  .kv-demo { margin-top: 18px; display: flex; flex-wrap: wrap; gap: 10px; direction: ltr; }
  .kv { display: inline-flex; align-items: stretch; border-radius: 12px; overflow: hidden; border: 1px solid var(--line-strong); font-family: var(--mono); font-size: 15px; }
  .kv .k { padding: 8px 14px; background: var(--gold-soft); color: var(--gold-text); font-weight: 700; }
  .kv .arr { padding: 8px 8px; background: var(--bg-panel-2); color: var(--ink-faint); }
  .kv .v { padding: 8px 14px; background: var(--bg-panel-2); color: var(--ink); }
  .g-rules { margin: 16px 0 0; padding: 0; list-style: none; display: grid; gap: 8px; }
  .g-rules li { display: flex; gap: 10px; align-items: flex-start; font-size: 16px; color: var(--ink-dim); }
  .g-rules li::before { content: "✓"; color: var(--moss); font-weight: 800; }
  .g-parts { margin: 14px 0 0; padding: 0; list-style: none; display: grid; gap: 8px; }
  .g-parts li { font-size: 16px; color: var(--ink-dim); }
  .g-parts li .mono { background: var(--bg-panel-2); border-radius: 6px; padding: 1px 7px; color: var(--gold-text); font-size: .9em; }
  .g-sub { margin-top: 24px; padding-top: 20px; border-top: 1px dashed var(--line-strong); }
  .g-sub h4 { font-family: var(--sans); font-size: 17px; font-weight: 700; color: var(--ink); margin: 0 0 6px; }
  .g-sub h4 span { color: var(--gold-text); font-family: var(--mono); font-size: 14.5px; direction: ltr; unicode-bidi: isolate; }
  .g-sub .code-card { margin-top: 12px; }
  /* loop stepper */
  .stepper { margin-top: 20px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 16px; padding: 18px 20px 20px; }
  .stepper h4 { font-family: var(--sans); font-size: 16px; font-weight: 700; margin: 0 0 4px; }
  .stepper .pill-row { margin-top: 12px; }
  .st-cards { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 16px; direction: ltr; }
  .st-card { position: relative; border: 2px solid var(--line-strong); border-radius: 12px; padding: 8px 14px; font-family: var(--mono); font-size: 14.5px; color: var(--ink-dim); background: var(--bg-panel); transition: all .2s; }
  .st-card.on { border-color: var(--gold-text); background: var(--gold-soft); color: var(--ink); transform: translateY(-3px); }
  .st-card.done { opacity: .55; }
  .st-card .k { color: var(--gold-text); font-weight: 700; }
  .st-code { margin-top: 14px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 14px; line-height: 1.8; background: var(--code-bg); border-radius: 12px; padding: 12px 18px; color: var(--code-ink); }
  .st-code .ln.on { background: rgba(255,127,150,.18); border-radius: 4px; display: block; margin: 0 -8px; padding: 0 8px; }
  .st-code .ln { display: block; white-space: pre; }
  .st-var { margin-top: 12px; font-family: var(--mono); font-size: 14px; direction: ltr; text-align: left; color: var(--gold-text); min-height: 24px; }
  .st-out { margin-top: 10px; direction: ltr; text-align: left; font-family: var(--mono); font-size: 14px; line-height: 1.7; color: var(--moss); background: #0f1b20; border-radius: 12px; padding: 10px 16px; min-height: 44px; white-space: pre-wrap; }
  .st-ctl { margin-top: 14px; display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
  .g-btn { font-family: var(--display); font-weight: 700; font-size: 15px; color: #1a1204; background: var(--gold-text); border: none; border-radius: 100px; padding: 10px 24px; }
  .g-btn.ghost { background: transparent; color: var(--ink-dim); border: 1px solid var(--line-strong); }
  .g-btn:disabled { opacity: .45; cursor: default; }
  .st-msg { font-size: 14.5px; color: var(--ink-dim); }
  /* cheat sheet + mistakes */
  .cheat { margin-top: 16px; overflow-x: auto; border: 1px solid var(--line-strong); border-radius: 14px; }
  .cheat table { width: 100%; border-collapse: collapse; font-size: 15.5px; }
  .cheat th, .cheat td { padding: 10px 16px; text-align: start; border-bottom: 1px solid var(--line); }
  .cheat tr:last-child td { border-bottom: none; }
  .cheat th { background: var(--bg-panel-2); font-size: 13.5px; color: var(--ink-faint); font-weight: 700; }
  .cheat td { color: var(--ink-dim); }
  .cheat td code { direction: ltr; unicode-bidi: isolate; color: var(--gold-text); font-size: .92em; white-space: nowrap; }
  .mistakes { margin-top: 16px; display: grid; gap: 12px; }
  .mistake { background: var(--bg-panel-2); border: 1px solid var(--line); border-radius: 14px; padding: 14px 18px; }
  .mistake h4 { font-family: var(--sans); font-size: 16px; font-weight: 700; color: var(--ink); margin: 0 0 8px; }
  .mistake .row { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
  @media (max-width: 620px) { .mistake .row { grid-template-columns: 1fr; } }
  .mistake .bad, .mistake .good { border-radius: 10px; padding: 8px 12px; font-family: var(--mono); font-size: 13.5px; direction: ltr; text-align: left; line-height: 1.6; white-space: pre-wrap; }
  .mistake .bad { background: var(--rust-soft); color: #ffb3c1; border: 1px solid rgba(255,127,150,.3); }
  .mistake .good { background: var(--moss-soft); color: #9af0bd; border: 1px solid rgba(111,224,160,.3); }
  .mistake small { display: block; font-family: var(--sans); font-size: 12px; font-weight: 700; margin-bottom: 2px; opacity: .8; }
  .mistake p { font-size: 15px; margin-top: 8px; }
  .g-go { margin-top: 32px; text-align: center; }
  .g-go p { color: var(--ink); font-size: 18px; margin-bottom: 14px; }
  .g-go a { display: inline-block; text-decoration: none; font-family: var(--display); font-weight: 700; color: #1a1204; background: var(--gold-text); border-radius: 100px; padding: 12px 30px; }

  .g-bridge { margin-top: 28px; display: flex; align-items: center; justify-content: center; gap: 10px; font-weight: 700; color: var(--gold-text); background: var(--gold-soft); border: 1px dashed var(--gold-text); border-radius: 100px; padding: 10px 22px; width: fit-content; margin-inline: auto; font-size: 16px; }
  .gsec .g-step:first-of-type { margin-top: 26px; }
  /* חוקי או שגיאה */
  .gv-wrap { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 24px 26px 26px; }
  .gv-top { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; color: var(--ink-faint); font-size: 14.5px; font-weight: 700; }
  .gv-bar { flex: 1; height: 8px; border-radius: 8px; background: var(--bg-panel-2); overflow: hidden; }
  .gv-bar i { display: block; height: 100%; width: 0; background: var(--gold-text); transition: width .3s; border-radius: 8px; }
  .gv-pre { font-size: 17px !important; padding: 22px 24px !important; }
  .gv-opts { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-top: 16px; }
  @media (max-width: 620px) { .gv-opts { grid-template-columns: 1fr; } }
  .gv-opt { border: 1px solid var(--line-strong); background: var(--bg-panel-2); color: var(--ink); border-radius: 14px; padding: 13px 10px; font-weight: 700; font-size: 15.5px; transition: border-color .15s, transform .15s; }
  .gv-opt:hover:not(:disabled) { border-color: var(--gold-text); transform: translateY(-1px); }
  .gv-opt:disabled { cursor: default; }
  .gv-opt.right { border-color: var(--moss); background: var(--moss-soft); }
  .gv-opt.wrong { border-color: var(--rust); background: var(--rust-soft); }
  .gv-fb { margin-top: 14px; min-height: 26px; font-size: 16px; font-weight: 600; color: var(--ink); }
  .gv-fb.good { color: var(--moss); } .gv-fb.bad { color: #ff9fb2; }
  .gv-ctl { margin-top: 12px; display: flex; gap: 10px; }
  .gv-wrap [hidden] { display: none !important; }
  /* ---------- תרגיל 6: פייתון אמיתי בדפדפן (Pyodide) ---------- */
  .pyx-code { min-height: 190px; tab-size: 4; white-space: pre; overflow: auto; }
  .pyx-status { margin-top: 12px; display: flex; flex-direction: column; gap: 8px; font-size: 14.5px; color: var(--ink-dim); background: var(--bg-panel-2); border-radius: 10px; padding: 10px 14px; }
  .pyx-status[hidden] { display: none; }
  .pyx-retry { align-self: flex-start; }
  .pyx-retry[hidden] { display: none; }
  .pyx-status.err { color: var(--rust); }
  .pyx-bar { display: block; height: 4px; border-radius: 4px; background: var(--line-strong); overflow: hidden; position: relative; }
  .pyx-bar::after { content: ""; position: absolute; inset-block: 0; width: 35%; background: var(--gold); border-radius: 4px; animation: pyx-slide 1.3s ease-in-out infinite; }
  .pyx-status.err .pyx-bar, .pyx-status.done .pyx-bar { display: none; }
  @keyframes pyx-slide { 0% { inset-inline-start: -35%; } 100% { inset-inline-start: 100%; } }
  @media (prefers-reduced-motion: reduce) { .pyx-bar::after { animation: none; width: 100%; opacity: .5; } }
  .pyx-tests { list-style: none; margin: 12px 0 0; padding: 0; display: grid; gap: 8px; }
  .pyx-tests li { display: flex; gap: 10px; align-items: flex-start; background: var(--bg-panel-2); border-radius: 10px; padding: 9px 12px; font-size: 14.5px; color: var(--ink); }
  .pyx-tests .mark { flex: none; font-weight: 800; min-width: 1.2em; }
  .pyx-tests li.pass .mark { color: var(--moss); }
  .pyx-tests li.fail .mark { color: var(--rust); }
  .pyx-tests code { font-family: var(--mono); direction: ltr; unicode-bidi: isolate; font-size: 13px; }
  .pyx-tests .detail { display: block; color: var(--ink-dim); font-size: 13.5px; margin-top: 2px; }
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
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור שישי · פייתון · מגמת מחשבים</div>
    <h1>ספר הטלפונים של התוכנית:<br><span class="accent">מילונים</span> (dict)</h1>
    <p class="hero-sub">כשתוכנית שומרת פרטים על משתמשת, זה נראה כך:</p>

    <div class="code-card solo-code" style="margin:26px auto 0;">
      <div class="code-card-label">Python</div>
      <pre class="hl">user = {"name": "דנה", "age": 30, "city": "חיפה"}</pre>
    </div>

    <p class="hero-sub" style="margin-top:26px;">זה <strong>מילון</strong>: אוסף של זוגות מפתח ← ערך. במקום לזכור ״הערך שנמצא במקום מספר 2״, מבקשים אותו בשם: <span class="mono">user["city"]</span>.</p>
  </div>
</header>

<main>
  


  <section class="gsec" id="b1">
    <div class="wrap">
      <div class="eyebrow gold">חלק 1 · הבסיס</div>
      <h2 class="section-title">מה זה מילון, ואיך יוצרים אחד</h2>
      <div class="g-step" id="g1">
        <div class="g-head"><span class="g-num">1</span><h3>מה זה מילון?</h3></div>
        <p>מילון הוא אוסף של <strong>זוגות</strong>. בכל זוג יש <strong>מפתח</strong> (השם שמחפשים לפיו) ו<strong>ערך</strong> (מה שמקבלים). בדיוק כמו ספר טלפונים: מחפשים את השם "Dana" (המפתח) ומקבלים מספר (הערך).</p>
        <div class="kv-demo" aria-hidden="true">
          <span class="kv"><span class="k">"Dana"</span><span class="arr">→</span><span class="v">30</span></span>
          <span class="kv"><span class="k">"Yuval"</span><span class="arr">→</span><span class="v">25</span></span>
          <span class="kv"><span class="k">"Noa"</span><span class="arr">→</span><span class="v">28</span></span>
        </div>
        <p style="margin-top:18px;">ההבדל החשוב מרשימה (<span class="mono">list</span>): ברשימה ניגשים לפי <strong>מקום</strong> (0, 1, 2...), ובמילון ניגשים לפי <strong>שם</strong>. במקום לזכור "מי נמצא במקום מספר 1", פשוט שואלים על השם.</p>
        <div class="g-pair">
          <div class="col"><h4>רשימה: לפי מקום</h4><pre>ages = [30, 25, 28]
print(ages[1])   # 25 (whose age?)</pre><p>צריך לזכור שמקום 1 שייך ליובל.</p></div>
          <div class="col"><h4>מילון: לפי שם</h4><pre>ages = {"Dana": 30, "Yuval": 25}
print(ages["Yuval"])   # 25</pre><p>שואלים ישר על יובל.</p></div>
        </div>
        <ul class="g-rules">
          <li>המפתחות <strong>לא חוזרים</strong>: לכל מפתח יש ערך אחד בלבד.</li>
          <li>מפתח הוא בדרך כלל <strong>טקסט או מספר</strong> (לא רשימה).</li>
          <li>ערך יכול להיות <strong>כל דבר</strong>: מספר, טקסט, רשימה, ואפילו מילון אחר.</li>
        </ul>
      </div>
<div class="g-step" id="g2">
        <div class="g-head"><span class="g-num">2</span><h3>יוצרים מילון</h3></div>
        <p>משתמשים בסוגריים מסולסלים <span class="mono">{ }</span>. בתוכם כותבים זוגות של <span class="mono">מפתח: ערך</span>, כשמפרידים בין זוג לזוג בפסיק.</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">empty = {}                                   # מילון ריק
ages = {"Dana": 30, "Yuval": 25, "Noa": 28}  # מילון עם שלושה זוגות</pre></div>
      </div>
    </div>
  </section>


  <section id="game-valid">
    <div class="wrap">
      <div class="eyebrow gold">בנייה</div>
      <h2 class="section-title">חוקי או שגיאה?</h2>
      <p class="lede">תראו מילון, ותחליטו: האם פייתון תקבל אותו, או שתהיה שגיאה?</p>
      <div class="gv-wrap" id="gv-wrap">
        <div class="gv-top"><span id="gv-count">שאלה 1 מתוך 5</span><div class="gv-bar"><i id="gv-bar"></i></div><span id="gv-score"></span></div>
        <div class="code-card" id="gv-card"><div class="code-card-label">Python</div><pre id="gv-code" class="gv-pre"></pre></div>
        <div class="gv-opts" id="gv-opts">
          <button class="gv-opt" type="button" data-a="ok">✅ חוקי</button>
          <button class="gv-opt" type="button" data-a="err">❌ שגיאה</button>
          <button class="gv-opt" type="button" data-a="over">⚠️ חוקי, אבל משהו נדרס</button>
        </div>
        <div class="gv-fb" id="gv-fb" role="status" aria-live="polite"></div>
        <div class="gv-ctl"><button class="g-btn" id="gv-next" type="button" hidden>השאלה הבאה ▸</button><button class="g-btn ghost" id="gv-again" type="button" hidden>שחקו שוב</button></div>
      </div>
    </div>
  </section>


  <section class="gsec" id="b2">
    <div class="wrap">
      <div class="eyebrow gold">חלק 2 · קריאה</div>
      <h2 class="section-title">איך קוראים ערך מהמילון</h2>
      <div class="g-step" id="g3">
        <div class="g-head"><span class="g-num">3</span><h3>קוראים ערך</h3></div>
        <p>נניח שיש לנו את המילון <span class="mono">ages</span> מהשלב הקודם. כדי לקבל ערך, כותבים את שם המילון ואחריו המפתח בסוגריים מרובעים:</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">print(ages["Dana"])</pre><pre class="g-out">30</pre></div>
        <div class="g-note warn"><span class="i">⚠️</span><p>אם המפתח <strong>לא קיים</strong>, התוכנית קורסת עם <span class="mono">KeyError</span>:</p></div>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">print(ages["Rami"])</pre><pre class="g-out" style="color:#ff9fb2">KeyError: ''Rami''</pre></div>
        <div class="g-sub">
          <h4>הפתרון: <span>.get()</span></h4>
          <p>הפונקציה <span class="mono">get</span> מחפשת מפתח, ואם אין אותו היא <strong>לא קורסת</strong>. היא מחזירה <span class="mono">None</span>, או ערך ברירת מחדל שאתם בוחרים.</p>
          <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">print(ages.get("Rami"))       # None, בלי קריסה
print(ages.get("Rami", 0))    # 0 (ערך ברירת מחדל)
print(ages.get("Dana", 0))    # 30 (המפתח קיים, אז מקבלים את הערך שלו)</pre><pre class="g-out">None
0
30</pre></div>
        </div>
      </div>
    </div>
  </section>


  <section id="get">
    <div class="wrap">
      <div class="eyebrow gold">d[key] או d.get(key)</div>
      <h2 class="section-title">מה קורה כשהמפתח לא קיים?</h2>
      <p class="lede"><span class="mono">d["שרה"]</span> קורסת אם אין מפתח כזה. <span class="mono">d.get("שרה")</span> לא קורסת, אלא מחזירה <span class="mono">None</span> או ערך ברירת מחדל שקובעים בעצמנו: <span class="mono">d.get("שרה", 0)</span>.</p>

      <div class="playground">
        <div class="pg-stage"><div class="cards" id="get-cards"></div></div>
        <div class="pg-bar">
          <label>מפתח <input class="txt-in" type="text" id="get-key" value="דנה" autocomplete="off"></label>
          <div class="pill-row">
            <button class="pill" id="get-a" type="button">ages[מפתח]</button>
            <button class="pill" id="get-b" type="button">ages.get(מפתח, 0)</button>
          </div>
        </div>
        <div class="two-out">
          <div class="out-box" id="get-out-a" aria-live="polite"><div class="cap">ages[מפתח]</div></div>
          <div class="out-box" id="get-out-b" aria-live="polite"><div class="cap">ages.get(מפתח, 0)</div></div>
        </div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: מה יחזיר <span class="mono">ages.get("שרה", 0)</span> כשאין שרה?</span>
          <input type="text" id="g2-input" autocomplete="off" aria-label="הניחוש שלי">
          <button class="guess-btn" id="g2-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g2-fb" role="status" aria-live="polite"></span>
        </div>
      </div>
    </div>
  </section>

  <section class="gsec" id="b3">
    <div class="wrap">
      <div class="eyebrow gold">חלק 3 · שינויים</div>
      <h2 class="section-title">מוסיפים, משנים, מוחקים ובודקים</h2>
      <div class="g-step" id="g4">
        <div class="g-head"><span class="g-num">4</span><h3>מוסיפים, משנים ומוחקים</h3></div>
        <p>אותו תחביר מוסיף וגם משנה: אם המפתח <strong>לא קיים</strong>, נוצר זוג חדש. אם הוא <strong>כבר קיים</strong>, הערך שלו מתעדכן.</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">ages = {"Dana": 30, "Yuval": 25, "Noa": 28}

ages["Rami"] = 22      # מפתח חדש: מוסיף זוג
ages["Dana"] = 31      # מפתח קיים: משנה את הערך
del ages["Yuval"]      # מוחק את הזוג

print(len(ages))       # כמה זוגות יש עכשיו
print(ages)</pre><pre class="g-out">3
{''Dana'': 31, ''Noa'': 28, ''Rami'': 22}</pre></div>
      </div>
<div class="g-step" id="g5">
        <div class="g-head"><span class="g-num">5</span><h3>בודקים אם מפתח קיים</h3></div>
        <p>המילה <span class="mono">in</span> שואלת "האם המפתח הזה נמצא במילון?" והתשובה היא <span class="mono">True</span> או <span class="mono">False</span>. נחזור למילון המקורי:</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">ages = {"Dana": 30, "Yuval": 25, "Noa": 28}

print("Dana" in ages)        # True
print("Moshe" in ages)       # False
print("Moshe" not in ages)   # True</pre><pre class="g-out">True
False
True</pre></div>
        <div class="g-note warn"><span class="i">⚠️</span><p><strong>שימו לב:</strong> <span class="mono">in</span> בודק <strong>מפתחות בלבד</strong>, ולא ערכים. כדי לחפש ערך, בודקים ב-<span class="mono">ages.values()</span>:</p></div>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">print(28 in ages)            # False (אין מפתח 28)
print(28 in ages.values())   # True  (יש ערך 28)</pre><pre class="g-out">False
True</pre></div>
      </div>
    </div>
  </section>


  <section id="phonebook">
    <div class="wrap">
      <div class="eyebrow gold">dict</div>
      <h2 class="section-title">ספר הטלפונים</h2>
      <p class="lede">מילון הוא כמו ספר טלפונים: מחפשים לפי שם (<strong>המפתח</strong>) ומקבלים ערך. המפתחות לא חוזרים, ואפשר להוסיף ולשנות. כתבו מפתח וערך ולחצו על הכפתורים.</p>

      <div class="playground">
        <div class="pg-bar">
          <label>מפתח <input class="txt-in" type="text" id="pb-key" value="שרה" autocomplete="off"></label>
          <label>ערך <input class="txt-in" type="text" id="pb-val" value="28" autocomplete="off"></label>
        </div>
        <div class="pg-bar">
          <div class="pill-row" id="pb-buttons">
            <button class="pill" data-act="set" type="button">ages[מפתח] = ערך</button>
            <button class="pill" data-act="del" type="button">del ages[מפתח]</button>
            <button class="pill" data-act="read" type="button">ages[מפתח]</button>
            <button class="pill reset" data-act="reset" type="button">אפסי</button>
          </div>
        </div>
        <div class="pg-stage"><div class="cards" id="pb-cards"></div></div>
        <div class="log" id="pb-log" aria-live="polite"></div>
        <div class="pg-note" id="pb-note" style="padding-top:12px;" aria-live="polite"></div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: <span class="mono">d = {"a": 1, "b": 2}</span>, ואז <span class="mono">d["b"] = 5</span>, ואז <span class="mono">d["c"] = 7</span>. מה יהיה <span class="mono">len(d)</span> ומה <span class="mono">d["b"]</span>?</span>
          <input type="text" id="g1-input" autocomplete="off" aria-label="הניחוש שלי" placeholder="_ _">
          <button class="guess-btn" id="g1-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g1-fb" role="status" aria-live="polite"></span>
        </div>
      </div>
    </div>
  </section>

  <section class="gsec" id="b4">
    <div class="wrap">
      <div class="eyebrow gold">חלק 4 · מעבר</div>
      <h2 class="section-title">איך עוברים על מילון</h2>
      <div class="g-step" id="g6">
        <div class="g-head"><span class="g-num">6</span><h3>עוברים על מילון (לולאה)</h3></div>
        <p>במילון יש <strong>שלוש דרכים</strong> לעבור על הזוגות, תלוי מה צריך: רק המפתחות, רק הערכים, או את שניהם ביחד. נעבוד כל הזמן עם אותו מילון:</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">ages = {"Dana": 30, "Yuval": 25, "Noa": 28}</pre></div>

        <div class="g-sub">
          <h4>א. רק המפתחות &nbsp;<span>for name in ages</span></h4>
          <p>זו ברירת המחדל: לולאה על מילון עוברת על <strong>המפתחות</strong>. בכל סיבוב המשתנה מקבל מפתח אחד.</p>
          <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">for name in ages:
    print(name)</pre><pre class="g-out">Dana
Yuval
Noa</pre></div>
        </div>

        <div class="g-sub">
          <h4>ב. רק הערכים &nbsp;<span>for age in ages.values()</span></h4>
          <p>כשלא צריך את השמות אלא רק את הערכים. בכל סיבוב המשתנה מקבל ערך אחד.</p>
          <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">for age in ages.values():
    print(age)</pre><pre class="g-out">30
25
28</pre></div>
        </div>

        <div class="g-sub">
          <h4>ג. גם מפתח וגם ערך &nbsp;<span>for name, age in ages.items()</span></h4>
          <p>הדרך הכי שימושית. <span class="mono">.items()</span> נותן את <strong>הזוגות</strong>, ושני המשתנים אחרי <span class="mono">for</span> "פורקים" כל זוג: הראשון מקבל את המפתח והשני את הערך.</p>
          <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">for name, age in ages.items():
    print(name, "is", age)</pre><pre class="g-out">Dana is 30
Yuval is 25
Noa is 28</pre></div>
        </div>

        <div class="stepper" id="gd-stepper">
          <h4>▶ ראו את הלולאה רצה צעד אחר צעד</h4>
          <p style="font-size:15px;">בחרו סוג לולאה ולחצו "צעד הבא". תראו מה המשתנה מקבל בכל סיבוב ומה מודפס.</p>
          <div class="pill-row" id="gd-modes">
            <button class="pill" type="button" data-m="keys">for name in ages</button>
            <button class="pill" type="button" data-m="values">for age in ages.values()</button>
            <button class="pill" type="button" data-m="items">for name, age in ages.items()</button>
          </div>
          <div class="st-cards" id="gd-cards"></div>
          <div class="st-code" id="gd-code"></div>
          <div class="st-var" id="gd-var"></div>
          <div class="st-out" id="gd-out"></div>
          <div class="st-ctl"><button class="g-btn" id="gd-next" type="button">צעד הבא ▸</button><button class="g-btn ghost" id="gd-reset" type="button">מההתחלה</button><span class="st-msg" id="gd-msg"></span></div>
        </div>
      </div>
    </div>
  </section>


  

  <section class="gsec" id="b5">
    <div class="wrap">
      <div class="eyebrow gold">חלק 5 · מבנים מורכבים</div>
      <h2 class="section-title">מילון בתוך מילון</h2>
      <div class="g-step" id="g7">
        <div class="g-head"><span class="g-num">7</span><h3>מילון בתוך מילון</h3></div>
        <p>ערך במילון יכול להיות גם מילון או רשימה. כך נראים נתונים אמיתיים, למשל מה שחוזר מאתר או מאפליקציה. כל סוגריים מרובעים נוספים יורדים <strong>רמה אחת פנימה</strong>, וקוראים משמאל לימין:</p>
        <div class="code-card"><div class="code-card-label">Python</div>
<pre class="hl">user = {
    "name": "Dana",
    "address": {"city": "Haifa", "street": "Herzl"},
    "hobbies": ["chess", "python"]
}

print(user["address"]["city"])
print(user["hobbies"][0])</pre><pre class="g-out">Haifa
chess</pre></div>
      </div>
    </div>
  </section>


  <section id="nested">
    <div class="wrap">
      <div class="eyebrow gold">dict בתוך dict</div>
      <h2 class="section-title">כך נראית תשובה של AI</h2>
      <p class="lede">תשובות של AI הן מילונים בתוך מילונים ורשימות. לחצו על ערך וראו את הביטוי שמגיע אליו.</p>

      <div class="playground">
        <div class="pg-stage">
          <div class="tree" id="tree" role="tree" aria-label="עץ הנתונים"></div>
          <div class="expr-box" id="expr" aria-live="polite">לחצי על ערך בעץ.</div>
        </div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: מה יחזיר <span class="mono">data["items"][1]["price"]</span>?</span>
          <input type="text" id="g3-input" autocomplete="off" aria-label="הניחוש שלי">
          <button class="guess-btn" id="g3-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="g3-fb" role="status" aria-live="polite"></span>
        </div>
      </div>
    </div>
  </section>

  <section class="gsec" id="cheat">
    <div class="wrap">
      <div class="eyebrow">לפני האתגרים</div>
      <h2 class="section-title">דף עזר</h2>
      <p class="lede">כל מה שלמדנו, בטבלה אחת.</p>
      <div class="g-step" id="g8">
        
        <div class="cheat"><table>
          <thead><tr><th>מה רוצים</th><th>הקוד</th><th>מה קורה</th></tr></thead>
          <tbody>
            <tr><td>ליצור</td><td><code>d = {"a": 1, "b": 2}</code></td><td>מילון עם שני זוגות</td></tr>
            <tr><td>לקרוא ערך</td><td><code>d["a"]</code></td><td>1 (קורס אם אין מפתח)</td></tr>
            <tr><td>לקרוא בבטחה</td><td><code>d.get("z", 0)</code></td><td>0 (בלי קריסה)</td></tr>
            <tr><td>להוסיף או לשנות</td><td><code>d["c"] = 3</code></td><td>מוסיף, או מעדכן אם קיים</td></tr>
            <tr><td>למחוק</td><td><code>del d["a"]</code></td><td>מסיר את הזוג</td></tr>
            <tr><td>לבדוק אם קיים</td><td><code>"a" in d</code></td><td>True או False</td></tr>
            <tr><td>לדעת כמה יש</td><td><code>len(d)</code></td><td>מספר הזוגות</td></tr>
            <tr><td>לעבור על מפתחות</td><td><code>for k in d:</code></td><td>מפתח בכל סיבוב</td></tr>
            <tr><td>לעבור על ערכים</td><td><code>for v in d.values():</code></td><td>ערך בכל סיבוב</td></tr>
            <tr><td>לעבור על זוגות</td><td><code>for k, v in d.items():</code></td><td>מפתח וערך בכל סיבוב</td></tr>
          </tbody>
        </table></div></div>
  </section>


  

  <section id="emoji">
    <div class="wrap">
      <div class="eyebrow gold">🎁 הטוויסט</div>
      <h2 class="section-title">מתרגם האימוג׳ים</h2>
      <p class="lede">מילון שמתרגם משפט לאימוג׳ים. מילה שאין בו נשארת כמו שהיא, כי משתמשים ב-<span class="mono">get</span> עם ברירת מחדל.</p>

      <pre class="code-static hl">emoji = {"אוהבת": "❤️", "פיצה": "🍕", "גלידה": "🍦"}
words = ["אני", "אוהבת", "פיצה", "וגלידה"]
for w in words:
    print(emoji.get(w, w))</pre>

      <div class="playground">
        <div class="pg-bar">
          <label style="flex:1; min-width:220px;">משפט <input class="txt-in wide" type="text" id="em-in" value="אני אוהבת פיצה וגלידה" autocomplete="off"></label>
          <button class="run-btn" id="em-run" type="button">תרגמי</button>
        </div>
        <div class="pg-stage"><div class="cards" id="em-cards"></div>
          <div class="em-out" id="em-out" aria-live="polite"></div>
          <div class="em-legend">מילה באפור היא מילה שאין לה תרגום, והיא נשארת כמו שהיא.</div>
        </div>
        <div class="em-ask">המילה ״וגלידה״ לא תורגמה. מה צריך להוסיף למילון כדי שתתורגם?</div>
        <div class="pg-bar">
          <label>מילה <input class="txt-in" type="text" id="em-word" autocomplete="off"></label>
          <label>אימוג׳י <input class="txt-in short" type="text" id="em-emoji" autocomplete="off" style="width:80px;"></label>
          <button class="guess-btn" id="em-add" type="button">הוסיפי למילון</button>
        </div>
        <div class="pg-note" id="em-note" style="padding-top:10px;" aria-live="polite"></div>
      </div>
    </div>
  </section>

  <section id="exercises">
    <div class="wrap">
      <div class="exercises-banner">
        <span class="badge">👇 מפה זה עלייך</span>
        <h2 class="section-title">תרגילים לכל הכיתה</h2>
        <p>חמישה תרגילים: ארבעה עם בדיקה מיידית, ואחד שכותבים בעורך הפייתון ומדביקים כאן. בסוף מורידות קובץ עם כל התוצאות.</p>
      </div>

      <div class="exercise-card">
        <div class="exercise-num">תרגיל 1 · קריאה לפי מפתח</div>
        <p class="exercise-task">השלימי כך שיודפס <span class="mono">25</span>.</p>
        <div class="exercise-code">ages = {"דנה": 30, "רונית": 25, "מיכל": 41}
print(ages[<input type="text" id="ex1-k" autocomplete="off" aria-label="המפתח">])</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex1-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex1-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex1-output"></div>
      </div>

      <div class="exercise-card">
        <div class="exercise-num">תרגיל 2 · שינוי והוספה</div>
        <p class="exercise-task">בלי להריץ — מה יודפס?</p>
        <div class="exercise-code">d = {"a": 1, "b": 2}
d["b"] = 5
d["c"] = 7
print(len(d), d["b"])</div>
        <div class="exercise-controls">
          <span style="font-size:14.5px; font-weight:600;">הניחוש שלי:</span>
          <input type="text" id="ex2-guess" autocomplete="off" aria-label="הניחוש שלי" placeholder="_ _">
          <button class="exercise-check-btn" id="ex2-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex2-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex2-output"></div>
      </div>

      <div class="exercise-card rust">
        <div class="exercise-num">תרגיל 3 · ברירת מחדל</div>
        <p class="exercise-task">השלימי את שם הפעולה כך שיודפס <span class="mono">0</span> במקום שגיאה.</p>
        <div class="exercise-code">ages = {"דנה": 30, "רונית": 25}
print(ages.<input type="text" id="ex3-m" autocomplete="off" aria-label="שם הפעולה">("שרה", 0))</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex3-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex3-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex3-output"></div>
      </div>

      <div class="exercise-card rust">
        <div class="exercise-num">תרגיל 4 · מעבר על ערכים</div>
        <p class="exercise-task">השלימי כך שיודפס הסכום <span class="mono">20</span>.</p>
        <div class="exercise-code">prices = {"עט": 5, "מחברת": 12, "מחק": 3}
total = 0
for price in prices.<input type="text" id="ex4-m" autocomplete="off" aria-label="שם הפעולה">():
    total = total + price
print(total)</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex4-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex4-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="exercise-output" id="ex4-output"></div>
      </div>

      <div class="exercise-divider">
        <span>כתיבה אישית — פותרות בעורך הפייתון שלכן, לא כאן</span>
      </div>

      <div class="exercise-card">
        <div class="exercise-num">תרגיל 5 · כתיבה חופשית · מתרגם האימוג׳ים שלך</div>
        <p class="exercise-task">כתבי בעורך הפייתון מתרגם כמו בדמו, עם מילון של 5 מילים לפחות ומשפט משלך (רשימת מילים), שמדפיס כל מילה או את האימוג׳י שלה.</p>
        <p class="exercise-note">✍️ כתבו ושמרו את הפתרון בעורך הפייתון שלכן, ואז הדביקו אותו כאן:</p>
        <textarea class="exercise-answer" id="ex5-answer" rows="7" placeholder="# הדביקו כאן את הקוד שכתבתן..."></textarea>
        <div class="ai-note"><strong>עידן ה-AI:</strong> עכשיו בקשי מ-AI: ״הוסף למילון שלי עוד 5 מילים עם אימוג׳ים״. הדביקי את הקוד שחזר, ובמשפט אחד: האם ה-AI שמר על המבנה של המילון שלך?</div>
        <textarea class="exercise-answer" id="ex5-ai-code" rows="5" style="margin-top:12px;" placeholder="# הדביקו כאן את הקוד שה-AI החזיר..."></textarea>
        <textarea class="exercise-answer rtl" id="ex5-ai" rows="2" style="margin-top:12px;" placeholder="משפט אחד: האם המבנה נשמר?"></textarea>
      </div>

      <div class="exercise-divider">
        <span>אתגר רשות — פייתון אמיתי כאן בדפדפן, הקוד רץ ונבדק אוטומטית</span>
      </div>

      <div class="exercise-card" id="ex6-card">
        <div class="exercise-num">תרגיל 6 · אתגר רשות · כתיבת קוד אמיתי · ספירת מילים</div>
        <p class="exercise-task">כתבי פונקציה בשם <span class="mono">count_words</span> שמקבלת רשימת מילים ומחזירה מילון: כל מילה היא מפתח, והערך הוא כמה פעמים היא הופיעה ברשימה.</p>
        <p class="exercise-note">הקוד שלך רץ באמת, בפייתון, בתוך הדף. לחצי ״הריצי״ והוא ייבדק מול כמה מקרים. (Ctrl+Enter גם מריץ.)</p>
        <textarea class="exercise-answer pyx-code" id="ex6-code" rows="9" dir="ltr" spellcheck="false" autocapitalize="off" autocomplete="off" aria-label="הקוד שלך בפייתון">def count_words(words):
    # כתבי כאן את הקוד
    pass
</textarea>
        <div class="exercise-controls" style="margin-top:12px;">
          <button class="run-btn" id="ex6-run" type="button">▶ הריצי</button>
          <button class="exercise-check-btn" id="ex6-stop" type="button" hidden>עצרי</button>
          <span class="exercise-feedback" id="ex6-feedback" role="status" aria-live="polite"></span>
        </div>
        <div class="pyx-status" id="ex6-status" role="status" aria-live="polite" hidden><span id="ex6-status-text"></span><span class="pyx-bar" id="ex6-bar" aria-hidden="true"></span><button class="exercise-check-btn pyx-retry" id="ex6-retry" type="button" hidden>נסי שוב</button></div>
        <div class="exercise-output" id="ex6-output" aria-label="פלט התוכנית"></div>
        <ul class="pyx-tests" id="ex6-tests" aria-label="תוצאות הבדיקות"></ul>
      </div>
    </div>
  </section>

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">מה למדנו</h2>
      <ul class="recap">
        <li>מילון הוא זוגות מפתח ← ערך, ומחפשים בו לפי שם ולא לפי מקום.</li>
        <li><span class="mono">d[key] = value</span> מוסיף או משנה, ו-<span class="mono">del d[key]</span> מוחק.</li>
        <li><span class="mono">d[key]</span> קורס אם אין מפתח, ו-<span class="mono">d.get(key, ברירת_מחדל)</span> לא.</li>
        <li><span class="mono">.keys()</span>, <span class="mono">.values()</span>, <span class="mono">.items()</span> למעבר על מילון.</li>
        <li>נתונים אמיתיים הם מילונים בתוך מילונים ורשימות, וחופרים אליהם צעד אחרי צעד.</li>
      </ul>
    </div>
  </section>

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

<footer><div class="wrap">שיעור פייתון · מילונים</div></footer>

<script>
window.lessonProgress = { name: "", ex1: false, ex2: false, ex3: false, ex4: false, ex6: false, detectiveSolved: 0, detectiveTotal: 2 };

/* דיווח התקדמות לאתר שמציג את השיעור. window.reportProgress מוזרק על ידי האתר ושולח לו הודעה;
   בקובץ שנפתח לבד אין אותו, ולכן הקריאה מוגנת. תרגילי החובה: תרגילים 1-4. תרגיל 5 (VS Code) ותרגיל 6 (אתגר רשות, פייתון אמיתי בדפדפן) לא נספרים. */
function reportLessonProgress() {
  if (!window.reportProgress) return;
  var p = window.lessonProgress, keys = ["ex1", "ex2", "ex3", "ex4"], done = 0;
  for (var i = 0; i < keys.length; i++) { if (p[keys[i]]) done++; }
  window.reportProgress(done, keys.length);
}
reportLessonProgress();

/*PURE-START*/
/* לוגיקת הבדיקה של תרגילים 1-4. פונקציות טהורות ללא DOM, מוכנות לעבור לשרת. */
function pyScalar(v) { return typeof v === "string" ? "''" + v + "''" : String(v); }

function stripQuotes(src) {
  var t = String(src == null ? "" : src).trim();
  var m = /^(["''])(.*)\1$/.exec(t);
  return m ? m[2].trim() : t;
}

/* תרגיל 1: ages[key] צריך להדפיס 25 */
function checkEx1(src) {
  var ages = { "דנה": 30, "רונית": 25, "מיכל": 41 };
  var key = stripQuotes(src);
  if (!key) return { ok: false, error: "כתבי מפתח (שם) בין הסוגריים." };
  if (!Object.prototype.hasOwnProperty.call(ages, key)) return { ok: false, error: "KeyError: ''" + key + "''. אין כרטיס בשם הזה בספר.", shown: "KeyError: ''" + key + "''" };
  var got = ages[key];
  if (got === 25) return { ok: true, shown: String(got) };
  return { ok: false, error: "יצא " + got + ". רוצות 25: של מי הגיל הזה?", shown: String(got) };
}

/* תרגיל 2: ניחוש של len(d) ו-d["b"] אחרי השינויים. התשובה "3 5" */
function checkEx2(src) {
  var d = { a: 1, b: 2 };
  d["b"] = 5; d["c"] = 7;
  var want = [String(Object.keys(d).length), String(d["b"])];
  var parts = String(src == null ? "" : src).trim().split(/[\s,]+/).filter(Boolean);
  if (!parts.length) return { ok: false, error: "כתבי ניחוש: שני מספרים עם רווח ביניהם." };
  var shown = want.join(" ");
  if (parts.length === 2 && parts[0] === want[0] && parts[1] === want[1]) return { ok: true, shown: shown };
  if (parts.length !== 2) return { ok: false, error: "כתבי שני מספרים: קודם len(d), ואז d[\"b\"].", shown: shown };
  return { ok: false, error: "לא בדיוק. אחרי השינויים יש במילון שלושה מפתחות (a, b, c), ו-b קיבל ערך חדש.", shown: shown };
}

/* תרגיל 3: ages.<name>("שרה", 0) צריך להדפיס 0 */
function checkEx3(src) {
  var name = String(src == null ? "" : src).trim();
  if (!name) return { ok: false, error: "כתבי את שם הפעולה." };
  if (name === "get") return { ok: true, shown: "0" };
  if (name === "pop") return { ok: false, error: "pop גם מחזירה ברירת מחדל, אבל היא מוחקת מהמילון. כאן רוצות רק לקרוא, בלי למחוק." };
  if (name === "keys" || name === "values" || name === "items") return { ok: false, error: name + " לא מקבלת מפתח וברירת מחדל. איזו פעולה קוראת ערך לפי מפתח בלי לקרוס?" };
  return { ok: false, error: "למילון אין פעולה בשם ''" + name + "''. הרמז: היא קוראת ערך לפי מפתח, ולא קורסת." };
}

/* תרגיל 4: for price in prices.<name>() צריך לסכם ל-20 */
function checkEx4(src) {
  var name = String(src == null ? "" : src).trim();
  if (!name) return { ok: false, error: "כתבי את שם הפעולה." };
  if (name === "values") return { ok: true, shown: "20" };
  if (name === "keys") return { ok: false, error: "TypeError: אי אפשר לחבר מספר למחרוזת. keys נותנת את השמות (עט, מחברת, מחק), ולא את המחירים." };
  if (name === "items") return { ok: false, error: "TypeError: items נותנת זוגות (שם, מחיר), ואי אפשר לחבר מספר לזוג." };
  return { ok: false, error: "למילון אין פעולה בשם ''" + name + "''. מחפשות את זו שנותנת רק את הערכים." };
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
var REDUCED = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

function highlight(code) {
  return esc(code).replace(/(#.*$)|("[^"]*")|\b(for|in|if|else|and|or|not|while|del)\b|\b(print|len|get|keys|values|items|None)\b|(-?\b\d+(?:\.\d+)?\b)/gm, function (m, cmt, str, kw, fn, num) {
    if (cmt) return ''<span class="tok-cmt">'' + cmt + "</span>";
    if (str) return ''<span class="tok-str">'' + str + "</span>";
    if (kw) return ''<span class="tok-kw">'' + kw + "</span>";
    if (fn) return ''<span class="tok-fn">'' + fn + "</span>";
    return ''<span class="tok-num">'' + num + "</span>";
  });
}
document.querySelectorAll("pre.hl").forEach(function (el) { el.innerHTML = highlight(el.textContent); });
document.querySelectorAll(".exercise-code").forEach(isolateCodeText);

/* מילון בסדר הכנסה: מערך זוגות. repr בסגנון פייתון */
function parseVal(t) { t = String(t).trim(); return /^-?\d+$/.test(t) ? parseInt(t, 10) : t; }
function reprVal(v) { return typeof v === "string" ? "''" + v + "''" : String(v); }
function reprDict(pairs) { return "{" + pairs.map(function (p) { return "''" + p[0] + "'': " + reprVal(p[1]); }).join(", ") + "}"; }
function findIdx(pairs, k) { for (var i = 0; i < pairs.length; i++) if (pairs[i][0] === k) return i; return -1; }

function renderCards(container, pairs, popKey, hitKey) {
  container.innerHTML = "";
  if (!pairs.length) { var e = document.createElement("span"); e.className = "cards-empty"; e.textContent = "מילון ריק {}"; container.appendChild(e); return; }
  pairs.forEach(function (p) {
    var c = document.createElement("div");
    c.className = "kv" + (p[0] === popKey ? " pop" : "") + (p[0] === hitKey ? " hit" : "");
    c.innerHTML = ''<span class="k">'' + esc(p[0]) + ''</span><span class="arrow">←</span><span class="v">'' + esc(p[1]) + "</span>";
    container.appendChild(c);
  });
}

function makeGuess(btnId, inputId, fbId, test, okText, badText) {
  $(btnId).addEventListener("click", function () {
    var fb = $(fbId), v = $(inputId).value.trim();
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

/* ---------- phone book ---------- */
var BASE_AGES = [["דנה", 30], ["רונית", 25], ["מיכל", 41]];
(function () {
  var pairs = BASE_AGES.map(function (p) { return p.slice(); }), log = [];
  var cards = $("pb-cards"), logEl = $("pb-log"), note = $("pb-note");
  function render(popKey, hitKey, msg, isErr) {
    renderCards(cards, pairs, popKey, hitKey);
    if (!log.length) logEl.innerHTML = ''<div class="empty">לחצי על כפתור, והפעולה תירשם כאן.</div>'';
    else {
      logEl.innerHTML = log.map(function (r) { return ''<div class="row"><span>'' + iso(r.code) + ''</span><span class="arrow">→</span><span class="'' + (r.bad ? "bad" : "res") + ''">'' + iso(r.res) + "</span></div>"; }).join("");
      logEl.scrollTop = logEl.scrollHeight;
    }
    note.textContent = msg || ""; note.className = "pg-note" + (isErr ? " err" : "");
  }
  function add(code, res, bad) { log.push({ code: code, res: res, bad: bad }); if (log.length > 12) log.shift(); }
  $("pb-buttons").addEventListener("click", function (e) {
    var b = e.target.closest("button"); if (!b) return;
    var act = b.dataset.act, key = $("pb-key").value.trim(), val = $("pb-val").value;
    if (act === "reset") { pairs = BASE_AGES.map(function (p) { return p.slice(); }); log = []; render(); return; }
    if (!key) { render(null, null, "כתבי מפתח (שם) בשדה הראשון.", true); return; }
    var i = findIdx(pairs, key);
    if (act === "set") {
      var v = parseVal(val);
      if (i >= 0) { pairs[i][1] = v; add(''ages["'' + key + ''"] = '' + reprVal(v), reprDict(pairs)); render(key, null, "המפתח כבר היה קיים, ולכן הערך שלו השתנה."); }
      else { pairs.push([key, v]); add(''ages["'' + key + ''"] = '' + reprVal(v), reprDict(pairs)); render(key, null, "המפתח היה חדש, ולכן נוסף כרטיס."); }
    } else if (act === "del") {
      if (i < 0) { add(''del ages["'' + key + ''"]'', "KeyError: ''" + key + "''", true); render(null, null, "אין כרטיס בשם הזה בספר.", true); }
      else { pairs.splice(i, 1); add(''del ages["'' + key + ''"]'', reprDict(pairs)); render(null, null, "הכרטיס נמחק."); }
    } else if (act === "read") {
      if (i < 0) { add(''ages["'' + key + ''"]'', "KeyError: ''" + key + "''", true); render(null, null, "אין כרטיס בשם הזה בספר.", true); }
      else { add(''ages["'' + key + ''"]'', reprVal(pairs[i][1])); render(null, key, "מצאנו! הערך של " + key + " הוא " + pairs[i][1] + "."); }
    }
  });
  makeGuess("g1-btn", "g1-input", "g1-fb", function (v) { var p = v.split(/[\s,]+/); return p.length === 2 && p[0] === "3" && p[1] === "5"; },
    "נכון! שלושה מפתחות (a, b, c), ו-b קיבל ערך חדש: 3 5.", "לא בדיוק. d[''b''] = 5 משנה מפתח קיים, ו-d[''c''] = 7 מוסיף חדש. כמה מפתחות יש עכשיו?");
  render();
})();

/* ---------- get ---------- */
(function () {
  var pairs = [["דנה", 30], ["רונית", 25], ["מיכל", 41]];
  renderCards($("get-cards"), pairs);
  function show(id, cap, html) { $(id).innerHTML = ''<div class="cap">'' + iso(cap) + "</div>" + html; }
  $("get-a").addEventListener("click", function () {
    var k = $("get-key").value.trim(), i = findIdx(pairs, k), cap = ''ages["'' + k + ''"]'';
    show("get-out-a", cap, i >= 0 ? ''<div class="ok">'' + iso(reprVal(pairs[i][1])) + "</div>" : ''<div class="bad">'' + iso("KeyError: ''" + k + "''") + "</div>");
    renderCards($("get-cards"), pairs, null, i >= 0 ? k : null);
  });
  $("get-b").addEventListener("click", function () {
    var k = $("get-key").value.trim(), i = findIdx(pairs, k), cap = ''ages.get("'' + k + ''", 0)'';
    show("get-out-b", cap, ''<div class="ok">'' + iso(i >= 0 ? reprVal(pairs[i][1]) : "0") + "</div>");
    renderCards($("get-cards"), pairs, null, i >= 0 ? k : null);
  });
  makeGuess("g2-btn", "g2-input", "g2-fb", function (v) { return v === "0"; },
    "נכון! אין שרה, אז get מחזירה את ברירת המחדל שקבענו: 0.", "לא בדיוק. get לא קורסת, והיא מחזירה את הערך השני שכתבנו בסוגריים.");
})();

/* ---------- nested tree ---------- */
(function () {
  var data = { "user": { "name": "דנה", "city": "חיפה" }, "items": [{ "name": "עט", "price": 5 }, { "name": "מחברת", "price": 12 }] };
  var tree = $("tree"), expr = $("expr"), current = null;
  function pathExpr(path) { return "data" + path.map(function (s) { return typeof s === "number" ? "[" + s + "]" : ''["'' + s + ''"]''; }).join(""); }
  function build(node, path) {
    var ul = document.createElement("ul");
    var entries = Array.isArray(node) ? node.map(function (v, i) { return [i, v]; }) : Object.keys(node).map(function (k) { return [k, node[k]]; });
    entries.forEach(function (en) {
      var li = document.createElement("li"), k = en[0], v = en[1], p = path.concat([k]);
      var label = typeof k === "number" ? "[" + k + "]" : ''"'' + k + ''"'';
      li.innerHTML = ''<span class="key">'' + esc(label) + "</span>:";
      if (v !== null && typeof v === "object") li.appendChild(build(v, p));
      else {
        var b = document.createElement("button"); b.type = "button"; b.className = "leaf";
        b.innerHTML = iso(typeof v === "string" ? ''"'' + v + ''"'' : String(v));
        b.addEventListener("click", function () {
          if (current) current.classList.remove("on");
          b.classList.add("on"); current = b;
          expr.innerHTML = iso(b.textContent) + "  ←  " + iso(pathExpr(p));
        });
        li.appendChild(b);
      }
      ul.appendChild(li);
    });
    return ul;
  }
  tree.appendChild(build(data, []));
  makeGuess("g3-btn", "g3-input", "g3-fb", function (v) { return v === "12"; },
    "נכון! data[\"items\"] היא רשימה, [1] הוא המחברת, ו-[\"price\"] נותן 12.", "לא בדיוק. לחצי על הערכים בעץ: איזה פריט נמצא ב-[1], ומה המחיר שלו?");
})();

/* ---------- emoji translator ---------- */
(function () {
  var dict = [["אוהבת", "❤️"], ["פיצה", "🍕"], ["גלידה", "🍦"]];
  var cardsEl = $("em-cards"), outEl = $("em-out"), note = $("em-note"), timers = [], translated = false;
  renderCards(cardsEl, dict);
  function translate() {
    timers.forEach(clearTimeout); timers = []; translated = true;
    outEl.innerHTML = "";
    var words = $("em-in").value.trim().split(/\s+/).filter(Boolean);
    if (!words.length) { outEl.innerHTML = ''<span class="cards-empty">כתבי משפט.</span>''; return; }
    words.forEach(function (w, k) {
      function step() {
        var i = findIdx(dict, w), chip = document.createElement("div");
        chip.className = "em-chip pop" + (i >= 0 ? "" : " keep");
        chip.innerHTML = ''<span class="big">'' + esc(i >= 0 ? dict[i][1] : w) + ''</span><span class="src">'' + esc(w) + "</span>";
        outEl.appendChild(chip);
      }
      if (REDUCED) step(); else timers.push(setTimeout(step, 350 * k));
    });
  }
  $("em-run").addEventListener("click", translate);
  $("em-add").addEventListener("click", function () {
    var w = $("em-word").value.trim(), e = $("em-emoji").value.trim();
    if (!w || !e) { note.textContent = "כתבי גם מילה וגם אימוג׳י."; note.className = "pg-note err"; return; }
    var i = findIdx(dict, w);
    if (i >= 0) dict[i][1] = e; else dict.push([w, e]);
    renderCards(cardsEl, dict, w);
    var words = $("em-in").value.trim().split(/\s+/).filter(Boolean);
    note.className = "pg-note";
    note.textContent = words.indexOf(w) >= 0
      ? "יפה! עכשיו get מצאה במילון את ״" + w + "״, ולכן היא מתורגמת. מילים שאין להן מפתח נשארות כמו שהן."
      : "נוסף למילון, אבל ״" + w + "״ לא מופיעה במשפט, ולכן לא רואים שינוי בתרגום.";
    if (translated) translate();
  });
})();

/* ---------- exercises ---------- */
(function () {
  function setFeedback(el, ok, text) { el.textContent = text; el.className = "exercise-feedback " + (ok ? "correct" : "wrong"); }
  function run(n, r, okText) {
    $("ex" + n + "-output").innerHTML = iso(r.shown || "");
    if (r.ok) { setFeedback($("ex" + n + "-feedback"), true, okText); window.lessonProgress["ex" + n] = true; reportLessonProgress(); }
    else setFeedback($("ex" + n + "-feedback"), false, r.error);
  }
  $("ex1-check").addEventListener("click", function () { run(1, checkEx1($("ex1-k").value), "נכון! רונית היא 25."); });
  $("ex2-check").addEventListener("click", function () { run(2, checkEx2($("ex2-guess").value), "נכון! שלושה מפתחות, ו-b הוא 5."); });
  $("ex3-check").addEventListener("click", function () { run(3, checkEx3($("ex3-m").value), "מדויק! get לא קורסת, והיא מחזירה את ברירת המחדל."); });
  $("ex4-check").addEventListener("click", function () { run(4, checkEx4($("ex4-m").value), "יפה! values נותנת רק את המחירים: 20."); });
})();

/* ---------- תרגיל 6 (אתגר רשות): פייתון אמיתי בדפדפן ---------- */
/* התשתית (Worker מבודד, CSP, טעינה מוקדמת, בדיקה מול מקרים, הודעות) מוזרקת על ידי האתר כ-window.pyxRunner. כאן רק הגדרת התרגיל. */
(function () {
  if (!window.pyxRunner) {
    $("ex6-run").disabled = true;
    $("ex6-status").hidden = false;
    $("ex6-status-text").textContent = "הרצת הקוד זמינה רק כשהשיעור נפתח באתר הקורסים.";
    return;
  }
  window.pyxRunner.mount({
    fn: "count_words", topicKey: "ex6", card: "ex6-card",
    ids: { code: "ex6-code", run: "ex6-run", stop: "ex6-stop", retry: "ex6-retry", feedback: "ex6-feedback", status: "ex6-status", statusText: "ex6-status-text", output: "ex6-output", tests: "ex6-tests" },
    cases: [
      { id: 1, label: "רשימה שבה מילה חוזרת", input: ["a", "b", "a"], expected: { a: 2, b: 1 } },
      { id: 2, label: "רשימה ריקה", input: [], expected: {} },
      { id: 3, label: "מילה אחת שחוזרת שלוש פעמים", input: ["x", "x", "x"], expected: { x: 3 } },
      { id: 4, label: "מקרה נסתר", hidden: true, input: ["go", "stop", "go", "go", "stop", "wait"], expected: { go: 3, stop: 2, wait: 1 } }
    ],
    onPass: function () { window.lessonProgress.ex6 = true; }
  });
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
    var aiCode = esc($("ex5-ai-code").value.trim()) || "(לא הוזן קוד)";
    var ai = esc($("ex5-ai").value.trim()) || "(לא הוזן)";
    var dateStr = new Date().toLocaleDateString("he-IL");
    return ''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8">'' +
      "<title>תעודת תרגול — " + esc(name) + "</title>" +
      ''<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'' +
      ''<link href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@700&family=Heebo:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">'' +
      "<style>" +
      ":root{--bg:#14121f;--panel:#1d1a2d;--ink:#16242b;--dim:#bdb7d3;--gold:#ff7f96;--ok:#6fe0a0;--no:#ff7f96;--code:#16242b;--code-ink:#f4f1fa;--line:rgba(58,53,88,.14);}" +
      "*{box-sizing:border-box;}body{margin:0;background:var(--bg);color:var(--ink);font-family:Assistant,sans-serif;font-size:16px;line-height:1.7;padding:50px 20px;}" +
      ".wrap{max-width:640px;margin:0 auto;}h1{font-family:Secular One,serif;font-weight:700;font-size:2rem;margin:0 0 6px;}" +
      ".meta{color:var(--dim);margin-bottom:34px;font-size:15px;}h2{font-family:Secular One,serif;font-weight:700;font-size:1.2rem;margin:0 0 14px;color:var(--gold);}" +
      ".card{background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:20px 22px;margin-bottom:26px;}" +
      ".row{display:flex;align-items:center;gap:10px;padding:6px 0;}.dot{width:10px;height:10px;border-radius:50%;background:var(--no);flex-shrink:0;}.dot.done{background:var(--ok);}" +
      ".label{flex:1;font-size:15px;}.state{font-family:''JetBrains Mono'',monospace;font-size:13px;font-weight:600;}.state.ok{color:var(--ok);}.state.no{color:var(--no);}" +
      ".score{font-family:''JetBrains Mono'',monospace;font-size:15px;color:var(--dim);padding:6px 0;}.score strong{color:var(--ink);}" +
      "pre{direction:ltr;text-align:left;font-family:''JetBrains Mono'',monospace;font-size:13.5px;line-height:1.7;background:var(--code);border-radius:10px;padding:16px 18px;overflow-x:auto;white-space:pre-wrap;word-break:break-word;color:var(--code-ink);margin:0 0 12px;}" +
      ".q{font-size:14.5px;color:var(--dim);margin:0 0 10px;}.txt{margin:12px 0 0;white-space:pre-wrap;}" +
      ''</style></head><body><div class="wrap">'' +
      "<h1>תעודת תרגול — מילונים בפייתון</h1>" +
      ''<div class="meta">שם: '' + esc(name) + " · תאריך: " + dateStr + "</div>" +
      ''<h2>תרגילים עם בדיקה</h2><div class="card">'' +
      statusRow("תרגיל 1 (קריאה לפי מפתח)", p.ex1) + statusRow("תרגיל 2 (שינוי והוספה)", p.ex2) + statusRow("תרגיל 3 (ברירת מחדל)", p.ex3) + statusRow("תרגיל 4 (מעבר על ערכים)", p.ex4) +
      "</div>" +
      ''<h2>בלשית קוד</h2><div class="card"><div class="score">מקרים שנפתרו: <strong>'' + p.detectiveSolved + "</strong> מתוך " + p.detectiveTotal + "</div></div>" +
      ''<h2>תרגיל 5 · מתרגם האימוג׳ים</h2><div class="card"><p class="q">התוכנית שלי:</p><pre>'' + ex5 + ''</pre><p class="q">הקוד ש-AI החזיר:</p><pre>'' + aiCode + ''</pre><p class="txt">'' + ai + "</p></div>" +
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

<script>
/* מדגים לולאה על מילון צעד אחר צעד */
(function () {
  var data = [["Dana", 30], ["Yuval", 25], ["Noa", 28]];
  var mode = "keys", i = 0;
  var cards = document.getElementById("gd-cards"), code = document.getElementById("gd-code"),
      vr = document.getElementById("gd-var"), out = document.getElementById("gd-out"),
      msg = document.getElementById("gd-msg"), next = document.getElementById("gd-next");
  var modes = {
    keys:   { head: "for name in ages:", body: "    print(name)" },
    values: { head: "for age in ages.values():", body: "    print(age)" },
    items:  { head: "for name, age in ages.items():", body: ''    print(name, "is", age)'' }
  };
  function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
  function render() {
    cards.innerHTML = "";
    data.forEach(function (p, idx) {
      var c = document.createElement("div");
      c.className = "st-card" + (idx === i - 1 ? " on" : (idx < i - 1 ? " done" : ""));
      c.innerHTML = ''<span class="k">"'' + p[0] + ''"</span>: '' + p[1];
      cards.appendChild(c);
    });
    var m = modes[mode];
    code.innerHTML = ''<span class="ln'' + (i > 0 && i <= data.length ? " on" : "") + ''">'' + esc(m.head) + ''</span><span class="ln'' + (i > 0 && i <= data.length ? " on" : "") + ''">'' + esc(m.body) + ''</span>'';
    if (i === 0) { vr.textContent = ""; out.textContent = ""; msg.textContent = "לחצו על ״צעד הבא״ כדי להתחיל."; next.disabled = false; return; }
    var cur = data[i - 1];
    if (mode === "keys") vr.textContent = ''סיבוב '' + i + '':  name = "'' + cur[0] + ''"'';
    else if (mode === "values") vr.textContent = ''סיבוב '' + i + '':  age = '' + cur[1];
    else vr.textContent = ''סיבוב '' + i + '':  name = "'' + cur[0] + ''",  age = '' + cur[1];
    var lines = [];
    for (var k = 0; k < i; k++) {
      var d = data[k];
      lines.push(mode === "keys" ? d[0] : mode === "values" ? String(d[1]) : d[0] + " is " + d[1]);
    }
    out.textContent = lines.join("\n");
    if (i >= data.length) { msg.textContent = "המילון נגמר, ולכן הלולאה מסתיימת."; next.disabled = true; }
    else msg.textContent = "";
  }
  document.querySelectorAll("#gd-modes .pill").forEach(function (b) {
    b.addEventListener("click", function () {
      mode = b.dataset.m; i = 0;
      document.querySelectorAll("#gd-modes .pill").forEach(function (x) { x.classList.toggle("active", x === b); });
      render();
    });
  });
  next.addEventListener("click", function () { if (i < data.length) { i++; render(); } });
  document.getElementById("gd-reset").addEventListener("click", function () { i = 0; render(); });
  var first = document.querySelector(''#gd-modes .pill''); if (first) first.classList.add("active");
  render();
})();
</script>
<script>
/* חוקי או שגיאה? */
(function () {
  var qs = [
    { code: ''{"name": "Dana", "age": 30}'', a: "ok", why: "מילון תקין: נקודתיים בין מפתח לערך, ופסיק בין זוגות." },
    { code: ''{"name": "Dana" "age": 30}'', a: "err", why: "חסר פסיק בין שני הזוגות, ולכן SyntaxError." },
    { code: ''{["x", "y"]: 1}'', a: "err", why: "רשימה לא יכולה להיות מפתח: TypeError (unhashable type: list). רשימה כערך הייתה בסדר." },
    { code: ''{"a": 1, "a": 2}'', a: "over", why: "אין שגיאה, אבל המפתח הכפול דורס: נשאר רק {\''a\'': 2}." },
    { code: ''{name: "Dana"}'', a: "err", why: "בלי מרכאות פייתון חושבת ש-name הוא משתנה, ולכן NameError." }
  ];
  var i = 0, score = 0, locked = false;
  var code = document.getElementById("gv-code"), fb = document.getElementById("gv-fb"), nextB = document.getElementById("gv-next"),
      again = document.getElementById("gv-again"), opts = document.querySelectorAll("#gv-opts .gv-opt");
  function render() {
    var q = qs[i]; locked = false;
    code.innerHTML = highlight(q.code);
    document.getElementById("gv-count").textContent = "שאלה " + (i + 1) + " מתוך " + qs.length;
    document.getElementById("gv-bar").style.width = (i / qs.length * 100) + "%";
    document.getElementById("gv-score").textContent = "ניקוד: " + score;
    fb.textContent = ""; fb.className = "gv-fb"; nextB.hidden = true; again.hidden = true;
    opts.forEach(function (b) { b.disabled = false; b.classList.remove("right", "wrong"); });
    document.getElementById("gv-opts").hidden = false; document.getElementById("gv-card").hidden = false;
  }
  opts.forEach(function (b) {
    b.addEventListener("click", function () {
      if (locked) return; locked = true;
      var q = qs[i], good = b.dataset.a === q.a;
      opts.forEach(function (x) { x.disabled = true; if (x.dataset.a === q.a) x.classList.add("right"); });
      if (good) { score++; fb.className = "gv-fb good"; fb.textContent = "נכון! " + q.why; }
      else { b.classList.add("wrong"); fb.className = "gv-fb bad"; fb.textContent = "לא בדיוק. " + q.why; }
      document.getElementById("gv-score").textContent = "ניקוד: " + score;
      nextB.hidden = false; nextB.textContent = i === qs.length - 1 ? "לסיום ▸" : "השאלה הבאה ▸";
    });
  });
  nextB.addEventListener("click", function () {
    if (i < qs.length - 1) { i++; render(); }
    else {
      document.getElementById("gv-bar").style.width = "100%";
      document.getElementById("gv-opts").hidden = true; document.getElementById("gv-card").hidden = true; nextB.hidden = true; again.hidden = false;
      code.textContent = "";
      fb.className = "gv-fb " + (score >= 4 ? "good" : ""); fb.textContent = (score === qs.length ? "🏆 " : "") + "סיימתם: " + score + " מתוך " + qs.length + (score >= 4 ? ". מעולה, אתם מכירים את החוקים." : ". כדאי לחזור להסבר למעלה ולנסות שוב.");
    }
  });
  again.addEventListener("click", function () { i = 0; score = 0; render(); });
  render();
})();
</script></body>
</html>
', 6, '2026-10-08T07:27:31.938Z');
