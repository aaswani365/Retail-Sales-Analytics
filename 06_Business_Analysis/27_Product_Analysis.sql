/*------------------------------------------------------------------------------
KPI 136 : Top Selling Products
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
PRINT 'KPI 136 : Top Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 137 : Lowest Selling Products
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
PRINT 'KPI 137 : Lowest Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 138 : Revenue by Product
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
PRINT 'KPI 138 : Revenue by Product Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 139 : Revenue by Category
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
PRINT 'KPI 139 : Revenue by Category Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 140 : Revenue by SubCategory
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
PRINT 'KPI 140 : Revenue by SubCategory Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 141 : Product Profitability Analysis
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
PRINT 'KPI 141 : Product Profitability Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 142 : Product Margin Analysis
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
PRINT 'KPI 142 : Product Margin Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 143 : Product Performance Ranking
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
PRINT 'KPI 143 : Product Performance Ranking Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 144 : Product Sales Contribution
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
PRINT 'KPI 144 : Product Sales Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 145 : Product Pareto Analysis (80/20 Rule)
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
PRINT 'KPI 145 : Product Pareto Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 146 : Fast Moving Products
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
PRINT 'KPI 146 : Fast Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 147 : Products Never Sold
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
PRINT 'KPI 147 : Products Never Sold Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 148 : Top 10 Slow Moving Products
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
PRINT 'KPI 148 : Top 10 Slow Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 149 : Top 10 Overstocked Products
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
PRINT 'KPI 149 : Top 10 Overstocked Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 150 : Products Requiring Immediate Reorder
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
PRINT 'KPI 150 : Products Requiring Immediate Reorder Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 151 : Product Revenue Contribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products contribute the highest percentage of total business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI identifies products contributing the largest share of total revenue,
helping management prioritize inventory, pricing, and promotional strategies.

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

------------------------------------------------------------------------------*/

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
    ROUND(
        TotalRevenue * 100.0 /
        SUM(TotalRevenue) OVER (),
        2
    ) AS RevenueContributionPercentage
FROM ProductRevenue
ORDER BY TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 151 : Product Revenue Contribution Generated Successfully';
PRINT '==============================================================';

/*------------------------------------------------------------------------------
KPI 152 : Product Revenue Contribution Percentage
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of the total business revenue is contributed by each product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding each product's contribution to total revenue helps identify
high-value products, revenue concentration, and opportunities for portfolio
optimization.

This KPI supports:

• Product Portfolio Analysis
• Revenue Concentration Analysis
• Product Prioritization
• Marketing Investment Decisions
• Inventory Optimization

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

Products are ranked based on revenue generated.

------------------------------------------------------------------------------*/

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
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContributionPercentage
FROM ProductRevenue
ORDER BY
    ProductRank;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 152 : Product Revenue Contribution Percentage Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 153 : Top Products by Profit
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest profit?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue alone does not indicate business success. Products with high revenue
may have low profitability due to higher procurement costs.

This KPI helps management:

• Identify high-profit products
• Optimize pricing strategy
• Improve product portfolio decisions
• Focus marketing on profitable products
• Increase overall business profitability

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Revenue
• Estimated Cost
• Estimated Profit
• Profit Margin %

Products are ranked by highest profit.

Assumption:
Supplier.UnitCost represents the procurement cost of each product.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    DENSE_RANK() OVER(ORDER BY SUM(OI.LineTotal) - SUM(OI.Quantity * OI.UnitPrice) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity * OI.UnitPrice) AS EstimatedCost,
    SUM(OI.LineTotal) - SUM(OI.Quantity * OI.UnitPrice) AS EstimatedProfit,
    ROUND((SUM(OI.LineTotal) - SUM(OI.Quantity * OI.UnitPrice)) * 100.0 / SUM(OI.LineTotal),2) AS ProfitMarginPercentage
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
    EstimatedProfit DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 153 : Top Products by Profit Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 154 : Products Never Sold
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have never been sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Products with zero sales occupy inventory space, increase carrying costs,
and reduce overall inventory efficiency.

This KPI helps management:

• Identify dead inventory
• Optimize inventory levels
• Remove obsolete products
• Improve product portfolio
• Plan promotional campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Product Name
• Brand
• Category
• Current Stock
• Product Status

Only products with no sales history are displayed.

