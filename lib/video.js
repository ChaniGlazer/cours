// lib/video.js
//
// ממיר קישור וידאו "רגיל" שהמדריך/ה מדביק/ה בעמוד הניהול לכתובת הטמעה.
// תומך ב-YouTube, Vimeo, קובץ וידאו ישיר (mp4/webm), וכל קישור הטמעה אחר כ-fallback.
//
// המלצה לאבטחת התוכן: אם חשוב לכם שהווידאו לא יהיה ניתן לצפייה למי שאין לו את
// הקישור הישיר, מומלץ Vimeo עם הגדרת "domain-level privacy" שמגבילה הטמעה רק
// לדומיין של האתר שלכם. קישורי YouTube "לא רשום" (unlisted) נוחים אך כל מי שמקבל
// את הקישור יכול לצפות בו גם בלי להתחבר לאתר.

export function parseVideoEmbed(url) {
  if (!url) return null;

  try {
    const u = new URL(url);
    const host = u.hostname.replace(/^www\./, "");

    if (host === "youtube.com" || host === "m.youtube.com") {
      const id = u.searchParams.get("v");
      if (id) return { type: "iframe", src: `https://www.youtube.com/embed/${id}` };
      if (u.pathname.startsWith("/embed/")) return { type: "iframe", src: url };
    }

    if (host === "youtu.be") {
      const id = u.pathname.slice(1);
      if (id) return { type: "iframe", src: `https://www.youtube.com/embed/${id}` };
    }

    if (host === "vimeo.com") {
      const id = u.pathname.split("/").filter(Boolean)[0];
      if (id) return { type: "iframe", src: `https://player.vimeo.com/video/${id}` };
    }

    if (host === "player.vimeo.com") {
      return { type: "iframe", src: url };
    }

    if (/\.(mp4|webm|ogg)$/i.test(u.pathname)) {
      return { type: "video", src: url };
    }

    // קישור הטמעה אחר (Loom, Wistia וכו') - מנסים כ-iframe גנרי
    return { type: "iframe", src: url };
  } catch {
    return null;
  }
}
