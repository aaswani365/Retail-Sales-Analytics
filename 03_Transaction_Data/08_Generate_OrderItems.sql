/*==============================================================================
Project     : Retail Sales Analytics & Inventory Management System
Script Name : 08_Generate_OrderItems.sql

Author      : Akshay Aswani
Created On  : July 2026

------------------------------------------------------------------------------
Description
------------------------------------------------------------------------------
This script generates transactional order line items for customer orders.

For each order, the script:

• Selects random products
• Generates purchase quantities
• Retrieves current product pricing
• Calculates discounts
• Calculates GST
• Computes line totals
• Inserts records into dbo.OrderItem
• Updates order financial totals

------------------------------------------------------------------------------
Tables Used
------------------------------------------------------------------------------
Source
------
dbo.[Order]
dbo.Product

Target
------
dbo.OrderItem

------------------------------------------------------------------------------
Business Rules
------------------------------------------------------------------------------
• Every order contains between 1 and 5 products.
• Products within the same order are unique.
• Quantity ranges from 1 to 5.
• Cost Price is copied from Product.
• Unit Price is copied from Product Selling Price.
• Discount ranges between 0% and 15%.
• GST is calculated at 18%.
• Line Total =
      (Quantity × UnitPrice)
    − Discount
    + Tax

------------------------------------------------------------------------------
Execution
------------------------------------------------------------------------------
Run After:
07_Generate_Orders.sql

Run Before:
09_Generate_Payments.sql

==============================================================================*/

/*==============================================================================
                    Data Cleanup
==============================================================================*/

DELETE FROM dbo.OrderItem;

DBCC CHECKIDENT ('dbo.OrderItem', RESEED, 0);

UPDATE dbo.[Order]
SET
    SubTotalAmount = 0,
    DiscountAmount = 0,
    TaxAmount = 0,
    NetAmount = 0;

PRINT 'Previous OrderItem data cleared successfully.';


SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Order Item Data Generation...';
PRINT '==============================================================';

/*==============================================================================
                    Part 2 : Variable Declaration
==============================================================================*/

------------------------------------------------------------
-- Order Item Generation Settings
------------------------------------------------------------

DECLARE @MinItemsPerOrder      INT = 1;
DECLARE @MaxItemsPerOrder      INT = 5;

DECLARE @MinQuantity           INT = 1;
DECLARE @MaxQuantity           INT = 5;

------------------------------------------------------------
-- Discount Settings
------------------------------------------------------------

DECLARE @MinDiscountPercent    DECIMAL(5,2) = 0.00;
DECLARE @MaxDiscountPercent    DECIMAL(5,2) = 15.00;

------------------------------------------------------------
-- Tax Settings
------------------------------------------------------------

DECLARE @GSTPercent            DECIMAL(5,2) = 18.00;

------------------------------------------------------------
-- Processing Variables
------------------------------------------------------------

DECLARE @OrderID               INT;
DECLARE @ProductID             INT;
DECLARE @Quantity              INT;

DECLARE @CostPrice             DECIMAL(12,2);
DECLARE @UnitPrice             DECIMAL(12,2);

DECLARE @DiscountPercent       DECIMAL(5,2);
DECLARE @DiscountAmount        DECIMAL(12,2);

DECLARE @TaxAmount             DECIMAL(12,2);
DECLARE @LineTotal             DECIMAL(12,2);

PRINT 'Variables initialized successfully.';

/*==============================================================================
                    Part 3 : Temporary Tables
==============================================================================*/

------------------------------------------------------------
-- Drop Temporary Tables (If Already Exist)
------------------------------------------------------------

IF OBJECT_ID('tempdb..#Orders') IS NOT NULL
    DROP TABLE #Orders;

IF OBJECT_ID('tempdb..#Products') IS NOT NULL
    DROP TABLE #Products;

IF OBJECT_ID('tempdb..#SelectedProducts') IS NOT NULL
    DROP TABLE #SelectedProducts;

------------------------------------------------------------
-- Temporary Orders Table
------------------------------------------------------------

CREATE TABLE #Orders
(
    OrderID INT PRIMARY KEY
);

------------------------------------------------------------
-- Temporary Products Table
------------------------------------------------------------

CREATE TABLE #Products
(
    ProductID INT PRIMARY KEY,
    CostPrice DECIMAL(12,2),
    SellingPrice DECIMAL(12,2)
);

------------------------------------------------------------
-- Temporary Selected Products
------------------------------------------------------------

