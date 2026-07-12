// lib/payments.js
import { db } from "./db";

export function getRecentPayments(limit = 50) {
  return db
    .prepare(
      `SELECT payments.*, users.name AS user_name, users.email AS user_email
       FROM payments
       JOIN users ON users.id = payments.user_id
       ORDER BY payments.created_at DESC
       LIMIT ?`
    )
    .all(limit);
}

export function getPaymentById(id) {
  return db.prepare("SELECT * FROM payments WHERE id = ?").get(id);
}
