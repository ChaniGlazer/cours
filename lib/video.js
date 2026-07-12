// lib/video.js
//
// ממיר קישור וידאו "רגיל" שהמדריך/ה מדביק/ה בעמוד הניהול לכתובת הטמעה.
// תומך ב-YouTube, Vimeo, Cloudflare Stream, קובץ וידאו ישיר (mp4/webm),
// וכל קישור הטמעה אחר כ-fallback.
//
// המלצה לאבטחת התוכן: אם חשוב לכם שהווידאו לא יהיה ניתן לצפייה למי שאין לו את
// הקישור הישיר, מומלץ Vimeo עם הגדרת "domain-level privacy" שמגבילה הטמעה רק
// לדומיין של האתר שלכם, או Cloudflare Stream עם "Signed URLs" (טוקן זמני
// שנוצר בשרת). קישורי YouTube "לא רשום" (unlisted) נוחים אך כל מי שמקבל
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

    // Cloudflare Stream: קישור ה"צפייה" הגנרי (watch.cloudflarestream.com/<uid>)
    // ניתן להטמעה כמו שהוא - כולל token= בשאילתה עבור וידאו עם Signed URLs.
    if (host === "watch.cloudflarestream.com") {
      return { type: "iframe", src: url };
    }

    // הדומיין הישן להטמעה (עדיין נתמך) - כבר מוכן לשימוש כמו שהוא.
    if (host === "iframe.videodelivery.net") {
      return { type: "iframe", src: url };
    }

    // videodelivery.net בלי תת-הדומיין iframe. - מוסיפים אותו כדי לקבל נגן תקין.
    if (host === "videodelivery.net") {
      const uid = u.pathname.split("/").filter(Boolean)[0];
      if (uid) return { type: "iframe", src: `https://iframe.videodelivery.net/${uid}${u.search}` };
    }

    // הדומיין הנוכחי הצמוד לחשבון (customer-<code>.cloudflarestream.com).
    // קוד ההטמעה מ-Cloudflare מסתיים כבר ב-/iframe; אם הודבק רק ה-UID
    // (בלי /iframe בסוף), משלימים אותו כדי לקבל נגן תקין, כולל שמירת
    // טוקן חתום (?token=...) אם קיים.
    if (host.endsWith(".cloudflarestream.com")) {
      const segments = u.pathname.split("/").filter(Boolean);
      if (segments[segments.length - 1] === "iframe") {
        return { type: "iframe", src: url };
      }
      if (segments.length >= 1) {
        return { type: "iframe", src: `https://${host}/${segments[0]}/iframe${u.search}` };
      }
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
