DELETE FROM lessons WHERE course_id='vibe-coding' AND slug='lesson-4-mental-model';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('f1c6a8d25e3b4a79b8d0c4e7a92f3b15', 'vibe-coding', 'lesson-4-mental-model', 'שיעור 4 - המודל המנטלי: הטבח החדש במטבח שלכם', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>הטבח החדש במטבח שלכם — שיעור 4</title>
<style>
html,body{margin:0;background:transparent}
</style>
</head>
<body>
<div class="cbl" id="cbl-4" dir="rtl" lang="he">

<style>
@import url(''https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap'');
.cbl{--ink:#f4f1fa;--mut:#bdb7d3;--line:#3a3558;--card:#1d1a2d;--soft:#26223b;--brand:#ff7f96;--brand2:#8fb8ff;--ok:#6fe0a0;--okbg:rgba(111,224,160,.1);--warn:#ffd27a;--warnbg:rgba(255,210,122,.1);--bad:#ff7f96;--badbg:rgba(255,127,150,.1);--display:''Secular One'',''Arial Hebrew'',Arial,sans-serif;
  position:relative;overflow:hidden;width:100%;max-width:100%;margin:0;padding:0 max(18px,calc((100% - 1000px)/2)) 64px;border-radius:0;color:var(--ink);font-family:''Assistant'',system-ui,-apple-system,''Segoe UI'',Arial,sans-serif;font-size:17px;line-height:1.65;box-sizing:border-box;
  background:transparent}
html,body{overflow-x:clip}
.cbl *{box-sizing:border-box;min-width:0}
.cbl h1,.cbl h2,.cbl h3,.cbl h4,.cbl p,.cbl ul{margin:0}
.cbl code{font-family:''JetBrains Mono'',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;unicode-bidi:isolate}
.cbl a{color:var(--brand2);text-decoration-thickness:1px;text-underline-offset:3px}
.cbl.js .rv{opacity:0;transform:translateY(18px);transition:opacity .6s ease,transform .6s ease}
.cbl.js .rv.in{opacity:1;transform:none}

/* hero */
.cbl .hero{display:grid;grid-template-columns:1.1fr .9fr;gap:48px;align-items:center;padding:72px 0 56px}
.cbl .crumb{display:inline-flex;align-items:center;gap:8px;font-size:14px;font-weight:700;color:var(--warn);background:var(--card);border:1px solid var(--line);padding:6px 14px;border-radius:99px}
.cbl h1{font-size:clamp(38px,6vw,62px);line-height:1.1;margin:18px 0 14px}
.cbl h1 em{font-style:normal;background:linear-gradient(90deg,var(--warn),var(--brand));-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent}
.cbl .sub{font-size:20px;color:var(--mut);max-width:480px}
.cbl .tag{display:inline-block;margin-top:16px;font-size:14.5px;font-weight:700;color:var(--brand);background:rgba(255,127,150,.16);padding:6px 14px;border-radius:99px}

/* menu card: התפריט של המסעדה, נטוי קלות */
.cbl .menu{position:relative;background:var(--soft);border:1px solid var(--line);border-radius:8px;padding:28px 26px 24px;box-shadow:0 18px 40px -20px rgba(0,0,0,.6);transform:rotate(-1.6deg)}
.cbl .menu:before{content:"";position:absolute;inset:8px;border:1.5px dashed rgba(255,210,122,.35);border-radius:4px;pointer-events:none}
.cbl .menu .pin{position:absolute;top:-14px;left:50%;margin-left:-14px;width:28px;height:28px;border-radius:50%;background:radial-gradient(circle at 35% 30%,#ff9fb0,#c85a72);box-shadow:0 4px 8px rgba(0,0,0,.4)}
.cbl .menu h4{font-size:13px;letter-spacing:1px;color:var(--warn);font-weight:700;margin-bottom:6px;direction:ltr;text-align:center}
.cbl .menu .big{font-family:var(--display);font-size:22px;text-align:center;margin-bottom:14px}
.cbl .menu .row{display:flex;justify-content:space-between;gap:12px;padding:8px 0;border-top:1px dotted rgba(255,210,122,.3);font-size:15.5px}
.cbl .menu .row code{font-size:12.5px;background:rgba(255,210,122,.16);color:var(--warn);border-radius:5px;padding:1px 7px;direction:ltr;align-self:center;flex:none}
.cbl .menu .cap{font-size:13px;color:var(--mut);text-align:center;margin-top:14px}

/* sections */
.cbl .sec{margin-top:84px}
.cbl h2{font-size:clamp(26px,3.8vw,36px);line-height:1.25;margin-bottom:6px}
.cbl .lead{color:var(--mut);margin-bottom:26px;font-size:18px}

/* scene cards */
.cbl .scenes{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
.cbl .scene{background:var(--card);border:1px solid var(--line);border-radius:24px;padding:26px 22px 22px;display:flex;flex-direction:column}
.cbl .ico{width:84px;height:84px;border-radius:24px;display:flex;align-items:center;justify-content:center;font-size:46px;margin-bottom:16px;background:rgba(255,210,122,.14);border:1px solid rgba(255,210,122,.35)}
.cbl .scene h3{font-size:20px;margin-bottom:4px}
.cbl .scene p{color:var(--mut);font-size:16px}
.cbl .code{margin-top:auto;padding-top:16px}
.cbl .code span{display:block;font-size:14px;font-weight:700;color:var(--brand);background:rgba(255,127,150,.14);border-radius:12px;padding:9px 12px;line-height:1.45}
.cbl .code span b{color:var(--ink)}

/* stats */
.cbl .stats{display:grid;grid-template-columns:repeat(3,1fr);gap:18px}
.cbl .stat{background:var(--card);border:1px solid var(--line);border-radius:24px;padding:24px}
.cbl .stat .n{font-family:var(--display);font-size:56px;line-height:1;direction:ltr;text-align:right;background:linear-gradient(90deg,var(--brand2),var(--brand));-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent}
.cbl .stat .scn{display:flex;gap:10px;align-items:center;margin-top:12px;font-size:16px;font-weight:700}
.cbl .stat .scn i{font-style:normal;font-size:26px}
.cbl .stat p{color:var(--mut);font-size:14.5px;margin-top:6px;line-height:1.5}
.cbl .src{font-size:13px;color:var(--mut);margin-top:16px}

/* matrix */
.cbl .mx{display:grid;grid-template-columns:34px 1fr 1fr;grid-template-rows:auto auto 28px;gap:14px}
.cbl .ax{writing-mode:vertical-rl;transform:rotate(180deg);font-size:13px;font-weight:700;color:var(--mut);display:flex;align-items:center;justify-content:center}
.cbl .xl{font-size:13px;font-weight:700;color:var(--mut);text-align:center}
.cbl .q{border-radius:24px;padding:22px;border:1px solid var(--line);display:flex;flex-direction:column;gap:6px}
.cbl .q .e{font-size:38px;line-height:1}
.cbl .q h4{font-size:19px}
.cbl .q p{font-size:15px;font-weight:600}
.cbl .q .ex{font-size:13.5px;color:var(--mut)}
.cbl .q.a{background:var(--okbg);border-color:rgba(111,224,160,.4)}.cbl .q.a h4{color:var(--ok)}
.cbl .q.b{background:rgba(143,184,255,.1);border-color:rgba(143,184,255,.4)}.cbl .q.b h4{color:var(--brand2)}
.cbl .q.c{background:var(--warnbg);border-color:rgba(255,210,122,.4)}.cbl .q.c h4{color:var(--warn)}
.cbl .q.d{background:var(--badbg);border-color:rgba(255,127,150,.4)}.cbl .q.d h4{color:var(--brand)}

.cbl .cmp{display:grid;grid-template-columns:1fr 1fr;gap:18px}
.cbl .col{border-radius:24px;padding:24px;border:1px solid var(--line);background:var(--card)}
.cbl .col.good{border-top:5px solid var(--ok)}
.cbl .col.care{border-top:5px solid var(--warn)}
.cbl .col h3{display:flex;align-items:center;gap:10px;font-size:21px;margin:0 0 14px}
.cbl .col h3 .b{width:30px;height:30px;border-radius:50%;display:flex;align-items:center;justify-content:center;color:#14121f}
.cbl .col.good h3 .b{background:var(--ok)}.cbl .col.care h3 .b{background:var(--warn)}
.cbl .it{padding:13px 0;border-top:1px solid var(--line)}
.cbl .it:first-of-type{border-top:0;padding-top:0}
.cbl .it b{display:block;font-size:16.5px;margin-bottom:2px}
.cbl .it span{color:var(--mut);font-size:14.5px;display:block;line-height:1.55}
.cbl .it em{display:inline-block;margin-top:7px;font-style:normal;font-size:13px;font-weight:700;color:var(--warn);background:rgba(255,210,122,.12);border:1px solid rgba(255,210,122,.35);border-radius:99px;padding:2px 12px}
.cbl .task{margin-top:72px;background:var(--card);border:1px solid var(--line);border-radius:28px;overflow:hidden}
.cbl .task .th{display:flex;gap:18px;align-items:center;background:linear-gradient(135deg,var(--warn),var(--brand));color:#14121f;padding:24px 28px}
.cbl .task .th .e{font-size:44px;flex:none}
.cbl .task .th h2{color:#14121f;font-size:26px;margin-bottom:2px}
.cbl .task .th p{color:rgba(20,18,31,.85);font-size:16.5px}
.cbl .task .tb{padding:26px 28px 28px}
.cbl .ts{margin:0;padding:0;list-style:none;display:grid;gap:12px;counter-reset:t}
.cbl .ts li{counter-increment:t;display:flex;gap:14px;align-items:flex-start;font-size:16.5px;color:#e6e1f2}
.cbl .ts li:before{content:counter(t);width:32px;height:32px;border-radius:50%;flex:none;display:flex;align-items:center;justify-content:center;font-family:var(--display);background:rgba(255,210,122,.16);color:var(--warn);border:1px solid rgba(255,210,122,.35)}
.cbl .ts li b{color:var(--ink)}
.cbl .exh{margin:24px 0 10px;font-size:14px;font-weight:800;color:var(--mut)}
.cbl .tbl{border:1px solid var(--line);border-radius:16px;overflow:hidden}
.cbl .tbl .r{display:grid;grid-template-columns:1.5fr .8fr .8fr 1.3fr;gap:10px;padding:12px 16px;align-items:center;border-top:1px solid var(--line);font-size:15px}
.cbl .tbl .r.h{background:var(--soft);border-top:0;font-size:13px;font-weight:800;color:var(--mut)}
.cbl .tbl .c{font-style:normal;display:inline-block;padding:2px 12px;border-radius:99px;font-size:13.5px;font-weight:700}
.cbl .tbl .c.g{background:var(--okbg);color:#c4f2d9}.cbl .tbl .c.r{background:var(--badbg);color:#ffc2d6}
.cbl .tbl .c.k{background:var(--okbg);color:#c4f2d9}.cbl .tbl .c.y{background:var(--warnbg);color:#ffe9b8}.cbl .tbl .c.b{background:var(--badbg);color:#ffc2d6}

/* הכותרות בגופן הכותרות של האתר (יש לו משקל אחד) */
.cbl h1,.cbl h2,.cbl h3,.cbl h4{font-family:var(--display);font-weight:400}

@media (max-width:860px){
  .cbl{font-size:16px}
  .cbl .hero{grid-template-columns:1fr;gap:34px;padding:44px 0 36px}
  .cbl .scenes,.cbl .cmp,.cbl .stats{grid-template-columns:1fr}
  .cbl .task .th{flex-direction:column;text-align:center}.cbl .tbl .r{grid-template-columns:1fr 1fr;row-gap:6px}.cbl .tbl .r.h{display:none}
  .cbl .mx{grid-template-columns:26px 1fr 1fr;gap:8px}.cbl .q{padding:12px}.cbl .q .ex,.cbl .q p{display:none}.cbl .q .e{font-size:30px}.cbl .q h4{font-size:15px}
}
@media (prefers-reduced-motion:reduce){.cbl *{animation:none!important;transition:none!important}}
</style>

<!-- ============ HERO ============ -->
<div class="hero">
  <div>
    <span class="crumb">מודול 1 · שיעור 4</span>
    <h1>הטבח החדש<br><em>במטבח שלכם</em></h1>
    <p class="sub">מהיר, מוכשר, מכיר כל מתכון. ויש לו בעיה אחת: הוא לא מכיר את המסעדה שלכם.</p>
    <span class="tag">המודל המנטלי: במה ה-AI חזק, ואיפה הוא טועה</span>
  </div>
  <div class="menu">
    <span class="pin"></span>
    <h4>THE RESTAURANT MENU · CLAUDE.md</h4>
    <div class="big">מה הטבח חייב לדעת</div>
    <div class="row"><span>בלי בוטנים, אף פעם</span><code>Rules</code></div>
    <div class="row"><span>הדלפק נפתח ב-8</span><code>Commands</code></div>
    <div class="row"><span>מרק רק בקערות כחולות</span><code>Conventions</code></div>
    <div class="cap">הטבח הכי טוב צריך לקרוא את זה לפני שמתחיל.</div>
  </div>
</div>

<!-- ============ היום הראשון ============ -->
<div class="sec rv">
  <h2>היום הראשון של הטבח</h2>
  <p class="lead">שלושה דברים שכדאי לדעת על Claude Code.</p>
  <div class="scenes">
    <div class="scene"><div class="ico">👨‍🍳</div><h3>מהיר ומנוסה</h3><p>מכין מנה בדקות.</p><div class="code"><span><b>בקוד:</b> כותב פונקציה בשניות</span></div></div>
    <div class="scene"><div class="ico">📖</div><h3>לא מכיר את התפריט</h3><p>לא יודע שאצלכם אין בוטנים.</p><div class="code"><span><b>בקוד:</b> כל שיחה מתחילה בלי זיכרון. ה-CLAUDE.md הוא התפריט</span></div></div>
    <div class="scene"><div class="ico">🤷</div><h3>מנחש כשחסר מידע</h3><p>לא יודע כמה מלח? מנחש, בביטחון.</p><div class="code"><span><b>בקוד:</b> ניחוש שנראה בדיוק כמו תשובה נכונה</span></div></div>
  </div>
</div>

<!-- ============ חזק מול זהירות ============ -->
<div class="sec rv">
  <h2>איפה הוא חזק, ואיפה נזהרים</h2>
  <p class="lead">לא כל משימה דורשת אותה רמת זהירות. הנה חלוקה מעשית.</p>
  <div class="cmp">
    <div class="col good">
      <h3><span class="b"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4 10-10"/></svg></span>חזק</h3>
      <div class="it"><b>קוד חוזר ומוכר</b><span>טפסים, ממשקי API רגילים, שמירה במסד נתונים. דפוסים נפוצים שקל לבדוק.</span><em>👨‍🍳 כמו במטבח: לחתוך 100 בצלים</em></div>
      <div class="it"><b>הסבר קוד והודעות שגיאה</b><span>מדביקים שגיאה או שורה לא ברורה ומקבלים הסבר. ואפשר לוודא בהרצה.</span><em>👨‍🍳 כמו במטבח: לתרגם מתכון משפה זרה</em></div>
      <div class="it"><b>בדיקות לפונקציה מוגדרת</b><span>המשימה ברורה והתוצאה ניתנת להרצה.</span><em>👨‍🍳 כמו במטבח: לחזור על מתכון ברור</em></div>
      <div class="it"><b>חיפוש בפרויקט</b><span>"אילו קבצים מטפלים בהתחברות?" חוסך זמן להבין קוד שלא כתבתם.</span><em>👨‍🍳 כמו במטבח: למצוא תבלין במזווה</em></div>
      <div class="it"><b>שינויים קטנים עם בדיקות שמגנות</b><span>ריפקטורינג זהיר, שבו הבדיקות מראות אם משהו נשבר.</span><em>👨‍🍳 כמו במטבח: לתקן מנה אחת ולטעום</em></div>
    </div>
    <div class="col care">
      <h3><span class="b"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"><path d="M12 6v8M12 18v.01"/></svg></span>זהירות</h3>
      <div class="it"><b>אבטחה, הרשאות וסודות</b><span>טעות כאן יקרה, ולא תמיד נראית מיד. קוראים שורה אחרי שורה.</span><em>👨‍🍳 כמו במטבח: לקבוע מה בטוח לאלרגיים</em></div>
      <div class="it"><b>ספריות, חבילות וגרסאות</b><span>הוא עשוי להמליץ על חבילה שלא קיימת, או על דרך שמיושנת. בודקים בתיעוד הרשמי.</span><em>👨‍🍳 כמו במטבח: להזמין מספק שלא קיים</em></div>
      <div class="it"><b>לוגיקה עסקית שלא כתובה בשום מקום</b><span>מה שנמצא רק בראש שלכם הוא לא מכיר. צריך לכתוב לו.</span><em>👨‍🍳 כמו במטבח: מתכון סודי שאף אחד לא כתב</em></div>
      <div class="it"><b>החלטות ארכיטקטורה</b><span>הוא יציע, אתם מכריעים, כי אתם מכירים את ההקשר.</span><em>👨‍🍳 כמו במטבח: לתכנן את כל התפריט</em></div>
      <div class="it"><b>שינויים גדולים בבת אחת</b><span>קשה לסקור, והסיכוי לטעות גדל.</span><em>👨‍🍳 כמו במטבח: לשפץ את המטבח בלילה אחד</em></div>
    </div>
  </div>
</div>

<!-- ============ מספרים ============ -->
<div class="sec rv">
  <h2>שלושה מספרים שכדאי לזכור</h2>
  <p class="lead">ממחקרים וסקרים אמיתיים.</p>
  <div class="stats">
    <div class="stat"><div class="n">66%</div><div class="scn"><i>🍝</i>מנה שנראית מושלמת, ולא בדיוק</div><p>מהמפתחים אומרים שקוד "כמעט נכון" הוא התסכול העיקרי איתם.</p></div>
    <div class="stat"><div class="n">21.7%</div><div class="scn"><i>🚚</i>הזמנה מספק שלא קיים</div><p>מהחבילות שמודלי קוד פתוח המליצו עליהן לא קיימות (לפחות 5.2% במסחריים).</p></div>
    <div class="stat"><div class="n">45%</div><div class="scn"><i>🚪</i>דלת מטבח שנשארה פתוחה</div><p>מהמשימות הכילו פגיעות אבטחה בקוד שנוצר.</p></div>
  </div>
  <div class="src">מקורות: <a href="https://survey.stackoverflow.co/2025/ai" target="_blank" rel="noopener">Stack Overflow 2025</a> · <a href="https://arxiv.org/abs/2406.10279" target="_blank" rel="noopener">Spracklen ואחרים (USENIX 2025)</a> · <a href="https://www.veracode.com/press-release/ai-generated-code-poses-major-security-risks-in-nearly-half-of-all-development-tasks-veracode-research-reveals/" target="_blank" rel="noopener">Veracode 2025</a>. אלה מחקרים מסוימים, על מודלים של זמנם.</div>
</div>

<!-- ============ מטריצה ============ -->
<div class="sec rv">
  <h2>כמה בודקים?</h2>
  <p class="lead">שתי שאלות: כמה יקר אם טעינו, וכמה קל לבדוק.</p>
  <div class="mx">
    <div class="ax" style="grid-row:1;grid-column:1">טעות זולה</div>
    <div class="q a" style="grid-row:1;grid-column:2"><span class="e">🍽️</span><h4>מתקדמים מהר</h4><p>סידור צלחות</p><div class="ex">בקוד: טקסט של כפתור</div></div>
    <div class="q b" style="grid-row:1;grid-column:3"><span class="e">🥄</span><h4>דוגמים</h4><p>טעימה אחת מקדירה גדולה</p><div class="ex">בקוד: שינוי עיצובי נרחב</div></div>
    <div class="ax" style="grid-row:2;grid-column:1">טעות יקרה</div>
    <div class="q c" style="grid-row:2;grid-column:2"><span class="e">🌡️</span><h4>מריצים בדיקות</h4><p>מד חום לבשר</p><div class="ex">בקוד: חישוב מחיר, שמירת נתונים</div></div>
    <div class="q d" style="grid-row:2;grid-column:3"><span class="e">📋</span><h4>קוראים שורה שורה</h4><p>רשימת אלרגנים לתפריט</p><div class="ex">בקוד: הרשאות, אבטחה, מחיקת מידע</div></div>
    <div class="xl" style="grid-row:3;grid-column:2">קל לבדוק</div>
    <div class="xl" style="grid-row:3;grid-column:3">קשה לבדוק</div>
  </div>
</div>

<!-- ============ משימה ============ -->
<div class="task rv">
  <div class="th"><div class="e">📝</div><div><h2>משימה קצרה: 5 דקות</h2><p>מתרגלים את ההחלטה "כמה לבדוק" על משימות אמיתיות שלכם.</p></div></div>
  <div class="tb">
    <ol class="ts">
      <li><span><b>כתבו 5 משימות תכנות</b> מהשבוע האחרון, או כאלה שאתם עומדים לעשות.</span></li>
      <li><span><b>ענו על שתי שאלות לכל משימה:</b> האם טעות תהיה זולה או יקרה? והאם קל או קשה לבדוק?</span></li>
      <li><span><b>בחרו איך לעבוד</b> לפי המטריצה שלמעלה: מתקדמים מהר, דוגמים, מריצים בדיקות, או קוראים שורה שורה.</span></li>
    </ol>
    <div class="exh">דוגמה לטבלה שתמלאו</div>
    <div class="tbl">
      <div class="r h"><span>המשימה</span><span>טעות</span><span>בדיקה</span><span>איך עובדים</span></div>
      <div class="r"><span>טקסט של כפתור</span><span><i class="c g">זולה</i></span><span><i class="c g">קלה</i></span><span><i class="c k">מתקדמים מהר</i></span></div>
      <div class="r"><span>חישוב מחיר בחשבונית</span><span><i class="c r">יקרה</i></span><span><i class="c g">קלה</i></span><span><i class="c y">מריצים בדיקות</i></span></div>
      <div class="r"><span>מי רשאי למחוק נתונים</span><span><i class="c r">יקרה</i></span><span><i class="c r">קשה</i></span><span><i class="c b">קוראים שורה שורה</i></span></div>
    </div>
  </div>
</div>

<script>
(function(){
  var root=document.getElementById(''cbl-4''); if(!root) return;
  root.classList.add(''js'');
  var rv=root.querySelectorAll(''.rv'');
  if(''IntersectionObserver'' in window){
    var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add(''in'');io.unobserve(e.target);}});},{threshold:.02});
    Array.prototype.forEach.call(rv,function(r){io.observe(r);});
  } else { Array.prototype.forEach.call(rv,function(r){r.classList.add(''in'');}); }
})();
</script>
</div>
</body>
</html>
', 4, '2026-10-28T00:00:00.000Z');
