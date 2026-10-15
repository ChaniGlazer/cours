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

// בבניית השרת (esbuild עם keepNames) נוספות לפונקציות קריאות __name(...), והן נכנסות גם לטקסט של toString שמוזרק לשיעור.
// בתוך ה-iframe אין __name, והסקריפט היה נכשל בשקט (window.pyxRunner לא הוגדר). לכן כל קטע מוזרק מקבל הגדרה ריקה שלו.
const NAME_SHIM = "var __name=function(t){return t};";

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
  '        return {"type": type(e).__name__, "msg": e.msg or "", "line": e.lineno, "text": (e.text or "").strip()}',
  '    return {"type": type(e).__name__, "msg": str(e), "line": _line_of(e)}',
  "",
  // הרצה חופשית של תוכנית שלמה (עורך הקוד בשיעורים). input() אמיתי בלי חסימה: התשובות שכבר ניתנו מגיעות ב-inputs;
  // כשנגמרות, התוכנית נעצרת ב-_NeedInput והממשק מבקש תשובה מהתלמידה ומריץ שוב מההתחלה עם התשובה החדשה (random נקבע לפי seed, אז ההרצה חוזרת על עצמה).
  "class _NeedInput(BaseException):",
  "    pass",
  "",
  "def run_code(code, files_json, inputs_json, seed):",
  "    import builtins, random, os, importlib",
  "    files = json.loads(files_json)",
  "    inputs = json.loads(inputs_json)",
  "    buf = io.StringIO()",
  "    real_out, real_err, real_input = sys.stdout, sys.stderr, builtins.input",
  "    pos = [0]",
  "    segs = []",
  '    state = {"need": None}',
  '    def fake_input(prompt=""):',
  "        start = buf.tell()",
  "        buf.write(str(prompt))",
  "        if pos[0] < len(inputs):",
  "            v = inputs[pos[0]]",
  "            pos[0] += 1",
  '            buf.write(v + "\\n")',
  "            segs.append((start, buf.tell()))",
  "            return v",
  "        segs.append((start, buf.tell()))",
  '        state["need"] = str(prompt)',
  "        raise _NeedInput()",
  "    names = []",
  '    res = {"error": None, "needInput": False}',
  "    sys.stdout = sys.stderr = buf",
  "    builtins.input = fake_input",
  "    try:",
  "        for f in files:",
  '            with open(f["name"], "w", encoding="utf-8") as fh:',
  '                fh.write(f["code"])',
  '            names.append(f["name"])',
  "        importlib.invalidate_caches()",
  "        random.seed(seed)",
  '        ns = {"__name__": "__main__"}',
  "        try:",
  '            exec(compile(code, "<code>", "exec"), ns)',
  "        except _NeedInput:",
  '            res["needInput"] = True',
  "        except SystemExit:",
  "            pass",
  "        except BaseException as e:",
  '            res["error"] = _err(e)',
  "    finally:",
  "        sys.stdout, sys.stderr = real_out, real_err",
  "        builtins.input = real_input",
  "        for n in names:",
  "            try:",
  "                os.remove(n)",
  "            except OSError:",
  "                pass",
  '            sys.modules.pop(n[:-3] if n.endswith(".py") else n, None)',
  // stdout = מה שהתלמידה רואה בטרמינל (כולל השאלות והתשובות של input); printed = רק מה שהתוכנית הדפיסה, והבדיקות משוות מולו
  "    full = buf.getvalue()",
  '    printed = ""',
  "    last = 0",
  "    for a, b in segs:",
  "        printed += full[last:a]",
  "        last = b",
  "    printed += full[last:]",
  '    res["stdout"] = full[:20000]',
  '    res["printed"] = printed[:20000]',
  "    return json.dumps(res, ensure_ascii=False)",
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


