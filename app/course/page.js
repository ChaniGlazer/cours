import { redirect } from "next/navigation";

// נתיב ישן מהזמן שהאתר שירת קורס יחיד - נשמר כהפניה כדי לא לשבור קישורים ישנים.
export default function LegacyCoursePage() {
  redirect("/courses");
}
