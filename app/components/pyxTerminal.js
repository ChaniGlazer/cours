// app/components/pyxTerminal.js
//
// טרמינל אמיתי בדפדפן, לשיעורי ה-HTML: פייתון אמיתי (Pyodide, אותה גרסה כמו ב-pyxRunner.js), קבצים אמיתיים במערכת קבצים וירטואלית,
// פקודות python / pip / ls / cat וכו'. `pip install` מוריד חבילות אמיתיות מ-PyPI (דרך micropip), ולכן מתקינים רק חבילות פייתון טהורות או כאלה
// ש-Pyodide מכיר (למשל pandas, rich). חבילה שאין לה גרסה מתאימה מחזירה שגיאה אמיתית.
//
// מוזרק ל-iframe של השיעור על ידי LessonHtmlFrame רק בשיעורים שמשתמשים בו (הטקסט "pyxTerminal" בתוך ה-HTML), והשיעור קורא
// ל-window.pyxTerminal.mount({ el, files, suggest, hint, onEvent }). ראו lessons/lesson10_modules_more.html.
//
// ארכיטקטורה (כמו pyxRunner.js, אבל worker יחיד שנשאר חי כדי שהתקנות וקבצים יישמרו בין פקודות):
//  - iframe פנימי (sandbox עם allow-scripts בלבד) עם CSP שמתיר חיבורים רק ל-cdn.jsdelivr.net (Pyodide וחבילותיו), pypi.org ו-files.pythonhosted.org (pip).
//    ה-Worker נוצר מ-Blob בתוכו ויורש את ה-CSP, ולכן הדפדפן חוסם כל גישה אחרת לרשת, גם מקוד התלמידה.
//  - ריצה שנמשכת יותר מדי נהרגת (הסרת ה-iframe), והסביבה נבנית מחדש בפקודה הבאה (חבילות שהותקנו נמחקות, הקבצים נשמרים).
//  - input() אמיתי בלי חסימה: כשהתוכנית מבקשת קלט, הטרמינל שואל את התלמידה ומריץ שוב מההתחלה עם התשובות (ה-seed של random קבוע).
//
// כל הפונקציות כאן מוזרקות כטקסט (toString), ולכן כל אחת עצמאית: בלי התייחסות למשתנים מחוץ לה (הנתונים עוברים כארגומנט).

const BASE = "https://cdn.jsdelivr.net/pyodide/v0.29.5/full/";
const CSP =
  "default-src 'none'; script-src 'unsafe-inline' 'unsafe-eval' 'wasm-unsafe-eval' blob: https://cdn.jsdelivr.net; worker-src blob:; " +
  "connect-src https://cdn.jsdelivr.net https://pypi.org https://files.pythonhosted.org";

// ראו הסבר ב-pyxRunner.js: בבניית השרת נוספות קריאות __name(...) שאינן קיימות בתוך ה-iframe.
const NAME_SHIM = "var __name=function(t){return t};";

