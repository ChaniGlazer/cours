// lib/coupons.js
import crypto from "node:crypto";
import { db, nowIso } from "./db";

function normalizeCode(code) {
  return (code || "").toString().trim().toUpperCase();
}

export function getCoupons() {
  return db.prepare("SELECT * FROM coupons ORDER BY created_at DESC").all();
}

// מחזיר את הקופון רק אם הוא בר-שימוש כרגע (פעיל, לא פג תוקף, מתחת למכסת השימושים).
// נקרא גם בזמן הצגת המחיר וגם שוב בזמן חיוב בפועל - אף פעם לא סומכים על מה
// שהוצג בעמוד קודם, כי המצב יכול להשתנות בין הצגה לחיוב (למשל קופון שהגיע למכסה).
export function findValidCoupon(codeRaw) {
  const code = normalizeCode(codeRaw);
  if (!code) return null;

  const coupon = db.prepare("SELECT * FROM coupons WHERE code = ?").get(code);
  if (!coupon) return null;
  if (!coupon.active) return null;
  if (coupon.expires_at && new Date(coupon.expires_at) < new Date()) return null;
  if (coupon.max_uses != null && coupon.used_count >= coupon.max_uses) return null;

  return coupon;
}

export function computeDiscountedPrice(price, coupon) {
  if (!coupon) return price;
  const discount =
    coupon.discount_type === "percent" ? (price * coupon.discount_value) / 100 : coupon.discount_value;
  return Math.max(0, Math.round((price - discount) * 100) / 100);
}

export function formatDiscount(coupon) {
  if (coupon.discount_type === "percent") return `${coupon.discount_value}%`;
  return `${coupon.discount_value} ₪`;
}

export function incrementCouponUsage(codeRaw) {
  const code = normalizeCode(codeRaw);
  if (!code) return;
  db.prepare("UPDATE coupons SET used_count = used_count + 1 WHERE code = ?").run(code);
}

export function createCoupon({ code, discountType, discountValue, maxUses, expiresAt }) {
  db.prepare(
    "INSERT INTO coupons (id, code, discount_type, discount_value, max_uses, active, expires_at, created_at) VALUES (?, ?, ?, ?, ?, 1, ?, ?)"
  ).run(
    crypto.randomUUID(),
    normalizeCode(code),
    discountType,
    discountValue,
    maxUses ?? null,
    expiresAt || null,
    nowIso()
  );
}

export function setCouponActive(id, active) {
  db.prepare("UPDATE coupons SET active = ? WHERE id = ?").run(active ? 1 : 0, id);
}

export function deleteCoupon(id) {
  db.prepare("DELETE FROM coupons WHERE id = ?").run(id);
}
