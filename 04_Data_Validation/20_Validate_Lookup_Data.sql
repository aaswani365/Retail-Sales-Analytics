/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 20_Validate_Lookup_Data.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates all Lookup Tables used throughout the
Retail Sales Analytics & Inventory Management System.

Validation Includes:
    • Record Counts
    • Duplicate Names
    • NULL Checks
    • Active Status Checks

Lookup Tables:
    • Category
	• SubCategory
    • Brand
    • PaymentMethod
    • PaymentStatus
    • ReturnReason
    • ReturnStatus
==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Lookup Data Validation...';
PRINT '==============================================================';

/*==============================================================================
                    Part 2 : Variable Declaration
==============================================================================*/

------------------------------------------------------------
-- Execution Tracking
------------------------------------------------------------

DECLARE @StartTime DATETIME2 = SYSDATETIME();

------------------------------------------------------------
-- Validation Variables
------------------------------------------------------------

DECLARE @TotalRecords INT;
DECLARE @DuplicateRecords INT;
DECLARE @NullRecords INT;
DECLARE @ActiveRecords INT;
DECLARE @InactiveRecords INT;

/*------------------------------------------------------------
                Part 3.1 : Validate Category
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating Category Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Category;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Category Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        CategoryName
    FROM dbo.Category
    GROUP BY CategoryName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Category Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Category Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Category
WHERE CategoryName IS NULL;

PRINT CONCAT('NULL Category Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Category
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Category
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    CategoryID,
    CategoryName,
    Description,
    IsActive
FROM dbo.Category
ORDER BY CategoryID;

PRINT 'Category validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.2 : Validate SubCategory
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating SubCategory Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.SubCategory;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate SubCategory Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        SubCategoryName
    FROM dbo.SubCategory
    WHERE SubCategoryName IS NOT NULL
    GROUP BY SubCategoryName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate SubCategory Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL SubCategory Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.SubCategory
WHERE SubCategoryName IS NULL;

PRINT CONCAT('NULL SubCategory Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.SubCategory
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.SubCategory
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    SubCategoryID,
    CategoryID,
    SubCategoryName,
    Description,
    IsActive
FROM dbo.SubCategory
ORDER BY SubCategoryID;

PRINT 'SubCategory validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.3 : Validate Brand
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating Brand Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Brand;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Brand Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        BrandName
    FROM dbo.Brand
    GROUP BY BrandName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Brand Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Brand Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Brand
WHERE BrandName IS NULL;

PRINT CONCAT('NULL Brand Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Brand
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Brand
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    BrandID,
    BrandName,
    Description,
    IsActive
FROM dbo.Brand
ORDER BY BrandID;

PRINT 'Brand validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.4 : Validate Payment Method
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating PaymentMethod Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.PaymentMethod;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Payment Method Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        MethodName
    FROM dbo.PaymentMethod
    GROUP BY MethodName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Payment Method Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Payment Method Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.PaymentMethod
WHERE MethodName IS NULL;

PRINT CONCAT('NULL Payment Method Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.PaymentMethod
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.PaymentMethod
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    PaymentMethodID,
    MethodName,
    Description,
    IsActive
FROM dbo.PaymentMethod
ORDER BY PaymentMethodID;

PRINT 'PaymentMethod validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.5 : Validate Payment Status
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating PaymentStatus Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.PaymentStatus;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Payment Status Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        StatusName
    FROM dbo.PaymentStatus
    GROUP BY StatusName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Payment Status Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Payment Status Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.PaymentStatus
WHERE StatusName IS NULL;

PRINT CONCAT('NULL Payment Status Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.PaymentStatus
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.PaymentStatus
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    PaymentStatusID,
    StatusName,
    Description,
    IsActive
FROM dbo.PaymentStatus
ORDER BY PaymentStatusID;

PRINT 'PaymentStatus validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.6 : Validate Return Reason
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating ReturnReason Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.ReturnReason;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Return Reason Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        ReasonName
    FROM dbo.ReturnReason
    GROUP BY ReasonName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Return Reason Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Return Reason Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.ReturnReason
WHERE ReasonName IS NULL;

PRINT CONCAT('NULL Return Reason Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.ReturnReason
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.ReturnReason
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    ReturnReasonID,
    ReasonName,
    Description,
    IsActive
FROM dbo.ReturnReason
ORDER BY ReturnReasonID;

PRINT 'ReturnReason validation completed successfully.';
PRINT '==============================================================';

/*------------------------------------------------------------
                Part 3.7 : Validate Return Status
------------------------------------------------------------*/

PRINT '==============================================================';
PRINT 'Validating ReturnStatus Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.ReturnStatus;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Return Status Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        StatusName
    FROM dbo.ReturnStatus
    GROUP BY StatusName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Return Status Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Return Status Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.ReturnStatus
WHERE StatusName IS NULL;

PRINT CONCAT('NULL Return Status Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.ReturnStatus
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.ReturnStatus
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT
    ReturnStatusID,
    StatusName,
    Description,
    IsActive
FROM dbo.ReturnStatus
ORDER BY ReturnStatusID;

PRINT 'ReturnStatus validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Validation Summary
==============================================================================*/

PRINT '==============================================================';
PRINT 'Lookup Data Validation Summary';
PRINT '==============================================================';

SELECT
    'Category' AS LookupTable,
    COUNT(*) AS TotalRecords
FROM dbo.Category

UNION ALL

SELECT
	'SubCategory',
	COUNT(*)
FROM dbo.SubCategory

UNION ALL

SELECT
    'Brand',
    COUNT(*)
FROM dbo.Brand

UNION ALL

SELECT
    'PaymentMethod',
    COUNT(*)
FROM dbo.PaymentMethod

UNION ALL

SELECT
    'PaymentStatus',
    COUNT(*)
FROM dbo.PaymentStatus

UNION ALL

SELECT
    'ReturnReason',
    COUNT(*)
FROM dbo.ReturnReason

UNION ALL

SELECT
    'ReturnStatus',
    COUNT(*)
FROM dbo.ReturnStatus;

PRINT '==============================================================';
PRINT 'Lookup Data Validation Summary Completed.';
PRINT '==============================================================';


/*==============================================================================
                    Part 5 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '12_Validate_Lookup_Data.sql executed successfully.';
PRINT 'All Lookup Tables validated successfully.';
PRINT '==============================================================';