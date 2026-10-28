DELETE FROM lessons WHERE course_id='vibe-coding' AND slug='lesson-3-install';
INSERT INTO lessons (id, course_id, slug, title, description, video_url, html_content, position, created_at) VALUES ('e8b2f5a07c1d4936b4e0a3d7c59f1b62', 'vibe-coding', 'lesson-3-install', 'שיעור 3 - התקנה והגדרה (Windows)', '', '', '<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>מתקינים את Claude Code במחשב Windows — שיעור 3</title>
<style>
html,body{margin:0;background:transparent}
</style>
</head>
<body>
<div class="cbl" id="cbl-3" dir="rtl" lang="he">

<style>
@import url(''https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap'');
.cbl{--ink:#f4f1fa;--mut:#bdb7d3;--line:#3a3558;--card:#1d1a2d;--soft:#26223b;--brand:#ff7f96;--brand2:#8fb8ff;--ok:#6fe0a0;--okbg:rgba(111,224,160,.1);--warn:#ffd27a;--warnbg:rgba(255,210,122,.1);--note:#8fb8ff;--notebg:rgba(143,184,255,.1);--code:#0e0c17;--display:''Secular One'',''Arial Hebrew'',Arial,sans-serif;
  position:relative;overflow:hidden;width:100%;max-width:100%;margin:0;padding:0 max(18px,calc((100% - 1000px)/2)) 64px;border-radius:0;color:var(--ink);font-family:''Assistant'',system-ui,-apple-system,''Segoe UI'',Arial,sans-serif;font-size:17px;line-height:1.7;box-sizing:border-box;
  background:transparent}
html,body{overflow-x:clip}
.cbl *{box-sizing:border-box;min-width:0}
.cbl h1,.cbl h2,.cbl h3,.cbl p,.cbl ul,.cbl ol{margin:0}
.cbl code{font-family:''JetBrains Mono'',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;unicode-bidi:isolate}
.cbl a{color:var(--brand2);text-decoration-thickness:1px;text-underline-offset:3px}
.cbl svg{display:block}
.cbl.js .rv{opacity:0;transform:translateY(18px);transition:opacity .6s ease,transform .6s ease}
.cbl.js .rv.in{opacity:1;transform:none}

/* hero */
.cbl .hero{display:grid;grid-template-columns:1.05fr .95fr;gap:48px;align-items:center;padding:72px 0 56px}
.cbl .crumb{display:inline-flex;align-items:center;gap:8px;font-size:14px;font-weight:700;color:var(--brand2);background:var(--card);border:1px solid var(--line);padding:6px 14px;border-radius:99px}
.cbl h1{font-size:clamp(34px,5.4vw,54px);line-height:1.12;margin:18px 0 16px}
.cbl h1 em{font-style:normal;background:linear-gradient(90deg,var(--brand2),var(--brand) 50%,var(--warn));-webkit-background-clip:text;background-clip:text;color:transparent;-webkit-text-fill-color:transparent}
.cbl .sub{font-size:19px;color:var(--mut);max-width:520px}
.cbl .heads{display:flex;gap:12px;align-items:flex-start;margin-top:22px;padding:14px 16px;border-radius:14px;background:var(--card);border:1px solid var(--line);border-right:4px solid var(--brand);max-width:540px;font-size:15.5px;line-height:1.6;color:#e6e1f2}.cbl .heads svg{color:var(--brand);flex:none;margin-top:2px}.cbl .heads b{color:var(--ink)}
.cbl .meta{display:flex;gap:10px;flex-wrap:wrap;margin-top:22px}
.cbl .meta>span{display:inline-flex;align-items:center;gap:8px;font-size:14.5px;font-weight:500;background:var(--card);border:1px solid var(--line);padding:7px 14px;border-radius:99px}
.cbl .winlogo{display:grid;grid-template-columns:repeat(2,6px);gap:1.5px}
.cbl .winlogo i{width:6px;height:6px;background:#8fb8ff;display:block}

/* code window */
.cbl .win{direction:ltr;text-align:left;background:var(--code);border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 18px 40px -20px rgba(0,0,0,.6)}
.cbl .wbar{display:flex;gap:7px;align-items:center;padding:11px 14px;background:rgba(244,241,250,.06)}
.cbl .wbar i{width:11px;height:11px;border-radius:50%;display:block;background:#4d4775}
.cbl .wbar span{margin-left:8px;font-size:12px;color:var(--mut);font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace}
.cbl .tbody,.cbl pre.cmd{margin:0;padding:16px 18px;font-family:''JetBrains Mono'',ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;font-size:13.5px;line-height:1.85;color:#f4f1fa;white-space:pre-wrap;word-break:break-word}
.cbl .tbody{min-height:200px}
.cbl .tbody .p,.cbl pre.cmd .p{color:#8fb8ff}
.cbl .tbody .g{color:#6fe0a0}.cbl .tbody .m,.cbl pre.cmd .m{color:#9e97ba}
.cbl pre.cmd .g{color:#6fe0a0}

/* sections */
.cbl .sec{margin-top:56px}
.cbl h2{font-size:clamp(24px,3.6vw,32px);line-height:1.25;margin-bottom:8px}

/* prerequisites */
.cbl .strip{display:grid;grid-template-columns:repeat(3,1fr);background:var(--card);border:1px solid var(--line);border-radius:20px}
.cbl .strip>div{padding:22px 24px;display:flex;gap:14px;align-items:flex-start}
.cbl .strip>div+div{border-right:1px solid var(--line)}
.cbl .ic{width:42px;height:42px;border-radius:12px;background:rgba(255,127,150,.16);color:var(--brand);display:flex;align-items:center;justify-content:center;flex:none}
.cbl .strip b{display:block;font-size:16.5px;font-weight:700;margin-bottom:2px}
.cbl .strip span{color:var(--mut);font-size:14.5px;line-height:1.55;display:block}

/* disclosure */
.cbl details.more{margin-top:14px;background:var(--card);border:1px solid var(--line);border-radius:16px}
.cbl details.more summary{list-style:none;cursor:pointer;display:flex;align-items:center;gap:10px;padding:14px 18px;font-weight:600;font-size:15.5px;color:var(--ink)}
.cbl details.more summary::-webkit-details-marker{display:none}
.cbl details.more summary .chev{margin-right:auto;transition:transform .2s;color:var(--mut)}
.cbl details.more[open] summary .chev{transform:rotate(180deg)}
.cbl details.more .in{padding:4px 18px 18px;display:grid;grid-template-columns:1fr 1fr;gap:16px}
.cbl details.more h4{margin:0 0 6px;font-size:14px;font-weight:700;color:var(--mut)}
.cbl details.more p{font-size:15px;color:var(--mut);margin-top:8px}
.cbl details.more code.k{background:var(--soft);border:1px solid var(--line);border-radius:6px;padding:1px 7px;font-size:13px;color:var(--ink);direction:ltr}

/* steps */
.cbl .steps{margin-top:36px;position:relative}
.cbl .step{display:grid;grid-template-columns:56px 1fr;gap:20px;position:relative}
.cbl .step+.step{margin-top:28px}
.cbl .step:before{content:"";position:absolute;right:27px;top:56px;bottom:-28px;width:2px;background:var(--line)}
.cbl .step:last-child:before{display:none}
.cbl .num{width:56px;height:56px;border-radius:50%;background:var(--brand);color:#14121f;font-family:var(--display);font-size:22px;display:flex;align-items:center;justify-content:center}
.cbl .card{background:var(--card);border:1px solid var(--line);border-radius:22px;padding:30px}
.cbl .card h3{font-size:clamp(22px,3vw,27px);line-height:1.3;margin-bottom:8px}
.cbl .card .lead{color:var(--mut);margin-bottom:18px;max-width:640px}
.cbl .two{display:grid;grid-template-columns:1fr 1fr;gap:28px;align-items:start}
.cbl .card p{color:#e6e1f2}
.cbl .card p+p{margin-top:10px}
.cbl .winpill{display:inline-flex;align-items:center;gap:8px;font-size:12.5px;font-weight:700;color:#8fb8ff;background:rgba(143,184,255,.14);padding:4px 12px;border-radius:99px;margin-bottom:10px}
.cbl .cap{font-size:13px;font-weight:700;color:var(--mut);margin:16px 0 6px}
.cbl .note,.cbl .warn,.cbl .ok{margin-top:16px;padding:13px 16px;border-radius:12px;font-size:15px;line-height:1.6;border-right:4px solid}
.cbl .note{background:var(--notebg);border-color:var(--note);color:#cfe0ff}
.cbl .warn{background:var(--warnbg);border-color:var(--warn);color:#ffe9b8}
.cbl .ok{background:var(--okbg);border-color:var(--ok);color:#c4f2d9}
.cbl .note b,.cbl .warn b,.cbl .ok b{font-weight:800}
.cbl .note code,.cbl .warn code,.cbl .ok code,.cbl .card p code,.cbl .list code{background:rgba(244,241,250,.1);border-radius:6px;padding:1px 7px;font-size:13.5px;direction:ltr}
.cbl .list{margin:4px 0 0;padding:0;list-style:none;counter-reset:l;display:grid;gap:12px}
.cbl .list li{counter-increment:l;display:flex;gap:12px;align-items:flex-start;font-size:15.5px;color:#e6e1f2}
.cbl .list li:before{content:counter(l);width:26px;height:26px;border-radius:50%;background:rgba(255,127,150,.16);color:var(--brand);font-weight:800;font-size:13px;flex:none;display:flex;align-items:center;justify-content:center;margin-top:1px}

/* editor mock */
.cbl .vsm{direction:ltr;background:var(--code);border:1px solid var(--line);border-radius:14px;overflow:hidden;box-shadow:0 18px 40px -20px rgba(0,0,0,.6)}
.cbl .vsm .bd{display:grid;grid-template-columns:40px 1fr 1.1fr;min-height:230px}
.cbl .vsm .act{background:#0a0912;display:flex;flex-direction:column;align-items:center;gap:16px;padding-top:16px}
.cbl .vsm .act i{width:16px;height:16px;border-radius:4px;border:1.5px solid #4d4775;display:block}
.cbl .vsm .act i.on{border-color:#ffd27a;background:rgba(255,210,122,.25)}
.cbl .vsm .ed{padding:12px 14px;font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace;font-size:12px;color:#e6e1f2;border-inline:1px solid #26223b;position:relative}
.cbl .vsm .ed .tab{display:inline-block;background:#26223b;padding:2px 10px;border-radius:6px 6px 0 0;font-size:11px;color:#9e97ba;margin-bottom:10px}
.cbl .vsm .ed .tb{position:absolute;top:10px;right:12px;width:18px;height:18px;border-radius:5px;background:rgba(255,210,122,.2);border:1.5px solid #ffd27a}
.cbl .vsm .ed div{line-height:1.75;white-space:pre}
.cbl .vsm .ed .sel{background:rgba(143,184,255,.3);border-radius:4px}
.cbl .vsm .cp{padding:12px 14px;font-size:12.5px;display:flex;flex-direction:column;gap:8px;font-family:''Assistant'',system-ui,sans-serif;direction:rtl;color:#f4f1fa}
.cbl .vsm .cp .h{font-size:11px;color:#9e97ba;direction:ltr;text-align:left}
.cbl .vsm .bub{padding:8px 12px;border-radius:12px;background:#26223b;line-height:1.5}
.cbl .vsm .bub.me{background:rgba(255,127,150,.28);align-self:flex-start}
.cbl .vsm .sb{display:flex;justify-content:space-between;padding:4px 12px;background:var(--brand);font-size:11px;color:#14121f;font-family:''JetBrains Mono'',ui-monospace,Menlo,Consolas,monospace}
.cbl .keys{display:flex;gap:8px;flex-wrap:wrap;margin-top:16px;font-size:14.5px;color:var(--mut)}
.cbl .keys code{background:var(--soft);border:1px solid var(--line);border-radius:6px;padding:1px 8px;font-size:13px;direction:ltr;color:var(--ink)}

/* final check */
.cbl .check{margin-top:48px;background:var(--card);border:1px solid var(--line);border-radius:22px;padding:28px 30px}
.cbl .check h2{margin-bottom:16px}
.cbl .ck3{display:grid;grid-template-columns:repeat(3,1fr);gap:14px}
.cbl .ck3>div{display:flex;gap:12px;align-items:flex-start;padding:16px;border-radius:14px;background:var(--okbg);border:1px solid rgba(111,224,160,.4)}
.cbl .ck3 .tick{width:26px;height:26px;border-radius:50%;background:var(--ok);color:#14121f;flex:none;display:flex;align-items:center;justify-content:center}
.cbl .ck3 b{display:block;font-size:15.5px;font-weight:700;margin-bottom:2px}
.cbl .ck3 span{font-size:14px;color:#c4f2d9;display:block;line-height:1.5}
.cbl .ck3 code{background:rgba(244,241,250,.12);border-radius:6px;padding:0 6px;font-size:12.5px;direction:ltr;color:#f4f1fa}
.cbl .src{font-size:13px;color:var(--mut);margin-top:18px}

/* הכותרות בגופן הכותרות של האתר (יש לו משקל אחד) */
.cbl h1,.cbl h2,.cbl h3{font-family:var(--display);font-weight:400}

@media (max-width:860px){
  .cbl{font-size:16px}
  .cbl .hero{grid-template-columns:1fr;gap:28px;padding:44px 0 36px}
  .cbl .strip{grid-template-columns:1fr}.cbl .strip>div+div{border-right:0;border-top:1px solid var(--line)}
  .cbl .two,.cbl .ck3,.cbl details.more .in{grid-template-columns:1fr}
  .cbl .step{grid-template-columns:40px 1fr;gap:12px}.cbl .num{width:40px;height:40px;font-size:17px}.cbl .step:before{right:19px;top:42px}
  .cbl .card{padding:20px 16px;border-radius:18px}.cbl .vsm .bd{grid-template-columns:34px 1fr}.cbl .vsm .cp{display:none}
}
@media (prefers-reduced-motion:reduce){.cbl *{animation:none!important;transition:none!important}}
</style>

<!-- ============ HERO ============ -->
<div class="hero">
  <div>
    <span class="crumb">מודול 1 · שיעור 3</span>
    <h1>מתקינים את Claude Code<br><em>במחשב Windows</em></h1>
    <p class="sub">שלושה צעדים קצרים: התקנה, התחברות ותוסף ל-VS Code. בסוף תוכלו לעבוד איתו גם בטרמינל וגם בעורך.</p>
    <div class="heads">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M12 8v5M12 16.5v.01"/></svg>
      <div><b>שימו לב: זה שיעור קצת טכני.</b> התקנות והגדרות, אין מה לעשות. זה לוקח כמה דקות, ומיד אחרי זה עוברים לדברים המעניינים.</div>
    </div>
    <div class="meta">
      <span><span class="winlogo"><i></i><i></i><i></i><i></i></span>Windows</span>
      <span>3 צעדים</span>
      <span>כ-10 דקות</span>
    </div>
  </div>
  <div class="win">
    <div class="wbar"><i></i><i></i><i></i><span>PowerShell</span></div>
    <div class="tbody" id="cbl-term"></div>
  </div>
</div>

<!-- ============ לפני שמתחילים ============ -->
<div class="rv">
  <div class="strip">
    <div><span class="ic"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="8" cy="12" r="4"/><path d="M12 12h9M18 12v3"/></svg></span><div><b>חשבון Claude</b><span>מנוי בתשלום (Pro, Max, Team או Enterprise) או חשבון Claude Console.</span></div></div>
    <div><span class="ic"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="16" rx="3"/><path d="M7 10l3 2-3 2M12 15h5"/></svg></span><div><b>PowerShell</b><span>מגיע עם Windows. פותחים אותו מתפריט התחלה: מקלידים PowerShell.</span></div></div>
    <div><span class="ic"><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="6" cy="5" r="2"/><circle cx="6" cy="19" r="2"/><circle cx="18" cy="9" r="2"/><path d="M6 7v10M18 11c0 4-6 3-12 6"/></svg></span><div><b>Git for Windows</b><span>מומלץ. בלעדיו Claude Code עובד עם PowerShell במקום Bash. <a href="https://git-scm.com/downloads/win" target="_blank" rel="noopener">להורדה</a></span></div></div>
  </div>

  <details class="more">
    <summary>
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="12" rx="2"/><path d="M8 20h8M12 16v4"/></svg>
      עובדים על Mac או Linux? ההוראות כאן
      <svg class="chev" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 9l6 6 6-6"/></svg>
    </summary>
    <div class="in">
      <div>
        <h4>התקנה (Mac, Linux, WSL)</h4>
        <div class="win"><pre class="cmd">curl -fsSL https://claude.ai/install.sh | bash</pre></div>
        <p>אפשר גם ב-Mac עם Homebrew: <code class="k">brew install --cask claude-code</code></p>
      </div>
      <div>
        <h4>מה שונה בשאר השיעור</h4>
        <p style="margin-top:0">פותחים את אפליקציית Terminal במקום PowerShell, ובשאר השיעור כל מה שנאמר על <code class="k">claude</code> נשאר זהה.</p>
        <p>ב-VS Code: <code class="k">Cmd+Shift+X</code> לתוספים ו-<code class="k">Option+K</code> להוספת שורות נבחרות. אם <code class="k">claude</code> לא מזוהה:</p>
        <div class="win" style="margin-top:8px"><pre class="cmd">echo ''export PATH="$HOME/.local/bin:$PATH"'' >> ~/.zshrc</pre></div>
        <p>(ב-bash משתמשים ב-<code class="k">~/.bashrc</code>). אחר כך פותחים טרמינל חדש.</p>
      </div>
    </div>
  </details>
</div>

<!-- ============ הצעדים ============ -->
<div class="steps">

  <div class="step rv">
    <div class="num">1</div>
    <div class="card">
      <span class="winpill"><span class="winlogo"><i></i><i></i><i></i><i></i></span>PowerShell</span>
      <h3>מתקינים את Claude Code</h3>
      <p class="lead">פותחים PowerShell ומדביקים פקודה אחת. ההתקנה לא מציגה התקדמות בזמן ההורדה, אז ממתינים עד שהיא מסתיימת.</p>
      <div class="two">
        <div>
          <div class="cap">1. מדביקים ב-PowerShell</div>
          <div class="win"><div class="wbar"><i></i><i></i><i></i><span>PowerShell</span></div><pre class="cmd"><span class="p">PS C:\&gt;</span> irm https://claude.ai/install.ps1 | iex</pre></div>
          <div class="cap">2. פותחים חלון PowerShell חדש ובודקים</div>
          <div class="win"><div class="wbar"><i></i><i></i><i></i><span>PowerShell</span></div><pre class="cmd"><span class="p">PS C:\&gt;</span> claude --version</pre></div>
        </div>
        <div>
          <div class="ok"><b>הצליח?</b> הפקודה השנייה מדפיסה מספר גרסה ואחריו <code>(Claude Code)</code>.</div>
          <div class="warn"><b>קיבלתם שגיאה?</b> בדקו שהשורה מתחילה ב-<code>PS C:\</code>. בלי <code>PS</code> אתם ב-CMD, והפקודה לא תזוהה. פתחו PowerShell, או הדביקו ב-CMD את הפקודה הזו:<div class="win" style="margin-top:8px"><pre class="cmd" style="font-size:12px">curl -fsSL https://claude.ai/install.cmd -o install.cmd &amp;&amp; install.cmd &amp;&amp; del install.cmd</pre></div></div>
          <div class="note"><b>claude לא מזוהה?</b> סגרו את החלון ופתחו חדש. אם זה נמשך, הוסיפו את התיקייה ל-PATH:
            <div class="win" style="margin-top:8px"><pre class="cmd" style="font-size:12px">$p = [Environment]::GetEnvironmentVariable(''PATH'',''User'')
[Environment]::SetEnvironmentVariable(''PATH'',"$p;$env:USERPROFILE\.local\bin",''User'')</pre></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="step rv">
    <div class="num">2</div>
    <div class="card">
      <span class="winpill"><span class="winlogo"><i></i><i></i><i></i><i></i></span>PowerShell</span>
      <h3>מתחברים ומפעילים</h3>
      <div class="two">
        <div>
          <p>נכנסים לתיקיית הפרויקט מהשיעור הקודם ומפעילים את <code>claude</code>.</p>
          <p>בפעם הראשונה ייפתח הדפדפן להתחברות. מאשרים, וההתחברות נשמרת, כך שאין צורך לחזור עליה.</p>
          <div class="note"><b>טיפ:</b> בתוך Claude Code אפשר להקליד <code>/help</code> לרשימת הפקודות, או <code>/login</code> כדי להחליף חשבון.</div>
        </div>
        <div class="win"><div class="wbar"><i></i><i></i><i></i><span>PowerShell</span></div><pre class="cmd"><span class="p">PS C:\&gt;</span> cd url-shortener
<span class="p">PS C:\url-shortener&gt;</span> claude

<span class="m"># first time only: a browser opens.
# approve the login and come back.</span></pre></div>
      </div>
    </div>
  </div>

  <div class="step rv">
    <div class="num">3</div>
    <div class="card">
      <span class="winpill">VS Code</span>
      <h3>מוסיפים את התוסף ל-VS Code</h3>
      <p class="lead">התוסף נותן את אותו Claude בתוך העורך, כולל השוואה בין הקוד הישן להצעה. נדרשת גרסה 1.94.0 ומעלה של VS Code.</p>
      <div class="two">
        <div>
          <ol class="list">
            <li><span>פותחים את תצוגת ההרחבות עם <code>Ctrl+Shift+X</code>.</span></li>
            <li><span>מחפשים <code>Claude Code</code> (המפרסם: Anthropic) ולוחצים <b>Install</b>.</span></li>
            <li><span>פותחים את החלונית דרך האייקון בפינה הימנית העליונה של העורך (מופיע כשיש קובץ פתוח), או דרך <b>✻ Claude Code</b> בשורת המצב.</span></li>
            <li><span>לוחצים <b>Sign in</b> ומאשרים בדפדפן.</span></li>
          </ol>
          <div class="keys"><span>לשלוח שורות נבחרות ל-Claude:</span><code>Alt+K</code></div>
          <div class="note"><b>חשוב:</b> התוסף משלים את ה-CLI ולא מחליף אותו. הפקודה <code>claude</code> בטרמינל מגיעה מצעד 1. אם התוסף לא מופיע, הפעילו מחדש את VS Code.</div>
        </div>
        <div class="vsm" aria-hidden="true">
          <div class="bd">
            <div class="act"><i></i><i></i><i class="on"></i></div>
            <div class="ed"><span class="tab">main.py</span><span class="tb"></span>
<div>def shorten(url):</div>
<div class="sel">    code = random_code(6)</div>
<div>    links[code] = url</div>
<div>    return code</div></div>
            <div class="cp"><div class="h">Claude Code</div><div class="bub me">מה השורה המסומנת עושה?</div><div class="bub">היא מייצרת קוד אקראי בן 6 תווים לקישור הקצר.</div></div>
          </div>
          <div class="sb"><span>Claude Code</span><span>main.py</span></div>
        </div>
      </div>
    </div>
  </div>

</div>

<!-- ============ בדיקה אחרונה ============ -->
<div class="check rv">
  <h2>בדיקה אחרונה</h2>
  <div class="ck3">
    <div><span class="tick"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4 10-10"/></svg></span><div><b>ההתקנה</b><span><code>claude --version</code> מדפיס גרסה</span></div></div>
    <div><span class="tick"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4 10-10"/></svg></span><div><b>הפרויקט</b><span><code>claude</code> נפתח בתיקיית הפרויקט, ו-<code>/context</code> מראה את ה-CLAUDE.md</span></div></div>
    <div><span class="tick"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12l4 4 10-10"/></svg></span><div><b>העורך</b><span>החלונית ב-VS Code עונה על שאלה לגבי שורה נבחרת</span></div></div>
  </div>
  <p class="src">מקורות: <a href="https://code.claude.com/docs/en/quickstart" target="_blank" rel="noopener">Quickstart</a> · <a href="https://code.claude.com/docs/en/vs-code" target="_blank" rel="noopener">VS Code</a> · <a href="https://code.claude.com/docs/en/troubleshoot-install" target="_blank" rel="noopener">Troubleshoot installation</a></p>
</div>

<script>
(function(){
  var root=document.getElementById(''cbl-3''); if(!root) return;
  root.classList.add(''js'');
  function mk(tag,cls,txt){var e=document.createElement(tag);if(cls)e.className=cls;if(txt!=null)e.textContent=txt;return e;}
  var rv=root.querySelectorAll(''.rv'');
  if(''IntersectionObserver'' in window){
    var io=new IntersectionObserver(function(es){es.forEach(function(e){if(e.isIntersecting){e.target.classList.add(''in'');io.unobserve(e.target);}});},{threshold:.02});
    Array.prototype.forEach.call(rv,function(r){io.observe(r);});
  } else { Array.prototype.forEach.call(rv,function(r){r.classList.add(''in'');}); }
  var T=[
    [''p'',''PS C:\\> irm https://claude.ai/install.ps1 | iex''],
    [''m'',''  installing... (no progress is shown, wait)''],
    [''p'',''PS C:\\> claude --version''],
    [''g'',''  <version> (Claude Code)''],
    [''p'',''PS C:\\> cd url-shortener''],
    [''p'',''PS C:\\url-shortener> claude''],
    [''g'',''  Claude Code ready.'']
  ];
  var term=document.getElementById(''cbl-term''),li=0,ci=0,cur=null;
  function typeLine(){
    if(!term||li>=T.length)return;
    if(ci===0){cur=mk(''div'',T[li][0]);term.appendChild(cur);}
    var txt=T[li][1];cur.textContent=txt.slice(0,++ci);
    if(ci>=txt.length){li++;ci=0;setTimeout(typeLine,400);}else setTimeout(typeLine,14);
  }
  typeLine();
})();
</script>
</div>
</body>
</html>
', 3, '2026-10-28T00:00:00.000Z');
