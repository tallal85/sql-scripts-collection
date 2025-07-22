/* ==============================================================================
   10_Date_Time_Formats.sql
-------------------------------------------------------------------------------
   Demonstrates SQL Server date formatting using FORMAT, CONVERT, and culture 
   codes. Includes common date styles and localization examples.

   Functions Covered:
     1. FORMAT – Standard and Custom Formats
     2. CONVERT – Style Codes
     3. Culture-Specific Formats
=================================================================================
*/

/* =======================
   1. FORMAT – Standard and Custom Formats
==========================*/

SELECT
    GETDATE() AS CurrentDate,
    FORMAT(GETDATE(), 'D') AS FullDatePattern,
    FORMAT(GETDATE(), 'd') AS ShortDatePattern,
    FORMAT(GETDATE(), 'MMM dd, yyyy') AS CustomFormat,
    FORMAT(GETDATE(), 'HH:mm:ss') AS Time24Hour,
    FORMAT(GETDATE(), 'hh:mm:ss tt') AS Time12Hour;

/* =======================
   2. CONVERT – Style Codes
==========================*/

SELECT
    GETDATE() AS CurrentDate,
    CONVERT(VARCHAR, GETDATE(), 101) AS USA_MMDDYYYY,   -- 01/31/2025
    CONVERT(VARCHAR, GETDATE(), 103) AS UK_DDMMYYYY,    -- 31/01/2025
    CONVERT(VARCHAR, GETDATE(), 120) AS ISO_YYYYMMDD,   -- 2025-01-31 13:45:00
    CONVERT(VARCHAR, GETDATE(), 113) AS EURO_DDMonYYYY  -- 31 Jan 2025 13:45:00
;

/* =======================
   3. Culture-Specific Formats
==========================*/

SELECT
    FORMAT(GETDATE(), 'D', 'en-US') AS US_FullDate,
    FORMAT(GETDATE(), 'D', 'fr-FR') AS French_FullDate,
    FORMAT(GETDATE(), 'D', 'de-DE') AS German_FullDate,
    FORMAT(GETDATE(), 'D', 'ja-JP') AS Japanese_FullDate;

