/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 17_Create_Views.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script creates reporting views for the
Retail Sales Analytics & Inventory Management System.

The views are designed to support:

    • Sales Analytics
    • Customer Analytics
    • Product Analytics
    • Inventory Monitoring
    • Store Performance
    • Payment Analysis
    • Return Analysis
    • Executive Dashboard Reporting

These views will serve as the primary data source for
Power BI dashboards and business reporting.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Creating Reporting Views...';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.1 : Create vwSalesSummary
==============================================================================*/

PRINT 'Creating View: vwSalesSummary...';

GO

CREATE OR ALTER VIEW dbo.vwSalesSummary
AS

SELECT

    ------------------------------------------------------------
    -- Order Information
    ------------------------------------------------------------

    O.OrderID,
    O.OrderNumber,
    O.OrderDate,

    ------------------------------------------------------------
    -- Customer Information
    ------------------------------------------------------------

    C.CustomerID,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,
    S.StoreName,
    S.City,
    S.State,

    ------------------------------------------------------------
    -- Employee Information
    ------------------------------------------------------------

    E.EmployeeID,
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    ------------------------------------------------------------
    -- Order Status
    ------------------------------------------------------------

    OS.StatusName AS OrderStatus,

    ------------------------------------------------------------
    -- Financial Information
    ------------------------------------------------------------

    O.SubTotalAmount,
    O.DiscountAmount,
    O.TaxAmount,
    O.NetAmount,

    ------------------------------------------------------------
    -- Audit Information
    ------------------------------------------------------------

    O.CreatedDate,
    O.ModifiedDate

FROM dbo.[Order] O

INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID

INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID

INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID

INNER JOIN dbo.OrderStatus OS
    ON O.OrderStatusID = OS.OrderStatusID;

GO

PRINT 'View Created: vwSalesSummary';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.2 : Create vwDailySales
==============================================================================*/

PRINT 'Creating View: vwDailySales...';

GO

CREATE OR ALTER VIEW dbo.vwDailySales
AS

SELECT

    ------------------------------------------------------------
    -- Date
    ------------------------------------------------------------

    CAST(O.OrderDate AS DATE) AS SalesDate,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.SubTotalAmount) AS TotalSubTotal,

    SUM(O.DiscountAmount) AS TotalDiscount,

    SUM(O.TaxAmount) AS TotalTax,

    SUM(O.NetAmount) AS TotalSales,

    AVG(O.NetAmount) AS AverageOrderValue,

    MIN(O.NetAmount) AS MinimumOrderValue,

    MAX(O.NetAmount) AS MaximumOrderValue

FROM dbo.[Order] O

GROUP BY
    CAST(O.OrderDate AS DATE);

GO

PRINT 'View Created: vwDailySales';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.3 : Create vwMonthlySales
==============================================================================*/

PRINT 'Creating View: vwMonthlySales...';

GO

CREATE OR ALTER VIEW dbo.vwMonthlySales
AS

SELECT

    ------------------------------------------------------------
    -- Year & Month
    ------------------------------------------------------------

    YEAR(O.OrderDate) AS SalesYear,

    MONTH(O.OrderDate) AS SalesMonth,

    DATENAME(MONTH, O.OrderDate) AS MonthName,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.SubTotalAmount) AS TotalSubTotal,

    SUM(O.DiscountAmount) AS TotalDiscount,

    SUM(O.TaxAmount) AS TotalTax,

    SUM(O.NetAmount) AS TotalSales,

    AVG(O.NetAmount) AS AverageOrderValue,

    MIN(O.NetAmount) AS MinimumOrderValue,

    MAX(O.NetAmount) AS MaximumOrderValue

FROM dbo.[Order] O

GROUP BY

    YEAR(O.OrderDate),

    MONTH(O.OrderDate),

    DATENAME(MONTH, O.OrderDate);

GO

PRINT 'View Created: vwMonthlySales';
PRINT '==============================================================';

