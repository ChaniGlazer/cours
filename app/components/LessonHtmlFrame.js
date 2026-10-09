"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { lessonThemeCss, themeLessonHtml } from "@/lib/lessonTheme";

// כל שיעור HTML הוא קובץ עצמאי ומלא (עם ה-<style>/<script> שלו) - מציגים אותו
// ב-iframe נפרד כדי שלא יתנגש עם ה-CSS/JS של שאר האתר, וכדי שהלוגיקה של השיעור
// (טפסים, כפתורים, אנימציות) תרוץ בדיוק כמו שתוכנן.
// ה-iframe רץ ב-sandbox בלי allow-same-origin, ולכן ההורה לא יכול לקרוא את גובה
// התוכן ישירות (מה שגרם לפס גלילה פנימי). במקום זה מזריקים לשיעור סקריפט קטן
// ששולח את הגובה בפועל דרך postMessage, וההורה מתאים את גובה ה-iframe.
// כמו כן מסתירים את הכותרת העליונה והפוטר של השיעור עצמו (האתר כבר מציג כותרת),
// ושיעורים שמגבילים את ה-body לרוחב קבוע מקבלים רוחב מלא.
const FONTS =
  '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Secular+One&family=Assistant:wght@400;600;700;800&family=JetBrains+Mono:wght@400;600;700&display=swap">';
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

// כל השיעורים (בכל הקורסים) מוצגים בעיצוב הכהה האחיד של האתר: הצבעים מוחלפים בזמן ההצגה בלבד.
export default function LessonHtmlFrame({ html }) {
  const iframeRef = useRef(null);
  const [height, setHeight] = useState(600);
  // הצבעים של השיעור מוחלפים לפלטת האתר בזמן ההצגה; התוכן במסד לא משתנה.
  const themed = useMemo(() => themeLessonHtml(html), [html]);
  const injected = useMemo(() => FONTS + LAYOUT_RESET + "<style>" + lessonThemeCss(html) + "</style>" + HEIGHT_SCRIPT, [html]);

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
      srcDoc={injected + themed}
      title="תוכן השיעור"
      className="lesson-html-frame"
      scrolling="no"
      style={{ height }}
      sandbox="allow-scripts allow-downloads allow-popups"
    />
  );
}
