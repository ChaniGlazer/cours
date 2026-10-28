// POST /api/visit - צפיית עמוד אנונימית (מעקב כניסות לפאנל הניהול).
// בקשה: { path, referrer?, vid }. אותה הגנת CSRF כמו /api/progress (Origin). לא נשמרים IP ו-User-Agent.
import { getCloudflareContext } from "@opennextjs/cloudflare";
import { getCurrentUser } from "@/lib/auth";
import { isBot, parseDevice, recordVisit, referrerSource } from "@/lib/visitStore";

const noContent = (status = 204) => new Response(null, { status, headers: { "Cache-Control": "no-store" } });

function ownHosts(request) {
  const hosts = new Set([new URL(request.url).hostname.replace(/^www\./, "")]);
  try {
    if (process.env.SITE_URL) hosts.add(new URL(process.env.SITE_URL).hostname.replace(/^www\./, ""));
  } catch {
    // SITE_URL לא תקין - מתעלמים
  }
  return hosts;
}

function sameSite(request, hosts) {
  const origin = request.headers.get("origin");
  if (origin) {
    try {
      return hosts.has(new URL(origin).hostname.replace(/^www\./, ""));
    } catch {
      return false;
    }
  }
  const fetchSite = request.headers.get("sec-fetch-site");
  return fetchSite === "same-origin" || fetchSite === "none";
}

const clean = (v, max) => (typeof v === "string" && v ? v.slice(0, max) : null);

export async function POST(request) {
  const hosts = ownHosts(request);
  if (!sameSite(request, hosts)) return noContent(403);
  const ua = request.headers.get("user-agent") || "";
  if (isBot(ua)) return noContent();

  let body;
  try {
    const text = await request.text();
    if (text.length > 2000) return noContent(400);
    body = JSON.parse(text);
  } catch {
    return noContent(400);
  }
  const path = typeof body?.path === "string" ? body.path.split(/[?#]/)[0].slice(0, 200) : "";
  if (!path.startsWith("/") || path.startsWith("/admin") || path.startsWith("/api/")) return noContent();
  if (typeof body?.vid !== "string" || !/^[a-z0-9-]{16,64}$/i.test(body.vid)) return noContent(400);

  let country = request.headers.get("cf-ipcountry");
  let city = null;
  try {
    const cf = (await getCloudflareContext({ async: true })).cf;
    country = cf?.country || country;
    city = cf?.city || null;
  } catch {
    // בלי cf (פיתוח מקומי) נשארים עם הכותרת, אם יש
  }
  if (country === "XX" || country === "T1") country = null;

  try {
    const user = await getCurrentUser();
    await recordVisit({
      path,
      visitorId: body.vid,
      userId: user?.id,
      country: clean(country, 2),
      city: clean(city, 60),
      source: referrerSource(body.referrer, hosts),
      ...parseDevice(ua)
    });
  } catch (err) {
    console.error("visit: record failed", err?.message);
    return noContent(503);
  }
  return noContent();
}