// פייתון (raw: בלי בריחה של לוכסנים). מנגנון הפקודות בצד הפייתון: הרצת קובץ, ו-pip (מעל micropip).
const TERM_HARNESS = String.raw`
import sys, io, os, json, builtins, importlib, traceback, random, re

class _NeedInput(BaseException):
    pass

_written = set()

def _sync_files(files):
    cwd = os.getcwd()
    if cwd not in sys.path:
        sys.path.insert(0, cwd)
    for n in list(_written):
        if n not in files:
            try:
                os.remove(n)
            except OSError:
                pass
            _written.discard(n)
    for n, code in files.items():
        with open(n, "w", encoding="utf-8") as fh:
            fh.write(code)
        _written.add(n)

def _purge_user_modules():
    cwd = os.getcwd()
    for n in list(sys.modules):
        f = getattr(sys.modules.get(n), "__file__", None)
        try:
            if f and os.path.dirname(os.path.abspath(f)) == cwd:
                sys.modules.pop(n, None)
        except Exception:
            pass

def term_run(req_json):
    req = json.loads(req_json)
    _sync_files(req.get("files", {}))
    buf = io.StringIO()
    real = (sys.stdout, sys.stderr, builtins.input)
    inputs = req.get("inputs", [])
    pos = [0]
    state = {"need": None}
    def fake_input(prompt=""):
        buf.write(str(prompt))
        if pos[0] < len(inputs):
            v = inputs[pos[0]]
            pos[0] += 1
            buf.write(v + "\n")
            return v
        state["need"] = str(prompt)
        raise _NeedInput()
    res = {"need": None, "exit": 0}
    sys.stdout = sys.stderr = buf
    builtins.input = fake_input
    try:
        code = req.get("code")
        name = req.get("name") or "<string>"
        src = None
        if code is not None:
            src = code
        else:
            try:
                with open(name, encoding="utf-8") as fh:
                    src = fh.read()
            except OSError:
                buf.write("python: can't open file '%s': [Errno 2] No such file or directory\n" % name)
                res["exit"] = 2
        if src is not None:
            random.seed(req.get("seed", 1))
            importlib.invalidate_caches()
            try:
                exec(compile(src, name, "exec"), {"__name__": "__main__", "__file__": name})
            except _NeedInput:
                res["need"] = state["need"]
            except SystemExit as e:
                c = e.code
                res["exit"] = c if isinstance(c, int) else (0 if c is None else 1)
            except BaseException as e:
                tb = e.__traceback__.tb_next if e.__traceback__ else None
                buf.write("".join(traceback.format_exception(type(e), e, tb)))
                res["exit"] = 1
    finally:
        sys.stdout, sys.stderr, builtins.input = real
        _purge_user_modules()
    res["out"] = buf.getvalue()[:30000]
    return json.dumps(res, ensure_ascii=False)

_SPEC = re.compile(r"^[A-Za-z0-9][A-Za-z0-9._-]*(\[[A-Za-z0-9,._-]+\])?([<>=!~]=?[A-Za-z0-9.*+!_-]+(,[<>=!~]=?[A-Za-z0-9.*+!_-]+)*)?$")

def _norm(n):
    return re.sub(r"[-_.]+", "-", n).lower()

async def term_pip(args_json):
    import micropip
    args = json.loads(args_json)
    out = []
    rc = 0
    done = []
    def installed():
        return dict((_norm(k), v.version) for k, v in micropip.list().items())
    sub = args[0] if args else ""
    rest = args[1:]
    flags = [a for a in rest if a.startswith("-")]
    pk = [a for a in rest if not a.startswith("-")]
    if sub == "install":
        if not pk:
            out.append('ERROR: You must give at least one requirement to install (see "pip help install")')
            rc = 1
        for spec in pk:
            if not _SPEC.match(spec):
                out.append("ERROR: Invalid requirement: '%s' (כאן מתקינים לפי שם חבילה מ-PyPI)" % spec)
                rc = 1
                continue
            base = _norm(re.split(r"[\[<>=!~]", spec)[0])
            have = installed()
            pinned = re.search(r"[<>=!~]", spec) is not None
            if base in have and not pinned and "-U" not in flags and "--upgrade" not in flags:
                out.append("Requirement already satisfied: %s (%s)" % (base, have[base]))
                continue
            out.append("Collecting " + spec)
            before = installed()
            try:
                await micropip.install(spec)
            except ValueError as e:
                msg = str(e)
                if "Can't fetch metadata" in msg:
                    out.append("ERROR: Could not find a version that satisfies the requirement %s (from versions: none)" % spec)
                    out.append("ERROR: No matching distribution found for %s" % base)
                elif "pure Python 3 wheel" in msg or "wheel" in msg:
                    out.append("ERROR: " + msg)
                    out.append("(בדפדפן אפשר להתקין רק חבילות פייתון טהורות או כאלה ש-Pyodide מכיר.)")
                else:
                    out.append("ERROR: " + msg)
                rc = 1
                continue
            except BaseException as e:
                out.append("ERROR: %s: %s" % (type(e).__name__, e))
                out.append("(בדקי את החיבור לרשת ונסי שוב.)")
                rc = 1
                continue
            after = installed()
            new = ["%s-%s" % (k, v) for k, v in after.items() if before.get(k) != v]
            if new:
                out.append("Installing collected packages: " + ", ".join(n.rsplit("-", 1)[0] for n in new))
                out.append("Successfully installed " + " ".join(new))
                done.extend(k for k in after if before.get(k) != after[k])
            else:
                out.append("Requirement already satisfied: " + base)
    elif sub == "uninstall":
        for name in [p for p in pk]:
            n = _norm(name)
            have = installed()
            if n not in have:
                out.append("WARNING: Skipping %s as it is not installed." % name)
                continue
            try:
                micropip.uninstall(n)
                out.append("Found existing installation: %s %s" % (n, have[n]))
                out.append("Successfully uninstalled %s-%s" % (n, have[n]))
            except BaseException as e:
                out.append("ERROR: %s" % e)
                rc = 1
    elif sub == "list":
        rows = sorted(installed().items())
        w = max([len("Package")] + [len(k) for k, _ in rows])
        out.append("Package".ljust(w) + " Version")
        out.append("-" * w + " -------")
        for k, v in rows:
            out.append(k.ljust(w) + " " + v)
    elif sub in ("--version", "-V", "version"):
        out.append("micropip " + micropip.__version__ + " (המקבילה של pip בדפדפן, Python " + sys.version.split()[0] + ")")
    elif sub in ("", "help", "-h", "--help"):
        out.append("Usage: pip <command> [package ...]")
        out.append("Commands: install, uninstall, list")
    else:
        out.append('ERROR: unknown command "%s"' % sub)
        rc = 1
    return json.dumps({"out": "\n".join(out) + "\n", "exit": rc, "installed": done}, ensure_ascii=False)
`;

