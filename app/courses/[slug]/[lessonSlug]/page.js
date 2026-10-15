import { redirect, notFound } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug, getLessonsForCourse } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { isAdmin } from "@/lib/admin-auth";
import { parseVideoEmbed } from "@/lib/video";
import LessonLayout from "@/app/components/LessonLayout";
import LessonSeoSection from "@/app/components/LessonSeoSection";
import OUTLINES from "@/lib/lessonOutlines.json";
import { getLessonSeo } from "@/lib/lessonSeo";
import { tutorVisibleFor } from "@/lib/tutorAccess";
import { absoluteUrl, toDescription, jsonLdString, AUTHOR_NAME } from "@/lib/seo";

export async function generateMetadata({ params }) {
  const { slug, lessonSlug } = await params;
  const course = await getCourseBySlug(slug);
  if (!course) return { title: "השיעור לא נמצא", robots: { index: false } };
  const lessons = await getLessonsForCourse(course.id);
  const idx = lessons.findIndex((l) => l.slug === lessonSlug);
  if (idx === -1) return { title: "השיעור לא נמצא", robots: { index: false } };
  const lesson = lessons[idx];
  // לשיעורים עם טקסטי SEO (lib/lessonSeo.js): title ו-description ייחודיים. לשאר: הנוסח הקודם.
  const seo = getLessonSeo(course.id, lesson.slug);
  const title = seo?.title || `${lesson.title} - ${course.title}`;
  const description = seo?.description || toDescription(lesson.description, `${lesson.title} - שיעור מתוך הקורס ${course.title}`);
  const path = `/courses/${course.id}/${lesson.slug}`;
  // שיעורים נעולים (בקורס בתשלום, אחרי הראשון) מפנים להרשמה - לא לאנדקס.
  const locked = course.is_paid && idx > 0;
  return {
    title,
    description,
    alternates: { canonical: path },
    ...(locked || course.coming_soon ? { robots: { index: false, follow: true } } : {}),
    openGraph: { type: "article", locale: "he_IL", url: path, title, description }
  };
}

export default async function LessonPage({ params }) {
  const { slug, lessonSlug } = await params;
  const course = await getCourseBySlug(slug);
  if (!course) notFound();

  const user = await getCurrentUser();
  const admin = await isAdmin();
  // קורס "בקרוב" סגור: הפניה לעמוד הקורס (שמציג "בקרוב"). מנהל מחובר רואה תצוגה מקדימה.
  if (course.coming_soon && !admin) redirect(`/courses/${course.id}`);
  const purchased = course.is_paid && user ? await hasPurchasedCourse(user.id, course.id) : false;
  // מנהל מחובר (סיסמת /admin) רואה את כל השיעורים בלי תשלום
  const hasAccess = !course.is_paid || purchased || admin;

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

  const seo = getLessonSeo(course.id, lesson.slug);
  const outline = OUTLINES[`${course.id}/${lesson.slug}`] || null;

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "LearningResource",
    name: lesson.title,
    description: seo?.description || toDescription(lesson.description, lesson.title),
    url: absoluteUrl(`/courses/${course.id}/${lesson.slug}`),
    inLanguage: "he",
    ...(seo?.teaches ? { teaches: seo.teaches } : {}),
    learningResourceType: "שיעור אינטראקטיבי",
    isAccessibleForFree: !course.is_paid || idx === 0,
    author: { "@type": "Person", name: AUTHOR_NAME },
    isPartOf: { "@type": "Course", name: course.title, url: absoluteUrl(`/courses/${course.id}`) }
  };

  const breadcrumbLd = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "קטלוג קורסים", item: absoluteUrl("/courses") },
      { "@type": "ListItem", position: 2, name: course.title, item: absoluteUrl(`/courses/${course.id}`) },
      { "@type": "ListItem", position: 3, name: lesson.title, item: absoluteUrl(`/courses/${course.id}/${lesson.slug}`) }
    ]
  };

  const lessonItems = lessons.map((l, i) => ({
    slug: l.slug,
    title: l.title,
    locked: course.is_paid && !hasAccess && i > 0
  }));

  // שיעור HTML מציג כותרת והירו משלו, ולכן נשאר רק h1 מוסתר ויזואלית (נגישות ו-SEO).
  // שאר השיעורים (וידאו או בלי תוכן) מקבלים את ההירו של התבנית.
  const heading = <h1 className="sr-only">{lesson.title}</h1>;
  const hero = lesson.html_content ? null : { title: lesson.title, description: lesson.description };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(jsonLd) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(breadcrumbLd) }} />
      <LessonLayout
        course={{ id: course.id, title: course.title }}
        lessons={lessonItems}
        currentSlug={lessonSlug}
        prev={prevLesson ? { slug: prevLesson.slug, title: prevLesson.title } : null}
        next={nextLesson ? { slug: nextLesson.slug, title: nextLesson.title } : null}
        heading={heading}
        hero={hero}
        html={lesson.html_content || null}
        loggedIn={Boolean(user)}
        tutorEnabled={tutorVisibleFor(user)}
        seoContent={
          outline || seo ? (
            <LessonSeoSection
              outline={outline}
              seo={seo}
              course={{ id: course.id }}
              prev={prevLesson ? { slug: prevLesson.slug, title: prevLesson.title } : null}
              next={nextLesson ? { slug: nextLesson.slug, title: nextLesson.title } : null}
            />
          ) : null
        }
      >
        {embed ? (
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