/*==============================================================================
                    Part 2.4 : Create vwYearlySales
==============================================================================*/

PRINT 'Creating View: vwYearlySales...';

GO

CREATE OR ALTER VIEW dbo.vwYearlySales
AS

SELECT

    ------------------------------------------------------------
    -- Year
    ------------------------------------------------------------

    YEAR(O.OrderDate) AS SalesYear,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.SubTotalAmount) AS TotalSubTotal,

    SUM(O.DiscountAmount) AS TotalDiscount,

    SUM(O.TaxAmount) AS TotalTax,

    SUM(O.NetAmount) AS TotalSales,

    AVG(O.NetAmount) AS AverageOrderValue,

    MIN(O.NetAmount) AS MinimumOrderValue,

    MAX(O.NetAmount) AS MaximumOrderValue

FROM dbo.[Order] O

GROUP BY
    YEAR(O.OrderDate);

GO

PRINT 'View Created: vwYearlySales';
PRINT '==============================================================';

/*==============================================================================
                    Part 3.1 : Create vwCustomerOrders
==============================================================================*/

PRINT 'Creating View: vwCustomerOrders...';

GO

CREATE OR ALTER VIEW dbo.vwCustomerOrders
AS

SELECT

    ------------------------------------------------------------
    -- Customer Information
    ------------------------------------------------------------

    C.CustomerID,

    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

    C.Email,

    C.Phone,

    C.City,

    C.State,

    ------------------------------------------------------------
    -- Order Information
    ------------------------------------------------------------

    O.OrderID,

    O.OrderNumber,

    O.OrderDate,

    OS.StatusName AS OrderStatus,

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    ------------------------------------------------------------
    -- Employee Information
    ------------------------------------------------------------

    E.EmployeeID,

    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,

    ------------------------------------------------------------
    -- Financial Information
    ------------------------------------------------------------

    O.SubTotalAmount,

    O.DiscountAmount,

    O.TaxAmount,

    O.NetAmount,

    ------------------------------------------------------------
    -- Payment Information
    ------------------------------------------------------------

    PM.MethodName AS PaymentMethod,

    PS.StatusName AS PaymentStatus,

    P.PaymentDate,

    P.Amount AS PaymentAmount

FROM dbo.Customer C

INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID

INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID

INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID

INNER JOIN dbo.OrderStatus OS
    ON O.OrderStatusID = OS.OrderStatusID

LEFT JOIN dbo.Payment P
    ON O.OrderID = P.OrderID

LEFT JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID

LEFT JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

GO

PRINT 'View Created: vwCustomerOrders';
PRINT '==============================================================';


/*==============================================================================
                    Part 3.2 : Create vwCustomerPurchaseHistory
==============================================================================*/

PRINT 'Creating View: vwCustomerPurchaseHistory...';

GO

CREATE OR ALTER VIEW dbo.vwCustomerPurchaseHistory
AS

SELECT

    ------------------------------------------------------------
    -- Customer Information
    ------------------------------------------------------------

    C.CustomerID,

    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

    C.Email,

    C.Phone,

    C.City,

    C.State,

    ------------------------------------------------------------
    -- Purchase KPIs
    ------------------------------------------------------------

	COUNT(O.OrderID) AS TotalOrders,
	
	ISNULL(SUM(O.NetAmount), 0) AS TotalSpent,
	
	ISNULL(AVG(O.NetAmount), 0) AS AverageOrderValue,
	
	MIN(O.OrderDate) AS FirstOrderDate,
	
	MAX(O.OrderDate) AS LastOrderDate,
	
	CASE
	    WHEN COUNT(O.OrderID) = 0 THEN 0
	    ELSE DATEDIFF
	    (
	        DAY,
	        MIN(O.OrderDate),
	        MAX(O.OrderDate)
	    )
	END AS CustomerLifetimeDays

FROM dbo.Customer C

LEFT JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID

GROUP BY

    C.CustomerID,
    C.FirstName,
    C.LastName,
    C.Email,
    C.Phone,
    C.City,
    C.State;

