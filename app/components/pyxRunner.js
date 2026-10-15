// app/components/pyxRunner.js
//
// תשתית להרצת פייתון אמיתי בדפדפן (Pyodide) בתוך שיעורי ה-HTML. מוזרקת ל-iframe של השיעור על ידי LessonHtmlFrame (כמו reportProgress),
// והשיעור משתמש בה דרך window.pyxRunner: הגדרת מקרי בדיקה ו-HTML של הכרטיס בלבד (ראו lessons/lesson6_dicts.html, תרגיל 6).
//
// ארכיטקטורה:
//  - ה-iframe של השיעור הוא sandbox בלי allow-same-origin (origin "null"). בתוכו נוצר iframe פנימי נוסף (sandbox עם allow-scripts בלבד)
//    עם meta CSP שמתיר חיבורים רק ל-cdn.jsdelivr.net. ה-Web Worker נוצר מ-Blob בתוך ה-iframe הפנימי ולכן יורש את ה-CSP:
//    הדפדפן עצמו חוסם גישה לרשת מהקוד של התלמידה. הריגה של Worker = הסרת ה-iframe הפנימי שלו. בתוך ה-Worker מוסרים גם את כלי הרשת.
//  - Pyodide בגרסה מקובעת (v0.29.5; v314 לא נטען כ-classic worker). הטעינה מתחילה מוקדם (prewarmWhenVisible: כשהתרגיל נכנס ל-viewport
//    והדפדפן במצב idle) או בלחיצה על "הריצי".
//  - Worker רזרבי: אחרי הריצה הראשונה נוצר Worker שני ברקע. בביטול או ב-timeout הרזרבי מחליף את הפעיל מיד, ונוצר רזרבי חדש.
//  - כשל בטעינה (רשת, חסימה, דפדפן שלא תומך) הופך לסטטוס error עם סיבה, והממשק (mount) מציג הודעה בעברית וכפתור "נסי שוב".
//
// כל הפונקציות כאן מוזרקות כטקסט (toString), ולכן כל אחת עצמאית: בלי התייחסות למשתנים מחוץ לה (הנתונים עוברים כארגומנט).

const BASE = "https://cdn.jsdelivr.net/pyodide/v0.29.5/full/";
const CSP =
  "default-src 'none'; script-src 'unsafe-inline' 'unsafe-eval' 'wasm-unsafe-eval' blob: https://cdn.jsdelivr.net; worker-src blob:; connect-src https://cdn.jsdelivr.net";

// פייתון: מריץ את הקוד של התלמידה, ואז קורא לפונקציה בשם fn_name עם כל מקרה בדיקה. מחזיר JSON.
const HARNESS = [
  "import sys, io, json, traceback",
  "",
  "def _line_of(e):",
  "    ln = None",
  "    for fr in traceback.extract_tb(e.__traceback__):",
  '        if fr.filename == "<code>":',
  "            ln = fr.lineno",
  "    return ln",
  "",
  "def _err(e):",
  "    if isinstance(e, SyntaxError):",
  '        return {"type": type(e).__name__, "msg": e.msg or "", "line": e.lineno}',
  '    return {"type": type(e).__name__, "msg": str(e), "line": _line_of(e)}',
  "",
  "def run_student(code, fn_name, tests_json):",
  "    tests = json.loads(tests_json)",
  "    buf = io.StringIO()",
  "    real_out, real_err = sys.stdout, sys.stderr",
  "    sys.stdout = sys.stderr = buf",
  '    res = {"error": None, "cases": []}',
  "    try:",
  '        ns = {"__name__": "__main__"}',
  "        try:",
  '            exec(compile(code, "<code>", "exec"), ns)',
  "        except BaseException as e:",
  '            res["error"] = _err(e)',
  "        else:",
  "            fn = ns.get(fn_name)",
  "            if not callable(fn):",
  '                res["error"] = {"type": "MissingFunction", "msg": "", "line": None}',
  "            else:",
  "                for t in tests:",
  '                    c = {"id": t["id"]}',
  "                    try:",
  '                        got = fn(json.loads(json.dumps(t["input"])))',
  '                        c["got"] = repr(got)[:200]',
  '                        c["none"] = got is None',
  '                        c["pass"] = isinstance(got, dict) and got == t["expected"]',
  "                    except BaseException as e:",
  '                        c["pass"] = False',
  '                        c["error"] = _err(e)',
  '                    res["cases"].append(c)',
  "    finally:",
  "        sys.stdout, sys.stderr = real_out, real_err",
  '    res["stdout"] = buf.getvalue()[:4000]',
  "    return json.dumps(res, ensure_ascii=False)"
].join("\n");

