/* ==============================================================================
   SQL Triggers
-------------------------------------------------------------------------------
   This script demonstrates how to create and manage triggers in SQL Server.
   It includes creating a logging table, a trigger on the Employees table, and
   verifying that the trigger fires automatically after inserts.

   Table of Contents:
     1. Create a Logging Table
     2. Create an AFTER INSERT Trigger
     3. Test the Trigger with Insert Operations
     4. Verify Logs
===============================================================================*/

/* ==============================================================================
   1. CREATE A LOGGING TABLE
===============================================================================*/

-- Create a table to store logs for employee insert operations
CREATE TABLE Sales.EmployeeLogs
(
    LogID      INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    LogMessage VARCHAR(255),
    LogDate    DATETIME
);
GO

/* ==============================================================================
   2. CREATE AN AFTER INSERT TRIGGER
===============================================================================*/

-- Create a trigger that logs a message when a new employee is added
CREATE TRIGGER trg_AfterInsertEmployee
ON Sales.Employees
AFTER INSERT
AS
BEGIN
    INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
    SELECT
        EmployeeID,
        'New Employee Added = ' + CAST(EmployeeID AS VARCHAR),
        GETDATE()
    FROM INSERTED;
END;
GO

/* ==============================================================================
   3. TEST THE TRIGGER WITH INSERT OPERATIONS
===============================================================================*/

-- Insert a new employee into Sales.Employees
INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID)
VALUES (6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000, 3);
GO

-- Insert multiple employees at once to test the trigger for multiple rows
INSERT INTO Sales.Employees (EmployeeID, FirstName, LastName, Department, BirthDate, Gender, Salary, ManagerID)
VALUES 
(7, 'David', 'Smith', 'Finance', '1990-05-22', 'M', 90000, 2),
(8, 'Linda', 'Green', 'IT', '1992-03-18', 'F', 85000, 2);
GO

/* ==============================================================================
   4. VERIFY LOGS
===============================================================================*/

-- Check the logs to confirm the trigger worked correctly
SELECT *
FROM Sales.EmployeeLogs;
GO

/* ==============================================================================
   NOTES:
     - The trigger fires automatically after every INSERT on Sales.Employees.
     - If multiple rows are inserted, the trigger handles all rows via the INSERTED pseudo-table.
     - To drop the trigger:
       DROP TRIGGER trg_AfterInsertEmployee;
===============================================================================*/
