/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 32_Supplier_Analysis.sql
Description     : Supplier Analysis KPIs for Supplier Performance Insights

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

KPI Range       : 286 - 315
Total KPIs      : 30
Difficulty      : Intermediate → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module analyzes supplier performance, procurement efficiency, inventory
investment, supplier profitability, business contribution, operational
performance, supplier dependency, procurement risk, and executive supplier
scorecards to generate actionable business insights.

These KPIs help organizations evaluate supplier effectiveness, optimize
procurement strategies, reduce supply chain risks, improve vendor
relationships, strengthen supplier performance monitoring, and support
data-driven procurement and executive decision-making.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Supplier Analysis

KPI Range          : 286 - 315

Total KPIs         : 30

Estimated Runtime  : < 20 Seconds

Primary SQL Concepts
--------------------

• SELECT
• GROUP BY
• INNER JOIN
• LEFT JOIN
• Common Table Expressions (CTE)
• Aggregate Functions
• Window Functions
• CASE
• ISNULL
• NULLIF
• HAVING
• TOP
• DENSE_RANK
• LAG
• Conditional Aggregation
• Ranking Functions
• Financial Calculations
• Weighted Score Calculations

==============================================================================*/

USE RetailSalesDB;
GO

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT '32_Supplier_Analysis.sql';
PRINT '==============================================================';

PRINT 'Starting Supplier Analysis KPI Module...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 286 : Supplier Overview
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall summary of suppliers in the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Overview provides a high-level summary of supplier information.
It helps management understand supplier availability, product sourcing,
inventory support, and supplier participation across the business.

This KPI helps management:

• Monitor Supplier Base
• Measure Active Suppliers
• Analyze Product Coverage
• Evaluate Inventory Support
• Support Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Suppliers
• Active Suppliers
• Inactive Suppliers
• Total Products Supplied
• Average Products per Supplier

------------------------------------------------------------------------------*/

SELECT
    COUNT(*) AS TotalSuppliers,
    SUM(
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END) AS ActiveSuppliers,
    SUM(
        CASE
            WHEN IsActive = 0 THEN 1
            ELSE 0
        END) AS InactiveSuppliers,
    (
        SELECT COUNT(*)
        FROM dbo.Product
    ) AS TotalProducts,
    ROUND((SELECT COUNT(*) * 1.0 FROM dbo.Product) / NULLIF(COUNT(*), 0),2) AS AverageProductsPerSupplier
FROM dbo.Supplier;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 286 : Supplier Overview Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 287 : Total Active Suppliers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many suppliers are currently active and available to supply products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Active Suppliers represent vendors currently available for procurement and
inventory replenishment. Monitoring active suppliers ensures supply chain
continuity and helps identify whether the business has sufficient sourcing
capacity.

This KPI helps management:

• Monitor Supplier Availability
• Evaluate Procurement Capacity
• Identify Inactive Suppliers
• Support Vendor Management
• Reduce Supply Chain Risk

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Active Suppliers
• Active Supplier Percentage
• Inactive Supplier Percentage

------------------------------------------------------------------------------*/

SELECT
    SUM(
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END) AS TotalActiveSuppliers,
    ROUND((SUM(
                CASE
                    WHEN IsActive = 1 THEN 1
                    ELSE 0
                END) * 100.0) / COUNT(*),2) AS ActiveSupplierPercentage,
    ROUND((SUM(
                CASE
                    WHEN IsActive = 0 THEN 1
                    ELSE 0
                END) * 100.0) / COUNT(*), 2) AS InactiveSupplierPercentage
FROM dbo.Supplier;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 287 : Total Active Suppliers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 288 : Products Supplied by Supplier
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many products does each supplier provide to the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI measures the number of products supplied by each supplier. It helps
identify key suppliers, supplier dependency, and product distribution across
the supplier network.

This KPI helps management:

• Identify Major Suppliers
• Evaluate Supplier Portfolio
• Measure Supplier Contribution
• Reduce Supplier Dependency Risk
• Improve Procurement Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products Supplied
• Active Products
• Inactive Products
• Product Contribution (%)

Product Contribution (%) =
(Supplier Products / Total Products) × 100

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(P.ProductID) AS TotalProductsSupplied,
    SUM(
        CASE
            WHEN P.IsActive = 1 THEN 1
            ELSE 0
        END) AS ActiveProducts,
    SUM(
        CASE
            WHEN P.IsActive = 0 THEN 1
            ELSE 0
        END) AS InactiveProducts,
    ROUND((COUNT(P.ProductID) * 100.0) / SUM(COUNT(P.ProductID)) OVER (),2) AS ProductContributionPercentage
FROM dbo.Supplier S
INNER JOIN dbo.Product P
    ON S.SupplierID = P.SupplierID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalProductsSupplied DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 288 : Products Supplied by Supplier Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 289 : Inventory Value by Supplier
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the total inventory value contributed by each supplier across all
stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI evaluates how much inventory investment is associated with each
supplier based on inventory cost.

Inventory Value = Quantity In Stock × Cost Price

This KPI helps management:

• Identify High Value Suppliers
• Measure Procurement Investment
• Optimize Inventory Planning
• Reduce Inventory Risk
• Support Supplier Performance Evaluation

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalInventoryQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalInventoryValue,
    ROUND(AVG(I.QuantityInStock * P.CostPrice),2) AS AverageInventoryValue,
    ROUND((SUM(I.QuantityInStock * P.CostPrice) * 100.0) / SUM(SUM(I.QuantityInStock * P.CostPrice)) OVER (),2) AS InventoryContributionPercentage
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalInventoryValue DESC,
    TotalInventoryQuantity DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 289 : Inventory Value by Supplier Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 290 : Revenue by Supplier Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much sales revenue has been generated from the products supplied by each
supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI evaluates supplier performance based on actual sales generated by
their products. It helps identify suppliers that contribute the most revenue
and supports procurement and vendor management decisions.

This KPI helps management:

• Identify High Revenue Suppliers
• Evaluate Supplier Business Contribution
• Measure Product Performance
• Support Procurement Decisions
• Strengthen Strategic Supplier Partnerships

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Products Sold
• Total Quantity Sold
• Total Revenue
• Average Revenue per Product
• Average Revenue per Order
• Revenue Contribution (%)

Revenue is calculated using OrderItem.LineTotal.

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS ProductsSold,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageRevenuePerProduct,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT OI.OrderID), 0),2) AS AverageRevenuePerOrder,
    ROUND((SUM(OI.LineTotal) * 100.0) / SUM(SUM(OI.LineTotal)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalRevenue DESC,
    TotalQuantitySold DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 290 : Revenue by Supplier Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 291 : Supplier Revenue Contribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of the company's total sales revenue is contributed by each
supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Revenue Contribution measures the share of total business revenue
generated by products supplied by each supplier.

This KPI helps management:

• Identify Strategic Suppliers
• Evaluate Supplier Business Impact
• Measure Supplier Dependency
• Improve Procurement Decisions
• Support Vendor Negotiations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Revenue
• Revenue Contribution (%)

Revenue Contribution (%) = (Supplier Revenue / Total Company Revenue) × 100

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND((SUM(OI.LineTotal) * 100.0) / SUM(SUM(OI.LineTotal)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    RevenueContributionPercentage DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 291 : Supplier Revenue Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 292 : Top Revenue Generating Suppliers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers generate the highest sales revenue for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI identifies the suppliers whose products generate the highest revenue.
It helps procurement and management teams recognize strategic suppliers,
strengthen vendor relationships, and prioritize business partnerships.

This KPI helps management:

• Identify Top Performing Suppliers
• Prioritize Strategic Vendors
• Support Procurement Decisions
• Improve Supplier Relationship Management
• Focus on Revenue Drivers

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Top 10 Suppliers
• Total Products Sold
• Total Quantity Sold
• Total Revenue
• Average Revenue per Product

Revenue is calculated using OrderItem.LineTotal.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS ProductsSold,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageRevenuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalRevenue DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 292 : Top Revenue Generating Suppliers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 293 : Low Performing Suppliers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers generate the lowest sales revenue for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Low Performing Suppliers are vendors whose products contribute the least
towards company revenue. Identifying these suppliers helps businesses review
supplier relationships, optimize procurement strategies, and improve product
portfolio decisions.

This KPI helps management:

• Identify Underperforming Suppliers
• Review Supplier Contracts
• Optimize Product Portfolio
• Improve Procurement Efficiency
• Reduce Supply Chain Costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Bottom 10 Suppliers
• Products Sold
• Total Quantity Sold
• Total Revenue
• Average Revenue per Product

Revenue is calculated using OrderItem.LineTotal.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS ProductsSold,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageRevenuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalRevenue ASC,
    TotalQuantitySold ASC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 293 : Low Performing Suppliers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 294 : Average Products per Supplier
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

On average, how many products does each supplier provide?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Products per Supplier measures the average size of each supplier's
product portfolio. It helps evaluate supplier diversification and identify
whether procurement is concentrated among a few suppliers or distributed
across many.

This KPI helps management:

• Measure Supplier Portfolio Size
• Evaluate Supplier Diversification
• Identify Supplier Dependency
• Support Procurement Planning
• Improve Vendor Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Suppliers
• Total Products
• Average Products per Supplier

Average Products per Supplier =
Total Products / Total Suppliers

------------------------------------------------------------------------------*/

SELECT
    COUNT(DISTINCT S.SupplierID) AS TotalSuppliers,
    COUNT(P.ProductID) AS TotalProducts,
    ROUND(COUNT(P.ProductID) * 1.0 / NULLIF(COUNT(DISTINCT S.SupplierID), 0),2) AS AverageProductsPerSupplier
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 294 : Average Products per Supplier Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 295 : Category-wise Supplier Distribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are suppliers distributed across different product categories?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-wise Supplier Distribution measures the number of suppliers providing
products within each product category. It helps identify categories that rely
on a limited number of suppliers and categories with strong supplier
diversification.

This KPI helps management:

• Measure Supplier Coverage
• Identify Supply Chain Risks
• Evaluate Category Diversification
• Improve Procurement Strategy
• Support Vendor Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Name
• Total Suppliers
• Total Products
• Average Products per Supplier

------------------------------------------------------------------------------*/

SELECT
    C.CategoryName,
    COUNT(DISTINCT S.SupplierID) AS TotalSuppliers,
    COUNT(P.ProductID) AS TotalProducts,
    ROUND(COUNT(P.ProductID) * 1.0 / NULLIF(COUNT(DISTINCT S.SupplierID), 0),2) AS AverageProductsPerSupplier
FROM dbo.Category AS C
INNER JOIN dbo.SubCategory AS SC
    ON C.CategoryID = SC.CategoryID
INNER JOIN dbo.Product AS P
    ON SC.SubCategoryID = P.SubCategoryID
INNER JOIN dbo.Supplier AS S
    ON P.SupplierID = S.SupplierID
GROUP BY
    C.CategoryName
ORDER BY
    TotalSuppliers DESC,
    TotalProducts DESC,
    C.CategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 295 : Category-wise Supplier Distribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 296 : Brand-wise Supplier Distribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are suppliers distributed across different product brands?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand-wise Supplier Distribution helps identify the number of suppliers
supporting each brand. It provides insight into supplier concentration,
brand dependency, and procurement diversity.

This KPI helps management:

• Analyze Brand Coverage
• Measure Supplier Diversification
• Identify Supplier Dependency
• Improve Procurement Planning
• Reduce Supply Chain Risk

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Brand Name
• Total Suppliers
• Total Products
• Average Products per Supplier

------------------------------------------------------------------------------*/

SELECT
    B.BrandName,
    COUNT(DISTINCT S.SupplierID) AS TotalSuppliers,
    COUNT(P.ProductID) AS TotalProducts,
    ROUND(COUNT(P.ProductID) * 1.0 / NULLIF(COUNT(DISTINCT S.SupplierID), 0),2) AS AverageProductsPerSupplier
FROM dbo.Brand AS B
INNER JOIN dbo.Product AS P
    ON B.BrandID = P.BrandID
INNER JOIN dbo.Supplier AS S
    ON P.SupplierID = S.SupplierID
GROUP BY
    B.BrandName
ORDER BY
    TotalSuppliers DESC,
    TotalProducts DESC,
    B.BrandName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 296 : Brand-wise Supplier Distribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 297 : Supplier Product Availability
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of each supplier's products are currently active and available
for sale?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Product Availability measures the proportion of active products
supplied by each supplier. It helps identify suppliers with discontinued
products and evaluates the health of each supplier's product portfolio.

This KPI helps management:

• Monitor Product Availability
• Evaluate Supplier Portfolio Health
• Identify Suppliers with Inactive Products
• Improve Inventory Planning
• Support Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products
• Active Products
• Inactive Products
• Product Availability (%)

Product Availability (%) =
(Active Products / Total Products) × 100

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(P.ProductID) AS TotalProducts,
    SUM(
        CASE
            WHEN P.IsActive = 1 THEN 1
            ELSE 0
        END) AS ActiveProducts,
    SUM(
        CASE
            WHEN P.IsActive = 0 THEN 1
            ELSE 0
        END) AS InactiveProducts,
    ROUND((SUM(
                CASE
                    WHEN P.IsActive = 1 THEN 1
                    ELSE 0
                END) * 100.0) / NULLIF(COUNT(P.ProductID), 0),2) AS ProductAvailabilityPercentage
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    ProductAvailabilityPercentage DESC,
    ActiveProducts DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 297 : Supplier Product Availability Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 298 : Supplier Inventory Coverage
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much inventory is currently available for the products supplied by each
supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Inventory Coverage measures the quantity of inventory available for
each supplier's products across all stores. It helps evaluate supplier stock
availability and identify suppliers whose inventory levels may require
replenishment.

This KPI helps management:

• Monitor Supplier Stock Availability
• Evaluate Inventory Coverage
• Identify Low Stock Suppliers
• Improve Procurement Planning
• Reduce Stockout Risk

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products
• Total Inventory Quantity
• Average Inventory per Product
• Total Stores Covered

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalInventoryQuantity,
    ROUND(SUM(I.QuantityInStock) * 1.0 / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageInventoryPerProduct,
    COUNT(DISTINCT I.StoreID) AS TotalStoresCovered
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalInventoryQuantity DESC,
    TotalProducts DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 298 : Supplier Inventory Coverage Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 299 : Supplier Stock Value
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the current stock value held for each supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Stock Value measures the inventory investment associated with each
supplier based on the current quantity in stock and product cost price.

This KPI helps management:

• Measure Inventory Investment
• Identify High Value Suppliers
• Monitor Working Capital
• Optimize Procurement Planning
• Improve Inventory Cost Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products
• Total Stock Quantity
• Total Stock Value
• Average Stock Value per Product

Stock Value =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalStockQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalStockValue,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageStockValuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalStockValue DESC,
    TotalStockQuantity DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 299 : Supplier Stock Value Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 300 : High Value Suppliers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers contribute the highest inventory value to the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

High Value Suppliers are vendors whose inventory represents the largest
financial investment. Identifying these suppliers helps management prioritize
vendor relationships, manage procurement budgets, and monitor inventory risk.

This KPI helps management:

• Identify Strategic Suppliers
• Measure Inventory Investment
• Optimize Procurement Budget
• Monitor Inventory Risk
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Top 10 Suppliers by Stock Value
• Total Products
• Total Stock Quantity
• Total Stock Value
• Average Stock Value per Product

Stock Value =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT TOP (10)
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalStockQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalStockValue,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageStockValuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalStockValue DESC,
    TotalStockQuantity DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 300 : High Value Suppliers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 301 : Low Value Suppliers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers contribute the lowest inventory value to the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Low Value Suppliers are vendors whose inventory investment is relatively
small. Identifying these suppliers helps management evaluate supplier
effectiveness, optimize procurement decisions, and review vendor contracts.

This KPI helps management:

• Identify Low Investment Suppliers
• Review Supplier Performance
• Optimize Procurement Costs
• Improve Vendor Portfolio
• Support Strategic Sourcing Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Bottom 10 Suppliers by Stock Value
• Total Products
• Total Stock Quantity
• Total Stock Value
• Average Stock Value per Product

Stock Value =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT TOP (10)
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalStockQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalStockValue,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageStockValuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalStockValue ASC,
    TotalStockQuantity ASC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 301 : Low Value Suppliers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 302 : Supplier Dependency Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How dependent is the business on each supplier based on the number of products
they supply?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Dependency Analysis measures each supplier's share of the overall
product portfolio. A high dependency on a single supplier increases supply
chain risk and can impact inventory availability if that supplier faces
operational issues.

This KPI helps management:

• Identify Supplier Dependency
• Measure Supplier Risk
• Diversify Procurement Strategy
• Improve Supply Chain Resilience
• Support Vendor Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Products Supplied
• Product Portfolio Contribution (%)
• Dependency Level

Dependency Levels:
• High Dependency      : ≥ 20%
• Medium Dependency    : 10% - 19.99%
• Low Dependency       : < 10%

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(P.ProductID) AS ProductsSupplied,
    ROUND((COUNT(P.ProductID) * 100.0) / SUM(COUNT(P.ProductID)) OVER (),2) AS ProductPortfolioContributionPercentage,
    CASE
        WHEN(COUNT(P.ProductID) * 100.0) / SUM(COUNT(P.ProductID)) OVER () >= 20 THEN 'High Dependency'
        WHEN(COUNT(P.ProductID) * 100.0) / SUM(COUNT(P.ProductID)) OVER () >= 10 THEN 'Medium Dependency'
        ELSE 'Low Dependency'
    END AS DependencyLevel
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    ProductPortfolioContributionPercentage DESC,
    ProductsSupplied DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 302 : Supplier Dependency Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 303 : Single Supplier Risk Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are dependent on a single supplier, creating potential supply
chain risk?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Products sourced from only one supplier are vulnerable to supply disruptions,
price fluctuations, and vendor-specific operational issues.

This KPI helps management:

• Identify Single Supplier Risk
• Reduce Supply Chain Dependency
• Improve Procurement Planning
• Support Business Continuity
• Strengthen Vendor Diversification

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• SKU
• Category
• Brand
• Supplier
• Current Inventory
• Inventory Value

Only products supplied by one supplier are included.

Inventory Value =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT
    P.ProductID,
    P.ProductName,
    P.SKU,
    C.CategoryName,
    B.BrandName,
    S.SupplierName,
    SUM(I.QuantityInStock) AS CurrentInventory,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS InventoryValue
FROM dbo.Product AS P
INNER JOIN dbo.Supplier AS S
    ON P.SupplierID = S.SupplierID
INNER JOIN dbo.Brand AS B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory AS SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category AS C
    ON SC.CategoryID = C.CategoryID
LEFT JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    P.ProductID,
    P.ProductName,
    P.SKU,
    C.CategoryName,
    B.BrandName,
    S.SupplierName,
    P.CostPrice
HAVING
    COUNT(DISTINCT P.SupplierID) = 1
ORDER BY
    InventoryValue DESC,
    CurrentInventory DESC,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 303 : Single Supplier Risk Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 304 : Multi Supplier Coverage
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many suppliers are associated with each product category, and how well is
each category diversified across suppliers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Although each product is assigned to one supplier in the current database
design, procurement risk can still be assessed by measuring how many different
suppliers operate within each product category.

Categories supported by multiple suppliers are generally more resilient to
supply disruptions than categories dominated by only one or two suppliers.

This KPI helps management:

• Measure Supplier Diversification
• Identify High-Risk Categories
• Improve Procurement Planning
• Reduce Supply Chain Dependency
• Support Vendor Expansion Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Name
• Total Suppliers
• Total Products
• Supplier Coverage Ratio
• Coverage Level

Coverage Levels

• Excellent : 10+ Suppliers
• Good      : 5–9 Suppliers
• Limited   : 2–4 Suppliers
• High Risk : 1 Supplier

------------------------------------------------------------------------------*/

SELECT
    C.CategoryName,
    COUNT(DISTINCT S.SupplierID) AS TotalSuppliers,
    COUNT(P.ProductID) AS TotalProducts,
    ROUND(COUNT(P.ProductID) * 1.0 / NULLIF(COUNT(DISTINCT S.SupplierID), 0),2) AS SupplierCoverageRatio,
    CASE
        WHEN COUNT(DISTINCT S.SupplierID) >= 10 THEN 'Excellent'
        WHEN COUNT(DISTINCT S.SupplierID) >= 5 THEN 'Good'
        WHEN COUNT(DISTINCT S.SupplierID) >= 2 THEN 'Limited'
        ELSE 'High Risk'
    END AS CoverageLevel
FROM dbo.Category AS C
INNER JOIN dbo.SubCategory AS SC
    ON C.CategoryID = SC.CategoryID
INNER JOIN dbo.Product AS P
    ON SC.SubCategoryID = P.SubCategoryID
INNER JOIN dbo.Supplier AS S
    ON P.SupplierID = S.SupplierID
GROUP BY
    C.CategoryName
ORDER BY
    TotalSuppliers DESC,
    TotalProducts DESC,
    C.CategoryName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 304 : Multi Supplier Coverage Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 305 : Supplier Purchase Cost Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the total purchase cost associated with each supplier's inventory?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Purchase Cost Analysis measures the total procurement investment made
for inventory supplied by each supplier based on product cost price and current
stock quantity.

This KPI helps management:

• Evaluate Procurement Investment
• Identify High Cost Suppliers
• Optimize Purchasing Decisions
• Monitor Inventory Costs
• Improve Supplier Cost Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products
• Total Inventory Quantity
• Total Purchase Cost
• Average Cost per Product
• Average Cost per Unit

Purchase Cost =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalInventoryQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalPurchaseCost,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageCostPerProduct,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(SUM(I.QuantityInStock), 0),2) AS AverageCostPerUnit
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalPurchaseCost DESC,
    TotalInventoryQuantity DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 305 : Supplier Purchase Cost Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 306 : Supplier Sales Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each supplier performed based on sales generated by their products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Sales Performance evaluates supplier effectiveness using sales volume,
order volume, and revenue generated from supplied products.

This KPI helps management:

• Measure Supplier Sales Performance
• Identify High Performing Suppliers
• Compare Supplier Productivity
• Support Procurement Strategy
• Strengthen Supplier Relationships

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Products Sold
• Orders Served
• Total Quantity Sold
• Total Sales Revenue
• Average Revenue per Order

Sales Revenue is calculated using OrderItem.LineTotal.

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS ProductsSold,
    COUNT(DISTINCT OI.OrderID) AS OrdersServed,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(SUM(OI.LineTotal),2) AS TotalSalesRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT OI.OrderID), 0),2) AS AverageRevenuePerOrder
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalSalesRevenue DESC,
    OrdersServed DESC,
    TotalQuantitySold DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 306 : Supplier Sales Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 307 : Supplier Inventory Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How efficiently is inventory managed for each supplier based on current stock
levels and product availability?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Inventory Performance evaluates inventory distribution across
suppliers by measuring stock availability, inventory value, and average stock
per product.

This KPI helps management:

• Monitor Inventory Health
• Evaluate Supplier Stock Performance
• Identify Overstocked Suppliers
• Improve Inventory Planning
• Optimize Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Products
• Total Inventory Quantity
• Total Inventory Value
• Average Inventory per Product
• Average Inventory Value per Product

Inventory Value =
Quantity In Stock × Cost Price

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    COUNT(DISTINCT P.ProductID) AS TotalProducts,
    SUM(I.QuantityInStock) AS TotalInventoryQuantity,
    ROUND(SUM(I.QuantityInStock * P.CostPrice),2) AS TotalInventoryValue,
    ROUND(SUM(I.QuantityInStock) * 1.0 / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageInventoryPerProduct,
    ROUND(SUM(I.QuantityInStock * P.CostPrice) / NULLIF(COUNT(DISTINCT P.ProductID), 0),2) AS AverageInventoryValuePerProduct
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.Inventory AS I
    ON P.ProductID = I.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    TotalInventoryValue DESC,
    TotalInventoryQuantity DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 307 : Supplier Inventory Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 308 : Supplier Profit Contribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much gross profit is generated by the products supplied by each supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue alone does not indicate supplier profitability. This KPI evaluates the
gross profit earned from each supplier's products by comparing sales revenue
with product cost.

This KPI helps management:

• Identify Most Profitable Suppliers
• Measure Supplier Contribution
• Optimize Procurement Strategy
• Improve Product Mix
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Total Revenue
• Total Cost
• Gross Profit
• Gross Profit Margin (%)

Gross Profit =
Sales Revenue − Product Cost

Product Cost =
Quantity × Cost Price

------------------------------------------------------------------------------*/

SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.Quantity * P.CostPrice),2) AS TotalCost,
    ROUND(SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice),2) AS GrossProfit,
    ROUND(((SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice)) * 100.0) / NULLIF(SUM(OI.LineTotal), 0),2) AS GrossProfitMarginPercentage
