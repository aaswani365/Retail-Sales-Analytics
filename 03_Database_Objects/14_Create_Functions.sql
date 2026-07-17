/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 14_Create_Functions.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script creates user-defined functions (UDFs) for the
Retail Sales Analytics & Inventory Management System.

The functions provide reusable business logic for:

    • Profit Calculation
    • Inventory Status
    • Customer Lifetime Value
    • Customer Orders
    • Store Inventory
    • Low Stock Products

These functions improve code reusability, simplify queries,
and support reporting, analytics, and application development.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Creating User-Defined Functions...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.1 : Create fn_CalculateProfit
==============================================================================*/

PRINT 'Creating Function: fn_CalculateProfit...';

GO

CREATE OR ALTER FUNCTION dbo.fn_CalculateProfit
(
    @CostPrice DECIMAL(12,2),
    @SellingPrice DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
AS
BEGIN

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @CostPrice IS NULL
       OR @SellingPrice IS NULL
    BEGIN
        RETURN NULL;
    END;

    ------------------------------------------------------------
    -- Return Profit
    ------------------------------------------------------------

    RETURN (@SellingPrice - @CostPrice);

END;
GO

PRINT 'Function Created: fn_CalculateProfit';
PRINT '==============================================================';
GO


/*==============================================================================
                    Part 2.2 : Create fn_GetStockStatus
==============================================================================*/

PRINT 'Creating Function: fn_GetStockStatus...';

GO

CREATE OR ALTER FUNCTION dbo.fn_GetStockStatus
(
    @QuantityInStock INT,
    @ReorderLevel INT
)
RETURNS VARCHAR(20)
AS
BEGIN

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @QuantityInStock IS NULL
       OR @ReorderLevel IS NULL
    BEGIN
        RETURN NULL;
    END;

    ------------------------------------------------------------
    -- Determine Stock Status
    ------------------------------------------------------------

    RETURN
    (
        CASE
            WHEN @QuantityInStock = 0
                THEN 'Out of Stock'

            WHEN @QuantityInStock <= @ReorderLevel
                THEN 'Low Stock'

            ELSE 'In Stock'
        END
    );

END;
GO

PRINT 'Function Created: fn_GetStockStatus';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.3 : Create fn_GetCustomerLifetimeValue
==============================================================================*/

PRINT 'Creating Function: fn_GetCustomerLifetimeValue...';

GO

CREATE OR ALTER FUNCTION dbo.fn_GetCustomerLifetimeValue
(
    @CustomerID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN

    DECLARE @LifetimeValue DECIMAL(18,2);

    ------------------------------------------------------------
    -- Validate Parameter
    ------------------------------------------------------------

    IF @CustomerID IS NULL
    BEGIN
        RETURN NULL;
    END;

    ------------------------------------------------------------
    -- Calculate Customer Lifetime Value
    ------------------------------------------------------------

    SELECT
        @LifetimeValue = ISNULL(SUM(NetAmount), 0)
    FROM dbo.[Order]
    WHERE CustomerID = @CustomerID;

    ------------------------------------------------------------
    -- Return Lifetime Value
    ------------------------------------------------------------

    RETURN @LifetimeValue;

END;
GO

PRINT 'Function Created: fn_GetCustomerLifetimeValue';
PRINT '==============================================================';
GO


/*==============================================================================
                    Part 3.1 : Create fn_GetOrdersByCustomer
==============================================================================*/

PRINT 'Creating Function: fn_GetOrdersByCustomer...';

GO

CREATE OR ALTER FUNCTION dbo.fn_GetOrdersByCustomer
(
    @CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT

        OrderID,

        OrderNumber,

        OrderDate,

        CustomerID,

        CustomerName,

        StoreName,

        EmployeeName,

        OrderStatus,

        SubTotalAmount,

        DiscountAmount,

        TaxAmount,

        NetAmount

    FROM dbo.vwCustomerOrders

    WHERE CustomerID = @CustomerID
);
GO

PRINT 'Function Created: fn_GetOrdersByCustomer';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.2 : Create fn_GetProductsByStore
==============================================================================*/

PRINT 'Creating Function: fn_GetProductsByStore...';

GO

CREATE OR ALTER FUNCTION dbo.fn_GetProductsByStore
(
    @StoreID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT

        StoreID,

        StoreName,

        City,

        State,

        ProductID,

        ProductName,

        SKU,

        BrandName,

        CategoryName,

        SubCategoryName,

        SupplierName,

        QuantityInStock,

        ReorderLevel,

        StockStatus,

        LastRestockedDate,

        CostPrice,

        SellingPrice,

        InventoryCostValue,

        InventorySellingValue

    FROM dbo.vwInventoryStatus

    WHERE StoreID = @StoreID
);
GO

PRINT 'Function Created: fn_GetProductsByStore';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.3 : Create fn_GetLowStockProducts
==============================================================================*/

PRINT 'Creating Function: fn_GetLowStockProducts...';

GO

CREATE OR ALTER FUNCTION dbo.fn_GetLowStockProducts()
RETURNS TABLE
AS
RETURN
(
    SELECT

        StoreID,

        StoreName,

        ProductID,

        ProductName,

        SKU,

        BrandName,

        CategoryName,

        SubCategoryName,

        SupplierName,

        QuantityInStock,

        ReorderLevel,

        StockVariance,

        StockStatus,

        LastRestockedDate,

        CostPrice,

        SellingPrice,

        InventoryCostValue,

        InventorySellingValue

    FROM dbo.vwLowStockProducts
);
GO

PRINT 'Function Created: fn_GetLowStockProducts';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT 'All User-Defined Functions Created Successfully!';
PRINT '==============================================================';

PRINT 'Scalar Functions Created:';

PRINT '  ✓ fn_CalculateProfit';
PRINT '  ✓ fn_GetStockStatus';
PRINT '  ✓ fn_GetCustomerLifetimeValue';

PRINT '';

PRINT 'Table-Valued Functions Created:';

PRINT '  ✓ fn_GetOrdersByCustomer';
PRINT '  ✓ fn_GetProductsByStore';
PRINT '  ✓ fn_GetLowStockProducts';

PRINT '==============================================================';
PRINT '19_Create_Functions.sql Completed Successfully.';
PRINT '==============================================================';

GO