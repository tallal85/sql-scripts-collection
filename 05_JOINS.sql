/* ==============================================================================
   05_JOINS.sql
-------------------------------------------------------------------------------
   Demonstrates INNER, LEFT, RIGHT, and FULL OUTER JOIN with practical examples.
=================================================================================
*/

/* =======================
   1. INNER JOIN
==========================*/

-- Orders with their corresponding customer details
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Sales.Orders AS o
INNER JOIN Sales.Customers AS c
    ON o.CustomerID = c.CustomerID;

/* =======================
   2. LEFT JOIN
==========================*/

-- All customers with their orders (including customers without orders)
SELECT 
    c.CustomerID,
    c.FirstName,
    c.LastName,
    o.OrderID,
    o.OrderDate
FROM Sales.Customers AS c
LEFT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID;

/* =======================
   3. RIGHT JOIN
==========================*/

-- All orders with their customers (including orders without customer details)
SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerID,
    c.FirstName,
    c.LastName
FROM Sales.Customers AS c
RIGHT JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID;

/* =======================
   4. FULL OUTER JOIN
==========================*/

-- Combine all customers and all orders (regardless of match)
SELECT 
    c.CustomerID,
    c.FirstName,
    o.OrderID,
    o.OrderDate
FROM Sales.Customers AS c
FULL OUTER JOIN Sales.Orders AS o
    ON c.CustomerID = o.CustomerID;

/* =======================
   5. SELF JOIN
==========================*/

-- Employees and their managers
SELECT 
    e.EmployeeID,
    e.FirstName AS EmployeeName,
    m.EmployeeID AS ManagerID,
    m.FirstName AS ManagerName
FROM Sales.Employees AS e
LEFT JOIN Sales.Employees AS m
    ON e.ManagerID = m.EmployeeID;

/* =======================
   6. CROSS JOIN
==========================*/

-- All combinations of customers and products
SELECT 
    c.CustomerID,
    c.FirstName,
    p.ProductID,
    p.Product
FROM Sales.Customers AS c
CROSS JOIN Sales.Products AS p;
