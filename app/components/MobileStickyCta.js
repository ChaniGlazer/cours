"use client";

import { useEffect, useState } from "react";

// מוצג רק במובייל (מוסתר ב-CSS מעל 720px) ורק אחרי שגוללים מעבר למסך הראשון,
// כדי לתת גישה מתמדת לכפתור הרכישה בלי להפריע לרושם הראשוני בכניסה לעמוד.
export default function MobileStickyCta({ href, text, price, currency }) {
  const [visible, setVisible] = useState(false);

  useEffect(() => {
    function onScroll() {
      setVisible(window.scrollY > 480);
    }
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  return (
    <div className={`mobile-sticky-cta${visible ? " is-visible" : ""}`}>
      {price ? (
        <span className="mobile-sticky-cta__price">
          {price} {currency === "ILS" ? "₪" : currency}
        </span>
      ) : null}
      <a href={href} className="btn btn-primary mobile-sticky-cta__btn">
        {text}
      </a>
    </div>
  );
}
