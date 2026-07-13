// app/opengraph-image.js
//
// תמונת Open Graph לעמוד הבית - נבנית דינמית (לא תמונה קבועה) מתוך שם הקורס
// וכותרת המשנה שהוגדרו בעמוד הניהול, כדי שתמיד תשקף את התוכן העדכני.
//
// גופן: Noto Sans Hebrew (SIL Open Font License 1.1) - מצורף כקובץ מקומי
// בתיקייה הזו במקום להוריד מ-Google Fonts בזמן ריצה, כי next/og (Satori)
// צריך את בייטים הגופן בפועל כדי לצייר טקסט עברי (בלי זה מוצגים ריבועים
// ריקים), ותלות ברשת בזמן ריצה לכל בקשה היא נקודת כשל מיותרת.
import { ImageResponse } from "next/og";
import { readFile } from "node:fs/promises";
import path from "node:path";
import { getSettings } from "@/lib/settings";

export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default async function Image() {
  const settings = getSettings();
  const title = settings.course_title || "הקורס שלי";
  const subtitle = settings.course_subtitle || "";

  const [bold, regular] = await Promise.all([
    readFile(path.join(process.cwd(), "app/fonts/NotoSansHebrew-Bold.ttf")),
    readFile(path.join(process.cwd(), "app/fonts/NotoSansHebrew-Regular.ttf"))
  ]);

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          background: "#1e3a5f",
          color: "#f7ede0",
          padding: "80px",
          textAlign: "center",
          fontFamily: "Noto Sans Hebrew",
          direction: "rtl"
        }}
      >
        <div
          style={{
            display: "flex",
            direction: "rtl",
            fontSize: 26,
            letterSpacing: 4,
            color: "#e08a3e",
            fontWeight: 700,
            marginBottom: 28
          }}
        >
          קורס וידאו אונליין
        </div>
        <div
          style={{
            display: "flex",
            direction: "rtl",
            fontSize: 64,
            fontWeight: 700,
            lineHeight: 1.3,
            maxWidth: 950
          }}
        >
          {title}
        </div>
        {subtitle && (
          <div
            style={{
              display: "flex",
              direction: "rtl",
              fontSize: 30,
              fontWeight: 400,
              marginTop: 28,
              color: "rgba(247, 237, 224, 0.75)",
              maxWidth: 820,
              lineHeight: 1.5
            }}
          >
            {subtitle}
          </div>
        )}
      </div>
    ),
    {
      ...size,
      fonts: [
        { name: "Noto Sans Hebrew", data: regular, weight: 400, style: "normal" },
        { name: "Noto Sans Hebrew", data: bold, weight: 700, style: "normal" }
      ]
    }
  );
}
