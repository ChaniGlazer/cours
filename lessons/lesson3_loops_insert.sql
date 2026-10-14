DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='for-while-loops';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('65fb1e5aae2f5ef4f57a7f33de27412d', 'python-ai-era', 'for-while-loops', 'שיעור 3 - לולאות for ו-while', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>for ו-while בפייתון — משחקים</title>
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
  h1, h2, h3 { font-family: var(--display); font-weight: 800; color: var(--ink); margin: 0; }
  code, .mono { font-family: var(--mono); }

  button { font-family: var(--sans); cursor: pointer; }
  button:focus-visible { outline: 2px solid var(--ink); outline-offset: 3px; }

  section { padding: 68px 0; }
  section + section { border-top: 1px solid var(--line); }

  .eyebrow { font-family: var(--mono); font-size: 13px; color: var(--ink-faint); margin-bottom: 12px; }
  .eyebrow.for-c { color: var(--for); }
  .eyebrow.while-c { color: var(--while); }

  h2.section-title { font-size: clamp(1.6rem, 4.5vw, 2.2rem); }
  .lede { font-size: 18px; margin-top: 14px; }

  /* ---------- HERO + CLICKER TEASER ---------- */

  .hero { padding: 80px 0 60px; text-align: center; }
  .hero h1 { font-size: clamp(2.1rem, 7vw, 3.2rem); line-height: 1.18; }
  .hero h1 .accent-for { color: var(--for); }
  .hero h1 .accent-while { color: var(--while); }
  .hero-sub { max-width: 46ch; margin: 18px auto 0; font-size: 18.5px; }

  .teaser {
    margin: 40px auto 0;
    max-width: 420px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    padding: 30px 26px;
    position: relative;
    overflow: hidden;
  }
  .teaser p { font-size: 16px; margin-bottom: 20px; }
  .big-btn {
    font-family: var(--display);
    font-weight: 800;
    font-size: 18px;
    color: #1a1204;
    background: var(--for);
    border: none;
    border-radius: 100px;
    padding: 16px 40px;
    box-shadow: 0 8px 0 #b5762c, 0 10px 24px rgba(255,184,77,0.25);
    transition: transform 0.08s ease, box-shadow 0.08s ease;
  }
  .big-btn:active { transform: translateY(6px); box-shadow: 0 2px 0 #b5762c, 0 4px 10px rgba(255,184,77,0.2); }
  .teaser-count { margin-top: 18px; font-family: var(--mono); font-size: 15px; color: var(--ink-faint); }
  .teaser-result {
    margin-top: 20px;
    padding-top: 18px;
    border-top: 1px solid var(--line);
    font-size: 15.5px;
    color: var(--ink);
    opacity: 0;
    transform: translateY(6px);
    transition: opacity 0.4s ease, transform 0.4s ease;
  }
  .teaser-result.show { opacity: 1; transform: translateY(0); }
  .spark {
    position: absolute;
    font-size: 14px;
    pointer-events: none;
    animation: spark-rise 0.7s ease-out forwards;
  }
  @keyframes spark-rise {
    from { opacity: 1; transform: translateY(0) scale(1); }
    to { opacity: 0; transform: translateY(-50px) scale(1.3); }
  }

  /* ---------- BEFORE/AFTER ---------- */

  .contrast {
    margin-top: 32px;
    display: grid;
    grid-template-columns: 1.3fr auto 1fr;
    gap: 18px;
    align-items: center;
  }
  @media (max-width: 640px) { .contrast { grid-template-columns: 1fr; } }
  .contrast-arrow { font-family: var(--display); font-size: 24px; color: var(--ink-faint); text-align: center; }
  @media (max-width: 640px) { .contrast-arrow { transform: rotate(90deg); } }

  .code-card {
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    overflow: hidden;
  }
  .code-card-label {
    font-size: 13.5px;
    font-weight: 700;
    color: var(--ink-faint);
    padding: 12px 18px;
    border-bottom: 1px solid var(--line);
  }
  .code-card.for-accent .code-card-label { color: var(--for); }
  .code-card.while-accent .code-card-label { color: var(--while); }
  .code-card pre {
    direction: ltr; text-align: left; margin: 0;
    padding: 16px 18px 18px;
    overflow-x: auto;
    font-family: var(--mono); font-size: 14.5px; line-height: 1.7;
  }
  .tok-kw { color: #C792EA; }
  .tok-str { color: #A8D48A; }
  .tok-num { color: #F5C97B; }
  .tok-fn { color: #7EC1F5; }
  .tok-var { color: var(--ink); }

  /* ---------- FOR PLAYGROUND ---------- */

  .playground {
    margin-top: 36px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    overflow: hidden;
  }
  .playground-controls {
    padding: 22px 24px;
    border-bottom: 1px solid var(--line);
    display: flex;
    align-items: center;
    gap: 16px;
    flex-wrap: wrap;
  }
  .playground-controls label { font-weight: 700; font-size: 15px; }
  .slider-row { display: flex; align-items: center; gap: 12px; flex: 1; min-width: 200px; }
  input[type="range"] { flex: 1; accent-color: var(--for); }
  .slider-val {
    font-family: var(--mono); font-weight: 700; font-size: 18px;
    color: var(--for); min-width: 28px; text-align: center;
  }
  .run-btn {
    font-family: var(--display); font-weight: 800; font-size: 15px;
    color: #1a1204; background: var(--for); border: none;
    border-radius: 100px; padding: 12px 26px;
  }
  .run-btn:disabled { opacity: 0.5; }

  .playground-code {
    direction: ltr; text-align: left;
    font-family: var(--mono); font-size: 14.5px; line-height: 2;
    padding: 16px 0;
    border-bottom: 1px solid var(--line);
  }
  .playground-code .line { padding: 2px 22px; white-space: pre; border-radius: 6px; transition: background 0.15s ease; }
  .playground-code .line.active { background: var(--for-soft); box-shadow: inset 3px 0 0 var(--for); }

  .stage {
    min-height: 96px;
    padding: 22px 24px;
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }
  .star {
    display: flex; flex-direction: column; align-items: center; gap: 4px;
    opacity: 0; transform: scale(0.3);
    animation: pop-in 0.35s cubic-bezier(.34,1.56,.64,1) forwards;
  }
  .star .icon { font-size: 26px; }
  .star .i-val { font-family: var(--mono); font-size: 12px; color: var(--ink-faint); }
  @keyframes pop-in { to { opacity: 1; transform: scale(1); } }

  .guess-row {
    padding: 18px 24px;
    border-top: 1px solid var(--line);
    display: flex;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
  }
  .guess-row input[type="number"] {
    width: 70px; font-family: var(--mono); font-size: 16px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong);
    border-radius: 8px; color: var(--ink); padding: 8px 10px; text-align: center;
  }
  .guess-btn {
    background: var(--bg-panel-2); color: var(--ink); border: 1px solid var(--line-strong);
    border-radius: 100px; padding: 9px 18px; font-weight: 700; font-size: 14px;
  }
  .guess-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .guess-feedback.correct { color: var(--success); }
  .guess-feedback.wrong { color: var(--danger); }

  /* ---------- RANGE EXPLAINER ---------- */

  .range-explainer {
    margin-top: 28px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 22px 24px;
  }
  .range-explainer-head {
    font-family: var(--mono); font-size: 17px; color: var(--for);
    display: flex; align-items: center; gap: 4px; direction: ltr; justify-content: flex-start; flex-wrap: wrap;
  }
  .range-explainer-head input[type="number"] {
    width: 54px; text-align: center; font-family: var(--mono); font-size: 16px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--for); padding: 4px 6px;
  }
  .range-intro { font-size: 14.5px; margin-bottom: 16px; }
  .range-tabs { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 18px; }
  .range-tab {
    font-family: var(--mono); font-size: 13px; padding: 8px 14px; border-radius: 100px;
    border: 1px solid var(--line-strong); background: var(--bg-panel-2); color: var(--ink-dim);
  }
  .range-tab.active { background: var(--for-soft); color: var(--for); border-color: var(--for); }
  .range-line { display: flex; gap: 8px; margin-top: 18px; flex-wrap: wrap; direction: ltr; }
  .range-box.skipped { background: transparent; color: var(--ink-faint); border: 1px dashed var(--line-strong); opacity: 0.65; }
  .range-box {
    width: 42px; height: 42px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-family: var(--mono); font-weight: 700; font-size: 15px;
  }
  .range-box.included { background: var(--for-soft); color: var(--for); border: 1px solid var(--for); }
  .range-box.excluded { background: transparent; color: var(--danger); border: 1px dashed var(--danger); }
  .range-note { margin-top: 16px; font-size: 14.5px; color: var(--ink-dim); }
  .range-note strong { color: var(--ink); }

  /* ---------- EXERCISES ---------- */

  .exercise-card {
    margin-top: 22px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-inline-start: 3px solid var(--line-strong);
    border-radius: 16px;
    padding: 22px 24px;
  }
  .exercise-card.for-accent { border-inline-start-color: var(--for); }
  .exercise-card.while-accent { border-inline-start-color: var(--while); }
  .exercise-num { font-family: var(--mono); font-size: 12.5px; color: var(--ink-faint); }
  .exercise-task { margin: 8px 0 16px; font-weight: 600; color: var(--ink); font-size: 15.5px; }
  .exercise-code {
    direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 1.9;
    background: rgba(0,0,0,0.22); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px;
  }
  .exercise-code input[type="number"] {
    width: 50px; font-family: var(--mono); font-size: 14px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 6px;
    color: var(--for); padding: 3px 4px; text-align: center;
  }
  .while-accent .exercise-code input[type="number"] { color: var(--while); }
  .exercise-controls { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .exercise-controls input[type="number"] {
    width: 54px; font-family: var(--mono); font-size: 15px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px;
    color: var(--ink); padding: 7px 8px; text-align: center;
  }
  .exercise-check-btn {
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); color: var(--ink);
    border-radius: 100px; padding: 9px 20px; font-weight: 700; font-size: 14px;
  }
  .exercise-feedback { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .exercise-feedback.correct { color: var(--success); }
  .exercise-feedback.wrong { color: var(--danger); }
  .exercise-output {
    margin-top: 12px; font-family: var(--mono); font-size: 13.5px;
    background: rgba(0,0,0,0.18); border-radius: 8px; padding: 10px 12px;
    color: var(--ink-dim); white-space: pre-line; min-height: 20px;
  }

  .exercise-divider {
    margin-top: 40px;
    display: flex;
    align-items: center;
    gap: 14px;
    color: var(--ink-faint);
    font-family: var(--mono);
    font-size: 13px;
  }
  .exercise-divider::before, .exercise-divider::after {
    content: ""; flex: 1; height: 1px; background: var(--line);
  }
  .exercise-hint {
    direction: ltr; text-align: left; font-family: var(--mono); font-size: 13px;
    color: var(--ink-dim); background: rgba(0,0,0,0.18); border-radius: 8px;
    padding: 12px 14px; margin-bottom: 12px; line-height: 1.7;
  }
  .exercise-note { font-size: 13.5px; color: var(--ink-faint); font-style: italic; margin: 0 0 10px; }
  .exercise-answer {
    width: 100%; direction: ltr; text-align: left;
    font-family: var(--mono); font-size: 13.5px; line-height: 1.7;
    background: rgba(0,0,0,0.22); border: 1px solid var(--line-strong); border-radius: 8px;
    color: var(--ink); padding: 12px 14px; resize: vertical;
  }
  .exercise-answer:focus { outline: none; border-color: var(--ink-dim); }

  /* ---------- CODE DETECTIVE ---------- */

  .detective-card {
    margin-top: 30px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    padding: 26px 26px 24px;
  }
  .detective-head { margin-bottom: 14px; }
  .detective-progress { font-family: var(--mono); font-size: 13px; color: var(--ink-faint); }
  .detective-task { font-size: 16px; font-weight: 600; color: var(--ink); margin-bottom: 16px; }
  .detective-output {
    font-family: var(--mono); font-size: 15px; color: var(--for);
    background: rgba(0,0,0,0.25); border-radius: 10px; padding: 14px 16px;
    margin-bottom: 16px; direction: ltr; text-align: left; white-space: pre-line;
  }
  .detective-code {
    direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 1.9;
    background: rgba(0,0,0,0.22); border-radius: 10px; padding: 14px 16px; margin-bottom: 16px;
  }
  .detective-code input[type="number"] {
    width: 50px; font-family: var(--mono); font-size: 14px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 6px;
    color: var(--for); padding: 3px 4px; text-align: center;
  }

  /* ---------- WHILE BALLOON GAME ---------- */

  .balloon-game {
    margin-top: 36px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    overflow: hidden;
  }
  .balloon-body { display: grid; grid-template-columns: 1fr 1fr; }
  @media (max-width: 680px) { .balloon-body { grid-template-columns: 1fr; } }

  .balloon-stage {
    position: relative;
    min-height: 280px;
    display: flex;
    align-items: flex-end;
    justify-content: center;
    padding: 24px 0 20px;
    border-inline-end: 1px solid var(--line);
    overflow: hidden;
  }
  @media (max-width: 680px) { .balloon-stage { border-inline-end: none; border-bottom: 1px solid var(--line); } }

  .balloon {
    width: 64px; height: 78px;
    background: radial-gradient(circle at 35% 28%, #ffc2d6, var(--while) 70%);
    border-radius: 50% 50% 50% 50% / 62% 62% 38% 38%;
    position: relative;
    transform-origin: bottom center;
    transform: scale(1);
    transition: transform 0.28s cubic-bezier(.34,1.56,.64,1);
    box-shadow: 0 0 28px rgba(255,92,138,0.3);
  }
  .balloon::after {
    content: ""; position: absolute; bottom: -12px; left: 50%; transform: translateX(-50%);
    border-left: 6px solid transparent; border-right: 6px solid transparent; border-top: 9px solid var(--while);
  }
  .balloon.popped { animation: pop 0.3s ease forwards; }
  @keyframes pop { 0% { transform: scale(var(--s, 1)); opacity: 1; } 60% { transform: scale(calc(var(--s, 1) * 1.4)); opacity: 1; } 100% { transform: scale(0); opacity: 0; } }

  .confetti-piece {
    position: absolute; top: 30%; width: 7px; height: 7px; border-radius: 2px;
    animation: confetti-fall 0.9s ease-out forwards;
  }
  @keyframes confetti-fall { to { transform: translateY(140px) rotate(360deg); opacity: 0; } }

  .balloon-side { padding: 22px 24px; }
  .balloon-side h4 { font-family: var(--sans); font-weight: 700; font-size: 15px; margin: 0 0 14px; }
  .balloon-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14px; line-height: 1.9; background: rgba(0,0,0,0.22); border-radius: 10px; padding: 12px 0; margin-bottom: 16px; }
  .balloon-code .line { padding: 1px 16px; white-space: pre; border-radius: 5px; }
  .balloon-code .line.active { background: var(--while-soft); box-shadow: inset 3px 0 0 var(--while); }
  .balloon-var { font-family: var(--mono); font-size: 15px; margin-bottom: 16px; }
  .balloon-var .k { color: var(--ink-faint); }
  .balloon-var .v { color: var(--while); font-weight: 700; }
  .balloon-buttons { display: flex; gap: 10px; flex-wrap: wrap; }
  .balloon-buttons button {
    font-weight: 700; font-size: 14px; border-radius: 100px; padding: 10px 18px; border: 1px solid var(--line-strong);
    background: var(--bg-panel-2); color: var(--ink);
  }
  .balloon-buttons button.primary { background: var(--while); color: #2b0916; border-color: var(--while); }
  .balloon-buttons button:disabled { opacity: 0.4; }
  .balloon-status { margin-top: 14px; font-size: 14.5px; min-height: 20px; color: var(--ink-dim); }

  /* ---------- INFINITE LOOP RESCUE ---------- */

  .rescue {
    margin-top: 36px;
    background: var(--bg-panel);
    border: 1px solid var(--danger);
    border-radius: var(--radius);
    padding: 24px 26px 26px;
  }
  .rescue.fixed { border-color: var(--success); }
  .rescue-head { display: flex; align-items: center; gap: 14px; margin-bottom: 18px; }
  .spinner {
    width: 30px; height: 30px; border-radius: 50%;
    border: 4px solid var(--line-strong); border-top-color: var(--danger);
    animation: spin 0.7s linear infinite;
  }
  .rescue.fixed .spinner { display: none; }
  .rescue-check { display: none; font-size: 26px; color: var(--success); }
  .rescue.fixed .rescue-check { display: block; }
  @keyframes spin { to { transform: rotate(360deg); } }
  .rescue-head h4 { font-family: var(--sans); font-weight: 700; font-size: 15.5px; margin: 0; }
  .rescue pre {
    direction: ltr; text-align: left; margin: 0 0 18px;
    font-family: var(--mono); font-size: 14.5px; line-height: 1.75;
    background: rgba(0,0,0,0.25); border-radius: 10px; padding: 16px 18px;
  }
  .rescue pre .added { color: var(--success); }
  .rescue-choices { display: flex; gap: 12px; flex-wrap: wrap; }
  .rescue-choice {
    flex: 1; min-width: 220px; text-align: right;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 14px;
    padding: 14px 16px; font-size: 14.5px; color: var(--ink);
  }
  .rescue-choice:hover { border-color: var(--ink-dim); }
  .rescue-feedback { margin-top: 14px; font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .rescue-feedback.correct { color: var(--success); }
  .rescue-feedback.wrong { color: var(--danger); }

  /* ---------- QUICK-FIRE QUIZ ---------- */

  .quiz-card {
    margin-top: 20px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: 16px;
    padding: 20px 22px;
  }
  .quiz-card p { color: var(--ink); font-size: 16px; font-weight: 600; margin-bottom: 16px; }
  .quiz-choices { display: flex; gap: 10px; }
  .quiz-choice {
    flex: 1; font-family: var(--display); font-weight: 800; font-size: 15px;
    border-radius: 100px; padding: 11px 0; border: 2px solid var(--line-strong);
    background: transparent; color: var(--ink);
  }
  .quiz-choice.for-c { border-color: var(--for); color: var(--for); }
  .quiz-choice.while-c { border-color: var(--while); color: var(--while); }
  .quiz-choice:disabled { opacity: 0.55; }
  .quiz-feedback { margin-top: 12px; font-size: 14.5px; min-height: 20px; }
  .quiz-feedback.correct { color: var(--success); }
  .quiz-feedback.wrong { color: var(--danger); }

  /* ---------- FLIP CARDS ---------- */

  .flip-grid { margin-top: 30px; display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
  @media (max-width: 600px) { .flip-grid { grid-template-columns: 1fr; } }
  .flip-card { perspective: 1000px; height: 150px; cursor: pointer; }
  .flip-inner {
    position: relative; width: 100%; height: 100%;
    transform-style: preserve-3d; transition: transform 0.5s cubic-bezier(.4,.2,.2,1);
  }
  .flip-card.flipped .flip-inner { transform: rotateY(180deg); }
  .flip-front, .flip-back {
    position: absolute; inset: 0; backface-visibility: hidden;
    border-radius: 16px; display: flex; align-items: center; justify-content: center;
    flex-direction: column; gap: 6px; border: 1px solid var(--line);
  }
  .flip-front { background: var(--bg-panel); }
  .flip-front .flip-label { font-family: var(--display); font-weight: 800; font-size: 22px; }
  .flip-front.for-c .flip-label { color: var(--for); }
  .flip-front.while-c .flip-label { color: var(--while); }
  .flip-front .flip-hint { font-size: 13px; color: var(--ink-faint); }
  .flip-back {
    background: var(--bg-panel-2); transform: rotateY(180deg);
    font-family: var(--mono); font-size: 14px; direction: ltr; text-align: left;
    padding: 18px; line-height: 1.7; white-space: pre;
  }

  /* ---------- NAME BAR (top) ---------- */

  .name-bar {
    background: var(--bg-panel);
    border-bottom: 1px solid var(--line);
    padding: 14px 0;
  }
  .name-bar-inner {
    display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
  }
  .name-bar-inner label { font-size: 13.5px; color: var(--ink-dim); flex-shrink: 0; }
  .name-bar-input {
    flex: 1; min-width: 160px; max-width: 260px;
    font-family: var(--sans); font-size: 15px;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong);
    border-radius: 10px; color: var(--ink); padding: 9px 12px;
  }
  .name-bar-input:focus { outline: none; border-color: var(--for); }
  .name-bar-jump {
    margin-inline-start: auto;
    font-family: var(--display); font-weight: 700; font-size: 13.5px;
    color: var(--for); text-decoration: none; background: transparent;
    border: 1px solid var(--for); border-radius: 100px; padding: 8px 16px;
    white-space: nowrap; cursor: pointer;
  }
  .name-bar-jump:hover { background: var(--for-soft); }

  /* ---------- EXERCISES BANNER ---------- */

  .exercises-banner {
    margin-bottom: 8px;
    background: linear-gradient(135deg, var(--for-soft), var(--while-soft));
    border: 1px solid var(--line-strong);
    border-radius: var(--radius);
    padding: 24px 26px;
  }
  .exercises-banner .badge {
    display: inline-block; font-family: var(--mono); font-size: 12.5px; font-weight: 700;
    color: var(--bg); background: var(--for); border-radius: 100px; padding: 4px 12px; margin-bottom: 10px;
  }
  .exercises-banner h2 { font-size: clamp(1.7rem, 4.5vw, 2.3rem); }
  .exercises-banner p { margin-top: 10px; font-size: 16px; color: var(--ink); }

  /* ---------- DIFF GAME ---------- */

  .diff-tabs { display: flex; gap: 8px; margin-top: 26px; margin-bottom: 22px; }
  .diff-tab {
    font-family: var(--display); font-weight: 800; font-size: 14px;
    padding: 9px 22px; border-radius: 100px; border: 2px solid var(--line-strong);
    background: transparent; color: var(--ink-dim); cursor: pointer;
  }
  .diff-tab.for-c.active { border-color: var(--for); color: var(--for); background: var(--for-soft); }
  .diff-tab.while-c.active { border-color: var(--while); color: var(--while); background: var(--while-soft); }
  .solo-code { max-width: 420px; }
  .diff-counter {
    margin-top: 18px; display: flex; align-items: center; gap: 12px; flex-wrap: wrap;
  }
  .diff-counter label { font-size: 14.5px; font-weight: 600; color: var(--ink); }
  .diff-counter input[type="number"] {
    width: 60px; font-family: var(--mono); font-size: 16px; text-align: center;
    background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px;
    color: var(--ink); padding: 8px 10px;
  }
  .diff-remaining { font-size: 14.5px; font-weight: 700; color: var(--ink-dim); }
  .diff-remaining.done { color: var(--success); }
  .reveal-btn {
    margin-top: 18px;
    font-family: var(--sans); font-weight: 600; font-size: 14px;
    background: transparent; color: var(--ink-faint);
    border: 1px dashed var(--line-strong); border-radius: 8px; padding: 9px 16px;
    cursor: pointer;
  }
  .reveal-btn:hover { color: var(--ink); border-color: var(--ink-dim); }
  .diff-answer {
    margin-top: 14px; font-size: 14.5px; color: var(--ink-dim);
    background: var(--bg-panel); border: 1px solid var(--line); border-radius: 12px;
    padding: 14px 18px;
  }
  .diff-answer-row { display: flex; align-items: flex-start; gap: 10px; padding: 6px 0; }
  .diff-num-badge {
    flex-shrink: 0; display: flex; align-items: center; justify-content: center;
    width: 20px; height: 20px; border-radius: 50%;
    background: var(--for-soft); color: var(--for);
    font-family: var(--mono); font-size: 12px; font-weight: 700;
  }
  .diff-answer.while-accent .diff-num-badge { background: var(--while-soft); color: var(--while); }

  /* ---------- CERTIFICATE ---------- */

  .certificate-box {
    margin-top: 30px;
    background: var(--bg-panel);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    padding: 26px 26px 22px;
    display: flex;
    align-items: center;
    gap: 14px;
    flex-wrap: wrap;
  }
  .cert-name-display { font-size: 15px; color: var(--ink-dim); }
  .cert-name-display strong { color: var(--for); }
  .cert-status { width: 100%; margin: 0; font-size: 14.5px; color: var(--ink-dim); }
  .cert-status.correct { color: var(--success); }
  .cert-status.wrong { color: var(--danger); }
  .cert-fallback { margin-top: 16px; }
  .cert-fallback-note { font-size: 13.5px; color: var(--ink-faint); margin: 0 0 10px; }
  .cert-fallback-text {
    width: 100%; direction: ltr; text-align: left;
    font-family: var(--mono); font-size: 12px; line-height: 1.6;
    background: rgba(0,0,0,0.25); border: 1px solid var(--line-strong); border-radius: 10px;
    color: var(--ink-dim); padding: 12px 14px;
  }

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
    <div class="eyebrow" style="justify-content:center; display:flex;">שיעור שלישי · פייתון · מגמת מחשבים</div>
    <h1>איך גורמים למחשב<br>לעשות משהו <span class="accent-for">שוב</span> <span class="accent-while">ושוב</span>?</h1>
    <p class="hero-sub">אתן כבר יודעות מה זה משתנה, ומה זה if. עכשיו נלמד איך לחסוך המון הקלדה — עם שני כלים חדשים: for ו-while.</p>

    <div class="teaser">
      <p>קודם, ניסוי קטן. תלחצי על הכפתור <strong>10 פעמים</strong> ברצף.</p>
      <button class="big-btn" id="teaser-btn" type="button">⭐ לחצי כאן</button>
      <div class="teaser-count" id="teaser-count">0 / 10</div>
      <div class="teaser-result" id="teaser-result">מרגיש קצת מייגע ללחוץ 10 פעמים ביד? עכשיו תדמייני שהיינו צריכות לעשות את זה 1,000 פעמים בקוד — שורה-שורה. בדיוק בשביל זה קיימות לולאות.</div>
    </div>
  </div>
</header>

<main>

  <section id="diff-game">
    <div class="wrap">
      <div class="eyebrow">לפני שמתחילים</div>
      <h2 class="section-title">מה שונה כאן לעומת Java?</h2>
      <p class="lede">תסתכלו בקוד הפייתון למטה, ותגידו בקול רם: מה שונה כאן לעומת מה שאתן מכירות מ-Java?</p>

      <div class="diff-tabs">
        <button class="diff-tab active for-c" data-round="for" type="button">for</button>
        <button class="diff-tab while-c" data-round="while" type="button">while</button>
      </div>

      <div class="diff-round" data-round="for">
        <div class="code-card for-accent solo-code">
          <div class="code-card-label">Python</div>
          <pre><code>for i in range(5):
    print(i)</code></pre>
        </div>
        <div class="diff-counter">
          <label for="diff-count-for">כמה שינויים מצאתם עד עכשיו?</label>
          <input type="number" id="diff-count-for" min="0" max="5" value="0">
          <span class="diff-remaining" id="diff-remaining-for"></span>
        </div>
        <button class="reveal-btn" data-target="diff-answer-for" type="button">הצג תשובה (למורה)</button>
        <div class="diff-answer" id="diff-answer-for" hidden>
          <div class="diff-answer-row"><span class="diff-num-badge">1</span><span>אין הכרזת טיפוס למשתנה הלולאה.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">2</span><span>אין נקודה-פסיק בין שלושת חלקי הלולאה.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">3</span><span>אין i++ בסוף — ה-for מתקדם לבד לאיבר הבא.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">4</span><span>אין סוגריים מסביב לתנאי כולו.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">5</span><span>אין סוגריים מסולסלים — ההזחה מסמנת איפה גוף הלולאה מתחיל ונגמר.</span></div>
        </div>
      </div>

      <div class="diff-round" data-round="while" hidden>
        <div class="code-card while-accent solo-code">
          <div class="code-card-label">Python</div>
          <pre><code>count = 5
while count > 0:
    print(count)
    count = count - 1</code></pre>
        </div>
        <div class="diff-counter">
          <label for="diff-count-while">כמה שינויים מצאתם עד עכשיו?</label>
          <input type="number" id="diff-count-while" min="0" max="5" value="0">
          <span class="diff-remaining" id="diff-remaining-while"></span>
        </div>
        <button class="reveal-btn" data-target="diff-answer-while" type="button">הצג תשובה (למורה)</button>
        <div class="diff-answer while-accent" id="diff-answer-while" hidden>
          <div class="diff-answer-row"><span class="diff-num-badge">1</span><span>אין הכרזת טיפוס למשתנה.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">2</span><span>אין נקודה-פסיק בסוף כל שורה.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">3</span><span>אין סוגריים מסביב לתנאי.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">4</span><span>אין סוגריים מסולסלים פותחים.</span></div>
          <div class="diff-answer-row"><span class="diff-num-badge">5</span><span>אין סוגריים מסולסלים סוגרים — ההזחה מסמנת איפה גוף הלולאה נגמר.</span></div>
        </div>
      </div>
    </div>
  </section>

  <section id="problem">
    <div class="wrap">
      <div class="eyebrow">הבעיה</div>
      <h2 class="section-title">בלי לולאה, כל חזרה = שורה חדשה</h2>
      <p class="lede">נניח שרוצים להדפיס "בוקר טוב!" חמש פעמים. בלי לולאה, צריך להקליד את אותה שורה חמש פעמים בדיוק. עם לולאה — מספיק להגיד לפייתון "תעשי את זה 5 פעמים", ולתת לה לדאוג לשאר.</p>

      <div class="contrast">
        <div class="code-card">
          <div class="code-card-label">בלי לולאה — מעייף ומועד לטעויות</div>
          <pre><code><span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)
<span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)
<span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)
<span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)
<span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)</code></pre>
        </div>
        <div class="contrast-arrow">=</div>
        <div class="code-card for-accent">
          <div class="code-card-label">עם for — אותה תוצאה</div>
          <pre><code><span class="tok-kw">for</span> i <span class="tok-kw">in</span> <span class="tok-fn">range</span>(<span class="tok-num">5</span>):
    <span class="tok-fn">print</span>(<span class="tok-str">"בוקר טוב!"</span>)</code></pre>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= FOR PLAYGROUND ================= -->

  <section id="for-loop">
    <div class="wrap">
      <div class="eyebrow for-c">for</div>
      <h2 class="section-title">for — "תעשי את זה N פעמים"</h2>
      <p class="lede"><span class="mono">range(N)</span> יוצר N מספרים: <span class="mono">0, 1, 2, ...</span> עד N-1. המשתנה <span class="mono">i</span> מקבל בכל סיבוב את המספר הבא, וגוף הלולאה רץ פעם אחת עבור כל אחד מהם. שחקו עם המחוון ולחצו "הריצי" כדי לראות את זה קורה בזמן אמת.</p>

      <div class="range-explainer">
        <p class="range-intro">יש ל-range() כמה צורות — נסו את כל השלוש ותראו איך הן משנות את המספרים שמתקבלים.</p>
        <div class="range-tabs" id="range-tabs">
          <button class="range-tab active" data-mode="stop" type="button">range(עצירה)</button>
          <button class="range-tab" data-mode="start-stop" type="button">range(התחלה, עצירה)</button>
          <button class="range-tab" data-mode="step" type="button">range(התחלה, עצירה, קפיצה)</button>
        </div>
        <div class="range-explainer-head" id="range-inputs-row"></div>
        <div class="range-line" id="range-line"></div>
        <p class="range-note" id="range-note"></p>
      </div>

      <div class="playground">
        <div class="playground-controls">
          <label for="range-slider">כמה פעמים?</label>
          <div class="slider-row">
            <input type="range" id="range-slider" min="1" max="10" value="5">
            <span class="slider-val" id="range-val">5</span>
          </div>
          <button class="run-btn" id="run-btn" type="button">▸ הריצי</button>
        </div>
        <div class="playground-code" id="for-code">
          <div class="line" data-line="0">for i in range(<span id="code-n">5</span>):</div>
          <div class="line" data-line="1">&nbsp;&nbsp;&nbsp;&nbsp;print(i)</div>
        </div>
        <div class="stage" id="star-stage"></div>
        <div class="guess-row">
          <span style="font-size:14.5px; font-weight:600;">נחשי לפני שמריצות: כמה כוכבים יופיעו?</span>
          <input type="number" id="guess-input" min="0" max="99">
          <button class="guess-btn" id="guess-btn" type="button">בדקי</button>
          <span class="guess-feedback" id="guess-feedback"></span>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= WHILE BALLOON GAME ================= -->

  <section id="while-loop">
    <div class="wrap">
      <div class="eyebrow while-c">while</div>
      <h2 class="section-title">while — "כל עוד זה נכון, תמשיכי"</h2>
      <p class="lede">בלולאת while, פייתון בודקת תנאי (בדיוק כמו ב-if!) — אבל בכל פעם שגוף הלולאה מסתיים, היא חוזרת ובודקת שוב. את זו שצריכה לדאוג שהתנאי בסוף יפסיק להיות נכון — אחרת הלולאה לא תיעצר לעולם. נפחו בלון וגלו את זה בעצמכן.</p>

      <div class="balloon-game">
        <div class="balloon-body">
          <div class="balloon-stage">
            <div class="balloon" id="balloon"></div>
          </div>
          <div class="balloon-side">
            <h4>מה קורה בקוד:</h4>
            <div class="balloon-code" id="while-code">
              <div class="line" data-line="0">air = 0</div>
              <div class="line" data-line="1">while air < 10:</div>
              <div class="line" data-line="2">&nbsp;&nbsp;&nbsp;&nbsp;air = air + 1</div>
              <div class="line" data-line="3">print("בום!")</div>
            </div>
            <div class="balloon-var"><span class="k">air =</span> <span class="v" id="air-val">0</span></div>
            <div class="balloon-buttons">
              <button class="primary" id="pump-btn" type="button">נפחי סיבוב אחד</button>
              <button id="auto-btn" type="button">תני ל-while לרוץ לבד</button>
              <button id="balloon-reset" type="button">אפסי</button>
            </div>
            <div class="balloon-status" id="balloon-status">air &lt; 10 עדיין נכון — התנאי מאפשר עוד סיבוב.</div>
          </div>
        </div>
      </div>

      <div class="rescue" id="rescue">
        <div class="rescue-head">
          <div class="spinner"></div>
          <div class="rescue-check">✓</div>
          <h4 id="rescue-title">הקוד הזה תקוע בלולאה אינסופית. מוצאות את הבאג?</h4>
        </div>
        <pre id="rescue-code">air = 0
while air &lt; 10:
    print("מנפחת...")</pre>
        <div class="rescue-choices" id="rescue-choices">
          <button class="rescue-choice" data-correct="true">שכחו לעדכן את air בתוך הלולאה — התנאי נשאר נכון לנצח</button>
          <button class="rescue-choice" data-correct="false">יש יותר מדי הדפסות בתוך הלולאה</button>
        </div>
        <div class="rescue-feedback" id="rescue-feedback"></div>
      </div>
    </div>
  </section>

  <!-- ================= EXERCISES ================= -->

  <section id="exercises">
    <div class="wrap">
      <div class="exercises-banner">
        <span class="badge">👇 מפה זה עלייך</span>
        <h2 class="section-title">התרגילים שלכן</h2>
        <p>שישה תרגילים — ארבעה עם בדיקה מיידית, ושניים שכותבים בעורך הפייתון ומדביקים כאן. בסוף מורידות קובץ עם כל התוצאות.</p>
      </div>
      <p class="lede" style="margin-top:22px;">משלימות את החסר בקוד, לוחצות "בדקי", ורואות מיד אם זה עובד — בדיוק כמו בפייתון האמיתית.</p>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 1 · for</div>
        <p class="exercise-task">total מתחיל ב-0, ובכל סיבוב מוסיפים אליו את i. איזה N ב-range(N) יגרום ל-total הסופי להיות בדיוק 45?</p>
        <div class="exercise-code">total = 0<br>for i in range(<input type="number" id="ex1-n" min="0" max="40">):<br>&nbsp;&nbsp;&nbsp;&nbsp;total = total + i<br>print(total)</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex1-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex1-feedback"></span>
        </div>
        <div class="exercise-output" id="ex1-output"></div>
      </div>

      <div class="exercise-card for-accent">
        <div class="exercise-num">תרגיל 2 · for</div>
        <p class="exercise-task">כתבו קוד שמדפיס בדיוק: 5 9 13 17 21</p>
        <div class="exercise-code">for i in range(<input type="number" id="ex2-start" min="0" max="40">, <input type="number" id="ex2-stop" min="0" max="40">, <input type="number" id="ex2-step" min="1" max="10">):<br>&nbsp;&nbsp;&nbsp;&nbsp;print(i)</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex2-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex2-feedback"></span>
        </div>
        <div class="exercise-output" id="ex2-output"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 3 · while</div>
        <p class="exercise-task">count מתחיל ב-1 ומוכפל פי 2 בכל סיבוב. השלימו את התנאי כך שיודפס בדיוק: 1 2 4 8 16 (ולא 32)</p>
        <div class="exercise-code">count = 1<br>while count <= <input type="number" id="ex3-limit" min="0" max="100">:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(count)<br>&nbsp;&nbsp;&nbsp;&nbsp;count = count * 2</div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="ex3-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex3-feedback"></span>
        </div>
        <div class="exercise-output" id="ex3-output"></div>
      </div>

      <div class="exercise-card while-accent">
        <div class="exercise-num">תרגיל 4 · while</div>
        <p class="exercise-task">בקוד הזה, count מתחיל ב-100 ויורד ב-7 בכל סיבוב, כל עוד הוא גדול מ-0. בלי להריץ — כמה פעמים ידפיס הקוד מספר?</p>
        <div class="exercise-code">count = 100<br>while count &gt; 0:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(count)<br>&nbsp;&nbsp;&nbsp;&nbsp;count = count - 7</div>
        <div class="exercise-controls">
          <span style="font-size:14.5px; font-weight:600;">הניחוש שלי:</span>
          <input type="number" id="ex4-guess" min="0" max="40">
          <button class="exercise-check-btn" id="ex4-check" type="button">בדקי</button>
          <span class="exercise-feedback" id="ex4-feedback"></span>
        </div>
        <div class="exercise-output" id="ex4-output"></div>
      </div>
      <div class="exercise-divider">
        <span>כתיבה אישית — פותרות בעורך הפייתון שלכן, לא כאן</span>
      </div>

      <div class="exercise-card for-accent open-exercise">
        <div class="exercise-num">תרגיל 5 · for · כתיבה חופשית</div>
        <p class="exercise-task">כתבו קוד עם לולאת for שרצה בדיוק 3 פעמים. בכל סיבוב (לפי הערך של i) תדפיסי שם של חג שאת אוהבת, ומשפט קצר על מה היה הכי כיף לך בו. אפשר להיעזר ב-if בתוך הלולאה כדי להדפיס דבר שונה בכל סיבוב.</p>
        <div class="exercise-hint">רמז לפתיחה:<br>for i in range(3):<br>&nbsp;&nbsp;&nbsp;&nbsp;if i == 0:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;print("...")<br>&nbsp;&nbsp;&nbsp;&nbsp;elif i == 1:<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;print("...")</div>
        <p class="exercise-note">✍️ כתבו ושמרו את הפתרון בעורך הפייתון שלכן, ואז הדביקו אותו כאן:</p>
        <textarea class="exercise-answer" id="ex5-answer" rows="6" placeholder="# הדביקו כאן את הקוד שכתבתן..."></textarea>
      </div>

      <div class="exercise-card while-accent open-exercise">
        <div class="exercise-num">תרגיל 6 · while · כתיבה חופשית</div>
        <p class="exercise-task">כתבו לולאת while שסופרת לאחור כמה ימים נשארו עד החג האהוב עלייך (למשל מתחילים ב-10 ויורדים ב-1 בכל סיבוב), ומדפיסה בכל סיבוב כמה ימים נשארו. כשהלולאה נגמרת, תדפיסי משפט אחד על מה הכי כיף לך בחג הזה.</p>
        <div class="exercise-hint">רמז לפתיחה:<br>days_left = 10<br>while days_left > 0:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(days_left, "ימים עד החג!")<br>&nbsp;&nbsp;&nbsp;&nbsp;days_left = days_left - 1</div>
        <p class="exercise-note">✍️ כתבו ושמרו את הפתרון בעורך הפייתון שלכן, ואז הדביקו אותו כאן:</p>
        <textarea class="exercise-answer" id="ex6-answer" rows="6" placeholder="# הדביקו כאן את הקוד שכתבתן..."></textarea>
      </div>
    </div>
  </section>

  <!-- ================= CODE DETECTIVE CHALLENGE ================= -->

  <section id="detective">
    <div class="wrap">
      <div class="eyebrow for-c">אתגר</div>
      <h2 class="section-title">בלש הקוד</h2>
      <p class="lede">הפעם הפוך: רואות את הפלט, וצריכות לגלות אילו מספרים היו חייבים להיות בקוד כדי לקבל אותו.</p>

      <div class="detective-card">
        <div class="detective-head">
          <span class="detective-progress" id="det-progress">סיבוב 1 מתוך 4</span>
        </div>
        <p class="detective-task" id="det-task"></p>
        <div class="detective-output" id="det-output"></div>
        <div class="detective-code" id="det-code"></div>
        <div class="exercise-controls">
          <button class="exercise-check-btn" id="det-check" type="button">בדקי</button>
          <button class="run-btn" id="det-next" type="button" style="display:none;">הסיבוב הבא ▸</button>
          <span class="exercise-feedback" id="det-feedback"></span>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= QUICK-FIRE QUIZ ================= -->

  <section id="quiz">
    <div class="wrap">
      <div class="eyebrow">בדיקה מהירה</div>
      <h2 class="section-title">for או while?</h2>
      <p class="lede">לכל תרחיש — בחרו בכלי הנכון. אין באג, אין תשובה מסתתרת, רק תחושת בטן שתתחדד עם התרגול.</p>

      <div id="quiz-container"></div>
    </div>
  </section>

  <!-- ================= FLIP CARDS ================= -->

  <section id="wrapup">
    <div class="wrap">
      <div class="eyebrow">לסיכום</div>
      <h2 class="section-title">שני הכלים, בקצרה</h2>
      <p class="lede">לחצו על כרטיס כדי לראות את התחביר.</p>
      <div class="flip-grid">
        <div class="flip-card" id="card-for">
          <div class="flip-inner">
            <div class="flip-front for-c">
              <div class="flip-label">for</div>
              <div class="flip-hint">יודעת בדיוק כמה פעמים</div>
            </div>
            <div class="flip-back">for i in range(5):
    print(i)</div>
          </div>
        </div>
        <div class="flip-card" id="card-while">
          <div class="flip-inner">
            <div class="flip-front while-c">
              <div class="flip-label">while</div>
              <div class="flip-hint">ממתינה לתנאי שישתנה</div>
            </div>
            <div class="flip-back">air = 0
while air &lt; 10:
    air = air + 1</div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= CERTIFICATE / DOWNLOAD ================= -->

  <section id="certificate">
    <div class="wrap">
      <div class="eyebrow">לסיום</div>
      <h2 class="section-title">שלחו לי את התוצאות</h2>
      <p class="lede">לוחצות על הכפתור — יורד קובץ HTML מעוצב עם סיכום מה שפתרתן, כולל הקוד שהדבקתן בתרגילים 5-6, כדי שאוכל לבדוק.</p>
      <div class="certificate-box">
        <span class="cert-name-display">מורידה עבור: <strong id="cert-name-display">—</strong></span>
        <button class="run-btn" id="cert-download" type="button">⬇️ הורידי קובץ תוצאות</button>
        <p class="cert-status" id="cert-status"></p>
      </div>
      <div class="cert-fallback" id="cert-fallback" hidden>
        <p class="cert-fallback-note">ההורדה האוטומטית לא זמינה כאן. סמנו הכול בתיבה למטה (Ctrl+A / Cmd+A), העתיקו, הדביקו לקובץ טקסט חדש ושמרו אותו בסיומת .html:</p>
        <textarea class="cert-fallback-text" id="cert-fallback-text" readonly rows="8"></textarea>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">שיעור פייתון · for ו-while</div></footer>

<script>
window.lessonProgress = { name: "", ex1: false, ex2: false, ex3: false, ex4: false, detectiveSolved: 0, detectiveTotal: 0, quizCorrect: 0, quizTotal: 0 };

/* ---------- diff comparison tabs ---------- */
(function () {
  var tabs = document.querySelectorAll(".diff-tab");
  var rounds = document.querySelectorAll(".diff-round");

  tabs.forEach(function (tab) {
    tab.addEventListener("click", function () {
      tabs.forEach(function (t) { t.classList.remove("active"); });
      tab.classList.add("active");
      rounds.forEach(function (r) { r.hidden = r.dataset.round !== tab.dataset.round; });
    });
  });

  document.querySelectorAll(".reveal-btn").forEach(function (btn) {
    btn.addEventListener("click", function () {
      var target = document.getElementById(btn.dataset.target);
      var showing = !target.hidden;
      target.hidden = showing;
      btn.textContent = showing ? "הצג תשובה (למורה)" : "הסתר תשובה";
    });
  });

  var totals = { for: 5, while: 5 };
  Object.keys(totals).forEach(function (key) {
    var input = document.getElementById("diff-count-" + key);
    var remainingEl = document.getElementById("diff-remaining-" + key);
    var total = totals[key];

    function update() {
      var found = parseInt(input.value, 10);
      if (isNaN(found) || found < 0) found = 0;
      if (found > total) found = total;
      var left = total - found;
      if (left <= 0) {
        remainingEl.textContent = "מצאתם את כולם! 🎉";
        remainingEl.className = "diff-remaining done";
      } else {
        remainingEl.textContent = "נשארו עוד " + left + " להגיד.";
        remainingEl.className = "diff-remaining";
      }
    }
    input.addEventListener("input", update);
    update();
  });
})();

/* ---------- jump to exercises ---------- */
(function () {
  var btn = document.getElementById("jump-to-exercises");
  var target = document.getElementById("exercises");
  if (btn && target) {
    btn.addEventListener("click", function () {
      target.scrollIntoView({ behavior: "smooth", block: "start" });
    });
  }
})();

/* ---------- hero clicker teaser ---------- */
(function () {
  var btn = document.getElementById("teaser-btn");
  var countEl = document.getElementById("teaser-count");
  var resultEl = document.getElementById("teaser-result");
  var n = 0;
  btn.addEventListener("click", function (e) {
    if (n >= 10) return;
    n++;
    countEl.textContent = n + " / 10";
    var spark = document.createElement("span");
    spark.className = "spark";
    spark.textContent = "✨";
    var rect = btn.getBoundingClientRect();
    var parentRect = btn.parentElement.getBoundingClientRect();
    spark.style.left = (rect.left - parentRect.left + rect.width / 2 - 7) + "px";
    spark.style.top = (rect.top - parentRect.top - 6) + "px";
    btn.parentElement.appendChild(spark);
    setTimeout(function () { spark.remove(); }, 700);
    if (n === 10) {
      resultEl.classList.add("show");
      btn.disabled = true;
      btn.style.opacity = "0.5";
    }
  });
})();

/* ---------- range() explainer (3 forms) ---------- */
(function () {
  var tabs = document.querySelectorAll(".range-tab");
  var inputsRow = document.getElementById("range-inputs-row");
  var lineEl = document.getElementById("range-line");
  var noteEl = document.getElementById("range-note");
  var mode = "stop";

  var state = {
    stop: 5,
    start: 2, stop2: 7,
    start3: 0, stop3: 10, step3: 2
  };

  function clampBoxes(list) {
    lineEl.innerHTML = "";
    list.forEach(function (b) {
      var box = document.createElement("div");
      box.className = "range-box " + b.cls;
      box.textContent = b.val;
      lineEl.appendChild(box);
    });
  }

  function renderStop() {
    var n = Math.max(1, Math.min(12, state.stop));
    var boxes = [];
    for (var i = 0; i < n; i++) boxes.push({ val: i, cls: "included" });
    boxes.push({ val: n, cls: "excluded" });
    clampBoxes(boxes);
    noteEl.innerHTML = "range(" + n + ") נותן <strong>" + n + " מספרים</strong>: 0 עד " + (n - 1) + ". המספר " + n + " עצמו (אדום) רק מסמן איפה עוצרים — הוא <strong>לא</strong> נכלל.";
  }

  function renderStartStop() {
    var start = Math.max(0, Math.min(10, state.start));
    var stop = Math.max(start + 1, Math.min(12, state.stop2));
    var boxes = [];
    for (var i = 0; i < start; i++) boxes.push({ val: i, cls: "skipped" });
    for (var i2 = start; i2 < stop; i2++) boxes.push({ val: i2, cls: "included" });
    boxes.push({ val: stop, cls: "excluded" });
    clampBoxes(boxes);
    noteEl.innerHTML = "range(" + start + ", " + stop + ") <strong>מתחילה לספור מ-" + start + "</strong> במקום מ-0, ועוצרת לפני " + stop + ". המספרים האפורים בהתחלה — פשוט לא חלק מהתוצאה.";
  }

  function renderStep() {
    var start = Math.max(0, Math.min(10, state.start3));
    var stop = Math.max(start + 1, Math.min(16, state.stop3));
    var step = Math.max(1, Math.min(5, state.step3));
    var boxes = [];
    var included = {};
    for (var v = start; v < stop; v += step) included[v] = true;
    for (var i = 0; i < stop; i++) {
      boxes.push({ val: i, cls: included[i] ? "included" : "skipped" });
    }
    boxes.push({ val: stop, cls: "excluded" });
    clampBoxes(boxes);
    noteEl.innerHTML = "range(" + start + ", " + stop + ", " + step + ") מתחילה ב-" + start + ", <strong>מוסיפה " + step + " בכל סיבוב</strong>, ועוצרת לפני " + stop + ". כל מה שלא במקפצה — נשאר אפור.";
  }

  function buildInputsRow() {
    if (mode === "stop") {
      inputsRow.innerHTML = ''range(<input type="number" id="ri-stop" min="1" max="12" value="'' + state.stop + ''">)'';
    } else if (mode === "start-stop") {
      inputsRow.innerHTML = ''range(<input type="number" id="ri-start" min="0" max="10" value="'' + state.start + ''">, <input type="number" id="ri-stop2" min="1" max="12" value="'' + state.stop2 + ''">)'';
    } else {
      inputsRow.innerHTML = ''range(<input type="number" id="ri-start3" min="0" max="10" value="'' + state.start3 + ''">, <input type="number" id="ri-stop3" min="1" max="16" value="'' + state.stop3 + ''">, <input type="number" id="ri-step3" min="1" max="5" value="'' + state.step3 + ''">)'';
    }
    inputsRow.querySelectorAll("input").forEach(function (inp) {
      inp.addEventListener("input", function () {
        if (mode === "stop") state.stop = parseInt(document.getElementById("ri-stop").value, 10) || 1;
        else if (mode === "start-stop") {
          state.start = parseInt(document.getElementById("ri-start").value, 10) || 0;
          state.stop2 = parseInt(document.getElementById("ri-stop2").value, 10) || 1;
        } else {
          state.start3 = parseInt(document.getElementById("ri-start3").value, 10) || 0;
          state.stop3 = parseInt(document.getElementById("ri-stop3").value, 10) || 1;
          state.step3 = parseInt(document.getElementById("ri-step3").value, 10) || 1;
        }
        render();
      });
    });
  }

  function render() {
    if (mode === "stop") renderStop();
    else if (mode === "start-stop") renderStartStop();
    else renderStep();
  }

  tabs.forEach(function (tab) {
    tab.addEventListener("click", function () {
      tabs.forEach(function (t) { t.classList.remove("active"); });
      tab.classList.add("active");
      mode = tab.dataset.mode;
      buildInputsRow();
      render();
    });
  });

  buildInputsRow();
  render();
})();

/* ---------- for playground ---------- */
(function () {
  var slider = document.getElementById("range-slider");
  var valEl = document.getElementById("range-val");
  var codeN = document.getElementById("code-n");
  var runBtn = document.getElementById("run-btn");
  var stage = document.getElementById("star-stage");
  var lines = document.querySelectorAll("#for-code .line");
  var guessInput = document.getElementById("guess-input");
  var guessBtn = document.getElementById("guess-btn");
  var guessFeedback = document.getElementById("guess-feedback");
  var running = false;

  slider.addEventListener("input", function () {
    valEl.textContent = slider.value;
    codeN.textContent = slider.value;
  });

  function clearActive() { lines.forEach(function (l) { l.classList.remove("active"); }); }

  runBtn.addEventListener("click", function () {
    if (running) return;
    running = true;
    runBtn.disabled = true;
    stage.innerHTML = "";
    var n = parseInt(slider.value, 10);
    var i = 0;
    lines[0].classList.add("active");
    function step() {
      if (i >= n) {
        clearActive();
        running = false;
        runBtn.disabled = false;
        return;
      }
      clearActive();
      lines[0].classList.add("active");
      setTimeout(function () {
        clearActive();
        lines[1].classList.add("active");
        var star = document.createElement("div");
        star.className = "star";
        star.innerHTML = ''<span class="icon">⭐</span><span class="i-val">i='' + i + "</span>";
        stage.appendChild(star);
        i++;
        setTimeout(step, 220);
      }, 160);
    }
    step();
  });

  guessBtn.addEventListener("click", function () {
    var guess = parseInt(guessInput.value, 10);
    var n = parseInt(slider.value, 10);
    if (isNaN(guess)) return;
    if (guess === n) {
      guessFeedback.textContent = "נכון! range(" + n + ") נותן בדיוק " + n + " מספרים.";
      guessFeedback.className = "guess-feedback correct";
    } else {
      guessFeedback.textContent = "לא בדיוק — range(" + n + ") נותן " + n + " מספרים (0 עד " + (n - 1) + "), לחצי הריצי לראות.";
      guessFeedback.className = "guess-feedback wrong";
    }
  });
})();

/* ---------- while balloon game ---------- */
(function () {
  var balloon = document.getElementById("balloon");
  var airVal = document.getElementById("air-val");
  var pumpBtn = document.getElementById("pump-btn");
  var autoBtn = document.getElementById("auto-btn");
  var resetBtn = document.getElementById("balloon-reset");
  var statusEl = document.getElementById("balloon-status");
  var lines = document.querySelectorAll("#while-code .line");
  var stage = document.querySelector(".balloon-stage");
  var air = 0;
  var max = 10;
  var popped = false;
  var autoRunning = false;

  function clearActive() { lines.forEach(function (l) { l.classList.remove("active"); }); }

  function confetti() {
    var colors = ["#FF5C8A", "#FFB84D", "#5CE1A6", "#7EC1F5"];
    for (var k = 0; k < 14; k++) {
      var piece = document.createElement("div");
      piece.className = "confetti-piece";
      piece.style.left = (35 + Math.random() * 30) + "%";
      piece.style.background = colors[k % colors.length];
      piece.style.animationDelay = (Math.random() * 0.15) + "s";
      stage.appendChild(piece);
      setTimeout(function (p) { return function () { p.remove(); }; }(piece), 1000);
    }
  }

  function render() {
    var scale = 1 + air * 0.09;
    balloon.style.transform = "scale(" + scale + ")";
    airVal.textContent = air;
    if (air < max) {
      clearActive();
      lines[1].classList.add("active");
      statusEl.textContent = "air < " + max + " (air = " + air + ") — עדיין נכון, אז יש עוד סיבוב.";
      statusEl.style.color = "";
    }
  }

  function pump() {
    if (popped) return;
    clearActive();
    lines[2].classList.add("active");
    air++;
    if (air >= max) {
      popped = true;
      balloon.style.setProperty("--s", (1 + (air - 1) * 0.09).toFixed(2));
      balloon.classList.add("popped");
      confetti();
      clearActive();
      lines[3].classList.add("active");
      statusEl.textContent = "air < " + max + " כבר לא נכון — התנאי נכשל, אז while עוצרת. print(\"בום!\") רץ אחרי הלולאה.";
      statusEl.style.color = "var(--success)";
      pumpBtn.disabled = true;
      autoBtn.disabled = true;
    } else {
      render();
    }
    airVal.textContent = air;
  }

  pumpBtn.addEventListener("click", pump);

  autoBtn.addEventListener("click", function () {
    if (autoRunning || popped) return;
    autoRunning = true;
    pumpBtn.disabled = true;
    autoBtn.disabled = true;
    function loop() {
      if (popped) { autoRunning = false; return; }
      pump();
      if (!popped) setTimeout(loop, 260);
      else { pumpBtn.disabled = true; autoBtn.disabled = true; }
    }
    loop();
  });

  resetBtn.addEventListener("click", function () {
    air = 0;
    popped = false;
    autoRunning = false;
    balloon.classList.remove("popped");
    balloon.style.transform = "scale(1)";
    pumpBtn.disabled = false;
    autoBtn.disabled = false;
    render();
  });

  render();
})();

/* ---------- infinite loop rescue ---------- */
(function () {
  var rescue = document.getElementById("rescue");
  var title = document.getElementById("rescue-title");
  var codeEl = document.getElementById("rescue-code");
  var choices = document.querySelectorAll(".rescue-choice");
  var feedback = document.getElementById("rescue-feedback");
  var solved = false;

  choices.forEach(function (btn) {
    btn.addEventListener("click", function () {
      if (solved) return;
      if (btn.dataset.correct === "true") {
        solved = true;
        rescue.classList.add("fixed");
        title.textContent = "יופי, תפסתן את זה! זו הגרסה המתוקנת:";
        codeEl.innerHTML = ''air = 0\nwhile air &lt; 10:\n    print("מנפחת...")\n    <span class="added">air = air + 1</span>'';
        feedback.textContent = "עכשיו air גדל בכל סיבוב, אז בסוף air < 10 יהיה לא נכון והלולאה תעצור.";
        feedback.className = "rescue-feedback correct";
        choices.forEach(function (c) { c.disabled = true; c.style.opacity = "0.5"; });
      } else {
        feedback.textContent = "לא זו הבעיה — כמות ההדפסות לא קשורה לזה שהלולאה נתקעת. נסי שוב.";
        feedback.className = "rescue-feedback wrong";
      }
    });
  });
})();

/* ---------- exercises ---------- */
(function () {
  function setFeedback(el, ok, text) {
    el.textContent = text;
    el.className = "exercise-feedback " + (ok ? "correct" : "wrong");
  }

  // Exercise 1: total = sum(0..n-1) — target total = 45 (n = 10)
  document.getElementById("ex1-check").addEventListener("click", function () {
    var n = parseInt(document.getElementById("ex1-n").value, 10);
    var outEl = document.getElementById("ex1-output");
    var fbEl = document.getElementById("ex1-feedback");
    if (isNaN(n) || n < 0) { setFeedback(fbEl, false, "שימי מספר תקין."); outEl.textContent = ""; return; }
    var total = 0;
    for (var i = 0; i < n; i++) total += i;
    outEl.textContent = "total = " + total;
    if (total === 45) { setFeedback(fbEl, true, "בדיוק 45!"); window.lessonProgress.ex1 = true; }
    else setFeedback(fbEl, false, "עם N = " + n + ", total יוצא " + total + ". רוצות 45.");
  });

  // Exercise 2: for i in range(start, stop, step): print(i) — target [5,9,13,17,21]
  document.getElementById("ex2-check").addEventListener("click", function () {
    var start = parseInt(document.getElementById("ex2-start").value, 10);
    var stop = parseInt(document.getElementById("ex2-stop").value, 10);
    var step = parseInt(document.getElementById("ex2-step").value, 10);
    var outEl = document.getElementById("ex2-output");
    var fbEl = document.getElementById("ex2-feedback");
    if (isNaN(start) || isNaN(stop) || isNaN(step) || step <= 0) { setFeedback(fbEl, false, "שימי שלושה מספרים תקינים (step חייב להיות חיובי)."); outEl.textContent = ""; return; }
    var result = [];
    for (var i = start; i < stop; i += step) result.push(i);
    outEl.textContent = result.join(" ");
    var target = [5, 9, 13, 17, 21];
    if (result.length === target.length && result.every(function (v, idx) { return v === target[idx]; })) {
      setFeedback(fbEl, true, "מדויק!");
      window.lessonProgress.ex2 = true;
    } else {
      setFeedback(fbEl, false, "זה נותן: " + (result.join(" ") || "כלום") + ". רוצות: 5 9 13 17 21.");
    }
  });

  // Exercise 3: while count <= limit: print(count); count *= 2 — target [1,2,4,8,16]
  document.getElementById("ex3-check").addEventListener("click", function () {
    var limit = parseInt(document.getElementById("ex3-limit").value, 10);
    var outEl = document.getElementById("ex3-output");
    var fbEl = document.getElementById("ex3-feedback");
    if (isNaN(limit)) { setFeedback(fbEl, false, "שימי מספר תקין."); outEl.textContent = ""; return; }
    var result = [];
    var count = 1, guard = 0;
    while (count <= limit && guard < 100) { result.push(count); count *= 2; guard++; }
    outEl.textContent = result.join(" ") || "(אין פלט)";
    var target = [1, 2, 4, 8, 16];
    if (result.length === target.length && result.every(function (v, idx) { return v === target[idx]; })) {
      setFeedback(fbEl, true, "יפה! כל סף בין 16 ל-31 עובד.");
      window.lessonProgress.ex3 = true;
    } else {
      setFeedback(fbEl, false, "זה נותן: " + (result.join(" ") || "כלום") + ". רוצות: 1 2 4 8 16.");
    }
  });

  // Exercise 4: predict iteration count of count=100, while count>0, count -= 7 — target 15
  document.getElementById("ex4-check").addEventListener("click", function () {
    var guess = parseInt(document.getElementById("ex4-guess").value, 10);
    var outEl = document.getElementById("ex4-output");
    var fbEl = document.getElementById("ex4-feedback");
    var result = [];
    var count = 100, guard = 0;
    while (count > 0 && guard < 100) { result.push(count); count -= 7; guard++; }
    if (isNaN(guess)) { setFeedback(fbEl, false, "שימי ניחוש תחילה."); outEl.textContent = ""; return; }
    outEl.textContent = result.join(" ");
    if (guess === result.length) {
      setFeedback(fbEl, true, "נכון! " + result.length + " פעמים.");
      window.lessonProgress.ex4 = true;
    } else {
      setFeedback(fbEl, false, "לא בדיוק — זה רץ " + result.length + " פעמים.");
    }
  });
})();

/* ---------- code detective challenge ---------- */
(function () {
  var rounds = [
    {
      task: "איזה N צריך לשים ב-range(N) כדי לקבל את הפלט הזה?",
      output: [0, 1, 2, 3, 4, 5, 6, 7],
      isFor: true,
      html: ''range(<input type="number" id="d-in-0" min="0" max="40">)'',
      ids: ["d-in-0"],
      simulate: function (v) {
        var n = v[0], out = [];
        if (isNaN(n) || n < 0) return null;
        for (var i = 0; i < n; i++) out.push(i);
        return out;
      }
    },
    {
      task: "הפעם עם שני ערכים — מה יהיו start ו-stop?",
      output: [12, 13, 14, 15, 16, 17],
      isFor: true,
      html: ''range(<input type="number" id="d-in-0" min="0" max="40">, <input type="number" id="d-in-1" min="0" max="40">)'',
      ids: ["d-in-0", "d-in-1"],
      simulate: function (v) {
        var s = v[0], e = v[1], out = [];
        if (isNaN(s) || isNaN(e)) return null;
        for (var i = s; i < e; i++) out.push(i);
        return out;
      }
    },
    {
      task: "עכשיו גם עם קפיצה — מה יהיו start, stop ו-step?",
      output: [1, 4, 7, 10, 13],
      isFor: true,
      html: ''range(<input type="number" id="d-in-0" min="0" max="40">, <input type="number" id="d-in-1" min="0" max="40">, <input type="number" id="d-in-2" min="1" max="10">)'',
      ids: ["d-in-0", "d-in-1", "d-in-2"],
      simulate: function (v) {
        var s = v[0], e = v[1], st = v[2], out = [];
        if (isNaN(s) || isNaN(e) || isNaN(st) || st <= 0) return null;
        for (var i = s; i < e; i += st) out.push(i);
        return out;
      }
    },
    {
      task: "הפעם זה while, ועם שני נעלמים — מאיזה מספר count מתחילים, ובכמה יורדים בכל סיבוב?",
      output: [20, 15, 10, 5],
      isFor: false,
      html: ''count = <input type="number" id="d-in-0" min="0" max="40"><br>while count &gt; 0:<br>&nbsp;&nbsp;&nbsp;&nbsp;print(count)<br>&nbsp;&nbsp;&nbsp;&nbsp;count = count - <input type="number" id="d-in-1" min="1" max="20">'',
      ids: ["d-in-0", "d-in-1"],
      simulate: function (v) {
        var c = v[0], step = v[1], out = [], guard = 0;
        if (isNaN(c) || isNaN(step) || step <= 0) return null;
        while (c > 0 && guard < 100) { out.push(c); c -= step; guard++; }
        return out;
      }
    },
    {
      task: "אתגר בונוס: total מתחיל ב-0 וצובר את count בכל סיבוב. איזה סף יגרום לתוצאה הסופית להיות בדיוק זו?",
      output: [55],
      isFor: false,
      html: ''total = 0<br>count = 1<br>while count &lt;= <input type="number" id="d-in-0" min="0" max="40">:<br>&nbsp;&nbsp;&nbsp;&nbsp;total = total + count<br>&nbsp;&nbsp;&nbsp;&nbsp;count = count + 1<br>print(total)'',
      ids: ["d-in-0"],
      simulate: function (v) {
        var limit = v[0];
        if (isNaN(limit)) return null;
        var total = 0, count = 1, guard = 0;
        while (count <= limit && guard < 200) { total += count; count++; guard++; }
        return [total];
      }
    }
  ];

  var idx = 0;
  window.lessonProgress.detectiveTotal = rounds.length;
  var progressEl = document.getElementById("det-progress");
  var taskEl = document.getElementById("det-task");
  var outputEl = document.getElementById("det-output");
  var codeEl = document.getElementById("det-code");
  var checkBtn = document.getElementById("det-check");
  var nextBtn = document.getElementById("det-next");
  var feedbackEl = document.getElementById("det-feedback");

  function arraysEqual(a, b) {
    if (!a || !b || a.length !== b.length) return false;
    return a.every(function (v, i) { return v === b[i]; });
  }

  function renderRound() {
    var r = rounds[idx];
    progressEl.textContent = "סיבוב " + (idx + 1) + " מתוך " + rounds.length;
    taskEl.textContent = r.task;
    outputEl.textContent = r.output.join("\n");
    codeEl.innerHTML = r.isFor ? ("for i in " + r.html + ":<br>&nbsp;&nbsp;&nbsp;&nbsp;print(i)") : r.html;
    feedbackEl.textContent = "";
    feedbackEl.className = "exercise-feedback";
    checkBtn.style.display = "";
    nextBtn.style.display = "none";
  }

  checkBtn.addEventListener("click", function () {
    var r = rounds[idx];
    var vals = r.ids.map(function (id) { return parseInt(document.getElementById(id).value, 10); });
    var result = r.simulate(vals);
    if (!result) {
      feedbackEl.textContent = "שימי מספרים בכל השדות.";
      feedbackEl.className = "exercise-feedback wrong";
      return;
    }
    if (arraysEqual(result, r.output)) {
      feedbackEl.textContent = "פתרתן! ✓";
      feedbackEl.className = "exercise-feedback correct";
      checkBtn.style.display = "none";
      window.lessonProgress.detectiveSolved = Math.max(window.lessonProgress.detectiveSolved, idx + 1);
      if (idx < rounds.length - 1) nextBtn.style.display = "";
      else nextBtn.style.display = "none";
      if (idx === rounds.length - 1) feedbackEl.textContent = "פתרתן את כל הבלש! 🕵️";
    } else {
      feedbackEl.textContent = "זה נותן: " + (result.join(", ") || "כלום") + " — נסי שוב.";
      feedbackEl.className = "exercise-feedback wrong";
    }
  });

  nextBtn.addEventListener("click", function () {
    idx++;
    renderRound();
  });

  renderRound();
})();

/* ---------- quick-fire quiz ---------- */
(function () {
  var scenarios = [
    { text: "להדפיס \"בוקר טוב\" בדיוק 5 פעמים.", answer: "for", why: "מספר החזרות ידוע מראש — for נועד בדיוק לזה." },
    { text: "להמשיך לשאול את המשתמש מספר, עד שהוא יזין מספר גדול מ-0.", answer: "while", why: "לא ידוע מראש כמה פעמים המשתמש יטעה — תלוי בתנאי." },
    { text: "לספור בקול רם מ-1 עד 20.", answer: "for", why: "טווח קבוע וידוע — 20 חזרות בדיוק." },
    { text: "להמשיך את המשחק כל עוד לשחקנית יש חיים (lives > 0).", answer: "while", why: "מספר הסיבובים תלוי במה שקורה במשחק, לא קבוע מראש." }
  ];

  var container = document.getElementById("quiz-container");
  window.lessonProgress.quizTotal = scenarios.length;
  scenarios.forEach(function (s, idx) {
    var card = document.createElement("div");
    card.className = "quiz-card";
    card.innerHTML =
      ''<p>'' + (idx + 1) + ''. '' + s.text + ''</p>'' +
      ''<div class="quiz-choices">'' +
        ''<button class="quiz-choice for-c" data-choice="for">for</button>'' +
        ''<button class="quiz-choice while-c" data-choice="while">while</button>'' +
      ''</div>'' +
      ''<div class="quiz-feedback"></div>'';
    container.appendChild(card);

    var buttons = card.querySelectorAll(".quiz-choice");
    var fb = card.querySelector(".quiz-feedback");
    buttons.forEach(function (b) {
      b.addEventListener("click", function () {
        buttons.forEach(function (x) { x.disabled = true; });
        if (b.dataset.choice === s.answer) {
          fb.textContent = "נכון! " + s.why;
          fb.className = "quiz-feedback correct";
          window.lessonProgress.quizCorrect++;
        } else {
          fb.textContent = "התשובה הנכונה היא " + s.answer + ". " + s.why;
          fb.className = "quiz-feedback wrong";
        }
      });
    });
  });
})();

/* ---------- certificate download ---------- */
(function () {
  var nameInput = document.getElementById("cert-name");
  var btn = document.getElementById("cert-download");
  var statusEl = document.getElementById("cert-status");
  var fallbackBox = document.getElementById("cert-fallback");
  var fallbackText = document.getElementById("cert-fallback-text");
  var nameDisplay = document.getElementById("cert-name-display");

  function currentName() {
    return (nameInput.value || "").trim() || "תלמידה";
  }

  function syncNameDisplay() {
    nameDisplay.textContent = currentName();
  }
  nameInput.addEventListener("input", syncNameDisplay);
  syncNameDisplay();

  function showFallback(html) {
    fallbackText.value = html;
    fallbackBox.hidden = false;
  }

  function escapeHtml(str) {
    return (str || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }

  function statusRow(label, done) {
    return ''<div class="row"><span class="dot '' + (done ? "done" : "") + ''"></span><span class="label">'' + label + ''</span><span class="state '' + (done ? "ok" : "no") + ''">'' + (done ? "הושלם" : "לא הושלם") + "</span></div>";
  }

  function buildCertificateHtml(name) {
    var p = window.lessonProgress;
    var ex5 = escapeHtml(document.getElementById("ex5-answer").value.trim()) || "(לא הוזן קוד)";
    var ex6 = escapeHtml(document.getElementById("ex6-answer").value.trim()) || "(לא הוזן קוד)";
    var dateStr = new Date().toLocaleDateString("he-IL");

    return ''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8">'' +
      ''<title>תעודת תרגול — '' + escapeHtml(name) + ''</title>'' +
      ''<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'' +
      ''<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@700;800;900&family=Assistant:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">'' +
      ''<style>'' +
      '':root{--bg:#12102A;--panel:#1D1A3D;--panel2:#262148;--ink:#F5F3FF;--dim:#B4AEDB;--faint:#6F699E;--for:#FFB84D;--while:#FF5C8A;--ok:#5CE1A6;--no:#FF6B6B;--line:rgba(245,243,255,.12);}'' +
      ''*{box-sizing:border-box;}body{margin:0;background:var(--bg);color:var(--ink);font-family:Assistant,sans-serif;font-size:16px;line-height:1.7;padding:50px 20px;}'' +
      ''.wrap{max-width:640px;margin:0 auto;}'' +
      ''h1{font-family:Rubik,sans-serif;font-weight:900;font-size:2rem;margin:0 0 6px;}'' +
      ''.meta{color:var(--dim);margin-bottom:34px;font-size:15px;}'' +
      ''h2{font-family:Rubik,sans-serif;font-weight:800;font-size:1.1rem;margin:0 0 14px;color:var(--for);}'' +
      ''.card{background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:20px 22px;margin-bottom:26px;}'' +
      ''.row{display:flex;align-items:center;gap:10px;padding:6px 0;}'' +
      ''.dot{width:10px;height:10px;border-radius:50%;background:var(--no);flex-shrink:0;}'' +
      ''.dot.done{background:var(--ok);}'' +
      ''.label{flex:1;font-size:15px;}'' +
      ''.state{font-family:"JetBrains Mono",monospace;font-size:13px;font-weight:600;}'' +
      ''.state.ok{color:var(--ok);}.state.no{color:var(--no);}'' +
      ''.score{font-family:"JetBrains Mono",monospace;font-size:15px;color:var(--dim);padding:6px 0;}'' +
      ''.score strong{color:var(--ink);}'' +
      ''pre{direction:ltr;text-align:left;font-family:"JetBrains Mono",monospace;font-size:13.5px;line-height:1.7;background:rgba(0,0,0,.28);border-radius:10px;padding:16px 18px;overflow-x:auto;white-space:pre-wrap;word-break:break-word;color:var(--ink);margin:0;}'' +
      ''.q{font-size:14.5px;color:var(--dim);margin:0 0 10px;}'' +
      ''</style></head><body><div class="wrap">'' +
      ''<h1>תעודת תרגול — for ו-while בפייתון</h1>'' +
      ''<div class="meta">שם: '' + escapeHtml(name) + '' · תאריך: '' + dateStr + ''</div>'' +

      ''<h2>תרגילים עצמאיים</h2><div class="card">'' +
      statusRow("תרגיל 1 (for · סכימה עד 45)", p.ex1) +
      statusRow("תרגיל 2 (for · start/stop/step)", p.ex2) +
      statusRow("תרגיל 3 (while · הכפלה)", p.ex3) +
      statusRow("תרגיל 4 (while · ניחוש חזרות)", p.ex4) +
      ''</div>'' +

      ''<h2>בלש הקוד וחידון</h2><div class="card">'' +
      ''<div class="score">בלש הקוד: <strong>'' + p.detectiveSolved + ''</strong> מתוך '' + p.detectiveTotal + '' סיבובים נפתרו</div>'' +
      ''<div class="score">חידון for/while: <strong>'' + p.quizCorrect + ''</strong> תשובות נכונות מתוך '' + p.quizTotal + ''</div>'' +
      ''</div>'' +

      ''<h2>תרגיל 5 · for · חג אהוב</h2><div class="card"><p class="q">לולאת for עם הודעה שונה על כל חג.</p><pre>'' + ex5 + ''</pre></div>'' +

      ''<h2>תרגיל 6 · while · ספירה לאחור לחג</h2><div class="card"><p class="q">לולאת while שסופרת ימים עד החג האהוב.</p><pre>'' + ex6 + ''</pre></div>'' +

      ''</div></body></html>'';
  }

  function blobDownload(filename, html) {
    try {
      var blob = new Blob([html], { type: "text/html;charset=utf-8" });
      var url = URL.createObjectURL(blob);
      var a = document.createElement("a");
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      setTimeout(function () { URL.revokeObjectURL(url); }, 1500);
      return true;
    } catch (e) {
      return false;
    }
  }

  btn.addEventListener("click", async function () {
    var name = currentName();
    var html = buildCertificateHtml(name);
    var filename = name + " - תעודת תרגול.html";

    // Path 1: Claude''s runtime download capability (works when viewed as a claude.ai artifact)
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
          if (err && err.code === "declined") {
            statusEl.textContent = "ההורדה בוטלה.";
            statusEl.className = "cert-status wrong";
            return;
          }
          // fall through to the browser-download path below
        }
      }
    }

    // Path 2: standard browser download — works when this HTML file is opened
    // directly (double-clicked, opened from disk, hosted elsewhere) rather than
    // viewed inside a claude.ai artifact page.
    if (blobDownload(filename, html)) {
      statusEl.textContent = "הקובץ ירד! שלחו אותו אליי.";
      statusEl.className = "cert-status correct";
      return;
    }

    // Path 3: last resort — copyable text box.
    statusEl.textContent = "ההורדה האוטומטית לא עבדה כאן — הטקסט מוכן להעתקה למטה.";
    statusEl.className = "cert-status wrong";
    showFallback(html);
  });
})();

/* ---------- flip cards ---------- */
document.querySelectorAll(".flip-card").forEach(function (card) {
  card.addEventListener("click", function () { card.classList.toggle("flipped"); });
});
</script>

</body>
</html>
', 3, '2026-09-17T16:18:25.181Z');