const TERM_CSS = [
  ".pyt{margin-top:14px;direction:ltr;text-align:left}",
  ".pyt-tabs{display:flex;flex-wrap:wrap;gap:6px;margin-bottom:-1px}",
  ".pyt-tabs[hidden]{display:none}",
  ".pyt-tab{font:600 13px var(--mono,monospace);padding:6px 14px;border-radius:8px 8px 0 0;border:1px solid rgba(255,255,255,.18);border-bottom:0;background:transparent;color:#bdb7d3;cursor:pointer}",
  ".pyt-tab.on{background:#171431;color:#f5f3ff}",
  ".pyt-ed{display:block;width:100%;box-sizing:border-box;direction:ltr;text-align:left;font:500 14.5px/1.7 var(--mono,'JetBrains Mono',monospace);tab-size:4;white-space:pre;overflow:auto;resize:vertical;background:#171431;color:#f5f3ff;border:1px solid rgba(255,255,255,.18);border-radius:0 12px 12px 12px;padding:12px 14px;min-height:96px}",
  ".pyt-ed:focus{outline:2px solid var(--for,#ffd27a);outline-offset:1px}",
  ".pyt-hint{margin-top:8px;font:14px var(--sans,inherit);direction:rtl;text-align:right;color:var(--ink-dim,#bdb7d3)}",
  ".pyt-screen{margin-top:12px;background:#0c0a1c;color:#e9e6ff;border:1px solid rgba(255,255,255,.18);border-radius:12px;padding:12px 16px;font:500 14px/1.65 var(--mono,'JetBrains Mono',monospace);min-height:150px;max-height:340px;overflow:auto;cursor:text}",
  ".pyt-screen:before{content:'טרמינל';display:block;font:700 11px var(--sans,inherit);letter-spacing:.06em;color:#8b86b8;margin-bottom:4px;direction:rtl;text-align:right}",
  ".pyt-line{white-space:pre-wrap;word-break:break-word;margin:0;unicode-bidi:plaintext}",
  ".pyt-cmdline{color:#ffd27a}",
  ".pyt-dim{color:#8b86b8}",
  ".pyt-bad{color:#ff8a8a}",
  ".pyt-good{color:#6fe0a0}",
  ".pyt-row{display:flex;gap:8px;align-items:center}",
  ".pyt-ps{color:#6fe0a0;font-weight:700;flex:none}",
  ".pyt-cmd,.pyt-in{font:inherit;background:transparent;color:#ffd27a;border:0;outline:none;padding:0;caret-color:#ffd27a;direction:ltr;text-align:left}",
  ".pyt-cmd{flex:1;min-width:0;width:100%}",
  ".pyt-in{border-bottom:1px solid #ffd27a;min-width:12ch}",
  ".pyt-bar{display:flex;flex-wrap:wrap;gap:8px;align-items:center;margin-top:10px;direction:rtl}",
  ".pyt-chip{font:600 13px var(--mono,monospace);direction:ltr;padding:7px 13px;border-radius:100px;border:1px solid rgba(255,255,255,.22);background:rgba(255,255,255,.06);color:#e9e6ff;cursor:pointer}",
  ".pyt-chip:hover{border-color:#bdb7d3}",
  ".pyt-chip.reset{font-family:var(--sans,inherit);border-style:dashed;background:transparent;color:#9e97ba}"
].join("");

