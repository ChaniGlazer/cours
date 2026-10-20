DELETE FROM lessons WHERE course_id='ai-app-dev' AND slug='lesson-8-summary';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('79df0186af73476aba10927f039e35c6', 'ai-app-dev', 'lesson-8-summary', 'שיעור 8 - סיכום ופרויקט סיום', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור 8 — סיכום ופרויקט סיום</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;700;800;900&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #07191B;
    --bg-panel: #0E2A2D;
    --bg-panel-2: #14393D;
    --ink: #F2FBF8;
    --ink-dim: #A8C7C3;
    --ink-faint: #6B8F8C;
    --cyan: #FFB547;
    --cyan-soft: #3B2B0E;
    --violet: #5EEAD4;
    --violet-soft: #0F3A36;
    --success: #9BE564;
    --success-soft: #1E3A12;
    --danger: #FF6B6B;
    --danger-soft: #3E1D22;
    --warn: #FF9F6B;
    --warn-soft: #3F2316;
    --line: rgba(242,251,248,0.10);
    --line-strong: rgba(242,251,248,0.22);
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
      radial-gradient(700px 420px at 12% -5%, rgba(255,181,71,0.12), transparent 60%),
      radial-gradient(700px 420px at 100% 18%, rgba(94,234,212,0.12), transparent 60%),
      var(--bg);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 17px;
    line-height: 1.7;
    -webkit-font-smoothing: antialiased;
  }
  ::selection { background: var(--cyan); color: #1c1203; }

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
  .callout.warn { background: var(--warn-soft); border-color: rgba(255,159,107,.45); }
  .callout.danger { background: var(--danger-soft); border-color: rgba(255,107,107,.5); }
  .callout.info { background: var(--cyan-soft); border-color: rgba(255,181,71,.4); }
  .callout.ok { background: var(--success-soft); border-color: rgba(155,229,100,.45); }

  .btn { font-family: var(--display); font-weight: 800; font-size: 14px; color: #1c1203; background: var(--cyan); border: none; border-radius: 100px; padding: 7px 18px; }
  .copy-btn { font-size: 12.5px; font-weight: 700; color: var(--cyan); background: transparent; border: 1px solid var(--line-strong); border-radius: 100px; padding: 4px 12px; }
  .copy-btn:hover { border-color: var(--cyan); }
  .link-btn { display: inline-flex; align-items: center; gap: 8px; margin-top: 10px; font-family: var(--display); font-weight: 700; font-size: 14.5px; color: var(--cyan); background: var(--cyan-soft); border: 1px solid var(--cyan); border-radius: 100px; padding: 7px 18px; text-decoration: none; }
  .link-btn:hover { background: var(--cyan); color: #1c1203; }

  /* ---------- journey map ---------- */
  .path { margin-top: 28px; display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; }
  @media (max-width: 600px) { .path { grid-template-columns: repeat(4, 1fr); } }
  .node { text-align: center; background: transparent; border: none; color: var(--ink); padding: 4px 0; }
  .node .bd { width: 52px; height: 52px; margin: 0 auto 6px; border-radius: 16px; background: var(--bg-panel-2); border: 2px solid var(--line-strong); display: flex; align-items: center; justify-content: center; font-size: 24px; transition: all .25s; }
  .node .nl { font-size: 12.5px; font-weight: 700; color: var(--ink-dim); }
  .node:hover .bd { border-color: var(--ink-dim); }
  .node.on .bd { border-color: var(--cyan); background: var(--cyan-soft); box-shadow: 0 0 22px rgba(255,181,71,.3); transform: translateY(-3px); }
  .node.on .nl { color: var(--cyan); }
  .path-text { margin-top: 18px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 14px 18px; min-height: 76px; }
  .path-text h4 { font-size: 16.5px; color: var(--cyan); margin-bottom: 2px; }
  .path-text p { font-size: 15.5px; color: var(--ink); }

  /* ---------- ideas ---------- */
  .ideas { margin-top: 24px; display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; }
  @media (max-width: 600px) { .ideas { grid-template-columns: 1fr 1fr; } }
  .idea { text-align: center; background: var(--bg-panel); border: 1px solid var(--line-strong); border-radius: 14px; padding: 12px 8px; color: var(--ink); font-size: 14.5px; font-weight: 700; }
  .idea .em { font-size: 28px; display: block; line-height: 1.2; }
  .idea:hover { border-color: var(--ink-dim); }
  .idea.on { border-color: var(--violet); background: var(--violet-soft); }
  .idea-card { margin-top: 14px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 16px 18px; }
  .idea-card h4 { font-size: 17px; margin-bottom: 8px; }
  .note { background: #3B2F0E; border: 1px solid rgba(255,181,71,.45); border-radius: 12px; padding: 10px 14px; font-size: 15px; color: var(--ink); }
  .note-head { display: flex; justify-content: space-between; align-items: center; gap: 8px; font-family: var(--display); font-size: 12.5px; font-weight: 800; color: var(--cyan); margin-bottom: 4px; }
  .idea-extra { margin-top: 10px; font-size: 14.5px; color: var(--ink-dim); }

  /* ---------- checklist ---------- */
  .check-box { margin-top: 24px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 18px 20px; }
  .check-box h4 { font-size: 16px; margin: 4px 0 8px; }
  .check-box h4:not(:first-child) { margin-top: 18px; }
  .check-box label { display: flex; gap: 12px; align-items: flex-start; color: var(--ink); font-size: 16px; cursor: pointer; margin: 6px 0; }
  .check-box input { width: 20px; height: 20px; margin-top: 4px; accent-color: var(--success); flex-shrink: 0; }
  .check-box input:checked + span { color: var(--ink-faint); text-decoration: line-through; }
  .bar { margin-top: 16px; height: 10px; border-radius: 8px; background: var(--bg-panel-2); overflow: hidden; }
  .bar i { display: block; height: 100%; width: 0; background: linear-gradient(90deg, var(--cyan), var(--success)); transition: width .3s; }
  .final-msg { margin-top: 12px; font-family: var(--display); font-weight: 800; color: var(--success); min-height: 26px; }

  /* ---------- tips ---------- */
  .tips { margin-top: 20px; display: grid; gap: 10px; }
  .tip { display: flex; gap: 12px; align-items: flex-start; background: var(--bg-panel); border: 1px solid var(--line); border-radius: 14px; padding: 12px 16px; font-size: 15.5px; color: var(--ink); }
  .tip .em { font-size: 22px; line-height: 1.4; }

  /* ---------- next ---------- */
  .nexts { margin-top: 24px; display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
  @media (max-width: 600px) { .nexts { grid-template-columns: 1fr; } }
  .next { background: var(--bg-panel); border: 1px solid var(--line); border-radius: 16px; padding: 16px 18px; }
  .next .em { font-size: 30px; line-height: 1.2; }
  .next h4 { font-size: 16.5px; margin: 4px 0 2px; }
  .next p { font-size: 14.5px; }
  .next .soon { display: inline-block; margin-top: 10px; font-size: 13px; font-weight: 700; color: var(--ink-faint); border: 1px dashed var(--line-strong); border-radius: 100px; padding: 3px 14px; }

  .bye { margin-top: 28px; background: linear-gradient(135deg, var(--cyan-soft), var(--violet-soft)); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 24px 26px; text-align: center; }
  .bye h3 { font-size: 22px; }
  .bye p { margin-top: 6px; color: var(--ink); }

  footer { padding: 44px 0 70px; text-align: center; color: var(--ink-faint); font-size: 14px; }
</style>
</head>
<body>

<div class="scroll-progress" aria-hidden="true"><i id="scroll-bar"></i></div>

<div class="topbar">
  <div class="wrap topbar-inner">
    <span class="course">בונים אפליקציית AI עם OpenAI ו-Python</span>
    <span class="lesson-chip">שיעור 8</span>
  </div>
</div>

<!-- ================= HERO ================= -->
<header class="hero">
  <div class="wrap">
    <div class="eyebrow c" style="text-align:center;">שיעור 8 · סיכום ופרויקט סיום</div>
    <h1>הגעתם לסוף, <span class="a1">ועכשיו</span><br>בונים את <span class="a2">שלכם</span></h1>
    <p class="hero-sub">בשבעה שיעורים עברתם דרך ארוכה: ממפתח API ועד אתר שמפעיל כלים. בשיעור האחרון נסכם, ותבנו אפליקציה משלכם.</p>
    <div class="time-row">
      <span class="pill">⏱ כ-45 דקות</span>
      <span class="pill">🏆 פרויקט סיום</span>
      <span class="pill">🧭 מה הלאה</span>
    </div>
    <div class="morph" aria-hidden="true">🔑 → 🌐 → 🏆</div>
  </div>
</header>

<main>

  <!-- ================= RECAP ================= -->
  <section id="recap">
    <div class="wrap">
      <div class="eyebrow">מה בניתם</div>
      <h2 class="section-title">המסע שלכם בשבעה צעדים</h2>
      <p class="lede">לחצו על כל תחנה, ותזכרו מה למדתם בה:</p>
      <div class="path" id="path"></div>
      <div class="path-text" id="path-text"></div>
    </div>
  </section>

  <!-- ================= PROJECT ================= -->
  <section id="project">
    <div class="wrap">
      <div class="eyebrow c">פרויקט הסיום</div>
      <h2 class="section-title">מה תבנו?</h2>
      <p class="lede">בחרו רעיון, או המציאו משלכם. לחצו על רעיון כדי לקבל הנחיה להתחלה:</p>

      <div class="ideas" id="ideas"></div>
      <div class="idea-card" id="idea-card"></div>

      <div class="callout info">
        <span class="ico">🛠️</span>
        <p><strong>איך מתחילים:</strong> קחו את <code>app.py</code> משיעור 6, שמרו ממנו עותק, והחליפו את ההנחיה ב-<code>instructions</code> להנחיה של הרעיון שבחרתם. זה כבר פרויקט עובד, ומשם מוסיפים.</p>
      </div>
    </div>
  </section>

  <!-- ================= CHECKLIST ================= -->
  <section id="checklist">
    <div class="wrap">
      <div class="eyebrow v">רשימת בדיקה</div>
      <h2 class="section-title">מתי הפרויקט מוכן?</h2>

      <div class="check-box">
        <h4>חובה</h4>
        <label><input type="checkbox" class="req"><span>🎭 לבוט יש דמות והנחיות משלו</span></label>
        <label><input type="checkbox" class="req"><span>📒 הוא זוכר את השיחה (<code>session_state</code>)</span></label>
        <label><input type="checkbox" class="req"><span>🌐 הוא רץ באתר עם חלון צ''אט (Streamlit)</span></label>
        <h4>בונוס</h4>
        <label><input type="checkbox"><span>📋 הוא מחזיר פלט מסודר (JSON) ומציג אותו יפה</span></label>
        <label><input type="checkbox"><span>🛠️ יש לו כלי אחד לפחות</span></label>
        <label><input type="checkbox"><span>🎨 ביקשתי מ-AI לשפר את העיצוב</span></label>
        <div class="bar"><i id="bar"></i></div>
        <div class="final-msg" id="final-msg"></div>
      </div>

      <div class="tips">
        <div class="tip"><span class="em">🔁</span><span>שנו דבר אחד בכל פעם, והריצו. כך קל לדעת מה שבר.</span></div>
        <div class="tip"><span class="em">💾</span><span>שמרו גיבוי של גרסה שעובדת לפני כל שינוי גדול.</span></div>
        <div class="tip"><span class="em">🤖</span><span>נתקעתם? העתיקו את השגיאה ל-ChatGPT או ל-Claude ושאלו מה לתקן.</span></div>
        <div class="tip"><span class="em">🔑</span><span>המפתח נשאר במחשב ולא בקוד, וגם לא בצילומי מסך.</span></div>
      </div>
    </div>
  </section>

  <!-- ================= NEXT ================= -->
  <section id="next">
    <div class="wrap">
      <div class="eyebrow c">ובהמשך</div>
      <h2 class="section-title">מה אפשר ללמוד עכשיו?</h2>

      <div class="callout warn">
        <span class="ico">🌍</span>
        <p>האתר שלכם רץ כרגע <strong>רק במחשב שלכם</strong>. כדי שכל אחד יוכל להשתמש בו, צריך להעלות אותו לשרת. את זה, ועוד הרבה, תלמדו בקורס Vibe Coding.</p>
      </div>

      <div class="nexts">
        <div class="next">
          <div class="em">🚀</div>
          <h4>לפתח עם AI, מההתחלה ועד הסוף</h4>
          <p>איך בונים תוכנה בשיחה עם AI, מהרעיון ועד אפליקציה מוכנה, כולל העלאה לשרת, כך שיהיה לה קישור שאפשר לשלוח לחברים.</p>
          <a class="link-btn" href="/courses/vibe-coding" target="_top">לקורס Vibe Coding ↗</a>
        </div>
        <div class="next">
          <div class="em">✍️</div>
          <h4>פרומפטים מקצועיים</h4>
          <p>איך לבקש מה-AI בדיוק מה שאתם צריכים, ולשפר את ההנחיות של הבוט שלכם.</p>
          <span class="soon">קורס פרומפטים, בקרוב</span>
        </div>
      </div>

      <div class="bye">
        <h3>כל הכבוד! 🎉</h3>
        <p>הפכתם ממשתמשים של AI ליוצרים של אפליקציות AI. תראו למישהו את מה שבניתם.</p>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">בונים אפליקציית AI עם OpenAI ו-Python · שיעור 8</div></footer>

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

/* ---------- journey recap ---------- */
(function () {
  var nodes = [
    { e: "🔑", n: "מפתח", t: "שיעור 1 · המפתח", x: "יצרתם מפתח API ושמרתם אותו בצורה מאובטחת, מחוץ לקוד." },
    { e: "💌", n: "קריאה", t: "שיעור 2 · הקריאה הראשונה", x: "שלחתם שאלה למודל וקיבלתם תשובה, מקוד שכתבתם בעצמכם." },
    { e: "📒", n: "זיכרון", t: "שיעור 3 · שיחה עם זיכרון", x: "הבנתם שהמודל לא זוכר, ושלחתם לו את השיחה כולה בכל פעם." },
    { e: "🎭", n: "אישיות", t: "שיעור 4 · אישיות והנחיות", x: "נתתם לבוט דמות בעזרת הנחיות, ושלטתם ביצירתיות עם temperature." },
    { e: "📋", n: "פלט", t: "שיעור 5 · פלט מסודר", x: "ביקשתם JSON, והקוד שלכם פירק אותו לשדות ושלט בתצוגה." },
    { e: "🌐", n: "אתר", t: "שיעור 6 · ממשק web", x: "עטפתם את הבוט באתר עם חלון צ''אט, בעזרת Streamlit." },
    { e: "🛠️", n: "כלים", t: "שיעור 7 · כלים", x: "נתתם למודל כלים: פונקציות שלכם שהוא מבקש להפעיל." }
  ];
  var box = $("path"), txt = $("path-text");
  var btns = [];
  function pick(i) {
    btns.forEach(function (b, j) { b.classList.toggle("on", j === i); });
    txt.innerHTML = "";
    txt.appendChild(el("h4", "", nodes[i].t));
    txt.appendChild(el("p", "", nodes[i].x));
  }
  nodes.forEach(function (n, i) {
    var b = el("button", "node"); b.type = "button";
    b.appendChild(el("div", "bd", n.e)); b.appendChild(el("div", "nl", n.n));
    b.addEventListener("click", function () { pick(i); });
    box.appendChild(b); btns.push(b);
  });
  pick(6);
})();

/* ---------- ideas ---------- */
(function () {
  var ideas = [
    { e: "💪", n: "מאמן כושר אישי", i: "אתה מאמן כושר אישי ותומך. בנה תוכניות אימון לפי הרצונות של המשתמש, ענה בעברית ובקצרה.", x: "רעיון לבונוס: פלט מסודר, תוכנית אימון כרשימה עם תרגילים, סטים וחזרות." },
    { e: "👨‍🍳", n: "שף ביתי", i: "אתה שף ביתי חם וסבלני. הצע מתכונים לפי המצרכים שיש למשתמש בבית, ענה בעברית ובקצרה.", x: "רעיון לבונוס: כלי שממיר מידות (כוסות לגרמים)." },
    { e: "🕵️", n: "בלש משחקי", i: "אתה בלש שמנהל משחק תעלומה. תן רמזים אחד אחד, חכה לניחושים של המשתמש וענה בעברית.", x: "רעיון לבונוס: הזיכרון חשוב כאן, הבוט צריך לזכור את כל הרמזים." },
    { e: "🧳", n: "מתכנן טיולים", i: "אתה מתכנן טיולים נלהב. תכנן יום טיול לפי ההעדפות והתקציב של המשתמש, ענה בעברית.", x: "רעיון לבונוס: פלט מסודר, לוח זמנים עם שעות ותחנות." },
    { e: "📚", n: "חבר ללימוד", i: "אתה חבר ללימוד סבלני. הסבר נושאים בפשטות, ושאל שאלות בדיקה כדי לוודא הבנה. ענה בעברית.", x: "רעיון לבונוס: פלט מסודר, שאלות בחירה עם תשובה נכונה." },
    { e: "🎭", n: "דמות משלי", i: "אתה [מי הדמות]. אתה מדבר [איך], יודע [על מה], וענה תמיד בעברית ובקצרה.", x: "מלאו את הסוגריים ברעיון שלכם. כל רעיון מתאים." }
  ];
  var box = $("ideas"), card = $("idea-card");
  var btns = [];
  function pick(k) {
    var d = ideas[k];
    btns.forEach(function (b, j) { b.classList.toggle("on", j === k); });
    card.innerHTML = "";
    card.appendChild(el("h4", "", d.e + " " + d.n));
    var note = el("div", "note");
    var head = el("div", "note-head");
    head.appendChild(el("span", "", "📝 הנחיה להתחלה (instructions)"));
    var cp = el("button", "copy-btn", "העתק"); cp.type = "button";
    cp.addEventListener("click", function () {
      function done(ok) { cp.textContent = ok ? "הועתק ✓" : "סמנו והעתיקו ידנית"; setTimeout(function () { cp.textContent = "העתק"; }, 1600); }
      function fallback() {
        var ok = false;
        try {
          var ta = document.createElement("textarea");
          ta.value = d.i; ta.setAttribute("readonly", "");
          ta.style.cssText = "position:fixed;top:0;left:0;opacity:0;";
          document.body.appendChild(ta); ta.select();
          ok = document.execCommand("copy");
          document.body.removeChild(ta);
        } catch (e) {}
        done(ok);
      }
      try { navigator.clipboard.writeText(d.i).then(function () { done(true); }, fallback); } catch (e) { fallback(); }
    });
    head.appendChild(cp);
    note.appendChild(head);
    note.appendChild(document.createTextNode(d.i));
    card.appendChild(note);
    card.appendChild(el("div", "idea-extra", d.x));
  }
  ideas.forEach(function (d, k) {
    var b = el("button", "idea"); b.type = "button";
    b.appendChild(el("span", "em", d.e)); b.appendChild(document.createTextNode(d.n));
    b.addEventListener("click", function () { pick(k); });
    box.appendChild(b); btns.push(b);
  });
  pick(0);
})();

/* ---------- checklist ---------- */
(function () {
  var all = document.querySelectorAll(".check-box input");
  var reqs = document.querySelectorAll(".check-box input.req");
  function upd() {
    var r = 0, a = 0;
    all.forEach(function (c) { if (c.checked) a++; });
    reqs.forEach(function (c) { if (c.checked) r++; });
    if (window.reportProgress) window.reportProgress(r, reqs.length);
    $("bar").style.width = (a / all.length * 100) + "%";
    $("final-msg").textContent = r === reqs.length ? "🏆 הפרויקט שלכם מוכן! אפשר להראות אותו למישהו." : (a ? r + " מתוך " + reqs.length + " תנאי חובה הושלמו" : "");
  }
  all.forEach(function (c) { c.addEventListener("change", upd); });
  if (window.reportProgress) window.reportProgress(0, reqs.length);
})();
</script>

</body>
</html>
', 8, '2026-10-20T00:00:00.000Z');
