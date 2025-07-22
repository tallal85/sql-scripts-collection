/* ==============================================================================
   07_String_Functions.sql
-------------------------------------------------------------------------------
   Demonstrates SQL string functions for text manipulation, transformation, and
   extraction.

   Functions Covered:
     1. CONCAT
     2. LOWER / UPPER
     3. TRIM
     4. REPLACE
     5. LEN
     6. LEFT / RIGHT
     7. SUBSTRING
     8. Nesting Functions
=================================================================================
*/

/* =======================
   1. CONCAT
==========================*/

-- Concatenate first name and country
SELECT 
    CONCAT(FirstName, '-', Country) AS FullInfo
FROM Sales.Customers;

/* =======================
   2. LOWER / UPPER
==========================*/

-- Convert first name to lowercase
SELECT 
    LOWER(FirstName) AS LowerCaseName
FROM Sales.Customers;

-- Convert first name to uppercase
SELECT 
    UPPER(FirstName) AS UpperCaseName
FROM Sales.Customers;

/* =======================
   3. TRIM
==========================*/

-- Find customers with leading or trailing spaces in first name
SELECT 
    FirstName,
    LEN(FirstName) AS OriginalLength,
    LEN(TRIM(FirstName)) AS TrimmedLength
FROM Sales.Customers
WHERE FirstName != TRIM(FirstName);

/* =======================
   4. REPLACE
==========================*/

-- Replace dashes in phone number
SELECT
    '123-456-7890' AS OriginalPhone,
    REPLACE('123-456-7890', '-', '') AS CleanPhone;

-- Replace file extension from .txt to .csv
SELECT
    'report.txt' AS OldFile,
    REPLACE('report.txt', '.txt', '.csv') AS NewFile;

/* =======================
   5. LEN
==========================*/

-- Length of each customer's first name
SELECT 
    FirstName, 
    LEN(FirstName) AS NameLength
FROM Sales.Customers;

/* =======================
   6. LEFT / RIGHT
==========================*/

-- First two characters of first name
SELECT 
    FirstName,
    LEFT(FirstName, 2) AS First2Chars
FROM Sales.Customers;

-- Last two characters of first name
SELECT 
    FirstName,
    RIGHT(FirstName, 2) AS Last2Chars
FROM Sales.Customers;

/* =======================
   7. SUBSTRING
==========================*/

-- Extract first name without the first character
SELECT 
    FirstName,
    SUBSTRING(FirstName, 2, LEN(FirstName)) AS TrimmedName
FROM Sales.Customers;

/* =======================
   8. Nesting Functions
==========================*/

-- Apply multiple transformations
SELECT
    FirstName,
    UPPER(LOWER(FirstName)) AS NestedExample
FROM Sales.Customers;
