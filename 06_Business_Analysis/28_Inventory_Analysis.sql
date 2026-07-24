/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 28_Inventory_Analysis.sql
Description     : Inventory Analysis KPIs for Inventory Performance Insights

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

KPI Range       : 166 - 195
Total KPIs      : 30
Difficulty      : Intermediate → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module analyzes inventory performance, stock availability, inventory
health, replenishment, distribution, utilization, and operational
efficiency to generate actionable business insights.

These KPIs help organizations optimize inventory management, improve stock
availability, reduce stockout risks, enhance replenishment planning,
balance inventory across stores, and support data-driven operational and
executive decision-making.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Inventory Analysis

KPI Range          : 166 - 195

Total KPIs         : 30

Estimated Runtime  : < 20 Seconds

Primary SQL Concepts
--------------------

• SELECT
• GROUP BY
• INNER JOIN
• Common Table Expressions (CTE)
• Aggregate Functions
• Window Functions
• CASE
• DATE Functions
• DATEDIFF
• DATEADD
• ISNULL
• NULLIF
• HAVING
• TOP
• Ranking Functions
• Conditional Aggregation

==============================================================================*/

USE RetailSalesDB;
GO

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT '28_Inventory_Analysis.sql';
PRINT '==============================================================';

PRINT 'Starting Inventory Analysis KPI Module...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 166 : Inventory Overview
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall inventory status across all products and stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Overview provides a high-level summary of inventory records,
stock availability, store coverage, and product distribution.

This KPI serves as the foundation for the entire Inventory Analysis module.

It helps management:

• Monitor Overall Inventory Size
• Measure Product Availability
• Understand Store Coverage
• Analyze Stock Distribution
• Support Inventory Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Inventory Records
• Total Products in Inventory
• Total Stores Maintaining Inventory
• Total Quantity in Stock
• Average Quantity per Inventory Record
• Highest Stock Quantity
• Lowest Stock Quantity
• Products with Available Stock
• Products with Zero Stock

------------------------------------------------------------------------------*/

SELECT
    COUNT(*) AS TotalInventoryRecords,
    COUNT(DISTINCT ProductID) AS TotalProducts,
    COUNT(DISTINCT StoreID) AS TotalStores,
    SUM(QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(QuantityInStock AS DECIMAL(18,2))),2) AS AverageQuantityPerRecord,
    MAX(QuantityInStock) AS HighestStockQuantity,
    MIN(QuantityInStock) AS LowestStockQuantity,
    COUNT(DISTINCT
        CASE
            WHEN QuantityInStock > 0 THEN ProductID
        END
    ) AS ProductsAvailable,
    COUNT(DISTINCT
        CASE
            WHEN QuantityInStock = 0 THEN ProductID
        END
    ) AS ProductsOutOfStock
FROM dbo.Inventory;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 166 : Inventory Overview Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 167 : Store-wise Current Stock Status
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is inventory distributed across different stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-wise inventory analysis helps management understand stock
distribution, identify inventory imbalances, and support replenishment
planning.

This KPI helps management:

• Monitor Inventory by Store
• Compare Store Stock Levels
• Identify High and Low Stock Stores
• Improve Inventory Allocation
• Support Store Replenishment Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Rank
• Store ID
• Store Name
• Total Products
• Total Quantity in Stock
• Average Quantity per Product
• Highest Stock Level
• Lowest Stock Level

Stores are ranked based on total stock quantity.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(I.QuantityInStock) DESC) AS StoreRank,
    S.StoreID,
    S.StoreName,
    COUNT(DISTINCT I.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageQuantityPerProduct,
    MAX(I.QuantityInStock) AS HighestStockLevel,
    MIN(I.QuantityInStock) AS LowestStockLevel
FROM dbo.Inventory I
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
GROUP BY
    S.StoreID,
    S.StoreName
ORDER BY
    TotalQuantityInStock DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 167 : Store-wise Current Stock Status Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 168 : Low Stock Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products currently have low stock levels across all stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Low stock products can lead to stockouts, lost sales, and poor customer
experience if they are not replenished in time.

This KPI helps management:

• Identify Low Stock Products
• Prioritize Inventory Replenishment
• Reduce Stockout Risk
• Improve Inventory Planning
• Support Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Total Quantity in Stock
• Number of Stores Carrying the Product

Business Rule

Products having total stock less than or equal to 20 units
are considered Low Stock Products.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(I.QuantityInStock) ASC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    COUNT(DISTINCT I.StoreID) AS AvailableStores
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName
HAVING
    SUM(I.QuantityInStock) <= 20
ORDER BY
    TotalQuantityInStock ASC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 168 : Low Stock Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 169 : Out of Stock Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are completely out of stock across all stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Out-of-stock products directly impact customer satisfaction and revenue.

Identifying these products helps management:

• Prevent Lost Sales
• Prioritize Product Replenishment
• Improve Inventory Availability
• Reduce Stockout Incidents
• Support Procurement Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Total Quantity in Stock
• Number of Stores Maintaining Inventory

Business Rule

Products having Total Quantity in Stock = 0
are considered Out of Stock.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY P.ProductName) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    COUNT(DISTINCT I.StoreID) AS InventoryStores
FROM dbo.Product P
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Inventory I
    ON P.ProductID = I.ProductID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName
HAVING
    SUM(I.QuantityInStock) = 0
