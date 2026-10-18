import { COURSE_ID } from "@/lib/topics";

export const metadata = {
  title: "העמוד לא נמצא",
  robots: { index: false, follow: false }
};

// עמוד 404 לכל כתובת שלא קיימת (וגם ל-notFound() מתוך עמודים כמו /topics/[slug]).
export default function NotFound() {
  return (
    <section className="section nf-page">
      <div className="container nf-wrap">
        <div className="nf-code" dir="ltr" aria-hidden="true">
          404
        </div>
        <h1>העמוד הזה לא נמצא</h1>
        <p className="text-soft">ייתכן שהכתובת שגויה או שהעמוד הועבר. אלה המקומות הכי טובים להמשיך מהם:</p>
        <div className="nf-links">
          <a className="btn btn-primary" href={`/courses/${COURSE_ID}`}>
            לקורס הפייתון
          </a>
          <a className="btn btn-ghost" href="/courses">
            לקטלוג הקורסים
          </a>
          <a className="btn btn-ghost" href="/topics">
            לנושאים בפייתון
          </a>
        </div>
      </div>
    </section>
  );
}
