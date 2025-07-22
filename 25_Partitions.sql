/* ==============================================================================
   SQL Partitioning
-------------------------------------------------------------------------------
   This script demonstrates how to implement partitioning in SQL Server, 
   including partition functions, schemes, filegroups, and verifying partitioned data.

   Table of Contents:
     1. Create a Partition Function
     2. Create Filegroups
     3. Create Data Files
     4. Create Partition Scheme
     5. Create the Partitioned Table
     6. Insert Data Into the Partitioned Table
     7. Verify Partitioning and Compare Execution Plans
===============================================================================*/

/* ==============================================================================
   1. CREATE A PARTITION FUNCTION
===============================================================================*/

-- Left-range partition based on OrderDate
CREATE PARTITION FUNCTION PartitionByYear (DATE)
AS RANGE LEFT FOR VALUES ('2023-12-31', '2024-12-31', '2025-12-31');

-- Verify existing partition functions
SELECT 
    name, function_id, type_desc, boundary_value_on_right
FROM sys.partition_functions;

/* ==============================================================================
   2. CREATE FILEGROUPS
===============================================================================*/

ALTER DATABASE SalesDB ADD FILEGROUP FG_2023;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2024;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2025;
ALTER DATABASE SalesDB ADD FILEGROUP FG_2026;

-- Verify existing filegroups
SELECT * 
FROM sys.filegroups
WHERE type = 'FG';

/* ==============================================================================
   3. CREATE DATA FILES
===============================================================================*/

ALTER DATABASE SalesDB ADD FILE
(
    NAME = P_2023,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2023.ndf'
) TO FILEGROUP FG_2023;

ALTER DATABASE SalesDB ADD FILE
(
    NAME = P_2024,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2024.ndf'
) TO FILEGROUP FG_2024;

ALTER DATABASE SalesDB ADD FILE
(
    NAME = P_2025,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2025.ndf'
) TO FILEGROUP FG_2025;

ALTER DATABASE SalesDB ADD FILE
(
    NAME = P_2026,
    FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\P_2026.ndf'
) TO FILEGROUP FG_2026;

-- Verify data files
SELECT 
    fg.name AS FilegroupName,
    mf.name AS LogicalFileName,
    mf.physical_name AS PhysicalFilePath,
    mf.size / 128 AS SizeInMB
FROM sys.filegroups fg
JOIN sys.master_files mf ON fg.data_space_id = mf.data_space_id
WHERE mf.database_id = DB_ID('SalesDB');

/* ==============================================================================
   4. CREATE PARTITION SCHEME
===============================================================================*/

CREATE PARTITION SCHEME SchemePartitionByYear
AS PARTITION PartitionByYear
TO (FG_2023, FG_2024, FG_2025, FG_2026);

-- Verify partition schemes
SELECT 
    ps.name AS PartitionSchemeName,
    pf.name AS PartitionFunctionName,
    ds.destination_id AS PartitionNumber,
    fg.name AS FilegroupName
FROM sys.partition_schemes ps
JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
JOIN sys.destination_data_spaces ds ON ps.data_space_id = ds.partition_scheme_id
JOIN sys.filegroups fg ON ds.data_space_id = fg.data_space_id;

/* ==============================================================================
   5. CREATE THE PARTITIONED TABLE
===============================================================================*/

CREATE TABLE Sales.Orders_Partitioned 
(
    OrderID INT,
    OrderDate DATE,
    Sales INT
) ON SchemePartitionByYear (OrderDate);

/* ==============================================================================
   6. INSERT DATA INTO THE PARTITIONED TABLE
===============================================================================*/

INSERT INTO Sales.Orders_Partitioned VALUES (1, '2023-05-15', 100);
INSERT INTO Sales.Orders_Partitioned VALUES (2, '2024-07-20', 50);
INSERT INTO Sales.Orders_Partitioned VALUES (3, '2025-12-31', 20);
INSERT INTO Sales.Orders_Partitioned VALUES (4, '2026-01-01', 100);

/* ==============================================================================
   7. VERIFY PARTITIONING & COMPARE EXECUTION PLANS
===============================================================================*/

-- Verify partitioned rows and assigned filegroups
SELECT 
    p.partition_number AS PartitionNumber,
    f.name AS PartitionFilegroup, 
    p.rows AS NumberOfRows
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(p.object_id) = 'Orders_Partitioned';

-- Non-partitioned copy for comparison
SELECT *
INTO Sales.Orders_NoPartition
FROM Sales.Orders_Partitioned;

-- Query on partitioned table
SELECT *
FROM Sales.Orders_Partitioned
WHERE OrderDate IN ('2026-01-01', '2025-12-31');

-- Query on non-partitioned table
SELECT *
FROM Sales.Orders_NoPartition
WHERE OrderDate IN ('2026-01-01', '2025-12-31');
