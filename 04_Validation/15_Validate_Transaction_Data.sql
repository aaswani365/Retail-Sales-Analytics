/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 15_Validate_Transaction_Data.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates all Transaction Data generated for the
Retail Sales Analytics & Inventory Management System.

Validation Includes:
    • Record Counts
    • Duplicate Checks
    • NULL Checks
    • Business Rule Validation
    • Financial Validation
    • Referential Integrity

Transaction Tables:
    • Order
    • OrderItem
    • Payment
    • Return
    • Inventory

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Transaction Data Validation...';
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
DECLARE @InvalidRecords INT;
DECLARE @OrphanRecords INT;

/*==============================================================================
                    Part 3 : Validate Order
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Order Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.[Order];

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Order Numbers
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        OrderNumber
    FROM dbo.[Order]
    WHERE OrderNumber IS NOT NULL
    GROUP BY OrderNumber
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Order Numbers : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Order Numbers
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.[Order]
WHERE OrderNumber IS NULL;

PRINT CONCAT('NULL Order Numbers : ', @NullRecords);

------------------------------------------------------------
-- Invalid SubTotal Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE SubTotalAmount < 0;

PRINT CONCAT('Invalid SubTotal Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Discount Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE DiscountAmount < 0;

PRINT CONCAT('Invalid Discount Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Tax Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE TaxAmount < 0;

PRINT CONCAT('Invalid Tax Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Net Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE NetAmount <= 0;

PRINT CONCAT('Invalid Net Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Net Amount Validation
-- NetAmount = SubTotalAmount - DiscountAmount + TaxAmount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE NetAmount <>
(
    SubTotalAmount
    - DiscountAmount
    + TaxAmount
);

PRINT CONCAT('Invalid Net Amount Calculation : ', @InvalidRecords);

------------------------------------------------------------
-- Future Order Dates
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Order]
WHERE OrderDate > SYSDATETIME();

PRINT CONCAT('Future Order Dates : ', @InvalidRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    OrderID,
    OrderNumber,
    CustomerID,
    StoreID,
    EmployeeID,
    OrderDate,
    SubTotalAmount,
    DiscountAmount,
    TaxAmount,
    NetAmount,
    OrderStatusID
FROM dbo.[Order]
ORDER BY OrderID;

PRINT 'Order validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Validate OrderItem
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating OrderItem Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.OrderItem;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Order-Product Combination
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        OrderID,
        ProductID
    FROM dbo.OrderItem
    GROUP BY
        OrderID,
        ProductID
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Order-Product Records : ', @DuplicateRecords);

------------------------------------------------------------
-- Invalid Quantity
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE Quantity <= 0;

PRINT CONCAT('Invalid Quantity : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Cost Price
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE CostPrice <= 0;

PRINT CONCAT('Invalid Cost Price : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Unit Price
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE UnitPrice <= 0;

PRINT CONCAT('Invalid Unit Price : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Discount Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE DiscountAmount < 0;

PRINT CONCAT('Invalid Discount Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Tax Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE TaxAmount < 0;

PRINT CONCAT('Invalid Tax Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Line Total
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE LineTotal <= 0;

PRINT CONCAT('Invalid Line Total : ', @InvalidRecords);

------------------------------------------------------------
-- Line Total Validation
-- LineTotal = (Quantity × UnitPrice)
--             - DiscountAmount
--             + TaxAmount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.OrderItem
WHERE LineTotal <>
(
    (Quantity * UnitPrice)
    - DiscountAmount
    + TaxAmount
);

PRINT CONCAT('Invalid Line Total Calculation : ', @InvalidRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    OrderItemID,
    OrderID,
    ProductID,
    Quantity,
    CostPrice,
    UnitPrice,
    DiscountAmount,
    TaxAmount,
    LineTotal
FROM dbo.OrderItem
ORDER BY OrderItemID;

PRINT 'OrderItem validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 5 : Validate Payment
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Payment Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Payment;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Invalid Payment Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Payment
WHERE Amount <= 0;

PRINT CONCAT('Invalid Payment Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Future Payment Dates
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Payment
WHERE PaymentDate > SYSDATETIME();

PRINT CONCAT('Future Payment Dates : ', @InvalidRecords);

------------------------------------------------------------
-- NULL Transaction Reference
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Payment
WHERE TransactionReference IS NULL;

PRINT CONCAT('NULL Transaction References : ', @NullRecords);

------------------------------------------------------------
-- Payment Before Order Date
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
WHERE P.PaymentDate < O.OrderDate;

PRINT CONCAT('Payments Before Order Date : ', @InvalidRecords);

------------------------------------------------------------
-- Payment Amount Validation
-- Payment Amount = Order NetAmount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
WHERE P.Amount <> O.NetAmount;

PRINT CONCAT('Payment Amount Mismatch : ', @InvalidRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    P.PaymentID,
    P.OrderID,
    P.PaymentMethodID,
    P.PaymentStatusID,
    P.PaymentDate,
    P.Amount,
    O.NetAmount,
    P.TransactionReference
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
ORDER BY P.PaymentID;

PRINT 'Payment validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 6 : Validate Return
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Return Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.[Return];

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Invalid Returned Quantity
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Return]
WHERE QuantityReturned <= 0;

PRINT CONCAT('Invalid Returned Quantity : ', @InvalidRecords);

------------------------------------------------------------
-- Invalid Refund Amount
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Return]
WHERE RefundAmount < 0;

PRINT CONCAT('Invalid Refund Amount : ', @InvalidRecords);

------------------------------------------------------------
-- Return Date Before Order Date
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
WHERE R.ReturnDate < O.OrderDate;

PRINT CONCAT('Returns Before Order Date : ', @InvalidRecords);

------------------------------------------------------------
-- Returned Quantity Greater Than Ordered Quantity
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
WHERE R.QuantityReturned > OI.Quantity;

PRINT CONCAT('Returned Quantity Exceeds Ordered Quantity : ', @InvalidRecords);

------------------------------------------------------------
-- Refund Amount Greater Than Line Total
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
WHERE R.RefundAmount > OI.LineTotal;

PRINT CONCAT('Refund Amount Exceeds Line Total : ', @InvalidRecords);

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    R.ReturnID,
    R.OrderItemID,
    R.ReturnReasonID,
    R.ReturnStatusID,
    R.ReturnDate,
    R.QuantityReturned,
    R.RefundAmount,
    OI.Quantity AS OrderedQuantity,
    OI.LineTotal
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
ORDER BY R.ReturnID;

PRINT 'Return validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Validate Inventory
==============================================================================*/