FROM dbo.Supplier AS S
INNER JOIN dbo.Product AS P
    ON S.SupplierID = P.SupplierID
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
GROUP BY
    S.SupplierID,
    S.SupplierName
ORDER BY
    GrossProfit DESC,
    TotalRevenue DESC,
    S.SupplierName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 308 : Supplier Profit Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 309 : Supplier Business Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers deliver the best overall business performance based on
Revenue, Gross Profit, and Current Inventory Value?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

A supplier should not be evaluated using a single metric. This KPI combines
Sales Performance, Profitability, and Inventory Investment into one Business
Score.

The query avoids double-counting by separately aggregating:

• Sales Data
• Inventory Data

before combining the results.

This KPI helps management:

• Identify Strategic Suppliers
• Evaluate Overall Supplier Performance
• Support Procurement Decisions
• Improve Vendor Management
• Build Executive Supplier Scorecards

------------------------------------------------------------------------------
Business Score Formula
------------------------------------------------------------------------------

Business Score = (Revenue × 40%) + (Gross Profit × 40%) + (Inventory Value × 20%)

------------------------------------------------------------------------------*/

WITH SalesSummary AS(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity * P.CostPrice) AS TotalCost,
        SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice) AS GrossProfit
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS TotalInventoryQuantity,
        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
)
SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND(ISNULL(SS.TotalRevenue,0),2) AS TotalRevenue,
    ROUND(ISNULL(SS.GrossProfit,0),2) AS GrossProfit,
    ISNULL(ISU.TotalInventoryQuantity,0) AS TotalInventoryQuantity,
    ROUND(ISNULL(ISU.InventoryValue,0),2) AS InventoryValue,
    ROUND((ISNULL(SS.TotalRevenue,0) * 0.40) + (ISNULL(SS.GrossProfit,0) * 0.40) + (ISNULL(ISU.InventoryValue,0) * 0.20),2) AS BusinessScore,
    DENSE_RANK() OVER( ORDER BY (ISNULL(SS.TotalRevenue,0) * 0.40) + (ISNULL(SS.GrossProfit,0) * 0.40) + (ISNULL(ISU.InventoryValue,0) * 0.20) DESC ) AS SupplierRank