ORDER BY
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 169 : Out of Stock Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 170 : Highest Stock Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products currently have the highest stock quantity across all stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying products with high inventory levels helps businesses detect
potential overstock situations, optimize inventory investment, and improve
stock balancing.

This KPI helps management:

• Identify Overstocked Products
• Optimize Inventory Allocation
• Reduce Holding Costs
• Improve Inventory Turnover
• Support Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Total Quantity in Stock
• Number of Stores Carrying the Product
• Average Stock per Store

Displays the Top 10 products with the highest inventory quantity.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    DENSE_RANK() OVER(ORDER BY SUM(I.QuantityInStock) DESC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    COUNT(DISTINCT I.StoreID) AS TotalStores,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageStockPerStore
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName
ORDER BY
    TotalQuantityInStock DESC,
    AverageStockPerStore DESC;
    
PRINT '';

PRINT '==============================================================';
PRINT 'KPI 170 : Highest Stock Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 171 : Inventory by Category
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is inventory distributed across product categories?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-level inventory analysis helps businesses understand inventory
distribution, identify overstocked or understocked categories, and improve
inventory planning.

This KPI helps management:

• Analyze Inventory Distribution
• Compare Category Stock Levels
• Optimize Inventory Investment
• Improve Procurement Planning
• Support Category Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Rank
• Category Name
• Total Products
• Total Stores
• Total Quantity in Stock
• Average Stock per Product

Categories are ranked based on total inventory quantity.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(I.QuantityInStock) DESC) AS CategoryRank,
    C.CategoryName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    COUNT(DISTINCT I.StoreID) AS TotalStores,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageStockPerProduct
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    C.CategoryName
ORDER BY
    TotalQuantityInStock DESC,
    CategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 171 : Inventory by Category Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 172 : Inventory by Brand
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is inventory distributed across different product brands?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand-wise inventory analysis helps businesses understand stock allocation,
identify brands with excessive or insufficient inventory, and support
procurement decisions.

This KPI helps management:

• Compare Inventory by Brand
• Optimize Brand-level Inventory
• Improve Procurement Planning
• Identify Overstocked Brands
• Support Brand Performance Analysis

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Brand Rank
• Brand Name
• Total Products
• Total Stores
• Total Quantity in Stock
• Average Stock per Product

Brands are ranked based on total inventory quantity.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(I.QuantityInStock) DESC) AS BrandRank,
    B.BrandName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    COUNT(DISTINCT I.StoreID) AS TotalStores,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageStockPerProduct
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
GROUP BY
    B.BrandName
ORDER BY
    TotalQuantityInStock DESC,
    BrandName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 172 : Inventory by Brand Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 173 : Average Stock per Product
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average stock level maintained for each product across stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average stock per product helps businesses evaluate inventory distribution,
identify products with consistently high or low stock levels, and optimize
inventory allocation.

This KPI helps management:

• Monitor Product Stock Levels
• Improve Inventory Allocation
• Balance Stock Across Stores
• Support Replenishment Planning
• Optimize Inventory Holding

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Total Stores
• Total Quantity in Stock
• Average Stock per Store

Products are ranked based on average stock maintained per store.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY AVG(I.QuantityInStock) DESC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    COUNT(DISTINCT I.StoreID) AS TotalStores,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageStockPerStore
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName
ORDER BY
    AverageStockPerStore DESC,
    TotalQuantityInStock DESC;
    
PRINT '';

PRINT '==============================================================';
PRINT 'KPI 173 : Average Stock per Product Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 174 : Recently Restocked Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have been restocked most recently?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Recently restocked products indicate active inventory replenishment and
help businesses monitor procurement activities.

This KPI helps management:

• Track Recent Inventory Replenishment
• Monitor Procurement Activity
• Verify Stock Availability
• Support Inventory Audits
• Improve Supply Chain Visibility

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Store Name
• Current Stock Quantity
• Last Restocked Date
• Days Since Last Restocked

Products are ranked by the most recent restocking date.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY I.LastRestockedDate DESC) AS ProductRank,
	P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    I.LastRestockedDate,
    DATEDIFF(DAY,I.LastRestockedDate,GETDATE()) AS DaysSinceLastRestocked
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
WHERE
    I.LastRestockedDate IS NOT NULL
ORDER BY
    I.LastRestockedDate DESC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 174 : Recently Restocked Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 175 : Products Never Restocked
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which inventory records have never been restocked?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Products that have never been restocked may indicate:

• Slow-moving inventory
• Newly introduced products
• Overstocked products
• Procurement planning opportunities

This KPI helps management:

• Identify Products Never Replenished
• Review Inventory Strategy
• Monitor Product Lifecycle
• Improve Procurement Planning
• Support Inventory Audits

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Store Name
• Current Stock Quantity
• Inventory Created Date
• Last Restocked Date

Business Rule

Products where LastRestockedDate IS NULL
are considered Never Restocked.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY I.CreatedDate ASC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    I.CreatedDate,
    I.LastRestockedDate
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
WHERE
    I.LastRestockedDate IS NULL
ORDER BY
    I.CreatedDate ASC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 175 : Products Never Restocked Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 177 : Stock Concentration by Store
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores hold the largest share of the company's inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding inventory concentration helps businesses identify inventory
imbalances across stores and optimize stock allocation.

