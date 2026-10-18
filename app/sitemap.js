import { getCourses, getLessonsForCourse } from "@/lib/courses";
import { absoluteUrl, latestDate, BUILD_TIME } from "@/lib/seo";
import { TOPICS } from "@/lib/topics";
import { aboutIsFilled } from "@/lib/site";

export const dynamic = "force-dynamic";

// lastmod: לעמודים מהמסד (קורס, שיעור) - התאריך האחרון שנשמר בו (lessons.created_at, ששיעור שמעודכן מחדש מקבל מחדש).
// לעמודים סטטיים (נושאים, אודות, פרטיות) אין תאריך משלהם, ולכן מוצג תאריך הפריסה (BUILD_TIME, נקבע בזמן build).
export default async function sitemap() {
  const deployed = new Date(BUILD_TIME);
  const entries = [];
  const courseDates = [];

  const courses = await getCourses();
  const courseEntries = [];
  for (const course of courses) {
    // קורס "בקרוב" לא ב-sitemap: עמודו noindex והשיעורים סגורים.
    if (course.coming_soon) continue;

    // שיעורים נגישים לכולם: כל שיעורי קורס חינמי, ורק השיעור הראשון בקורס בתשלום.
    const lessons = await getLessonsForCourse(course.id);
    const lessonEntries = [];
    lessons.forEach((lesson, idx) => {
      if (!lesson.slug) return;
      if (course.is_paid && idx > 0) return;
      lessonEntries.push({
        url: absoluteUrl(`/courses/${course.id}/${lesson.slug}`),
        lastModified: latestDate([lesson.created_at]),
        changeFrequency: "monthly",
        priority: 0.6
      });
    });

    const courseModified = latestDate([course.created_at, ...lessons.map((l) => l.created_at)]);
    courseDates.push(courseModified);
    courseEntries.push({
      url: absoluteUrl(`/courses/${course.id}`),
      lastModified: courseModified,
      changeFrequency: "weekly",
      priority: 0.8
    });
    courseEntries.push(...lessonEntries);
  }

  const catalogModified = courseDates.length ? new Date(Math.max(...courseDates)) : deployed;
  entries.push(
    { url: absoluteUrl("/courses"), lastModified: catalogModified, changeFrequency: "weekly", priority: 1 },
    { url: absoluteUrl("/topics"), lastModified: deployed, changeFrequency: "monthly", priority: 0.8 },
    ...TOPICS.map((t) => ({ url: absoluteUrl(`/topics/${t.slug}`), lastModified: deployed, changeFrequency: "monthly", priority: 0.7 })),
    ...courseEntries
  );
  // /about נכנס רק כשמולאו בו פרטים (אחרת הוא noindex), ו-/privacy תמיד.
  if (aboutIsFilled()) entries.push({ url: absoluteUrl("/about"), lastModified: deployed, changeFrequency: "yearly", priority: 0.4 });
  entries.push({ url: absoluteUrl("/privacy"), lastModified: deployed, changeFrequency: "yearly", priority: 0.2 });
  return entries;
}