FROM dbo.Supplier AS S
LEFT JOIN SalesSummary AS SS
    ON S.SupplierID = SS.SupplierID
LEFT JOIN InventorySummary AS ISU
    ON S.SupplierID = ISU.SupplierID
ORDER BY
    SupplierRank,
    BusinessScore DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 309 : Supplier Business Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 310 : Supplier Operational Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers demonstrate the strongest operational performance based on
sales, inventory availability, and product availability?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Operational Score evaluates suppliers from an operational perspective
instead of purely financial performance.

This KPI combines:

• Sales Activity
• Inventory Availability
• Product Availability

to identify suppliers with consistently strong operational execution.

This KPI helps management:

• Evaluate Operational Efficiency
• Monitor Supplier Reliability
• Improve Procurement Planning
• Identify Operational Leaders
• Support Executive Decision Making

------------------------------------------------------------------------------
Operational Score Formula
------------------------------------------------------------------------------

Operational Score = (Revenue Score × 50%) + (Inventory Score × 30%) + (Product Availability × 20%)

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS InventoryQuantity
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
),
ProductSummary AS
(
    SELECT
        SupplierID,
        COUNT(*) AS TotalProducts,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) AS ActiveProducts
    FROM dbo.Product
    GROUP BY
        SupplierID
)
SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND(ISNULL(SS.TotalRevenue,0),2) AS TotalRevenue,
    ISNULL(ISU.InventoryQuantity,0) AS InventoryQuantity,
    PS.TotalProducts,
    PS.ActiveProducts,
    ROUND((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0), 2) AS ProductAvailabilityPercentage,
    ROUND((ISNULL(SS.TotalRevenue,0) * 0.50) + (ISNULL(ISU.InventoryQuantity,0) * 0.30) + 
			(((PS.ActiveProducts * 100.0)/NULLIF(PS.TotalProducts,0))*0.20),2) AS OperationalScore,
    DENSE_RANK() OVER(ORDER BY(ISNULL(SS.TotalRevenue,0) * 0.50) + (ISNULL(ISU.InventoryQuantity,0) * 0.30) + 
			(((PS.ActiveProducts * 100.0)/NULLIF(PS.TotalProducts,0)) * 0.20)DESC) AS OperationalRank
