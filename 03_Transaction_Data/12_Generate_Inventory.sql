/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 11_Generate_Inventory.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script generates realistic inventory records for every Product
across every Store.

Generation Logic:
    • One Inventory record per Product per Store
    • Random QuantityInStock
    • Random LastRestockedDate
    • Prevents duplicate Product-Store combinations
    • Supports inventory analytics and reporting

Expected Records:
    Products : 484
    Stores   : 20
    Inventory: 9,680

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Inventory Data Generation...';
PRINT '==============================================================';

/*==============================================================================
                    Part 2 : Variable Declaration
==============================================================================*/

------------------------------------------------------------
-- Execution Tracking
------------------------------------------------------------

DECLARE @StartTime DATETIME2 = SYSDATETIME();

------------------------------------------------------------
-- Processing Variables
------------------------------------------------------------

DECLARE @StoreID INT;
DECLARE @ProductID INT;

------------------------------------------------------------
-- Inventory Variables
------------------------------------------------------------

DECLARE @QuantityInStock INT;
DECLARE @LastRestockedDate DATETIME2;

------------------------------------------------------------
-- Randomization Variables
------------------------------------------------------------

DECLARE @RandomNumber INT;
DECLARE @RestockDays INT;

------------------------------------------------------------
-- Validation Variables
------------------------------------------------------------

DECLARE @TotalProducts INT;
DECLARE @TotalStores INT;

/*==============================================================================
                    Part 3 : Data Cleanup
==============================================================================*/

------------------------------------------------------------
-- Remove Existing Inventory Data
------------------------------------------------------------

DELETE FROM dbo.Inventory;

DBCC CHECKIDENT
(
    'dbo.Inventory',
    RESEED,
    0
);

PRINT '==============================================================';
PRINT 'Previous Inventory data cleared successfully.';
PRINT '==============================================================';

------------------------------------------------------------
-- Drop Temporary Tables (if they exist)
------------------------------------------------------------

DROP TABLE IF EXISTS #Products;
DROP TABLE IF EXISTS #Stores;

PRINT '==============================================================';
PRINT 'Temporary tables dropped successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Load Reference Data
==============================================================================*/

/*------------------------------------------------------------
                Part 4.1 : Load Products
------------------------------------------------------------*/

------------------------------------------------------------
-- Temporary Table
------------------------------------------------------------

CREATE TABLE #Products
(
    ProductID INT
);

------------------------------------------------------------
-- Load Products
------------------------------------------------------------

INSERT INTO #Products
(
    ProductID
)
SELECT
    ProductID
FROM dbo.Product;

------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT @TotalProducts = COUNT(*)
FROM #Products;

PRINT CONCAT
(
    'Products Loaded : ',
    @TotalProducts
);

PRINT 'Products loaded successfully.';

/*------------------------------------------------------------
                Part 4.2 : Load Stores
------------------------------------------------------------*/

------------------------------------------------------------
-- Temporary Table
------------------------------------------------------------

CREATE TABLE #Stores
(
    StoreID INT
);

------------------------------------------------------------
-- Load Stores
------------------------------------------------------------

INSERT INTO #Stores
(
    StoreID
)
SELECT
    StoreID
FROM dbo.Store;

------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT @TotalStores = COUNT(*)
FROM #Stores;

PRINT CONCAT
(
    'Stores Loaded : ',
    @TotalStores
);

PRINT 'Stores loaded successfully.';

/*==============================================================================
                    Part 5 : Inventory Generation
==============================================================================*/

/*------------------------------------------------------------
                Part 5.1 : Store Processing Loop
------------------------------------------------------------*/

------------------------------------------------------------
-- Store Cursor
------------------------------------------------------------

DECLARE StoreCursor CURSOR FAST_FORWARD
FOR
SELECT
    StoreID
FROM #Stores
ORDER BY StoreID;

OPEN StoreCursor;

FETCH NEXT FROM StoreCursor
INTO @StoreID;