// ---- רץ בתוך ה-Web Worker ----
function pyxWorker() {
  var py = null;
  // שכבת הגנה שנייה: אחרי שפייתון עלה אין עוד צורך ברשת, ולכן מסירים את ה-API שלה (ה-CSP של ה-iframe הפנימי הוא החסימה האמיתית).
  function lockdown() {
    var names = ["fetch", "XMLHttpRequest", "WebSocket", "EventSource", "importScripts", "Worker", "SharedWorker", "caches", "BroadcastChannel"];
    var deny = function () { throw new Error("אין גישה לרשת בתרגיל הזה"); };
    var proto = Object.getPrototypeOf(Object.getPrototypeOf(self));
    names.forEach(function (n) {
      try { delete proto[n]; } catch (e) {}
      try { delete self[n]; } catch (e) {}
      try { Object.defineProperty(self, n, { value: deny, writable: false, configurable: false }); } catch (e) {}
    });
  }
  self.onmessage = async function (e) {
    var d = e.data;
    try {
      if (d.type === "boot") {
        var t0 = Date.now();
        importScripts(d.base + "pyodide.js");
        py = await loadPyodide({ indexURL: d.base });
        py.runPython(d.harness);
        lockdown();
        self.postMessage({ type: "ready", ms: Date.now() - t0 });
      } else if (d.type === "run") {
        py.globals.set("PYX_CODE", d.code);
        py.globals.set("PYX_FN", d.fn);
        py.globals.set("PYX_TESTS", d.cases);
        self.postMessage({ type: "result", json: py.runPython("run_student(PYX_CODE, PYX_FN, PYX_TESTS)") });
      }
    } catch (err) {
      self.postMessage({ type: "fatal", message: String((err && err.message) || err) });
    }
  };
}

// ---- רץ בתוך ה-iframe הפנימי (עם ה-CSP): יוצר את ה-Worker מ-Blob ומעביר הודעות ----
function pyxBridge() {
  var worker = null;
  function post(m) { parent.postMessage(m, "*"); }
  window.addEventListener("message", function (e) {
    if (e.source !== parent) return;
    var d = e.data || {};
    if (d.type === "boot") {
      try {
        worker = new Worker(URL.createObjectURL(new Blob([d.workerSrc], { type: "text/javascript" })));
      } catch (err) { post({ type: "fatal", message: "worker: " + err }); return; }
      worker.onmessage = function (ev) { post(ev.data); };
      worker.onerror = function (ev) { post({ type: "fatal", message: String((ev && ev.message) || "worker error") }); };
      worker.postMessage({ type: "boot", harness: d.harness, base: d.base });
    } else if (d.type === "run" && worker) {
      worker.postMessage(d);
    }
  });
  post({ type: "alive" });
}