const CODE_CSS = [
  ".pyc{margin-top:14px}",
  ".pyc-tabs{display:flex;gap:6px;direction:ltr;margin-bottom:-1px}",
  ".pyc-tabs[hidden]{display:none}",
  ".pyc-tab{font:600 13px var(--mono,monospace);padding:6px 14px;border-radius:8px 8px 0 0;border:1px solid rgba(255,255,255,.18);border-bottom:0;background:transparent;color:#b4aedb;cursor:pointer}",
  ".pyc-tab.on{background:#171431;color:#f5f3ff}",
  ".pyc-ed{display:block;width:100%;box-sizing:border-box;direction:ltr;text-align:left;font:500 14.5px/1.7 var(--mono,'JetBrains Mono',monospace);tab-size:4;white-space:pre;overflow:auto;resize:vertical;background:#171431;color:#f5f3ff;border:1px solid rgba(255,255,255,.18);border-radius:12px;padding:14px 16px;caret-color:#ffd166}",
  ".pyc-ed:focus{outline:2px solid var(--pyc-accent,var(--main,var(--for,var(--gold,var(--cyan,#7ce38b)))));outline-offset:1px}",
  ".pyc-hint{margin-top:8px;font-size:13.5px;color:var(--ink-dim,#b4aedb)}",
  ".pyc-bar{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin-top:12px}",
  ".pyc-btn{font:700 14.5px var(--sans,inherit);padding:9px 18px;border-radius:100px;border:1px solid transparent;cursor:pointer;background:var(--pyc-accent,var(--main,var(--for,var(--gold,var(--cyan,#7ce38b)))));color:#1a1730}",
  ".pyc-btn:disabled{opacity:.5;cursor:default}",
  ".pyc-btn[hidden]{display:none}",
  ".pyc-btn-check{background:#5ce1a6}",
  ".pyc-btn-ghost{background:transparent;color:var(--ink-dim,#b4aedb);border-color:rgba(255,255,255,.25)}",
  ".pyc-fb{font-weight:700;font-size:14.5px}",
  ".pyc-fb.good{color:#5ce1a6}.pyc-fb.bad{color:#ff8a8a}",
  ".pyc-status{margin-top:12px;display:flex;flex-wrap:wrap;gap:10px;align-items:center;font-size:14.5px;color:var(--ink-dim,#b4aedb);background:rgba(255,255,255,.06);border-radius:10px;padding:10px 14px}",
  ".pyc-status[hidden]{display:none}.pyc-status.err{color:#ff8a8a}",
  ".pyc-term{margin-top:12px;background:#0c0a1c;color:#e9e6ff;border:1px solid rgba(255,255,255,.14);border-radius:12px;padding:12px 16px;font:500 14.5px/1.7 var(--mono,'JetBrains Mono',monospace);min-height:44px;overflow-x:auto}",
  ".pyc-term[hidden]{display:none}",
  ".pyc-term:before{content:'פלט';display:block;font:700 11px var(--sans,inherit);letter-spacing:.06em;color:#8b86b8;margin-bottom:4px}",
  ".pyc-line{white-space:pre-wrap;word-break:break-word}",
  ".pyc-dim{color:#8b86b8}",
  ".pyc-in{font:inherit;background:transparent;color:#ffd166;border:0;border-bottom:1px solid #ffd166;outline:none;min-width:12ch;padding:0 4px}",
  ".pyc-err{margin-top:8px;border-inline-start:3px solid #ff8a8a;padding:4px 12px;color:#ff8a8a}",
  ".pyc-err-line{font-weight:700;direction:ltr;text-align:left;white-space:pre-wrap}",
  ".pyc-err-hint{margin-top:4px;color:#f5f3ff;font-family:var(--sans,inherit);font-size:14px}",
  ".pyc-tests{list-style:none;margin:12px 0 0;padding:0;display:grid;gap:8px}",
  ".pyc-tests:empty{display:none}",
  ".pyc-tests li{display:flex;gap:10px;align-items:flex-start;background:rgba(255,255,255,.06);border-radius:10px;padding:9px 12px;font-size:14.5px}",
  ".pyc-tests .mark{flex:none;font-weight:800;min-width:1.2em}",
  ".pyc-tests li.pass .mark{color:#5ce1a6}.pyc-tests li.fail .mark{color:#ff8a8a}",
  ".pyc-tests .detail{display:block;color:var(--ink-dim,#b4aedb);font-size:13.5px;margin-top:2px}"
].join("").replace(/(^|\})(\.pyc-)/g, "$1.pyc $2"); // קידומת .pyc מחזקת את הסלקטורים מול כללי textarea וכדומה של השיעור

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
      } else if (d.type === "exec") {
        py.globals.set("PYX_CODE", d.code);
        py.globals.set("PYX_FILES", d.files);
        py.globals.set("PYX_INPUTS", d.inputs);
        py.globals.set("PYX_SEED", d.seed);
        self.postMessage({ type: "result", json: py.runPython("run_code(PYX_CODE, PYX_FILES, PYX_INPUTS, PYX_SEED)") });
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
    } else if ((d.type === "run" || d.type === "exec") && worker) {
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
      f.srcdoc = '<!doctype html><meta http-equiv="Content-Security-Policy" content="' + cfg.csp + '"><script>var __name=function(t){return t};(' + cfg.bridge + ")();<" + "/script>";
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

  // שולח הודעת ריצה ל-Worker הפעיל. מחזיר Promise עם { ok: true, result } או { ok: false, reason: "run-timeout" | "stopped" | "fatal" | "unsupported" | "network" | "boot-timeout" }.
  function dispatch(msg, timeoutMs) {
    return new Promise(function (resolve) {
      var s = ensureActive();
      if (!s || s.state === "dead") { resolve({ ok: false, reason: (lastError && lastError.reason) || "network" }); return; }
      var job = { resolve: resolve, timer: null };
      function begin() {
        s.state = "busy";
        s.job = job;
        job.timer = setTimeout(function () { kill("run-timeout"); }, timeoutMs || opts.runTimeoutMs);
        s.frame.contentWindow.postMessage(msg, "*");
        emit({ phase: "running" });
      }
      if (s.state === "ready") begin();
      else s.waiters.push({ ready: begin, fail: function (err) { resolve({ ok: false, reason: err.reason, message: err.message }); } });
    });
  }

  // כמה עורכים בעמוד אחד חולקים Worker אחד, ולכן הרצות נכנסות לתור (Worker מריץ משימה אחת בכל רגע).
  var queue = Promise.resolve();
  function enqueue(msg, timeoutMs) {
    var p = queue.then(function () { return dispatch(msg, timeoutMs); });
    queue = p.then(function () {}, function () {});
    return p;
  }

  // מריץ קוד של תלמידה מול מקרי בדיקה (פונקציה בשם fn).
  function run(o) {
    return enqueue({ type: "run", code: o.code, fn: o.fn, cases: JSON.stringify(o.cases) }, o.timeoutMs);
  }

  // מריץ תוכנית שלמה: o.code הקובץ הראשי, o.files קבצים נוספים [{name, code}] (למשל מודול ל-import), o.inputs תשובות ל-input() לפי הסדר.
  // התוצאה: { stdout, error, needInput } (needInput = התוכנית עצרה ב-input() שעוד אין לו תשובה).
  function execCode(o) {
    return enqueue({ type: "exec", code: o.code, files: JSON.stringify(o.files || []), inputs: JSON.stringify(o.inputs || []), seed: o.seed || 1 }, o.timeoutMs);
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

  // ---------- עורך פייתון אמיתי: עורך + טרמינל + (אופציונלית) בדיקות. משמש תרגילים ודוגמאות בכל השיעורים ----------
  // c.el: id או אלמנט שבו נבנה הממשק. c.files: [{name, code}] (הראשון הוא הקובץ הראשי) או c.code. c.tests: [{label, inputs, transform(code), out, has, verify(res), hidden}].
  // c.onPass(), c.onRun(res), c.topicKey, c.id (קידומת ל-id של ה-textarea, למשל "ex1"), c.rows, c.hint, c.checkLabel, c.passText.
  var cssDone = false;
  function injectCss() {
    if (cssDone) return;
    cssDone = true;
    var st = document.createElement("style");
    st.id = "pyc-style";
    st.textContent = cfg.css;
    document.head.appendChild(st);
  }
  function mk(tag, cls, text) {
    var n = document.createElement(tag);
    if (cls) n.className = cls;
    if (text != null) n.textContent = text;
    return n;
  }
  function hintFor(err) {
    var m = err.msg || "", mm;
    switch (err.type) {
      case "SyntaxError":
        if (/unterminated string|EOL while/.test(m)) return "מרכאה נפתחה ולא נסגרה. לכל מרכאה פותחת צריכה להיות מרכאה סוגרת.";
        if (/was never closed/.test(m)) return "סוגריים נפתחו ולא נסגרו.";
        if (/expected ':'/.test(m)) return "חסרות נקודתיים (:) בסוף השורה.";
        if (/expected an indented block/.test(m)) return "אחרי שורה שנגמרת בנקודתיים, השורה הבאה צריכה להיות מוזחת.";
        return "יש טעות בכתיב של הקוד. בדקי נקודתיים, סוגריים ומרכאות." + (err.text ? " השורה: " + err.text : "");
      case "IndentationError": case "TabError":
        return "ההזחה לא נכונה. כל שורה שבתוך if / for / while / def מוזחת באותה מידה (ארבעה רווחים).";
      case "NameError":
        mm = /name '(.+)' is not defined/.exec(m);
        return "פייתון לא מכירה את השם" + (mm ? " " + mm[1] : "") + ". אולי שכחת להגדיר אותו, יש טעות הקלדה, או ששכחת מרכאות סביב טקסט.";
      case "TypeError":
        if (/'int' and 'str'|'str' and 'int'|must be str, not int|can only concatenate str/.test(m)) return "אי אפשר לחבר מספר וטקסט. אם הטקסט הגיע מ-input, צריך להפוך אותו עם int(...).";
        return "פעולה על סוג ערך לא מתאים (" + m + ").";
      case "ValueError":
        if (/invalid literal for int/.test(m)) return "int() מקבלת רק טקסט שנראה כמו מספר שלם, כמו 5 או 12.";
        return "ערך לא מתאים (" + m + ").";
      case "ZeroDivisionError": return "אי אפשר לחלק באפס.";
      case "IndexError": return "ביקשת מקום שלא קיים ברשימה או במחרוזת. האינדקסים מתחילים ב-0.";
      case "KeyError": return "ביקשת מפתח שלא קיים במילון. אפשר לבדוק קודם עם in, או להשתמש ב-get.";
      case "AttributeError": return "לערך הזה אין את הפעולה שביקשת (" + m + "). בדקי את שם הפעולה.";
      case "ModuleNotFoundError": case "ImportError": return "פייתון לא מצאה את המודול. בדקי את השם של הקובץ ואת שורת ה-import.";
      case "UnboundLocalError": return "משתנה שנוצר בתוך פונקציה לא קיים מחוץ לה, ולהפך.";
      case "RecursionError": return "הפונקציה קוראת לעצמה בלי סוף.";
      default: return "";
    }
  }
  function errorText(err) {
    return err.type + (err.msg ? ": " + err.msg : "") + (err.line ? " (שורה " + err.line + ")" : "");
  }
  // הודעת סטטוס לכשל כללי בהרצה (לא שגיאה בקוד של התלמידה)
  function failInfo(res) {
    switch (res.reason) {
      case "run-timeout": return { text: "הקוד רץ יותר מ-" + Math.round(opts.runTimeoutMs / 1000) + " שניות, ולכן עצרתי אותו (לולאה אינסופית?). בדקי שהלולאה מסתיימת.", retry: false };
      case "stopped": return { text: "עצרתי את הריצה.", retry: false };
      case "unsupported": return { text: "הדפדפן שלך לא מאפשר להריץ כאן פייתון. אפשר להריץ את הקוד בעורך שלך (למשל VS Code), או לנסות דפדפן עדכני יותר.", retry: false };
      case "fatal": return { text: "שגיאה בהרצה. נסי שוב.", retry: true };
      default: return { text: "לא הצלחתי לטעון את פייתון. בדקי חיבור לאינטרנט (או שהאתר חסום ברשת שלך) ולחצי ״נסי שוב״.", retry: true };
    }
  }
  function normOut(t) {
    var lines = String(t).replace(/\r/g, "").split("\n").map(function (l) { return l.replace(/\s+$/, ""); });
    while (lines.length && lines[lines.length - 1] === "") lines.pop();
    return lines.join("\n");
  }
  function hasBlank(code) { return /(^|\W)___(\W|$)/.test(code); }
  var LOADING_TEXT = "טוענת את פייתון לדפדפן… (כ-5MB, רק בפעם הראשונה; לפעמים זה לוקח כמה שניות)";

  function mountCode(c) {
    var root = typeof c.el === "string" ? document.getElementById(c.el) : c.el;
    if (!root) return null;
    injectCss();
    var files = (c.files || [{ name: "main.py", code: c.code || "" }]).map(function (f) { return { name: f.name, code: f.code, start: f.code }; });
    var tests = c.tests || [];
    var cur = 0, busy = false, token = 0, answers = [], waiting = false, userStarted = false;

    root.textContent = "";
    var box = mk("div", "pyc");
    var tabs = mk("div", "pyc-tabs");
    tabs.hidden = files.length < 2;
    var ta = mk("textarea", "pyc-ed");
    if (c.id) ta.id = c.id + "-code";
    ta.setAttribute("dir", "ltr");
    ta.setAttribute("spellcheck", "false");
    ta.setAttribute("autocapitalize", "off");
    ta.setAttribute("autocomplete", "off");
    ta.setAttribute("aria-label", c.label || "הקוד שלך בפייתון");
    ta.value = files[0].code;
    var bar = mk("div", "pyc-bar");
    var runBtn = mk("button", "pyc-btn", "▶ הריצי");
    runBtn.type = "button";
    var checkBtn = null;
    if (tests.length) { checkBtn = mk("button", "pyc-btn pyc-btn-check", "✓ " + (c.checkLabel || "בדקי")); checkBtn.type = "button"; }
    var stopBtn = mk("button", "pyc-btn pyc-btn-ghost", "עצרי");
    stopBtn.type = "button";
    stopBtn.hidden = true;
    var resetBtn = mk("button", "pyc-btn pyc-btn-ghost", "↺ שחזרי");
    resetBtn.type = "button";
    var fb = mk("span", "pyc-fb");
    fb.setAttribute("role", "status");
    fb.setAttribute("aria-live", "polite");
    bar.appendChild(runBtn);
    if (checkBtn) bar.appendChild(checkBtn);
    bar.appendChild(stopBtn);
    bar.appendChild(resetBtn);
    bar.appendChild(fb);
    var status = mk("div", "pyc-status");
    status.hidden = true;
    var statusText = mk("span");
    var retryBtn = mk("button", "pyc-btn pyc-btn-ghost", "נסי שוב");
    retryBtn.type = "button";
    retryBtn.hidden = true;
    status.appendChild(statusText);
    status.appendChild(retryBtn);
    var term = mk("div", "pyc-term");
    term.setAttribute("aria-label", "הפלט של התוכנית");
    term.hidden = true;
    var list = mk("ul", "pyc-tests");
    box.appendChild(tabs);
    box.appendChild(ta);
    if (c.hint) box.appendChild(mk("div", "pyc-hint", c.hint));
    box.appendChild(bar);
    box.appendChild(status);
    box.appendChild(term);
    box.appendChild(list);
    root.appendChild(box);

    function setStatus(text, kind, showRetry) {
      status.hidden = !text;
      status.className = "pyc-status" + (kind ? " " + kind : "");
      statusText.textContent = text || "";
      retryBtn.hidden = !showRetry;
    }
    function setFb(kind, text) { fb.textContent = text || ""; fb.className = "pyc-fb" + (kind ? " " + kind : ""); }
    function setBusy(b) { busy = b; runBtn.disabled = b; if (checkBtn) checkBtn.disabled = b; stopBtn.hidden = !b; }
    function syncCur() { files[cur].code = ta.value; }
    function extraFiles() { syncCur(); return files.slice(1).map(function (f) { return { name: f.name, code: f.code }; }); }
    function mainCode() { syncCur(); return files[0].code; }
    function growEditor() {
      var n = ta.value.split("\n").length;
      var rows = Math.max(c.rows || 5, Math.min(n + 1, c.maxRows || 22));
      ta.rows = rows;
    }
    function clearOutput() { term.textContent = ""; term.hidden = true; list.textContent = ""; setFb("", ""); setStatus("", ""); waiting = false; }

    function drawTabs() {
      tabs.textContent = "";
      files.forEach(function (f, i) {
        var b = mk("button", "pyc-tab" + (i === cur ? " on" : ""), f.name);
        b.type = "button";
        b.addEventListener("click", function () { syncCur(); cur = i; ta.value = files[cur].code; drawTabs(); growEditor(); });
        tabs.appendChild(b);
      });
    }
    drawTabs();
    growEditor();

    // מצייר את הפלט בטרמינל. pendingInput: מוסיף שדה הקלדה בסוף השורה האחרונה (שם נמצאת השאלה של input).
    function paint(stdout, err, pendingInput) {
      term.textContent = "";
      term.hidden = false;
      var text = stdout || "";
      var lines = text.split("\n");
      if (!pendingInput && lines.length && lines[lines.length - 1] === "") lines.pop();
      if (!text && !err && !pendingInput) {
        term.appendChild(mk("div", "pyc-line pyc-dim", "(התוכנית לא הדפיסה כלום)"));
      }
      var last = null;
      lines.forEach(function (ln) {
        if (!text) return;
        var d = mk("div", "pyc-line", ln === "" ? " " : ln);
        d.setAttribute("dir", "auto");
        term.appendChild(d);
        last = d;
      });
      if (pendingInput) {
        if (!last) { last = mk("div", "pyc-line"); last.setAttribute("dir", "auto"); term.appendChild(last); }
        var inp = mk("input", "pyc-in");
        inp.type = "text";
        inp.setAttribute("aria-label", "התשובה שלך לתוכנית (Enter לשליחה)");
        inp.setAttribute("autocomplete", "off");
        inp.setAttribute("dir", "auto");
        last.appendChild(document.createTextNode(" "));
        last.appendChild(inp);
        inp.addEventListener("keydown", function (ev) {
          if (ev.key !== "Enter") return;
          ev.preventDefault();
          answers.push(inp.value);
          inp.disabled = true;
          runFree(true);
        });
        try { inp.focus({ preventScroll: true }); } catch (e) { inp.focus(); }
      }
      if (err) {
        var e = mk("div", "pyc-err");
        e.appendChild(mk("div", "pyc-err-line", errorText(err)));
        var hint = hintFor(err);
        if (hint) e.appendChild(mk("div", "pyc-err-hint", hint));
        term.appendChild(e);
      }
    }

    function blankMessage() {
      var bad = false;
      syncCur();
      files.forEach(function (f) { if (hasBlank(f.code)) bad = true; });
      if (bad) setFb("bad", "עוד נשארו חלקים ריקים בקוד (___). החליפי כל ___ במה שחסר ואז הריצי.");
      return bad;
    }

    // הרצה חופשית: מדפיסה לטרמינל, ומבקשת קלט מהתלמידה כשהתוכנית מגיעה ל-input()
    function runFree(continuing) {
      if (busy) return;
      if (!continuing) {
        answers = [];
        clearOutput();
        if (blankMessage()) return;
      }
      userStarted = true;
      waiting = false;
      var my = ++token;
      var seed = c.seed || 7;
      setBusy(true);
      setStatus(status_ready() ? "מריצה את הקוד…" : LOADING_TEXT, "");
      execCode({ code: mainCode(), files: extraFiles(), inputs: answers, seed: seed }).then(function (res) {
        if (my !== token) return;
        setBusy(false);
        if (!res.ok) {
          var f = failInfo(res);
          setStatus(f.text, "err", f.retry);
          return;
        }
        setStatus("", "");
        var r = res.result;
        if (r.needInput) { waiting = true; paint(r.stdout, null, true); return; }
        paint(r.stdout, r.error, false);
        if (c.onRun) { try { c.onRun({ stdout: r.stdout, error: r.error, inputs: answers.slice() }); } catch (e) {} }
        if (c.topicKey && !r.error) { try { parent.postMessage({ type: "tutor-context", topicKey: c.topicKey, code: String(ta.value).slice(0, 4000) }, "*"); } catch (e2) {} }
      });
    }
    function status_ready() { var st = status_(); return st.active === "ready"; }
    function status_() { return { active: active ? active.state : null }; }

    // בדיקה: מריצה את הקוד מול כל מקרה (עם הקלט שלו) ובודקת את הפלט
    function judge(t, r) {
      if (r.error) return { ok: false, msg: errorText(r.error) + (hintFor(r.error) ? ". " + hintFor(r.error) : "") };
      if (r.needInput) return { ok: false, msg: t.needMsg || "התוכנית ביקשה עוד קלט ממה שציפינו. בדקי שהיא שואלת רק את מה שצריך." };
      if (t.out !== undefined) {
        if (normOut(r.printed) !== normOut(t.out)) {
          return { ok: false, msg: t.hidden ? "הפלט לא מתאים למה שהתבקשת." : "הפלט שלך: " + (normOut(r.printed) || "(ריק)").replace(/\n/g, " ⏎ ") + " · הפלט הנדרש: " + normOut(t.out).replace(/\n/g, " ⏎ ") };
        }
      }
      if (t.has) {
        for (var i = 0; i < t.has.length; i++) {
          var h = t.has[i], ok = typeof h === "string" ? r.printed.indexOf(h) >= 0 : h.test(r.printed);
          if (!ok) return { ok: false, msg: t.hidden ? "משהו חסר בפלט." : "בפלט חסר: " + (typeof h === "string" ? h : (t.hasLabels && t.hasLabels[i]) || String(h)) };
        }
      }
      if (t.verify) {
        var v = t.verify(r);
        if (v !== true) return { ok: false, msg: typeof v === "string" ? v : "התוצאה לא מתאימה." };
      }
      return { ok: true };
    }

    function runTests() {
      if (busy) return;
      answers = [];
      clearOutput();
      if (blankMessage()) return;
      userStarted = true;
      var my = ++token;
      setBusy(true);
      setStatus(status_ready() ? "בודקת את הקוד…" : LOADING_TEXT, "");
      var results = [], i = 0, code = mainCode(), extra = extraFiles();
      (function next() {
        if (i >= tests.length) { finish(); return; }
        var t = tests[i++];
        var src = code;
        try { if (t.transform) src = t.transform(code); } catch (e) {}
        var ins = [];
        try { ins = typeof t.inputs === "function" ? t.inputs(code) : (t.inputs || []); } catch (e) {}
        execCode({ code: src, files: extra, inputs: ins, seed: t.seed || 1 }).then(function (res) {
          if (my !== token) return;
          if (!res.ok) { setBusy(false); var f = failInfo(res); setStatus(f.text, "err", f.retry); setFb("bad", f.text); return; }
          res.result.code = code;
          res.result.files = extra;
          results.push({ t: t, r: res.result, v: judge(t, res.result) });
          next();
        });
      })();
      function finish() {
        setBusy(false);
        setStatus("", "");
        var failed = results.filter(function (x) { return !x.v.ok; });
        if (tests.length === 1) {
          paint(results[0].r.stdout, results[0].r.error, false);
        } else {
          results.forEach(function (x, k) {
            var li = mk("li", x.v.ok ? "pass" : "fail");
            li.appendChild(mk("span", "mark", x.v.ok ? "✓" : "✗"));
            var body = mk("span");
            body.appendChild(mk("span", null, x.t.label || "בדיקה " + (k + 1)));
            if (!x.v.ok && x.v.msg) body.appendChild(mk("span", "detail", x.v.msg));
            li.appendChild(body);
            list.appendChild(li);
          });
        }
        if (!failed.length) {
          setFb("good", c.passText || (tests.length > 1 ? "מעולה! כל הבדיקות עברו." : "מעולה! זה עובד."));
          if (c.onPass) { try { c.onPass(); } catch (e) {} }
          if (c.topicKey) { try { parent.postMessage({ type: "tutor-context", topicKey: c.topicKey, code: String(ta.value).slice(0, 4000) }, "*"); } catch (e2) {} }
        } else {
          setFb("bad", tests.length === 1 ? failed[0].v.msg : "עוד לא. בדקי את הבדיקות שסומנו ב-✗ ונסי שוב.");
        }
      }
    }

    function stopRun() { token++; stop(); setBusy(false); setStatus("עצרתי את הריצה.", "err"); }

    runBtn.addEventListener("click", function () { token++; busy = false; runFree(false); });
    if (checkBtn) checkBtn.addEventListener("click", function () { runTests(); });
    stopBtn.addEventListener("click", stopRun);
    retryBtn.addEventListener("click", function () { if (busy) return; retry(); if (checkBtn && fb.className.indexOf("bad") >= 0 && tests.length) runTests(); else runFree(false); });
    resetBtn.addEventListener("click", function () {
      token++;
      files.forEach(function (f) { f.code = f.start; });
      ta.value = files[cur].code;
      clearOutput();
      growEditor();
    });
    ta.addEventListener("input", function () { growEditor(); });
    ta.addEventListener("keydown", function (ev) {
      if ((ev.ctrlKey || ev.metaKey) && ev.key === "Enter") { ev.preventDefault(); if (checkBtn) runTests(); else runFree(false); return; }
      if (ev.key === "Escape") { ta.dataset.free = "1"; return; }
      var s = ta.selectionStart, e = ta.selectionEnd, v = ta.value;
      if (ev.key === "Tab" && !ev.shiftKey && ta.dataset.free !== "1") {
        ev.preventDefault();
        ta.value = v.slice(0, s) + "    " + v.slice(e);
        ta.selectionStart = ta.selectionEnd = s + 4;
        growEditor();
        return;
      }
      if (ev.key === "Tab") { ta.dataset.free = ""; return; }
      if (ev.key === "Enter" && s === e && !ev.shiftKey) {
        var ls = v.lastIndexOf("\n", s - 1) + 1, line = v.slice(ls, s);
        var ind = /^[ ]*/.exec(line)[0];
        if (/:\s*$/.test(line)) ind += "    ";
        ev.preventDefault();
        ta.value = v.slice(0, s) + "\n" + ind + v.slice(e);
        ta.selectionStart = ta.selectionEnd = s + 1 + ind.length;
        growEditor();
      }
    });
    ta.addEventListener("blur", function () { ta.dataset.free = ""; });

    if (!supported) { setStatus("הדפדפן שלך לא מאפשר להריץ כאן פייתון. אפשר להריץ את הקוד בעורך שלך (למשל VS Code).", "err"); runBtn.disabled = true; if (checkBtn) checkBtn.disabled = true; }
    if (c.prewarm !== false) prewarmWhenVisible(box);

    return {
      getCode: mainCode,
      getFiles: function () { syncCur(); return files.map(function (f) { return { name: f.name, code: f.code }; }); },
      setTests: function (t) { tests = t || []; },
      setCode: function (code) { files[0].code = code; files[0].start = code; if (cur === 0) ta.value = code; clearOutput(); growEditor(); },
      run: function () { token++; busy = false; runFree(false); },
      check: runTests,
      hasRun: function () { return userStarted; }
    };
  }

  window.pyxRunner = { exec: execCode, mountCode: mountCode, run: run, stop: stop, retry: retry, prewarm: prewarm, prewarmWhenVisible: prewarmWhenVisible, status: status, mount: mount, onStatus: function (cb) { listeners.push(cb); }, configure: function (o) { for (var k in o) opts[k] = o[k]; } };
}

export const PYX_RUNNER_SCRIPT =
  "<script>" + NAME_SHIM + "(" +
  // הקוד המכווץ של הבנייה לפרודקשן מאחד את "<" + "/script>" למחרוזת אחת "</script>", וזה היה סוגר את תג ה-script של השיעור באמצע.
  // לכן מבריחים כל "</script" בטקסט הפונקציה (בתוך מחרוזת JS, "<\/script>" שווה בדיוק ל-"</script>").
  pyxHost.toString().replace(/<\/script/gi, "<\\/script") +
  ")(" +
  JSON.stringify({
    base: BASE,
    csp: CSP,
    harness: HARNESS,
    css: CODE_CSS,
    worker: NAME_SHIM + "(" + pyxWorker.toString() + ")();",
    bridge: pyxBridge.toString()
  }).replace(/<\//g, "<\\/") +
  ");</script>";
