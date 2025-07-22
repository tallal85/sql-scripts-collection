/* ==============================================================================
   03_Data_Manipulation_DML.sql
-------------------------------------------------------------------------------
   INSERT, UPDATE, DELETE, and MERGE operations.
=================================================================================
*/

/* =======================
   1. INSERT DATA
==========================*/

-- Insert single row
INSERT INTO Sales.Customers (CustomerID, FirstName, LastName, Country, Score, BirthDate)
VALUES (1, 'John', 'Smith', 'USA', 85, '1990-05-12');

-- Insert multiple rows
INSERT INTO Sales.Customers (CustomerID, FirstName, LastName, Country, Score, BirthDate)
VALUES 
(2, 'Maria', 'Gonzalez', 'Spain', 90, '1988-07-23'),
(3, 'Ahmed', 'Khan', 'UAE', 70, '1992-11-02');

-- Insert into Orders
INSERT INTO Sales.Orders (OrderID, CustomerID, ProductID, OrderDate, Sales, Quantity, OrderStatus)
VALUES
(101, 1, 10, '2025-07-01', 250.00, 5, 'Pending'),
(102, 2, 12, '2025-07-03', 100.00, 2, 'Delivered');

/* =======================
   2. UPDATE DATA
==========================*/

-- Update customer score
UPDATE Sales.Customers
SET Score = 95
WHERE CustomerID = 1;

-- Update multiple columns
UPDATE Sales.Orders
SET 
    OrderStatus = 'Delivered',
    Sales = Sales + 20
WHERE OrderID = 101;

/* =======================
   3. DELETE DATA
==========================*/

-- Delete a specific order
DELETE FROM Sales.Orders
WHERE OrderID = 102;

-- Delete customers with NULL score
DELETE FROM Sales.Customers
WHERE Score IS NULL;

/* =======================
   4. MERGE DATA (Upsert)
==========================*/

-- Insert or update customers from a staging table
MERGE Sales.Customers AS target
USING (
    SELECT 1 AS CustomerID, 'John' AS FirstName, 'Smith' AS LastName, 'USA' AS Country, 100 AS Score
    UNION ALL
    SELECT 4, 'Elena', 'Popov', 'Russia', 80
) AS source
ON target.CustomerID = source.CustomerID

WHEN MATCHED THEN
    UPDATE SET 
        target.Score = source.Score,
        target.Country = source.Country

WHEN NOT MATCHED THEN
    INSERT (CustomerID, FirstName, LastName, Country, Score)
    VALUES (source.CustomerID, source.FirstName, source.LastName, source.Country, source.Score);

-- Check result
SELECT * FROM Sales.Customers;
