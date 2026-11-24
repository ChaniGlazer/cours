// lib/sameOrigin.js
//
// הגנת CSRF לנתיבי API שמאומתים בעוגיית סשן: הבקשה חייבת להגיע מהאתר עצמו (Origin, או Sec-Fetch-Site כשאין Origin).
// משותף ל-/api/tutor ול-/api/prompt-review.
export function isSameOriginRequest(request) {
  const origin = request.headers.get("origin");
  const allowed = new Set([new URL(request.url).origin]);
  try {
    if (process.env.SITE_URL) allowed.add(new URL(process.env.SITE_URL).origin);
  } catch {
    // SITE_URL לא תקין - מתעלמים
  }
  if (origin) return allowed.has(origin);
  const fetchSite = request.headers.get("sec-fetch-site");
  return fetchSite === "same-origin" || fetchSite === "none";
}
