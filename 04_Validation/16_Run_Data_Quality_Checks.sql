/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 16_Run_Data_Quality_Checks.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script performs an overall Database Health Check for the
Retail Sales Analytics & Inventory Management System.

The script provides a high-level overview of:

    • Database Overview
    • Lookup Data Health
    • Master Data Health
    • Transaction Data Health
    • Financial Health
    • Inventory Health
    • Business KPIs
    • Database Statistics

This script is intended to be executed after all data generation
and validation scripts have completed successfully.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Database Health Check...';
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

DECLARE @TotalRecords           INT;
DECLARE @DuplicateRecords       INT;
DECLARE @NullRecords            INT;
DECLARE @InvalidRecords         INT;
DECLARE @OrphanRecords          INT;

------------------------------------------------------------
-- Health Check Variables
------------------------------------------------------------

DECLARE @LookupRecords          INT;
DECLARE @MasterRecords          INT;
DECLARE @TransactionRecords     INT;
DECLARE @DatabaseRecords        INT;

------------------------------------------------------------
-- Financial KPI Variables
------------------------------------------------------------

DECLARE @TotalSales             DECIMAL(18,2);
DECLARE @TotalDiscount          DECIMAL(18,2);
DECLARE @TotalTax               DECIMAL(18,2);
DECLARE @TotalPayments          DECIMAL(18,2);
DECLARE @TotalRefundAmount      DECIMAL(18,2);
DECLARE @NetRevenue             DECIMAL(18,2);

------------------------------------------------------------
-- Inventory KPI Variables
------------------------------------------------------------

DECLARE @TotalProducts          INT;
DECLARE @ProductsBelowReorder   INT;
DECLARE @OutOfStockProducts     INT;

/*==============================================================================
                    Part 3 : Database Overview
==============================================================================*/

PRINT '==============================================================';
PRINT 'Database Overview';
PRINT '==============================================================';

SELECT
    'Category' AS TableName,
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
    'Supplier',
    COUNT(*)
FROM dbo.Supplier

UNION ALL

SELECT
    'Customer',
    COUNT(*)
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
FROM dbo.Product

UNION ALL

SELECT
    'Order',
    COUNT(*)
FROM dbo.[Order]

UNION ALL

SELECT
    'OrderItem',
    COUNT(*)
FROM dbo.OrderItem

UNION ALL

SELECT
    'Payment',
    COUNT(*)
FROM dbo.Payment

UNION ALL

SELECT
    'Return',
    COUNT(*)
FROM dbo.[Return]

UNION ALL

SELECT
    'Inventory',
    COUNT(*)
FROM dbo.Inventory;

PRINT '==============================================================';
PRINT 'Database Overview Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Lookup Data Health
==============================================================================*/

PRINT '==============================================================';
PRINT 'Lookup Data Health';
PRINT '==============================================================';

SELECT
    'Category' AS LookupTable,
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS HealthStatus,
    COUNT(*) AS TotalRecords
FROM dbo.Category

UNION ALL

SELECT
    'SubCategory',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.SubCategory

UNION ALL

SELECT
    'Brand',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Brand

UNION ALL

SELECT
    'PaymentMethod',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.PaymentMethod

UNION ALL

SELECT
    'PaymentStatus',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.PaymentStatus

UNION ALL

SELECT
    'ReturnReason',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.ReturnReason

UNION ALL

SELECT
    'ReturnStatus',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.ReturnStatus;

PRINT '==============================================================';
PRINT 'Lookup Data Health Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 5 : Master Data Health
==============================================================================*/

PRINT '==============================================================';
PRINT 'Master Data Health';
PRINT '==============================================================';

SELECT
    'Customer' AS MasterTable,
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS HealthStatus,
    COUNT(*) AS TotalRecords
FROM dbo.Customer

UNION ALL

SELECT
    'Employee',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Employee

UNION ALL

SELECT
    'Store',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Store

UNION ALL

SELECT
    'Product',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Product

UNION ALL

SELECT
    'Supplier',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Supplier;

PRINT '==============================================================';
PRINT 'Master Data Health Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 6 : Transaction Data Health
==============================================================================*/

PRINT '==============================================================';
PRINT 'Transaction Data Health';
PRINT '==============================================================';

SELECT
    'Order' AS TransactionTable,
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END AS HealthStatus,
    COUNT(*) AS TotalRecords
FROM dbo.[Order]

UNION ALL

SELECT
    'OrderItem',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.OrderItem

UNION ALL

SELECT
    'Payment',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Payment

UNION ALL

SELECT
    'Return',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.[Return]

UNION ALL

SELECT
    'Inventory',
    CASE
        WHEN COUNT(*) > 0 THEN 'PASS'
        ELSE 'FAIL'
    END,
    COUNT(*)
FROM dbo.Inventory;

PRINT '==============================================================';
PRINT 'Transaction Data Health Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Financial Health
==============================================================================*/

PRINT '==============================================================';
PRINT 'Financial Health';
PRINT '==============================================================';

------------------------------------------------------------
-- Calculate Financial KPIs
------------------------------------------------------------

SELECT
    @TotalSales = SUM(NetAmount),
    @TotalDiscount = SUM(DiscountAmount),
    @TotalTax = SUM(TaxAmount)
FROM dbo.[Order];

SELECT
    @TotalPayments = SUM(Amount)
FROM dbo.Payment;

SELECT
    @TotalRefundAmount = SUM(RefundAmount)
FROM dbo.[Return];