FROM dbo.Supplier AS S
LEFT JOIN SalesSummary AS SS
    ON S.SupplierID = SS.SupplierID
LEFT JOIN InventorySummary AS ISU
    ON S.SupplierID = ISU.SupplierID
LEFT JOIN ProductSummary AS PS
    ON S.SupplierID = PS.SupplierID
ORDER BY
    OperationalRank,
    OperationalScore DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 310 : Supplier Operational Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 311 : Supplier Performance Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each supplier perform across Revenue, Profitability, Inventory,
Product Availability, and Operational Efficiency?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI consolidates the most important supplier performance metrics into a
single dashboard-ready dataset.

It enables management to evaluate suppliers from multiple business
perspectives without running separate reports.

This KPI helps management:

• Monitor Supplier Performance
• Compare Strategic Suppliers
• Support Procurement Decisions
• Improve Vendor Relationships
• Build Executive Dashboards

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Supplier ID
• Supplier Name
• Total Products
• Active Products
• Product Availability (%)
• Total Revenue
• Gross Profit
• Inventory Quantity
• Inventory Value
• Business Score
• Operational Score

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity * P.CostPrice) AS TotalCost,
        SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice) AS GrossProfit
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS InventoryQuantity,
        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
),
ProductSummary AS
(
    SELECT
        SupplierID,
        COUNT(*) AS TotalProducts,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) AS ActiveProducts
    FROM dbo.Product
    GROUP BY
        SupplierID
)
SELECT
    S.SupplierID,
    S.SupplierName,
    PS.TotalProducts,
    PS.ActiveProducts,
    ROUND((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0),2) AS ProductAvailabilityPercentage,
    ROUND(ISNULL(SS.TotalRevenue,0),2) AS TotalRevenue,
    ROUND(ISNULL(SS.GrossProfit,0),2) AS GrossProfit,
    ISNULL(ISU.InventoryQuantity,0) AS InventoryQuantity,
    ROUND(ISNULL(ISU.InventoryValue,0),2) AS InventoryValue,
    ROUND((ISNULL(SS.TotalRevenue,0) * 0.40) + (ISNULL(SS.GrossProfit,0) * 0.40) + (ISNULL(ISU.InventoryValue,0) * 0.20),2) AS BusinessScore,
    ROUND((ISNULL(SS.TotalRevenue,0) * 0.50) + (ISNULL(ISU.InventoryQuantity,0) * 0.30) + 
			((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) * 0.20,2) AS OperationalScore
FROM dbo.Supplier AS S
LEFT JOIN SalesSummary AS SS
    ON S.SupplierID = SS.SupplierID
LEFT JOIN InventorySummary AS ISU
    ON S.SupplierID = ISU.SupplierID
LEFT JOIN ProductSummary AS PS
    ON S.SupplierID = PS.SupplierID
ORDER BY
    BusinessScore DESC,
    OperationalScore DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 311 : Supplier Performance Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 312 : Supplier Executive Scorecard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers perform best overall when evaluated across key business
dimensions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Supplier Executive Scorecard provides a single executive-level view of
supplier performance by combining financial, operational, and inventory
metrics.

This KPI enables leadership to quickly identify:

• Strategic Suppliers
• High Performing Suppliers
• Suppliers Requiring Attention
• Procurement Priorities
• Vendor Management Opportunities

------------------------------------------------------------------------------
Scorecard Metrics
------------------------------------------------------------------------------

• Total Revenue
• Gross Profit
• Inventory Value
• Product Availability %
• Business Score
• Operational Score
• Executive Score
• Executive Rating

Executive Score Formula

Executive Score =
(Business Score × 60%)
+
(Operational Score × 40%)

Executive Ratings

★★★★★ Outstanding
★★★★ Excellent
★★★ Good
★★ Needs Attention
★ Critical

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity * P.CostPrice) AS TotalCost,
        SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice) AS GrossProfit
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS InventoryQuantity,
        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
),
ProductSummary AS
(
    SELECT
        SupplierID,
        COUNT(*) AS TotalProducts,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) AS ActiveProducts
    FROM dbo.Product
    GROUP BY
        SupplierID
),
SupplierScores AS
(
    SELECT
        S.SupplierID,
        S.SupplierName,
        ISNULL(SS.TotalRevenue,0) AS TotalRevenue,
        ISNULL(SS.GrossProfit,0) AS GrossProfit,
        ISNULL(ISU.InventoryValue,0) AS InventoryValue,
        ROUND((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0),2) AS ProductAvailabilityPercentage,
		((ISNULL(SS.TotalRevenue,0) * 0.40) + (ISNULL(SS.GrossProfit,0) * 0.40) + (ISNULL(ISU.InventoryValue,0) * 0.20)) AS BusinessScore,
        ((ISNULL(SS.TotalRevenue,0) * 0.50) + (ISNULL(ISU.InventoryQuantity,0) * 0.30) + ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) * 0.20) AS OperationalScore
    FROM dbo.Supplier AS S
    LEFT JOIN SalesSummary AS SS
        ON S.SupplierID = SS.SupplierID
    LEFT JOIN InventorySummary AS ISU
        ON S.SupplierID = ISU.SupplierID
    LEFT JOIN ProductSummary AS PS
        ON S.SupplierID = PS.SupplierID
)
SELECT
    SupplierID,
    SupplierName,
    ROUND(TotalRevenue,2) AS TotalRevenue,
    ROUND(GrossProfit,2) AS GrossProfit,
    ROUND(InventoryValue,2) AS InventoryValue,
    ProductAvailabilityPercentage,
    ROUND(BusinessScore,2) AS BusinessScore,
    ROUND(OperationalScore,2) AS OperationalScore,
    ROUND((BusinessScore * 0.60) + (OperationalScore * 0.40),2) AS ExecutiveScore,
    CASE
        WHEN((BusinessScore * 0.60) + (OperationalScore * 0.40)) >= 100000 THEN '★★★★★ Outstanding'
        WHEN((BusinessScore * 0.60) + (OperationalScore * 0.40)) >= 75000 THEN '★★★★ Excellent'
        WHEN((BusinessScore * 0.60) + (OperationalScore * 0.40)) >= 50000 THEN '★★★ Good'
        WHEN((BusinessScore * 0.60) + (OperationalScore * 0.40)) >= 25000 THEN '★★ Needs Attention'
        ELSE '★ Critical'
    END AS ExecutiveRating
