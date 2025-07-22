/* ==============================================================================
   04_Filtering_Data.sql
-------------------------------------------------------------------------------
   Filtering data using WHERE, BETWEEN, LIKE, and logical operators.
=================================================================================
*/

/* =======================
   1. BASIC WHERE FILTERS
==========================*/

-- Customers from USA
SELECT *
FROM Sales.Customers
WHERE Country = 'USA';

-- Orders with Sales greater than 100
SELECT *
FROM Sales.Orders
WHERE Sales > 100;

/* =======================
   2. BETWEEN OPERATOR
==========================*/

-- Orders placed between two dates
SELECT *
FROM Sales.Orders
WHERE OrderDate BETWEEN '2025-07-01' AND '2025-07-31';

-- Customers with scores between 70 and 90
SELECT *
FROM Sales.Customers
WHERE Score BETWEEN 70 AND 90;

/* =======================
   3. IN & NOT IN
==========================*/

-- Orders from specific customers
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (1, 2, 3);

-- Customers not from USA or Germany
SELECT *
FROM Sales.Customers
WHERE Country NOT IN ('USA', 'Germany');

/* =======================
   4. LIKE OPERATOR
==========================*/

-- Customers whose first name starts with 'J'
SELECT *
FROM Sales.Customers
WHERE FirstName LIKE 'J%';

-- Customers whose last name ends with 'son'
SELECT *
FROM Sales.Customers
WHERE LastName LIKE '%son';

-- Customers whose name contains 'ar'
SELECT *
FROM Sales.Customers
WHERE FirstName LIKE '%ar%';

/* =======================
   5. LOGICAL OPERATORS (AND / OR / NOT)
==========================*/

-- Customers from USA with score above 80
SELECT *
FROM Sales.Customers
WHERE Country = 'USA' AND Score > 80;

-- Customers from USA or Germany
SELECT *
FROM Sales.Customers
WHERE Country = 'USA' OR Country = 'Germany';

-- Customers not from Spain
SELECT *
FROM Sales.Customers
WHERE NOT Country = 'Spain';

/* =======================
   6. IS NULL & IS NOT NULL
==========================*/

-- Customers with NULL score
SELECT *
FROM Sales.Customers
WHERE Score IS NULL;

-- Customers with score present
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL;
