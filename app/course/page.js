import { redirect } from "next/navigation";
import { getCurrentUser } from "@/lib/auth";
import { getSettings, getLessons } from "@/lib/settings";
import { parseVideoEmbed } from "@/lib/video";
import { startPaymentAction, applyCouponAction } from "@/app/actions/payment";
import { findValidCoupon, computeDiscountedPrice, formatDiscount } from "@/lib/coupons";

export default async function CoursePage({ searchParams }) {
  const params = await searchParams;
  const user = await getCurrentUser();
  if (!user) {
    redirect("/login?next=/course");
  }

  const settings = getSettings();

  if (!user.paid) {
    const currencySymbol = settings.currency === "ILS" ? "₪" : settings.currency;
    const basePrice = parseFloat(settings.price) || 0;
    const coupon = params?.coupon ? findValidCoupon(params.coupon) : null;
    const finalPrice = coupon ? computeDiscountedPrice(basePrice, coupon) : basePrice;

    return (
      <section className="section">
        <div className="container" style={{ maxWidth: 520 }}>
          <span className="eyebrow">שלב אחרון</span>
          <h1>תשלום וקבלת גישה</h1>
          <p className="text-soft">
            שלום {user.name}, נשאר רק לבצע תשלום מאובטח כדי לקבל גישה מיידית לכל שיעורי הקורס.
          </p>

          {params?.error === "price_not_set" && (
            <div className="alert alert-error">
              לא הוגדר מחיר לקורס. יש להגדיר מחיר בעמוד הניהול (/admin) ולנסות שוב.
            </div>
          )}
          {params?.error === "coupon_invalid" && (
            <div className="alert alert-error">קוד הקופון אינו תקף, פג תוקף, או הגיע למכסת השימושים.</div>
          )}
          {params?.coupon && !coupon && !params?.error && (
            <div className="alert alert-error">קוד הקופון אינו תקף יותר.</div>
          )}

          <div className="price-card" style={{ marginTop: 24 }}>
            <span className="eyebrow">{settings.course_title}</span>
            {coupon ? (
              <>
                <div className="text-soft" style={{ textDecoration: "line-through" }}>
                  {basePrice} {currencySymbol}
                </div>
                <div className="price-amount">
                  {finalPrice} {currencySymbol}
                </div>
                <p className="text-soft">קופון {coupon.code} הופעל - הנחה של {formatDiscount(coupon)}</p>
              </>
            ) : (
              <div className="price-amount">
                {basePrice} {currencySymbol}
              </div>
            )}
            <form action={startPaymentAction}>
              {coupon && <input type="hidden" name="coupon_code" value={coupon.code} />}
              <button type="submit" className="btn btn-primary btn-block">
                לתשלום מאובטח
              </button>
            </form>
          </div>

          <div className="card" style={{ marginTop: 20 }}>
            <h2 style={{ fontSize: "1.1rem" }}>יש לכם קוד קופון?</h2>
            <form action={applyCouponAction} style={{ display: "flex", gap: 10, alignItems: "flex-end" }}>
              <div className="field" style={{ flex: 1, marginBottom: 0 }}>
                <input name="code" placeholder="קוד קופון" defaultValue={coupon?.code || ""} />
              </div>
              <button type="submit" className="btn btn-ghost">
                החלת קופון
              </button>
            </form>
          </div>
        </div>
      </section>
    );
  }

  const lessons = getLessons();

  return (
    <section className="section">
      <div className="container" style={{ maxWidth: 760 }}>
        <span className="eyebrow">האזור האישי שלך</span>
        <h1>{settings.course_title}</h1>
        <p className="text-soft">שלום {user.name}, בהצלחה בלימודים!</p>

        <div style={{ marginTop: 28 }}>
          {lessons.map((lesson, idx) => {
            const embed = parseVideoEmbed(lesson.video_url);
            return (
              <details key={lesson.id} className="lesson" open={idx === 0}>
                <summary>
                  <span className="lesson-num">{idx + 1}</span>
                  {lesson.title}
                </summary>
                <div className="lesson-body">
                  {lesson.description && <p className="text-soft">{lesson.description}</p>}
                  {embed ? (
                    <div className="video-wrap">
                      {embed.type === "video" ? (
                        <video controls src={embed.src} />
                      ) : (
                        <iframe
                          src={embed.src}
                          allow="autoplay; fullscreen; picture-in-picture; encrypted-media"
                          allowFullScreen
                          title={lesson.title}
                        />
                      )}
                    </div>
                  ) : (
                    <p className="text-soft">קישור לסרטון יתעדכן כאן בקרוב.</p>
                  )}
                </div>
              </details>
            );
          })}
        </div>
      </div>
    </section>
  );
}
