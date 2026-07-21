/*------------------------------------------------------------------------------
KPI 106 : Top Selling Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest sales quantity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Top-selling products are the primary revenue drivers for a business.

Identifying these products helps:

• Improve Inventory Planning
• Increase Product Availability
• Optimize Marketing Campaigns
• Forecast Future Demand
• Improve Supply Chain Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Quantity Sold
• Total Revenue
• Average Selling Price

Displays the Top 10 selling products based on quantity sold.

------------------------------------------------------------------------------
*/

SELECT TOP (10)
    DENSE_RANK() OVER ( ORDER BY SUM(OI.Quantity) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    SUM(OI.LineTotal) AS TotalRevenue,
    ROUND(AVG(OI.UnitPrice),2) AS AverageSellingPrice
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
INNER JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID
GROUP BY
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    TotalQuantitySold DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 106 : Top Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 107 : Lowest Selling Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the lowest sales quantity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying low-selling products helps businesses:

• Detect slow-moving inventory
• Optimize warehouse space
• Improve inventory planning
• Plan promotional campaigns
• Identify products for discontinuation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Quantity Sold
• Total Revenue
• Average Selling Price

Displays the Bottom 10 selling products based on quantity sold.

------------------------------------------------------------------------------
*/

SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY SUM(OI.Quantity) ASC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    SUM(OI.LineTotal) AS TotalRevenue,
    ROUND(AVG(OI.UnitPrice),2) AS AverageSellingPrice
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
INNER JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID
GROUP BY
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    TotalQuantitySold ASC,
    TotalRevenue ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 107 : Lowest Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 108 : Revenue by Product
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue analysis helps identify the most profitable products from a sales
perspective.

This KPI supports:

• Product Revenue Analysis
• Product Portfolio Management
• Business Growth Strategy
• Product Performance Monitoring
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Quantity Sold
• Total Revenue
• Average Selling Price
• Revenue Contribution (%)

Displays the Top 10 products based on revenue.

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS
(
    SELECT

        P.ProductID,

        P.ProductName,

        B.BrandName,

        CAT.CategoryName,

        SUM(OI.Quantity) AS TotalQuantitySold,

        SUM(OI.LineTotal) AS TotalRevenue,

        AVG(OI.UnitPrice) AS AverageSellingPrice

    FROM dbo.Product P

    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID

    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID

    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID

    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID

    GROUP BY

        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
)

SELECT TOP (10)

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS ProductRank,

    ProductName,

    BrandName,

    CategoryName,

    TotalQuantitySold,

    TotalRevenue,

    ROUND
    (
        AverageSellingPrice,
        2
    ) AS AverageSellingPrice,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS RevenueContributionPercentage

FROM ProductRevenue

ORDER BY

    TotalRevenue DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 108 : Revenue by Product Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 109 : Revenue by Category
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product categories generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-wise revenue analysis helps businesses identify the strongest
performing product categories and allocate resources effectively.

This KPI supports:

• Category Performance Analysis
• Product Portfolio Optimization
• Marketing Budget Allocation
• Inventory Planning
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Rank
• Category Name
• Total Products
• Total Quantity Sold
• Total Revenue
• Average Selling Price
• Revenue Contribution (%)

Categories are ranked based on total revenue.

------------------------------------------------------------------------------
*/

WITH CategoryRevenue AS
(
    SELECT
        CAT.CategoryID,
        CAT.CategoryName,
        COUNT(DISTINCT P.ProductID) AS TotalProducts,
        SUM(OI.Quantity) AS TotalQuantitySold,
        SUM(OI.LineTotal) AS TotalRevenue,
        AVG(OI.UnitPrice) AS AverageSellingPrice
    FROM dbo.Category CAT
    INNER JOIN dbo.SubCategory SC
        ON CAT.CategoryID = SC.CategoryID
    INNER JOIN dbo.Product P
        ON SC.SubCategoryID = P.SubCategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        CAT.CategoryID,
        CAT.CategoryName
)
SELECT
    DENSE_RANK() OVER ( ORDER BY TotalRevenue DESC ) AS CategoryRank,
    CategoryName,
    TotalProducts,
    TotalQuantitySold,
    TotalRevenue,
    ROUND(AverageSellingPrice,2) AS AverageSellingPrice,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER(), 2) AS RevenueContributionPercentage