GO

PRINT 'View Created: vwCustomerPurchaseHistory';
PRINT '==============================================================';

/*==============================================================================
                    Part 4.1 : Create vwTopSellingProducts
==============================================================================*/

PRINT 'Creating View: vwTopSellingProducts...';

GO

CREATE OR ALTER VIEW dbo.vwTopSellingProducts
AS

SELECT

    ------------------------------------------------------------
    -- Product Information
    ------------------------------------------------------------

    P.ProductID,

    P.ProductName,

    P.SKU,

    B.BrandName,

    SC.SubCategoryName,

    C.CategoryName,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(DISTINCT O.OrderID) AS TotalOrders,

    SUM(OI.Quantity) AS TotalQuantitySold,

    SUM(OI.LineTotal) AS TotalSales,

    AVG(OI.UnitPrice) AS AverageSellingPrice,

    MIN(OI.UnitPrice) AS MinimumSellingPrice,

    MAX(OI.UnitPrice) AS MaximumSellingPrice

FROM dbo.Product P

INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID

INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID

INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID

INNER JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID

INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID

GROUP BY

    P.ProductID,
    P.ProductName,
    P.SKU,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName;

GO

PRINT 'View Created: vwTopSellingProducts';
PRINT '==============================================================';

/*==============================================================================
                    Part 4.2 : Create vwProductProfitability
==============================================================================*/

PRINT 'Creating View: vwProductProfitability...';

GO

CREATE OR ALTER VIEW dbo.vwProductProfitability
AS

SELECT

    ------------------------------------------------------------
    -- Product Information
    ------------------------------------------------------------

    P.ProductID,

    P.ProductName,

    P.SKU,

    B.BrandName,

    SC.SubCategoryName,

    C.CategoryName,

    ------------------------------------------------------------
    -- Sales Metrics
    ------------------------------------------------------------

    SUM(OI.Quantity) AS TotalQuantitySold,

    SUM(OI.LineTotal) AS TotalRevenue,

    SUM(OI.CostPrice * OI.Quantity) AS TotalCost,

    ------------------------------------------------------------
    -- Profit Metrics
    ------------------------------------------------------------

    SUM(OI.LineTotal) -
    SUM(OI.CostPrice * OI.Quantity) AS GrossProfit,
	Round(
	CASE
        WHEN SUM(OI.LineTotal) = 0 THEN 0
        ELSE
            (
                (SUM(OI.LineTotal) -
                 SUM(OI.CostPrice * OI.Quantity))
                * 100.0
            ) / SUM(OI.LineTotal)
    END, 2) AS ProfitMarginPercentage

FROM dbo.Product P

INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID

INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID

INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID

INNER JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID

GROUP BY

    P.ProductID,
    P.ProductName,
    P.SKU,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName;

GO

PRINT 'View Created: vwProductProfitability';
PRINT '==============================================================';

/*==============================================================================
                    Part 5.1 : Create vwInventoryStatus
==============================================================================*/

PRINT 'Creating View: vwInventoryStatus...';

GO

CREATE OR ALTER VIEW dbo.vwInventoryStatus
AS

SELECT

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    S.City,

    S.State,

    ------------------------------------------------------------
    -- Product Information
    ------------------------------------------------------------

    P.ProductID,

    P.ProductName,

    P.SKU,

    B.BrandName,

    SC.SubCategoryName,

    C.CategoryName,

    SUP.SupplierName,

    ------------------------------------------------------------
    -- Inventory Information
    ------------------------------------------------------------

    I.QuantityInStock,

    P.ReorderLevel,

    CASE
        WHEN I.QuantityInStock = 0
            THEN 'Out of Stock'

        WHEN I.QuantityInStock <= P.ReorderLevel
            THEN 'Low Stock'

        ELSE 'In Stock'
    END AS StockStatus,

    I.LastRestockedDate,

    ------------------------------------------------------------
    -- Product Pricing
    ------------------------------------------------------------

    P.CostPrice,

    P.SellingPrice,

    ------------------------------------------------------------
    -- Inventory Value
    ------------------------------------------------------------

    I.QuantityInStock * P.CostPrice AS InventoryCostValue,

    I.QuantityInStock * P.SellingPrice AS InventorySellingValue