This KPI helps management:

• Identify High Inventory Stores
• Balance Inventory Distribution
• Improve Store Replenishment
• Optimize Warehouse Operations
• Reduce Excess Inventory

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Rank
• Store ID
• Store Name
• Total Products
• Total Quantity in Stock
• Inventory Share (%)

Stores are ranked by total inventory quantity.

------------------------------------------------------------------------------*/

WITH StoreInventory AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        COUNT(DISTINCT I.ProductID) AS TotalProducts,
        SUM(I.QuantityInStock) AS TotalQuantityInStock
    FROM dbo.Store S
    INNER JOIN dbo.Inventory I
        ON S.StoreID = I.StoreID
    GROUP BY
        S.StoreID,
        S.StoreName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalQuantityInStock DESC) AS StoreRank,
    StoreID,
    StoreName,
    TotalProducts,
    TotalQuantityInStock,
    ROUND(TotalQuantityInStock * 100.0 / SUM(TotalQuantityInStock) OVER (),2) AS InventorySharePercentage
FROM StoreInventory
ORDER BY
    TotalQuantityInStock DESC,
    StoreName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 177 : Stock Concentration by Store Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 178 : Inventory Coverage by Category
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much of the company's inventory is allocated to each product category?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory coverage by category helps businesses understand how inventory
investment is distributed across product categories.

This KPI helps management:

• Measure Category-wise Inventory Allocation
• Identify Inventory Concentration
• Optimize Category Planning
• Improve Inventory Balancing
• Support Strategic Procurement

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Rank
• Category Name
• Total Products
• Total Quantity in Stock
• Inventory Share (%)

Categories are ranked based on total stock quantity.

------------------------------------------------------------------------------*/

WITH CategoryInventory AS
(
    SELECT
        C.CategoryID,
        C.CategoryName,
        COUNT(DISTINCT P.ProductID) AS TotalProducts,
        SUM(I.QuantityInStock) AS TotalQuantityInStock
    FROM dbo.Inventory I
    INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category C
        ON SC.CategoryID = C.CategoryID
    GROUP BY
        C.CategoryID,
        C.CategoryName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalQuantityInStock DESC) AS CategoryRank,
    CategoryName,
    TotalProducts,
    TotalQuantityInStock,
    ROUND(TotalQuantityInStock * 100.0 / SUM(TotalQuantityInStock) OVER (),2) AS InventorySharePercentage
FROM CategoryInventory
ORDER BY
    TotalQuantityInStock DESC,
    CategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 178 : Inventory Coverage by Category Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 179 : Inventory Coverage by Brand
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much of the company's inventory is allocated to each brand?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand-wise inventory coverage helps businesses understand inventory
distribution across brands and supports procurement, supplier management,
and inventory balancing.

This KPI helps management:

• Measure Brand-wise Inventory Allocation
• Compare Inventory Across Brands
• Identify High Inventory Brands
• Optimize Procurement Planning
• Improve Inventory Distribution

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Brand Rank
• Brand Name
• Total Products
• Total Quantity in Stock
• Inventory Share (%)

Brands are ranked based on total stock quantity.

------------------------------------------------------------------------------*/

WITH BrandInventory AS
(
    SELECT
        B.BrandID,
        B.BrandName,
        COUNT(DISTINCT P.ProductID) AS TotalProducts,
        SUM(I.QuantityInStock) AS TotalQuantityInStock
    FROM dbo.Inventory I
    INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    GROUP BY
        B.BrandID,
        B.BrandName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalQuantityInStock DESC) AS BrandRank,
    BrandName,
    TotalProducts,
    TotalQuantityInStock,
    ROUND(TotalQuantityInStock * 100.0 / SUM(TotalQuantityInStock) OVER (),2) AS InventorySharePercentage
FROM BrandInventory
ORDER BY
    TotalQuantityInStock DESC,
    BrandName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 179 : Inventory Coverage by Brand Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 180 : Inventory Health Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How healthy is the inventory for each product based on stock availability
and replenishment activity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Health Score provides a quick assessment of inventory quality.

Products with healthy inventory are adequately stocked and recently
replenished, while unhealthy inventory may require immediate attention.

This KPI helps management:

• Monitor Inventory Health
• Identify Inventory Risk
• Improve Replenishment Planning
• Reduce Stockout Risk
• Optimize Inventory Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Total Quantity in Stock
• Days Since Last Restocked
• Inventory Health

Business Rules

Healthy Inventory

• Quantity >= 50
• Restocked within last 30 days

Moderate Inventory

• Quantity between 20 and 49
• Restocked within last 90 days

Otherwise

Needs Attention

------------------------------------------------------------------------------*/

WITH ProductInventory AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName,
        SUM(I.QuantityInStock) AS TotalQuantityInStock,
        MAX(I.LastRestockedDate) AS LatestRestockedDate
    FROM dbo.Inventory I
    INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category C
        ON SC.CategoryID = C.CategoryID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalQuantityInStock DESC) AS ProductRank,
    ProductID,
    ProductName,
    BrandName,
    CategoryName,
    TotalQuantityInStock,
    LatestRestockedDate,
    DATEDIFF(DAY,ISNULL(LatestRestockedDate, GETDATE()),GETDATE()) AS DaysSinceLastRestocked,
    CASE
        WHEN TotalQuantityInStock >= 50 AND DATEDIFF(DAY,ISNULL(LatestRestockedDate, GETDATE()),GETDATE()) <= 30 THEN 'Healthy'
        WHEN TotalQuantityInStock >= 20 AND DATEDIFF(DAY,ISNULL(LatestRestockedDate, GETDATE()),GETDATE()) <= 90 THEN 'Moderate'
        ELSE 'Needs Attention'
    END AS InventoryHealth
