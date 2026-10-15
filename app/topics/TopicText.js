// טקסט עברית עם קטעי קוד באנגלית (print, range(4), [::-1], age = age + 1 ועוד). בלי טיפול מיוחד, הסימנים שבקצה הקוד ("[", "-", ".", "=") נשברים
// בתצוגה מימין לשמאל והקוד מתהפך. לכן כל קטע ASCII שמכיל אותיות, סוגריים מרובעים או סימני השוואה נעטף ב-<code dir="ltr">.
// קטע שהוקף בגרשיים הפוכים (`...`) בטקסט המקור נעטף תמיד, גם אם אין בו אותיות (למשל `-1`).
// קומפוננטת server, בלי hooks.

const HEBREW = /[֐-׿]/;
const NOT_CODE = /^(AI|Java|Enter)$/;

function count(s, ch) {
  let n = 0;
  for (const c of s) if (c === ch) n++;
  return n;
}

// מקצץ רווחים, פיסוק בקצה, ותווי סוגריים ללא זוג (הם שייכים למשפט העברי). מקף צמוד לעברית (ב-print) נשאר מחוץ לקוד.
function trimRun(text, start, run) {
  let s = start;
  let r = run;
  const lead = r.length - r.trimStart().length;
  s += lead;
  r = r.trimStart();
  // פיסוק של המשפט העברי שנצמד לקוד ("... בסוף. append מוסיפה"): נשאר מחוץ לקוד
  const punct = /^[.,:;!?]+\s+/.exec(r);
  if (punct) {
    r = r.slice(punct[0].length);
    s += punct[0].length;
  }
  // מקף צמוד לאות עברית הוא תחילית ("ב-0", "ב-print"), לא סימן מינוס
  if (r.startsWith("-") && s > 0 && HEBREW.test(text[s - 1])) {
    r = r.slice(1);
    s += 1;
  }
  r = r.trimEnd();
  for (;;) {
    const before = r;
    r = r.replace(/[.,:;!?"'״׳]+$/, "");
    if (r.startsWith("(") && count(r, "(") > count(r, ")")) {
      r = r.slice(1);
      s += 1;
    }
    if (r.endsWith(")") && count(r, ")") > count(r, "(")) r = r.slice(0, -1);
    if (r.endsWith("-") && !/^-?\d*-$/.test(r)) r = r.replace(/-+$/, "");
    if (r === before) break;
  }
  return { start: s, core: r };
}

function isCode(core) {
  if (!core || NOT_CODE.test(core)) return false;
  return /[A-Za-z\[\]<>=]/.test(core) || /^-\d/.test(core);
}

function autoWrap(text, keyBase) {
  const out = [];
  let last = 0;
  let k = 0;
  const re = /[^֐-׿]+/g;
  let m;
  while ((m = re.exec(text))) {
    const { start, core } = trimRun(text, m.index, m[0]);
    if (!isCode(core)) continue;
    if (start > last) out.push(text.slice(last, start));
    out.push(
      <code className="tp-inline" dir="ltr" key={`${keyBase}-${k++}`}>
        {core}
      </code>
    );
    last = start + core.length;
  }
  if (last < text.length) out.push(text.slice(last));
  return out;
}

export default function TopicText({ text }) {
  const parts = String(text).split(/`([^`]+)`/);
  return parts.flatMap((p, i) =>
    i % 2 === 1
      ? [
          <code className="tp-inline" dir="ltr" key={`e${i}`}>
            {p}
          </code>
        ]
      : autoWrap(p, `a${i}`)
  );
}
