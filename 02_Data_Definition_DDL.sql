/* ==============================================================================
   02_Data_Definition_DDL.sql
-------------------------------------------------------------------------------
   Create, alter, and drop tables, schemas, and constraints.
=================================================================================
*/

/* =======================
   1. CREATE SCHEMA
==========================*/
CREATE SCHEMA Sales;
GO

/* =======================
   2. CREATE TABLE
==========================*/
CREATE TABLE Sales.Customers (
    CustomerID INT PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50),
    Score INT
);
GO

CREATE TABLE Sales.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    ProductID INT,
    OrderDate DATE,
    Sales DECIMAL(10,2),
    Quantity INT,
    OrderStatus NVARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Sales.Customers(CustomerID)
);
GO

/* =======================
   3. ALTER TABLE
==========================*/
-- Add a new column
ALTER TABLE Sales.Customers
ADD BirthDate DATE;

-- Modify a column (increase size)
ALTER TABLE Sales.Customers
ALTER COLUMN Country NVARCHAR(100);

-- Add a new constraint
ALTER TABLE Sales.Customers
ADD CONSTRAINT CHK_CustomerScore CHECK (Score >= 0);

/* =======================
   4. DROP CONSTRAINT
==========================*/
ALTER TABLE Sales.Customers
DROP CONSTRAINT CHK_CustomerScore;

/* =======================
   5. DROP TABLE
==========================*/
DROP TABLE IF EXISTS Sales.Orders;
DROP TABLE IF EXISTS Sales.Customers;

