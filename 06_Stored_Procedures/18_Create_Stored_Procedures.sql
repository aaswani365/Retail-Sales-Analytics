/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 18_Create_Stored_Procedures.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script creates stored procedures for the
Retail Sales Analytics & Inventory Management System.

The stored procedures provide reusable business logic for:

    • Sales Reporting
    • Customer Analytics
    • Inventory Monitoring
    • Store Performance
    • Executive Dashboard Reporting

These procedures support reporting, business operations,
Power BI integration, and application development.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Creating Stored Procedures...';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.1 : Create usp_GetSalesByDateRange
==============================================================================*/

PRINT 'Creating Procedure: usp_GetSalesByDateRange...';
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetSalesByDateRange
(
    @StartDate DATE,
    @EndDate DATE
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @StartDate IS NULL
       OR @EndDate IS NULL
    BEGIN
        THROW 50001,
              'Start Date and End Date cannot be NULL.',
              1;
    END;

    IF @StartDate > @EndDate
    BEGIN
        THROW 50002,
              'Start Date cannot be greater than End Date.',
              1;
    END;

    ------------------------------------------------------------
    -- Sales Report
    ------------------------------------------------------------

    SELECT

        OrderID,
        OrderNumber,
        OrderDate,

        CustomerID,
        CustomerName,

        StoreID,
        StoreName,

        EmployeeID,
        EmployeeName,

        OrderStatus,

        SubTotalAmount,
        DiscountAmount,
        TaxAmount,
        NetAmount

    FROM dbo.vwSalesSummary

    WHERE OrderDate >= @StartDate
	AND OrderDate < DATEADD(DAY, 1, @EndDate)

    ORDER BY
        OrderDate,
        OrderNumber;

END;
GO

PRINT 'Procedure Created: usp_GetSalesByDateRange';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.2 : Create usp_GetMonthlySales
==============================================================================*/

PRINT 'Creating Procedure: usp_GetMonthlySales...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetMonthlySales
(
    @Year INT
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @Year IS NULL
    BEGIN
        THROW 50003,
              'Year cannot be NULL.',
              1;
    END;

    ------------------------------------------------------------
    -- Validate Year Exists
    ------------------------------------------------------------

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.vwMonthlySales
        WHERE SalesYear = @Year
    )
    BEGIN
        THROW 50004,
              'No sales data found for the specified year.',
              1;
    END;

    ------------------------------------------------------------
    -- Monthly Sales Report
    ------------------------------------------------------------

    SELECT

        SalesYear,
        SalesMonth,
        MonthName,
        TotalOrders,
        TotalSubTotal,
        TotalDiscount,
        TotalTax,
        TotalSales,
        AverageOrderValue,
        MinimumOrderValue,
        MaximumOrderValue

    FROM dbo.vwMonthlySales

    WHERE SalesYear = @Year

    ORDER BY SalesMonth;

END;
GO

PRINT 'Procedure Created: usp_GetMonthlySales';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.3 : Create usp_GetTopSellingProducts
==============================================================================*/

PRINT 'Creating Procedure: usp_GetTopSellingProducts...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTopSellingProducts
(
    @TopN INT = 10
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
	-- Validate Parameters
	------------------------------------------------------------
	
	IF @TopN IS NULL
	   OR @TopN <= 0
	BEGIN
	    THROW 50005,
	          'Top N must be greater than zero.',
	          1;
	END;
	
	IF @TopN > 100
	BEGIN
	    THROW 50006,
	          'Top N cannot exceed 100.',
	          1;
	END;
	
	------------------------------------------------------------
	-- Top Selling Products
	------------------------------------------------------------
	
	SELECT TOP (@TopN)
	
	    ProductID,
	
	    ProductName,
	
	    SKU,
	
	    BrandName,
	
	    CategoryName,
	
	    SubCategoryName,
	
	    TotalOrders,
	
	    TotalQuantitySold,
	
	    TotalSales,
	
	    AverageSellingPrice,
	
	    MinimumSellingPrice,
	
	    MaximumSellingPrice
	
	FROM dbo.vwTopSellingProducts
	
	ORDER BY
	    TotalSales DESC,
	    TotalQuantitySold DESC,
	    ProductName ASC;
	
END;
GO

PRINT 'Procedure Created: usp_GetTopSellingProducts';
PRINT '==============================================================';

/*==============================================================================
                    Part 3.1 : Create usp_GetCustomerOrderHistory
==============================================================================*/

PRINT 'Creating Procedure: usp_GetCustomerOrderHistory...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetCustomerOrderHistory
(
    @CustomerID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @CustomerID IS NULL
    BEGIN
        THROW 50007,
              'Customer ID cannot be NULL.',
              1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Customer
        WHERE CustomerID = @CustomerID
    )
    BEGIN
        THROW 50008,
              'Customer not found.',
              1;
    END;

    ------------------------------------------------------------
    -- Customer Order History
    ------------------------------------------------------------

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

    ORDER BY

        OrderDate DESC,
        OrderNumber DESC;

END;
GO

PRINT 'Procedure Created: usp_GetCustomerOrderHistory';
PRINT '==============================================================';

/*==============================================================================
                    Part 3.2 : Create usp_GetTopCustomers
==============================================================================*/

PRINT 'Creating Procedure: usp_GetTopCustomers...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetTopCustomers
(
    @TopN INT = 10
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @TopN IS NULL
       OR @TopN <= 0
    BEGIN
        THROW 50009,
              'Top N must be greater than zero.',
              1;
    END;

    IF @TopN > 100
    BEGIN
        THROW 50010,
              'Top N cannot exceed 100.',
              1;
    END;

    ------------------------------------------------------------
    -- Top Customers Report
    ------------------------------------------------------------

    SELECT TOP (@TopN)

    CustomerID,
    CustomerName,
    Email,
    Phone,
    City,
    State,
    TotalOrders,
    TotalSpent,
    AverageOrderValue,
    FirstOrderDate,
    LastOrderDate,
    CustomerLifetimeDays

FROM dbo.vwCustomerPurchaseHistory

ORDER BY

    TotalSpent DESC,
    TotalOrders DESC,
    CustomerName ASC;

END;
GO

PRINT 'Procedure Created: usp_GetTopCustomers';
PRINT '==============================================================';

/*==============================================================================
                    Part 4.1 : Create usp_GetLowStockProducts
==============================================================================*/

PRINT 'Creating Procedure: usp_GetLowStockProducts...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetLowStockProducts
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Low Stock Products Report
    ------------------------------------------------------------

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

    ORDER BY

        StockVariance ASC,
        StoreName ASC,
        ProductName ASC;

END;
GO

PRINT 'Procedure Created: usp_GetLowStockProducts';
PRINT '==============================================================';

/*==============================================================================
                    Part 4.2 : Create usp_GetInventoryByStore
==============================================================================*/

PRINT 'Creating Procedure: usp_GetInventoryByStore...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetInventoryByStore
(
    @StoreID INT
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Parameters
    ------------------------------------------------------------

    IF @StoreID IS NULL
    BEGIN
        THROW 50011,
              'Store ID cannot be NULL.',
              1;
    END;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Store
        WHERE StoreID = @StoreID
    )
    BEGIN
        THROW 50012,
              'Store not found.',
              1;
    END;

    ------------------------------------------------------------
    -- Store Inventory Report
    ------------------------------------------------------------

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

    ORDER BY

    CASE
        WHEN StockStatus = 'Out of Stock' THEN 1
        WHEN StockStatus = 'Low Stock' THEN 2
        ELSE 3
    END,

    ProductName ASC;

END;
GO

PRINT 'Procedure Created: usp_GetInventoryByStore';
PRINT '==============================================================';

/*==============================================================================
                    Part 5.1 : Create usp_GetStorePerformance
==============================================================================*/

PRINT 'Creating Procedure: usp_GetStorePerformance...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetStorePerformance
(
    @StoreID INT = NULL
)
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Validate Store (If Provided)
    ------------------------------------------------------------

    IF @StoreID IS NOT NULL
    BEGIN
        IF NOT EXISTS
        (
            SELECT 1
            FROM dbo.Store
            WHERE StoreID = @StoreID
        )
        BEGIN
            THROW 50013,
                  'Store not found.',
                  1;
        END;
    END;

    ------------------------------------------------------------
    -- Store Performance Report
    ------------------------------------------------------------

    SELECT

        StoreID,

        StoreName,

        City,

        State,

        TotalOrders,

        TotalCustomers,

        TotalSubTotal,

        TotalDiscount,

        TotalTax,

        TotalSales,

        AverageOrderValue,

        TotalItemsSold,

        UniqueProductsSold

    FROM dbo.vwStorePerformance

    WHERE StoreID = ISNULL(@StoreID, StoreID)

    ORDER BY

        TotalSales DESC,
        StoreName ASC;

END;
GO

PRINT 'Procedure Created: usp_GetStorePerformance';
PRINT '==============================================================';

/*==============================================================================
                    Part 6.1 : Create usp_GetExecutiveDashboard
==============================================================================*/

PRINT 'Creating Procedure: usp_GetExecutiveDashboard...';

GO

CREATE OR ALTER PROCEDURE dbo.usp_GetExecutiveDashboard
AS
BEGIN

    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- Executive Dashboard Report
    ------------------------------------------------------------

    SELECT

        TotalCustomers,

        ActiveCustomers,

        TotalProducts,

        ActiveProducts,

        TotalStores,

        ActiveStores,

        TotalOrders,

        TotalSales,

        AverageOrderValue,

        TotalPayments,

        TotalReturns,

        TotalRefundAmount,

        OutOfStockProducts,

        LowStockProducts

    FROM dbo.vwBusinessDashboard;

END;
GO

PRINT 'Procedure Created: usp_GetExecutiveDashboard';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT 'All Stored Procedures Created Successfully!';
PRINT '==============================================================';

PRINT 'Stored Procedures Created:';

PRINT '  ✓ usp_GetSalesByDateRange';
PRINT '  ✓ usp_GetMonthlySales';
PRINT '  ✓ usp_GetTopSellingProducts';

PRINT '  ✓ usp_GetCustomerOrderHistory';
PRINT '  ✓ usp_GetTopCustomers';

PRINT '  ✓ usp_GetLowStockProducts';
PRINT '  ✓ usp_GetInventoryByStore';

PRINT '  ✓ usp_GetStorePerformance';

PRINT '  ✓ usp_GetExecutiveDashboard';

PRINT '==============================================================';
PRINT '18_Create_Stored_Procedures.sql Completed Successfully.';
PRINT '==============================================================';

GO