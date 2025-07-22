/* ==============================================================================
   01_Query_Data_SELECT.sql
-------------------------------------------------------------------------------
   Basic and advanced SELECT queries – selecting columns, filtering,
   sorting, and simple aggregations.
=================================================================================
*/

/* =======================
   1. SELECT Specific Columns
==========================*/
SELECT 
    CustomerID,
    FirstName,
    LastName
FROM Sales.Customers;

/* =======================
   2. SELECT All Columns
==========================*/
SELECT 
    *
FROM Sales.Orders;

/* =======================
   3. DISTINCT Values
==========================*/
SELECT DISTINCT 
    Country
FROM Sales.Customers;

/* =======================
   4. Sorting (ORDER BY)
==========================*/
SELECT 
    OrderID,
    Sales
FROM Sales.Orders
ORDER BY Sales DESC;

/* =======================
   5. Simple Aggregations
==========================*/
SELECT 
    COUNT(*) AS TotalOrders,
    SUM(Sales) AS TotalSales,
    AVG(Sales) AS AvgSales
FROM Sales.Orders;

