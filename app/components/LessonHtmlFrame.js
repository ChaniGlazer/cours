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
// reportProgress(done, total, complete) - הפונקציה המשותפת שכל שיעור קורא לה בנקודות שבהן תרגיל חובה הושלם.
// כותבים אותה כאן (ולא בכל שיעור) כדי שיהיה מקור אחד: שיעור רק קורא לה, והיא שולחת להורה lesson-progress
// כשההתקדמות משתנה, ו-lesson-complete פעם אחת בלבד (כש-done >= total, או כש-complete === true).
// ה-slug לא נשלח, כי ההורה כבר יודע איזה שיעור הוא מציג. השיעורים קוראים לה רק אם היא קיימת, כך שקובץ שנפתח לבד לא נשבר.
const REPORT_SCRIPT =
  "<script>(function(){var last=-1,sent=false;" +
  "window.reportProgress=function(done,total,complete){" +
  "done=Number(done);total=Number(total);if(!(total>0)||!(done>=0))return;if(done>total)done=total;" +
  "if(done!==last){last=done;parent.postMessage({type:'lesson-progress',done:done,total:total},'*');}" +
  "if(!sent&&(complete===undefined?done>=total:complete===true)){sent=true;parent.postMessage({type:'lesson-complete'},'*');}" +
  "};})();</script>";
const LAYOUT_RESET =
  "<style>html,body{width:100%;max-width:none!important;margin-left:0!important;margin-right:0!important;overflow-y:hidden!important}" +
  "body>*{max-width:none!important}" + HIDE_INNER_CHROME + "</style>";

// הודעות נוספות מהשיעור (למשל lesson-progress ו-lesson-complete) מועברות להורה ב-prop onMessage.
// ה-origin של ה-iframe הוא "null" (sandbox בלי allow-same-origin), ולכן הזהות נבדקת לפי event.source בלבד.
// כל השיעורים (בכל הקורסים) מוצגים בעיצוב הכהה האחיד של האתר: הצבעים מוחלפים בזמן ההצגה בלבד.
export default function LessonHtmlFrame({ html, onMessage }) {
  const iframeRef = useRef(null);
  const onMessageRef = useRef(onMessage);
  const [height, setHeight] = useState(600);
  // הצבעים של השיעור מוחלפים לפלטת האתר בזמן ההצגה; התוכן במסד לא משתנה.
  const themed = useMemo(() => themeLessonHtml(html), [html]);
  const injected = useMemo(() => FONTS + LAYOUT_RESET + "<style>" + lessonThemeCss(html) + "</style>" + HEIGHT_SCRIPT + REPORT_SCRIPT, [html]);

  // ה-callback נשמר ב-ref כדי שהאזנה אחת תישאר פעילה גם כשההורה יוצר פונקציה חדשה בכל רינדור.
  useEffect(() => {
    onMessageRef.current = onMessage;
  }, [onMessage]);

  useEffect(() => {
    function handleMessage(e) {
      if (e.source !== iframeRef.current?.contentWindow) return;
      const data = e.data;
      if (!data || typeof data !== "object") return;
      if (data.type === "lesson-height") {
        if (data.h > 0) setHeight(data.h);
        return;
      }
      onMessageRef.current?.(data);
    }
    window.addEventListener("message", handleMessage);
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  return (
    <iframe
      ref={iframeRef}
      srcDoc={injected + themed}
      title="תוכן השיעור"
      className="lesson-html-frame"
      scrolling="no"
      style={{ height }}
      sandbox="allow-scripts allow-downloads allow-popups allow-top-navigation-by-user-activation"
    />
  );
}