------------------------------------------------------------------------------*/

SELECT
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    ISNULL(SUM(I.QuantityInStock),0) AS CurrentStock,
    'Never Sold' AS ProductStatus
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
LEFT JOIN dbo.OrderItem OI
    ON P.ProductID = OI.ProductID
LEFT JOIN dbo.Inventory I
    ON P.ProductID = I.ProductID
WHERE OI.ProductID IS NULL
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    CurrentStock DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 154 : Products Never Sold Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 155 : Product Sales Frequency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products appear in the highest number of customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

A product that appears in many different orders demonstrates strong
customer demand and consistent purchasing behavior.

This KPI helps management:

• Identify frequently purchased products
• Improve product placement
• Optimize cross-selling opportunities
• Support inventory planning
• Forecast product demand

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Orders
• Total Quantity Sold
• Average Quantity per Order

Products are ranked based on the number of distinct orders.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT OI.OrderID) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    COUNT(DISTINCT OI.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(CAST(SUM(OI.Quantity) AS DECIMAL(18,2)) / COUNT(DISTINCT OI.OrderID),2) AS AverageQuantityPerOrder
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
    TotalOrders DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 155 : Product Sales Frequency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 156 : Highest Average Selling Price Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest average selling price?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Products with a high average selling price generally contribute higher
revenue per transaction and often represent premium or luxury products.

This KPI helps management:

• Identify premium products
• Optimize pricing strategy
• Understand product positioning
• Improve product portfolio analysis
• Support premium product marketing

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Average Selling Price
• Highest Selling Price
• Lowest Selling Price
• Total Quantity Sold

Products are ranked by their average selling price.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER (ORDER BY AVG(OI.UnitPrice) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    ROUND(AVG(OI.UnitPrice),2) AS AverageSellingPrice,
    MAX(OI.UnitPrice) AS HighestSellingPrice,
    MIN(OI.UnitPrice) AS LowestSellingPrice,
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
    P.ProductName,
    B.BrandName,
    CAT.CategoryName
ORDER BY
    AverageSellingPrice DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 156 : Highest Average Selling Price Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 157 : Fast Moving Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are selling the fastest based on sales volume compared to
their available inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Fast-moving products require frequent replenishment and play a critical role
in inventory planning.

This KPI helps management:

• Prevent stock-outs
• Improve inventory replenishment
• Identify high-demand products
• Optimize warehouse planning
• Improve demand forecasting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Current Stock
• Total Quantity Sold
• Inventory Turnover Ratio

Products are ranked based on Inventory Turnover Ratio.

Formula:

Inventory Turnover Ratio =
Total Quantity Sold / Current Stock

Higher ratio = Faster Moving Product

------------------------------------------------------------------------------*/

WITH ProductInventory AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
),
ProductSales AS
(
    SELECT
        ProductID,
        SUM(Quantity) AS TotalQuantitySold
    FROM dbo.OrderItem
    GROUP BY ProductID
)
SELECT
    DENSE_RANK() OVER (ORDER BY CAST(PS.TotalQuantitySold AS DECIMAL(18,2)) / NULLIF(PI.CurrentStock,0) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    PI.CurrentStock,
    PS.TotalQuantitySold,
    ROUND(CAST(PS.TotalQuantitySold AS DECIMAL(18,2)) / NULLIF(PI.CurrentStock,0),2) AS InventoryTurnoverRatio
FROM dbo.Product P
INNER JOIN ProductInventory PI
    ON P.ProductID = PI.ProductID
INNER JOIN ProductSales PS
    ON P.ProductID = PS.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    InventoryTurnoverRatio DESC,
    PS.TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 157 : Fast Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 158 : Slow Moving Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the lowest inventory turnover ratio?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Slow-moving products remain in inventory for long periods and increase
holding costs while occupying valuable warehouse space.

This KPI helps management:

• Identify excess inventory
• Reduce inventory carrying costs
• Plan product promotions
• Optimize procurement
• Remove obsolete products

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Current Stock
• Total Quantity Sold
• Inventory Turnover Ratio

Products are ranked from the slowest moving to the fastest.

Formula:

Inventory Turnover Ratio =
Total Quantity Sold / Current Stock

Lower Ratio = Slow Moving Product

------------------------------------------------------------------------------*/

WITH ProductInventory AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
),
ProductSales AS
(
    SELECT
        ProductID,
        SUM(Quantity) AS TotalQuantitySold
    FROM dbo.OrderItem
    GROUP BY ProductID
)
SELECT TOP (20)
    DENSE_RANK() OVER(ORDER BY CAST(PS.TotalQuantitySold AS DECIMAL(18,2)) / NULLIF(PI.CurrentStock,0) ASC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    PI.CurrentStock,
    PS.TotalQuantitySold,
    ROUND(CAST(PS.TotalQuantitySold AS DECIMAL(18,2)) / NULLIF(PI.CurrentStock,0),2) AS InventoryTurnoverRatio
FROM dbo.Product P
INNER JOIN ProductInventory PI
    ON P.ProductID = PI.ProductID
INNER JOIN ProductSales PS
    ON P.ProductID = PS.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    InventoryTurnoverRatio ASC,
    PI.CurrentStock DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 158 : Slow Moving Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 159 : Highest Revenue Generating Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest total revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue generated by each product helps management identify the most valuable
products in terms of sales performance.

This KPI helps:

• Identify revenue-driving products
• Prioritize high-value inventory
• Improve pricing strategies
• Allocate marketing budget effectively
• Support product portfolio decisions

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
• Revenue Percentage

Products are ranked by Total Revenue.

------------------------------------------------------------------------------*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        SUM(OI.Quantity) AS TotalQuantitySold,
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
    DENSE_RANK() OVER(ORDER BY TotalRevenue DESC) AS ProductRank,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantitySold,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenuePercentage
FROM ProductRevenue
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 159 : Highest Revenue Generating Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 160 : Products with Highest Average Revenue Per Order
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest average revenue whenever they are purchased?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Some products may not sell frequently but generate significant revenue
each time they are purchased.

This KPI helps management:

• Identify premium products
• Optimize pricing strategies
• Improve product positioning
• Increase Average Order Value (AOV)
• Focus marketing on high-value products

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Total Orders
• Total Revenue
• Average Revenue Per Order

Products are ranked by Average Revenue Per Order.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(OI.LineTotal) / COUNT(DISTINCT OI.OrderID) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    COUNT(DISTINCT OI.OrderID) AS TotalOrders,
    SUM(OI.LineTotal) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) * 1.0 / COUNT(DISTINCT OI.OrderID),2) AS AverageRevenuePerOrder
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
    AverageRevenuePerOrder DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 160 : Products with Highest Average Revenue Per Order Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 161 : Product Return Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest return rate?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Products with high return rates may indicate poor quality, incorrect
