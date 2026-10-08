import { getCourses, getLessonsForCourse } from "@/lib/courses";
import { absoluteUrl } from "@/lib/seo";

export const dynamic = "force-dynamic";

export default async function sitemap() {
  const entries = [{ url: absoluteUrl("/courses"), changeFrequency: "weekly", priority: 1 }];

  const courses = await getCourses();
  for (const course of courses) {
    entries.push({ url: absoluteUrl(`/courses/${course.id}`), changeFrequency: "weekly", priority: 0.8 });

    // שיעורים נגישים לכולם: כל שיעורי קורס חינמי, ורק השיעור הראשון בקורס בתשלום.
    if (course.coming_soon) continue;
    const lessons = await getLessonsForCourse(course.id);
    lessons.forEach((lesson, idx) => {
      if (!lesson.slug) return;
      if (course.is_paid && idx > 0) return;
      entries.push({ url: absoluteUrl(`/courses/${course.id}/${lesson.slug}`), changeFrequency: "monthly", priority: 0.6 });
    });
  }
  return entries;
}
