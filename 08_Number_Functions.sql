/* ==============================================================================
   08_Number_Functions.sql
-------------------------------------------------------------------------------
   Demonstrates SQL number functions for performing mathematical operations
   and formatting numerical values.

   Functions Covered:
     1. ROUND
     2. ABS
=================================================================================
*/

/* =======================
   1. ROUND
==========================*/

-- Round a number to different decimal places
SELECT 
    3.516 AS OriginalNumber,
    ROUND(3.516, 2) AS Rounded2Decimals,
    ROUND(3.516, 1) AS Rounded1Decimal,
    ROUND(3.516, 0) AS RoundedNoDecimals;

/* =======================
   2. ABS
==========================*/

-- Absolute value of negative and positive numbers
SELECT 
    -10 AS OriginalNegative,
    ABS(-10) AS AbsoluteNegative,
    10 AS OriginalPositive,
    ABS(10) AS AbsolutePositive;