FROM SupplierScores
ORDER BY
    ExecutiveScore DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 312 : Supplier Executive Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 313 : Supplier Procurement Efficiency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers provide the best procurement efficiency based on inventory
investment and sales generated?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Procurement Efficiency evaluates how effectively the money invested in supplier
inventory is converted into sales revenue.

A higher efficiency indicates that inventory purchased from a supplier is
being sold effectively, reducing inventory holding costs and improving cash
flow.

This KPI helps management:

• Measure Procurement Efficiency
• Optimize Supplier Selection
• Improve Inventory Utilization
• Reduce Working Capital
• Support Strategic Procurement

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Inventory Value
• Sales Revenue
• Procurement Efficiency Ratio
• Efficiency Rating

Procurement Efficiency Ratio =
Sales Revenue / Inventory Value

Efficiency Ratings

★★★★★ Excellent   : ≥ 3.00
★★★★ Very Good    : 2.00 – 2.99
★★★ Good          : 1.50 – 1.99
★★ Average        : 1.00 – 1.49
★ Low             : < 1.00

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
)
SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND(ISNULL(ISU.InventoryValue,0),2) AS InventoryValue,
    ROUND(ISNULL(SS.TotalRevenue,0),2) AS SalesRevenue,
    ROUND(ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0),2) AS ProcurementEfficiencyRatio,
    CASE
        WHEN ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0) >= 3 THEN '★★★★★ Excellent'
        WHEN ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0) >= 2 THEN '★★★★ Very Good'
        WHEN ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0) >= 1.5 THEN '★★★ Good'
        WHEN ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0) >= 1 THEN '★★ Average'
        ELSE '★ Low'
    END AS EfficiencyRating
