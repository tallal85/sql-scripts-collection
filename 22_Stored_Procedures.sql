/* ==============================================================================
   SQL Stored Procedures
-------------------------------------------------------------------------------
   This script demonstrates creating and managing stored procedures in SQL Server.
   It covers basic stored procedures, parameters, multiple queries, variables,
   control flow, and error handling.

   Table of Contents:
     1. Basic Stored Procedure
     2. Parameters
     3. Multiple Queries
     4. Variables
     5. Control Flow (IF/ELSE)
     6. Error Handling (TRY/CATCH)
===============================================================================*/

/* ==============================================================================
   1. BASIC STORED PROCEDURE
===============================================================================*/

-- Create a basic stored procedure to summarize customers in the USA
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = 'USA';
END;
GO

-- Execute the stored procedure
EXEC GetCustomerSummary;

/* ==============================================================================
   2. PARAMETERS
===============================================================================*/

-- Alter the procedure to accept a parameter for country
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;
END;
GO

-- Execute with different parameter values
EXEC GetCustomerSummary @Country = 'Germany';
EXEC GetCustomerSummary;

/* ==============================================================================
   3. MULTIPLE QUERIES
===============================================================================*/

-- Add multiple queries for customers and orders
ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Query 1: Customers summary
    SELECT
        COUNT(*) AS TotalCustomers,
        AVG(Score) AS AvgScore
    FROM Sales.Customers
    WHERE Country = @Country;

    -- Query 2: Orders summary
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END;
GO

/* ==============================================================================
   4. VARIABLES
===============================================================================*/

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    -- Declare variables
    DECLARE @TotalCustomers INT, @AvgScore FLOAT;

    -- Assign values to variables
    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    -- Print results
    PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
    PRINT('Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

    -- Orders summary
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END;
GO

/* ==============================================================================
   5. CONTROL FLOW (IF/ELSE)
===============================================================================*/

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    DECLARE @TotalCustomers INT, @AvgScore FLOAT;

    -- Check and update NULL scores if any
    IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
    BEGIN
        PRINT('Updating NULL Scores to 0');
        UPDATE Sales.Customers
        SET Score = 0
        WHERE Score IS NULL AND Country = @Country;
    END
    ELSE
    BEGIN
        PRINT('No NULL Scores found');
    END;

    -- Summary results
    SELECT
        @TotalCustomers = COUNT(*),
        @AvgScore = AVG(Score)
    FROM Sales.Customers
    WHERE Country = @Country;

    PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
    PRINT('Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

    -- Orders summary (with intentional error to demonstrate error handling later)
    SELECT
        COUNT(OrderID) AS TotalOrders,
        SUM(Sales) AS TotalSales,
        1/0 AS FaultyCalculation -- Intentional error
    FROM Sales.Orders AS o
    JOIN Sales.Customers AS c
        ON c.CustomerID = o.CustomerID
    WHERE c.Country = @Country;
END;
GO

/* ==============================================================================
   6. ERROR HANDLING (TRY/CATCH)
===============================================================================*/

ALTER PROCEDURE GetCustomerSummary @Country NVARCHAR(50) = 'USA' AS
BEGIN
    BEGIN TRY
        DECLARE @TotalCustomers INT, @AvgScore FLOAT;

        -- Check and update NULL scores if any
        IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country = @Country)
        BEGIN
            PRINT('Updating NULL Scores to 0');
            UPDATE Sales.Customers
            SET Score = 0
            WHERE Score IS NULL AND Country = @Country;
        END

        -- Summary results
        SELECT
            @TotalCustomers = COUNT(*),
            @AvgScore = AVG(Score)
        FROM Sales.Customers
        WHERE Country = @Country;

        PRINT('Total Customers from ' + @Country + ': ' + CAST(@TotalCustomers AS NVARCHAR));
        PRINT('Average Score from ' + @Country + ': ' + CAST(@AvgScore AS NVARCHAR));

        -- Orders summary (with intentional error)
        SELECT
            COUNT(OrderID) AS TotalOrders,
            SUM(Sales) AS TotalSales,
            1/0 AS FaultyCalculation
        FROM Sales.Orders AS o
        JOIN Sales.Customers AS c
            ON c.CustomerID = o.CustomerID
        WHERE c.Country = @Country;
    END TRY
    BEGIN CATCH
        PRINT('An error occurred.');
        PRINT('Error Message: ' + ERROR_MESSAGE());
        PRINT('Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR));
        PRINT('Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR));
        PRINT('Error State: ' + CAST(ERROR_STATE() AS NVARCHAR));
        PRINT('Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR));
        PRINT('Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A'));
    END CATCH;
END;
GO

-- Execute to test error handling
EXEC GetCustomerSummary @Country = 'Germany';
