import { notFound } from "next/navigation";
import { TOPICS, COURSE_ID, getTopic } from "@/lib/topics";
import { absoluteUrl, jsonLdString, AUTHOR_NAME } from "@/lib/seo";
import TopicText from "../TopicText";
import "../topics.css";

export function generateStaticParams() {
  return TOPICS.map((t) => ({ slug: t.slug }));
}

export async function generateMetadata({ params }) {
  const { slug } = await params;
  const topic = getTopic(slug);
  if (!topic) return { title: "הנושא לא נמצא", robots: { index: false } };
  const path = `/topics/${topic.slug}`;
  return {
    title: topic.title,
    description: topic.description,
    alternates: { canonical: path },
    openGraph: { type: "article", locale: "he_IL", url: path, title: topic.title, description: topic.description }
  };
}

export default async function TopicPage({ params }) {
  const { slug } = await params;
  const topic = getTopic(slug);
  if (!topic) notFound();

  const url = absoluteUrl(`/topics/${topic.slug}`);
  const lessonHref = `/courses/${COURSE_ID}/${topic.lessonSlug}`;
  const related = topic.related.map((s) => getTopic(s)).filter(Boolean);

  const breadcrumbLd = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "דף הבית", item: absoluteUrl("/") },
      { "@type": "ListItem", position: 2, name: "נושאים", item: absoluteUrl("/topics") },
      { "@type": "ListItem", position: 3, name: topic.h1, item: url }
    ]
  };
  const articleLd = {
    "@context": "https://schema.org",
    "@type": "Article",
    headline: topic.h1,
    description: topic.description,
    url,
    mainEntityOfPage: url,
    inLanguage: "he",
    author: { "@type": "Person", name: AUTHOR_NAME }
  };

  return (
    <>
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(breadcrumbLd) }} />
      <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: jsonLdString(articleLd) }} />
      <article className="tp">
        <div className="container tp-wrap">
          <nav className="tp-crumbs" aria-label="נתיב">
            <a href="/">דף הבית</a>
            <span aria-hidden="true">›</span>
            <a href="/topics">נושאים</a>
            <span aria-hidden="true">›</span>
            <span aria-current="page">{topic.h1}</span>
          </nav>

          <h1 className="tp-h1">{topic.h1}</h1>

          {topic.sections.map((s) => (
            <section className="tp-section" key={s.h2}>
              <h2>{s.h2}</h2>
              {s.paragraphs.map((p, i) => (
                <p key={i}>
                  <TopicText text={p} />
                </p>
              ))}
              {(s.examples || []).map((ex, i) => (
                <div className="tp-example" key={i}>
                  <pre className="tp-code">
                    <code dir="ltr">{ex.code}</code>
                  </pre>
                  <div className="tp-out-label">מה מודפס:</div>
                  <pre className="tp-code tp-code--out">
                    <code dir="ltr">{ex.output}</code>
                  </pre>
                </div>
              ))}
            </section>
          ))}

          <section className="tp-section" aria-labelledby="tp-faq-h">
            <h2 id="tp-faq-h">שאלות ותשובות</h2>
            {topic.faq.map((f) => (
              <div className="tp-qa" key={f.q}>
                <h3>
                  <TopicText text={f.q} />
                </h3>
                <p>
                  <TopicText text={f.a} />
                </p>
              </div>
            ))}
          </section>

          <section className="tp-cta" aria-labelledby="tp-cta-h">
            <h2 id="tp-cta-h">רוצה לתרגל את זה?</h2>
            <p>בשיעור המלא יש הסבר מפורט, דוגמאות ותרגילים אינטראקטיביים.</p>
            <a href={lessonHref} className="btn btn-primary">
              לשיעור המלא וההרצה
            </a>
          </section>

          {related.length > 0 && (
            <section className="tp-section" aria-labelledby="tp-rel-h">
              <h2 id="tp-rel-h">נושאים קשורים</h2>
              <ul className="tp-related">
                {related.map((r) => (
                  <li key={r.slug}>
                    <a href={`/topics/${r.slug}`}>{r.h1}</a>
                  </li>
                ))}
              </ul>
              <p className="tp-all">
                <a href="/topics">לכל הנושאים</a>
              </p>
            </section>
          )}
        </div>
      </article>
    </>
  );
}
