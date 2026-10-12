import { NextResponse } from "next/server";
import { getCurrentUser } from "@/lib/auth";
import { isAdmin } from "@/lib/admin-auth";
import { hashVisitor, isBot, recordVisit } from "@/lib/analytics";

export const dynamic = "force-dynamic";

export async function POST(request) {
  try {
    const ua = request.headers.get("user-agent") || "";
    if (isBot(ua)) return new NextResponse(null, { status: 204 });
    if (await isAdmin()) return new NextResponse(null, { status: 204 });

    const body = await request.json().catch(() => ({}));
    const path = String(body.path || "").slice(0, 200);
    if (!path.startsWith("/") || path.startsWith("/admin") || path.startsWith("/api")) {
      return new NextResponse(null, { status: 204 });
    }

    // מקור הגעה: רק שם הדומיין, ורק אם הוא חיצוני לאתר
    let referrer = "";
    try {
      const host = new URL(String(body.referrer || "")).host;
      if (host && host !== request.headers.get("host")) referrer = host.slice(0, 100);
    } catch {}

    const ip = (request.headers.get("x-forwarded-for") || "").split(",")[0].trim() || "unknown";
    const user = await getCurrentUser();
    recordVisit({ path, visitorHash: hashVisitor(ip, ua), userId: user?.id, referrer, ua });
  } catch {
    // כשל במעקב לא אמור להשפיע על הגולש
  }
  return new NextResponse(null, { status: 204 });
}