FROM dbo.Inventory I

INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID

INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID

INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID

INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID

INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID

INNER JOIN dbo.Supplier SUP
    ON P.SupplierID = SUP.SupplierID;

GO

PRINT 'View Created: vwInventoryStatus';
PRINT '==============================================================';

/*==============================================================================
                    Part 5.2 : Create vwLowStockProducts
==============================================================================*/

PRINT 'Creating View: vwLowStockProducts...';

GO

CREATE OR ALTER VIEW dbo.vwLowStockProducts
AS

SELECT

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    ------------------------------------------------------------
    -- Product Information
    ------------------------------------------------------------

    P.ProductID,

    P.ProductName,

    P.SKU,

    B.BrandName,

    SC.SubCategoryName,

    C.CategoryName,

    SUP.SupplierName,

    ------------------------------------------------------------
    -- Inventory Information
    ------------------------------------------------------------

    I.QuantityInStock,

    P.ReorderLevel,

    I.QuantityInStock - P.ReorderLevel AS StockVariance,

    CASE
        WHEN I.QuantityInStock = 0
            THEN 'Out of Stock'

        ELSE 'Low Stock'
    END AS StockStatus,

    I.LastRestockedDate,

    ------------------------------------------------------------
    -- Product Pricing
    ------------------------------------------------------------

    P.CostPrice,

    P.SellingPrice,

    ------------------------------------------------------------
    -- Inventory Value
    ------------------------------------------------------------

    I.QuantityInStock * P.CostPrice AS InventoryCostValue,

    I.QuantityInStock * P.SellingPrice AS InventorySellingValue

FROM dbo.Inventory I

INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID

INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID

INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID

INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID

INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID

INNER JOIN dbo.Supplier SUP
    ON P.SupplierID = SUP.SupplierID

WHERE I.QuantityInStock <= P.ReorderLevel;

GO

PRINT 'View Created: vwLowStockProducts';
PRINT '==============================================================';

/*==============================================================================
                    Part 6.1 : Create vwStorePerformance
==============================================================================*/

PRINT 'Creating View: vwStorePerformance...';

GO

CREATE OR ALTER VIEW dbo.vwStorePerformance
AS

SELECT

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    S.City,

    S.State,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(DISTINCT O.OrderID) AS TotalOrders,

    COUNT(DISTINCT O.CustomerID) AS TotalCustomers,

    ISNULL(SUM(O.SubTotalAmount), 0) AS TotalSubTotal,

	ISNULL(SUM(O.DiscountAmount), 0) AS TotalDiscount,
	
	ISNULL(SUM(O.TaxAmount), 0) AS TotalTax,
	
	ISNULL(SUM(O.NetAmount), 0) AS TotalSales,
	
	ISNULL(AVG(O.NetAmount), 0) AS AverageOrderValue,
	
	------------------------------------------------------------
	-- Product KPIs
	------------------------------------------------------------
	
	ISNULL(SUM(OI.Quantity), 0) AS TotalItemsSold,
	
	COUNT(DISTINCT OI.ProductID) AS UniqueProductsSold
	
FROM dbo.Store S

LEFT JOIN dbo.[Order] O
    ON S.StoreID = O.StoreID

LEFT JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID

GROUP BY

    S.StoreID,
    S.StoreName,
    S.City,
    S.State;

GO

PRINT 'View Created: vwStorePerformance';
PRINT '==============================================================';

/*==============================================================================
                    Part 7.1 : Create vwPaymentSummary
==============================================================================*/

PRINT 'Creating View: vwPaymentSummary...';

