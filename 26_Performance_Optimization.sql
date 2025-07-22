/* ==============================================================================
   30 SQL Performance Optimization Tips
-------------------------------------------------------------------------------
   Best practices for optimizing SQL queries, including fetching data, filtering,
   joins, UNION, aggregations, subqueries/CTE, DDL, and indexing.
===============================================================================*/

/* ###############################################################
   1. FETCHING DATA
################################################################*/

-- Tip 1: Select Only What You Need
-- Bad
SELECT * FROM Sales.Customers;
-- Good
SELECT CustomerID, FirstName, LastName FROM Sales.Customers;

-- Tip 2: Avoid unnecessary DISTINCT & ORDER BY
-- Bad
SELECT DISTINCT FirstName FROM Sales.Customers ORDER BY FirstName;
-- Good
SELECT FirstName FROM Sales.Customers;

-- Tip 3: Limit Rows for Exploration
SELECT TOP 10 OrderID, Sales FROM Sales.Orders;

/* ###########################################################
   2. FILTERING
################################################################*/

-- Tip 4: Index Columns used in WHERE
CREATE NONCLUSTERED INDEX Idx_Orders_OrderStatus ON Sales.Orders(OrderStatus);

-- Tip 5: Avoid Functions in WHERE
-- Bad
SELECT * FROM Sales.Orders WHERE YEAR(OrderDate) = 2025;
-- Good
SELECT * FROM Sales.Orders 
WHERE OrderDate BETWEEN '2025-01-01' AND '2025-12-31';

-- Tip 6: Avoid Leading Wildcards
-- Bad
SELECT * FROM Sales.Customers WHERE LastName LIKE '%Gold%';
-- Good
SELECT * FROM Sales.Customers WHERE LastName LIKE 'Gold%';

-- Tip 7: Use IN instead of Multiple ORs
SELECT * FROM Sales.Orders WHERE CustomerID IN (1,2,3);

/* ###########################################################
   3. JOINS
################################################################*/

-- Tip 8: Prefer INNER JOIN where possible
SELECT c.FirstName, o.OrderID 
FROM Sales.Customers c 
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID;

-- Tip 9: Use Explicit (ANSI) Joins
SELECT c.FirstName, o.OrderID
FROM Sales.Customers AS c
INNER JOIN Sales.Orders AS o ON c.CustomerID = o.CustomerID;

-- Tip 10: Index ON clause columns
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON Sales.Orders(CustomerID);

-- Tip 11: Filter Before Joining (Big Tables)
SELECT c.FirstName, o.OrderID
FROM Sales.Customers c
INNER JOIN (
    SELECT OrderID, CustomerID
    FROM Sales.Orders
    WHERE OrderStatus = 'Delivered'
) o ON c.CustomerID = o.CustomerID;

-- Tip 12: Aggregate Before Joining (Big Tables)
SELECT c.CustomerID, c.FirstName, o.OrderCount
FROM Sales.Customers c
INNER JOIN (
    SELECT CustomerID, COUNT(OrderID) AS OrderCount
    FROM Sales.Orders
    GROUP BY CustomerID
) o ON c.CustomerID = o.CustomerID;

-- Tip 13: Use UNION Instead of OR in Joins
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
UNION
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.SalesPersonID;

-- Tip 14: Use SQL Hints for Big Table Joins
SELECT o.OrderID, c.FirstName
FROM Sales.Customers c
INNER JOIN Sales.Orders o ON c.CustomerID = o.CustomerID
OPTION (HASH JOIN);

/* ###########################################################
   4. UNION
################################################################*/

-- Tip 15: Use UNION ALL when duplicates are acceptable
SELECT CustomerID FROM Sales.Orders
UNION ALL
SELECT CustomerID FROM Sales.OrdersArchive;

-- Tip 16: Use UNION ALL + DISTINCT when duplicates must be removed
SELECT DISTINCT CustomerID
FROM (
    SELECT CustomerID FROM Sales.Orders
    UNION ALL
    SELECT CustomerID FROM Sales.OrdersArchive
) AS CombinedData;

/* ###########################################################
   5. AGGREGATIONS
################################################################*/

-- Tip 17: Use Columnstore Index for Large Aggregations
CREATE CLUSTERED COLUMNSTORE INDEX Idx_Orders_Columnstore ON Sales.Orders;

-- Tip 18: Pre-Aggregate Data for Reporting
SELECT MONTH(OrderDate) AS OrderMonth, SUM(Sales) AS TotalSales
INTO Sales.SalesSummary
FROM Sales.Orders
GROUP BY MONTH(OrderDate);

/* ###########################################################
   6. SUBQUERIES & CTE
################################################################*/

-- Tip 19: Prefer JOIN or EXISTS over IN
-- Best Practice (EXISTS for large tables)
SELECT o.OrderID, o.Sales
FROM Sales.Orders o
WHERE EXISTS (
    SELECT 1
    FROM Sales.Customers c
    WHERE c.CustomerID = o.CustomerID
      AND c.Country = 'USA'
);

-- Tip 20: Avoid Redundant Logic (Use Window Functions)
SELECT EmployeeID, FirstName,
    CASE
        WHEN Salary > AVG(Salary) OVER () THEN 'Above Average'
        WHEN Salary < AVG(Salary) OVER () THEN 'Below Average'
        ELSE 'Average'
    END AS Status
FROM Sales.Employees;

/* ###########################################################
   7. DDL BEST PRACTICES
################################################################*/

-- Tip 21-25: Table Design
CREATE TABLE CustomersInfo (
    CustomerID INT PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    TotalPurchases FLOAT,
    Score INT,
    BirthDate DATE,
    EmployeeID INT,
    CONSTRAINT FK_CustomersInfo_EmployeeID FOREIGN KEY (EmployeeID)
        REFERENCES Sales.Employees(EmployeeID)
);
CREATE NONCLUSTERED INDEX IX_CustomersInfo_EmployeeID ON CustomersInfo(EmployeeID);

/* ###########################################################
   8. INDEXING & MAINTENANCE
################################################################*/

-- Tip 26: Avoid Over-Indexing (Slows inserts/updates)
-- Tip 27: Drop Unused Indexes Periodically
-- Tip 28: Update Statistics Weekly
EXEC sp_updatestats;

-- Tip 29: Reorganize & Rebuild Fragmented Indexes
ALTER INDEX IX_CustomersInfo_EmployeeID ON CustomersInfo REORGANIZE;
ALTER INDEX IX_CustomersInfo_EmployeeID ON CustomersInfo REBUILD;

-- Tip 30: Partition Large Tables + Columnstore for Best Performance
-- (See 25_Partitions.sql for full implementation)