descriptions, sizing issues, or customer dissatisfaction.

This KPI helps management:

• Improve product quality
• Reduce return costs
• Optimize supplier performance
• Improve customer satisfaction
• Identify problematic products

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Quantity Sold
• Quantity Returned
• Return Rate (%)

Formula:

Return Rate (%) =
(Quantity Returned / Quantity Sold) × 100

------------------------------------------------------------------------------*/

WITH ProductSales AS
(
    SELECT
        ProductID,
        SUM(Quantity) AS TotalQuantitySold
    FROM dbo.OrderItem
    GROUP BY ProductID
),
ProductReturns AS
(
    SELECT
        OI.ProductID,
        SUM(R.QuantityReturned) AS TotalQuantityReturned
    FROM dbo.[Return] R
    INNER JOIN dbo.OrderItem OI
        ON R.OrderItemID = OI.OrderItemID
    GROUP BY
        OI.ProductID
)
SELECT
    DENSE_RANK() OVER (ORDER BY ISNULL(PR.TotalQuantityReturned,0) * 100.0 / NULLIF(PS.TotalQuantitySold,0) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    PS.TotalQuantitySold,
    ISNULL(PR.TotalQuantityReturned,0) AS TotalQuantityReturned,
    ROUND(ISNULL(PR.TotalQuantityReturned,0) * 100.0 / NULLIF(PS.TotalQuantitySold,0),2) AS ReturnRatePercentage
FROM dbo.Product P
INNER JOIN ProductSales PS
    ON P.ProductID = PS.ProductID
LEFT JOIN ProductReturns PR
    ON P.ProductID = PR.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    ReturnRatePercentage DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 161 : Product Return Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 162 : Products with Highest Inventory Value
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products represent the highest inventory investment?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Value measures the amount of capital tied up in stock.

Products with high inventory value require close monitoring because they
have a significant impact on working capital and inventory carrying costs.

This KPI helps management:

• Monitor inventory investment
• Optimize working capital
• Identify overstocked expensive products
• Improve procurement planning
• Reduce inventory holding costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Current Stock
• Average Selling Price
• Inventory Value

Formula:

Inventory Value =
Current Stock × Average Selling Price

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
),
AveragePrice AS
(
    SELECT
        ProductID,
        AVG(UnitPrice) AS AverageSellingPrice
    FROM dbo.OrderItem
    GROUP BY ProductID
)
SELECT
    DENSE_RANK() OVER (ORDER BY INV.CurrentStock * AP.AverageSellingPrice DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    INV.CurrentStock,
    ROUND(AP.AverageSellingPrice,2) AS AverageSellingPrice,
    ROUND(INV.CurrentStock * AP.AverageSellingPrice,2) AS InventoryValue
FROM dbo.Product P
INNER JOIN InventorySummary INV
    ON P.ProductID = INV.ProductID
INNER JOIN AveragePrice AP
    ON P.ProductID = AP.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    InventoryValue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 162 : Products with Highest Inventory Value Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 163 : Inventory Days on Hand
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many days of inventory are currently available for each product based
on historical sales?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Days on Hand (DOH) measures how long current inventory will last
based on average daily sales.

This KPI helps management:

• Identify overstocked products
• Prevent stock shortages
• Improve replenishment planning
• Optimize warehouse utilization
• Reduce inventory carrying costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product Name
• Brand
• Category
• Current Stock
• Total Quantity Sold
• Average Daily Sales
• Inventory Days on Hand

Formula:

Average Daily Sales =
Total Quantity Sold / Number of Sales Days

Inventory Days =
Current Stock / Average Daily Sales

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
),
SalesSummary AS
(
    SELECT
        OI.ProductID,
        SUM(OI.Quantity) AS TotalQuantitySold,
        COUNT(DISTINCT CAST(O.OrderDate AS DATE)) AS SalesDays
    FROM dbo.OrderItem OI
    INNER JOIN dbo.[Order] O
        ON OI.OrderID = O.OrderID
    GROUP BY
        OI.ProductID
)
SELECT
    DENSE_RANK() OVER(ORDER BY INV.CurrentStock / NULLIF(SS.TotalQuantitySold * 1.0 / NULLIF(SS.SalesDays,0),0) DESC) AS ProductRank,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    INV.CurrentStock,
    SS.TotalQuantitySold,
    ROUND(SS.TotalQuantitySold * 1.0 / NULLIF(SS.SalesDays,0),2) AS AverageDailySales,
    ROUND(INV.CurrentStock / NULLIF(SS.TotalQuantitySold * 1.0 / NULLIF(SS.SalesDays,0),0),2) AS InventoryDaysOnHand