FROM ProductInventory
ORDER BY
    TotalQuantityInStock DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 180 : Inventory Health Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 181 : Inventory Balance Across Stores
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the most uneven inventory distribution across stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Balanced inventory ensures products are available where customers need them.

Large differences in stock levels between stores may indicate poor inventory
allocation, unnecessary transfers, or replenishment issues.

This KPI helps management:

• Detect Inventory Imbalance
• Optimize Stock Allocation
• Reduce Inter-store Transfers
• Improve Product Availability
• Support Inventory Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Number of Stores
• Highest Store Stock
• Lowest Store Stock
• Stock Difference

Products are ranked by stock imbalance.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY MAX(I.QuantityInStock) - MIN(I.QuantityInStock) DESC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    COUNT(DISTINCT I.StoreID) AS TotalStores,
    MAX(I.QuantityInStock) AS HighestStoreStock,
    MIN(I.QuantityInStock) AS LowestStoreStock,
    MAX(I.QuantityInStock) - MIN(I.QuantityInStock) AS StockDifference
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName
ORDER BY
    StockDifference DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 181 : Inventory Balance Across Stores Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 182 : Inventory Freshness Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How fresh is the inventory based on the latest replenishment activity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory freshness helps businesses monitor replenishment efficiency and
identify products that may require attention due to infrequent restocking.

This KPI helps management:

• Monitor Inventory Freshness
• Evaluate Replenishment Frequency
• Improve Procurement Planning
• Reduce Inventory Risk
• Support Inventory Audits

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Store Name
• Quantity in Stock
• Last Restocked Date
• Days Since Last Restocked
• Freshness Status

Business Rules

0–30 Days      → Fresh Inventory
31–90 Days     → Stable Inventory
91–180 Days    → Aging Inventory
181+ Days      → Stale Inventory

If LastRestockedDate is NULL,
CreatedDate is used instead.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) ASC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    I.LastRestockedDate,
    DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) AS DaysSinceLastRestocked,
    CASE
        WHEN DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) <= 30 THEN 'Fresh Inventory'
		WHEN DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) <= 90 THEN 'Stable Inventory'
        WHEN DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) <= 180 THEN 'Aging Inventory'
        ELSE 'Stale Inventory'
    END AS FreshnessStatus
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
ORDER BY
    DaysSinceLastRestocked ASC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 182 : Inventory Freshness Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 183 : Store Inventory Utilization
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores maintain the highest average inventory per product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory utilization helps identify stores carrying excessive or
insufficient stock relative to the number of products they maintain.

This KPI helps management:

• Compare Inventory Utilization
• Identify Overstocked Stores
• Optimize Inventory Allocation
• Improve Stock Balancing
• Support Store Performance Evaluation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Rank
• Store ID
• Store Name
• Total Products
• Total Quantity in Stock
• Average Stock per Product

Stores are ranked by average stock maintained per product.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY AVG(I.QuantityInStock) DESC) AS StoreRank,
    S.StoreID,
    S.StoreName,
    COUNT(DISTINCT I.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageStockPerProduct
FROM dbo.Inventory I
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
GROUP BY
    S.StoreID,
    S.StoreName
ORDER BY
    AverageStockPerProduct DESC,
    TotalQuantityInStock DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 183 : Store Inventory Utilization Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 184 : Inventory Availability Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of inventory records currently have stock available?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory availability is one of the most important operational KPIs.

High inventory availability ensures products remain available for sale
while reducing stockout risk.

This KPI helps management:

• Measure Inventory Availability
• Monitor Stock Health
• Reduce Stockouts
• Improve Customer Satisfaction
• Support Inventory Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Inventory Records
• Available Inventory Records
• Out of Stock Records
• Inventory Availability Percentage
• Inventory Availability Status

Business Rules

>= 95%  → Excellent
90–94%  → Good
80–89%  → Moderate
< 80%   → Needs Improvement

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        COUNT(*) AS TotalInventoryRecords,
        SUM(
            CASE
                WHEN QuantityInStock > 0 THEN 1
                ELSE 0
            END
        ) AS AvailableInventoryRecords,
        SUM(
            CASE
                WHEN QuantityInStock = 0 THEN 1
                ELSE 0
            END
        ) AS OutOfStockRecords
    FROM dbo.Inventory
)
SELECT
    TotalInventoryRecords,
    AvailableInventoryRecords,
    OutOfStockRecords,
    ROUND(AvailableInventoryRecords * 100.0 / TotalInventoryRecords,2) AS InventoryAvailabilityPercentage,
    CASE
        WHEN AvailableInventoryRecords * 100.0 / TotalInventoryRecords >= 95 THEN 'Excellent'
        WHEN AvailableInventoryRecords * 100.0 / TotalInventoryRecords >= 90 THEN 'Good'
		WHEN AvailableInventoryRecords * 100.0 / TotalInventoryRecords >= 80 THEN 'Moderate'
        ELSE 'Needs Improvement'
    END AS InventoryAvailabilityStatus