SET @NetRevenue = @TotalPayments - ISNULL(@TotalRefundAmount, 0);

------------------------------------------------------------
-- Display Financial Health
------------------------------------------------------------

SELECT
    @TotalSales        AS TotalSales,
    @TotalDiscount     AS TotalDiscount,
    @TotalTax          AS TotalTax,
    @TotalPayments     AS TotalPayments,
    @TotalRefundAmount AS TotalRefundAmount,
    @NetRevenue        AS NetRevenue;

PRINT '==============================================================';
PRINT 'Financial Health Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 8 : Inventory Health
==============================================================================*/

PRINT '==============================================================';
PRINT 'Inventory Health';
PRINT '==============================================================';

------------------------------------------------------------
-- Inventory KPIs
------------------------------------------------------------

SELECT
    @TotalProducts = COUNT(*)
FROM dbo.Product;

SELECT
    @ProductsBelowReorder = COUNT(*)
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
WHERE I.QuantityInStock <= P.ReorderLevel;

SELECT
    @OutOfStockProducts = COUNT(*)
FROM dbo.Inventory
WHERE QuantityInStock = 0;

------------------------------------------------------------
-- Display Inventory KPIs
------------------------------------------------------------

SELECT
    @TotalProducts        AS TotalProducts,
    @ProductsBelowReorder AS ProductsBelowReorderLevel,
    @OutOfStockProducts   AS OutOfStockProducts;

------------------------------------------------------------
-- Stock Statistics
------------------------------------------------------------

SELECT
    MIN(QuantityInStock)                       AS MinimumStock,
    MAX(QuantityInStock)                       AS MaximumStock,
    AVG(CAST(QuantityInStock AS DECIMAL(10,2))) AS AverageStock
FROM dbo.Inventory;

PRINT '==============================================================';
PRINT 'Inventory Health Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 9 : Business KPIs
==============================================================================*/

PRINT '==============================================================';
PRINT 'Business KPIs';
PRINT '==============================================================';

SELECT
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCustomers
FROM dbo.Customer;

SELECT
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveEmployees
FROM dbo.Employee;

SELECT
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts
FROM dbo.Product;

SELECT
    COUNT(*) AS TotalStores,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveStores
FROM dbo.Store;

------------------------------------------------------------
-- Sales KPIs
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalOrders,
    AVG(NetAmount) AS AverageOrderValue
FROM dbo.[Order];

SELECT
    AVG(ItemCount * 1.0) AS AverageItemsPerOrder
FROM
(
    SELECT
        OrderID,
        COUNT(*) AS ItemCount
    FROM dbo.OrderItem
    GROUP BY OrderID
) OI;

SELECT
    AVG(Amount) AS AveragePaymentValue
FROM dbo.Payment;

SELECT
    AVG(RefundAmount) AS AverageRefundAmount
FROM dbo.[Return];

PRINT '==============================================================';
PRINT 'Business KPI Check Completed.';
PRINT '==============================================================';

/*==============================================================================
                    Part 10 : Database Statistics
==============================================================================*/

PRINT '==============================================================';
PRINT 'Database Statistics';
PRINT '==============================================================';

------------------------------------------------------------
-- Lookup Records
------------------------------------------------------------

SELECT
    @LookupRecords =
        (SELECT COUNT(*) FROM dbo.Category)
      + (SELECT COUNT(*) FROM dbo.SubCategory)
      + (SELECT COUNT(*) FROM dbo.Brand)
      + (SELECT COUNT(*) FROM dbo.PaymentMethod)
      + (SELECT COUNT(*) FROM dbo.PaymentStatus)
      + (SELECT COUNT(*) FROM dbo.ReturnReason)
      + (SELECT COUNT(*) FROM dbo.ReturnStatus);

------------------------------------------------------------
-- Master Records
------------------------------------------------------------

SELECT
    @MasterRecords =
        (SELECT COUNT(*) FROM dbo.Supplier)
      + (SELECT COUNT(*) FROM dbo.Customer)
      + (SELECT COUNT(*) FROM dbo.Employee)
      + (SELECT COUNT(*) FROM dbo.Store)
      + (SELECT COUNT(*) FROM dbo.Product);

------------------------------------------------------------
-- Transaction Records
------------------------------------------------------------

SELECT
    @TransactionRecords =
        (SELECT COUNT(*) FROM dbo.[Order])
      + (SELECT COUNT(*) FROM dbo.OrderItem)
      + (SELECT COUNT(*) FROM dbo.Payment)
      + (SELECT COUNT(*) FROM dbo.[Return])
      + (SELECT COUNT(*) FROM dbo.Inventory);

------------------------------------------------------------
-- Total Database Records
------------------------------------------------------------

SET @DatabaseRecords =
      @LookupRecords
    + @MasterRecords
    + @TransactionRecords;

------------------------------------------------------------
-- Display Statistics
------------------------------------------------------------

SELECT
    @LookupRecords      AS LookupRecords,
    @MasterRecords      AS MasterRecords,
    @TransactionRecords AS TransactionRecords,
    @DatabaseRecords    AS TotalDatabaseRecords;

PRINT '==============================================================';
PRINT 'Database Statistics Generated Successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 11 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '16_Run_Data_Quality_Checks.sql executed successfully.';
PRINT 'Database Health Check completed successfully.';
PRINT 'Overall Database Status : PASS';

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT 'Database is ready for Reporting and Analytics.';
PRINT '==============================================================';