FROM dbo.Product P
INNER JOIN InventorySummary INV
    ON P.ProductID = INV.ProductID
INNER JOIN SalesSummary SS
    ON P.ProductID = SS.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    InventoryDaysOnHand DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 163 : Inventory Days on Hand Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 164 : Product Stock Health Classification
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are Overstocked, Healthy, Low Stock, or Critical Stock based
on inventory coverage?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory health classification enables inventory managers to quickly
identify products requiring replenishment or inventory reduction.

This KPI helps management:

• Prevent stockouts
• Reduce excess inventory
• Improve replenishment planning
• Optimize warehouse space
• Support procurement decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Brand
• Category
• Current Stock
• Average Daily Sales
• Inventory Days
• Stock Health Status

Business Rules

Inventory Days > 60        → Overstocked
Inventory Days 30–60       → Healthy
Inventory Days 15–30       → Low Stock
Inventory Days < 15        → Critical

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        ProductID,
        SUM(QuantityInStock) AS CurrentStock
    FROM dbo.Inventory
    GROUP BY ProductID
),
SalesSummary AS
(
    SELECT
        OI.ProductID,
        SUM(OI.Quantity) AS TotalQuantitySold,
        COUNT(DISTINCT CAST(O.OrderDate AS DATE)) AS SalesDays
    FROM dbo.OrderItem OI
    INNER JOIN dbo.[Order] O
        ON OI.OrderID = O.OrderID
    GROUP BY OI.ProductID
),
InventoryCoverage AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        CAT.CategoryName,
        ISUM.CurrentStock,
        ROUND(SS.TotalQuantitySold * 1.0 / NULLIF(SS.SalesDays,0),2) AS AverageDailySales,
        ROUND(ISUM.CurrentStock / NULLIF(SS.TotalQuantitySold * 1.0 / NULLIF(SS.SalesDays,0),0),2) AS InventoryDays
    FROM dbo.Product P
    INNER JOIN InventorySummary ISUM
        ON P.ProductID = ISUM.ProductID
    INNER JOIN SalesSummary SS
        ON P.ProductID = SS.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category CAT
        ON SC.CategoryID = CAT.CategoryID
)
SELECT
    ProductName,
    BrandName,
    CategoryName,
    CurrentStock,
    AverageDailySales,
    InventoryDays,
    CASE
        WHEN InventoryDays > 60 THEN 'Overstocked'
        WHEN InventoryDays BETWEEN 30 AND 60 THEN 'Healthy'
        WHEN InventoryDays BETWEEN 15 AND 29.99 THEN 'Low Stock'
        ELSE 'Critical'
    END AS StockHealthStatus