WHILE @@FETCH_STATUS = 0
BEGIN

    /*------------------------------------------------------------
                Part 5.2 : Product Processing Loop
	------------------------------------------------------------*/
	
	------------------------------------------------------------
	-- Product Cursor
	------------------------------------------------------------
	
	DECLARE ProductCursor CURSOR FAST_FORWARD
	FOR
	SELECT
		ProductID
	FROM #Products
	ORDER BY ProductID;
	
	OPEN ProductCursor;
	
	FETCH NEXT FROM ProductCursor
	INTO @ProductID;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		/*------------------------------------------------------------
                Part 5.3 : Generate Inventory Details
		------------------------------------------------------------*/
		
		------------------------------------------------------------
		-- Generate Random Number (1 - 100)
		------------------------------------------------------------
		
		SET @RandomNumber =
			FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1;
		
		------------------------------------------------------------
		-- Generate Quantity In Stock
		------------------------------------------------------------
		
		IF @RandomNumber <= 15
		BEGIN
			-- Low Stock (15%)
			SET @QuantityInStock =
				FLOOR(RAND(CHECKSUM(NEWID())) * 21);
		END
		ELSE IF @RandomNumber <= 50
		BEGIN
			-- Medium Stock (35%)
			SET @QuantityInStock =
				FLOOR(RAND(CHECKSUM(NEWID())) * 80) + 21;
		END
		ELSE IF @RandomNumber <= 85
		BEGIN
			-- High Stock (35%)
			SET @QuantityInStock =
				FLOOR(RAND(CHECKSUM(NEWID())) * 200) + 101;
		END
		ELSE
		BEGIN
			-- Very High Stock (15%)
			SET @QuantityInStock =
				FLOOR(RAND(CHECKSUM(NEWID())) * 300) + 301;
		END;
		
		------------------------------------------------------------
		-- Generate Last Restocked Date
		------------------------------------------------------------
		
		SET @RestockDays =
			FLOOR(RAND(CHECKSUM(NEWID())) * 181);
		
		SET @LastRestockedDate =
			DATEADD
			(
				DAY,
				-@RestockDays,
				SYSDATETIME()
			);
		
/*------------------------------------------------------------
                Part 5.4 : Insert Inventory
------------------------------------------------------------*/

------------------------------------------------------------
-- Insert Inventory Record
------------------------------------------------------------

INSERT INTO dbo.Inventory
(
    ProductID,
    StoreID,
    QuantityInStock,
    LastRestockedDate
)
VALUES
(
    @ProductID,
    @StoreID,
    @QuantityInStock,
    @LastRestockedDate
);

------------------------------------------------------------
-- Next Product
------------------------------------------------------------

FETCH NEXT FROM ProductCursor
INTO @ProductID;

END

CLOSE ProductCursor;
DEALLOCATE ProductCursor;

------------------------------------------------------------
-- Next Store
------------------------------------------------------------

FETCH NEXT FROM StoreCursor
INTO @StoreID;

END

CLOSE StoreCursor;
DEALLOCATE StoreCursor;

PRINT '==============================================================';
PRINT 'Inventory Generation Completed Successfully.';
PRINT '==============================================================';		


/*==============================================================================
                    Part 6 : Validation
==============================================================================*/

------------------------------------------------------------
-- Total Inventory Records Generated
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalInventoryRecords
FROM dbo.Inventory;

------------------------------------------------------------
-- Total Products
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalProducts
FROM dbo.Product;

------------------------------------------------------------
-- Total Stores
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalStores
FROM dbo.Store;

------------------------------------------------------------
-- Expected Inventory Records
------------------------------------------------------------

SELECT
    (
        (SELECT COUNT(*) FROM dbo.Product)
        *
        (SELECT COUNT(*) FROM dbo.Store)
    ) AS ExpectedInventoryRecords;

------------------------------------------------------------
-- Duplicate Product-Store Combination
------------------------------------------------------------

SELECT
    ProductID,
    StoreID,
    COUNT(*) AS DuplicateCount
FROM dbo.Inventory
GROUP BY
    ProductID,
    StoreID
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Negative Inventory Check
------------------------------------------------------------

SELECT
    COUNT(*) AS NegativeInventoryRecords
FROM dbo.Inventory
WHERE QuantityInStock < 0;

------------------------------------------------------------
-- Inventory Summary
------------------------------------------------------------

SELECT
    MIN(QuantityInStock) AS MinimumStock,
    MAX(QuantityInStock) AS MaximumStock,
    AVG(CAST(QuantityInStock AS DECIMAL(10,2))) AS AverageStock
FROM dbo.Inventory;

------------------------------------------------------------
-- Inventory Distribution By Store
------------------------------------------------------------

SELECT
    StoreID,
    COUNT(*) AS TotalProducts,
    SUM(QuantityInStock) AS TotalStock
FROM dbo.Inventory
GROUP BY StoreID
ORDER BY StoreID;

------------------------------------------------------------
-- Sample Inventory Records
------------------------------------------------------------

SELECT TOP (10)
    InventoryID,
    ProductID,
    StoreID,
    QuantityInStock,
    LastRestockedDate
FROM dbo.Inventory
ORDER BY InventoryID;

PRINT '==============================================================';
PRINT 'Inventory Data Validation Completed Successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '11_Generate_Inventory.sql executed successfully.';
PRINT 'Inventory generated successfully.';
PRINT '==============================================================';