CREATE TABLE #SelectedProducts
(
    ProductID INT PRIMARY KEY
);

PRINT 'Temporary tables created successfully.';

/*==============================================================================
                    Part 4.1 : Load Orders & Products
==============================================================================*/

------------------------------------------------------------
-- Load Orders
------------------------------------------------------------

INSERT INTO #Orders
(
    OrderID
)
SELECT
    OrderID
FROM dbo.[Order];

PRINT CONCAT('Orders Loaded : ', @@ROWCOUNT);

------------------------------------------------------------
-- Load Active Products
------------------------------------------------------------

INSERT INTO #Products
(
    ProductID,
    CostPrice,
    SellingPrice
)
SELECT
    ProductID,
    CostPrice,
    SellingPrice
FROM dbo.Product
WHERE IsActive = 1;

PRINT CONCAT('Products Loaded : ', @@ROWCOUNT);

------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT
    (SELECT COUNT(*) FROM #Orders)   AS TotalOrders,
    (SELECT COUNT(*) FROM #Products) AS TotalProducts;

PRINT 'Orders and Products loaded successfully.';

/*==============================================================================
                    Part 4.2 : Order Processing Loop
==============================================================================*/

------------------------------------------------------------
-- Processing Variables
------------------------------------------------------------

DECLARE @ItemsPerOrder INT;

------------------------------------------------------------
-- Order Cursor
------------------------------------------------------------

DECLARE OrderCursor CURSOR FAST_FORWARD
FOR
SELECT OrderID
FROM #Orders
ORDER BY OrderID;

OPEN OrderCursor;

FETCH NEXT FROM OrderCursor
INTO @OrderID;

WHILE @@FETCH_STATUS = 0
BEGIN

    --------------------------------------------------------
    -- Clear Previously Selected Products
    --------------------------------------------------------

    TRUNCATE TABLE #SelectedProducts;

    --------------------------------------------------------
    -- Generate Random Number of Products
    --------------------------------------------------------

    SET @ItemsPerOrder =
        FLOOR
        (
            RAND(CHECKSUM(NEWID()))
            * (@MaxItemsPerOrder - @MinItemsPerOrder + 1)
        )
        + @MinItemsPerOrder;

    --------------------------------------------------------
    -- Select Random Unique Products
    --------------------------------------------------------

    INSERT INTO #SelectedProducts
    (
        ProductID
    )
    SELECT TOP (@ItemsPerOrder)
        ProductID
    FROM #Products
    ORDER BY NEWID();

/*------------------------------------------------------------
                Part 4.3 : Product Processing Loop
------------------------------------------------------------*/

DECLARE ProductCursor CURSOR LOCAL FAST_FORWARD
FOR
SELECT ProductID
FROM #SelectedProducts;

OPEN ProductCursor;

FETCH NEXT FROM ProductCursor
INTO @ProductID;

WHILE @@FETCH_STATUS = 0
BEGIN

    --------------------------------------------------------
    -- Generate Random Quantity
    --------------------------------------------------------

    SET @Quantity =
        FLOOR
        (
            RAND(CHECKSUM(NEWID()))
            * (@MaxQuantity - @MinQuantity + 1)
        )
        + @MinQuantity;

    --------------------------------------------------------
    -- Retrieve Product Prices
    --------------------------------------------------------

    SELECT
        @CostPrice = CostPrice,
        @UnitPrice = SellingPrice
    FROM #Products
    WHERE ProductID = @ProductID;

    /*------------------------------------------------------------
                    Part 4.4 : Financial Calculations
    ------------------------------------------------------------*/

    --------------------------------------------------------
    -- Generate Random Discount Percentage
    --------------------------------------------------------

    SET @DiscountPercent =
    ROUND
    (
        (
            RAND(CHECKSUM(NEWID()))
            * (@MaxDiscountPercent - @MinDiscountPercent)
        )
        + @MinDiscountPercent,
        2
    );

    --------------------------------------------------------
    -- Calculate Discount Amount
    --------------------------------------------------------

    SET @DiscountAmount =
    ROUND
    (
        (@Quantity * @UnitPrice * @DiscountPercent) / 100,
        2
    );

    --------------------------------------------------------
    -- Calculate Tax Amount (GST)
    --------------------------------------------------------

    SET @TaxAmount =
    ROUND
    (
        (
            ((@Quantity * @UnitPrice) - @DiscountAmount)
            * @GSTPercent
        ) / 100,
        2
    );

    --------------------------------------------------------
    -- Calculate Line Total
    --------------------------------------------------------

    SET @LineTotal =
    ROUND
    (
          (@Quantity * @UnitPrice)
        - @DiscountAmount
        + @TaxAmount,
        2
    );

    /*------------------------------------------------------------
                Part 4.5 : Insert Order Item
	------------------------------------------------------------*/

    INSERT INTO dbo.OrderItem
    (
        OrderID,
        ProductID,
        Quantity,
        CostPrice,
        UnitPrice,
        DiscountAmount,
        TaxAmount,
        LineTotal
    )
    VALUES
    (
        @OrderID,
        @ProductID,
        @Quantity,
        @CostPrice,
        @UnitPrice,
        @DiscountAmount,
        @TaxAmount,
        @LineTotal
    );

    --------------------------------------------------------
    -- Next Product
    --------------------------------------------------------

    FETCH NEXT FROM ProductCursor
    INTO @ProductID;

END

CLOSE ProductCursor;
DEALLOCATE ProductCursor;

--------------------------------------------------------
-- Next Order
--------------------------------------------------------

FETCH NEXT FROM OrderCursor
INTO @OrderID;

END

CLOSE OrderCursor;
DEALLOCATE OrderCursor;

PRINT '==============================================================';
PRINT 'Order Processing Completed Successfully.';
PRINT '==============================================================';


/*==============================================================================
                    Part 4.6 : Update Order Totals
==============================================================================*/

------------------------------------------------------------
-- Update Order Financial Totals
------------------------------------------------------------

UPDATE O
SET
    SubTotalAmount = X.SubTotalAmount,
    DiscountAmount = X.DiscountAmount,
    TaxAmount      = X.TaxAmount,
    NetAmount      = X.NetAmount
FROM dbo.[Order] O
INNER JOIN
(
    SELECT
        OrderID,

        SUM(Quantity * UnitPrice) AS SubTotalAmount,

        SUM(DiscountAmount) AS DiscountAmount,

        SUM(TaxAmount) AS TaxAmount,

        SUM(LineTotal) AS NetAmount

    FROM dbo.OrderItem
    GROUP BY OrderID
) X
ON O.OrderID = X.OrderID;

PRINT '==============================================================';
PRINT 'Order totals updated successfully.';
PRINT '==============================================================';

------------------------------------------------------------
-- Orders Updated
------------------------------------------------------------

SELECT
    COUNT(*) AS OrdersUpdated
FROM dbo.[Order]
WHERE NetAmount > 0;

/*==============================================================================
                    Part 5 : Validation
==============================================================================*/

------------------------------------------------------------
-- Total Order Items Generated
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalOrderItems
FROM dbo.OrderItem;

------------------------------------------------------------
-- Average Items Per Order
------------------------------------------------------------

SELECT
    CAST(AVG(ItemCount * 1.0) AS DECIMAL(10,2)) AS AvgItemsPerOrder
FROM
(
    SELECT
        OrderID,
        COUNT(*) AS ItemCount
    FROM dbo.OrderItem
    GROUP BY OrderID
) X;

------------------------------------------------------------
-- Orders Without Order Items
------------------------------------------------------------

SELECT
    COUNT(*) AS OrdersWithoutItems
FROM dbo.[Order] O
LEFT JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
WHERE OI.OrderID IS NULL;

------------------------------------------------------------
-- Financial Validation
------------------------------------------------------------

SELECT TOP (10)
    O.OrderID,
    O.SubTotalAmount,
    O.DiscountAmount,
    O.TaxAmount,
    O.NetAmount
FROM dbo.[Order] O
ORDER BY O.OrderID;

------------------------------------------------------------
-- OrderItem Sample
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

------------------------------------------------------------
-- Duplicate Products Per Order
------------------------------------------------------------

SELECT
    OrderID,
    ProductID,
    COUNT(*) AS TotalRecords
FROM dbo.OrderItem
GROUP BY
    OrderID,
    ProductID
HAVING COUNT(*) > 1;

PRINT '==============================================================';
PRINT 'Order Item Data Validation Completed Successfully.';
PRINT '==============================================================';

------------------------------------------------------------
-- Sample Generated Order Items
------------------------------------------------------------

SELECT TOP (10) * from dbo.[OrderItem]


/*==============================================================================
                    Part 6 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '08_Generate_OrderItems.sql executed successfully.';
PRINT 'Order Items generated successfully.';
PRINT 'Order totals updated successfully.';
PRINT '==============================================================';