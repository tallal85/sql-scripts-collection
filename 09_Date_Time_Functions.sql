/* ==============================================================================
   09_Date_Time_Functions.sql
-------------------------------------------------------------------------------
   Demonstrates SQL date and time functions for extracting, formatting, and 
   manipulating date/time values.

   Functions Covered:
     1. GETDATE
     2. DATEADD / DATEDIFF
     3. DATETRUNC
     4. DATENAME / DATEPART
     5. YEAR / MONTH / DAY
     6. EOMONTH
     7. FORMAT
     8. CONVERT / CAST
=================================================================================
*/

/* =======================
   1. GETDATE
==========================*/

-- Current system date and time
SELECT GETDATE() AS CurrentDateTime;

/* =======================
   2. DATEADD / DATEDIFF
==========================*/

-- Add or subtract intervals
SELECT
    GETDATE() AS Today,
    DATEADD(day, 10, GETDATE()) AS TenDaysLater,
    DATEADD(month, -2, GETDATE()) AS TwoMonthsEarlier;

-- Difference between dates
SELECT
    DATEDIFF(day, '2025-01-01', GETDATE()) AS DaysSince2025;

/* =======================
   3. DATETRUNC
==========================*/

-- Truncate to specific date parts
SELECT
    DATETRUNC(year, GETDATE()) AS StartOfYear,
    DATETRUNC(month, GETDATE()) AS StartOfMonth,
    DATETRUNC(day, GETDATE()) AS StartOfDay;

/* =======================
   4. DATENAME / DATEPART
==========================*/

-- Extract parts of the date
SELECT
    DATENAME(month, GETDATE()) AS MonthName,
    DATENAME(weekday, GETDATE()) AS WeekdayName,
    DATEPART(quarter, GETDATE()) AS QuarterNumber;

/* =======================
   5. YEAR / MONTH / DAY
==========================*/

-- Extract year, month, and day as integers
SELECT
    YEAR(GETDATE()) AS YearPart,
    MONTH(GETDATE()) AS MonthPart,
    DAY(GETDATE()) AS DayPart;

/* =======================
   6. EOMONTH
==========================*/

-- End of month date
SELECT
    EOMONTH(GETDATE()) AS EndOfThisMonth,
    EOMONTH(GETDATE(), 1) AS EndOfNextMonth;

/* =======================
   7. FORMAT
==========================*/

-- Format date in different styles
SELECT
    FORMAT(GETDATE(), 'MM-dd-yyyy') AS USA_Format,
    FORMAT(GETDATE(), 'dd-MM-yyyy') AS EURO_Format,
    FORMAT(GETDATE(), 'ddd MMM yyyy') AS ShortFormat;

/* =======================
   8. CONVERT / CAST
==========================*/

-- Convert between date and string
SELECT
    CONVERT(VARCHAR, GETDATE(), 101) AS ConvertedUSAStyle,
    CAST(GETDATE() AS DATE) AS CastToDateOnly;
