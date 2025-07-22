/* ==============================================================================
   SQL Indexing
-------------------------------------------------------------------------------
   This script demonstrates various index types in SQL Server, including:
   - Clustered, non-clustered, and composite indexes
   - Columnstore, unique, and filtered indexes
   - Index monitoring and maintenance (usage, missing, duplicate, fragmentation)

   Table of Contents:
     1. Clustered & Non-Clustered Indexes
     2. Leftmost Prefix Rule
     3. Columnstore Indexes
     4. Unique Indexes
     5. Filtered Indexes
     6. Index Monitoring
     7. Index Maintenance
===============================================================================*/

/* ==============================================================================
   1. CLUSTERED & NON-CLUSTERED INDEXES
===============================================================================*/

-- Create a heap table (no clustered index)
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers;

-- Create a clustered index on CustomerID
CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID);

-- Create non-clustered indexes
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName);

CREATE NONCLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName);

-- Create a composite (multi-column) index on Country and Score
CREATE NONCLUSTERED INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score);

/* ==============================================================================
   2. LEFTMOST PREFIX RULE
-------------------------------------------------------------------------------
   A composite index on (A, B, C, D) works for:
     - A
     - A, B
     - A, B, C
   but not for:
     - B
     - A, C
     - A, B, D
===============================================================================*/

/* ==============================================================================
   3. COLUMNSTORE INDEXES
===============================================================================*/

-- Create a clustered columnstore index
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers;

-- Create a non-clustered columnstore index
CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers (FirstName);

/* ==============================================================================
   4. UNIQUE INDEXES
===============================================================================*/

-- Unique index on Product column (fails if duplicates exist)
CREATE UNIQUE INDEX idx_Products_Product
ON Sales.Products (Product);

-- Test: Attempt to insert a duplicate (should fail)
-- INSERT INTO Sales.Products (ProductID, Product) VALUES (106, 'Caps');

/* ==============================================================================
   5. FILTERED INDEXES
===============================================================================*/

-- Create a filtered index for USA customers
CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA';

/* ==============================================================================
   6. INDEX MONITORING
===============================================================================*/

-- List all indexes on a specific table
EXEC sp_helpindex 'Sales.DBCustomers';

-- Monitor index usage
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    idx.type_desc AS IndexType,
    s.user_seeks AS UserSeeks,
    s.user_scans AS UserScans,
    s.user_updates AS UserUpdates,
    s.last_user_seek
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = idx.object_id AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name;

-- Missing indexes
SELECT * FROM sys.dm_db_missing_index_details;

-- Duplicate indexes
SELECT  
	tbl.name AS TableName,
	col.name AS IndexColumn,
	idx.name AS IndexName,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) AS ColumnCount
FROM sys.indexes idx
JOIN sys.tables tbl ON idx.object_id = tbl.object_id
JOIN sys.index_columns ic ON idx.object_id = ic.object_id AND idx.index_id = ic.index_id
JOIN sys.columns col ON ic.object_id = col.object_id AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC;

/* ==============================================================================
   7. INDEX MAINTENANCE
===============================================================================*/

-- Update statistics for all tables
EXEC sp_updatestats;

-- Check fragmentation
SELECT 
    tbl.name AS TableName,
    idx.name AS IndexName,
    s.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
INNER JOIN sys.tables tbl ON s.object_id = tbl.object_id
INNER JOIN sys.indexes idx ON idx.object_id = s.object_id AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC;

-- Reorganize a fragmented index
ALTER INDEX idx_Customers_Country ON Sales.Customers REORGANIZE;

-- Rebuild a fragmented index
ALTER INDEX idx_Customers_Country ON Sales.Customers REBUILD;
GO
