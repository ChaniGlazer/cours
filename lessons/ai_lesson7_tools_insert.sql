DELETE FROM lessons WHERE course_id='ai-app-dev' AND slug='lesson-7-tools';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('3239789f14e2eb41a472bf40905a20c8', 'ai-app-dev', 'lesson-7-tools', 'שיעור 7 - כלים', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 7 — כלים</title>
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
    --cyan: #ff7f96;
    --cyan-soft: #412a3e;
    --violet: #ffd27a;
    --violet-soft: #413739;
    --success: #6fe0a0;
    --success-soft: #2a3a3f;
    --danger: #ff7f96;
    --danger-soft: #412a3e;
    --warn: #ffd27a;
    --warn-soft: #413739;
    --blue: #8fb8ff;
    --blue-soft: #2f334f;
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
      radial-gradient(700px 420px at 12% -5%, rgba(255,127,150,0.12), transparent 60%),
      radial-gradient(700px 420px at 100% 18%, rgba(255,210,122,0.10), transparent 60%),
      var(--bg);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 17px;
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
  }
  ::selection { background: var(--cyan); color: #14121f; }

  .wrap { max-width: 740px; margin: 0 auto; padding: 0 22px; }
  p { color: var(--ink-dim); margin: 0; }
  p strong, li strong { color: var(--ink); }
  h1, h2, h3, h4 { font-family: var(--display); font-weight: 800; color: var(--ink); margin: 0; }
  code { font-family: var(--mono); }
  p code, li code {
    font-size: 0.88em; background: var(--bg-panel-2); border: 1px solid var(--line);
    border-radius: 6px; padding: 1px 7px; color: var(--cyan); direction: ltr; unicode-bidi: embed;
  }
  button { font-family: var(--sans); cursor: pointer; }
  button:focus-visible, a:focus-visible, input:focus-visible { outline: 2px solid var(--cyan); outline-offset: 3px; }

  section { padding: 60px 0; }
  section + section { border-top: 1px solid var(--line); }
  .eyebrow { font-family: var(--mono); font-size: 13px; color: var(--ink-faint); margin-bottom: 12px; direction: rtl; }
  .eyebrow.c { color: var(--cyan); }
  .eyebrow.v { color: var(--violet); }
  h2.section-title { font-size: clamp(1.6rem, 4.5vw, 2.2rem); line-height: 1.25; }
  .lede { font-size: 18px; margin-top: 14px; }

  .scroll-progress { position: fixed; top: 0; inset-inline: 0; height: 4px; z-index: 50; }
  .scroll-progress i { display: block; height: 100%; width: 0%; background: linear-gradient(90deg, var(--cyan), var(--violet)); }
  .topbar { background: var(--bg-panel); border-bottom: 1px solid var(--line); padding: 12px 0; }
  .topbar-inner { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; font-size: 14px; }
  .topbar .course { font-family: var(--display); font-weight: 700; color: var(--ink); }
  .topbar .lesson-chip { font-family: var(--mono); font-size: 12.5px; color: var(--cyan); border: 1px solid var(--cyan); border-radius: 100px; padding: 3px 12px; }

  /* ---------- hero ---------- */
  .hero { padding: 72px 0 52px; text-align: center; }
  .hero h1 { font-size: clamp(2.1rem, 7vw, 3.3rem); line-height: 1.18; }
  .hero h1 .a1 { color: var(--cyan); }
  .hero h1 .a2 { color: var(--violet); }
  .hero-sub { max-width: 46ch; margin: 18px auto 0; font-size: 18.5px; }
  .time-row { margin-top: 22px; display: flex; gap: 10px; justify-content: center; flex-wrap: wrap; }
  .pill { font-size: 13.5px; font-weight: 600; color: var(--ink-dim); border: 1px solid var(--line-strong); border-radius: 100px; padding: 4px 14px; }
  .morph { margin-top: 30px; font-size: 38px; letter-spacing: 8px; }

  /* ---------- shared bits ---------- */
  .callout { margin-top: 20px; border-radius: 14px; padding: 14px 18px; font-size: 15.5px; display: flex; gap: 12px; align-items: flex-start; border: 1px solid; }
  .callout .ico { font-size: 20px; line-height: 1.5; }
  .callout p { color: var(--ink); }
  .callout.warn { background: var(--warn-soft); border-color: rgba(255,210,122,.45); }
  .callout.danger { background: var(--danger-soft); border-color: rgba(255,127,150,.5); }
  .callout.info { background: var(--cyan-soft); border-color: rgba(255,127,150,.4); }
  .callout.ok { background: var(--success-soft); border-color: rgba(111,224,160,.45); }

  .code-card { background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); overflow: hidden; margin-top: 18px; }
  .code-card-head { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 10px 16px; border-bottom: 1px solid var(--line); font-size: 13.5px; font-weight: 700; color: var(--ink-faint); }
  .copy-btn { font-size: 12.5px; font-weight: 700; color: var(--cyan); background: transparent; border: 1px solid var(--line-strong); border-radius: 100px; padding: 4px 12px; }
  .copy-btn:hover { border-color: var(--cyan); }
  .code-card pre { direction: ltr; text-align: left; margin: 0; padding: 16px 18px 18px; overflow-x: auto; font-family: var(--mono); font-size: 14px; line-height: 1.7; color: #f4f1fa; }
  .code-card pre.he-out { direction: rtl; text-align: right; font-family: var(--sans); font-size: 16px; line-height: 1.7; white-space: pre-wrap; }
  .he { direction: rtl; unicode-bidi: isolate; }
  .k { color: #ff7f96; } .s { color: #6fe0a0; } .f { color: #ffd27a; } .cm { color: var(--ink-faint); }

  .btn { font-family: var(--display); font-weight: 800; font-size: 15px; color: #14121f; background: var(--cyan); border: none; border-radius: 100px; padding: 10px 22px; }
  .btn:disabled { opacity: .45; cursor: default; }
  .btn.ghost { background: transparent; color: var(--ink); border: 1px solid var(--line-strong); }

  /* ---------- journey demo ---------- */
  .demo { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 20px 16px 16px; }
  .rows { display: grid; grid-template-columns: minmax(0, 1fr); gap: 10px; min-height: 120px; }
  .jrow { display: grid; grid-template-columns: 96px minmax(0, 1fr); gap: 12px; align-items: start; background: var(--bg-panel-2); border-radius: 12px; padding: 10px 12px; animation: pop .3s ease; }
  @keyframes pop { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }
  .who { font-size: 13px; font-weight: 800; font-family: var(--display); text-align: center; border-radius: 8px; padding: 3px 6px; }
  .who.you { background: var(--violet-soft); color: var(--violet); }
  .who.model { background: var(--cyan-soft); color: var(--cyan); }
  .who.code { background: var(--blue-soft); color: var(--blue); }
  .jtext { font-size: 15.5px; color: var(--ink); }
  .jtext .mono { direction: ltr; unicode-bidi: embed; font-family: var(--mono); font-size: 13.5px; color: var(--cyan); }
  .jtext small { display: block; color: var(--ink-faint); font-size: 13px; margin-top: 2px; }
  .demo-actions { margin-top: 16px; display: flex; gap: 10px; flex-wrap: wrap; }
  .demo-note { margin-top: 10px; font-size: 13px; color: var(--ink-faint); }

  /* ---------- steps ---------- */
  .steps { margin-top: 24px; display: grid; grid-template-columns: minmax(0, 1fr); gap: 14px; }
  .step-card { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 18px 20px; transition: border-color .2s; }
  .step-card.done { border-color: var(--success); }
  .step-head { display: flex; align-items: center; gap: 12px; }
  .step-ico { width: 44px; height: 44px; border-radius: 14px; background: var(--bg-panel-2); display: flex; align-items: center; justify-content: center; font-size: 23px; flex-shrink: 0; }
  .step-head h3 { font-size: 17.5px; flex: 1; }
  .check { display: flex; align-items: center; gap: 8px; font-size: 13.5px; font-weight: 700; color: var(--ink-dim); cursor: pointer; flex-shrink: 0; }
  .check input { width: 20px; height: 20px; accent-color: var(--success); cursor: pointer; }
  .step-body { margin-top: 12px; }
  .step-body > p { font-size: 15.5px; }

  /* ---------- explainer ---------- */
  .explain { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 16px 14px 18px; }
  .blocks { display: grid; grid-template-columns: minmax(0, 1fr); gap: 8px; }
  .blk { text-align: start; background: rgba(0,0,0,.28); border: 1px solid transparent; border-inline-start: 4px solid var(--bc); border-radius: 10px; padding: 8px 12px 10px; color: var(--ink); }
  .blk:hover { border-color: var(--line-strong); }
  .blk.on { border-color: var(--bc); background: rgba(255,255,255,.06); }
  .blk-head { display: flex; align-items: center; justify-content: space-between; gap: 8px; margin-bottom: 4px; font-family: var(--display); font-weight: 800; font-size: 14.5px; }
  .tag { font-size: 12px; font-weight: 800; border-radius: 100px; padding: 1px 10px; white-space: nowrap; }
  .tag.new { background: var(--success-soft); color: var(--success); border: 1px solid rgba(111,224,160,.45); }
  .tag.small { background: var(--cyan-soft); color: var(--cyan); border: 1px solid rgba(255,127,150,.4); }
  .tag.plain { background: var(--bg-panel-2); color: var(--ink-dim); border: 1px solid var(--line-strong); }
  .blk pre { direction: ltr; text-align: left; margin: 0; font-family: var(--mono); font-size: 12.5px; line-height: 1.6; color: #f4f1fa; overflow-x: auto; white-space: pre; }
  .explain-text { margin-top: 14px; direction: rtl; }
  .explain-text h4 { font-size: 16.5px; margin-bottom: 6px; }
  .explain-text p { font-size: 15.5px; color: var(--ink); }
  .explain-text ol { margin: 8px 0 0; padding-inline-start: 22px; color: var(--ink); font-size: 15.5px; }
  .explain-text li { margin-bottom: 6px; }
  .explain-text code { font-size: .88em; background: var(--bg-panel-2); border: 1px solid var(--line); border-radius: 6px; padding: 1px 7px; color: var(--cyan); direction: ltr; unicode-bidi: embed; }

  /* ---------- parts ---------- */
  .parts { margin-top: 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  @media (max-width: 560px) { .parts { grid-template-columns: 1fr; } }
  .part { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 16px 18px; }
  .part .em { font-size: 28px; line-height: 1.2; }
  .part h4 { font-size: 16px; margin: 4px 0 2px; }
  .part p { font-size: 14.5px; }

  /* ---------- experiments ---------- */
  .exps { margin-top: 24px; display: grid; gap: 12px; }
  .exp { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 14px 18px; display: grid; grid-template-columns: 40px minmax(0, 1fr); gap: 12px; align-items: start; }
  .exp .em { font-size: 30px; line-height: 1.3; }
  .exp h4 { font-size: 16px; }
  .exp p { font-size: 15px; margin-top: 2px; }
  .exp .code-card { margin-top: 8px; }

  /* ---------- quiz ---------- */
  .quiz-card { margin-top: 16px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 18px 20px; }
  .quiz-card > p { color: var(--ink); font-weight: 600; font-size: 16px; margin-bottom: 12px; }
  .choices { display: grid; gap: 8px; }
  .choice { text-align: start; background: var(--bg-panel-2); border: 1px solid var(--line-strong); color: var(--ink); border-radius: 12px; padding: 10px 14px; font-size: 15px; }
  .choice:hover:not(:disabled) { border-color: var(--ink-dim); }
  .choice.right { border-color: var(--success); background: var(--success-soft); }
  .choice.wrong { border-color: var(--danger); background: var(--danger-soft); }
  .choice:disabled { cursor: default; }
  .fb { margin-top: 10px; font-size: 14.5px; font-weight: 700; min-height: 22px; }
  .fb.correct { color: var(--success); } .fb.wrong { color: var(--danger); }
  .score-box { margin-top: 22px; text-align: center; font-family: var(--display); font-weight: 800; font-size: 20px; color: var(--cyan); }

  /* ---------- mission ---------- */
  .mission { margin-top: 24px; background: linear-gradient(135deg, var(--cyan-soft), var(--violet-soft)); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 24px 26px 20px; }
  .mission h3 { font-size: 20px; }
  .mission ul { list-style: none; padding: 0; margin: 14px 0 0; display: grid; gap: 10px; }
  .mission li label { display: flex; gap: 12px; align-items: flex-start; color: var(--ink); font-size: 16px; cursor: pointer; }
  .mission li input { width: 20px; height: 20px; margin-top: 4px; accent-color: var(--success); flex-shrink: 0; }
  .mission li input:checked + span { color: var(--ink-faint); text-decoration: line-through; }
  .mission-done { margin-top: 16px; font-weight: 800; font-family: var(--display); color: var(--success); min-height: 26px; }
  .next-card { margin-top: 26px; border: 1px dashed var(--line-strong); border-radius: var(--radius); padding: 18px 24px; }
  .next-card .eyebrow { margin-bottom: 4px; }
  .next-card h3 { font-size: 19px; }

.plink { color: #E0553F; font-weight: 700; text-decoration: underline; text-underline-offset: 3px; }
.plink:hover { text-decoration-thickness: 2px; }
  footer { padding: 44px 0 70px; text-align: center; color: var(--ink-faint); font-size: 14px; }
</style>
</head>
<body>

<div class="scroll-progress" aria-hidden="true"><i id="scroll-bar"></i></div>

<div class="topbar">
  <div class="wrap topbar-inner">
    <span class="course">בונים אפליקציית AI עם OpenAI ו-Python</span>
    <span class="lesson-chip">שיעור 7</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap">
    <div class="eyebrow c" style="text-align:center;">שיעור 7 · כלים</div>
    <h1>מבוט <span class="a1">שמדבר</span><br>לבוט <span class="a2">שעושה</span></h1>
    <p class="hero-sub">המודל יודע לדבר, אבל הוא לא יכול לגעת בעולם. היום ניתן לו כלים: פונקציות שאנחנו כותבים, והוא מבקש מאיתנו להפעיל.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-35 דקות</span>
      <span class="pill">🛠️ Function calling</span>
      <span class="pill">💪 מחשבון BMI</span>
    </div>
    <div class="morph" aria-hidden="true">🗣️ → 🛠️</div>
  </div>
</header>

<main>

  <!-- ================= IDEA ================= -->
  <section id="idea">
    <div class="wrap">
      <div class="eyebrow">הרעיון</div>
      <h2 class="section-title">המודל מבקש, הקוד שלכם מבצע</h2>
      <p class="lede">יש דברים שהמודל לא יכול לעשות לבד: לדעת מה השעה עכשיו, לקרוא קובץ שלכם, לשלוף נתונים ממסד נתונים או לשלוח מייל. כלים פותרים את זה. עקבו אחרי שאלה אחת, צעד אחר צעד:</p>

      <div class="demo">
        <div class="rows" id="rows"></div>
        <div class="demo-actions">
          <button class="btn" id="next" type="button">הצעד הבא ▸</button>
          <button class="btn ghost" id="reset" type="button">מההתחלה</button>
        </div>
        <div class="demo-note">* המחשה מפושטת. כאן הכלי הוא מחשבון BMI, כדי להבין את המנגנון.</div>
      </div>

      <div class="callout warn">
        <span class="ico">⚠️</span>
        <p><strong>המודל לא מריץ קוד בעצמו.</strong> הוא רק אומר "תפעילו את הכלי הזה עם הערכים האלה". אנחנו מריצים, ומחזירים לו את התוצאה.</p>
      </div>
    </div>
  </section>

  <!-- ================= BUILD ================= -->
  <section id="build">
    <div class="wrap">
      <div class="eyebrow c">בונים</div>
      <h2 class="section-title">מאמן כושר עם מחשבון</h2>

      <div class="callout info">
        <span class="ico">💡</span>
        <p>זה הקוד הארוך ביותר בקורס עד עכשיו, אבל רובו הדבקה. אחרי שתריצו, תמצאו בחלק "הקוד, חלק אחר חלק" הסבר מפורט על כל חלק בו.</p>
      </div>

      <div class="steps">

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">✍️</div><h3>1 · קובץ חדש ומדביקים</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>צרו קובץ חדש בשם <code>tools.py</code> והדביקו:</p>
            <div class="code-card">
              <div class="code-card-head"><span>tools.py</span><button class="copy-btn" type="button">העתק</button></div>
<pre><span class="k">import</span> json
<span class="k">from</span> openai <span class="k">import</span> OpenAI
client = <span class="f">OpenAI</span>()

<span class="k">def</span> <span class="f">calculate_bmi</span>(weight_kg, height_m):
    <span class="k">return</span> <span class="f">round</span>(weight_kg / height_m ** 2, 1)

tools = [{
    <span class="s">"type"</span>: <span class="s">"function"</span>,
    <span class="s">"name"</span>: <span class="s">"calculate_bmi"</span>,
    <span class="s">"description"</span>: <span class="s">"Calculate BMI from weight in kg and height in meters"</span>,
    <span class="s">"parameters"</span>: {
        <span class="s">"type"</span>: <span class="s">"object"</span>,
        <span class="s">"properties"</span>: {
            <span class="s">"weight_kg"</span>: {<span class="s">"type"</span>: <span class="s">"number"</span>},
            <span class="s">"height_m"</span>: {<span class="s">"type"</span>: <span class="s">"number"</span>},
        },
        <span class="s">"required"</span>: [<span class="s">"weight_kg"</span>, <span class="s">"height_m"</span>],
        <span class="s">"additionalProperties"</span>: <span class="k">False</span>,
    },
    <span class="s">"strict"</span>: <span class="k">True</span>,
}]

instructions = <span class="s">"<span class="he">אתה מאמן כושר. כשצריך לחשב BMI, השתמש בכלי. ענה בעברית, בקצרה.</span>"</span>
messages = [{<span class="s">"role"</span>: <span class="s">"user"</span>, <span class="s">"content"</span>: <span class="f">input</span>(<span class="s">"You: "</span>)}]
response = client.responses.<span class="f">create</span>(model=<span class="s">"gpt-4o-mini"</span>, instructions=instructions, tools=tools, input=messages)

messages += response.output
called = <span class="k">False</span>
<span class="k">for</span> item <span class="k">in</span> response.output:
    <span class="k">if</span> item.type == <span class="s">"function_call"</span>:
        called = <span class="k">True</span>
        args = json.<span class="f">loads</span>(item.arguments)
        result = <span class="f">calculate_bmi</span>(**args)
        messages.<span class="f">append</span>({<span class="s">"type"</span>: <span class="s">"function_call_output"</span>, <span class="s">"call_id"</span>: item.call_id, <span class="s">"output"</span>: <span class="f">str</span>(result)})

<span class="k">if</span> called:
    response = client.responses.<span class="f">create</span>(model=<span class="s">"gpt-4o-mini"</span>, instructions=instructions, tools=tools, input=messages)
<span class="f">print</span>(<span class="s">"Bot:"</span>, response.output_text)</pre>
            </div>
            <div class="callout warn">
              <span class="ico">⚠️</span>
              <p>רווחים בתחילת שורה הם חלק מהקוד, וגם הסוגריים. אם משהו לא עובד, שאלו AI מה לתקן.</p>
            </div>
          </div>
        </div>

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">💪</div><h3>2 · מריצים ושואלים</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <div class="code-card">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python tools.py</pre>
            </div>
            <p style="margin-top:12px;">כתבו בעברית: <strong>"אני שוקל 80 קילו וגובה 1.80 מטר, מה ה-BMI שלי?"</strong>. התשובה תכלול את המספר המדויק שחישב הקוד שלכם, בערך כך:</p>
            <div class="code-card">
<pre class="he-out">ה-BMI שלך הוא 24.7, וזה בטווח התקין. כל הכבוד, המשך כך! 💪</pre>
            </div>
            <div class="callout ok">
              <span class="ico">🎉</span>
              <p>המודל החליט לבד שהוא צריך את הכלי, ביקש להפעיל אותו עם הערכים הנכונים, וניסח תשובה. זה הבסיס לכל "סוכן" חכם.</p>
            </div>
          </div>
        </div>

      </div>
    </div>
  </section>

  <!-- ================= CODE EXPLAINED ================= -->
  <section id="parts">
    <div class="wrap">
      <div class="eyebrow v">מבינים</div>
      <h2 class="section-title">הקוד, חלק אחר חלק</h2>
      <p class="lede">נפרק את הקוד לחמישה חלקים. לחצו על כל אחד כדי לראות מה הוא עושה, ואיזה חלק חדש לעומת הקריאה הרגילה שכתבנו בשיעורים הקודמים.</p>

      <div class="callout info">
        <span class="ico">🆕</span>
        <p><strong>מה השתנה לעומת קריאה רגילה למודל?</strong> שלושה דברים בלבד: מוסיפים <code>tools=tools</code> לקריאה, בודקים אם המודל ביקש כלי ומריצים אותו, ושולחים קריאה שנייה עם התוצאה.</p>
      </div>

      <div class="explain">
        <div class="blocks" id="blocks"></div>
        <div class="explain-text" id="explain-text"></div>
      </div>

      <div class="callout info">
        <span class="ico">🧩</span>
        <p>התיאור של הכלי (<code>description</code>) חשוב מאוד: לפיו המודל מחליט מתי להשתמש בו. תיאור ברור יוביל לשימוש נכון.</p>
      </div>
    </div>
  </section>

  <!-- ================= EXPERIMENTS ================= -->
  <section id="experiments">
    <div class="wrap">
      <div class="eyebrow c">משחקים</div>
      <h2 class="section-title">שלושה ניסויים</h2>
      <div class="exps">
        <div class="exp">
          <div class="em">👋</div>
          <div>
            <h4>שאלה בלי כלי</h4>
            <p>כתבו "שלום, מה שלומך?". המודל יענה ישר, בלי להפעיל את הכלי. הוא מחליט בעצמו מתי הוא צריך אותו.</p>
          </div>
        </div>
        <div class="exp">
          <div class="em">🕒</div>
          <div>
            <h4>הוסיפו כלי שני עם AI</h4>
            <p>המודל לא יודע מה השעה. בקשו מ-AI להוסיף כלי שמחזיר אותה. הדביקו לו את ההוראה הזו, ואת הקוד שלכם:</p>
            <div class="code-card">
              <div class="code-card-head"><span>הוראה ל-AI</span><button class="copy-btn" type="button">העתק</button></div>
<pre class="he-out">הנה קוד שעובד של בוט עם כלי אחד. הוסף כלי נוסף בשם get_time שמחזיר את השעה הנוכחית (בלי פרמטרים). שמור על שאר הקוד, ואל תוסיף מפתח API. החזר את הקוד המלא.

(כאן מדביקים את הקוד של tools.py)</pre>
            </div>
          </div>
        </div>
        <div class="exp">
          <div class="em">🔗</div>
          <div>
            <h4>חברו את הכלי לאתר</h4>
            <p>עד עכשיו הכלי רץ בטרמינל, והאתר משיעור 6 לא מכיר אותו. הדביקו ל-AI (ChatGPT או Claude) את <code>app.py</code> משיעור 6 ואת <code>tools.py</code>, עם ההוראה:</p>
            <div class="code-card">
              <div class="code-card-head"><span>הוראה ל-AI</span><button class="copy-btn" type="button">העתק</button></div>
<pre class="he-out">הנה שני קבצים שעובדים: אפליקציית Streamlit (app.py) ובוט עם כלי (tools.py). חבר את הכלי calculate_bmi לאפליקציית ה-Streamlit, כך שהבוט באתר יפעיל אותו בעצמו. שמור על שאר הקוד, ואל תוסיף מפתח API לקוד. החזר את הקוד המלא.

(כאן מדביקים את הקוד של app.py)

(כאן מדביקים את הקוד של tools.py)</pre>
            </div>
          </div>
        </div>
      </div>
      <div class="callout ok">
        <span class="ico">📚</span>
        <p><strong>רוצים בקשות מדויקות יותר ל-AI?</strong> יש באתר <a class="plink" href="/courses/prompts" target="_top">קורס פרומפטים</a> נפרד, שמוקדש לנושא הזה בלבד.</p>
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
          <li><label><input type="checkbox"><span>הרצתי את <code>tools.py</code> וקיבלתי תשובה עם BMI שחושב על ידי הקוד</span></label></li>
          <li><label><input type="checkbox"><span>שאלתי שאלה בלי קשר לכלי וראיתי שהמודל עונה ישירות</span></label></li>
          <li><label><input type="checkbox"><span>הוספתי כלי שני בעזרת AI (למשל <code>get_time</code>)</span></label></li>
        </ul>
        <div class="mission-done" id="mission-done"></div>
      </div>

      <div class="next-card">
        <div class="eyebrow">בשיעור הבא · שיעור 8</div>
        <h3>סיכום ופרויקט סיום</h3>
        <p style="margin-top:6px;">בשיעור האחרון נסכם את המסע, ותבנו אפליקציה משלכם, עם דמות, זיכרון ואתר.</p>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">בונים אפליקציית AI עם OpenAI ו-Python · שיעור 7</div></footer>

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

/* ---------- journey demo ---------- */
(function () {
  var steps = [
    { w: "you", wl: "🧑 אתם", t: "אני שוקל 80 קילו וגובה 1.80 מטר, מה ה-BMI שלי?" },
    { w: "model", wl: "🧠 המודל", t: "אני צריך את הכלי הזה:", m: "calculate_bmi(weight_kg=80, height_m=1.8)", s: "המודל לא מחשב בעצמו. הוא מבקש מהקוד להפעיל את הכלי." },
    { w: "code", wl: "💻 הקוד שלכם", t: "מריץ את הפונקציה ומחזיר:", m: "24.7", s: "זה החלק שאתם כתבתם בפייתון." },
    { w: "model", wl: "🧠 המודל", t: "ה-BMI שלך הוא 24.7, וזה בטווח התקין. כל הכבוד! 💪", s: "עכשיו יש לו מספר מדויק לנסח תשובה." }
  ];
  var rows = $("rows"), nextBtn = $("next"), idx = 0;
  function empty() { rows.innerHTML = ""; rows.appendChild(el("div", "jtext", "לחצו על \"הצעד הבא\" כדי להתחיל")); }
  function add(s) {
    var first = rows.querySelector(":scope > .jtext"); if (first && !first.classList.contains("jrow")) first.remove();
    var r = el("div", "jrow");
    r.appendChild(el("div", "who " + s.w, s.wl));
    var t = el("div", "jtext");
    t.appendChild(document.createTextNode(s.t));
    if (s.m) { t.appendChild(document.createTextNode(" ")); t.appendChild(el("span", "mono", s.m)); }
    if (s.s) t.appendChild(el("small", "", s.s));
    r.appendChild(t); rows.appendChild(r);
  }
  nextBtn.addEventListener("click", function () {
    if (idx >= steps.length) return;
    add(steps[idx]); idx++;
    if (idx >= steps.length) { nextBtn.disabled = true; }
  });
  $("reset").addEventListener("click", function () { idx = 0; nextBtn.disabled = false; empty(); });
  empty();
})();

/* ---------- code explainer ---------- */
(function () {
  var blocks = [
    { c: "#8fb8ff", t: "1 · הכלי עצמו", tag: ["plain", "פייתון רגיל"],
      code: "def calculate_bmi(weight_kg, height_m):\n    return round(weight_kg / height_m ** 2, 1)",
      intro: "זו פונקציית פייתון רגילה, כמו כל אחת שכתבתם: מקבלת משקל וגובה ומחזירה מספר.",
      steps: ["המודל <strong>אף פעם לא רואה</strong> את הקוד הזה. הוא רק יכול לבקש שנפעיל אותו.", "אפשר להחליף אותה בכל פונקציה אחרת: שליפה ממסד נתונים, שליחת מייל, קריאת קובץ, או בדיקת מחיר."] },
    { c: "#ffd27a", t: "2 · כרטיס הביקור של הכלי", tag: ["new", "חדש"],
      code: "tools = [{\n    \"type\": \"function\",\n    \"name\": \"calculate_bmi\",\n    \"description\": \"Calculate BMI from weight in kg and height in meters\",\n    \"parameters\": { ... weight_kg, height_m ... },\n}]",
      intro: "זה מה שהמודל כן רואה: תיאור של הכלי, כמו כרטיס ביקור.",
      steps: ["<code>name</code>: השם שבו המודל יבקש את הכלי.", "<code>description</code>: מה הכלי עושה. לפי זה המודל מחליט מתי להשתמש בו.", "<code>parameters</code>: אילו ערכים הכלי צריך, ומאיזה סוג (כאן שני מספרים).", "<code>strict</code> ו-<code>additionalProperties</code>: מבטיחים שהמודל ימלא בדיוק את הערכים שהגדרנו, לא יותר ולא פחות."] },
    { c: "#6fe0a0", t: "3 · הקריאה הראשונה", tag: ["small", "שינוי קטן"],
      code: "response = client.responses.create(\n    model=\"gpt-4o-mini\",\n    instructions=instructions,\n    tools=tools,\n    input=messages)",
      intro: "זו אותה קריאה כמו בשיעורים הקודמים, עם תוספת אחת: <code>tools=tools</code>.",
      steps: ["בזכות זה המודל יודע שיש לו כלים.", "עכשיו הוא יכול לבחור: לענות ישר (למשל על \"שלום\"), או לבקש שנפעיל כלי."] },
    { c: "#ff7f96", t: "4 · המודל ביקש כלי? מריצים", tag: ["new", "חדש"],
      code: "messages += response.output\ncalled = False\nfor item in response.output:\n    if item.type == \"function_call\":\n        called = True\n        args = json.loads(item.arguments)\n        result = calculate_bmi(**args)\n        messages.append({\"type\": \"function_call_output\",\n            \"call_id\": item.call_id, \"output\": str(result)})",
      intro: "זה הלב של השיעור. מה קורה כאן, שלב אחר שלב:",
      steps: ["<code>messages += response.output</code>: שומרים בשיחה את מה שהמודל החזיר, כדי שיהיה לו הקשר כשנחזור אליו.", "<code>for item in response.output</code>: עוברים על מה שחזר ובודקים אם יש בקשה לכלי (<code>function_call</code>).", "<code>json.loads(item.arguments)</code>: המודל שלח את הערכים כטקסט JSON, כמו בשיעור 5. כאן הופכים אותם לנתונים של פייתון.", "<code>calculate_bmi(**args)</code>: מפעילים את הפונקציה שלנו עם הערכים שהמודל בחר.", "<code>function_call_output</code>: מוסיפים לשיחה את התוצאה. <code>call_id</code> מזהה לאיזו בקשה התוצאה שייכת.", "<code>called</code>: סימון שזוכר אם הרצנו כלי, כדי שנדע אם צריך קריאה שנייה."] },
    { c: "#b79cff", t: "5 · הקריאה השנייה", tag: ["new", "חדש"],
      code: "if called:\n    response = client.responses.create(...)\nprint(\"Bot:\", response.output_text)",
      intro: "שולחים למודל את כל השיחה שוב, הפעם עם התוצאה בפנים.",
      steps: ["המודל קורא את המספר שהקוד חישב וכותב תשובה בעברית למשתמש.", "אם המודל לא ביקש כלי (למשל ענה על \"שלום\"), <code>called</code> נשאר <code>False</code> ולא עושים קריאה שנייה."] }
  ];
  var list = $("blocks"), txt = $("explain-text");
  var btns = [];
  function pick(i) {
    var b = blocks[i];
    btns.forEach(function (x, j) { x.classList.toggle("on", j === i); });
    txt.innerHTML = "";
    var h = el("h4", "", b.t); h.style.color = b.c; txt.appendChild(h);
    var p = el("p", ""); p.innerHTML = b.intro; txt.appendChild(p);
    var ol = document.createElement("ol");
    b.steps.forEach(function (s) { var li = document.createElement("li"); li.innerHTML = s; ol.appendChild(li); });
    txt.appendChild(ol);
  }
  blocks.forEach(function (b, i) {
    var btn = el("button", "blk"); btn.type = "button"; btn.style.setProperty("--bc", b.c);
    var head = el("div", "blk-head");
    head.appendChild(el("span", "", b.t));
    head.appendChild(el("span", "tag " + b.tag[0], b.tag[1]));
    btn.appendChild(head);
    btn.appendChild(el("pre", "", b.code));
    btn.addEventListener("click", function () { pick(i); });
    list.appendChild(btn); btns.push(btn);
  });
  pick(3);
})();

/* ---------- quiz ---------- */
(function () {
  var qs = [
    { q: "מי מריץ בפועל את הפונקציה calculate_bmi?", opts: ["המודל, בשרתים של OpenAI", "הקוד שלנו, במחשב שלנו", "הספרייה openai"], ok: 1, why: "המודל רק מבקש להפעיל כלי. את הפונקציה מריץ הקוד שאנחנו כתבנו, ואנחנו מחזירים לו את התוצאה." },
    { q: "למה צריך לבצע קריאה שנייה למודל?", opts: ["כי הקריאה הראשונה נכשלה", "כדי לשלוח לו את תוצאת הכלי, והוא ינסח תשובה סופית", "כדי לשלם פעמיים"], ok: 1, why: "בקריאה הראשונה המודל מבקש כלי. בשנייה הוא מקבל את התוצאה וכותב את התשובה למשתמש." },
    { q: "מה קובע אם המודל יחליט להשתמש בכלי?", opts: ["התיאור (description) של הכלי וההנחיות", "מזל", "גודל הקובץ"], ok: 0, why: "המודל קורא את תיאור הכלי ומחליט לפיו. תיאור ברור גורם לו להשתמש בכלי בזמן הנכון." }
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
    $("mission-done").textContent = n === boxes.length ? "🎉 מעולה! נתראה בשיעור 8, ונבנה את פרויקט הסיום." : (n ? n + " מתוך " + boxes.length + " הושלמו" : "");
  }
  boxes.forEach(function (b) { b.addEventListener("change", upd); });
})();
</script>

</body>
</html>
', 7, '2026-10-19T00:00:00.000Z');
