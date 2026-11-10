// GET /api/survey/export?type=subscribers|responses - הורדת CSV, למנהלת בלבד.
//   subscribers: רק מי שאישרה דיוור (מייל, תאריך ושעת ההסכמה, מקור, נוסח ההסכמה).
//   responses: תשובות הסקר האנונימיות, בלי מיילים.
import { isAdmin } from "@/lib/admin-auth";
import { responsesCsv, subscribersCsv } from "@/lib/surveyStore";

export async function GET(request) {
  if (!(await isAdmin())) return new Response("Unauthorized", { status: 401, headers: { "Cache-Control": "no-store" } });

  const type = new URL(request.url).searchParams.get("type");
  if (type !== "subscribers" && type !== "responses") return new Response("Bad request", { status: 400 });

  const csv = type === "subscribers" ? await subscribersCsv() : await responsesCsv();
  const day = new Date().toISOString().slice(0, 10);
  return new Response(csv, {
    headers: {
      "Content-Type": "text/csv; charset=utf-8",
      "Content-Disposition": `attachment; filename="survey-${type}-${day}.csv"`,
      "Cache-Control": "no-store"
    }
  });
}
