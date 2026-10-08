"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { LESSON_THEME_CSS, themeLessonHtml } from "@/lib/lessonTheme";

// כל שיעור HTML הוא קובץ עצמאי ומלא (עם ה-<style>/<script> שלו) - מציגים אותו
// ב-iframe נפרד כדי שלא יתנגש עם ה-CSS/JS של שאר האתר, וכדי שהלוגיקה של השיעור
// (טפסים, כפתורים, אנימציות) תרוץ בדיוק כמו שתוכנן.
// ה-iframe רץ ב-sandbox בלי allow-same-origin, ולכן ההורה לא יכול לקרוא את גובה
// התוכן ישירות (מה שגרם לפס גלילה פנימי). במקום זה מזריקים לשיעור סקריפט קטן
// ששולח את הגובה בפועל דרך postMessage, וההורה מתאים את גובה ה-iframe.
// כמו כן מסתירים את הכותרת העליונה והפוטר של השיעור עצמו (האתר כבר מציג כותרת),
// ושיעורים שמגבילים את ה-body לרוחב קבוע מקבלים רוחב מלא.
const FONTS =
  '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@500;700&family=Heebo:wght@400;500;600;700;800&display=swap">';
const HIDE_INNER_CHROME = ".topbar,.scroll-progress,footer{display:none!important}";
const HEIGHT_SCRIPT =
  "<script>(function(){function send(){var h=Math.ceil(document.documentElement.getBoundingClientRect().height);" +
  "parent.postMessage({type:'lesson-height',h:h},'*');}" +
  "addEventListener('load',send);addEventListener('resize',send);" +
  "if(window.ResizeObserver){new ResizeObserver(send).observe(document.documentElement);}" +
  "setInterval(send,700);})();</script>";
const LAYOUT_RESET =
  "<style>html,body{width:100%;max-width:none!important;margin-left:0!important;margin-right:0!important;overflow-y:hidden!important}" +
  "body>*{max-width:none!important}" + HIDE_INNER_CHROME + "</style>";

// ערכת הנושא הרגילה של האתר (החלפת צבעים בזמן ההצגה)
const INJECTED = FONTS + LAYOUT_RESET + "<style>" + LESSON_THEME_CSS + "</style>" + HEIGHT_SCRIPT;

// ערכת הנושא python-soft: השיעור עצמו לא משתנה. מוסיפים רק data-theme על <html> וקישור
// ל-/themes/python-soft.css בסוף ה-<head> (אחרי ה-CSS של השיעור), והקובץ דורס מראה בלבד.
const SOFT_FONTS =
  '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>' +
  '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Rubik:wght@500;600;700;800&family=Assistant:wght@400;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap">';
const SOFT_INJECTED = SOFT_FONTS + LAYOUT_RESET + HEIGHT_SCRIPT;

// שיעורים שנכתבו כבר בסגנון python-soft (למשל "פונקציות") נשארים כמו שהם: לא מוסיפים להם את הערכה,
// ורק מאפשרים לרקע של האתר לעבור דרכם, כדי שלא יופיע "קופסה" סביב ה-iframe.
function isNativeSoft(html) {
  return /--cyan:[ ]*#5B6CFF/i.test(html) && /--violet:[ ]*#FF7B6B/i.test(html);
}
const NATIVE_BLEND = "<style>html,body{background:transparent!important}body::before{display:none!important}</style>";

function applySoftTheme(html) {
  let out = html.replace(/<html\b/i, '<html data-theme="python-soft"');
  out = out.replace(/<\/head>/i, '<link rel="stylesheet" href="/themes/python-soft.css"></head>');
  return out;
}

export default function LessonHtmlFrame({ html, theme }) {
  const iframeRef = useRef(null);
  const [height, setHeight] = useState(600);
  // הצבעים של השיעור מוחלפים לפלטת האתר בזמן ההצגה בלבד; התוכן במסד לא משתנה.
  const soft = theme === "python-soft";
  const native = soft && isNativeSoft(html);
  const themed = useMemo(() => (soft ? (native ? html : applySoftTheme(html)) : themeLessonHtml(html)), [html, soft, native]);

  useEffect(() => {
    function onMessage(e) {
      if (e.source !== iframeRef.current?.contentWindow) return;
      if (e.data?.type === "lesson-height" && e.data.h > 0) setHeight(e.data.h);
    }
    window.addEventListener("message", onMessage);
    return () => window.removeEventListener("message", onMessage);
  }, []);

  return (
    <iframe
      ref={iframeRef}
      srcDoc={(soft ? SOFT_INJECTED + (native ? NATIVE_BLEND : "") : INJECTED) + themed}
      title="תוכן השיעור"
      className="lesson-html-frame"
      scrolling="no"
      style={{ height }}
      sandbox="allow-scripts allow-downloads allow-popups"
    />
  );
}