FROM dbo.Supplier AS S
LEFT JOIN SalesSummary AS SS
    ON S.SupplierID = SS.SupplierID
LEFT JOIN InventorySummary AS ISU
    ON S.SupplierID = ISU.SupplierID
ORDER BY
    ProcurementEfficiencyRatio DESC,
    SalesRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 313 : Supplier Procurement Efficiency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 314 : Supplier Risk Index
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers present the highest operational risk based on product
availability, inventory levels, and revenue contribution?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Risk Index provides an overall assessment of supplier risk by
combining multiple operational indicators into a single score.

A higher Risk Index indicates a supplier that requires closer monitoring due
to potential business impact.

This KPI helps management:

• Identify High-Risk Suppliers
• Reduce Supply Chain Risk
• Improve Business Continuity
• Prioritize Supplier Reviews
• Support Strategic Procurement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier ID
• Supplier Name
• Product Availability (%)
• Inventory Quantity
• Revenue
• Supplier Risk Index
• Risk Level

Risk Index Formula

Risk Index =
100 - Product Availability (%)

Risk Levels

• Low Risk       : 0 – 19
• Medium Risk    : 20 – 39
• High Risk      : 40 – 59
• Critical Risk  : 60+

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS InventoryQuantity
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
),
ProductSummary AS
(
    SELECT
        SupplierID,
        COUNT(*) AS TotalProducts,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) AS ActiveProducts
    FROM dbo.Product
    GROUP BY
        SupplierID
)
SELECT
    S.SupplierID,
    S.SupplierName,
    ROUND((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0),2) AS ProductAvailabilityPercentage,
    ISNULL(ISU.InventoryQuantity,0) AS InventoryQuantity,
    ROUND(ISNULL(SS.TotalRevenue,0),2) AS TotalRevenue,
    ROUND(100 - ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)),2) AS SupplierRiskIndex,
    CASE
        WHEN 100 - ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) >= 60 THEN 'Critical Risk'
        WHEN 100 - ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) >= 40 THEN 'High Risk'
        WHEN 100 - ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) >= 20 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS RiskLevel
