// lib/tutorOpenAI.js
//
// קריאה ל-OpenAI Responses API (POST /v1/responses) עם fetch ישיר, בלי SDK. לפי התיעוד העדכני (developers.openai.com, 2026-10):
// הבקשה: model, instructions (הוראות מערכת), input (מערך הודעות role/content), max_output_tokens, reasoning.effort, store, safety_identifier.
// התשובה: מערך output, ובו פריטי type "message" עם content מסוג output_text. usage: input_tokens, output_tokens, total_tokens.
// חשוב: טוקני reasoning נספרים בתוך max_output_tokens, ולכן מגבלה קטנה מדי יכולה להחזיר תשובה ריקה (status "incomplete").
//
// קובץ עצמאי (בלי import), כדי ש-scripts/tutor-eval.mjs יוכל לטעון אותו. הוא לא רושם ללוג תוכן שיחה, ולא מחזיר הודעות שגיאה גולמיות.

export const DEFAULT_API_BASE = "https://api.openai.com/v1";

// שגיאת ספק פנימית: kind בלבד (בלי טקסט גולמי), כדי שאי אפשר יהיה לדלוף אותה בטעות ללומדת.
export class TutorProviderError extends Error {
  constructor(kind, status) {
    super(`tutor provider error: ${kind}${status ? ` (${status})` : ""}`);
    this.name = "TutorProviderError";
    this.kind = kind; // "config" | "timeout" | "network" | "http" | "incomplete" | "empty" | "bad_response"
    this.status = status || null;
  }
}

function extractText(data) {
  const parts = [];
  for (const item of data?.output || []) {
    if (item?.type !== "message") continue;
    for (const c of item.content || []) {
      if (c?.type === "output_text" && typeof c.text === "string") parts.push(c.text);
    }
  }
  return parts.join("").trim();
}

// messages: [{ role: "user" | "assistant", content: string }]. מחזיר { text, usage: { input, output, total } }.
export async function callTutorModel({
  apiKey,
  baseUrl = DEFAULT_API_BASE,
  model,
  instructions,
  messages,
  maxOutputTokens = 1200,
  reasoningEffort = "low",
  safetyIdentifier,
  timeoutMs = 20000
}) {
  if (!apiKey || !model) throw new TutorProviderError("config");
  const body = {
    model,
    instructions,
    input: messages,
    max_output_tokens: maxOutputTokens,
    store: false
  };
  if (reasoningEffort) body.reasoning = { effort: reasoningEffort };
  if (safetyIdentifier) body.safety_identifier = safetyIdentifier;

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  let res;
  try {
    res = await fetch(`${baseUrl.replace(/\/+$/, "")}/responses`, {
      method: "POST",
      headers: { "Content-Type": "application/json", Authorization: `Bearer ${apiKey}` },
      body: JSON.stringify(body),
      signal: controller.signal
    });
  } catch (e) {
    throw new TutorProviderError(e?.name === "AbortError" ? "timeout" : "network");
  } finally {
    clearTimeout(timer);
  }
  if (!res.ok) throw new TutorProviderError("http", res.status);

  let data;
  try {
    data = await res.json();
  } catch {
    throw new TutorProviderError("bad_response");
  }
  const text = extractText(data);
  // תשובה חתוכה בלי טקסט נראה (כל הטוקנים הלכו על reasoning) נחשבת כישלון, כדי לא לספור ניסיון על תשובה ריקה.
  if (!text) throw new TutorProviderError(data?.status === "incomplete" ? "incomplete" : "empty");
  const u = data.usage || {};
  return { text, usage: { input: u.input_tokens || 0, output: u.output_tokens || 0, total: u.total_tokens || 0 }, truncated: data.status === "incomplete" };
}
