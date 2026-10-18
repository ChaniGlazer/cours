import { notFound } from "next/navigation";
import { TOPICS, COURSE_ID, getTopic } from "@/lib/topics";
import { absoluteUrl, jsonLdString, AUTHOR_NAME, OG_IMAGES } from "@/lib/seo";
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
    openGraph: { type: "article", locale: "he_IL", url: path, title: topic.title, description: topic.description, images: OG_IMAGES }
  };
}

function Example({ ex }) {
  return (
    <div className="tp-example">
      <pre className="tp-code">
        <code dir="ltr">{ex.code}</code>
      </pre>
      <div className="tp-out-label">מה מודפס:</div>
      <pre className="tp-code tp-code--out">
        <code dir="ltr">{ex.output}</code>
      </pre>
    </div>
  );
}

export default async function TopicPage({ params }) {
  const { slug } = await params;
  const topic = getTopic(slug);
  if (!topic) notFound();

  const url = absoluteUrl(`/topics/${topic.slug}`);
  const lessonHref = `/courses/${COURSE_ID}/${topic.lessonSlug}`;
  const related = topic.related.map((s) => getTopic(s)).filter(Boolean);
  // הדוגמה הראשונה של הנושא מוצגת בראש העמוד, וכל השאר בתוך "להרחבה".
  const firstExample = topic.sections.flatMap((sec) => sec.examples || [])[0] || null;

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

          <section className="tp-short" aria-labelledby="tp-short-h">
            <h2 id="tp-short-h">בקצרה</h2>
            <p>
              <TopicText text={topic.short} />
            </p>
          </section>

          {firstExample && <Example ex={firstExample} />}

          <div className="tp-lead">
            <a href={lessonHref} className="btn btn-primary tp-bigcta">
              לשיעור המלא וההרצה <span aria-hidden="true">←</span>
            </a>
          </div>

          <details className="tp-more">
            <summary>להרחבה</summary>
            <div className="tp-more__body">
              {topic.sections.map((sec) => (
                <section className="tp-section" key={sec.h2}>
                  <h2>{sec.h2}</h2>
                  {sec.paragraphs.map((p, i) => (
                    <p key={i}>
                      <TopicText text={p} />
                    </p>
                  ))}
                  {(sec.examples || [])
                    .filter((ex) => ex !== firstExample)
                    .map((ex, i) => (
                      <Example ex={ex} key={i} />
                    ))}
                </section>
              ))}
            </div>
          </details>

          <section className="tp-section" aria-labelledby="tp-faq-h">
            <h2 id="tp-faq-h">שאלות ותשובות</h2>
            <div className="tp-faq">
              {topic.faq.map((f) => (
                <details className="tp-qa" key={f.q}>
                  <summary>
                    <h3>
                      <TopicText text={f.q} />
                    </h3>
                  </summary>
                  <p>
                    <TopicText text={f.a} />
                  </p>
                </details>
              ))}
            </div>
          </section>

          {related.length > 0 && (
            <section className="tp-section" aria-labelledby="tp-rel-h">
              <h2 id="tp-rel-h">נושאים קשורים</h2>
              <ul className="tp-chips">
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

          <div className="tp-lead tp-lead--end">
            <a href={lessonHref} className="btn btn-primary tp-bigcta">
              לשיעור המלא וההרצה <span aria-hidden="true">←</span>
            </a>
          </div>
        </div>
      </article>
      <a href={lessonHref} className="tp-float btn btn-primary">
        לשיעור המלא וההרצה <span aria-hidden="true">←</span>
      </a>
    </>
  );
}