GO

CREATE OR ALTER VIEW dbo.vwPaymentSummary
AS

SELECT

    ------------------------------------------------------------
    -- Payment Information
    ------------------------------------------------------------

    P.PaymentID,

    P.PaymentDate,

    ------------------------------------------------------------
    -- Order Information
    ------------------------------------------------------------

    O.OrderID,

    O.OrderNumber,

    ------------------------------------------------------------
    -- Customer Information
    ------------------------------------------------------------

    C.CustomerID,

    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    ------------------------------------------------------------
    -- Payment Details
    ------------------------------------------------------------

    PM.MethodName AS PaymentMethod,

    PS.StatusName AS PaymentStatus,

    P.Amount,

    P.TransactionReference,

    P.Remarks,

    ------------------------------------------------------------
    -- Audit Information
    ------------------------------------------------------------

    P.CreatedDate,

    P.ModifiedDate

FROM dbo.Payment P

INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID

INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID

INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID

INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID

INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

GO

PRINT 'View Created: vwPaymentSummary';
PRINT '==============================================================';

/*==============================================================================
                    Part 8.1 : Create vwReturnAnalysis
==============================================================================*/

PRINT 'Creating View: vwReturnAnalysis...';

GO

CREATE OR ALTER VIEW dbo.vwReturnAnalysis
AS

SELECT

    ------------------------------------------------------------
    -- Return Information
    ------------------------------------------------------------

    R.ReturnID,

    R.ReturnDate,

    RR.ReasonName AS ReturnReason,

    RS.StatusName AS ReturnStatus,

    R.QuantityReturned,

    R.RefundAmount,

    ------------------------------------------------------------
    -- Order Information
    ------------------------------------------------------------

    O.OrderID,

    O.OrderNumber,

    ------------------------------------------------------------
    -- Customer Information
    ------------------------------------------------------------

    C.CustomerID,

    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

    ------------------------------------------------------------
    -- Store Information
    ------------------------------------------------------------

    S.StoreID,

    S.StoreName,

    ------------------------------------------------------------
    -- Product Information
    ------------------------------------------------------------

    P.ProductID,

    P.ProductName,

    P.SKU,

    B.BrandName,

    SC.SubCategoryName,

    CAT.CategoryName,

    ------------------------------------------------------------
    -- Audit Information
    ------------------------------------------------------------

    R.CreatedDate,

    R.ModifiedDate

FROM dbo.[Return] R

INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID

INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID

INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID

INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID

INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID

INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID

INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID

INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID

INNER JOIN dbo.ReturnReason RR
    ON R.ReturnReasonID = RR.ReturnReasonID

INNER JOIN dbo.ReturnStatus RS
    ON R.ReturnStatusID = RS.ReturnStatusID;

GO

PRINT 'View Created: vwReturnAnalysis';
PRINT '==============================================================';

/*==============================================================================
                    Part 9.1 : Create vwBusinessDashboard
==============================================================================*/

PRINT 'Creating View: vwBusinessDashboard...';

GO

CREATE OR ALTER VIEW dbo.vwBusinessDashboard
AS

