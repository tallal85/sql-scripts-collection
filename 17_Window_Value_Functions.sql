/* ==============================================================================
   SQL Window Value Functions
-------------------------------------------------------------------------------
   These functions let you reference and compare values from other rows 
   in a result set without complex joins or subqueries, enabling advanced 
   analysis on ordered data.

   Table of Contents:
     1. LEAD
     2. LAG
     3. FIRST_VALUE
     4. LAST_VALUE
===============================================================================
*/

/* ============================================================
   SQL WINDOW VALUE | LEAD, LAG
============================================================ */

-- TASK 1: Month-over-Month (MoM) Sales Percentage Change
SELECT
    *,
    CurrentMonthSales - PreviousMonthSales AS MoM_Change,
    ROUND(
        CAST((CurrentMonthSales - PreviousMonthSales) AS FLOAT)
        / PreviousMonthSales * 100, 1
    ) AS MoM_Perc
FROM (
    SELECT
        MONTH(OrderDate) AS OrderMonth,
        SUM(Sales) AS CurrentMonthSales,
        LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonthSales
    FROM Sales.Orders
    GROUP BY MONTH(OrderDate)
) AS MonthlySales;

-- TASK 2: Customer Loyalty - Average Days Between Orders
SELECT
    CustomerID,
    AVG(DaysUntilNextOrder) AS AvgDays,
    RANK() OVER (ORDER BY COALESCE(AVG(DaysUntilNextOrder), 999999)) AS RankAvg
FROM (
    SELECT
        OrderID,
        CustomerID,
        OrderDate AS CurrentOrder,
        LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS NextOrder,
        DATEDIFF(
            day,
            OrderDate,
            LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)
        ) AS DaysUntilNextOrder
    FROM Sales.Orders
) AS CustomerOrdersWithNext
GROUP BY CustomerID;

/* ============================================================
   SQL WINDOW VALUE | FIRST_VALUE & LAST_VALUE
============================================================ */

-- TASK 3: Lowest & Highest Sales per Product and Deviation from Lowest Sales
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS LowestSales,
    LAST_VALUE(Sales) OVER (
        PARTITION BY ProductID 
        ORDER BY Sales 
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS HighestSales,
    Sales - FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) AS SalesDifference
FROM Sales.Orders;