FROM InventorySummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 184 : Inventory Availability Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 185 : Stock Distribution Efficiency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How efficiently is inventory distributed across stores for each product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Balanced inventory distribution reduces stock shortages, minimizes
inter-store transfers, and improves product availability.

This KPI helps management:

• Evaluate Inventory Distribution
• Identify Stock Imbalance
• Improve Store Allocation
• Reduce Inventory Transfers
• Optimize Supply Chain Operations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Number of Stores
• Highest Store Stock
• Lowest Store Stock
• Stock Difference
• Distribution Status

Business Rules

Stock Difference

0–10   → Well Balanced
11–30  → Moderate
>30    → Poor Distribution

------------------------------------------------------------------------------*/

WITH ProductDistribution AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName,
        COUNT(DISTINCT I.StoreID) AS TotalStores,
        MAX(I.QuantityInStock) AS HighestStoreStock,
        MIN(I.QuantityInStock) AS LowestStoreStock,
        MAX(I.QuantityInStock) - MIN(I.QuantityInStock) AS StockDifference
    FROM dbo.Inventory I
    INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category C
        ON SC.CategoryID = C.CategoryID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName
)
SELECT
    DENSE_RANK() OVER(ORDER BY StockDifference ASC) AS ProductRank,
    ProductID,
    ProductName,
    BrandName,
    CategoryName,
    TotalStores,
    HighestStoreStock,
    LowestStoreStock,
    StockDifference,
    CASE
        WHEN StockDifference <= 10 THEN 'Well Balanced'
        WHEN StockDifference <= 30 THEN 'Moderate'
        ELSE 'Poor Distribution'
    END AS DistributionStatus
FROM ProductDistribution
ORDER BY
    StockDifference ASC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 185 : Stock Distribution Efficiency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 186 : Multi-Store Product Coverage
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many stores currently stock each product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product availability across multiple stores improves customer experience
and reduces the risk of lost sales.

Products available in only a few stores may indicate distribution issues
or limited market reach.

This KPI helps management:

• Measure Product Coverage
• Identify Limited Distribution
• Improve Product Availability
• Optimize Store Allocation
• Support Expansion Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Stores Carrying the Product
• Total Quantity in Stock
• Coverage Status

Business Rules

1 Store        → Limited Coverage
2–4 Stores     → Moderate Coverage
5+ Stores      → Wide Coverage

------------------------------------------------------------------------------*/

WITH ProductCoverage AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName,
        COUNT(DISTINCT I.StoreID) AS StoresCovered,
        SUM(I.QuantityInStock) AS TotalQuantityInStock
    FROM dbo.Inventory I
    INNER JOIN dbo.Product P
        ON I.ProductID = P.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category C
        ON SC.CategoryID = C.CategoryID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        C.CategoryName
)
SELECT
    DENSE_RANK() OVER(ORDER BY StoresCovered DESC) AS ProductRank,
    ProductID,
    ProductName,
    BrandName,
    CategoryName,
    StoresCovered,
    TotalQuantityInStock,
    CASE
        WHEN StoresCovered = 1 THEN 'Limited Coverage'
        WHEN StoresCovered BETWEEN 2 AND 4 THEN 'Moderate Coverage'
        ELSE 'Wide Coverage'
    END AS CoverageStatus
FROM ProductCoverage
ORDER BY
    StoresCovered DESC,
    TotalQuantityInStock DESC,
    ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 186 : Multi-Store Product Coverage Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 187 : Inventory Risk Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which inventory items are at the highest operational risk?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory risk analysis helps businesses proactively identify products that
may experience stock shortages or require immediate replenishment.

This KPI helps management:

• Detect High-Risk Inventory
• Reduce Stockout Risk
• Improve Replenishment Planning
• Optimize Inventory Control
• Support Operational Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Store Name
• Quantity in Stock
• Days Since Last Restocked
• Inventory Risk Level

Business Rules

High Risk

• QuantityInStock <= 10
OR
• Last Restocked more than 180 days ago

Medium Risk

• QuantityInStock between 11 and 30
OR
• Last Restocked between 91 and 180 days

Otherwise

Low Risk

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY I.QuantityInStock ASC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) AS DaysSinceLastRestocked,
    CASE
        WHEN I.QuantityInStock <= 10 OR DATEDIFF(DAY,ISNULL(I.LastRestockedDate,I.CreatedDate),GETDATE()) > 180 THEN 'High Risk'
        WHEN I.QuantityInStock BETWEEN 11 AND 30 OR DATEDIFF(DAY,ISNULL(I.LastRestockedDate,I.CreatedDate),GETDATE()) BETWEEN 91 AND 180
			THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS InventoryRiskLevel
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
ORDER BY
    CASE
        WHEN I.QuantityInStock <= 10 OR DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) > 180 THEN 1
        WHEN I.QuantityInStock BETWEEN 11 AND 30 OR DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) BETWEEN 91 AND 180 THEN 2
        ELSE 3
    END,
    I.QuantityInStock ASC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 187 : Inventory Risk Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 188 : Inventory Exception Report
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which inventory records require immediate operational attention?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Exception Reporting helps businesses quickly identify abnormal
inventory situations requiring corrective action.

