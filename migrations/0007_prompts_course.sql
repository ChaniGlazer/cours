-- קורס הפרומפטים: מוצג בקטלוג כ"בקרוב" כדי שהקישורים מהשיעורים אליו (/courses/prompts) יובילו לעמוד ולא ל-404.
INSERT OR IGNORE INTO courses (id, title, subtitle, description, is_paid, price_ils, position, created_at, coming_soon) VALUES
  (
    'prompts',
    'פרומפטים שעובדים',
    'ללמוד לכתוב הנחיות מדויקות, טובות ומקצועיות ל-AI',
    'קורס שמוקדש לכתיבת פרומפטים בצורה מדויקת ומקצועית. הקורס בהכנה ויפתח בקרוב.',
    0,
    NULL,
    4,
    strftime('%Y-%m-%dT%H:%M:%fZ', 'now'),
    1
  );
