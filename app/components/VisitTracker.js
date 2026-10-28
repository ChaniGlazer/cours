"use client";

// מדווח צפיית עמוד אנונימית ל-/api/visit (מעקב כניסות בפאנל הניהול). נשלח רק מדפדפן אמיתי, לא נשלח בעמודי /admin.
// visitor_id: מזהה אקראי ב-localStorage שמבדיל בין מבקר חוזר למבקר חדש; לא קשור לשם או למייל.
import { useEffect } from "react";
import { usePathname } from "next/navigation";

const KEY = "visitor-id-v1";

function visitorId() {
  try {
    let id = localStorage.getItem(KEY);
    if (!id) {
      id = crypto.randomUUID();
      localStorage.setItem(KEY, id);
    }
    return id;
  } catch {
    return null; // localStorage חסום: לא סופרים, במקום לספור כל צפייה כמבקר חדש
  }
}

export default function VisitTracker() {
  const pathname = usePathname();

  useEffect(() => {
    if (!pathname || pathname.startsWith("/admin")) return;
    if (navigator.doNotTrack === "1") return;
    const vid = visitorId();
    if (!vid) return;
    fetch("/api/visit", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ path: pathname, referrer: document.referrer, vid }),
      keepalive: true
    }).catch(() => {});
  }, [pathname]);

  return null;
}
