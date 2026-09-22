import { redirect, notFound } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getCourseBySlug, getLessonsForCourse } from "@/lib/courses";
import { hasPurchasedCourse } from "@/lib/purchases";
import { parseVideoEmbed } from "@/lib/video";
import LessonHtmlFrame from "@/app/components/LessonHtmlFrame";

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

  return (
    <section className="section">
      <div className="container lesson-layout">
        <aside className="lesson-sidebar">
          <a href={`/courses/${course.id}`} className="muted-link">
            ← חזרה לעמוד הקורס
          </a>
          <h3 style={{ marginTop: 14 }}>{course.title}</h3>
          <ul className="lesson-sidebar-list">
            {lessons.map((l, i) => {
              const isLocked = course.is_paid && !hasAccess && i > 0;
              const isCurrent = l.slug === lessonSlug;
              return (
                <li key={l.id} className={isCurrent ? "current" : ""}>
                  {isLocked ? (
                    <span className="text-soft">🔒 {l.title}</span>
                  ) : (
                    <a href={`/courses/${course.id}/${l.slug}`}>{l.title}</a>
                  )}
                </li>
              );
            })}
          </ul>
        </aside>

        <div className="lesson-main">
          <span className="eyebrow">
            שיעור {idx + 1} מתוך {lessons.length}
          </span>
          <h1 style={{ marginTop: 10 }}>{lesson.title}</h1>
          {lesson.description && <p className="text-soft">{lesson.description}</p>}

          <div style={{ marginTop: 20 }}>
            {lesson.html_content ? (
              <LessonHtmlFrame html={lesson.html_content} />
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
          </div>

          <div className="lesson-pager">
            {prevLesson ? (
              <a href={`/courses/${course.id}/${prevLesson.slug}`} className="btn btn-ghost">
                → שיעור קודם
              </a>
            ) : (
              <span />
            )}
            {nextLesson ? (
              <a href={`/courses/${course.id}/${nextLesson.slug}`} className="btn btn-primary">
                שיעור הבא ←
              </a>
            ) : (
              <a href={`/courses/${course.id}`} className="btn btn-primary">
                סיימתם! חזרה לעמוד הקורס
              </a>
            )}
          </div>
        </div>
      </div>
    </section>
  );
}
