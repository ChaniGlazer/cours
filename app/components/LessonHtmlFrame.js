"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { lessonThemeCss, themeLessonHtml } from "@/lib/lessonTheme";
import { PYX_RUNNER_SCRIPT } from "./pyxRunner";
import { PYX_TERMINAL_SCRIPT } from "./pyxTerminal";

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
  "<script>(function(){var last=-1,tot=0,sent=false;" +
  "window.reportProgress=function(done,total,complete){" +
  "done=Number(done);total=Number(total);if(!(total>0)||!(done>=0))return;if(done>total)done=total;" +
  "tot=total;if(done!==last){last=done;parent.postMessage({type:'lesson-progress',done:done,total:total},'*');}" +
  "if(!sent&&(complete===undefined?done>=total:complete===true)){sent=true;parent.postMessage({type:'lesson-complete'},'*');}" +
  "};" +
  // השיעור יכול להיטען לפני שההורה מחובר (hydration) ולפספס את הודעת ההתחלה, ולכן ההורה מבקש שליחה חוזרת.
  "addEventListener('message',function(e){if(e.source===parent&&e.data&&e.data.type==='lesson-parent-ready'&&last>=0)" +
  "parent.postMessage({type:'lesson-progress',done:last,total:tot},'*');});})();</script>";
// זיהוי התרגיל הפעיל בשיעור, עבור החונכת (TutorWidget). הפונקציה מוזרקת ל-iframe כטקסט (toString), ולכן היא עצמאית לגמרי:
// בלי התייחסות למשתנים מחוץ לה, ובתחביר פשוט (ES5). כשהלומדת מתמקדת בתרגיל, מקלידה בו או לוחצת בו, נשלחת להורה
// { type: "tutor-context", topicKey, code }: topicKey הוא "exN" (לפי ids שמתחילים ב-exN, או כותרת "תרגיל N"), או במשחקים של
// השיעורים: puzzle-N (פאזלי ההרכבה בשיעור הפונקציות), robot-N ו-prediction (שיעור הפתיחה). code הוא מה שנכתב בתרגיל (textarea,
// או הקוד של התרגיל עם ערכי השדות שמולאו). שיעור שאי אפשר לזהות בו תרגיל לא שולח כלום, וההורה משתמש ב-"general".
function tutorContextProbe() {
  var MAX_CODE = 4000;
  var lastKey = "";
  var timer = null;

  function numOf(id) {
    var m = /^ex(\d+)(?:-|$)/.exec(id || "");
    return m ? m[1] : null;
  }

  // מספר התרגיל של צומת: כל ה-ids שמתחילים ב-exN בתוכו (או הוא עצמו) חייבים להיות של אותו N, אחרת הצומת רחב מדי.
  function exerciseOf(node) {
    var nums = {};
    var count = 0;
    var own = numOf(node.id);
    var i;
    var n;
    if (own) {
      nums[own] = 1;
      count = 1;
    }
    var withIds = node.querySelectorAll ? node.querySelectorAll("[id]") : [];
    for (i = 0; i < withIds.length; i++) {
      n = numOf(withIds[i].id);
      if (n && !nums[n]) {
        nums[n] = 1;
        count++;
      }
    }
    if (count === 1) return "ex" + Object.keys(nums)[0];
    if (count === 0 && node.querySelectorAll) {
      var heads = node.querySelectorAll(".exercise-num, .task-num");
      if (heads.length === 1) {
        var m = /(\d+)/.exec(heads[0].textContent || "");
        if (m) return "ex" + m[1];
      }
    }
    return null;
  }

  function activeIndex(selector) {
    var els = document.querySelectorAll(selector);
    for (var i = 0; i < els.length; i++) {
      if (els[i].classList.contains("active") || els[i].classList.contains("on")) return i;
    }
    return -1;
  }

  function topicOf(el) {
    if (!el || !el.closest) return null;
    var idx;
    if (el.closest("#puzzle")) {
      idx = activeIndex("#puz-tabs .m-tab");
      return idx >= 0 ? "puzzle-" + (idx + 1) : null;
    }
    if (el.closest("#robot")) {
      idx = activeIndex("#lvl-tabs button");
      return idx >= 0 ? "robot-" + (idx + 1) : null;
    }
    var task = el.closest(".task-card");
    if (task && task.querySelector("#pred-opts")) return "prediction";
    var node = el;
    while (node && node !== document.body && node !== document.documentElement) {
      var t = exerciseOf(node);
      if (t) return t;
      node = node.parentElement;
    }
    return null;
  }

  // הצומת הגדול ביותר שעדיין שייך לאותו תרגיל (כרטיס התרגיל), כדי לקרוא ממנו את הקוד.
  function cardOf(el, topic) {
    var card = null;
    var node = el;
    while (node && node !== document.body && node !== document.documentElement) {
      var t = exerciseOf(node);
      if (t === topic) card = node;
      else if (card) break;
      node = node.parentElement;
    }
    return card;
  }

  function codeOf(el, topic) {
    var i;
    var lines;
    if (topic.indexOf("puzzle-") === 0) {
      var built = document.querySelectorAll("#puz-built .pline");
      lines = [];
      for (i = 0; i < built.length; i++) lines.push(built[i].textContent);
      return lines.join("\n");
    }
    if (topic.indexOf("robot-") === 0) {
      var rc = document.getElementById("rb-code");
      return rc ? rc.textContent || "" : "";
    }
    var card = cardOf(el, topic);
    if (!card) return "";
    var area = card.querySelector("textarea");
    if (area) return area.value || "";
    var block = card.querySelector(".exercise-code, .ex-code, pre");
    if (!block) return "";
    var clone = block.cloneNode(true);
    var from = block.querySelectorAll("input, select");
    var to = clone.querySelectorAll("input, select");
    for (i = 0; i < to.length; i++) {
      var v = from[i] && from[i].value ? from[i].value : "___";
      to[i].parentNode.replaceChild(document.createTextNode(v), to[i]);
    }
    return clone.textContent || "";
  }

  function send(el) {
    var topic = topicOf(el);
    if (!topic) return;
    var code = codeOf(el, topic).replace(/\s+$/, "").slice(0, MAX_CODE);
    var key = topic + "|" + code;
    if (key === lastKey) return;
    lastKey = key;
    parent.postMessage({ type: "tutor-context", topicKey: topic, code: code }, "*");
  }

  document.addEventListener("focusin", function (e) { send(e.target); }, true);
  // לחיצה במשחקים (פאזל, רובוט) בונה מחדש את ה-DOM, והאלמנט שנלחץ כבר לא מחובר כשהקוד נקרא. לכן מעגנים לחלק הקבוע של המשחק.
  document.addEventListener("click", function (e) {
    var target = e.target;
    var anchor = target.closest ? target.closest("#puzzle") || target.closest("#robot") || target : target;
    setTimeout(function () { send(anchor); }, 60);
  }, true);
  document.addEventListener("input", function (e) {
    var target = e.target;
    clearTimeout(timer);
    timer = setTimeout(function () { send(target); }, 400);
  }, true);
}
const TUTOR_CONTEXT_SCRIPT = "<script>(" + tutorContextProbe.toString() + ")();</script>";

