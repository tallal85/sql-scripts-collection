/* ==============================================================================
   11_NULL_Functions.sql
-------------------------------------------------------------------------------
   Demonstrates handling NULL values in SQL Server for calculations, 
   sorting, and comparisons.

   Functions & Techniques:
     1. COALESCE – Replace NULLs
     2. ISNULL – Substitute Default Values
     3. NULLIF – Avoid Division by Zero
     4. IS NULL / IS NOT NULL – Filtering
     5. Sorting NULLs Last
     6. NULL vs Empty String vs Blank Spaces
=================================================================================
*/

/* =======================
   1. COALESCE – Replace NULLs
==========================*/

SELECT
    CustomerID,
    Score,
    COALESCE(Score, 0) AS ScoreWithDefault
FROM Sales.Customers;

/* =======================
   2. ISNULL – Substitute Default Values
==========================*/

SELECT
    CustomerID,
    ISNULL(LastName, 'Unknown') AS CleanedLastName
FROM Sales.Customers;

/* =======================
   3. NULLIF – Avoid Division by Zero
==========================*/

SELECT
    OrderID,
    Sales,
    Quantity,
    Sales / NULLIF(Quantity, 0) AS PricePerUnit
FROM Sales.Orders;

/* =======================
   4. IS NULL / IS NOT NULL – Filtering
==========================*/

-- Customers with no Score
SELECT * 
FROM Sales.Customers
WHERE Score IS NULL;

-- Customers with Score
SELECT * 
FROM Sales.Customers
WHERE Score IS NOT NULL;

/* =======================
   5. Sorting NULLs Last
==========================*/

SELECT
    CustomerID,
    Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END, Score;

/* =======================
   6. NULL vs Empty String vs Blank Spaces
==========================*/

WITH TestData AS (
    SELECT 1 AS ID, 'A' AS Category UNION
    SELECT 2, NULL UNION
    SELECT 3, '' UNION
    SELECT 4, '  '
)
SELECT 
    *,
    DATALENGTH(Category) AS LengthBeforeTrim,
    TRIM(Category) AS TrimmedCategory,
    COALESCE(NULLIF(TRIM(Category), ''), 'Unknown') AS CleanedCategory
FROM TestData;