This KPI helps management:

• Identify Critical Inventory Issues
• Prioritize Replenishment
• Improve Inventory Monitoring
• Reduce Operational Risk
• Support Daily Inventory Operations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies inventory records that satisfy ANY of the following
conditions:

• Out of Stock
• Low Stock (<= 10 Units)
• Never Restocked
• Last Restocked More Than 180 Days Ago

The report includes:

• Exception Type
• Product Details
• Store
• Current Stock
• Last Restocked Date
• Inventory Age

------------------------------------------------------------------------------*/

SELECT
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    I.LastRestockedDate,
    DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) AS InventoryAgeDays,
    CASE
		WHEN I.QuantityInStock = 0 THEN 'Out of Stock'
        WHEN I.QuantityInStock <= 10 THEN 'Low Stock'
        WHEN I.LastRestockedDate IS NULL THEN 'Never Restocked'
        WHEN DATEDIFF(DAY,I.LastRestockedDate,GETDATE()) > 180 THEN 'Old Inventory'
    END AS ExceptionType
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
WHERE
       I.QuantityInStock = 0
    OR I.QuantityInStock <= 10
    OR I.LastRestockedDate IS NULL
    OR DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) > 180
ORDER BY
    CASE
        WHEN I.QuantityInStock = 0 THEN 1
        WHEN I.QuantityInStock <= 10 THEN 2
        WHEN I.LastRestockedDate IS NULL THEN 3
        ELSE 4
    END,
    InventoryAgeDays DESC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 188 : Inventory Exception Report Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 189 : Inventory Replenishment Priority
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which inventory items should be replenished first?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Replenishment prioritization helps inventory teams focus on products that
require immediate attention, reducing stockout risk and improving product
availability.

This KPI helps management:

• Prioritize Inventory Replenishment
• Improve Procurement Planning
• Reduce Stock Shortages
• Optimize Inventory Operations
• Support Supply Chain Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Rank
• Product ID
• Product Name
• Brand
• Category
• Store Name
• Current Stock
• Days Since Last Restocked
• Replenishment Priority

Business Rules

Critical

• QuantityInStock <= 5

High

• QuantityInStock BETWEEN 6 AND 15

Medium

• QuantityInStock BETWEEN 16 AND 30

Low

• QuantityInStock > 30

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY I.QuantityInStock ASC) AS ProductRank,
    P.ProductID,
    P.ProductName,
    B.BrandName,
    C.CategoryName,
    S.StoreName,
    I.QuantityInStock,
    DATEDIFF(DAY,ISNULL(I.LastRestockedDate, I.CreatedDate),GETDATE()) AS DaysSinceLastRestocked,
    CASE
        WHEN I.QuantityInStock <= 5 THEN 'Critical'
        WHEN I.QuantityInStock BETWEEN 6 AND 15 THEN 'High'
		WHEN I.QuantityInStock BETWEEN 16 AND 30 THEN 'Medium'
        ELSE 'Low'
    END AS ReplenishmentPriority
FROM dbo.Inventory I
INNER JOIN dbo.Product P
    ON I.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.Store S
    ON I.StoreID = S.StoreID
ORDER BY
    CASE
        WHEN I.QuantityInStock <= 5 THEN 1
        WHEN I.QuantityInStock BETWEEN 6 AND 15 THEN 2
        WHEN I.QuantityInStock BETWEEN 16 AND 30 THEN 3
        ELSE 4
    END,
    DaysSinceLastRestocked DESC,
    I.QuantityInStock ASC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 189 : Inventory Replenishment Priority Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 190 : Store Inventory Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How effectively is each store managing its inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-level inventory performance helps identify stores with healthy stock
levels and stores requiring inventory optimization.

This KPI helps management:

• Compare Store Inventory Performance
• Monitor Inventory Availability
• Improve Inventory Allocation
• Support Store Operations
• Optimize Inventory Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Rank
• Store ID
• Store Name
• Total Products
• Total Quantity in Stock
• Average Quantity per Product
• Out of Stock Products
• Inventory Performance Status

Business Rules

Excellent

• Average Stock >= 50
• No Out of Stock Products

Good

• Average Stock >= 30

Needs Improvement

• Otherwise

------------------------------------------------------------------------------*/

WITH StoreInventory AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        COUNT(DISTINCT I.ProductID) AS TotalProducts,
        SUM(I.QuantityInStock) AS TotalQuantityInStock,
        AVG(CAST(I.QuantityInStock AS DECIMAL(18,2)))
            AS AverageQuantityPerProduct,
        SUM(
            CASE
                WHEN I.QuantityInStock = 0 THEN 1
                ELSE 0
            END
        ) AS OutOfStockProducts
    FROM dbo.Store S
    INNER JOIN dbo.Inventory I
        ON S.StoreID = I.StoreID
    GROUP BY
        S.StoreID,
        S.StoreName
)
SELECT
    DENSE_RANK() OVER(ORDER BY AverageQuantityPerProduct DESC) AS StoreRank,
    StoreID,
    StoreName,
    TotalProducts,
    TotalQuantityInStock,
    ROUND(AverageQuantityPerProduct,2)
        AS AverageQuantityPerProduct,
    OutOfStockProducts,
    CASE
        WHEN AverageQuantityPerProduct >= 50 AND OutOfStockProducts = 0 THEN 'Excellent'
        WHEN AverageQuantityPerProduct >= 30 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS InventoryPerformance
