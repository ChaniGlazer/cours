"use client";

// כפתור "העתקת קישור" לעמוד התוצאות. מעתיק רק את הקישור, עם גיבוי לדפדפנים בלי הרשאת clipboard.
import { useState } from "react";

export default function CopyLinkButton({ path, children, className }) {
  const [msg, setMsg] = useState("");
  const copy = async () => {
    const url = `${window.location.origin}${path}`;
    let ok = false;
    try {
      await navigator.clipboard.writeText(url);
      ok = true;
    } catch {
      try {
        const ta = document.createElement("textarea");
        ta.value = url;
        ta.setAttribute("readonly", "");
        ta.style.position = "fixed";
        ta.style.opacity = "0";
        document.body.appendChild(ta);
        ta.select();
        ok = document.execCommand("copy");
        document.body.removeChild(ta);
      } catch {
        ok = false;
      }
    }
    setMsg(ok ? "הקישור הועתק ✓" : url);
  };
  return (
    <>
      <button type="button" className={className} onClick={copy}>{children}</button>
      <span className="sv-hint" role="status" aria-live="polite">{msg}</span>
    </>
  );
}
