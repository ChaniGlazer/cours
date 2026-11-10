import { OG_IMAGES } from "@/lib/seo";
import SurveyClient from "./SurveyClient";

const TITLE = "סקר: איך הייתם לומדים פיתוח בעידן ה-AI";
const DESCRIPTION = "סקר קצר של שתי דקות לכל מי שלומד או עובד בפיתוח. עשו את הסקר וגלו איך ענו האחרים.";

export const metadata = {
  title: TITLE,
  description: DESCRIPTION,
  alternates: { canonical: "/survey" },
  openGraph: { type: "website", locale: "he_IL", url: "/survey", title: TITLE, description: DESCRIPTION, images: OG_IMAGES },
  twitter: { card: "summary_large_image", title: TITLE, description: DESCRIPTION, images: OG_IMAGES }
};

export default function SurveyPage() {
  return <SurveyClient />;
}
