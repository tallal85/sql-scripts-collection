/* ==============================================================================
   06_SETs.sql
-------------------------------------------------------------------------------
   Demonstrates SQL set operations: UNION, UNION ALL, INTERSECT, and EXCEPT.
=================================================================================
*/

/* =======================
   1. UNION
==========================*/

-- Combine customers' and employees' first and last names (no duplicates)
SELECT 
    FirstName,
    LastName
FROM Sales.Customers
UNION
SELECT 
    FirstName,
    LastName
FROM Sales.Employees;

/* =======================
   2. UNION ALL
==========================*/

-- Combine customers' and employees' first and last names (include duplicates)
SELECT 
    FirstName,
    LastName
FROM Sales.Customers
UNION ALL
SELECT 
    FirstName,
    LastName
FROM Sales.Employees;

/* =======================
   3. INTERSECT
==========================*/

-- Find employees who are also customers
SELECT 
    FirstName,
    LastName
FROM Sales.Employees
INTERSECT
SELECT 
    FirstName,
    LastName
FROM Sales.Customers;

/* =======================
   4. EXCEPT
==========================*/

-- Find employees who are NOT customers
SELECT 
    FirstName,
    LastName
FROM Sales.Employees
EXCEPT
SELECT 
    FirstName,
    LastName
FROM Sales.Customers;

/* =======================
   5. UNION with Additional Column
==========================*/

-- Combine Orders and OrdersArchive into one report (without duplicates)
SELECT
    'Orders' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    Quantity,
    Sales
FROM Sales.Orders
UNION
SELECT
    'OrdersArchive' AS SourceTable,
    OrderID,
    ProductID,
    CustomerID,
    SalesPersonID,
    OrderDate,
    ShipDate,
    OrderStatus,
    Quantity,
    Sales
FROM Sales.OrdersArchive
ORDER BY OrderID;
