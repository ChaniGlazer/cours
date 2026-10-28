DELETE FROM lessons WHERE course_id='vibe-coding' AND slug='lesson-2-ai-vs-regular';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('d4a7e1c93b5f4268a0c7f2e9b13d6a85', 'vibe-coding', 'lesson-2-ai-vs-regular', 'שיעור 2 - איך פיתוח עם AI שונה מפיתוח רגיל', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>איך פיתוח עם AI שונה מפיתוח רגיל — שיעור 2</title>
<style>
html,body{margin:0;background:transparent}
</style>
</head>
<body>
<div class="cbl" id="cbl-2" dir="rtl" lang="he">

<style>
@import url(''https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap'');
.cbl{--bg:#14121f;--panel:#1d1a2d;--line:#3a3558;--ink:#f4f1fa;--mut:#bdb7d3;--c1:#ff7f96;--c2:#8fb8ff;--c3:#ffd27a;--ok:#6fe0a0;--bad:#ff7f96;--gold:#ffd27a;--or:#ffd27a;--display:''Secular One'',''Arial Hebrew'',Arial,sans-serif;
  position:relative;overflow:hidden;width:100%;max-width:100%;margin:0;padding:26px max(16px,calc((100% - 960px)/2)) 56px;border-radius:0;color:var(--ink);font-family:''Assistant'',system-ui,-apple-system,''Segoe UI'',Arial,sans-serif;font-size:17px;line-height:1.75;box-sizing:border-box;
  background:transparent}
html,body{overflow-x:clip}
.cbl *{box-sizing:border-box;min-width:0}
.cbl h1,.cbl h2,.cbl h3,.cbl h4,.cbl p,.cbl ul{margin:0}
.cbl code{font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace;unicode-bidi:isolate}
.cbl a{color:var(--c2)}
.cbl.js .rv{opacity:0;transform:translateY(26px);transition:opacity .8s ease,transform .8s ease}
.cbl.js .rv.in{opacity:1;transform:none}
.cbl .grad{background:linear-gradient(90deg,var(--c2),var(--c1) 50%,var(--c3));-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent}

/* hero */
.cbl .hero{position:relative;padding:36px 6px 14px;text-align:center}
.cbl .kick{display:inline-flex;gap:8px;align-items:center;background:var(--panel);border:1px solid var(--line);padding:7px 18px;border-radius:999px;font-size:14px;color:var(--c2);font-weight:700;margin-bottom:20px}
.cbl .kick:before{content:"";width:8px;height:8px;border-radius:50%;background:var(--ok)}
.cbl h1{font-size:clamp(36px,8vw,64px);line-height:1.1}
.cbl .sub{color:var(--mut);font-size:19px;margin:16px auto 24px;max-width:580px}

/* windows */
.cbl .win{direction:ltr;text-align:left;background:#0e0c17;border:1px solid var(--line);border-radius:16px;overflow:hidden;box-shadow:0 18px 40px -20px rgba(0,0,0,.6)}
.cbl .win.hero-t{max-width:660px;margin:0 auto}
.cbl .wbar{display:flex;gap:7px;align-items:center;padding:10px 14px;background:rgba(244,241,250,.06)}
.cbl .wbar i{width:12px;height:12px;border-radius:50%;display:block}
.cbl .wbar i:nth-child(1){background:#ff5f57}.cbl .wbar i:nth-child(2){background:#febc2e}.cbl .wbar i:nth-child(3){background:#28c840}
.cbl .wbar span{margin-left:10px;font-size:12px;color:var(--mut);font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace}
.cbl .wbar em{margin-left:auto;font-style:normal;font-size:12px;color:var(--mut)}
.cbl .tbody{padding:16px 18px;font-size:14.5px;min-height:150px;line-height:1.8;font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace}
.cbl .tbody .p{color:var(--c2)}.cbl .tbody .g{color:var(--ok)}.cbl .tbody .m{color:var(--mut)}
.cbl pre.cmd{margin:0;padding:14px 16px;font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace;font-size:14.5px;color:var(--ok);white-space:pre-wrap;word-break:break-word;line-height:1.75}
.cbl pre.cmd .h{color:var(--c2);font-weight:800}
.cbl pre.file{color:#f4f1fa;font-size:13.5px}
.cbl .code{counter-reset:ln;padding:8px 6px}
.cbl .code div{counter-increment:ln;display:flex;gap:14px;padding:3px 12px;border-radius:8px;white-space:pre;font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace;font-size:13.5px;color:#f4f1fa;overflow:hidden}
.cbl .code div:before{content:counter(ln);width:16px;text-align:right;color:#9e97ba;flex:none}
.cbl .code .bug{background:rgba(255,127,150,.22);color:#ffc2d6}
.cbl .code .fix{background:rgba(111,224,160,.16);color:var(--ok)}
.cbl .tag{display:inline-flex;align-items:center;gap:6px;font-size:13px;font-weight:800;padding:3px 12px;border-radius:99px;margin-bottom:8px}
.cbl .tag.r{background:rgba(255,127,150,.2);color:#ffc2d6}
.cbl .tag.g{background:rgba(111,224,160,.2);color:#c4f2d9}

/* sections */
.cbl .sec{margin-top:76px}
.cbl .sh{display:flex;align-items:center;gap:14px;margin-bottom:12px}
.cbl .sh .ic{width:52px;height:52px;border-radius:16px;display:flex;align-items:center;justify-content:center;font-size:26px;flex:none;background:rgba(255,127,150,.16);border:1px solid rgba(255,127,150,.4)}
.cbl .sh h2{font-size:clamp(26px,5vw,36px);line-height:1.2}
.cbl h3{font-size:clamp(21px,4vw,27px);line-height:1.3;margin-bottom:10px}
.cbl .lead{color:var(--mut);margin-bottom:18px;max-width:720px}
.cbl p{color:#e6e1f2}
.cbl p+p{margin-top:10px}
.cbl .row2{display:grid;grid-template-columns:1fr 1fr;gap:28px;align-items:center}
.cbl .row2.top{align-items:start}
.cbl .stag{display:inline-block;font-size:13px;font-weight:800;padding:3px 14px;border-radius:99px;background:var(--c1);color:#14121f;margin-bottom:10px}
.cbl .block{margin-top:56px}

/* lanes */
.cbl .lanes{display:grid;grid-template-columns:1fr 1fr;gap:16px}
.cbl .lane{position:relative;border-radius:24px;padding:20px 18px 18px;border:1px solid var(--line);background:var(--panel);overflow:hidden}
.cbl .lane:before{content:"";position:absolute;inset:0 0 auto 0;height:4px}
.cbl .lane.old:before{background:linear-gradient(90deg,#4d4775,#bdb7d3)}
.cbl .lane.new{background:linear-gradient(160deg,rgba(255,127,150,.16),rgba(143,184,255,.08));border-color:rgba(255,127,150,.5)}
.cbl .lane.new:before{background:linear-gradient(90deg,var(--c2),var(--c1),var(--c3))}
.cbl .lane h4{display:flex;align-items:center;gap:10px;font-size:20px;margin:0 0 4px}
.cbl .lane h4 span{font-size:28px}
.cbl .lane .meta{color:var(--mut);font-size:14px;margin-bottom:14px}
.cbl .node{display:flex;align-items:center;gap:12px;padding:9px 12px;border-radius:14px;background:rgba(244,241,250,.05);border:1px solid var(--line);font-weight:700}
.cbl .node .e{width:36px;height:36px;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:19px;flex:none;background:rgba(255,210,122,.18)}
.cbl .node.ai{background:rgba(143,184,255,.14);border-color:rgba(143,184,255,.6)}
.cbl .node.ai .e{background:rgba(143,184,255,.3)}
.cbl .node small{margin-right:auto;font-size:12px;font-weight:800;padding:2px 10px;border-radius:99px;background:rgba(255,210,122,.18);color:#ffd27a}
.cbl .node.ai small{background:rgba(143,184,255,.22);color:#cfe0ff}
.cbl .arr{height:14px;display:flex;align-items:center;justify-content:center;color:var(--mut);font-size:12px;line-height:1}
.cbl .share{display:flex;gap:4px;margin-top:14px}
.cbl .share i{flex:1;height:9px;border-radius:99px;background:var(--c3)}
.cbl .share i.a{background:var(--c2)}
.cbl .punch{margin-top:20px;text-align:center;font-size:clamp(19px,4vw,24px);font-weight:700;padding:18px 16px;border-radius:20px;background:linear-gradient(90deg,rgba(255,127,150,.22),rgba(143,184,255,.18));border:1px solid rgba(255,127,150,.45)}

/* route */
.cbl .route{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin:4px 0 8px}
.cbl .route span{display:inline-flex;align-items:center;gap:8px;padding:6px 14px 6px 12px;border-radius:99px;background:var(--panel);border:1px solid var(--line);font-size:14.5px;font-weight:700}
.cbl .route b{width:24px;height:24px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;background:var(--c1);color:#14121f}
.cbl .route i{font-style:normal;color:var(--mut)}

/* feature points */
.cbl .pts{display:grid;gap:8px;margin-top:12px;padding:0;list-style:none}
.cbl .pts li{display:flex;gap:10px;align-items:flex-start;font-size:15.5px;color:#e6e1f2}
.cbl .pts li:before{content:"";width:9px;height:9px;border-radius:50%;margin-top:11px;flex:none;background:var(--k,var(--c2))}
.cbl .pts code{background:rgba(255,210,122,.16);color:var(--or);padding:0 8px;border-radius:6px;font-size:13px;font-weight:700}
.cbl .twin{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-top:22px}
.cbl .box{display:flex;gap:12px;align-items:flex-start;padding:14px 16px;border-radius:16px;font-size:15.5px;line-height:1.65}
.cbl .box>i{font-style:normal;font-size:22px;flex:none;line-height:1.3}
.cbl .box.tip{background:rgba(143,184,255,.1);border:1px solid rgba(143,184,255,.45)}
.cbl .box.cav{background:rgba(255,210,122,.1);border:1px solid rgba(255,210,122,.45)}
.cbl .box b{color:var(--c2)}.cbl .box.cav b{color:var(--gold)}
.cbl .box code{background:rgba(244,241,250,.1);padding:0 7px;border-radius:6px;font-size:13.5px;direction:ltr}
.cbl .diffline{margin-top:14px;padding:12px 16px;border-radius:14px;background:rgba(255,127,150,.12);border:1px solid rgba(255,127,150,.4);font-size:15.5px}
.cbl .diffline b{color:var(--c2)}

/* request */
.cbl .req{padding:10px 12px;display:grid;gap:8px}
.cbl .rl{--k:#8fb8ff;display:flex;gap:12px;align-items:center;justify-content:space-between;padding:9px 12px;border-radius:10px;background:rgba(244,241,250,.04);border-left:4px solid var(--k);font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace;font-size:13.5px;color:#f4f1fa}
.cbl .rl em{font-style:normal;flex:none;font-family:''Assistant'',system-ui,sans-serif;font-size:12.5px;font-weight:800;padding:2px 12px;border-radius:99px;background:var(--k);color:#14121f;direction:rtl}
.cbl .checks{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:16px}
.cbl .checks div{display:flex;gap:10px;align-items:center;padding:12px 14px;border-radius:14px;background:rgba(111,224,160,.1);border:1px solid rgba(111,224,160,.4);font-size:15.5px}

/* challenges, summary, qa */
.cbl .tri{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.cbl .ch{padding:18px;border-radius:20px;background:var(--panel);border:1px solid var(--line)}
.cbl .ch .no{width:42px;height:42px;border-radius:13px;display:flex;align-items:center;justify-content:center;font-family:var(--display);font-size:19px;background:var(--c1);color:#14121f;margin-bottom:10px}
.cbl .ch b{display:block;font-size:18px;margin-bottom:4px}
.cbl .ch span{color:var(--mut);font-size:15px;display:block}
.cbl .ch code{background:rgba(244,241,250,.1);padding:1px 8px;border-radius:6px;color:var(--c2);font-size:13.5px;direction:ltr}
.cbl .sums{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.cbl .sums div{padding:18px;border-radius:20px;background:linear-gradient(160deg,rgba(255,127,150,.14),rgba(244,241,250,.03));border:1px solid var(--line);font-weight:700;font-size:16px}
.cbl .sums i{font-style:normal;font-size:28px;display:block;margin-bottom:6px}
.cbl .qas{display:grid;grid-template-columns:1fr 1fr;gap:12px}
.cbl .qa{padding:16px 18px;border-radius:18px;background:var(--panel);border:1px solid var(--line)}
.cbl .qa b{display:block;font-size:17px;margin-bottom:4px}
.cbl .qa p{color:var(--mut);font-size:15.5px}
.cbl .src{font-size:13px;color:var(--mut);margin-top:14px}

/* הכותרות בגופן הכותרות של האתר (יש לו משקל אחד) */
.cbl h1,.cbl h2,.cbl h3,.cbl h4{font-family:var(--display);font-weight:400}

@media (max-width:760px){
  .cbl{font-size:16px;padding:18px 14px 40px}.cbl .sec{margin-top:56px}.cbl .block{margin-top:44px}
  .cbl .lanes,.cbl .row2,.cbl .twin,.cbl .checks,.cbl .tri,.cbl .sums,.cbl .qas{grid-template-columns:1fr}
  .cbl .row2{gap:16px}.cbl .rl{flex-direction:column;align-items:flex-start;gap:6px}.cbl .code div{font-size:12.5px;padding:3px 8px}
}
@media (prefers-reduced-motion:reduce){.cbl *{animation:none!important;transition:none!important}}
</style>

<!-- ============ HERO ============ -->
<div class="hero">
  <span class="kick">מודול 1 · שיעור 2</span>
  <h1>איך פיתוח עם AI<br><span class="grad">שונה מפיתוח רגיל?</span></h1>
  <p class="sub">נעבור על התהליך האמיתי, מפרויקט ריק ועד שינוי ראשון, ונכתוב את קובץ ה-CLAUDE.md של הפרויקט שלנו.</p>
  <div class="win hero-t">
    <div class="wbar"><i></i><i></i><i></i><span>url-shortener</span></div>
    <div class="tbody" id="cbl-term"></div>
  </div>
</div>

<!-- ============ ההבדל בקצרה ============ -->
<div class="sec rv">
  <div class="sh"><span class="ic">⚖️</span><h2>ההבדל בקצרה</h2></div>
  <p class="lead">אותה משימה, שתי דרכי עבודה. שימו לב מי עושה כל שלב.</p>
  <div class="lanes">
    <div class="lane old">
      <h4><span>🧑‍💻</span>פיתוח רגיל</h4>
      <div class="meta">4 שלבים, כולם אצלכם</div>
      <div class="node"><span class="e">🧠</span>חושבים על הפתרון<small>אתם</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">⌨️</span>כותבים את הקוד<small>אתם</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">▶️</span>מריצים<small>אתם</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">🐞</span>מדבגים<small>אתם</small></div>
      <div class="share"><i></i><i></i><i></i><i></i></div>
    </div>
    <div class="lane new">
      <h4><span>🤖</span>פיתוח עם AI</h4>
      <div class="meta">5 שלבים, ורק אחד אצל ה-AI</div>
      <div class="node"><span class="e">🎯</span>מגדירים מה רוצים<small>אתם</small></div><div class="arr">▼</div>
      <div class="node ai"><span class="e">🤖</span>ה-AI כותב<small>AI</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">👀</span>קוראים וסוקרים<small>אתם</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">✅</span>מריצים ומאמתים<small>אתם</small></div><div class="arr">▼</div>
      <div class="node"><span class="e">🧭</span>מכווינים ומתקנים<small>אתם</small></div>
      <div class="share"><i></i><i class="a"></i><i></i><i></i><i></i></div>
    </div>
  </div>
  <div class="punch">הכתיבה עוברת ל-AI. <span class="grad">השיפוט נשאר אצלכם.</span></div>
</div>

<!-- ============ הדרך ============ -->
<div class="sec rv">
  <div class="sh"><span class="ic">🧭</span><h2>הדרך מפרויקט ריק לשינוי ראשון</h2></div>
  <p class="lead">נבנה את שירות קיצור הקישורים מההתחלה. אלה השלבים, ובהמשך נעבור עליהם אחד אחד.</p>
  <div class="route">
    <span><b>1</b>תיקייה וגיט</span><i>←</i>
    <span><b>2</b>פותחים Claude</span><i>←</i>
    <span><b>3</b>CLAUDE.md</span><i>←</i>
    <span><b>4</b>תוכנית</span><i>←</i>
    <span><b>5</b>בקשה</span><i>←</i>
    <span><b>6</b>בדיקה וקומיט</span>
  </div>

  <!-- שלבים 1-2 -->
  <div class="block row2">
    <div>
      <span class="stag">שלבים 1–2</span>
      <h3>מכינים קרקע ופותחים שיחה</h3>
      <p>קודם כול גיט, כי כל שינוי ש-Claude יעשה אפשר יהיה להחזיר אחורה. אחר כך מפעילים את <code dir="ltr">claude</code> בתוך התיקייה. בפעם הראשונה תתבקשו להתחבר דרך הדפדפן.</p>
      <p>אם הפקודה לא מזוהה, עוד לא התקנתם. זה השיעור הבא.</p>
      <div class="diffline"><b>ההבדל:</b> בפיתוח רגיל פותחים עורך. כאן פותחים שיחה עם סוכן שעובד בתוך תיקיית הפרויקט.</div>
    </div>
    <div class="win">
      <div class="wbar"><i></i><i></i><i></i><span>terminal</span></div>
      <pre class="cmd">mkdir url-shortener
cd url-shortener
git init

claude</pre>
    </div>
  </div>

  <!-- שלב 3 -->
  <div class="block row2 top">
    <div>
      <span class="stag">שלב 3</span>
      <h3>CLAUDE.md: הזיכרון של הפרויקט</h3>
      <p>כל שיחה עם Claude Code מתחילה בלי זיכרון מהשיחה הקודמת. קובץ בשם <code dir="ltr">CLAUDE.md</code> בשורש הפרויקט נטען בתחילת כל שיחה, ולכן שם כותבים מה שנכון תמיד לפרויקט.</p>
      <ul class="pts">
        <li style="--k:#8fb8ff"><span><code>Project</code> על מה עובדים</span></li>
        <li style="--k:#ff7f96"><span><code>Stack</code> איזו שפה ומסד נתונים. בלי זה ה-AI עשוי לבחור בעצמו</span></li>
        <li style="--k:#ffd27a"><span><code>Commands</code> איך מריצים ואיך בודקים</span></li>
        <li style="--k:#6fe0a0"><span><code>Structure</code> איפה כל קובץ</span></li>
        <li style="--k:#8fb8ff"><span><code>Conventions</code> הרגלי קוד שחשוב לכם</span></li>
        <li style="--k:#ff7f96"><span><code>Rules</code> גבולות ברורים, פחות הפתעות</span></li>
      </ul>
    </div>
    <div class="win">
      <div class="wbar"><i></i><i></i><i></i><span>CLAUDE.md</span><em>24 lines</em></div>
      <pre class="cmd file"><span class="h"># URL Shortener</span>
A service that turns a long URL into a short code.
- POST /shorten returns a 6-character code
- GET /{code} redirects to the original URL

<span class="h">## Stack</span>
- Python, FastAPI, SQLite

<span class="h">## Commands</span>
- Run server: uvicorn main:app --reload
- Run tests: pytest

<span class="h">## Structure</span>
- main.py: API routes
- database.py: all SQLite access
- tests/: pytest tests

<span class="h">## Conventions</span>
- Type hints on every function
- Routes never touch the DB directly;
  use functions in database.py

<span class="h">## Rules</span>
- Never commit secrets or .env files
- Run pytest before every commit
- Keep changes small: one feature per change</pre>
    </div>
  </div>
  <div class="twin">
    <div class="box cav"><i>⭐</i><div><b>כלל הזהב:</b> כותבים הוראות שאפשר לבדוק. לא "Write clean code" אלא "Type hints on every function". מומלץ להישאר מתחת ל-200 שורות.</div></div>
    <div class="box tip"><i>💡</i><div><b>בפרויקט קיים</b> אפשר להריץ <code dir="ltr">/init</code> ו-Claude ייצור טיוטה מהקוד. <b>בפרויקט ריק</b> כותבים בעצמכם. כדי לוודא שהקובץ נטען, מריצים <code dir="ltr">/context</code> ומחפשים אותו ברשימת Memory files.</div></div>
  </div>

  <!-- שלבים 4-5 -->
  <div class="block">
    <span class="stag">שלבים 4–5</span>
    <h3>מתכננים ושולחים בקשה קטנה</h3>
    <div class="row2 top" style="margin-bottom:22px">
      <div>
        <p>לפני שנוגעים בקוד עוברים ל-Plan mode. Claude קורא קבצים ומציע תוכנית, ולא עורך שום דבר עד שתאשרו. קוראים אותה ובודקים: אילו קבצים הוא מתכוון לגעת בהם, ואם יש שינוי שלא קשור למשימה.</p>
        <div class="diffline"><b>ההבדל:</b> בפיתוח רגיל מתכננים בראש. כאן מקבלים תוכנית כתובה, ומתקנים אותה לפני שנכתבה שורה.</div>
      </div>
      <div class="win">
        <div class="wbar"><i></i><i></i><i></i><span>terminal</span></div>
        <pre class="cmd">claude --permission-mode plan

# or, inside a session: press Shift+Tab
# until "plan mode on" appears</pre>
      </div>
    </div>
    <p style="margin-bottom:12px">אחרי שהתוכנית נראית טוב, שולחים בקשה קטנה וברורה. זו הבקשה הראשונה שלנו, וליד כל שורה כתוב למה היא שם:</p>
    <div class="win">
      <div class="wbar"><i></i><i></i><i></i><span>prompt</span></div>
      <div class="req">
        <div class="rl" style="--k:#8fb8ff"><span>Create POST /shorten in main.py.</span><em>מטרה: מה בונים ואיפה</em></div>
        <div class="rl" style="--k:#ff7f96"><span>It receives {"url": "..."} and returns a 6-character code.</span><em>פירוט: מה נכנס ומה יוצא</em></div>
        <div class="rl" style="--k:#ffd27a"><span>Store the code and URL in SQLite via database.py.</span><em>אילוץ: לפי ה-CLAUDE.md</em></div>
        <div class="rl" style="--k:#6fe0a0"><span>Add one pytest test for it.</span><em>אימות: איך נדע שזה עובד</em></div>
        <div class="rl" style="--k:#bdb7d3"><span>Don''t change any other file.</span><em>גבולות: מה לא לעשות</em></div>
      </div>
    </div>
    <p style="margin-top:14px">Claude כותב ומציג את השינוי, ובדרך כלל מבקש אישור לפני שהוא עורך קובץ. עכשיו התפקיד שלכם הוא לקרוא:</p>
    <div class="checks">
      <div>✅ הוא נגע רק במה שביקשתם?</div>
      <div>✅ יש שורה שלא הבנתם? שואלים אותו, לא מדלגים.</div>
    </div>
    <div class="diffline"><b>ההבדל:</b> בפיתוח רגיל כותבים שורה אחרי שורה ויודעים מה כתבתם. כאן קוראים קוד שלא כתבתם, ואחראים עליו. זה הכישור המרכזי.</div>
  </div>

  <!-- שלב 6 -->
  <div class="block">
    <span class="stag">שלב 6</span>
    <h3>מריצים, בודקים ועושים commit</h3>
    <p>"הבדיקות עברו" אומר רק שמה שנבדק עובד. צריך לשאול גם מה לא נבדק. הנה קוד ש-Claude עשוי לכתוב לפרויקט שלנו. הוא רץ בלי שגיאות, ובכל זאת יש בו באג:</p>
    <div class="row2 top" style="margin-top:18px">
      <div>
        <span class="tag r">❌ לפני</span>
        <div class="win"><div class="wbar"><i></i><i></i><i></i><span>main.py</span></div>
        <div class="code">
          <div>def shorten(url):</div>
          <div>    code = random_code(6)</div>
          <div class="bug">    links[code] = url   # ⚠️ bug</div>
          <div>    return "sho.rt/" + code</div>
        </div></div>
      </div>
      <div>
        <span class="tag g">✅ אחרי</span>
        <div class="win"><div class="wbar"><i></i><i></i><i></i><span>main.py</span></div>
        <div class="code">
          <div>def shorten(url):</div>
          <div>    code = random_code(6)</div>
          <div class="fix">    while code in links:</div>
          <div class="fix">        code = random_code(6)</div>
          <div>    links[code] = url</div>
          <div>    return "sho.rt/" + code</div>
        </div></div>
      </div>
    </div>
    <p style="margin-top:16px">אם הקוד האקראי כבר קיים, השורה המסומנת <b>דורסת את הקישור של מישהו אחר</b>. אין שגיאה, והקוד "עובד". רק מי שקורא ובודק מגלה את זה. אחרי שהכול נבדק, עושים commit:</p>
    <div class="win" style="margin-top:12px;max-width:640px">
      <div class="wbar"><i></i><i></i><i></i><span>terminal</span></div>
      <pre class="cmd">pytest

# then, inside the session:
commit my changes with a descriptive message</pre>
    </div>
    <div class="diffline"><b>ההבדל:</b> ה-AI מדווח "הכול עובד" גם כשיש באג שקט, ולכן מוודאים בעצמכם. ועושים commit על כל צעד קטן, כדי שאפשר יהיה לחזור אחורה.</div>
  </div>
</div>

<!-- ============ אתגרים ============ -->
<div class="sec rv">
  <div class="sh"><span class="ic">🎯</span><h2>שלושה אתגרים</h2></div>
  <div class="tri">
    <div class="ch"><div class="no">1</div><b>📁 הכינו את הקרקע</b><span>צרו תיקייה בשם <code>url-shortener</code> והריצו בתוכה <code>git init</code>. את Claude Code נתקין בשיעור הבא.</span></div>
    <div class="ch"><div class="no">2</div><b>📝 כתבו CLAUDE.md</b><span>העתיקו את הקובץ משלב 3, שמרו אותו בתיקייה והוסיפו שורה אחת משלכם. ודאו שהיא קונקרטית ואפשר לאמת אותה.</span></div>
    <div class="ch"><div class="no">3</div><b>🔍 חפשו באג</b><span>בקשו מכל צ''אט AI לכתוב את הפונקציה <code>shorten(url)</code>, וחפשו בה את הבאג משלב 6 או באג דומה.</span></div>
  </div>
</div>

<!-- ============ סיכום ============ -->
<div class="sec rv">
  <div class="sh"><span class="ic">🏁</span><h2>מה למדנו?</h2></div>
  <div class="sums">
    <div><i>🪜</i>התהליך: תיקייה וגיט, Claude Code, CLAUDE.md, תוכנית, בקשה קטנה, בדיקה וקומיט.</div>
    <div><i>🧠</i>כל שיחה מתחילה בלי זיכרון. ה-CLAUDE.md הוא הזיכרון, ובו הוראות שאפשר לבדוק.</div>
    <div><i>👀</i>ה-AI כותב ואתם סוקרים. קוד שרץ בלי שגיאה עדיין יכול להיות שגוי.</div>
  </div>
</div>

<!-- ============ שאלות ותשובות ============ -->
<div class="sec rv">
  <div class="sh"><span class="ic">❓</span><h2>שאלות ותשובות</h2></div>
  <div class="qas">
    <div class="qa"><b>חייבים CLAUDE.md?</b><p>לא חייבים, אבל בלעדיו Claude מתחיל כל שיחה בלי לדעת איך מריצים את הפרויקט ואילו כללים חלים עליו.</p></div>
    <div class="qa"><b>למה לא להגיד "תבנה לי הכול"?</b><p>קשה לסקור שינוי ענק, והסיכוי שה-AI ינחש לא נכון גדל. עובדים בצעדים קטנים שאפשר לבדוק.</p></div>
    <div class="qa"><b>מה ההבדל בין CLAUDE.md להנחיה בשיחה?</b><p>הנחיה בשיחה חיה רק בשיחה הזו. CLAUDE.md נטען בתחילת כל שיחה חדשה.</p></div>
    <div class="qa"><b>צריך לכתוב את הקובץ באנגלית?</b><p>לא חובה, אפשר גם בעברית. בקורס נכתוב באנגלית כי פקודות ושמות קבצים בלאו הכי באנגלית.</p></div>
  </div>
  <p class="src">פקודות ועקרונות מתוך תיעוד Claude Code: <a href="https://code.claude.com/docs/en/quickstart" target="_blank" rel="noopener">Quickstart</a> · <a href="https://code.claude.com/docs/en/memory" target="_blank" rel="noopener">CLAUDE.md</a> · <a href="https://code.claude.com/docs/en/common-workflows" target="_blank" rel="noopener">Common workflows</a></p>
</div>

<script>
(function(){
  var root=document.getElementById(''cbl-2''); if(!root) return;
  root.classList.add(''js'');
  function $(id){return document.getElementById(id);}
  function mk(tag,cls,txt){var e=document.createElement(tag);if(cls)e.className=cls;if(txt!=null)e.textContent=txt;return e;}
  var rv=root.querySelectorAll(''.rv'');
  if(''IntersectionObserver'' in window){
    var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add(''in'');io.unobserve(e.target);}});},{threshold:.02});
    Array.prototype.forEach.call(rv,function(r){io.observe(r);});
  } else { Array.prototype.forEach.call(rv,function(r){r.classList.add(''in'');}); }
  var T=[
    [''p'',''$ mkdir url-shortener && cd url-shortener''],
    [''p'',''$ git init''],
    [''p'',''$ claude''],
    [''m'',''  Claude Code ready. Directory: url-shortener''],
    [''p'',''> Create POST /shorten in main.py ...''],
    [''g'',''  ✔ plan ready for your review'']
  ];
  var term=$(''cbl-term''),li=0,ci=0,cur=null;
  function typeLine(){
    if(li>=T.length)return;
    if(ci===0){cur=mk(''div'',T[li][0]);term.appendChild(cur);}
    var txt=T[li][1];cur.textContent=txt.slice(0,++ci);
    if(ci>=txt.length){li++;ci=0;setTimeout(typeLine,380);}else setTimeout(typeLine,16);
  }
  typeLine();
})();
</script>
</div>
</body>
</html>
', 2, '2026-10-28T00:00:00.000Z');