// ---- רץ בתוך ה-Web Worker ----
function termWorker() {
  var py = null;
  self.onmessage = async function (e) {
    var d = e.data;
    try {
      if (d.type === "boot") {
        importScripts(d.base + "pyodide.js");
        py = await loadPyodide({ indexURL: d.base });
        await py.loadPackage("micropip");
        py.runPython(d.harness);
        self.postMessage({ type: "ready" });
      } else if (d.type === "req") {
        py.globals.set("PYT_REQ", d.payload);
        var json = d.kind === "pip"
          ? await py.runPythonAsync("await term_pip(PYT_REQ)")
          : py.runPython("term_run(PYT_REQ)");
        self.postMessage({ type: "res", id: d.id, json: json });
      }
    } catch (err) {
      self.postMessage({ type: "fatal", id: d && d.id, message: String((err && err.message) || err) });
    }
  };
}

// ---- רץ בתוך ה-iframe הפנימי (עם ה-CSP): יוצר את ה-Worker מ-Blob ומעביר הודעות ----
function termBridge() {
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
    } else if (d.type === "req" && worker) {
      worker.postMessage(d);
    }
  });
  post({ type: "alive" });
}

// ---- רץ ב-iframe של השיעור: הממשק, ניתוח הפקודות וניהול ה-Worker ----
function termHost(cfg) {
  "use strict";
  var supported = typeof Worker !== "undefined" && typeof WebAssembly !== "undefined" && typeof Blob !== "undefined" &&
    typeof URL !== "undefined" && typeof URL.createObjectURL === "function";
  var RUN_MS = 10000, PIP_MS = 180000, BOOT_MS = 120000;
  var cssDone = false;

  function injectCss() {
    if (cssDone) return;
    cssDone = true;
    var st = document.createElement("style");
    st.textContent = cfg.css;
    document.head.appendChild(st);
  }
  function mk(tag, cls, text) {
    var el = document.createElement(tag);
    if (cls) el.className = cls;
    if (text != null) el.textContent = text;
    return el;
  }

  // מנתח שורת פקודה לאסימונים, עם מירכאות כפולות/בודדות.
  function tokenize(line) {
    var out = [], cur = "", q = null, has = false;
    for (var i = 0; i < line.length; i++) {
      var ch = line[i];
      if (ch === "\\" && (q === '"' ? '"\\'.indexOf(line[i + 1]) >= 0 : !q && i + 1 < line.length)) { cur += line[i + 1]; i++; has = true; }
      else if (q) {
        if (ch === q) q = null; else cur += ch;
      } else if (ch === '"' || ch === "'") { q = ch; has = true; }
      else if (/\s/.test(ch)) { if (cur || has) { out.push(cur); cur = ""; has = false; } }
      else cur += ch;
    }
    if (cur || has) out.push(cur);
    return out;
  }
  var FILE_RE = /^[A-Za-z_][A-Za-z0-9_.-]{0,39}$/;

  function mount(c) {
    injectCss();
    var host = typeof c.el === "string" ? document.getElementById(c.el) : c.el;
    if (!host) return null;
    var files = (c.files || [{ name: "main.py", code: "" }]).map(function (f) { return { name: f.name, code: f.code, start: f.code }; });
    var cur = 0;
    var root = mk("div", "pyt");
    var tabs = mk("div", "pyt-tabs");
    var ta = mk("textarea", "pyt-ed");
    ta.spellcheck = false;
    ta.setAttribute("aria-label", "עורך קבצים");
    var hint = mk("div", "pyt-hint", c.hint || "");
    var screen = mk("div", "pyt-screen");
    screen.setAttribute("role", "log");
    screen.setAttribute("aria-live", "polite");
    var rowEl = mk("div", "pyt-row");
    var ps = mk("span", "pyt-ps", "$");
    var inp = mk("input", "pyt-cmd");
    inp.type = "text";
    inp.autocomplete = "off";
    inp.spellcheck = false;
    inp.setAttribute("aria-label", "שורת פקודה");
    rowEl.appendChild(ps);
    rowEl.appendChild(inp);
    screen.appendChild(rowEl);
    var bar = mk("div", "pyt-bar");
    root.appendChild(tabs);
    root.appendChild(ta);
    if (c.hint) root.appendChild(hint);
    root.appendChild(screen);
    root.appendChild(bar);
    host.appendChild(root);

    function emit(ev) { if (c.onEvent) { try { c.onEvent(ev); } catch (e) {} } }
    function line(text, cls) {
      var l = mk("div", "pyt-line" + (cls ? " " + cls : ""), text);
      screen.insertBefore(l, rowEl);
      screen.scrollTop = screen.scrollHeight;
      return l;
    }
    function clearScreen() {
      while (screen.firstChild !== rowEl) screen.removeChild(screen.firstChild);
    }

    // ---- קבצים ----
    function syncCur() { if (files[cur]) files[cur].code = ta.value; }
    function filesMap() {
      syncCur();
      var m = {};
      files.forEach(function (f) { m[f.name] = f.code; });
      return m;
    }
    function drawTabs() {
      tabs.innerHTML = "";
      files.forEach(function (f, i) {
        var b = mk("button", "pyt-tab" + (i === cur ? " on" : ""), f.name);
        b.type = "button";
        b.addEventListener("click", function () { syncCur(); cur = i; ta.value = files[cur].code; drawTabs(); grow(); });
        tabs.appendChild(b);
      });
      tabs.hidden = files.length < 2;
    }
    function grow() {
      var n = ta.value.split("\n").length;
      ta.rows = Math.max(5, Math.min(14, n + 1));
    }
    ta.addEventListener("input", grow);
    ta.addEventListener("keydown", function (e) {
      if (e.key === "Tab" && !e.shiftKey) {
        e.preventDefault();
        var s = ta.selectionStart, en = ta.selectionEnd;
        ta.value = ta.value.slice(0, s) + "    " + ta.value.slice(en);
        ta.selectionStart = ta.selectionEnd = s + 4;
        grow();
      }
    });
    function showFile(i) { cur = Math.max(0, Math.min(files.length - 1, i)); ta.value = files[cur] ? files[cur].code : ""; ta.disabled = !files.length; drawTabs(); grow(); }
    showFile(0);

    // ---- ה-Worker ----
    var slot = null, booting = null, waiters = {}, nextId = 1, queue = Promise.resolve();
    function kill() {
      if (slot && slot.off) slot.off();
      if (slot && slot.frame) slot.frame.remove();
      slot = null;
      booting = null;
      var w = waiters;
      waiters = {};
      Object.keys(w).forEach(function (k) { w[k].reject({ reason: "killed" }); });
    }
    function boot() {
      if (booting) return booting;
      if (!supported) return Promise.reject({ reason: "unsupported" });
      booting = new Promise(function (resolve, reject) {
        var f = document.createElement("iframe");
        f.setAttribute("sandbox", "allow-scripts");
        f.setAttribute("aria-hidden", "true");
        f.tabIndex = -1;
        f.title = "מפעיל הטרמינל (מוסתר)";
        f.style.cssText = "display:none;width:0;height:0;border:0";
        f.srcdoc = '<!doctype html><meta http-equiv="Content-Security-Policy" content="' + cfg.csp + '"><script>var __name=function(t){return t};(' + cfg.bridge + ")();<" + "/script>";
        var s = { frame: f, ready: false };
        slot = s;
        var timer = setTimeout(function () { if (slot === s) { kill(); reject({ reason: "boot-timeout" }); } }, BOOT_MS);
        function onMsg(e) {
          if (!s.frame || e.source !== s.frame.contentWindow) return;
          var d = e.data || {};
          if (d.type === "alive") {
            s.frame.contentWindow.postMessage({ type: "boot", workerSrc: cfg.worker, harness: cfg.harness, base: cfg.base }, "*");
          } else if (d.type === "ready") {
            s.ready = true;
            clearTimeout(timer);
            resolve(s);
          } else if (d.type === "res") {
            var w = waiters[d.id];
            if (w) { delete waiters[d.id]; w.resolve(JSON.parse(d.json)); }
          } else if (d.type === "fatal") {
            if (!s.ready) { clearTimeout(timer); window.removeEventListener("message", onMsg); if (slot === s) kill(); reject({ reason: /^worker:/.test(d.message || "") ? "unsupported" : "network", message: d.message }); }
            else if (d.id && waiters[d.id]) { var w2 = waiters[d.id]; delete waiters[d.id]; w2.reject({ reason: "error", message: d.message }); }
          }
        }
        window.addEventListener("message", onMsg);
        s.off = function () { window.removeEventListener("message", onMsg); };
        document.body.appendChild(f);
      });
      booting.catch(function () {});
      return booting;
    }
    var bootNote = null;
    function ensureReady() {
      if (slot && slot.ready) return Promise.resolve(slot);
      var fresh = !booting;
      if (fresh) bootNote = line("⏳ טוענים את פייתון (קורה פעם אחת, עד חצי דקה)...", "pyt-dim");
      return boot().then(function (s) {
        if (bootNote) { bootNote.remove(); bootNote = null; }
        return s;
      }, function (err) {
        if (bootNote) { bootNote.remove(); bootNote = null; }
        throw err;
      });
    }
    // שולח בקשה ל-Worker (בתור: אחת בכל פעם) עם timeout; ב-timeout הסביבה נהרגת.
    function send(kind, payload, ms) {
      var job = queue.then(function () {
        return ensureReady().then(function (s) {
          return new Promise(function (resolve, reject) {
            var id = nextId++;
            var t = setTimeout(function () { delete waiters[id]; kill(); reject({ reason: "timeout" }); }, ms);
            waiters[id] = {
              resolve: function (v) { clearTimeout(t); resolve(v); },
              reject: function (v) { clearTimeout(t); reject(v); }
            };
            s.frame.contentWindow.postMessage({ type: "req", id: id, kind: kind, payload: JSON.stringify(payload) }, "*");
          });
        });
      });
      queue = job.then(function () {}, function () {});
      return job;
    }
    function explain(err) {
      if (err.reason === "timeout") return "⏱ הפקודה ארכה יותר מדי ונעצרה (אולי לולאה אינסופית?). הסביבה אותחלה: חבילות שהותקנו נמחקו, הקבצים נשארו.";
      if (err.reason === "unsupported") return "הדפדפן הזה לא תומך בטרמינל (Web Worker / WebAssembly). אפשר לנסות דפדפן אחר.";
      if (err.reason === "killed") return "הסביבה אותחלה.";
      return "לא הצלחנו לטעון את פייתון (בדקי את החיבור לרשת ונסי שוב)." + (err.message ? " (" + err.message + ")" : "");
    }

    // ---- פקודות ----
    var busy = false;
    function printOut(text, cls) {
      text.replace(/\n$/, "").split("\n").forEach(function (l, i, a) { if (!(a.length === 1 && l === "")) line(l, cls); });
    }
    function askInput(block) {
      return new Promise(function (resolve) {
        var i = mk("input", "pyt-in");
        i.type = "text";
        i.autocomplete = "off";
        i.setAttribute("aria-label", "קלט לתוכנית");
        block.appendChild(i);
        i.focus();
        i.addEventListener("keydown", function (e) {
          if (e.key !== "Enter") return;
          e.preventDefault();
          var v = i.value;
          i.remove();
          resolve(v);
        });
        screen.scrollTop = screen.scrollHeight;
      });
    }
    function runPython(req) {
      var seed = Math.floor(Math.random() * 1e9) + 1, inputs = [];
      var block = mk("div", "pyt-line");
      screen.insertBefore(block, rowEl);
      function once() {
        var payload = { files: filesMap(), name: req.name, code: req.code, inputs: inputs, seed: seed };
        return send("run", payload, RUN_MS).then(function (res) {
          block.textContent = res.out.replace(/\n$/, "");
          if (res.need !== null && res.need !== undefined) {
            return askInput(block).then(function (ans) { inputs.push(ans); return once(); });
          }
          if (!res.out) block.remove();
          return res;
        });
      }
      return once().then(function (res) {
        emit({ type: "run", name: req.name || "-c", exit: res.exit, out: res.out });
        return res.exit;
      }, function (err) {
        if (!block.textContent) block.remove();
        throw err;
      });
    }
    function runPip(args) {
      return send("pip", args, PIP_MS).then(function (res) {
        printOut(res.out, res.exit ? "pyt-bad" : "");
        if (args[0] === "install") emit({ type: "pip-install", ok: !res.exit, packages: res.installed || [], args: args });
        return res.exit;
      });
    }
    function help() {
      [
        "פקודות שעובדות כאן:",
        "  python main.py        מריץ קובץ (python -c \"print(1+1)\" מריץ קוד ישירות)",
        "  pip install <שם>      מתקין חבילה אמיתית מ-PyPI (גם: pip list, pip uninstall <שם>)",
        "  ls, cat <קובץ>        רשימת הקבצים ותוכן קובץ",
        "  touch <קובץ>, rm <קובץ>   יוצר או מוחק קובץ",
        "  echo, pwd, clear, help"
      ].forEach(function (t) { line(t, "pyt-dim"); });
    }
    function exec(text) {
      var args = tokenize(text);
      if (!args.length) return Promise.resolve(0);
      var cmd = args[0];
      if (cmd === "clear") { clearScreen(); return Promise.resolve(0); }
      if (cmd === "help") { help(); return Promise.resolve(0); }
      if (cmd === "pwd") { line("/home/pyodide"); return Promise.resolve(0); }
      if (cmd === "echo") { line(args.slice(1).join(" ")); return Promise.resolve(0); }
      if (cmd === "ls") { syncCur(); line(files.map(function (f) { return f.name; }).sort().join("  ")); return Promise.resolve(0); }
      if (cmd === "cat") {
        syncCur();
        if (!args[1]) { line("cat: חסר שם קובץ", "pyt-bad"); return Promise.resolve(1); }
        var f = files.filter(function (x) { return x.name === args[1]; })[0];
        if (!f) { line("cat: " + args[1] + ": No such file or directory", "pyt-bad"); return Promise.resolve(1); }
        printOut(f.code || "");
        return Promise.resolve(0);
      }
      if (cmd === "touch") {
        if (!args[1] || !FILE_RE.test(args[1])) { line("touch: שם קובץ לא תקין (אותיות, ספרות, _ . -)", "pyt-bad"); return Promise.resolve(1); }
        if (!files.some(function (x) { return x.name === args[1]; })) {
          if (files.length >= 12) { line("touch: יותר מדי קבצים", "pyt-bad"); return Promise.resolve(1); }
          syncCur();
          files.push({ name: args[1], code: "", start: "" });
          showFile(files.length - 1);
        }
        return Promise.resolve(0);
      }
      if (cmd === "rm") {
        syncCur();
        var idx = -1;
        files.forEach(function (x, i) { if (x.name === args[1]) idx = i; });
        if (idx < 0) { line("rm: cannot remove '" + (args[1] || "") + "': No such file or directory", "pyt-bad"); return Promise.resolve(1); }
        files.splice(idx, 1);
        showFile(Math.min(cur, files.length - 1));
        return Promise.resolve(0);
      }
      if (cmd === "cd") { line("cd: כאן יש תיקייה אחת בלבד", "pyt-dim"); return Promise.resolve(0); }
      if (cmd === "pip" || cmd === "pip3") return runPip(args.slice(1));
      if (cmd === "python" || cmd === "python3" || cmd === "py") {
        var a = args.slice(1);
        if (!a.length) { line("אין כאן מצב אינטראקטיבי. הריצי קובץ: python main.py, או קוד ישיר: python -c \"print(1+1)\"", "pyt-dim"); return Promise.resolve(0); }
        if (a[0] === "-m" && a[1] === "pip") return runPip(a.slice(2));
        if (a[0] === "-c") return runPython({ code: a[1] || "", name: "<string>" });
        if (a[0] === "--version" || a[0] === "-V") return runPython({ code: "import sys; print('Python', sys.version.split()[0])", name: "<string>" });
        return runPython({ name: a[0] });
      }
      line("bash: " + cmd + ": command not found", "pyt-bad");
      return Promise.resolve(127);
    }

    var history = [], hpos = 0;
    function submit(text) {
      if (busy) return;
      busy = true;
      inp.disabled = true;
      var cl = mk("div", "pyt-line pyt-cmdline");
      cl.textContent = "$ " + text;
      screen.insertBefore(cl, rowEl);
      if (text.trim()) { history.push(text); }
      hpos = history.length;
      var p;
      try { p = exec(text); } catch (e) { p = Promise.reject({ reason: "error", message: String(e) }); }
      p.then(function (code) { emit({ type: "command", line: text, exit: code }); }, function (err) { line(explain(err), "pyt-bad"); })
        .then(function () {
          busy = false;
          inp.disabled = false;
          inp.value = "";
          inp.focus();
          screen.scrollTop = screen.scrollHeight;
        });
    }
    inp.addEventListener("keydown", function (e) {
      if (e.key === "Enter") { e.preventDefault(); submit(inp.value); }
      else if (e.key === "ArrowUp" && history.length) { e.preventDefault(); hpos = Math.max(0, hpos - 1); inp.value = history[hpos]; }
      else if (e.key === "ArrowDown" && history.length) { e.preventDefault(); hpos = Math.min(history.length, hpos + 1); inp.value = history[hpos] || ""; }
    });
    screen.addEventListener("click", function (e) { if (!window.getSelection || String(window.getSelection()) === "") inp.focus(); });

    (c.suggest || []).forEach(function (s) {
      var b = mk("button", "pyt-chip", s);
      b.type = "button";
      b.addEventListener("click", function () { if (busy) return; inp.value = s; inp.focus(); });
      bar.appendChild(b);
    });
    var rb = mk("button", "pyt-chip reset", "אפסי את הטרמינל");
    rb.type = "button";
    function reset() {
      kill();
      files = (c.files || []).map(function (f) { return { name: f.name, code: f.start != null ? f.start : f.code, start: f.code }; });
      files.forEach(function (f) { f.code = f.start; });
      clearScreen();
      showFile(0);
      busy = false;
      inp.disabled = false;
      inp.value = "";
      welcome();
      emit({ type: "reset" });
    }
    rb.addEventListener("click", reset);
    bar.appendChild(rb);

    function welcome() {
      line(c.welcome || "טרמינל אמיתי: פייתון אמיתי ו-pip שמתקין מ-PyPI. כתבי help כדי לראות את הפקודות.", "pyt-dim");
    }
    welcome();

    // טעינה מוקדמת כשהטרמינל נכנס לתצוגה, כדי שהפקודה הראשונה לא תחכה
    if (supported && typeof IntersectionObserver !== "undefined" && c.prewarm !== false) {
      var io = new IntersectionObserver(function (es) {
        es.forEach(function (en) {
          if (en.isIntersecting) { io.disconnect(); setTimeout(function () { boot(); }, 300); }
        });
      }, { rootMargin: "300px" });
      io.observe(root);
    }

    return {
      run: submit,
      getFiles: function () { return files.map(function (f) { syncCur(); return { name: f.name, code: f.code }; }); },
      reset: reset,
      focus: function () { inp.focus(); }
    };
  }

  window.pyxTerminal = { mount: mount, supported: supported };
}

export const PYX_TERMINAL_SCRIPT =
  "<script>" + NAME_SHIM + "(" +
  // ראו ההסבר ב-pyxRunner.js: "</script" בתוך טקסט הפונקציה היה סוגר את תג ה-script של השיעור.
  termHost.toString().replace(/<\/script/gi, "<\\/script") +
  ")(" +
  JSON.stringify({
    base: BASE,
    csp: CSP,
    harness: TERM_HARNESS,
    css: TERM_CSS,
    worker: NAME_SHIM + "(" + termWorker.toString() + ")();",
    bridge: termBridge.toString()
  }).replace(/<\//g, "<\\/") +
  ");</script>";
