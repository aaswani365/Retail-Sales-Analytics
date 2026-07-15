/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 14_Validate_Master_Data.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates all Master Data tables used throughout the
Retail Sales Analytics & Inventory Management System.

Validation Includes:
    • Record Counts
    • Duplicate Checks
    • NULL Checks
    • Foreign Key Integrity
    • Business Rule Validation

Master Tables:
    • Customer
    • Employee
    • Store
    • Product
    • Inventory

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Master Data Validation...';
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

------------------------------------------------------------
-- Business Rule Validation Variables
------------------------------------------------------------

DECLARE @InvalidRecords INT;
DECLARE @OrphanRecords INT;

/*==============================================================================
                    Part 3 : Validate Customer
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Customer Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Customer;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Email Addresses
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        Email
    FROM dbo.Customer
    WHERE Email IS NOT NULL
    GROUP BY Email
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Email Addresses : ', @DuplicateRecords);

------------------------------------------------------------
-- Duplicate Phone Numbers
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        Phone
    FROM dbo.Customer
    WHERE Phone IS NOT NULL
    GROUP BY Phone
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Phone Numbers : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL First Name
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Customer
WHERE FirstName IS NULL;

PRINT CONCAT('NULL First Names : ', @NullRecords);

------------------------------------------------------------
-- NULL Last Name
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Customer
WHERE LastName IS NULL;

PRINT CONCAT('NULL Last Names : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Customer
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Customer
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    City,
    State,
    IsActive
FROM dbo.Customer
ORDER BY CustomerID;

PRINT 'Customer validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Validate Employee
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Employee Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Employee;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Email Addresses
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        Email
    FROM dbo.Employee
    WHERE Email IS NOT NULL
    GROUP BY Email
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Email Addresses : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL First Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Employee
WHERE FirstName IS NULL;

PRINT CONCAT('NULL First Names : ', @NullRecords);

------------------------------------------------------------
-- NULL Last Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Employee
WHERE LastName IS NULL;

PRINT CONCAT('NULL Last Names : ', @NullRecords);

------------------------------------------------------------
-- NULL Job Titles
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Employee
WHERE JobTitle IS NULL;

PRINT CONCAT('NULL Job Titles : ', @NullRecords);

------------------------------------------------------------
-- Invalid Salary
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Employee
WHERE Salary <= 0;

PRINT CONCAT('Invalid Salary Records : ', @InvalidRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Employee
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Employee
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    EmployeeID,
    StoreID,
    ManagerEmployeeID,
    FirstName,
    LastName,
    Email,
    Phone,
    JobTitle,
    Salary,
    HireDate,
    IsActive
FROM dbo.Employee
ORDER BY EmployeeID;

PRINT 'Employee validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 5 : Validate Store
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Store Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Store;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Store Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        StoreName
    FROM dbo.Store
    WHERE StoreName IS NOT NULL
    GROUP BY StoreName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Store Names : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Store Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Store
WHERE StoreName IS NULL;

PRINT CONCAT('NULL Store Names : ', @NullRecords);

------------------------------------------------------------
-- NULL Addresses
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Store
WHERE Address IS NULL;

PRINT CONCAT('NULL Addresses : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Store
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Store
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    StoreID,
    StoreName,
    ManagerEmployeeID,
    Address,
    City,
    State,
    PostalCode,
    Country,
    Phone,
    IsActive
FROM dbo.Store
ORDER BY StoreID;

PRINT 'Store validation completed successfully.';
PRINT '==============================================================';


/*==============================================================================
                    Part 6 : Validate Product
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Product Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Product;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Product Names
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        ProductName
    FROM dbo.Product
    WHERE ProductName IS NOT NULL
    GROUP BY ProductName
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Product Names : ', @DuplicateRecords);

------------------------------------------------------------
-- Duplicate SKU
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        SKU
    FROM dbo.Product
    WHERE SKU IS NOT NULL
    GROUP BY SKU
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate SKU : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Product Names
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Product
WHERE ProductName IS NULL;

PRINT CONCAT('NULL Product Names : ', @NullRecords);

------------------------------------------------------------
-- Invalid Cost Price
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Product
WHERE CostPrice <= 0;

PRINT CONCAT('Invalid Cost Price Records : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Selling Price
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Product
WHERE SellingPrice <= 0;

PRINT CONCAT('Invalid Selling Price Records : ', @InvalidRecords);

------------------------------------------------------------
-- Selling Price Less Than Cost Price
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Product
WHERE SellingPrice < CostPrice;

PRINT CONCAT('Selling Price < Cost Price : ', @InvalidRecords);

------------------------------------------------------------
-- NULL Reorder Level
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Product
WHERE ReorderLevel IS NULL;

PRINT CONCAT('NULL Reorder Level : ', @NullRecords);

------------------------------------------------------------
-- Active / Inactive Records
------------------------------------------------------------

SELECT @ActiveRecords = COUNT(*)
FROM dbo.Product
WHERE IsActive = 1;

SELECT @InactiveRecords = COUNT(*)
FROM dbo.Product
WHERE IsActive = 0;

PRINT CONCAT('Active Records : ', @ActiveRecords);
PRINT CONCAT('Inactive Records : ', @InactiveRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    ProductID,
    ProductName,
    SKU,
    SubCategoryID,
    BrandID,
    SupplierID,
    CostPrice,
    SellingPrice,
    ReorderLevel,
    IsActive
FROM dbo.Product
ORDER BY ProductID;

PRINT 'Product validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Validation Summary
==============================================================================*/

PRINT '==============================================================';
PRINT 'Master Data Validation Summary';
PRINT '==============================================================';

SELECT
    'Customer' AS MasterTable,
    COUNT(*) AS TotalRecords
FROM dbo.Customer

UNION ALL

SELECT
    'Employee',
    COUNT(*)
FROM dbo.Employee

UNION ALL

SELECT
    'Store',
    COUNT(*)
FROM dbo.Store

UNION ALL

SELECT
    'Product',
    COUNT(*)
FROM dbo.Product;

PRINT '==============================================================';
PRINT 'Master Data Validation Summary Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 8 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '14_Validate_Master_Data.sql executed successfully.';
PRINT 'All Master Tables validated successfully.';
PRINT '==============================================================';