// ---- רץ ב-iframe של השיעור: ניהול ה-Workers (פעיל + רזרבי), טעינה מוקדמת, ה-API של השיעור וממשק התרגיל (mount) ----
function pyxHost(cfg) {
  "use strict";
  var supported = typeof Worker !== "undefined" && typeof WebAssembly !== "undefined" && typeof Blob !== "undefined" &&
    typeof URL !== "undefined" && typeof URL.createObjectURL === "function";
  var opts = { bootTimeoutMs: 90000, runTimeoutMs: 5000 };
  var active = null, spare = null, lastError = null, firstRunDone = false, prewarmed = false;
  var all = [], listeners = [];

  function emit(ev) { for (var i = 0; i < listeners.length; i++) { try { listeners[i](ev); } catch (e) {} } }
  function classify(message) {
    if (/^worker:/.test(message)) return "unsupported";
    return "network";
  }

  function createSlot() {
    var s = { frame: null, state: "booting", waiters: [], job: null, timer: null, bootMs: 0 };
    if (!supported) { s.state = "dead"; s.error = { reason: "unsupported" }; return s; }
    try {
      var f = document.createElement("iframe");
      f.setAttribute("sandbox", "allow-scripts");
      f.setAttribute("aria-hidden", "true");
      f.tabIndex = -1;
      f.title = "מפעיל הפייתון (מוסתר)";
      f.style.cssText = "display:none;width:0;height:0;border:0";
      f.srcdoc = '<!doctype html><meta http-equiv="Content-Security-Policy" content="' + cfg.csp + '"><script>(' + cfg.bridge + ")();<" + "/script>";
      document.body.appendChild(f);
      s.frame = f;
    } catch (e) { s.state = "dead"; s.error = { reason: "unsupported" }; return s; }
    s.timer = setTimeout(function () { slotFailed(s, "boot-timeout", ""); }, opts.bootTimeoutMs);
    all.push(s);
    return s;
  }

  function destroy(s) {
    clearTimeout(s.timer);
    if (s.frame) { s.frame.remove(); s.frame = null; }
    s.state = "dead";
    var i = all.indexOf(s);
    if (i >= 0) all.splice(i, 1);
  }

  // כשל בטעינת Worker. אם הוא הפעיל: שגיאה לממשק ולכל מי שממתין. אם הוא הרזרבי: מתעלמים (ינסו שוב בהזדמנות הבאה).
  function slotFailed(s, reason, message) {
    var waiters = s.waiters.splice(0);
    destroy(s);
    if (s === spare) { spare = null; return; }
    if (s === active) {
      active = null;
      lastError = { reason: reason, message: message };
      for (var i = 0; i < waiters.length; i++) waiters[i].fail(lastError);
      emit({ phase: "error", reason: reason, message: message });
    }
  }

  function ensureActive() {
    if (active && active.state !== "dead") return active;
    if (spare && spare.state !== "dead") { active = spare; spare = null; }
    else active = createSlot();
    if (active.state === "dead") {
      lastError = active.error;
      var err = active.error;
      var dead = active;
      active = null;
      emit({ phase: "error", reason: err.reason });
      return dead;
    }
    emit({ phase: active.state === "ready" ? "ready" : "loading" });
    return active;
  }

  // Worker רזרבי: נוצר ברקע אחרי הריצה הראשונה, ומחליף את הפעיל מיד בביטול או ב-timeout.
  function ensureSpare() {
    if (!firstRunDone || spare || !supported) return;
    setTimeout(function () { if (!spare) spare = createSlot(); }, 0);
  }

  function onResult(s, json) {
    var job = s.job;
    s.job = null;
    if (!job) return;
    clearTimeout(job.timer);
    s.state = "ready";
    var res;
    try { res = JSON.parse(json); } catch (e) { job.resolve({ ok: false, reason: "fatal", message: "bad result" }); return; }
    job.resolve({ ok: true, result: res });
    emit({ phase: "ready" });
    firstRunDone = true;
    ensureSpare();
  }

  function runFatal(s, message) {
    var job = s.job;
    s.job = null;
    if (job) { clearTimeout(job.timer); job.resolve({ ok: false, reason: "fatal", message: message }); }
    destroy(s);
    if (s === active) { active = null; emit({ phase: "idle" }); }
    if (s === spare) spare = null;
    firstRunDone = true;
    ensureSpare();
  }

  // הריגה של הפעיל (timeout, או "עצרי"): הרזרבי מחליף אותו מיד אם קיים, ונוצר רזרבי חדש.
  function kill(reason) {
    var s = active;
    if (!s) return;
    var job = s.job;
    s.job = null;
    if (job) { clearTimeout(job.timer); job.resolve({ ok: false, reason: reason }); }
    var waiters = s.waiters.splice(0);
    for (var i = 0; i < waiters.length; i++) waiters[i].fail({ reason: reason });
    destroy(s);
    active = null;
    firstRunDone = true;
    if (spare && spare.state !== "dead") {
      active = spare;
      spare = null;
      emit({ phase: active.state === "ready" ? "ready" : "loading", swapped: true });
    } else {
      emit({ phase: "idle" });
    }
    ensureSpare();
  }

  window.addEventListener("message", function (e) {
    var s = null;
    for (var i = 0; i < all.length; i++) { if (all[i].frame && all[i].frame.contentWindow === e.source) { s = all[i]; break; } }
    if (!s) return;
    var d = e.data || {};
    if (d.type === "alive") {
      s.frame.contentWindow.postMessage({ type: "boot", workerSrc: cfg.worker, harness: cfg.harness, base: cfg.base }, "*");
    } else if (d.type === "ready") {
      clearTimeout(s.timer);
      s.state = "ready";
      s.bootMs = d.ms;
      if (s === active) {
        emit({ phase: "ready", ms: d.ms });
        var waiters = s.waiters.splice(0);
        for (var j = 0; j < waiters.length; j++) waiters[j].ready();
      }
    } else if (d.type === "result") {
      onResult(s, d.json);
    } else if (d.type === "fatal") {
      if (s.state === "booting") slotFailed(s, classify(String(d.message)), String(d.message));
      else runFatal(s, String(d.message));
    }
  });

  // מריץ קוד של תלמידה מול מקרי בדיקה. מחזיר Promise עם { ok: true, result } או { ok: false, reason: "run-timeout" | "stopped" | "fatal" | "unsupported" | "network" | "boot-timeout" }.
  function run(o) {
    return new Promise(function (resolve) {
      var s = ensureActive();
      if (!s || s.state === "dead") { resolve({ ok: false, reason: (lastError && lastError.reason) || "network" }); return; }
      var job = { resolve: resolve, timer: null };
      function begin() {
        s.state = "busy";
        s.job = job;
        job.timer = setTimeout(function () { kill("run-timeout"); }, o.timeoutMs || opts.runTimeoutMs);
        s.frame.contentWindow.postMessage({ type: "run", code: o.code, fn: o.fn, cases: JSON.stringify(o.cases) }, "*");
        emit({ phase: "running" });
      }
      if (s.state === "ready") begin();
      else s.waiters.push({ ready: begin, fail: function (err) { resolve({ ok: false, reason: err.reason, message: err.message }); } });
    });
  }

  function prewarm() {
    if (prewarmed || !supported) return;
    prewarmed = true;
    ensureActive();
  }

  // טעינה מוקדמת: כשהאלמנט נכנס ל-viewport (IntersectionObserver), ואחרי שהדפדפן במצב idle. לא בחיבור חסכוני או איטי מאוד.
  function prewarmWhenVisible(el) {
    if (!el || prewarmed || !supported) return;
    var c = navigator.connection;
    if (c && (c.saveData || /(^|-)2g$/.test(c.effectiveType || ""))) return;
    var go = function () {
      var idle = window.requestIdleCallback || function (cb) { return setTimeout(cb, 1500); };
      idle(function () { prewarm(); }, { timeout: 4000 });
    };
    if (!("IntersectionObserver" in window)) { go(); return; }
    var io = new IntersectionObserver(function (entries) {
      for (var i = 0; i < entries.length; i++) { if (entries[i].isIntersecting) { io.disconnect(); go(); return; } }
    });
    io.observe(el);
  }

  function retry() {
    lastError = null;
    if (active && active.state === "dead") active = null;
    prewarmed = true;
    ensureActive();
  }

  function stop() { kill("stopped"); }

  function status() {
    return { supported: supported, active: active ? active.state : null, spare: spare ? spare.state : null, error: lastError, bootMs: active ? active.bootMs : 0, firstRunDone: firstRunDone };
  }

  // ---------- ממשק תרגיל: מחבר כרטיס HTML (לפי ids) למקרי בדיקה. כל הטקסטים והעיצוב של התוצאות כאן, כדי שהשיעור יישאר קטן ----------
  function mount(c) {
    var byId = function (id) { return document.getElementById(id); };
    var el = {};
    for (var k in c.ids) el[k] = byId(c.ids[k]);
    var busy = false, userStarted = false;

    function pyRepr(v) {
      if (typeof v === "string") return "'" + v + "'";
      if (Array.isArray(v)) return "[" + v.map(pyRepr).join(", ") + "]";
      if (v && typeof v === "object") return "{" + Object.keys(v).map(function (key) { return pyRepr(key) + ": " + pyRepr(v[key]); }).join(", ") + "}";
      return String(v);
    }
    function setStatus(text, kind, showRetry) {
      el.status.hidden = !text;
      el.status.className = "pyx-status" + (kind ? " " + kind : "");
      el.statusText.textContent = text || "";
      if (el.retry) el.retry.hidden = !showRetry;
    }
    function setFeedback(ok, text) { el.feedback.textContent = text; el.feedback.className = "exercise-feedback " + (ok ? "correct" : "wrong"); }
    function setBusy(b) { busy = b; el.run.disabled = b; el.stop.hidden = !b; }
    function clearOutput() { el.tests.textContent = ""; el.output.textContent = ""; el.feedback.textContent = ""; el.feedback.className = "exercise-feedback"; }

    function friendly(err) {
      var line = err.line ? " (בשורה " + err.line + ")" : "", m = err.msg || "";
      switch (err.type) {
        case "KeyError": return "KeyError" + line + ": ניסית לקרוא מהמילון את המפתח " + m + ", אבל הוא עוד לא קיים שם. אפשר לבדוק קודם עם in, או להשתמש ב-get עם ערך ברירת מחדל.";
        case "SyntaxError": return "SyntaxError" + line + ": יש טעות בכתיב של הקוד (" + m + "). בדקי נקודתיים, סוגריים ומרכאות.";
        case "IndentationError": case "TabError": return err.type + line + ": ההזחה לא נכונה (" + m + "). כל הקוד שבתוך הפונקציה צריך להיות מוזח באותה מידה.";
        case "NameError": return "NameError" + line + ": הפייתון לא מכירה את השם הזה (" + m + "). אולי שכחת להגדיר אותו, או שיש טעות הקלדה.";
        case "TypeError": return "TypeError" + line + ": פעולה על סוג ערך לא מתאים (" + m + ").";
        case "AttributeError": return "AttributeError" + line + ": לערך הזה אין את הפעולה שביקשת (" + m + ").";
        case "IndexError": return "IndexError" + line + ": ביקשת תא שלא קיים ברשימה (" + m + ").";
        case "ValueError": return "ValueError" + line + ": ערך לא מתאים (" + m + ").";
        case "ZeroDivisionError": return "ZeroDivisionError" + line + ": אי אפשר לחלק באפס.";
        case "MissingFunction": return "לא מצאתי פונקציה בשם " + c.fn + ". בדקי שכתבת def " + c.fn + "(...): בדיוק כך.";
        default: return err.type + line + (m ? ": " + m : "");
      }
    }

    function renderCases(res) {
      el.tests.textContent = "";
      var pass = 0;
      res.cases.forEach(function (r) {
        var spec = null;
        for (var i = 0; i < c.cases.length; i++) { if (c.cases[i].id === r.id) spec = c.cases[i]; }
        var li = document.createElement("li");
        li.className = r.pass ? "pass" : "fail";
        var mark = document.createElement("span");
        mark.className = "mark";
        mark.textContent = r.pass ? "✓" : "✗";
        mark.setAttribute("aria-label", r.pass ? "עבר" : "נכשל");
        var body = document.createElement("span");
        var title = document.createElement("span");
        title.textContent = "מקרה " + r.id + ": " + spec.label;
        body.appendChild(title);
        var detail = function (builder) { var d = document.createElement("span"); d.className = "detail"; builder(d); body.appendChild(d); };
        var code = function (parent, text) { var q = document.createElement("code"); q.textContent = text; parent.appendChild(q); };
        if (!spec.hidden) {
          detail(function (d) { d.appendChild(document.createTextNode("קלט: ")); code(d, c.fn + "(" + pyRepr(spec.input) + ")"); });
          if (!r.pass) {
            detail(function (d) {
              if (r.error) d.textContent = friendly(r.error);
              else if (r.none) d.textContent = "הפונקציה לא החזירה כלום (None). בדקי שיש return.";
              else {
                d.appendChild(document.createTextNode("קיבלת: ")); code(d, r.got);
                d.appendChild(document.createTextNode(" · ציפינו ל: ")); code(d, pyRepr(spec.expected));
              }
            });
          }
        } else if (!r.pass && r.error) {
          detail(function (d) { d.textContent = friendly(r.error); });
        }
        li.appendChild(mark);
        li.appendChild(body);
        el.tests.appendChild(li);
        if (r.pass) pass++;
      });
      return pass === c.cases.length;
    }

    function showResult(res) {
      setBusy(false);
      if (res.ok) {
        var r = res.result;
        setStatus("", "");
        el.output.style.direction = r.stdout ? "" : "rtl";
        el.output.style.textAlign = r.stdout ? "" : "right";
        el.output.textContent = r.stdout ? r.stdout : "התוכנית לא הדפיסה כלום. זה בסדר: הבדיקה קוראת לפונקציה שלך בעצמה.";
        if (r.error) { setFeedback(false, friendly(r.error)); return; }
        if (renderCases(r)) {
          setFeedback(true, "מעולה! כל המקרים עברו, גם המקרה הנסתר.");
          if (c.onPass) c.onPass();
          // הקשר לחונכת: התרגיל עבר, והקוד של התלמידה נשלח להורה
          if (c.topicKey) { try { parent.postMessage({ type: "tutor-context", topicKey: c.topicKey, code: String(el.code.value).slice(0, 4000) }, "*"); } catch (e) {} }
        } else {
          setFeedback(false, "עוד לא. בדקי את המקרים שסומנו ב-✗ ונסי שוב.");
        }
        return;
      }
      clearOutput();
      switch (res.reason) {
        case "run-timeout": setStatus("הקוד רץ יותר מ-" + Math.round(opts.runTimeoutMs / 1000) + " שניות, ולכן עצרתי אותו (לולאה אינסופית?). בדקי שהלולאה מסתיימת ונסי שוב.", "err"); setFeedback(false, "הריצה נעצרה."); break;
        case "stopped": setStatus("עצרתי את הריצה.", "err"); setFeedback(false, "הריצה נעצרה."); break;
        case "unsupported": setStatus("הדפדפן שלך לא מאפשר להריץ כאן פייתון. אפשר לפתור את התרגיל בעורך הפייתון שלך (למשל VS Code), ולנסות דפדפן עדכני יותר.", "err"); setFeedback(false, "ההרצה לא זמינה בדפדפן הזה."); break;
        case "fatal": setStatus("שגיאה בהרצה. נסי שוב.", "err", true); setFeedback(false, "הריצה נכשלה."); break;
        default: setStatus("לא הצלחתי לטעון את פייתון. בדקי חיבור לאינטרנט (או שהאתר חסום ברשת שלך) ולחצי ״נסי שוב״.", "err", true); setFeedback(false, "הטעינה נכשלה.");
      }
    }

    function start() {
      if (busy) return;
      userStarted = true;
      clearOutput();
      setBusy(true);
      var st = status();
      setStatus(st.active === "ready" ? "מריצה את הקוד…" : "טוענת את פייתון לדפדפן… (כ-5MB, רק בפעם הראשונה; לפעמים זה לוקח כמה שניות)", "");
      run({ fn: c.fn, code: el.code.value, cases: c.cases.map(function (x) { return { id: x.id, input: x.input, expected: x.expected }; }) }).then(showResult);
    }

    listeners.push(function (ev) {
      if (!userStarted || !busy) return;
      if (ev.phase === "running") setStatus("מריצה את הקוד…", "");
      else if (ev.phase === "loading") setStatus("טוענת את פייתון לדפדפן… (כ-5MB, רק בפעם הראשונה; לפעמים זה לוקח כמה שניות)", "");
    });

    el.run.addEventListener("click", start);
    el.stop.addEventListener("click", stop);
    if (el.retry) el.retry.addEventListener("click", function () { if (busy) return; retry(); start(); });
    el.code.addEventListener("keydown", function (ev) { if ((ev.ctrlKey || ev.metaKey) && ev.key === "Enter") { ev.preventDefault(); start(); } });
    if (!supported) { setStatus("הדפדפן שלך לא מאפשר להריץ כאן פייתון. אפשר לפתור את התרגיל בעורך הפייתון שלך (למשל VS Code).", "err"); el.run.disabled = true; }
    if (c.prewarm !== false) prewarmWhenVisible(byId(c.card || c.ids.card));
  }

  window.pyxRunner = { run: run, stop: stop, retry: retry, prewarm: prewarm, prewarmWhenVisible: prewarmWhenVisible, status: status, mount: mount, onStatus: function (cb) { listeners.push(cb); }, configure: function (o) { for (var k in o) opts[k] = o[k]; } };
}

export const PYX_RUNNER_SCRIPT =
  "<script>(" +
  pyxHost.toString() +
  ")(" +
  JSON.stringify({
    base: BASE,
    csp: CSP,
    harness: HARNESS,
    worker: "(" + pyxWorker.toString() + ")();",
    bridge: pyxBridge.toString()
  }).replace(/<\//g, "<\\/") +
  ");</script>";
