/* ==============================================================================
   SQL Subquery Functions
-------------------------------------------------------------------------------
   This script demonstrates various subquery techniques in SQL.
   It covers result types, subqueries in the FROM clause, in SELECT, in JOIN clauses,
   with comparison operators, IN, ANY, correlated subqueries, and EXISTS.
   
   Table of Contents:
     1. Subquery - Result Types
     2. Subquery - FROM Clause
     3. Subquery - SELECT
     4. Subquery - JOIN Clause
     5. Subquery - Comparison Operators 
     6. Subquery - IN Operator
     7. Subquery - ANY Operator
     8. Correlated Subquery
     9. EXISTS Operator
===============================================================================
*/

/* ==============================================================================
   SUBQUERY | RESULT TYPES
===============================================================================*/

-- Scalar Query
SELECT AVG(Sales) AS AvgSales
FROM Sales.Orders;

-- Row Query
SELECT CustomerID
FROM Sales.Orders;

-- Table Query
SELECT OrderID, OrderDate
FROM Sales.Orders;

/* ==============================================================================
   SUBQUERY | FROM CLAUSE
===============================================================================*/

-- TASK 1: Products priced above the average price of all products
SELECT *
FROM (
    SELECT
        ProductID,
        Price,
        AVG(Price) OVER () AS AvgPrice
    FROM Sales.Products
) AS t
WHERE Price > AvgPrice;

-- TASK 2: Rank customers by total sales
SELECT *,
       RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
FROM (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS t;

/* ==============================================================================
   SUBQUERY | SELECT
===============================================================================*/

-- TASK 3: Product details with total number of orders
SELECT
    ProductID,
    Product,
    Price,
    (SELECT COUNT(*) FROM Sales.Orders) AS TotalOrders
FROM Sales.Products;

/* ==============================================================================
   SUBQUERY | JOIN CLAUSE
===============================================================================*/

-- TASK 4: Customer details with total sales
SELECT
    c.*,
    t.TotalSales
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT
        CustomerID,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID
) AS t
ON c.CustomerID = t.CustomerID;

-- TASK 5: Customer details with total orders
SELECT
    c.*,
    o.TotalOrders
FROM Sales.Customers AS c
LEFT JOIN (
    SELECT
        CustomerID,
        COUNT(*) AS TotalOrders
    FROM Sales.Orders
    GROUP BY CustomerID
) AS o
ON c.CustomerID = o.CustomerID;

/* ==============================================================================
   SUBQUERY | COMPARISON OPERATORS
===============================================================================*/

-- TASK 6: Products priced above average
SELECT
    ProductID,
    Price,
    (SELECT AVG(Price) FROM Sales.Products) AS AvgPrice
FROM Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

/* ==============================================================================
   SUBQUERY | IN OPERATOR
===============================================================================*/

-- TASK 7: Orders by customers in Germany
SELECT *
FROM Sales.Orders
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sales.Customers
    WHERE Country = 'Germany'
);

-- TASK 8: Orders by customers not in Germany
SELECT *
FROM Sales.Orders
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Sales.Customers
    WHERE Country = 'Germany'
);

/* ==============================================================================
   SUBQUERY | ANY OPERATOR
===============================================================================*/

-- TASK 9: Female employees earning more than any male employee
SELECT
    EmployeeID,
    FirstName,
    Salary
FROM Sales.Employees
WHERE Gender = 'F'
  AND Salary > ANY (
      SELECT Salary
      FROM Sales.Employees
      WHERE Gender = 'M'
  );

/* ==============================================================================
   CORRELATED SUBQUERY
===============================================================================*/

-- TASK 10: Customer details with total orders (correlated)
SELECT
    *,
    (SELECT COUNT(*)
     FROM Sales.Orders o
     WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM Sales.Customers AS c;

/* ==============================================================================
   SUBQUERY | EXISTS OPERATOR
===============================================================================*/

-- TASK 11: Orders by customers in Germany
SELECT *
FROM Sales.Orders AS o
WHERE EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
      AND o.CustomerID = c.CustomerID
);

-- TASK 12: Orders by customers not in Germany
SELECT *
FROM Sales.Orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.Customers AS c
    WHERE Country = 'Germany'
      AND o.CustomerID = c.CustomerID
);
