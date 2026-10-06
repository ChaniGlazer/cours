# אתר מכירת קורס – מדריך הפעלה

אתר מוכן להרצה שמאפשר למכור קורס וידאו יחיד: הרשמה, תשלום מאובטח דרך
**Invoice4U (Clearing API)**, וגישה לתוכן רק למי שנרשם ושילם בפועל. כולל גם עמוד ניהול
(`/admin`) לעריכת שם הקורס, המחיר, התיאור והשיעורים - בלי לגעת בקוד.

## מה בנוי כאן

- **Next.js 16** (App Router) + **React 19** - קוד אחד גם לדפים וגם לשרת.
- **אחסון**: [Cloudflare Workers](https://workers.cloudflare.com/) (דרך
  [OpenNext](https://opennext.js.org/cloudflare)), בלי שרת/דיסק לנהל.
- **מסד נתונים**: [Cloudflare D1](https://developers.cloudflare.com/d1/) - SQLite
  serverless מנוהל על ידי Cloudflare (ראו `migrations/0001_init.sql` למבנה הטבלאות).
- **הרשמה והתחברות**: סיסמאות מוצפנות (`bcrypt`), session מאובטח ב-cookie
  שמאוחסן במסד הנתונים (לא JWT) - כך שתמיד אפשר "להתנתק" משתמש מסוים אם צריך.
- **תשלום**: אינטגרציה עם ה-Clearing API של Invoice4U - פתיחת בקשת סליקה
  (iframe מאובטח), ובדיקת סטטוס פעילה בעמוד ההצלחה (Invoice4U לא שולח
  webhook לעסקאות רגילות, אז האתר שואל אותו ישירות מה קרה עם התשלום).
- **מייל**: [Resend](https://resend.com) (REST API) - לשליחת מייל איפוס סיסמה.
- **עמוד ניהול** (`/admin`, מוגן בסיסמה אחת מסביבת השרת): עריכת כל תוכן הקורס
  והשיעורים.

## הרצה מקומית (לבדיקות)

```bash
cp .env.example .env
# ערכו את .env: לפחות SITE_URL ו-ADMIN_PASSWORD
npm install

# יצירת מסד D1 מקומי (קובץ SQLite זמני שמנהל wrangler) והרצת ה-migration
npm run db:migrate:local

npm run dev
```

האתר יעלה בכתובת `http://localhost:3000`. כנסו ל-`/admin` עם הסיסמה
שהגדרתם ב-`ADMIN_PASSWORD` כדי לערוך את תוכן הקורס.

> בלי מפתח API של Invoice4U (`INVOICE4U_API_KEY`) שלב התשלום בפועל יחזיר
> הודעת שגיאה ברורה ויפנה את המשתמש לעמוד "התשלום בוטל" - זה תקין ומכוון,
> ככה תוכלו לבדוק את כל שאר האתר לפני שמחברים תשלומים אמיתיים.

## משתני סביבה (קובץ `.env`)

| משתנה | הסבר |
|---|---|
| `SITE_URL` | כתובת האתר בפועל, **בלי** `/` בסוף. חשוב לעדכן כשעוברים מ-localhost לדומיין האמיתי. |
| `ADMIN_PASSWORD` | הסיסמה לכניסה ל-`/admin`. בחרו סיסמה חזקה וייחודית - היא היחידה שמגנה על ניהול האתר. |
| `INVOICE4U_API_KEY` | מפתח ה-API של Invoice4U (נוצר ב-private.invoice4u.co.il, ראו בהמשך). |
| `INVOICE4U_CC_COMPANY` | קוד חברת הסליקה שמוגדרת בחשבון שלכם: Meshulam=7, UPay=6, YaadSarig=12, Cardcom=15. |
| `RESEND_API_KEY`, `EMAIL_FROM` | אופציונלי - לשליחת מייל איפוס סיסמה דרך Resend. בלעדיהם, קישור האיפוס יודפס ללוג של השרת בלבד (ראו בהמשך). |

בפריסה בפועל (לא בפיתוח מקומי) יש להגדיר את המשתנים האלה כ-secrets דרך `wrangler
secret put <NAME>` (לא בקובץ `.env`) - ראו "פריסה ל-Cloudflare Workers" בהמשך.

## הגדרת Invoice4U (Clearing API) - שלב חשוב

1. היכנסו לחשבון שלכם ב-`private.invoice4u.co.il`.
2. עברו ל-**הגדרות** (Settings) → **הגדרות חשבון** → לשונית **API**, ולחצו
   **Generate** כדי ליצור מפתח API (GUID).
3. ודאו שחברת הסליקה המוגדרת בחשבון תואמת למה שהגדרתם ב-`INVOICE4U_CC_COMPANY`
   (Meshulam=7, UPay=6, YaadSarig=12, Cardcom=15).
4. הכניסו את המפתח ל-`.env` בתור `INVOICE4U_API_KEY`.
5. בצעו תשלום בדיקה מקצה לקצה: הרשמה → תשלום → מילוי פרטי כרטיס ב-iframe →
   חזרה לאתר → קבלת גישה לקורס. עקבו בלוגים של השרת (`console.log`/
   `console.error` שמודפסים לטרמינל) שהבקשה נפתחה ושבדיקת הסטטוס בעמוד
   ההצלחה אכן זיהתה תשלום מוצלח.

### פרטים שאומתו מול חשבון אמיתי (ולא מופיעים בתיעוד הציבורי)

התיעוד הציבורי של Invoice4U (`invoice4uclearingapis.docs.apiary.io`) לא מדויק
ב-100%. האינטגרציה נבדקה בפועל מול חשבון Invoice4U אמיתי (לא sandbox - אין כזה
מתועד ל-Clearing API), וכמה דברים התבררו רק מהבדיקה הזו:

- כל תגובות ה-API עטופות במעטפת `"d"` (מוסכמת JSON קלאסית של ASMX/WCF) - השדות
  האמיתיים נמצאים תחת `json.d.*`.
- `ProcessApiRequestV2` מזדהה עם `Invoice4UUserApiKey` (כמו בתיעוד), אבל
  `GetClearingLogById` משתמש בפרמטרים `token` ו-`clearingLogId` (לא
  `Invoice4UUserApiKey`/`ClearingLogId`) - זה לא מופיע בתיעוד.
- הפעולה `GetClearingLogByParams` (המתועדת) החזירה תקלת רשת (ECONNRESET) בכל
  ניסיון - כנראה כי `PaymentId` שם מתייחס למספר הפנימי של Invoice4U (מתחיל
  מ-"0" ומתעדכן רק אחרי חיוב מוצלח), לא ל-`OrderIdClientUsage` שלנו. לכן
  משתמשים במקום זאת ב-`GetClearingLogById` עם המזהה המספרי (`I4UClearingLogId`)
  שמוחזר כבר בתגובת `ProcessApiRequestV2` ונשמר בעמודת `clearing_log_id`.
- `IsSuccess` בתגובת `GetClearingLogById` הוא `true` **גם לפני שהתשלום בפועל
  הושלם** - הוא מציין רק שרשומת הסליקה נוצרה בהצלחה, לא שהחיוב אושר. הזיהוי
  בפועל של תשלום מוצלח (בקוד: `interpretClearingLog` ב-`lib/invoice4u.js`)
  מתבסס על `PaymentId` שהופך למספר אמיתי (לא "0"), או `TransactionId`/
  `ClearingConfirmationNumber` שהופכים לא-ריקים.
- בניגוד ל-Grow, ל-Invoice4U **אין webhook** לעסקאות רגילות (`Type=1`) - יש
  כזה רק ל-Standing Orders (הוראות קבע, `StandingOrderCallBackUrl`). לכן אימות
  התשלום נעשה בבדיקה פעילה (`GetClearingLogById`) שקוראת לשרתי Invoice4U בכל
  פעם שהעמוד בודק סטטוס - לא ב"האזנה" פסיבית לאירוע.

כל תגובה (גם כשעדיין לא ברור אם שולם) נשמרת בעמודת `raw_log` בטבלת `payments`,
כדי שיהיה קל לבדוק מול תשלום אמיתי בלי צורך בגישה ללוגים של השרת.

⚠️ **שימו לב לפני כסף אמיתי**: כל בדיקה (גם ניסיון שלא הושלם) יוצרת לקוח
וחשבונית אמיתיים בחשבון Invoice4U (`IsAutoCreateCustomer`/`IsDocCreate`), כי
אין sandbox נפרד. מומלץ לבקש מ-Invoice4U/Cardcom כרטיס בדיקה ייעודי, או לחלופין
לבצע עסקה אמיתית בסכום סמלי ולבצע לה Refund (`Refund: true` ב-API).

## איפוס סיסמה (שכחתי סיסמה)

יש קישור "שכחתם סיסמה?" בעמוד ההתחברות. כשמשתמש מבקש איפוס, האתר שולח
מייל עם קישור חד-פעמי שתקף לשעה. הקישור מאפשר לבחור סיסמה חדשה ומתחבר
אוטומטית לאחר מכן (וגם מבטל סשנים פתוחים אחרים של אותו משתמש, כהגנה).

**בלי הגדרת Resend** - האתר עדיין "עובד", אבל במקום לשלוח מייל, קישור
האיפוס יודפס ללוג השרת (`console.warn`) עם הכתובת שביקשה אותו. זה שימושי
לבדיקות, אבל לאתר חי כדאי להגדיר שליחת מייל אמיתית.

### הגדרת Resend

Cloudflare Workers לא תומך בצורה אמינה בחיבורי SMTP גולמיים, ולכן שליחת המייל
נעשית דרך ה-REST API של [Resend](https://resend.com) (יש חבילת חינם).

1. פתחו חשבון ב-[resend.com](https://resend.com) ואמתו דומיין שלכם (Domains →
   Add Domain, ועדכון רשומות ה-DNS שמבקשים - אם הדומיין כבר מנוהל ב-Cloudflare,
   קל להוסיף אותן שם).
2. ב-**API Keys**, צרו מפתח חדש.
3. הגדירו:
   ```
   RESEND_API_KEY=<המפתח שקיבלתם>
   EMAIL_FROM=noreply@your-domain.co.il
   ```
   (`EMAIL_FROM` חייב להיות מהדומיין שאומת בשלב 1.)

בפריסה בפועל מגדירים את שני אלה כ-secrets (`wrangler secret put`), לא ב-`.env`
- ראו "פריסה ל-Cloudflare Workers" בהמשך.

## וידאו לשיעורים

בעמוד הניהול מדביקים קישור לסרטון - האתר תומך אוטומטית ב:
- **YouTube** (קישור רגיל או `youtu.be`)
- **Vimeo**
- **קובץ וידאו ישיר** (מסתיים ב-`.mp4`/`.webm`)
- כל קישור הטמעה אחר (כ-fallback גנרי)

**המלצה לאבטחת התוכן**: קישור YouTube "לא רשום" (unlisted) נוח, אבל מי
שמקבל את הקישור הישיר יכול לצפות גם בלי להתחבר לאתר. אם חשוב לכם שהווידאו
יהיה נגיש רק מתוך האתר שלכם, **Vimeo** מאפשר הגדרת "domain-level privacy"
שמגבילה הטמעה רק לדומיין שלכם.

## פריסה ל-Cloudflare Workers

האתר בנוי לרוץ על [Cloudflare Workers](https://workers.cloudflare.com/) - אין
שרת לנהל ואין צורך בדיסק קבוע, כי מסד הנתונים הוא Cloudflare D1 (מנוהל).

הפריסה נעשית דרך [`@opennextjs/cloudflare`](https://opennext.js.org/cloudflare),
ה-adapter הרשמי שממיר בנייה של Next.js להרצה על Workers.

### הגדרה חד-פעמית

1. התקינו והתחברו ל-Cloudflare (אם עוד לא):
   ```bash
   npm install
   npx wrangler login
   ```
2. צרו מסד D1:
   ```bash
   npx wrangler d1 create course-db
   ```
   הפקודה תדפיס `database_id` - העתיקו אותו ל-`wrangler.jsonc`, לשדה
   `d1_databases[0].database_id` (במקום `REPLACE_WITH_YOUR_DATABASE_ID`).
3. הריצו את ה-migration (יוצר את הטבלאות ומזין נתוני ברירת מחדל) על המסד
   האמיתי בענן:
   ```bash
   npm run db:migrate:remote
   ```
4. הגדירו את משתני הסביבה הרגישים כ-secrets (לא בקובץ `.env` - זה לא נשלח
   לענן):
   ```bash
   npx wrangler secret put ADMIN_PASSWORD
   npx wrangler secret put INVOICE4U_API_KEY
   npx wrangler secret put INVOICE4U_CC_COMPANY
   npx wrangler secret put SITE_URL
   npx wrangler secret put RESEND_API_KEY
   npx wrangler secret put EMAIL_FROM
   ```

### פריסה

```bash
npm run deploy
```

הפקודה בונה את האתר (`opennextjs-cloudflare build`) ומפרסמת אותו ל-Workers
(`opennextjs-cloudflare deploy`). בסיום תודפס כתובת ה-`workers.dev` של האתר;
לחיבור דומיין משלכם - **Workers & Pages → השירות → Settings → Domains &
Routes** בדשבורד של Cloudflare.

> **חשוב**: `SITE_URL` צריך לשקף את הדומיין שבו האתר ירוץ בפועל (כתובת
> ה-`ReturnUrl` שנשלחת ל-Invoice4U נבנית ממנו) - עדכנו את ה-secret הזה
> (`wrangler secret put SITE_URL`) ופרסו מחדש אחרי שחיברתם דומיין.

לבדיקה מקומית של גרסת ה-build לפני פריסה (רץ מול D1 מקומי, לא הענן האמיתי):

```bash
npm run preview
```

## מבנה הפרויקט (למי שרוצה להתאים)

```
app/
  page.js              עמוד הבית / מכירה
  register, login      הרשמה והתחברות
  forgot-password, reset-password   איפוס סיסמה
  course/page.js        עמוד הקורס המוגן (paywall + נגן שיעורים)
  payment/success, cancel   מסכי חזרה מהתשלום
  admin/page.js          עמוד ניהול
  actions/             כל הלוגיקה בצד שרת (Server Actions)
lib/
  db.js                גישה למסד הנתונים (Cloudflare D1)
  auth.js, admin-auth.js   הרשמה/התחברות/הרשאות
  invoice4u.js         אינטגרציית הסליקה (Invoice4U Clearing API)
  mailer.js            שליחת מייל איפוס סיסמה (Resend)
  settings.js, video.js   עזרים
migrations/
  0001_init.sql        מבנה הטבלאות + נתוני ברירת מחדל (מורץ דרך wrangler d1 migrations)
```

- **עיצוב**: כל הצבעים, הגופנים והרווחים מוגדרים כמשתני CSS בראש
  `app/globals.css` - שינוי שם משפיע על כל האתר בבת אחת.
- **שאלות נפוצות**: כרגע כתובות ישירות בקוד (`app/page.js`) - אם תרצו
  לערוך אותן, צריך לערוך את הקובץ הזה (לא דרך `/admin`).
- כל תוכן אחר (שם הקורס, מחיר, תיאור, שיעורים) - דרך `/admin`.

## הערות אבטחה

- הסשנים (גם של משתמשים וגם של מנהל) הם opaque tokens שמאוחסנים במסד
  הנתונים, ב-cookie מסוג `httpOnly` + `sameSite=lax` - לא JWT, כדי שתמיד
  אפשר לבטל סשן ספציפי.
- בדיקת התשלום לא מסתפקת ב-redirect שהמשתמש חוזר ממנו - היא שואלת ישירות
  את שרתי Invoice4U (`GetClearingLogById`) לפני שמסמנת משתמש כ"שילם".
- קישור איפוס הסיסמה הוא טוקן חד-פעמי שתקף לשעה; במסד הנתונים נשמר רק
  hash שלו (לא הטוקן עצמו), והעמוד "שכחתי סיסמה" מגיב באותו אופן בין אם
  האימייל קיים במערכת ובין אם לא - כדי שלא יהיה אפשר להשתמש בו לבדוק אילו
  כתובות רשומות באתר.
- לא הוספנו הגבלת קצב (rate limiting) על הרשמה/התחברות/איפוס סיסמה. באתר
  עם תנועה גבוהה כדאי להוסיף הגנה כזו (לדוגמה דרך Nginx או שירות כמו
  Cloudflare) כדי למנוע ניסיונות brute-force או spam של בקשות איפוס.
