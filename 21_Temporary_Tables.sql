/* ==============================================================================
   SQL Temporary Tables
-------------------------------------------------------------------------------
   This script provides examples of using temporary tables for data migration,
   cleaning, and testing operations in SQL Server.

   Table of Contents:
     1. Create Temporary Table
     2. Clean Data in Temporary Table
     3. Load Cleaned Data into a Permanent Table
===============================================================================*/

/* ==============================================================================
   STEP 1: CREATE TEMPORARY TABLE (#Orders)
===============================================================================*/

-- Create a temporary table as a copy of Sales.Orders
SELECT
    *
INTO #Orders
FROM Sales.Orders;

-- Verify the temporary table
SELECT * FROM #Orders;

/* ==============================================================================
   STEP 2: CLEAN DATA IN TEMPORARY TABLE
===============================================================================*/

-- Delete rows with delivered orders from the temporary table
DELETE FROM #Orders
WHERE OrderStatus = 'Delivered';

-- Verify cleaned data
SELECT * FROM #Orders;

/* ==============================================================================
   STEP 3: LOAD CLEANED DATA INTO A PERMANENT TABLE
===============================================================================*/

-- Create a permanent table and load cleaned data into it
SELECT
    *
INTO Sales.OrdersTest
FROM #Orders;

-- Verify data in the permanent table
SELECT * FROM Sales.OrdersTest;