SELECT

    ------------------------------------------------------------
    -- Customer KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.Customer
    ) AS TotalCustomers,

    (SELECT COUNT(*)
     FROM dbo.Customer
     WHERE IsActive = 1
    ) AS ActiveCustomers,

    ------------------------------------------------------------
    -- Product KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.Product
    ) AS TotalProducts,

    (SELECT COUNT(*)
     FROM dbo.Product
     WHERE IsActive = 1
    ) AS ActiveProducts,

    ------------------------------------------------------------
    -- Store KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.Store
    ) AS TotalStores,

    (SELECT COUNT(*)
     FROM dbo.Store
     WHERE IsActive = 1
    ) AS ActiveStores,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.[Order]
    ) AS TotalOrders,

    (SELECT ISNULL(SUM(NetAmount),0)
     FROM dbo.[Order]
    ) AS TotalSales,

    (SELECT ISNULL(AVG(NetAmount),0)
     FROM dbo.[Order]
    ) AS AverageOrderValue,

    ------------------------------------------------------------
    -- Payment KPIs
    ------------------------------------------------------------

    (SELECT ISNULL(SUM(Amount),0)
     FROM dbo.Payment
    ) AS TotalPayments,

    ------------------------------------------------------------
    -- Return KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.[Return]
    ) AS TotalReturns,

    (SELECT ISNULL(SUM(RefundAmount),0)
     FROM dbo.[Return]
    ) AS TotalRefundAmount,

    ------------------------------------------------------------
    -- Inventory KPIs
    ------------------------------------------------------------

    (SELECT COUNT(*)
     FROM dbo.Inventory
     WHERE QuantityInStock = 0
    ) AS OutOfStockProducts,

    (SELECT COUNT(*)
     FROM dbo.Inventory I
     INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
     WHERE I.QuantityInStock <= P.ReorderLevel
    ) AS LowStockProducts;

GO

PRINT 'View Created: vwBusinessDashboard';
PRINT '==============================================================';

/*==============================================================================
                    Part 9.2 : Create vwExecutiveSummary
==============================================================================*/

PRINT 'Creating View: vwExecutiveSummary...';

GO

CREATE OR ALTER VIEW dbo.vwExecutiveSummary
AS

SELECT

    ------------------------------------------------------------
    -- Year
    ------------------------------------------------------------

    YEAR(O.OrderDate) AS SalesYear,

    ------------------------------------------------------------
    -- Sales KPIs
    ------------------------------------------------------------

    COUNT(DISTINCT O.OrderID) AS TotalOrders,

    COUNT(DISTINCT O.CustomerID) AS TotalCustomers,

    SUM(O.NetAmount) AS TotalSales,

    AVG(O.NetAmount) AS AverageOrderValue,

    ------------------------------------------------------------
    -- Product KPIs
    ------------------------------------------------------------

    SUM(OI.Quantity) AS TotalItemsSold,

    COUNT(DISTINCT OI.ProductID) AS UniqueProductsSold,

    ------------------------------------------------------------
    -- Payment KPIs
    ------------------------------------------------------------

    ISNULL(SUM(P.Amount), 0) AS TotalPayments,

    ------------------------------------------------------------
    -- Return KPIs
    ------------------------------------------------------------

    COUNT(DISTINCT R.ReturnID) AS TotalReturns,

    ISNULL(SUM(R.RefundAmount), 0) AS TotalRefundAmount

FROM dbo.[Order] O

LEFT JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID

LEFT JOIN dbo.Payment P
    ON O.OrderID = P.OrderID

LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID

GROUP BY

    YEAR(O.OrderDate);

GO

PRINT 'View Created: vwExecutiveSummary';
PRINT '==============================================================';

/*==============================================================================
                    Part 10 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT 'All Reporting Views Created Successfully!';
PRINT '==============================================================';

PRINT 'Views Created:';
PRINT '  ✓ vwSalesSummary';
PRINT '  ✓ vwDailySales';
PRINT '  ✓ vwMonthlySales';
PRINT '  ✓ vwYearlySales';
PRINT '  ✓ vwCustomerOrders';
PRINT '  ✓ vwCustomerPurchaseHistory';
PRINT '  ✓ vwTopSellingProducts';
PRINT '  ✓ vwProductProfitability';
PRINT '  ✓ vwInventoryStatus';
PRINT '  ✓ vwLowStockProducts';
PRINT '  ✓ vwStorePerformance';
PRINT '  ✓ vwPaymentSummary';
PRINT '  ✓ vwReturnAnalysis';
PRINT '  ✓ vwBusinessDashboard';
PRINT '  ✓ vwExecutiveSummary';

PRINT '==============================================================';
PRINT '17_Create_Views.sql Completed Successfully.';
PRINT '==============================================================';
GO