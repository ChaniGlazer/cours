-- מוסיף שדה לתוכן HTML מלא של שיעור (לצד/במקום קישור הווידאו הקיים) -
-- כדי לתמוך בהעלאת שיעורים כקובצי HTML מוכנים דרך עמוד הניהול.
ALTER TABLE lessons ADD COLUMN html_content TEXT;
