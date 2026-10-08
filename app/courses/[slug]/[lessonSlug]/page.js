import { redirect, notFound } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug, getLessonsForCourse } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { parseVideoEmbed } from "@/lib/video";
import LessonHtmlFrame from "@/app/components/LessonHtmlFrame";
import LessonLayout from "@/app/components/LessonLayout";
import { absoluteUrl, toDescription, jsonLdString, AUTHOR_NAME } from "@/lib/seo";

export async function generateMetadata({ params }) {
  const { slug, lessonSlug } = await params;
  const course = await getCourseBySlug(slug);
  if (!course) return { title: "השיעור לא נמצא", robots: { index: false } };
  const lessons = await getLessonsForCourse(course.id);
  const idx = lessons.findIndex((l) => l.slug === lessonSlug);
  if (idx === -1) return { title: "השיעור לא נמצא", robots: { index: false } };
  const lesson = lessons[idx];
  const title = `${lesson.title} - ${course.title}`;
  const description = toDescription(lesson.description, `${lesson.title} - שיעור מתוך הקורס ${course.title}`);
  const path = `/courses/${course.id}/${lesson.slug}`;
  // שיעורים נעולים (בקורס בתשלום, אחרי הראשון) מפנים להרשמה - לא לאנדקס.
  const locked = course.is_paid && idx > 0;
  return {
    title,
    description,
    alternates: { canonical: path },
    ...(locked ? { robots: { index: false, follow: true } } : {}),
    openGraph: { type: "article", locale: "he_IL", url: path, title, description }
  };
}

export default async function LessonPage({ params }) {
  const { slug, lessonSlug } = await params;
  const course = await getCourseBySlug(slug);
  if (!course) notFound();

  const user = await getCurrentUser();
  const purchased = course.is_paid && user ? await hasPurchasedCourse(user.id, course.id) : false;
  const hasAccess = !course.is_paid || purchased;

  const lessons = await getLessonsForCourse(course.id);
  const idx = lessons.findIndex((l) => l.slug === lessonSlug);
  if (idx === -1) notFound();

  const locked = course.is_paid && !hasAccess && idx > 0;
  if (locked) {
    redirect(`/courses/${course.id}`);
  }

  const lesson = lessons[idx];
  const embed = parseVideoEmbed(lesson.video_url);
  const prevLesson = idx > 0 ? lessons[idx - 1] : null;
  const nextLesson = idx < lessons.length - 1 ? lessons[idx + 1] : null;

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "LearningResource",
    name: lesson.title,
    description: toDescription(lesson.description, lesson.title),
    url: absoluteUrl(`/courses/${course.id}/${lesson.slug}`),
    inLanguage: "he",
    learningResourceType: "שיעור אינטראקטיבי",
    isAccessibleForFree: !course.is_paid || idx === 0,
    author: { "@type": "Person", name: AUTHOR_NAME },
    isPartOf: { "@type": "Course", name: course.title, url: absoluteUrl(`/courses/${course.id}`) }
  };

  const lessonItems = lessons.map((l, i) => ({
    slug: l.slug,
    title: l.title,
    locked: course.is_paid && !hasAccess && i > 0
  }));

  const heading = lesson.html_content ? (
    // שיעור HTML מציג כותרת משלו, ולכן נשאר רק h1 מוסתר ויזואלית (נגישות ו-SEO).
    <h1 className="sr-only">{lesson.title}</h1>
  ) : (
    <div className="lesson-main__head">
      <h1>{lesson.title}</h1>
      {lesson.description && <p className="text-soft">{lesson.description}</p>}
    </div>
  );

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(jsonLd) }} />
      <LessonLayout
        theme={course.theme}
        course={{ id: course.id, title: course.title }}
        lessons={lessonItems}
        currentSlug={lessonSlug}
        prev={prevLesson ? { slug: prevLesson.slug, title: prevLesson.title } : null}
        next={nextLesson ? { slug: nextLesson.slug, title: nextLesson.title } : null}
        heading={heading}
      >
        {lesson.html_content ? (
          <LessonHtmlFrame html={lesson.html_content} theme={course.theme} />
        ) : embed ? (
          <div className="video-wrap">
            {embed.type === "video" ? (
              <video controls src={embed.src} />
            ) : (
              <iframe
                src={embed.src}
                allow="autoplay; fullscreen; picture-in-picture"
                allowFullScreen
                title={lesson.title}
              />
            )}
          </div>
        ) : (
          <p className="text-soft">התוכן יתעדכן כאן בקרוב.</p>
        )}
      </LessonLayout>
    </>
  );
}
