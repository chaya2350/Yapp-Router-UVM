
# YAPP Router UVM Verification Environment
פרויקט זה מכיל סביבת אימות UVM עבור YAPP Router, כולל מספר מעבדות (labs) המדגימות שלבים שונים בפיתוח סביבת האימות.

## מבנה הפרויקט
### רכיבי UVM עיקריים
yapp/: סביבת UVM עיקרית עבור YAPP protocol
channel/: UVC עבור channel interface
hbus/: UVC עבור host bus interface
clock_and_reset/: UVC עבור clock and reset control
### מעבדות (Labs)
lab01_data/: יצירת data objects
lab02_test/: יצירת test cases
lab03_uvc/: פיתוח UVM Verification Component
lab04_factory/: שימוש ב-UVM Factory
lab05_seq/: sequences ו-sequencers
lab06_vif/: virtual interfaces
lab07_integ/: אינטגרציה של רכיבים
lab08_mcseq/: multi-channel sequences
lab09_sba/: scoreboard - גישה A
lab09_sbb/: scoreboard - גישה B
lab09_sbd/: scoreboard - גישה D
lab11a_rm_gen/: register model generation
lab11b_rm_integ/: register model integration
RTL
router_rtl/: קבצי RTL של ה-router
## דרישות מערכת
Cadence Xcelium או כלי סימולציה תואם אחר
UVM library
SystemVerilog compiler
## הרצה
כל מעבדה מכילה קובץ run.f עם הגדרות הקומפילציה והסימולציה.

## רישיון
!ראה קובץ COPYRIGHT.TXT לפרטי הרישיון.

## יוצרת
chaya2350