FROM dbo.Supplier AS S
LEFT JOIN ProductSummary AS PS
    ON S.SupplierID = PS.SupplierID
LEFT JOIN SalesSummary AS SS
    ON S.SupplierID = SS.SupplierID
LEFT JOIN InventorySummary AS ISU
    ON S.SupplierID = ISU.SupplierID
ORDER BY
    SupplierRiskIndex DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 314 : Supplier Risk Index Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 315 : Supplier Overall Performance Ranking
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers are the overall best performers when considering financial,
operational, inventory, and procurement performance?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI provides the final supplier ranking by combining the most important
supplier performance metrics into one comprehensive score.

Unlike individual KPIs, this ranking represents the overall contribution of
each supplier to the business.

This KPI helps management:

• Identify Strategic Suppliers
• Build Executive Supplier Rankings
• Improve Procurement Decisions
• Prioritize Vendor Partnerships
• Support Annual Supplier Reviews

------------------------------------------------------------------------------
Overall Performance Score
------------------------------------------------------------------------------

Overall Score = (Business Score × 50%) + (Operational Score × 30%) + (Procurement Efficiency Ratio × 20%)

------------------------------------------------------------------------------*/

;WITH SalesSummary AS
(
    SELECT
        P.SupplierID,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity * P.CostPrice) AS GrossCost,
        SUM(OI.LineTotal) - SUM(OI.Quantity * P.CostPrice) AS GrossProfit
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.SupplierID
),
InventorySummary AS
(
    SELECT
        P.SupplierID,
        SUM(I.QuantityInStock) AS InventoryQuantity,
        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue
    FROM dbo.Product AS P
    INNER JOIN dbo.Inventory AS I
        ON P.ProductID = I.ProductID
    GROUP BY
        P.SupplierID
),
ProductSummary AS
(
    SELECT
        SupplierID,
        COUNT(*) AS TotalProducts,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) AS ActiveProducts
    FROM dbo.Product
    GROUP BY
        SupplierID
),
SupplierScores AS
(
    SELECT
        S.SupplierID,
        S.SupplierName,
        ISNULL(SS.TotalRevenue,0) AS TotalRevenue,
        ISNULL(SS.GrossProfit,0) AS GrossProfit,
        ISNULL(ISU.InventoryQuantity,0) AS InventoryQuantity,
        ISNULL(ISU.InventoryValue,0) AS InventoryValue,
        ((ISNULL(SS.TotalRevenue,0) * 0.40) + (ISNULL(SS.GrossProfit,0) * 0.40) + (ISNULL(ISU.InventoryValue,0) * 0.20)) AS BusinessScore,
        ((ISNULL(SS.TotalRevenue,0) * 0.50) + (ISNULL(ISU.InventoryQuantity,0) * 0.30) + ((PS.ActiveProducts * 100.0) / NULLIF(PS.TotalProducts,0)) * 0.20) AS OperationalScore,
        (ISNULL(SS.TotalRevenue,0) / NULLIF(ISNULL(ISU.InventoryValue,0),0) ) AS ProcurementEfficiencyRatio
    FROM dbo.Supplier AS S
    LEFT JOIN SalesSummary AS SS
        ON S.SupplierID = SS.SupplierID
    LEFT JOIN InventorySummary AS ISU
        ON S.SupplierID = ISU.SupplierID
    LEFT JOIN ProductSummary AS PS
        ON S.SupplierID = PS.SupplierID
)
SELECT
    SupplierID,
    SupplierName,
    ROUND(TotalRevenue,2) AS TotalRevenue,
    ROUND(GrossProfit,2) AS GrossProfit,
    ROUND(InventoryValue,2) AS InventoryValue,
    ROUND(BusinessScore,2) AS BusinessScore,
    ROUND(OperationalScore,2) AS OperationalScore,
    ROUND(ProcurementEfficiencyRatio,2) AS ProcurementEfficiencyRatio,
    ROUND((BusinessScore * 0.50) + (OperationalScore * 0.30) + (ProcurementEfficiencyRatio * 0.20),2) AS OverallPerformanceScore,
    DENSE_RANK() OVER(ORDER BY(BusinessScore * 0.50) + (OperationalScore * 0.30) + (ProcurementEfficiencyRatio * 0.20) DESC) AS OverallRank
FROM SupplierScores
ORDER BY
    OverallRank,
    OverallPerformanceScore DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 315 : Supplier Overall Performance Ranking Generated Successfully';
PRINT '==============================================================';

PRINT '';