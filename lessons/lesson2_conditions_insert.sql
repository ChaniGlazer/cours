DELETE FROM lessons WHERE course_id='python-ai-era' AND slug='conditions';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('534b4a71406247ddb3153d95faf6f784', 'python-ai-era', 'conditions', 'שיעור 2 - תנאים (if)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>שיעור שני בפייתון — תנאים</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;700;800;900&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #12102A; --bg-panel: #1D1A3D; --bg-panel-2: #262148;
    --ink: #F5F3FF; --ink-dim: #B4AEDB; --ink-faint: #6F699E;
    --main: #B79CFF; --main-soft: #2D2552;
    --yes: #5CE1A6; --yes-soft: #163B30;
    --no: #FF6B6B; --no-soft: #3E1D22;
    --amber: #FFB84D;
    --line: rgba(245,243,255,0.10); --line-strong: rgba(245,243,255,0.22);
    --radius: 20px;
    --display: "Rubik", sans-serif; --sans: "Assistant", sans-serif; --mono: "JetBrains Mono", monospace;
  }
  @media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation-duration: 0.01ms !important; transition-duration: 0.01ms !important; } }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }
  body {
    margin: 0;
    background: radial-gradient(620px 420px at 12% -5%, rgba(183,156,255,0.13), transparent 60%), radial-gradient(620px 420px at 100% 22%, rgba(92,225,166,0.07), transparent 60%), var(--bg);
    color: var(--ink); font-family: var(--sans); font-size: 17px; line-height: 1.7; -webkit-font-smoothing: antialiased;
  }
  ::selection { background: var(--main); color: #170f33; }
  .wrap { max-width: 720px; margin: 0 auto; padding: 0 22px; }
  p { color: var(--ink-dim); margin: 0; }
  h1, h2 { font-family: var(--display); font-weight: 800; color: var(--ink); margin: 0; }
  .mono { font-family: var(--mono); direction: ltr; unicode-bidi: isolate; }
  button { font-family: var(--sans); cursor: pointer; }
  button:focus-visible, input:focus-visible, select:focus-visible, textarea:focus-visible { outline: 2px solid var(--ink); outline-offset: 2px; }
  section { padding: 62px 0; }
  section + section { border-top: 1px solid var(--line); }
  .eyebrow { font-family: var(--mono); font-size: 13px; margin-bottom: 12px; color: var(--main); }
  h2.section-title { font-size: clamp(1.6rem, 4.5vw, 2.2rem); }
  .lede { font-size: 18px; margin-top: 14px; }

  .name-bar { background: var(--bg-panel); border-bottom: 1px solid var(--line); padding: 14px 0; }
  .name-bar-inner { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .name-bar-inner label { font-size: 13.5px; color: var(--ink-dim); flex-shrink: 0; }
  .name-bar-input { flex: 1; min-width: 160px; max-width: 260px; font-family: var(--sans); font-size: 15px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 10px; color: var(--ink); padding: 9px 12px; }
  .name-bar-jump { margin-inline-start: auto; font-family: var(--display); font-weight: 700; font-size: 13.5px; color: var(--main); background: transparent; border: 1px solid var(--main); border-radius: 100px; padding: 8px 16px; white-space: nowrap; }
  .name-bar-jump:hover { background: var(--main-soft); }

  .hero { padding: 70px 0 54px; text-align: center; }
  .hero .eyebrow { display: flex; justify-content: center; }
  .hero h1 { font-size: clamp(2.1rem, 7vw, 3.2rem); line-height: 1.16; }
  .accent { color: var(--main); }
  .hero-sub { max-width: 46ch; margin: 18px auto 0; font-size: 18.5px; }

  .tok-kw { color: #C792EA; } .tok-str { color: #A8D48A; } .tok-num { color: #F5C97B; } .tok-fn { color: #7EC1F5; } .tok-bool { color: var(--amber); }
  .panel { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); overflow: hidden; text-align: right; }
  .panel-pad { padding: 20px 24px; }
  .panel-bar { padding: 16px 24px; border-bottom: 1px solid var(--line); display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .panel-bar label { font-weight: 700; font-size: 15px; }
  .panel-foot { padding: 14px 24px 16px; border-top: 1px solid var(--line); font-size: 15px; color: var(--ink-dim); min-height: 52px; }
  .hero .panel { max-width: 560px; margin-inline: auto; }

  .codeblock { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 2; padding: 14px 0; background: rgba(0,0,0,0.22); }
  .codeblock .line { padding: 1px 22px; white-space: pre; transition: opacity 0.2s ease, background 0.2s ease; }
  .codeblock .line.hit { background: var(--main-soft); box-shadow: inset 3px 0 0 var(--main); }
  .codeblock .line.dim { opacity: 0.32; }
  .codeblock .note { font-family: var(--sans); font-size: 12.5px; color: var(--ink-faint); margin-inline-start: 14px; direction: rtl; unicode-bidi: isolate; white-space: normal; }
  .codeblock .note.on { color: var(--yes); font-weight: 700; }

  .btn { font-weight: 700; font-size: 14px; color: var(--ink); background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 100px; padding: 9px 18px; }
  .btn:hover:not(:disabled) { border-color: var(--ink-dim); }
  .btn.main { background: var(--main); border-color: var(--main); color: #170f33; }
  input[type="number"], input[type="text"], select, textarea { font-family: var(--mono); font-size: 15px; background: var(--bg-panel-2); border: 1px solid var(--line-strong); border-radius: 8px; color: var(--ink); padding: 8px 10px; }
  input[type="range"] { accent-color: var(--main); flex: 1; min-width: 140px; }
  .val-badge { font-family: var(--mono); font-weight: 800; font-size: 20px; color: var(--main); min-width: 62px; text-align: center; direction: ltr; }
  .mini-label { font-size: 13px; font-weight: 700; color: var(--ink-faint); margin: 14px 0 8px; }

  .meter { position: relative; direction: ltr; height: 20px; background: var(--bg-panel-2); border-radius: 100px; margin: 10px 0 34px; }
  .meter-fill { height: 100%; border-radius: 100px; transition: width 0.15s ease, background 0.2s ease; }
  .meter-tick { position: absolute; top: -8px; width: 2px; height: 36px; background: var(--ink); }
  .meter-tick span { position: absolute; top: 40px; left: 50%; transform: translateX(-50%); font-family: var(--mono); font-size: 12px; color: var(--ink-dim); white-space: nowrap; }
  .verdict { margin: 4px 0 16px; padding: 14px 18px; border-radius: 14px; font-family: var(--display); font-weight: 800; font-size: 20px; text-align: center; transition: background 0.2s ease, color 0.2s ease; }
  .verdict.yes { background: var(--yes-soft); color: var(--yes); }
  .verdict.no { background: var(--no-soft); color: var(--no); }

  .cmp-row { display: flex; align-items: center; justify-content: center; gap: 12px; flex-wrap: wrap; direction: ltr; }
  .cmp-row input { width: 84px; text-align: center; font-size: 22px; padding: 10px; }
  .ops { display: flex; gap: 6px; flex-wrap: wrap; justify-content: center; margin-top: 18px; }
  .op { font-family: var(--mono); font-weight: 800; font-size: 17px; min-width: 52px; padding: 8px 12px; border-radius: 12px; background: transparent; border: 2px solid var(--line-strong); color: var(--ink-dim); }
  .op.on { border-color: var(--main); color: var(--main); background: var(--main-soft); }
  .tf { margin: 20px auto 6px; width: 150px; text-align: center; border-radius: 14px; padding: 12px; font-family: var(--mono); font-weight: 800; font-size: 26px; transition: background 0.15s ease, color 0.15s ease; }
  .tf.t { background: var(--yes-soft); color: var(--yes); } .tf.f { background: var(--no-soft); color: var(--no); }
  .expr { text-align: center; font-family: var(--mono); font-size: 18px; color: var(--ink-dim); direction: ltr; margin-top: 16px; }

  .callout { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--main); border-radius: 14px; padding: 16px 20px; font-size: 15.5px; color: var(--ink-dim); }
  .callout strong { color: var(--ink); }

  .toggles { display: flex; gap: 10px; flex-wrap: wrap; }
  .tg { font-family: var(--mono); font-weight: 700; font-size: 14px; padding: 10px 16px; border-radius: 12px; background: transparent; border: 2px solid var(--no); color: var(--no); }
  .tg.on { border-color: var(--yes); color: var(--yes); background: var(--yes-soft); }
  .seg { display: inline-flex; gap: 8px; }
  .seg button { font-family: var(--mono); font-weight: 800; font-size: 15px; padding: 8px 20px; border-radius: 100px; border: 2px solid var(--line-strong); background: transparent; color: var(--ink-dim); }
  .seg button.on { border-color: var(--main); color: var(--main); background: var(--main-soft); }

  .banner { margin-bottom: 8px; background: linear-gradient(135deg, var(--main-soft), var(--yes-soft)); border: 1px solid var(--line-strong); border-radius: var(--radius); padding: 24px 26px; }
  .banner .badge { display: inline-block; font-family: var(--mono); font-size: 12.5px; font-weight: 700; color: var(--bg); background: var(--main); border-radius: 100px; padding: 4px 12px; margin-bottom: 10px; }
  .banner p { margin-top: 10px; font-size: 16px; color: var(--ink); }
  .ex-card { margin-top: 22px; background: var(--bg-panel); border: 1px solid var(--line); border-inline-start: 3px solid var(--main); border-radius: 16px; padding: 22px 24px; }
  .ex-num { font-family: var(--mono); font-size: 12.5px; color: var(--ink-faint); }
  .ex-task { margin: 8px 0 14px; font-weight: 600; color: var(--ink); font-size: 15.5px; }
  .ex-code { direction: ltr; text-align: left; font-family: var(--mono); font-size: 14.5px; line-height: 2.1; background: rgba(0,0,0,0.22); border-radius: 10px; padding: 14px 16px; margin-bottom: 14px; overflow-x: auto; white-space: pre; }
  .code-in { direction: ltr; text-align: left; width: 220px; padding: 4px 8px; font-size: 14px; color: var(--main); }
  .ex-controls { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; }
  .ex-fb { font-size: 14.5px; font-weight: 700; min-height: 20px; }
  .ex-fb.ok { color: var(--yes); } .ex-fb.bad { color: var(--no); }
  .q-opts { display: flex; gap: 10px; flex-wrap: wrap; }
  .q-opt { font-family: var(--mono); font-size: 15px; background: var(--bg-panel-2); color: var(--ink); border: 1px solid var(--line-strong); border-radius: 12px; padding: 10px 18px; }
  .q-opt:hover:not(:disabled) { border-color: var(--ink-dim); }
  .q-opt.right { border-color: var(--yes); background: var(--yes-soft); color: var(--yes); }
  .q-opt.wrong { border-color: var(--no); background: var(--no-soft); color: var(--no); }
  .q-opt:disabled { cursor: default; }
  .ex-note { font-size: 13.5px; color: var(--ink-faint); font-style: italic; margin: 0 0 10px; }
  .ex-answer { width: 100%; direction: ltr; text-align: left; font-size: 13.5px; line-height: 1.7; resize: vertical; }
  .ex-divider { margin-top: 38px; display: flex; align-items: center; gap: 14px; color: var(--ink-faint); font-family: var(--mono); font-size: 13px; }
  .ex-divider::before, .ex-divider::after { content: ""; flex: 1; height: 1px; background: var(--line); }

  .certificate-box { margin-top: 28px; background: var(--bg-panel); border: 1px solid var(--line); border-radius: var(--radius); padding: 24px 26px 20px; display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
  .cert-name-display { font-size: 15px; color: var(--ink-dim); }
  .cert-name-display strong { color: var(--main); }
  .cert-status { width: 100%; margin: 0; font-size: 14.5px; color: var(--ink-dim); min-height: 22px; }
  .cert-status.ok { color: var(--yes); } .cert-status.bad { color: var(--no); }
  .cert-fallback { margin-top: 16px; }
  .cert-fallback-note { font-size: 13.5px; color: var(--ink-faint); margin: 0 0 10px; }
  .cert-fallback-text { width: 100%; direction: ltr; text-align: left; font-size: 12px; line-height: 1.6; color: var(--ink-dim); }
  footer { padding: 44px 0 70px; text-align: center; color: var(--ink-faint); font-size: 14px; }
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
    <div class="eyebrow">שיעור שני · פייתון</div>
    <h1>המחשב מחליט —<br><span class="accent">לפי מה שתגידו לו</span></h1>
    <p class="hero-sub">עד עכשיו הקוד רץ שורה אחרי שורה. עם תנאים הוא לומד לבחור דרך, לפי המצב. נתחיל ברכבת הרים בפארק שעשועים.</p>

    <div class="panel">
      <div class="panel-bar">
        <label for="ride-h">הגובה שלך:</label>
        <input type="range" id="ride-h" min="100" max="190" value="152">
        <span class="val-badge" id="ride-val">152 ס״מ</span>
      </div>
      <div class="panel-pad">
        <div class="meter"><div class="meter-fill" id="ride-fill"></div><div class="meter-tick" id="ride-tick"><span>140</span></div></div>
        <div class="verdict" id="ride-verdict"></div>
        <div class="codeblock" id="ride-code" style="border-radius:12px;"></div>
      </div>
      <div class="panel-foot">הזיזו את המחוון. ברגע שהגובה חוצה את הקו, התוכנית בוחרת מסלול אחר — השורות המודגשות הן אלה שרצו.</div>
    </div>
  </div>
</header>

<main>

  <!-- ===== COMPARE ===== -->
  <section id="compare">
    <div class="wrap">
      <div class="eyebrow">חלק 1 · השוואות</div>
      <h2 class="section-title">תנאי הוא שאלה של כן או לא</h2>
      <p class="lede">התשובה לתנאי היא תמיד אחת משתיים: <span class="mono">True</span> (כן) או <span class="mono">False</span> (לא). בחרו שני מספרים ופעולת השוואה, וראו מה יוצא.</p>

      <div class="panel">
        <div class="panel-pad">
          <div class="cmp-row">
            <input type="number" id="cmp-a" value="7">
            <span class="mono" id="cmp-op-shown" style="font-size:26px; font-weight:800; color:var(--main);">&gt;</span>
            <input type="number" id="cmp-b" value="5">
          </div>
          <div class="ops" id="ops"></div>
          <div class="expr" id="cmp-expr"></div>
          <div class="tf" id="cmp-tf"></div>
        </div>
        <div class="panel-foot" id="cmp-say"></div>
      </div>

      <div class="callout"><strong>שימו לב להבדל:</strong> <span class="mono">=</span> <strong>שמה</strong> ערך בקופסה (<span class="mono">x = 5</span>). <span class="mono">==</span> <strong>שואלת</strong> אם שני דברים שווים (<span class="mono">x == 5</span>). בתוך תנאי תמיד כותבים שני שווים.</div>
    </div>
  </section>

  <!-- ===== ELIF ===== -->
  <section id="elif">
    <div class="wrap">
      <div class="eyebrow">חלק 2 · יותר משני מסלולים</div>
      <h2 class="section-title">elif — בודקים לפי הסדר</h2>
      <p class="lede">כשיש יותר משתי אפשרויות, מוסיפים <span class="mono">elif</span>. פייתון בודקת מלמעלה למטה, <strong>עוצרת בתנאי הראשון שנכון</strong>, ומדלגת על כל השאר. הזיזו את הציון וראו.</p>

      <div class="panel">
        <div class="panel-bar">
          <label for="sc">הציון:</label>
          <input type="range" id="sc" min="0" max="100" value="82">
          <span class="val-badge" id="sc-val">82</span>
        </div>
        <div class="codeblock" id="sc-code"></div>
        <div class="panel-foot" id="sc-say"></div>
      </div>
    </div>
  </section>

  <!-- ===== AND / OR ===== -->
  <section id="logic">
    <div class="wrap">
      <div class="eyebrow">חלק 3 · וגם / או</div>
      <h2 class="section-title">לחבר שני תנאים</h2>
      <p class="lede"><span class="mono">and</span> — שני התנאים חייבים להיות נכונים. <span class="mono">or</span> — מספיק שאחד נכון. לחצו על המתגים ושנו בין and ל-or.</p>

      <div class="panel">
        <div class="panel-bar">
          <div class="toggles">
            <button class="tg" id="tg-ticket" type="button">has_ticket</button>
            <button class="tg" id="tg-invite" type="button">has_invite</button>
          </div>
          <div class="seg" id="logic-seg">
            <button class="on" data-op="and" type="button">and</button>
            <button data-op="or" type="button">or</button>
          </div>
        </div>
        <div class="panel-pad">
          <div class="codeblock" id="logic-code" style="border-radius:12px;"></div>
          <div class="verdict" id="logic-verdict" style="margin-top:16px;"></div>
        </div>
        <div class="panel-foot" id="logic-say"></div>
      </div>
    </div>
  </section>

  <!-- ===== EXERCISES ===== -->
  <section id="exercises">
    <div class="wrap">
      <div class="banner">
        <span class="badge">👇 מפה זה עלייך</span>
        <h2 class="section-title">התרגילים שלכן</h2>
        <p>שלושה תרגילים קצרים עם בדיקה, ותרגיל אחד שכותבים בעורך. בסוף מורידות קובץ עם התוצאות.</p>
      </div>

      <div class="ex-card">
        <div class="ex-num">תרגיל 1 · כתבו תנאי</div>
        <p class="ex-task">רכבת ההרים מתאימה מגובה 140 ס״מ ומעלה (140 כולל). כתבו את התנאי: החליפו את ___ והריצו.</p>
        <div id="ex1-ed"></div>
      </div>

      <div class="ex-card">
        <div class="ex-num">תרגיל 2 · מה יודפס?</div>
        <p class="ex-task">בלי להריץ — מה תדפיס התוכנית?</p>
        <div class="ex-code">x = 7
if x > 5:
    print("A")
elif x > 3:
    print("B")
else:
    print("C")</div>
        <div class="q-opts" id="ex2-opts"></div>
        <div class="ex-fb" id="ex2-fb" style="margin-top:12px;"></div>
      </div>

      <div class="ex-card">
        <div class="ex-num">תרגיל 3 · בין שני מספרים</div>
        <p class="ex-task">כתבו תנאי שנכון רק כש-num נמצא בין 10 ל-20, כולל שניהם (10 ו-20 נחשבים). החליפו את ___ והריצו.</p>
        <div id="ex3-ed"></div>
      </div>

      <div class="ex-divider"><span>כתיבה אישית</span></div>

      <div class="ex-card">
        <div class="ex-num">תרגיל 4 · שומר הסיסמה</div>
        <p class="ex-task">כתבו תוכנית ששומרת סיסמה סודית במשתנה (למשל python123), שואלת את המשתמשת איזו סיסמה היא מקלידה, ומדפיסה <span class="mono">הדלת נפתחת</span> אם היא נכונה, ו-<span class="mono">הדלת נשארת נעולה</span> אם לא. בונוס: אם לא הקלידה כלום, הדפיסו <span class="mono">לא הקלדת כלום</span>.</p>
        <p class="ex-note">✍️ כתבו כאן את התוכנית, הריצו, ובדקו שהיא עובדת:</p>
        <div id="ex4-ed"></div>
      </div>
    </div>
  </section>

  <!-- ===== CERTIFICATE ===== -->
  <section id="certificate">
    <div class="wrap">
      <div class="eyebrow">לסיום</div>
      <h2 class="section-title">שלחו לי את התוצאות</h2>
      <p class="lede">לוחצות על הכפתור — יורד קובץ מעוצב עם מה שפתרתן והקוד מתרגיל 4.</p>
      <div class="certificate-box">
        <span class="cert-name-display">מורידה עבור: <strong id="cert-name-display">—</strong></span>
        <button class="btn main" id="cert-download" type="button">⬇️ הורידי קובץ תוצאות</button>
        <p class="cert-status" id="cert-status"></p>
      </div>
      <div class="cert-fallback" id="cert-fallback" hidden>
        <p class="cert-fallback-note">ההורדה האוטומטית לא זמינה כאן. סמנו הכול בתיבה (Ctrl+A / Cmd+A), העתיקו, הדביקו לקובץ טקסט חדש ושמרו אותו בסיומת .html:</p>
        <textarea class="cert-fallback-text" id="cert-fallback-text" readonly rows="8"></textarea>
      </div>
    </div>
  </section>

</main>

<footer><div class="wrap">שיעור שני בפייתון · תנאים</div></footer>

<script>
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
window.lessonProgress = { ex1: false, ex2: false, ex3: false };

/* דיווח התקדמות לאתר שמציג את השיעור. window.reportProgress מוזרק על ידי האתר ושולח לו הודעה;
   בקובץ שנפתח לבד אין אותו, ולכן הקריאה מוגנת. תרגילי החובה: תרגילים 1-3. */
function reportLessonProgress() {
  if (!window.reportProgress) return;
  var p = window.lessonProgress, keys = ["ex1", "ex2", "ex3"], done = 0;
  for (var i = 0; i < keys.length; i++) { if (p[keys[i]]) done++; }
  window.reportProgress(done, keys.length);
}
reportLessonProgress();

function $(id) { return document.getElementById(id); }
function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;"); }
function highlight(code) {
  return esc(code).replace(/("[^"]*")|\b(if|elif|else|and|or|not)\b|\b(print|input|int)\b|\b(True|False)\b|\b(\d+)\b/g, function (m, str, kw, fn, bool, num) {
    if (str) return ''<span class="tok-str">'' + str + "</span>";
    if (kw) return ''<span class="tok-kw">'' + kw + "</span>";
    if (fn) return ''<span class="tok-fn">'' + fn + "</span>";
    if (bool) return ''<span class="tok-bool">'' + bool + "</span>";
    return ''<span class="tok-num">'' + num + "</span>";
  });
}
function lineDiv(text, cls, note, noteOn) {
  return ''<div class="line'' + (cls ? " " + cls : "") + ''">'' + highlight(text) + (note ? ''<span class="note'' + (noteOn ? " on" : "") + ''">'' + esc(note) + "</span>" : "") + "</div>";
}

$("jump-to-exercises").addEventListener("click", function () { $("exercises").scrollIntoView({ behavior: "smooth", block: "start" }); });

/* ---------- hero: roller coaster ---------- */
(function () {
  var sl = $("ride-h"), val = $("ride-val"), fill = $("ride-fill"), tick = $("ride-tick"), verdict = $("ride-verdict"), code = $("ride-code");
  tick.style.left = ((140 - 100) / 90 * 100) + "%";
  function render() {
    var h = parseInt(sl.value, 10), ok = h >= 140;
    val.textContent = h + " ס״מ";
    fill.style.width = ((h - 100) / 90 * 100) + "%";
    fill.style.background = ok ? "var(--yes)" : "var(--no)";
    verdict.className = "verdict " + (ok ? "yes" : "no");
    verdict.textContent = ok ? "✅ אפשר לעלות לרכבת ההרים!" : "⛔ עוד קצת… צריך לפחות 140";
    code.innerHTML =
      lineDiv("height = " + h) +
      lineDiv("if height >= 140:", ok ? "hit" : "") +
      lineDiv(''    print("אפשר לעלות!")'', ok ? "hit" : "dim") +
      lineDiv("else:", ok ? "dim" : "hit") +
      lineDiv(''    print("עוד קצת...")'', ok ? "dim" : "hit");
  }
  sl.addEventListener("input", render);
  render();
})();

/* ---------- comparisons ---------- */
(function () {
  var a = $("cmp-a"), b = $("cmp-b"), opsEl = $("ops"), shown = $("cmp-op-shown"), expr = $("cmp-expr"), tf = $("cmp-tf"), say = $("cmp-say");
  var ops = [
    { s: ">", f: function (x, y) { return x > y; }, w: "גדול מ" },
    { s: "<", f: function (x, y) { return x < y; }, w: "קטן מ" },
    { s: ">=", f: function (x, y) { return x >= y; }, w: "גדול או שווה ל" },
    { s: "<=", f: function (x, y) { return x <= y; }, w: "קטן או שווה ל" },
    { s: "==", f: function (x, y) { return x === y; }, w: "שווה ל" },
    { s: "!=", f: function (x, y) { return x !== y; }, w: "שונה מ" }
  ];
  var cur = 0, btns = [];
  function render() {
    var x = parseFloat(a.value), y = parseFloat(b.value);
    btns.forEach(function (bt, i) { bt.classList.toggle("on", i === cur); });
    shown.textContent = ops[cur].s;
    if (isNaN(x) || isNaN(y)) { expr.textContent = ""; tf.textContent = "?"; tf.className = "tf"; say.textContent = "הקלידו שני מספרים."; return; }
    var r = ops[cur].f(x, y);
    expr.textContent = x + " " + ops[cur].s + " " + y;
    tf.textContent = r ? "True" : "False"; tf.className = "tf " + (r ? "t" : "f");
    say.textContent = "השאלה: האם " + x + " " + ops[cur].w + "-" + y + "? התשובה: " + (r ? "כן — True." : "לא — False.");
  }
  ops.forEach(function (o, i) {
    var bt = document.createElement("button");
    bt.type = "button"; bt.className = "op"; bt.textContent = o.s;
    bt.addEventListener("click", function () { cur = i; render(); });
    btns.push(bt); opsEl.appendChild(bt);
  });
  a.addEventListener("input", render); b.addEventListener("input", render);
  render();
})();

/* ---------- elif ---------- */
(function () {
  var sl = $("sc"), val = $("sc-val"), code = $("sc-code"), say = $("sc-say");
  var branches = [
    { t: 90, msg: "מצוין" }, { t: 75, msg: "טוב" }, { t: 55, msg: "עובר" }
  ];
  function render() {
    var s = parseInt(sl.value, 10);
    val.textContent = s;
    var chosen = -1;
    for (var i = 0; i < branches.length; i++) { if (s >= branches[i].t) { chosen = i; break; } }
    if (chosen === -1) chosen = branches.length; /* else */
    var html = lineDiv("score = " + s);
    branches.forEach(function (br, i) {
      var kw = i === 0 ? "if" : "elif";
      var isTrue = s >= br.t, note = "", on = false, cls;
      if (i < chosen) { note = "✗ לא נכון — ממשיכים הלאה"; cls = "dim"; }
      else if (i === chosen) { note = "✓ נכון! נבחר"; on = true; cls = "hit"; }
      else { note = isTrue ? "(גם זה נכון, אבל פייתון כבר לא בודקת)" : ""; cls = "dim"; }
      html += lineDiv(kw + " score >= " + br.t + ":", cls, note, on);
      html += lineDiv(''    print("'' + br.msg + ''")'', i === chosen ? "hit" : "dim");
    });
    html += lineDiv("else:", chosen === branches.length ? "hit" : "dim", chosen === branches.length ? "✓ כל מה שלמעלה לא נכון — אז זה" : "", chosen === branches.length);
    html += lineDiv(''    print("צריך לתרגל")'', chosen === branches.length ? "hit" : "dim");
    code.innerHTML = html;
    say.textContent = chosen < branches.length
      ? "הציון " + s + " עומד בתנאי הראשון שנכון (≥ " + branches[chosen].t + ") — לכן מודפס ״" + branches[chosen].msg + "״, ושאר התנאים לא נבדקים."
      : "אף תנאי לא נכון, אז רצה ה-else: ״צריך לתרגל״.";
  }
  sl.addEventListener("input", render);
  render();
})();

/* ---------- and / or ---------- */
(function () {
  var tT = $("tg-ticket"), tI = $("tg-invite"), seg = $("logic-seg"), code = $("logic-code"), verdict = $("logic-verdict"), say = $("logic-say");
  var ticket = false, invite = false, op = "and";
  function render() {
    tT.classList.toggle("on", ticket); tI.classList.toggle("on", invite);
    tT.textContent = "has_ticket = " + (ticket ? "True" : "False");
    tI.textContent = "has_invite = " + (invite ? "True" : "False");
    seg.querySelectorAll("button").forEach(function (b) { b.classList.toggle("on", b.dataset.op === op); });
    var res = op === "and" ? (ticket && invite) : (ticket || invite);
    code.innerHTML =
      lineDiv("has_ticket = " + (ticket ? "True" : "False")) +
      lineDiv("has_invite = " + (invite ? "True" : "False")) +
      lineDiv("if has_ticket " + op + " has_invite:", res ? "hit" : "") +
      lineDiv(''    print("נכנסת!")'', res ? "hit" : "dim") +
      lineDiv("else:", res ? "dim" : "hit") +
      lineDiv(''    print("אי אפשר להיכנס")'', res ? "dim" : "hit");
    verdict.className = "verdict " + (res ? "yes" : "no");
    verdict.textContent = res ? "✅ נכנסת!" : "⛔ אי אפשר להיכנס";
    say.textContent = op === "and"
      ? "עם and צריך את שניהם: גם כרטיס וגם הזמנה. אם אחד חסר — הכול False."
      : "עם or מספיק אחד מהם: כרטיס או הזמנה. רק אם שניהם חסרים — False.";
  }
  tT.addEventListener("click", function () { ticket = !ticket; render(); });
  tI.addEventListener("click", function () { invite = !invite; render(); });
  seg.querySelectorAll("button").forEach(function (b) { b.addEventListener("click", function () { op = b.dataset.op; render(); }); });
  render();
})();

/* ---------- exercises ---------- */
(function () {
  function fb(id, ok, text) { var e = $(id); e.textContent = text; e.className = "ex-fb " + (ok ? "ok" : "bad"); }
  /* בדיקה אמיתית: מריצים את הקוד של התלמידה כמה פעמים, כל פעם עם ערך אחר במשתנה בשורה הראשונה */
  function condTests(varName, cases, okLine) {
    return cases.map(function (c) {
      return {
        label: varName + " = " + c[0],
        transform: function (code) { return code.replace(new RegExp("^" + varName + "\\s*=.*$", "m"), varName + " = " + c[0]); },
        out: c[1] ? okLine : "",
        hidden: false
      };
    });
  }
  pyEditor({
    el: "ex1-ed", id: "ex1", rows: 3, maxRows: 8, code: ''height = 150\nif ___:\n    print("אפשר לעלות!")\n'', hint: "החליפי את ___ בתנאי והריצי. הבדיקה מנסה כמה גבהים.",
    tests: condTests("height", [[140, true], [150, true], [185, true], [139, false], [120, false], [100, false]], "אפשר לעלות!"),
    passText: "נכון! התנאי עובד גם ב-140 בדיוק וגם מתחתיו ומעליו.",
    onPass: function () { window.lessonProgress.ex1 = true; reportLessonProgress(); }
  });
  pyEditor({
    el: "ex3-ed", id: "ex3", rows: 3, maxRows: 8, code: ''num = 15\nif ___:\n    print("בטווח!")\n'', hint: "החליפי את ___ בתנאי והריצי. הבדיקה מנסה כמה מספרים.",
    tests: condTests("num", [[10, true], [15, true], [20, true], [9, false], [21, false], [0, false], [100, false]], "בטווח!"),
    passText: "מדויק! התנאי נכון בדיוק מ-10 עד 20.",
    onPass: function () { window.lessonProgress.ex3 = true; reportLessonProgress(); }
  });
  var opts = [
    { t: "A", ok: true }, { t: "B", ok: false }, { t: "A ו-B", ok: false }, { t: "C", ok: false }
  ];
  for (var i = opts.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)); var tmp = opts[i]; opts[i] = opts[j]; opts[j] = tmp; }
  var box = $("ex2-opts"), btns = [];
  opts.forEach(function (o) {
    var b = document.createElement("button");
    b.type = "button"; b.className = "q-opt"; b.textContent = o.t;
    b.addEventListener("click", function () {
      if (o.ok) { btns.forEach(function (x) { x.disabled = true; }); b.classList.add("right"); fb("ex2-fb", true, "נכון! 7 גדול מ-5, אז נבחר A — ו-elif כבר לא נבדק."); window.lessonProgress.ex2 = true; reportLessonProgress(); }
      else {
        /* תשובה שגויה נסגרת, והשאר נשארות פתוחות כדי לנסות שוב */
        b.disabled = true; b.classList.add("wrong");
        fb("ex2-fb", false, "לא בדיוק. התנאי הראשון (x > 5) נכון, אז נבחר A ופייתון עוצרת — היא לא בודקת את ה-elif. נסי שוב.");
      }
    });
    btns.push(b); box.appendChild(b);
  });
})();

/* ---------- exercise 4: password keeper, runs for real ---------- */
var ex4Editor = pyEditor({
  el: "ex4-ed", id: "ex4", rows: 8, maxRows: 18, code: ''# כתבי כאן את התוכנית\n'',
  tests: [
    { label: "סיסמה שגויה", inputs: ["לא-הסיסמה-123"], verify: function (r) {
      if (r.printed.indexOf("הדלת נפתחת") >= 0) return "הוקלדה סיסמה לא נכונה, והתוכנית הדפיסה ״הדלת נפתחת״.";
      return r.printed.indexOf("הדלת נשארת נעולה") >= 0 ? true : "בסיסמה שגויה צריך להדפיס: הדלת נשארת נעולה";
    } },
    { label: "הסיסמה הנכונה", inputs: function (code) {
      var m = /^\s*\w+\s*=\s*["'']([^"''\n]+)["'']/m.exec(code);
      return [m ? m[1] : "python123"];
    }, verify: function (r) {
      return r.printed.indexOf("הדלת נפתחת") >= 0 ? true : "כשמקלידים את הסיסמה השמורה במשתנה, צריך להדפיס: הדלת נפתחת";
    } }
  ]
});

/* ---------- certificate download ---------- */
(function () {
  var nameInput = $("cert-name"), btn = $("cert-download"), statusEl = $("cert-status");
  var fallbackBox = $("cert-fallback"), fallbackText = $("cert-fallback-text"), nameDisplay = $("cert-name-display");
  function currentName() { return (nameInput.value || "").trim() || "תלמידה"; }
  nameInput.addEventListener("input", function () { nameDisplay.textContent = currentName(); });
  nameDisplay.textContent = currentName();

  function row(label, done) {
    return ''<div class="row"><span class="dot '' + (done ? "done" : "") + ''"></span><span class="label">'' + label + ''</span><span class="state '' + (done ? "ok" : "no") + ''">'' + (done ? "הושלם" : "לא הושלם") + "</span></div>";
  }
  function buildCertificateHtml(name) {
    var p = window.lessonProgress;
    var ex4 = esc(edCode(ex4Editor, "ex4").trim()) || "(לא הוזן קוד)";
    var dateStr = new Date().toLocaleDateString("he-IL");
    return ''<!DOCTYPE html><html lang="he" dir="rtl"><head><meta charset="UTF-8">'' +
      "<title>תעודת תרגול — " + esc(name) + "</title>" +
      ''<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'' +
      ''<link href="https://fonts.googleapis.com/css2?family=Rubik:wght@700;800;900&family=Assistant:wght@400;600;700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">'' +
      "<style>" +
      ":root{--bg:#12102A;--panel:#1D1A3D;--ink:#F5F3FF;--dim:#B4AEDB;--main:#B79CFF;--ok:#5CE1A6;--no:#FF6B6B;--line:rgba(245,243,255,.12);}" +
      "*{box-sizing:border-box;}body{margin:0;background:var(--bg);color:var(--ink);font-family:Assistant,sans-serif;font-size:16px;line-height:1.7;padding:50px 20px;}" +
      ".wrap{max-width:640px;margin:0 auto;}h1{font-family:Rubik,sans-serif;font-weight:900;font-size:2rem;margin:0 0 6px;}" +
      ".meta{color:var(--dim);margin-bottom:34px;font-size:15px;}h2{font-family:Rubik,sans-serif;font-weight:800;font-size:1.1rem;margin:0 0 14px;color:var(--main);}" +
      ".card{background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:20px 22px;margin-bottom:26px;}" +
      ".row{display:flex;align-items:center;gap:10px;padding:6px 0;}.dot{width:10px;height:10px;border-radius:50%;background:var(--no);flex-shrink:0;}.dot.done{background:var(--ok);}" +
      ".label{flex:1;font-size:15px;}.state{font-family:''JetBrains Mono'',monospace;font-size:13px;font-weight:600;}.state.ok{color:var(--ok);}.state.no{color:var(--no);}" +
      "pre{direction:ltr;text-align:left;font-family:''JetBrains Mono'',monospace;font-size:13.5px;line-height:1.7;background:rgba(0,0,0,.28);border-radius:10px;padding:16px 18px;overflow-x:auto;white-space:pre-wrap;word-break:break-word;color:var(--ink);margin:0;}" +
      ".q{font-size:14.5px;color:var(--dim);margin:0 0 10px;}" +
      ''</style></head><body><div class="wrap">'' +
      "<h1>תעודת תרגול — שיעור שני בפייתון</h1>" +
      ''<div class="meta">שם: '' + esc(name) + " · תאריך: " + dateStr + "</div>" +
      ''<h2>תרגילים עם בדיקה</h2><div class="card">'' +
      row("תרגיל 1 (תנאי גובה)", p.ex1) + row("תרגיל 2 (מה יודפס)", p.ex2) + row("תרגיל 3 (בין 10 ל-20)", p.ex3) +
      "</div>" +
      ''<h2>תרגיל 4 · שומר הסיסמה</h2><div class="card"><p class="q">תוכנית עם input, תנאי ו-else.</p><pre>'' + ex4 + "</pre></div>" +
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
    var filename = name + " - תעודת תרגול שיעור 2.html";
    if (typeof window.claude !== "undefined" && window.claude.use) {
      var downloads = null;
      try { downloads = await window.claude.use("downloads"); } catch (e) { downloads = null; }
      if (downloads) {
        try {
          var res = await downloads.save({ filename: filename, data: html });
          statusEl.textContent = res.status === "saved" ? "הקובץ נשמר! שלחו אותו אליי." : "הקובץ נשלח.";
          statusEl.className = "cert-status ok";
          return;
        } catch (err) {
          if (err && err.code === "declined") { statusEl.textContent = "ההורדה בוטלה."; statusEl.className = "cert-status bad"; return; }
        }
      }
    }
    if (blobDownload(filename, html)) {
      statusEl.textContent = "הקובץ ירד! שלחו אותו אליי.";
      statusEl.className = "cert-status ok";
      return;
    }
    statusEl.textContent = "ההורדה האוטומטית לא עבדה כאן — הטקסט מוכן להעתקה למטה.";
    statusEl.className = "cert-status bad";
    fallbackText.value = html; fallbackBox.hidden = false;
  });
})();
</script>
</body>
</html>
', 2, '2026-10-06T07:05:30.675Z');