PRINT '==============================================================';
PRINT 'Validating Inventory Table...';
PRINT '==============================================================';

------------------------------------------------------------
-- Total Records
------------------------------------------------------------

SELECT @TotalRecords = COUNT(*)
FROM dbo.Inventory;

PRINT CONCAT('Total Records : ', @TotalRecords);

------------------------------------------------------------
-- Duplicate Product-Store Records
------------------------------------------------------------

SELECT @DuplicateRecords = COUNT(*)
FROM
(
    SELECT
        ProductID,
        StoreID
    FROM dbo.Inventory
    GROUP BY
        ProductID,
        StoreID
    HAVING COUNT(*) > 1
) D;

PRINT CONCAT('Duplicate Product-Store Records : ', @DuplicateRecords);

------------------------------------------------------------
-- NULL Quantity In Stock
------------------------------------------------------------

SELECT @NullRecords = COUNT(*)
FROM dbo.Inventory
WHERE QuantityInStock IS NULL;

PRINT CONCAT('NULL Quantity In Stock : ', @NullRecords);

------------------------------------------------------------
-- Negative Stock
------------------------------------------------------------

SELECT @InvalidRecords = COUNT(*)
FROM dbo.Inventory
WHERE QuantityInStock < 0;

PRINT CONCAT('Negative Stock Records : ', @InvalidRecords);

------------------------------------------------------------
-- Orphan Product Records
------------------------------------------------------------

SELECT @OrphanRecords = COUNT(*)
FROM dbo.Inventory I
LEFT JOIN dbo.Product P
    ON I.ProductID = P.ProductID
WHERE P.ProductID IS NULL;

PRINT CONCAT('Orphan Product Records : ', @OrphanRecords);

------------------------------------------------------------
-- Orphan Store Records
------------------------------------------------------------

SELECT @OrphanRecords = COUNT(*)
FROM dbo.Inventory I
LEFT JOIN dbo.Store S
    ON I.StoreID = S.StoreID
WHERE S.StoreID IS NULL;

PRINT CONCAT('Orphan Store Records : ', @OrphanRecords);

------------------------------------------------------------
-- Inventory Completeness
-- Expected Records = Products × Stores
------------------------------------------------------------

DECLARE @ExpectedInventoryRecords INT;

SELECT
    @ExpectedInventoryRecords =
        (SELECT COUNT(*) FROM dbo.Product)
        *
        (SELECT COUNT(*) FROM dbo.Store);

PRINT CONCAT('Expected Inventory Records : ', @ExpectedInventoryRecords);
PRINT CONCAT('Actual Inventory Records   : ', @TotalRecords);

------------------------------------------------------------
-- Stock Summary
------------------------------------------------------------

SELECT
    MIN(QuantityInStock) AS MinimumStock,
    MAX(QuantityInStock) AS MaximumStock,
    AVG(CAST(QuantityInStock AS DECIMAL(10,2))) AS AverageStock
FROM dbo.Inventory;

------------------------------------------------------------
-- Sample Data
------------------------------------------------------------

SELECT TOP (10)
    InventoryID,
    ProductID,
    StoreID,
    QuantityInStock,
    LastRestockedDate
FROM dbo.Inventory
ORDER BY InventoryID;

PRINT 'Inventory validation completed successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 8 : Validation Summary
==============================================================================*/

PRINT '==============================================================';
PRINT 'Transaction Data Validation Summary';
PRINT '==============================================================';

SELECT
    'Order' AS TransactionTable,
    COUNT(*) AS TotalRecords
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
PRINT 'Transaction Data Validation Summary Completed.';
PRINT '==============================================================';


/*==============================================================================
                    Part 9 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '15_Validate_Transaction_Data.sql executed successfully.';
PRINT 'All Transaction Tables validated successfully.';
PRINT '==============================================================';