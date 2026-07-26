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