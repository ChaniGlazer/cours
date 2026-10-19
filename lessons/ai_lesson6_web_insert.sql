DELETE FROM lessons WHERE course_id='ai-app-dev' AND slug='lesson-6-web-interface';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('4b63df053d8c36292e14ed373d6f9124', 'ai-app-dev', 'lesson-6-web-interface', 'שיעור 6 - ממשק web', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 6 — ממשק web</title>
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
  .code-card pre { direction: ltr; text-align: left; margin: 0; padding: 16px 18px 18px; overflow-x: auto; font-family: var(--mono); font-size: 14.5px; line-height: 1.75; color: #f4f1fa; }
  .code-card pre.he-out { direction: rtl; text-align: right; font-family: var(--sans); font-size: 16px; line-height: 1.7; white-space: pre-wrap; }
  .ai-opts { margin-top: 22px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 12px; }
  @media (max-width: 560px) { .ai-opts { grid-template-columns: 1fr; } }
  .ai-opt { display: block; text-decoration: none; text-align: center; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 16px; padding: 14px 10px; color: var(--ink); transition: border-color .2s; }
  .ai-opt:hover { border-color: var(--cyan); }
  .ai-opt .em { font-size: 28px; line-height: 1.2; display: block; }
  .ai-opt b { font-family: var(--display); font-size: 16px; display: block; margin-top: 4px; }
  .ai-opt small { display: block; direction: ltr; font-size: 12.5px; color: var(--cyan); }
  .he { direction: rtl; unicode-bidi: isolate; }
  .k { color: #ff7f96; } .s { color: #6fe0a0; } .f { color: #ffd27a; } .cm { color: var(--ink-faint); }

  .btn { font-family: var(--display); font-weight: 800; font-size: 15px; color: #14121f; background: var(--cyan); border: none; border-radius: 100px; padding: 10px 22px; }
  .btn:disabled { opacity: .45; cursor: default; }
  .btn.ghost { background: transparent; color: var(--ink); border: 1px solid var(--line-strong); }

  /* ---------- rerun demo ---------- */
  .demo { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 20px 16px 16px; }
  .flow { display: grid; grid-template-columns: minmax(0, 1fr); gap: 6px; }
  .step-line { display: flex; gap: 12px; align-items: center; background: var(--bg-panel-2); border: 1px solid transparent; border-radius: 10px; padding: 7px 14px; font-size: 15px; color: var(--ink-dim); transition: all .2s; }
  .step-line .n { font-family: var(--mono); font-size: 12px; color: var(--ink-faint); width: 18px; }
  .step-line.on { border-color: var(--cyan); background: var(--cyan-soft); color: var(--ink); }
  .boxes { margin-top: 16px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  @media (max-width: 560px) { .boxes { grid-template-columns: 1fr; } }
  .mem { border-radius: 14px; padding: 12px 14px; min-height: 120px; border: 1px solid var(--line-strong); }
  .mem h4 { font-size: 14.5px; margin-bottom: 2px; }
  .mem small { display: block; font-size: 12.5px; color: var(--ink-faint); margin-bottom: 8px; }
  .mem.plain { background: var(--danger-soft); border-color: rgba(255,127,150,.45); }
  .mem.plain h4 { color: var(--danger); }
  .mem.keep { background: var(--success-soft); border-color: rgba(111,224,160,.45); }
  .mem.keep h4 { color: var(--success); }
  .chips { display: flex; flex-wrap: wrap; gap: 6px; }
  .chip { font-size: 13px; background: rgba(0,0,0,.28); border-radius: 100px; padding: 2px 10px; color: var(--ink); animation: pop .25s ease; }
  .empty { font-size: 14px; color: var(--ink-faint); }
  @keyframes pop { from { opacity: 0; transform: translateY(5px); } to { opacity: 1; transform: none; } }
  .demo-actions { margin-top: 16px; display: flex; gap: 10px; flex-wrap: wrap; }

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
  .exp .code-card pre { padding: 10px 16px; font-size: 14px; }

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
    <span class="lesson-chip">שיעור 6</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap">
    <div class="eyebrow c" style="text-align:center;">שיעור 6 · ממשק web</div>
    <h1>מהטרמינל <span class="a1">לאתר אמיתי</span>,<br>בלי לדעת <span class="a2">HTML</span></h1>
    <p class="hero-sub">הבוט שלנו חכם, אבל הוא חי בחלון שחור. היום נעטוף אותו באתר עם חלון צ''אט, שאפשר להראות לכל אחד.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-30 דקות</span>
      <span class="pill">🌐 Streamlit</span>
      <span class="pill">💬 חלון צ''אט</span>
    </div>
    <div class="morph" aria-hidden="true">⬛ → 🌐</div>
  </div>
</header>

<main>

  <!-- ================= IDEA ================= -->
  <section id="idea">
    <div class="wrap">
      <div class="eyebrow">הרעיון</div>
      <h2 class="section-title">ספרייה אחת, ויש אתר</h2>
      <p class="lede"><strong style="color:var(--ink)">Streamlit</strong> היא ספרייה שהופכת סקריפט פייתון לאתר, בלי HTML ובלי עיצוב. כותבים <code>st.title(...)</code> ומופיעה כותרת, כותבים <code>st.chat_input(...)</code> ומופיעה תיבת הקלדה.</p>

      <div class="callout warn">
        <span class="ico">🔄</span>
        <p>יש דבר אחד מוזר שחייבים להבין: <strong>בכל לחיצה, Streamlit מריץ את כל הסקריפט מההתחלה</strong>. לכן משתנה רגיל מתאפס, ואם רוצים לזכור משהו צריך מקום מיוחד לזה. נראה:</p>
      </div>

      <div class="demo">
        <div class="flow" id="flow"></div>
        <div class="boxes">
          <div class="mem plain">
            <h4>🗑️ משתנה רגיל</h4><small><code style="font-size:.9em">history = []</code></small>
            <div id="plain-box"></div>
          </div>
          <div class="mem keep">
            <h4>🧠 session_state</h4><small><code style="font-size:.9em">st.session_state.history</code></small>
            <div id="keep-box"></div>
          </div>
        </div>
        <div class="demo-actions">
          <button class="btn" id="send" type="button">שלח הודעה ▸</button>
          <button class="btn ghost" id="reset" type="button">מההתחלה</button>
        </div>
      </div>
    </div>
  </section>

  <!-- ================= BUILD ================= -->
  <section id="build">
    <div class="wrap">
      <div class="eyebrow c">בונים</div>
      <h2 class="section-title">הבוט עולה לאוויר</h2>

      <div class="steps">

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">📦</div><h3>1 · מתקינים Streamlit</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <div class="code-card">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python -m pip install streamlit</pre>
            </div>
            <p style="margin-top:12px; font-size:15px;">ההתקנה ארוכה יותר מהקודמות, כי Streamlit מביאה איתה הרבה ספריות. חכו להודעת <code>Successfully installed</code>.</p>
          </div>
        </div>

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">✍️</div><h3>2 · קובץ חדש ומדביקים</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <p>צרו קובץ חדש בשם <code>app.py</code> והדביקו:</p>
            <div class="code-card">
              <div class="code-card-head"><span>app.py</span><button class="copy-btn" type="button">העתק</button></div>
<pre><span class="k">import</span> streamlit <span class="k">as</span> st
<span class="k">from</span> openai <span class="k">import</span> OpenAI

client = <span class="f">OpenAI</span>()
st.<span class="f">title</span>(<span class="s">"<span class="he">מאמן הכושר שלי 💪</span>"</span>)

<span class="k">if</span> <span class="s">"history"</span> <span class="k">not in</span> st.session_state:
    st.session_state.history = []

<span class="k">for</span> msg <span class="k">in</span> st.session_state.history:
    <span class="k">with</span> st.<span class="f">chat_message</span>(msg[<span class="s">"role"</span>]):
        st.<span class="f">write</span>(msg[<span class="s">"content"</span>])

text = st.<span class="f">chat_input</span>(<span class="s">"<span class="he">כתבו הודעה...</span>"</span>)
<span class="k">if</span> text:
    st.session_state.history.<span class="f">append</span>({<span class="s">"role"</span>: <span class="s">"user"</span>, <span class="s">"content"</span>: text})
    <span class="k">with</span> st.<span class="f">chat_message</span>(<span class="s">"user"</span>):
        st.<span class="f">write</span>(text)
    response = client.responses.<span class="f">create</span>(
        model=<span class="s">"gpt-4o-mini"</span>,
        instructions=<span class="s">"<span class="he">אתה מאמן כושר אנרגטי ומעודד. ענה בעברית, בקצרה.</span>"</span>,
        input=st.session_state.history,
    )
    answer = response.output_text
    st.session_state.history.<span class="f">append</span>({<span class="s">"role"</span>: <span class="s">"assistant"</span>, <span class="s">"content"</span>: answer})
    <span class="k">with</span> st.<span class="f">chat_message</span>(<span class="s">"assistant"</span>):
        st.<span class="f">write</span>(answer)</pre>
            </div>
            <div class="callout warn">
              <span class="ico">⚠️</span>
              <p>רווחים בתחילת שורה הם חלק מהקוד. אחרי ההדבקה שמרו (<code>Ctrl + S</code>).</p>
            </div>
          </div>
        </div>

        <div class="step-card" data-step>
          <div class="step-head"><div class="step-ico">🚀</div><h3>3 · מעלים לאוויר</h3><label class="check"><input type="checkbox" class="step-check"> סיימתי</label></div>
          <div class="step-body">
            <div class="code-card">
              <div class="code-card-head"><span>טרמינל</span><button class="copy-btn" type="button">העתק</button></div>
<pre>python -m streamlit run app.py</pre>
            </div>
            <p style="margin-top:12px;">אחרי כמה שניות ייפתח דפדפן עם האתר שלכם (בכתובת <code>localhost:8501</code>). כתבו הודעה ותראו את הבוט עונה בחלון צ''אט.</p>
            <div class="callout ok">
              <span class="ico">🎉</span>
              <p>זה אתר אמיתי, והוא רץ אצלכם במחשב. כדי לעצור אותו חזרו לטרמינל ולחצו <code>Ctrl + C</code>.</p>
            </div>
            <div class="callout info">
              <span class="ico">💡</span>
              <p>בהרצה הראשונה Streamlit עשוי לבקש כתובת אימייל בטרמינל. אפשר פשוט ללחוץ Enter כדי לדלג.</p>
            </div>
          </div>
        </div>

      </div>

      <div class="callout info">
        <span class="ico">🛠️</span>
        <p>קיבלתם שגיאה? העתיקו אותה ושאלו את ChatGPT מה לתקן (בלי המפתח!).</p>
      </div>
    </div>
  </section>

  <!-- ================= PARTS ================= -->
  <section id="parts">
    <div class="wrap">
      <div class="eyebrow v">מבינים</div>
      <h2 class="section-title">ארבעה חלקים באתר</h2>
      <div class="parts">
        <div class="part"><div class="em">🖼️</div><h4><code style="font-size:.85em">st.title</code> ו-<code style="font-size:.85em">st.write</code></h4><p>מציגים כותרת וטקסט על המסך.</p></div>
        <div class="part"><div class="em">⌨️</div><h4><code style="font-size:.85em">st.chat_input</code></h4><p>תיבת ההקלדה בתחתית. מחזירה את מה שהמשתמש כתב.</p></div>
        <div class="part"><div class="em">💬</div><h4><code style="font-size:.85em">st.chat_message</code></h4><p>בועת צ''אט, עם תפקיד: <code>user</code> או <code>assistant</code>.</p></div>
        <div class="part"><div class="em">🧠</div><h4><code style="font-size:.85em">st.session_state</code></h4><p>הזיכרון של האתר. כאן שומרים את <code>history</code> בין ההרצות.</p></div>
      </div>
      <div class="callout info">
        <span class="ico">💡</span>
        <p>הלולאה <code>while True</code> משיעור 3 נעלמה. Streamlit עצמו חוזר ומריץ את הקוד בכל הודעה חדשה, ולכן לא צריך אותה.</p>
      </div>
    </div>
  </section>

  <!-- ================= AI DESIGN ================= -->
  <section id="ai-design">
    <div class="wrap">
      <div class="eyebrow v">טיפ זהב</div>
      <h2 class="section-title">ביקשו מ-AI לעצב לכם את האתר</h2>
      <p class="lede">לא צריך לדעת עיצוב. יש לכם AI, אז תנו לו לעשות את העבודה: אתם מעתיקים אליו את הקוד שעובד, והוא מחזיר גרסה יפה יותר.</p>

      <div class="ai-opts">
        <a class="ai-opt" href="https://chatgpt.com" target="_blank" rel="noopener"><span class="em">💬</span><b>ChatGPT</b><small>chatgpt.com</small></a>
        <a class="ai-opt" href="https://claude.ai" target="_blank" rel="noopener"><span class="em">🟠</span><b>Claude</b><small>claude.ai</small></a>
        <a class="ai-opt" href="https://gemini.google.com" target="_blank" rel="noopener"><span class="em">🔷</span><b>Gemini</b><small>gemini.google.com</small></a>
      </div>
      <p style="margin-top:12px; font-size:14.5px;">כל אחד מהם מתאים. בחרו את זה שאתם כבר מכירים, ולרובם יש גרסה חינמית מוגבלת.</p>

      <div class="parts">
        <div class="part"><div class="em">💾</div><h4>1 · שומרים גיבוי</h4><p>מעתיקים את <code>app.py</code> לקובץ <code>app_backup.py</code>, כדי שתמיד יהיה לאן לחזור.</p></div>
        <div class="part"><div class="em">📋</div><h4>2 · מעתיקים ל-AI</h4><p>מדביקים באחד מה-AI שלמעלה את ההוראה למטה, ואת הקוד שלכם.</p></div>
        <div class="part"><div class="em">📥</div><h4>3 · מדביקים ומריצים</h4><p>מחליפים את התוכן של <code>app.py</code> בקוד שחזר, שומרים ומרעננים את האתר.</p></div>
        <div class="part"><div class="em">🔁</div><h4>4 · משפרים בצעדים קטנים</h4><p>מבקשים שינוי אחד בכל פעם, כמו "תגדיל את הכותרת" או "תשנה את הצבעים".</p></div>
      </div>

      <div class="code-card">
        <div class="code-card-head"><span>הוראה מוכנה ל-AI</span><button class="copy-btn" type="button">העתק</button></div>
<pre class="he-out">הנה קוד של אפליקציית Streamlit שעובדת (בוט צ''אט). שפר את העיצוב שלה: יישור מימין לשמאל לעברית, פלטת צבעים נעימה, כותרת יפה עם אייקון ועיצוב לבועות הצ''אט. אל תשנה את הלוגיקה ואל תוסיף מפתח API לקוד. החזר לי את הקוד המלא בקובץ אחד.

(כאן מדביקים את הקוד של app.py)</pre>
      </div>

      <div class="callout danger">
        <span class="ico">🚨</span>
        <p><strong>גם כאן:</strong> אם ה-AI הוסיף לקוד שורה עם <code>api_key="sk-..."</code>, מחקו אותה. המפתח נשאר במחשב ולא בקוד.</p>
      </div>
      <div class="callout info">
        <span class="ico">💡</span>
        <p>אם משהו נשבר אחרי השינוי, הדביקו ל-AI את השגיאה והוא יתקן. ואם הכול התקלקל, חוזרים ל-<code>app_backup.py</code>.</p>
      </div>
      <div class="callout ok">
        <span class="ico">📚</span>
        <p><strong>רוצים בקשות מדויקות יותר ל-AI?</strong> יש באתר <a class="plink" href="/courses/prompts" target="_top">קורס פרומפטים</a> נפרד, שמוקדש לנושא הזה בלבד.</p>
      </div>
    </div>
  </section>

  <!-- ================= EXPERIMENTS ================= -->
  <section id="experiments">
    <div class="wrap">
      <div class="eyebrow c">משחקים</div>
      <h2 class="section-title">שני ניסויים</h2>
      <div class="exps">
        <div class="exp">
          <div class="em">🎨</div>
          <div>
            <h4>שנו את הכותרת והדמות</h4>
            <p>שנו את <code>st.title</code> ואת ההנחיה בתוך <code>instructions</code> לדמות אחרת (שף, בלש). שמרו, וב-Streamlit לחצו <strong>Rerun</strong> או רענו את הדף.</p>
          </div>
        </div>
        <div class="exp">
          <div class="em">↔️</div>
          <div>
            <h4>עברית מימין לשמאל</h4>
            <p>הוסיפו מתחת ל-<code>st.title</code> שורה שמיישרת את הדף לימין, ובדקו איך זה נראה:</p>
            <div class="code-card"><pre>st.<span class="f">markdown</span>(<span class="s">"&lt;style&gt;.stApp {direction: rtl;}&lt;/style&gt;"</span>, unsafe_allow_html=<span class="k">True</span>)</pre></div>
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
        <h3>🎯 ארבע משימות</h3>
        <ul id="mission-list">
          <li><label><input type="checkbox"><span>הרצתי את <code>app.py</code> ושוחחתי עם הבוט בדפדפן</span></label></li>
          <li><label><input type="checkbox"><span>החלפתי את הדמות והכותרת וראיתי את השינוי באתר</span></label></li>
          <li><label><input type="checkbox"><span>ביקשתי מ-AI לשפר את העיצוב, והאתר נראה טוב יותר</span></label></li>
          <li><label><input type="checkbox"><span>הראיתי את האתר לאדם אחד בבית, כדי לראות את התגובה 🙂</span></label></li>
        </ul>
        <div class="mission-done" id="mission-done"></div>
      </div>

      <div class="callout warn">
        <span class="ico">🌍</span>
        <p>האתר שלכם רץ כרגע <strong>רק במחשב שלכם</strong>. להעלות אותו לשרת, כך שכל אחד יוכל להשתמש בו, תלמדו בקורס Vibe Coding, שמלמד לפתח עם AI מההתחלה ועד הסוף.</p>
      </div>

      <div class="next-card">
        <div class="eyebrow">בשיעור הבא · שיעור 7</div>
        <h3>כלים</h3>
        <p style="margin-top:6px;">עד עכשיו המודל רק דיבר. בשיעור הבא נלמד אותו להפעיל פונקציות שאנחנו כותבים, ונהפוך אותו מבוט שמדבר לבוט שעושה.</p>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">בונים אפליקציית AI עם OpenAI ו-Python · שיעור 6</div></footer>

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

/* ---------- rerun demo ---------- */
(function () {
  var steps = ["הסקריפט מתחיל מההתחלה", "טוענים את ההיסטוריה", "מציגים את ההודעות הקודמות", "מחכים להודעה חדשה", "שולחים למודל ומציגים תשובה"];
  var stepEls = [];
  var flow = $("flow"), plainBox = $("plain-box"), keepBox = $("keep-box");
  var sent = 0, busy = false, timers = [];
  steps.forEach(function (s, i) {
    var r = el("div", "step-line"); r.appendChild(el("span", "n", String(i + 1))); r.appendChild(el("span", "", s));
    flow.appendChild(r); stepEls.push(r);
  });
  function renderBoxes() {
    plainBox.innerHTML = ""; keepBox.innerHTML = "";
    plainBox.appendChild(el("div", "empty", sent ? "ריק, התאפס בכל הרצה 😬" : "ריק"));
    if (!sent) { keepBox.appendChild(el("div", "empty", "ריק")); return; }
    var c = el("div", "chips");
    for (var i = 1; i <= sent; i++) { c.appendChild(el("span", "chip", "🧑 הודעה " + i)); c.appendChild(el("span", "chip", "🤖 תשובה " + i)); }
    keepBox.appendChild(c);
  }
  function clearTimers() { timers.forEach(clearTimeout); timers = []; }
  $("send").addEventListener("click", function () {
    if (busy) return; busy = true; $("send").disabled = true;
    stepEls.forEach(function (r) { r.classList.remove("on"); });
    stepEls.forEach(function (r, i) {
      timers.push(setTimeout(function () {
        stepEls.forEach(function (x, j) { x.classList.toggle("on", j === i); });
      }, i * 380));
    });
    timers.push(setTimeout(function () {
      sent++; renderBoxes(); busy = false; $("send").disabled = false;
    }, steps.length * 380));
  });
  $("reset").addEventListener("click", function () {
    clearTimers(); sent = 0; busy = false; $("send").disabled = false;
    stepEls.forEach(function (r) { r.classList.remove("on"); });
    renderBoxes();
  });
  renderBoxes();
})();

/* ---------- quiz ---------- */
(function () {
  var qs = [
    { q: "מה עושה Streamlit?", opts: ["הופך סקריפט פייתון לאתר, בלי HTML ובלי עיצוב", "מחליף את OpenAI", "משפר את התשובות של המודל"], ok: 0, why: "Streamlit עוטפת את הקוד שלנו בממשק web: כותרות, תיבות הקלדה, בועות צ''אט ועוד." },
    { q: "למה צריך st.session_state?", opts: ["כי Streamlit מריץ את כל הסקריפט מחדש בכל לחיצה, ומשתנה רגיל מתאפס", "כדי לחבר ל-OpenAI", "כדי להסתיר את המפתח"], ok: 0, why: "כל מה שצריך לזכור בין הרצות, כמו היסטוריית השיחה, נשמר ב-session_state." },
    { q: "איך עוצרים את האתר שרץ במחשב?", opts: ["סוגרים את הדפדפן", "חוזרים לטרמינל ולוחצים Ctrl + C", "מוחקים את הקובץ app.py"], ok: 1, why: "האתר רץ מתוך הטרמינל. סגירת הדפדפן לא עוצרת אותו, ו-Ctrl + C עוצר." }
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
    $("mission-done").textContent = n === boxes.length ? "🎉 מעולה! נתראה בשיעור 7, ונלמד את הבוט להפעיל כלים." : (n ? n + " מתוך " + boxes.length + " הושלמו" : "");
  }
  boxes.forEach(function (b) { b.addEventListener("change", upd); });
})();
</script>

</body>
</html>
', 6, '2026-10-13T00:00:00.000Z');
