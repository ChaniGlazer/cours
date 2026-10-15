// lib/tutorOutput.js
//
// הפלט המובנה של החונכת: המודל מחזיר JSON { reply, suggestions } (OpenAI Structured Outputs, text.format = json_schema), והשרת
// מפענח אותו, מסנן את ההצעות ומחזיר ללומדת רק מה שבטוח. קובץ עצמאי (בלי import), כדי ש-scripts/tutor-eval.mjs יוכל לטעון אותו.
//
// ההצעות ("צ'יפים") הן תשובות קצרות שהלומדת יכולה ללחוץ עליהן במקום לכתוב. השרת מוחק כל הצעה שמכילה את ה-answer של תרגיל
// מהשיעור הנוכחי, גם אם המודל "החליט" להציע אותה.

export const DEFAULT_SUGGESTIONS = ["עוד רמז", "לא הבנתי"];
export const MAX_SUGGESTIONS = 4;
export const MIN_SUGGESTIONS = 2;
export const MAX_SUGGESTION_CHARS = 24;

// הסכמה במצב strict: כל השדות חובה ו-additionalProperties:false. אורך ומספר ההצעות נאכפים בשרת ובפרומפט (לא בסכמה).
export const TUTOR_OUTPUT_SCHEMA = {
  type: "object",
  properties: {
    reply: { type: "string", description: "תשובת החונכת ללומדת, עד 5 משפטים, בעברית" },
    suggestions: { type: "array", items: { type: "string" }, description: "2 עד 4 תשובות קצרות שהלומדת יכולה ללחוץ עליהן" }
  },
  required: ["reply", "suggestions"],
  additionalProperties: false
};
export const TUTOR_TEXT_FORMAT = { type: "json_schema", name: "tutor_reply", strict: true, schema: TUTOR_OUTPUT_SCHEMA };

// נרמול להשוואה: אותיות קטנות, בלי רווחים ובלי מרכאות (רגילות, עבריות, חכמות וגרש הפוך).
export const normForMatch = (s) => String(s ?? "").toLowerCase().replace(/[\s'"`״׳“”‘’]/g, "");

// האם הצעה (או כל טקסט קצר) חושפת את ה-answer של תרגיל. answer יכול להכיל חלופות מופרדות ב"או".
// מחרוזת של 4 תווים ומעלה (אחרי נרמול) נחשבת חשיפה אם היא מופיעה בהצעה. מחרוזת קצרה (get, int, 8) נחשבת רק אם ההצעה כולה זהה לה,
// כדי לא למחוק הצעות תמימות כמו "אני חושבת שזה 2 או 3".
export function suggestionLeaks(suggestion, answers) {
  const s = normForMatch(suggestion);
  if (!s) return false;
  for (const answer of answers || []) {
    for (const variant of String(answer).split(" או ")) {
      const v = normForMatch(variant);
      if (!v) continue;
      if (v.length >= 4 ? s.includes(v) : s === v) return true;
    }
  }
  return false;
}

// ניקוי רשימת הצעות: רק מחרוזות, בלי ריקות, בלי ארוכות מ-24 תווים, בלי כפילויות (אחרי נרמול), בלי הצעות שדולפות תשובה, עד 4.
export function sanitizeSuggestions(list, answers) {
  const out = [];
  const seen = new Set();
  for (const item of Array.isArray(list) ? list : []) {
    if (typeof item !== "string") continue;
    const text = item.trim().replace(/\s+/g, " ");
    if (!text || text.length > MAX_SUGGESTION_CHARS) continue;
    const key = normForMatch(text);
    if (!key || seen.has(key)) continue;
    if (suggestionLeaks(text, answers)) continue;
    seen.add(key);
    out.push(text);
    if (out.length === MAX_SUGGESTIONS) break;
  }
  return out;
}

// כשהמודל לא החזיר JSON תקין, ננסה לחלץ את reply מ-JSON חתוך (status incomplete), ואם גם זה לא מצליח, נחזיר את הטקסט כמו שהוא.
function salvageReply(raw) {
  const m = /"reply"\s*:\s*"((?:[^"\\]|\\.)*)/.exec(raw);
  if (!m) return null;
  try {
    return JSON.parse(`"${m[1].replace(/\\$/, "")}"`).trim() || null;
  } catch {
    return null;
  }
}

// מפענח את הטקסט שהמודל החזיר. ok=false אם הוא לא JSON תקין לפי הסכמה (ואז reply הוא הטקסט הגולמי או מה שחולץ ממנו).
export function parseTutorOutput(text) {
  const raw = String(text ?? "").trim();
  try {
    const data = JSON.parse(raw);
    if (data && typeof data === "object" && typeof data.reply === "string" && data.reply.trim() && Array.isArray(data.suggestions)) {
      return { ok: true, reply: data.reply.trim(), suggestions: data.suggestions };
    }
  } catch {
    // לא JSON: ממשיכים לחילוץ
  }
  const looksLikeJson = raw.startsWith("{");
  const salvaged = looksLikeJson ? salvageReply(raw) : null;
  return { ok: false, reply: salvaged || raw, suggestions: [] };
}

// ההצעות הסופיות שנשלחות ללומדת: אחרי סינון, ולפחות 2 (משלימים מברירות המחדל), עד 4.
export function finalizeSuggestions(rawSuggestions, answers) {
  const cleaned = sanitizeSuggestions(rawSuggestions, answers);
  if (cleaned.length >= MIN_SUGGESTIONS) return cleaned;
  const have = new Set(cleaned.map(normForMatch));
  for (const d of DEFAULT_SUGGESTIONS) {
    if (cleaned.length >= MIN_SUGGESTIONS) break;
    if (!have.has(normForMatch(d))) cleaned.push(d);
  }
  return cleaned;
}