FROM CategoryRevenue
ORDER BY
    TotalRevenue DESC,
    CategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 109 : Revenue by Category Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 110 : Revenue by SubCategory
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product subcategories generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

SubCategory analysis provides a more detailed view of product performance
within each category.

This KPI supports:

• Product Mix Optimization
• Inventory Planning
• Marketing Strategy
• Category Management
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• SubCategory Rank
• Category Name
• SubCategory Name
• Total Products
• Total Quantity Sold
• Total Revenue
• Average Selling Price
• Revenue Contribution (%)

SubCategories are ranked based on revenue.

------------------------------------------------------------------------------
*/

WITH SubCategoryRevenue AS
(
    SELECT
        SC.SubCategoryID,
        CAT.CategoryName,
        SC.SubCategoryName,
        COUNT(DISTINCT P.ProductID) AS TotalProducts,
        SUM(OI.Quantity) AS TotalQuantitySold,
        SUM(OI.LineTotal) AS TotalRevenue,
        AVG(OI.UnitPrice) AS AverageSellingPrice
    FROM dbo.SubCategory SC
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.Product P
        ON SC.SubCategoryID = P.SubCategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        SC.SubCategoryID,
        CAT.CategoryName,
        SC.SubCategoryName
)
SELECT
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS SubCategoryRank,
    CategoryName,
    SubCategoryName,
    TotalProducts,
    TotalQuantitySold,
    TotalRevenue,
    ROUND(AverageSellingPrice,2) AS AverageSellingPrice,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER(),2) AS RevenueContributionPercentage
FROM SubCategoryRevenue
ORDER BY
    TotalRevenue DESC,
    CategoryName,
    SubCategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 110 : Revenue by SubCategory Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 111 : Product Profitability Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest profit?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

High revenue does not always mean high profitability.

Profitability analysis helps businesses:

• Identify High-Profit Products
• Improve Product Pricing
• Optimize Product Portfolio
• Increase Overall Profit Margin
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Quantity Sold
• Revenue
• Cost
• Profit
• Profit Margin (%)

Products are ranked based on Total Profit.

------------------------------------------------------------------------------
*/

WITH ProductProfitability AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.Quantity) AS TotalQuantitySold,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(P.CostPrice * OI.Quantity) AS TotalCost,
        SUM(OI.LineTotal) - SUM(P.CostPrice * OI.Quantity) AS TotalProfit
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
)
SELECT
    DENSE_RANK() OVER (ORDER BY TotalProfit DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantitySold,
    TotalRevenue,
    TotalCost,
    TotalProfit,
    ROUND( TotalProfit * 100.0 / NULLIF(TotalRevenue,0),2) AS ProfitMarginPercentage
FROM ProductProfitability
ORDER BY
    TotalProfit DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 111 : Product Profitability Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 112 : Product Margin Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest profit margin?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Profit margin analysis helps identify products that generate the highest
return on every sale.

This KPI supports:

• Pricing Strategy
• Product Portfolio Optimization
• Marketing Decisions
• Product Promotion
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Quantity Sold
• Revenue
• Cost
• Profit
• Profit Margin (%)

Products are ranked based on Profit Margin.

------------------------------------------------------------------------------
*/

WITH ProductMargin AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.Quantity) AS TotalQuantitySold,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(P.CostPrice * OI.Quantity) AS TotalCost,
        SUM(OI.LineTotal) - SUM(P.CostPrice * OI.Quantity) AS TotalProfit
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
)
SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY (TotalProfit * 100.0 / NULLIF(TotalRevenue,0)) DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantitySold,
    TotalRevenue,
    TotalCost,
    TotalProfit,
    ROUND(TotalProfit * 100.0 / NULLIF(TotalRevenue,0),2) AS ProfitMarginPercentage
FROM ProductMargin
ORDER BY
    ProfitMarginPercentage DESC,
    TotalProfit DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 112 : Product Margin Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 113 : Product Performance Ranking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products perform the best based on sales, revenue, and profitability?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product performance should not be measured using only sales quantity or
revenue.

A complete product evaluation should consider:

• Sales Quantity
• Revenue
• Profit

This KPI helps management identify the best overall performing products.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Overall Product Rank
• Product Name
• Brand
• Category
• Quantity Sold
• Revenue
• Profit
• Profit Margin (%)

Products are ranked by:

1. Total Revenue
2. Total Profit
3. Quantity Sold

------------------------------------------------------------------------------
*/

WITH ProductPerformance AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.Quantity) AS TotalQuantitySold,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(P.CostPrice * OI.Quantity) AS TotalCost,
        SUM(OI.LineTotal) - SUM(P.CostPrice * OI.Quantity) AS TotalProfit
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
)
SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC, TotalProfit DESC, TotalQuantitySold DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantitySold,
    TotalRevenue,
    TotalCost,
    TotalProfit,
    ROUND(TotalProfit * 100.0 / NULLIF(TotalRevenue,0),2) AS ProfitMarginPercentage
FROM ProductPerformance
ORDER BY
    TotalRevenue DESC,
    TotalProfit DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 113 : Product Performance Ranking Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 114 : Product Sales Contribution
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much does each product contribute to the overall business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Not every product contributes equally to business revenue.

Understanding revenue contribution helps businesses:

• Identify Key Revenue Drivers
• Optimize Product Portfolio
• Improve Marketing Investments
• Support Business Strategy
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Revenue
• Revenue Contribution (%)
• Cumulative Revenue Contribution (%)

Products are ranked by total revenue.

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
)
SELECT
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER(),2) AS RevenueContributionPercentage,
    ROUND(SUM(TotalRevenue) OVER(ORDER BY TotalRevenue DESC ROWS UNBOUNDED PRECEDING) * 100.0 / SUM(TotalRevenue) OVER(), 2) AS CumulativeRevenueContributionPercentage
FROM ProductRevenue
ORDER BY
    TotalRevenue DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 114 : Product Sales Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 115 : Product Pareto Analysis (80/20 Rule)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products contribute to approximately 80% of total business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Pareto Principle (80/20 Rule) states that a small percentage of products
often generate the majority of business revenue.

This KPI helps businesses:

• Identify Key Revenue Drivers
• Prioritize Inventory Investment
• Optimize Product Portfolio
• Focus Marketing Efforts
• Improve Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Revenue
• Revenue Contribution (%)
• Cumulative Revenue Contribution (%)
• Pareto Classification

Products contributing to the first 80% of revenue are classified as:

• Top 80% Revenue Contributors

Remaining products are classified as:

• Remaining 20%

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
),
ParetoAnalysis AS
(
    SELECT
        ProductName,
        BrandName,
        CategoryName,
        TotalRevenue,
        ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER(),2) AS RevenueContributionPercentage,
        ROUND(SUM(TotalRevenue) OVER(ORDER BY TotalRevenue DESC ROWS UNBOUNDED PRECEDING) * 100.0 / SUM(TotalRevenue) OVER(),2) AS CumulativeRevenueContributionPercentage
    FROM ProductRevenue
)
SELECT
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalRevenue,
    RevenueContributionPercentage,
    CumulativeRevenueContributionPercentage,
    CASE
        WHEN CumulativeRevenueContributionPercentage <= 80 THEN 'Top 80% Revenue Contributors'
        ELSE 'Remaining 20%'
    END AS ParetoCategory
FROM ParetoAnalysis
ORDER BY
    TotalRevenue DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 115 : Product Pareto Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 116 : Fast Moving Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are selling the fastest, and is the available inventory
sufficient to meet demand?

------------------------------------------------------------------------------
Business Logic
------------------------------------------------------------------------------

Inventory Coverage Ratio =

Current Stock / Total Quantity Sold

Coverage Ratio < 20  -> Critical

Coverage Ratio < 30  -> Low Stock

Coverage Ratio < 45  -> Healthy

Coverage Ratio >=45  -> Overstocked

------------------------------------------------------------------------------
*/

WITH ProductSales AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.Quantity) AS TotalQuantitySold
    FROM dbo.Product P
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName
),
InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock,
        MAX(LastRestockedDate) AS LastRestockedDate
    FROM dbo.Inventory
    GROUP BY ProductID
),
CoverageAnalysis AS
(
    SELECT
        PS.ProductID,
        PS.ProductName,
        PS.BrandName,
        PS.CategoryName,
        PS.TotalQuantitySold,
        ISNULL(ISM.CurrentStock,0) AS CurrentStock,
        CAST(ISNULL(ISM.CurrentStock,0) * 1.0 / NULLIF(PS.TotalQuantitySold,0) AS DECIMAL(10,2)) AS InventoryCoverageRatio,
        ISM.LastRestockedDate
    FROM ProductSales PS
    LEFT JOIN InventorySummary ISM
        ON PS.ProductID = ISM.ProductID
)
SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY TotalQuantitySold DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantitySold,
    CurrentStock,
    InventoryCoverageRatio,
    CASE
        WHEN InventoryCoverageRatio < 20 THEN 'Critical'
        WHEN InventoryCoverageRatio < 30 THEN 'Low Stock'
        WHEN InventoryCoverageRatio < 45 THEN 'Healthy'
        ELSE
            'Overstocked'
    END AS InventoryStatus,
    LastRestockedDate