FROM InventoryCoverage
ORDER BY
    InventoryDays DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 164 : Product Stock Health Classification Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 165 : Product Performance Scorecard
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products perform best when considering Sales, Revenue, Returns,
and Inventory together?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Looking at only revenue or sales does not provide a complete picture.

This KPI combines multiple performance indicators into one executive
scorecard for better decision-making.

This KPI helps management:

• Identify Star Products
• Detect Underperforming Products
• Improve Inventory Planning
• Optimize Product Portfolio
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Brand
• Category
• Quantity Sold
• Total Revenue
• Current Stock
• Quantity Returned
• Return Rate %
• Inventory Value
• Performance Rating

Performance Rating Rules

Excellent
    Revenue >= 100000
    AND Return Rate < 5%

Good
    Revenue >= 50000
    AND Return Rate < 10%

Average
    Revenue >= 25000

Needs Attention
    Otherwise

------------------------------------------------------------------------------
*/

WITH SalesSummary AS
(
    SELECT
        ProductID,
        SUM(Quantity) AS QuantitySold,
        SUM(LineTotal) AS TotalRevenue,
        AVG(UnitPrice) AS AverageSellingPrice
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
),
ReturnSummary AS
(
    SELECT
        OI.ProductID,
        SUM(R.QuantityReturned) AS QuantityReturned
    FROM dbo.[Return] R
    INNER JOIN dbo.OrderItem OI
        ON R.OrderItemID = OI.OrderItemID
    GROUP BY
        OI.ProductID
)
SELECT
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SS.QuantitySold,
    SS.TotalRevenue,
    ISUM.CurrentStock,
    ISNULL(RS.QuantityReturned,0) AS QuantityReturned,
    ROUND(ISNULL(RS.QuantityReturned,0) * 100.0 / NULLIF(SS.QuantitySold,0),2) AS ReturnRatePercentage,
    ROUND(ISUM.CurrentStock * SS.AverageSellingPrice,2) AS InventoryValue,
    CASE
        WHEN
            SS.TotalRevenue >= 100000 AND (ISNULL(RS.QuantityReturned,0) * 100.0 / NULLIF(SS.QuantitySold,0)) < 5 THEN 'Excellent'
        WHEN
            SS.TotalRevenue >= 50000 AND (ISNULL(RS.QuantityReturned,0) * 100.0 / NULLIF(SS.QuantitySold,0)) < 10 THEN 'Good'
        WHEN
            SS.TotalRevenue >= 25000 THEN 'Average'
        ELSE 'Needs Attention'
    END AS PerformanceRating
FROM dbo.Product P
INNER JOIN SalesSummary SS
    ON P.ProductID = SS.ProductID
INNER JOIN InventorySummary ISUM
    ON P.ProductID = ISUM.ProductID
LEFT JOIN ReturnSummary RS
    ON P.ProductID = RS.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
ORDER BY
    SS.TotalRevenue DESC,
    ReturnRatePercentage ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 165 : Product Performance Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';