const LAYOUT_RESET =
  "<style>html,body{width:100%;max-width:none!important;margin-left:0!important;margin-right:0!important;overflow-y:hidden!important}" +
  "body>*{max-width:none!important}" + HIDE_INNER_CHROME + "</style>";

// הודעות נוספות מהשיעור (למשל lesson-progress ו-lesson-complete) מועברות להורה ב-prop onMessage.
// ה-origin של ה-iframe הוא "null" (sandbox בלי allow-same-origin), ולכן הזהות נבדקת לפי event.source בלבד.
// כל השיעורים (בכל הקורסים) מוצגים בעיצוב הכהה האחיד של האתר: הצבעים מוחלפים בזמן ההצגה בלבד.
export default function LessonHtmlFrame({ html, onMessage, tutor = false }) {
  const iframeRef = useRef(null);
  const onMessageRef = useRef(onMessage);
  const [height, setHeight] = useState(600);
  // מסך מלא: שיעור (תרגיל הבריחה) מבקש {type:'lesson-fullscreen', on} כדי לתפוס את כל חלון הדפדפן, ובסיום לשחרר.
  const [full, setFull] = useState(false);
  // הצבעים של השיעור מוחלפים לפלטת האתר בזמן ההצגה; התוכן במסד לא משתנה.
  const themed = useMemo(() => themeLessonHtml(html), [html]);
  const injected = useMemo(() => FONTS + LAYOUT_RESET + "<style>" + lessonThemeCss(html) + "</style>" + HEIGHT_SCRIPT + REPORT_SCRIPT + PYX_RUNNER_SCRIPT + (html.indexOf("pyxTerminal") >= 0 ? PYX_TERMINAL_SCRIPT : "") + (tutor ? TUTOR_CONTEXT_SCRIPT : ""), [html, tutor]);

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
      if (data.type === "lesson-fullscreen") {
        setFull(data.on === true);
        return;
      }
      onMessageRef.current?.(data);
    }
    window.addEventListener("message", handleMessage);
    // אם ה-iframe כבר נטען, מבקשים ממנו לשלוח שוב את מצב ההתקדמות (ההודעה הראשונה שלו אבדה לפני ההאזנה).
    iframeRef.current?.contentWindow?.postMessage({ type: "lesson-parent-ready" }, "*");
    return () => window.removeEventListener("message", handleMessage);
  }, []);

  // במסך מלא ננעלת הגלילה של האתר, ו-Escape משחרר (כך שאי אפשר להיתקע בתוך השיעור).
  useEffect(() => {
    if (!full) return;
    const prev = document.body.style.overflow;
    document.body.style.overflow = "hidden";
    const onKey = (e) => { if (e.key === "Escape") setFull(false); };
    window.addEventListener("keydown", onKey);
    return () => {
      document.body.style.overflow = prev;
      window.removeEventListener("keydown", onKey);
      // אחרי היציאה חוזרים להציג את השיעור במקומו בעמוד.
      iframeRef.current?.scrollIntoView?.({ block: "start" });
    };
  }, [full]);

  // השיעור מתעדכן במצב בפועל (למשל אחרי Escape בהורה), כדי שיוריד את מצב המסך המלא אצלו.
  useEffect(() => {
    iframeRef.current?.contentWindow?.postMessage({ type: "lesson-fullscreen-state", on: full }, "*");
  }, [full]);

  return (
    <iframe
      ref={iframeRef}
      srcDoc={injected + themed}
      title="תוכן השיעור"
      className="lesson-html-frame"
      scrolling={full ? "yes" : "no"}
      style={full ? { position: "fixed", inset: 0, width: "100%", height: "100%", zIndex: 2000, borderRadius: 0, overflow: "auto", background: "#14121f" } : { height }}
      sandbox="allow-scripts allow-downloads allow-popups allow-top-navigation-by-user-activation"
    />
  );
}