FROM StoreInventory
ORDER BY
    AverageQuantityPerProduct DESC,
    TotalQuantityInStock DESC,
    StoreName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 190 : Store Inventory Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 191 : Inventory KPI Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What are the key inventory performance indicators in one consolidated view?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Inventory KPI Dashboard provides management with a high-level summary
of inventory performance and operational health.

This KPI helps management:

• Monitor Inventory Performance
• Track Inventory Availability
• Identify Inventory Risks
• Measure Stock Distribution
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Inventory Records
• Total Products
• Total Stores
• Total Quantity in Stock
• Average Quantity per Inventory Record
• Products Available
• Products Out of Stock
• Recently Restocked Records (Last 30 Days)
• Never Restocked Records

------------------------------------------------------------------------------*/

SELECT
    COUNT(*) AS TotalInventoryRecords,
    COUNT(DISTINCT ProductID) AS TotalProducts,
    COUNT(DISTINCT StoreID) AS TotalStores,
    SUM(QuantityInStock) AS TotalQuantityInStock,
    ROUND(AVG(CAST(QuantityInStock AS DECIMAL(18,2))),2) AS AverageQuantityPerRecord,
    SUM(
        CASE
            WHEN QuantityInStock > 0 THEN 1
            ELSE 0
        END
    ) AS AvailableInventoryRecords,
    SUM(
        CASE
            WHEN QuantityInStock = 0 THEN 1
            ELSE 0
        END
    ) AS OutOfStockInventoryRecords,
    SUM(
        CASE
            WHEN LastRestockedDate >= DATEADD(DAY,-30,GETDATE()) THEN 1
            ELSE 0
        END
    ) AS RecentlyRestockedRecords,
    SUM(
        CASE
            WHEN LastRestockedDate IS NULL THEN 1
            ELSE 0
        END
    ) AS NeverRestockedRecords
FROM dbo.Inventory;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 191 : Inventory KPI Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 192 : Inventory Operational Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall operational score of the inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Operational Score combines multiple inventory indicators into a
single performance metric that executives can monitor over time.

This KPI helps management:

• Measure Overall Inventory Performance
• Monitor Inventory Operations
• Track Inventory Quality
• Identify Operational Improvements
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Inventory Availability %
• Recently Restocked %
• Never Restocked %
• Operational Score

Operational Score Formula

Inventory Availability Percentage
+
Recently Restocked Percentage
-
Never Restocked Percentage

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        COUNT(*) AS TotalInventoryRecords,
        SUM(
            CASE
                WHEN QuantityInStock > 0 THEN 1
                ELSE 0
            END
        ) AS AvailableInventory,
        SUM(
            CASE
                WHEN LastRestockedDate >= DATEADD(DAY,-30,GETDATE())THEN 1
                ELSE 0
            END
        ) AS RecentlyRestocked,
        SUM(
            CASE
                WHEN LastRestockedDate IS NULL THEN 1
                ELSE 0
            END
        ) AS NeverRestocked
    FROM dbo.Inventory
)
SELECT
    ROUND(AvailableInventory * 100.0 / TotalInventoryRecords,2) AS InventoryAvailabilityPercentage,
    ROUND(RecentlyRestocked * 100.0 / TotalInventoryRecords,2) AS RecentlyRestockedPercentage,
    ROUND(NeverRestocked * 100.0 / TotalInventoryRecords,2) AS NeverRestockedPercentage,
    ROUND(((AvailableInventory * 100.0 / TotalInventoryRecords) + 
	(RecentlyRestocked * 100.0 / TotalInventoryRecords) - 
	(NeverRestocked * 100.0 / TotalInventoryRecords)),2) AS InventoryOperationalScore
FROM InventorySummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 192 : Inventory Operational Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 193 : Inventory Health Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many inventory records fall into each inventory health category?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Health Dashboard classifies inventory into operational health
groups, allowing management to quickly identify healthy inventory and
inventory requiring attention.

This KPI helps management:

• Monitor Inventory Health
• Identify Critical Inventory
• Improve Inventory Planning
• Reduce Stockout Risk
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query classifies inventory records into:

• Healthy Inventory
• Moderate Inventory
• Needs Attention

Business Rules

Healthy

• QuantityInStock >= 50
AND
• Last Restocked within 30 Days

Moderate

• QuantityInStock BETWEEN 20 AND 49
OR
• Last Restocked within 90 Days

Needs Attention

• All Remaining Inventory

------------------------------------------------------------------------------*/

WITH InventoryHealth AS
(
    SELECT
        CASE
            WHEN QuantityInStock >= 50 AND DATEDIFF(DAY,ISNULL(LastRestockedDate, CreatedDate),GETDATE()) <= 30 THEN 'Healthy'
            WHEN QuantityInStock BETWEEN 20 AND 49 OR DATEDIFF(DAY,ISNULL(LastRestockedDate, CreatedDate),GETDATE()) <= 90 THEN 'Moderate'
            ELSE 'Needs Attention'
        END AS InventoryHealthStatus
    FROM dbo.Inventory
)
SELECT
    InventoryHealthStatus,
    COUNT(*) AS InventoryRecords,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS Percentage
FROM InventoryHealth
GROUP BY
    InventoryHealthStatus
