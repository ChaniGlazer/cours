# תמונת שיתוף ואייקונים

- `og-default.html` - מקור תמונת השיתוף `public/og-default.png` (1200x630). לעריכה: לשנות את ה-HTML ולצלם:
  `msedge --headless=new --window-size=1200,630 --force-device-scale-factor=1 --screenshot=public/og-default.png file:///.../scripts/og/og-default.html`
  הכתובת `/og-default.png` מוזכרת ב-`lib/seo.js` (OG_IMAGES) ונכנסת ל-metadata של כל עמוד.
- `icon.html` - מקור האייקון (256x256) שממנו נוצרו `app/favicon.ico` ו-`app/apple-icon.png`. `app/icon.svg` נכתב ידנית באותו עיצוב.
