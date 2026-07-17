/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 15_Create_Triggers.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script creates DML triggers for the
Retail Sales Analytics & Inventory Management System.

The triggers automate business operations including:

    • Automatically updating ModifiedDate columns
    • Maintaining inventory after order placement
    • Restoring inventory after product returns
    • Preventing invalid inventory updates

These triggers help enforce business rules,
maintain data integrity, and reduce manual operations.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Creating Database Triggers...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.1 : Create trg_Product_ModifiedDate
==============================================================================*/

PRINT 'Creating Trigger: trg_Product_ModifiedDate...';

GO

CREATE OR ALTER TRIGGER dbo.trg_Product_ModifiedDate
ON dbo.Product
AFTER UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Update ModifiedDate for Updated Products
    ------------------------------------------------------------

    UPDATE P
    SET
        ModifiedDate = SYSDATETIME()
    FROM dbo.Product AS P
    INNER JOIN inserted AS I
        ON P.ProductID = I.ProductID;

END;
GO

PRINT 'Trigger Created: trg_Product_ModifiedDate';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.2 : Create trg_Customer_ModifiedDate
==============================================================================*/

PRINT 'Creating Trigger: trg_Customer_ModifiedDate...';

GO

CREATE OR ALTER TRIGGER dbo.trg_Customer_ModifiedDate
ON dbo.Customer
AFTER UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Update ModifiedDate for Updated Customers
    ------------------------------------------------------------

    UPDATE C
    SET
        ModifiedDate = SYSDATETIME()
    FROM dbo.Customer AS C
    INNER JOIN inserted AS I
        ON C.CustomerID = I.CustomerID;

END;
GO

PRINT 'Trigger Created: trg_Customer_ModifiedDate';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.1 : Create trg_OrderItem_DecreaseInventory
==============================================================================*/

PRINT 'Creating Trigger: trg_OrderItem_DecreaseInventory...';

GO

CREATE OR ALTER TRIGGER dbo.trg_OrderItem_DecreaseInventory
ON dbo.OrderItem
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Inventory Availability
    ------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS I
        INNER JOIN dbo.[Order] AS O
            ON I.OrderID = O.OrderID
        INNER JOIN dbo.Inventory AS INV
            ON INV.ProductID = I.ProductID
           AND INV.StoreID = O.StoreID
        WHERE INV.QuantityInStock < I.Quantity
    )
    BEGIN
        THROW 50020,
              'Insufficient inventory available for one or more products.',
              1;
    END;

    ------------------------------------------------------------
    -- Reduce Inventory
    ------------------------------------------------------------

    UPDATE INV
    SET

        INV.QuantityInStock =
            INV.QuantityInStock - I.Quantity,

        INV.ModifiedDate =
            SYSDATETIME()

    FROM dbo.Inventory AS INV

    INNER JOIN dbo.[Order] AS O
        ON INV.StoreID = O.StoreID

    INNER JOIN inserted AS I
        ON O.OrderID = I.OrderID
       AND INV.ProductID = I.ProductID;

END;
GO

PRINT 'Trigger Created: trg_OrderItem_DecreaseInventory';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.2 : Create trg_Return_RestoreInventory
==============================================================================*/

PRINT 'Creating Trigger: trg_Return_RestoreInventory...';

GO

CREATE OR ALTER TRIGGER dbo.trg_Return_RestoreInventory
ON dbo.[Return]
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Restore Inventory After Product Return
    ------------------------------------------------------------

    UPDATE INV
    SET

        INV.QuantityInStock =
            INV.QuantityInStock + I.QuantityReturned,

        INV.ModifiedDate =
            SYSDATETIME()

    FROM dbo.Inventory AS INV

    INNER JOIN dbo.OrderItem AS OI
        ON INV.ProductID = OI.ProductID

    INNER JOIN dbo.[Order] AS O
        ON OI.OrderID = O.OrderID
       AND INV.StoreID = O.StoreID

    INNER JOIN inserted AS I
        ON OI.OrderItemID = I.OrderItemID;

END;
GO

PRINT 'Trigger Created: trg_Return_RestoreInventory';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4.1 : Create trg_PreventNegativeInventory
==============================================================================*/

PRINT 'Creating Trigger: trg_PreventNegativeInventory...';

GO

CREATE OR ALTER TRIGGER dbo.trg_PreventNegativeInventory
ON dbo.Inventory
AFTER INSERT, UPDATE
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Prevent Negative Inventory
    ------------------------------------------------------------

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE QuantityInStock < 0
    )
    BEGIN

        THROW 50030,
              'Inventory quantity cannot be negative.',
              1;

    END;

END;
GO

PRINT 'Trigger Created: trg_PreventNegativeInventory';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 5 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT 'All Database Triggers Created Successfully!';
PRINT '==============================================================';

PRINT 'Audit Triggers Created:';

PRINT '  ✓ trg_Product_ModifiedDate';
PRINT '  ✓ trg_Customer_ModifiedDate';

PRINT '';

PRINT 'Inventory Triggers Created:';

PRINT '  ✓ trg_OrderItem_DecreaseInventory';
PRINT '  ✓ trg_Return_RestoreInventory';

PRINT '';

PRINT 'Validation Trigger Created:';

PRINT '  ✓ trg_PreventNegativeInventory';

PRINT '==============================================================';
PRINT '20_Create_Triggers.sql Completed Successfully.';
PRINT '==============================================================';

GO