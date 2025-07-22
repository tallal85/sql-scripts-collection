/* ==============================================================================
   SQL Aggregate Functions
-------------------------------------------------------------------------------
   This document provides an overview of SQL aggregate functions, which allow 
   performing calculations on multiple rows of data to generate summary results.

   Table of Contents:
     1. Basic Aggregate Functions
        - COUNT
        - SUM
        - AVG
        - MAX
        - MIN
     2. Grouped Aggregations
        - GROUP BY
=================================================================================
*/

/* ============================================================================== 
   BASIC AGGREGATE FUNCTIONS
=============================================================================== */

-- Find the total number of customers
SELECT COUNT(*) AS total_customers
FROM Sales.Customers;

-- Find the total sales of all orders
SELECT SUM(Sales) AS total_sales
FROM Sales.Orders;

-- Find the average sales of all orders
SELECT AVG(Sales) AS avg_sales
FROM Sales.Orders;

-- Find the highest score among customers
SELECT MAX(Score) AS max_score
FROM Sales.Customers;

-- Find the lowest score among customers
SELECT MIN(Score) AS min_score
FROM Sales.Customers;

/* ============================================================================== 
   GROUPED AGGREGATIONS - GROUP BY
=============================================================================== */

-- Find the number of orders, total sales, average sales, highest sales, and lowest sales per customer
SELECT
    CustomerID,
    COUNT(*) AS total_orders,
    SUM(Sales) AS total_sales,
    AVG(Sales) AS avg_sales,
    MAX(Sales) AS highest_sales,
    MIN(Sales) AS lowest_sales
FROM Sales.Orders
GROUP BY CustomerID;