ORDER BY
    CASE InventoryHealthStatus
        WHEN 'Healthy' THEN 1
        WHEN 'Moderate' THEN 2
        ELSE 3
    END;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 193 : Inventory Health Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 194 : Inventory Performance Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What are the overall inventory performance metrics?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Inventory Performance Dashboard provides a consolidated operational
view of inventory performance across the organization.

This KPI helps management:

• Monitor Inventory Performance
• Evaluate Inventory Availability
• Track Stock Health
• Measure Inventory Utilization
• Support Operational Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Inventory Records
• Total Products
• Total Stores
• Total Inventory Quantity
• Average Quantity per Record
• Available Inventory Records
• Out of Stock Records
• Recently Restocked Records
• Never Restocked Records
• Inventory Availability %
• Inventory Utilization %

------------------------------------------------------------------------------*/

WITH InventorySummary AS
(
    SELECT
        COUNT(*) AS TotalInventoryRecords,
        COUNT(DISTINCT ProductID) AS TotalProducts,
        COUNT(DISTINCT StoreID) AS TotalStores,
        SUM(QuantityInStock) AS TotalInventoryQuantity,
        AVG(CAST(QuantityInStock AS DECIMAL(18,2)))AS AverageQuantity,
        SUM(
            CASE
                WHEN QuantityInStock > 0 THEN 1
                ELSE 0
            END
        ) AS AvailableInventory,
        SUM(
            CASE
                WHEN QuantityInStock = 0 THEN 1
                ELSE 0
            END
        ) AS OutOfStockInventory,
        SUM(
            CASE
                WHEN LastRestockedDate >= DATEADD(DAY,-30,GETDATE()) THEN 1
                ELSE 0
            END
        ) AS RecentlyRestocked,
        SUM(
            CASE
                WHEN LastRestockedDate IS NULL THEN 1
                ELSE 0
            END
        ) AS NeverRestocked
    FROM dbo.Inventory
)
SELECT
    TotalInventoryRecords,
    TotalProducts,
    TotalStores,
    TotalInventoryQuantity,
    ROUND(AverageQuantity,2) AS AverageQuantityPerRecord,
    AvailableInventory,
    OutOfStockInventory,
    RecentlyRestocked,
    NeverRestocked,
    ROUND(AvailableInventory * 100.0 / TotalInventoryRecords,2) AS InventoryAvailabilityPercentage,
    ROUND(TotalInventoryQuantity * 1.0 / TotalProducts,2) AS AverageStockPerProduct
FROM InventorySummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 194 : Inventory Performance Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 195 : Inventory Executive Scorecard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall operational health of the inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Inventory Executive Scorecard provides a single-page executive summary
of inventory performance using key operational indicators.

This KPI helps management:

• Measure Overall Inventory Health
• Monitor Inventory Availability
• Evaluate Inventory Quality
• Track Operational Performance
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Inventory Records
• Total Products
• Total Stores
• Inventory Availability %
• Recently Restocked %
• Never Restocked %
• Out of Stock %
• Executive Inventory Rating

Business Rules

Excellent

• Availability >= 95%
AND
• Out of Stock <= 2%

Good

• Availability >= 90%
AND
• Out of Stock <= 5%

Otherwise

Needs Improvement

------------------------------------------------------------------------------*/

WITH InventoryScorecard AS
(
    SELECT
        COUNT(*) AS TotalInventoryRecords,
        COUNT(DISTINCT ProductID) AS TotalProducts,
        COUNT(DISTINCT StoreID) AS TotalStores,
        SUM(
            CASE
                WHEN QuantityInStock > 0 THEN 1
                ELSE 0
            END
        ) AS AvailableInventory,
        SUM(
            CASE
                WHEN QuantityInStock = 0 THEN 1
                ELSE 0
            END
        ) AS OutOfStockInventory,
        SUM(
            CASE
                WHEN LastRestockedDate >= DATEADD(DAY,-30,GETDATE()) THEN 1
                ELSE 0
            END
        ) AS RecentlyRestocked,
        SUM(
            CASE
                WHEN LastRestockedDate IS NULL THEN 1
                ELSE 0
            END
        ) AS NeverRestocked
    FROM dbo.Inventory
)
SELECT
    TotalInventoryRecords,
    TotalProducts,
    TotalStores,
    ROUND(AvailableInventory * 100.0 / TotalInventoryRecords,2) AS InventoryAvailabilityPercentage,
    ROUND(OutOfStockInventory * 100.0 / TotalInventoryRecords,2) AS OutOfStockPercentage,
    ROUND(RecentlyRestocked * 100.0 / TotalInventoryRecords,2) AS RecentlyRestockedPercentage,
    ROUND(NeverRestocked * 100.0 / TotalInventoryRecords,2) AS NeverRestockedPercentage,
    CASE
        WHEN(AvailableInventory * 100.0 /TotalInventoryRecords) >= 95 AND (OutOfStockInventory * 100.0 /TotalInventoryRecords) <= 2 THEN 'Excellent'
        WHEN(AvailableInventory * 100.0 / TotalInventoryRecords) >= 90 AND (OutOfStockInventory * 100.0 / TotalInventoryRecords) <= 5 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS ExecutiveInventoryRating
FROM InventoryScorecard;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 195 : Inventory Executive Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';