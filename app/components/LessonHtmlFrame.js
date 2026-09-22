"use client";

import { useRef, useState } from "react";

// כל שיעור HTML הוא קובץ עצמאי ומלא (עם ה-<style>/<script> שלו) - מציגים אותו
// ב-iframe נפרד כדי שלא יתנגש עם ה-CSS/JS של שאר האתר, וכדי שהלוגיקה של השיעור
// (טפסים, כפתורים, אנימציות) תרוץ בדיוק כמו שתוכנן. הגובה מתעדכן אוטומטית לפי
// התוכן בפועל, כולל כשה-iframe נמצא בהתחלה בתוך אקורדיון סגור (ResizeObserver
// תופס את השינוי ברגע שהוא נפתח ומקבל גובה אמיתי).
export default function LessonHtmlFrame({ html }) {
  const iframeRef = useRef(null);
  const observerRef = useRef(null);
  const [height, setHeight] = useState(600);

  function handleLoad() {
    const doc = iframeRef.current?.contentWindow?.document;
    if (!doc?.documentElement) return;

    if (observerRef.current) observerRef.current.disconnect();

    const update = () => setHeight(doc.documentElement.scrollHeight || 600);
    update();

    if (typeof ResizeObserver !== "undefined") {
      observerRef.current = new ResizeObserver(update);
      observerRef.current.observe(doc.documentElement);
    }
  }

  return (
    <iframe
      ref={iframeRef}
      srcDoc={html}
      onLoad={handleLoad}
      title="תוכן השיעור"
      className="lesson-html-frame"
      style={{ height }}
      sandbox="allow-scripts allow-downloads allow-popups"
    />
  );
}