FROM CoverageAnalysis
ORDER BY
    TotalQuantitySold DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 116 : Fast Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 117 : Products Never Sold
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have never been sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI helps identify:

• Dead Inventory
• Non-performing Products
• Overstocked Items
• Products requiring promotion
• Product Catalog Optimization

------------------------------------------------------------------------------
*/

SELECT
    P.ProductID,
    P.ProductName,
    B.BrandName,
	CAT.CategoryName,
    SUM(I.QuantityInStock) AS CurrentStock,
    MAX(I.LastRestockedDate) AS LastRestockedDate
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
LEFT JOIN dbo.Inventory I
    ON P.ProductID = I.ProductID
LEFT JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID
WHERE
    OI.ProductID IS NULL
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    CurrentStock DESC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 117 : Products Never Sold Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 118 : Top 10 Slow Moving Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the lowest sales quantity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI helps identify:

• Slow Moving Products
• Dead Inventory Risk
• Overstocked Products
• Promotion Opportunities
• Product Portfolio Optimization

------------------------------------------------------------------------------
*/

SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY SUM(OI.Quantity)) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(I.QuantityInStock) AS CurrentStock
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
INNER JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
LEFT JOIN dbo.Inventory I
    ON P.ProductID = I.ProductID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    TotalQuantitySold,
    TotalOrders,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 118 : Top 10 Slow Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 119 : Top 10 Overstocked Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest inventory compared to their sales?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI helps identify:

• Overstocked Products
• Excess Inventory
• Slow Inventory Turnover
• Capital Locked in Inventory
• Products requiring promotions

------------------------------------------------------------------------------
*/

WITH ProductSales AS
(
    SELECT
        ProductID,
        SUM(Quantity) AS TotalQuantitySold
    FROM dbo.OrderItem
    GROUP BY ProductID
),
InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
)
SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY(ISNULL(I.CurrentStock,0) * 1.0 / NULLIF(PS.TotalQuantitySold,0)) DESC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    PS.TotalQuantitySold,
    I.CurrentStock,
    CAST(I.CurrentStock * 1.0 / NULLIF(PS.TotalQuantitySold,0) AS DECIMAL(10,2)) AS InventoryCoverageRatio
FROM dbo.Product P
INNER JOIN ProductSales PS
    ON P.ProductID = PS.ProductID
INNER JOIN InventorySummary I
    ON P.ProductID = I.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    InventoryCoverageRatio DESC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 119 : Top 10 Overstocked Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 120 : Products Requiring Immediate Reorder
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products require immediate replenishment?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI helps:

• Prevent Stockouts
• Improve Customer Satisfaction
• Support Procurement Planning
• Maintain Inventory Availability
• Reduce Lost Sales

------------------------------------------------------------------------------
Business Logic
------------------------------------------------------------------------------

Current Stock < 2500

------------------------------------------------------------------------------
*/

WITH InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock,
        MAX(LastRestockedDate) AS LastRestockedDate
    FROM dbo.Inventory
    GROUP BY ProductID
)
SELECT
    DENSE_RANK() OVER(ORDER BY ISM.CurrentStock) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    ISM.CurrentStock,
    ISM.LastRestockedDate,
    CASE
        WHEN ISM.CurrentStock < 1500 THEN 'Critical'
        WHEN ISM.CurrentStock < 2500 THEN 'Reorder'
        ELSE 'Sufficient'
    END AS InventoryStatus
FROM dbo.Product P
INNER JOIN InventorySummary ISM
    ON P.ProductID = ISM.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
WHERE
    ISM.CurrentStock < 2500
ORDER BY
    ISM.CurrentStock,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 120 : Products Requiring Immediate Reorder Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO