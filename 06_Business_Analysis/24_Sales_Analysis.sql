/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 24_Sales_Analysis.sql
Description     : Detailed Sales Analysis using Advanced SQL

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

Total KPIs      : 30
Difficulty      : Intermediate → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module focuses on detailed sales analytics by evaluating product
performance, revenue trends, geographical sales, store performance,
growth analysis, and sales distribution.

The KPIs are designed to support business analysts in identifying
sales opportunities, growth patterns, and revenue drivers.

==============================================================================*/
GO

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Sales Analysis

Total KPIs         : 30

Sections Included
-----------------

• Product Sales Analysis
• Revenue Analysis
• Geographic Analysis
• Store Performance

Primary SQL Concepts
--------------------

• JOIN
• GROUP BY
• ORDER BY
• Aggregate Functions
• Common Table Expressions (CTEs)
• Window Functions
• Ranking Functions
• CASE Expressions
• Date Functions
• Running Totals

==============================================================================*/
GO

/*==============================================================================
Table of Contents
==============================================================================

Part 1 : Product Sales Analysis
--------------------------------------------------------
KPI 046 : Sales by Category
KPI 047 : Sales by SubCategory
KPI 048 : Sales by Brand
KPI 049 : Top 10 Best Selling Products
KPI 050 : Bottom 10 Selling Products
KPI 051 : Product Revenue Ranking
KPI 052 : Product Revenue Contribution (%)
KPI 053 : Average Selling Price by Product
KPI 054 : Average Quantity Sold per Order
KPI 055 : Top 10 Highest Revenue Products

Part 2 : Order & Revenue Analysis
--------------------------------------------------------
KPI 056 : Top 10 Highest Revenue Orders
KPI 057 : Largest Orders by Quantity
KPI 058 : Monthly Sales Growth (%)
KPI 059 : Year-over-Year Sales Growth
KPI 060 : Quarter-wise Sales Performance
KPI 061 : Running Total Revenue
KPI 062 : Average Revenue per Order
KPI 063 : Revenue vs Quantity Trend
KPI 064 : Order Size Distribution
KPI 065 : Revenue Pareto Analysis

Part 3 : Geographic & Store Analysis
--------------------------------------------------------
KPI 066 : Revenue by Country
KPI 067 : Revenue by State
KPI 068 : Revenue by City
KPI 069 : Sales by Store Type
KPI 070 : Top Performing Store by Month
KPI 071 : Bottom Performing Store by Month
KPI 072 : Store Revenue Ranking
KPI 073 : Sales Distribution by Hour
KPI 074 : Sales Distribution by Month
KPI 075 : Sales Dashboard Dataset

==============================================================================*/
GO

/*==============================================================================
                    Part 1 : Product Sales Analysis
==============================================================================*/

/*------------------------------------------------------------------------------
KPI 046 : Sales by Category
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product categories generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-level revenue analysis helps management identify high-performing
categories, optimize inventory planning, improve pricing strategies,
and allocate marketing budgets effectively.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks product categories based on total revenue generated,
allowing stakeholders to quickly identify the strongest and weakest
performing categories.

------------------------------------------------------------------------------
*/

SELECT
    C.CategoryName,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
GROUP BY
    C.CategoryName
ORDER BY
    TotalRevenue DESC;

PRINT '';
PRINT '==============================================================';
PRINT 'KPI 046 : Sales by Category Generated Successfully';
PRINT '==============================================================';
PRINT '';
GO

/*------------------------------------------------------------------------------
KPI 047 : Sales by SubCategory
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product subcategories generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Subcategory-level analysis provides deeper insights than category analysis,
helping identify high-performing product groups for inventory planning,
pricing strategies, and promotional campaigns.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks product subcategories based on revenue, quantity sold,
and number of orders, enabling better product portfolio decisions.

------------------------------------------------------------------------------
*/

SELECT
    SC.SubCategoryName,
    C.CategoryName,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
GROUP BY
    SC.SubCategoryName,
    C.CategoryName
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 047 : Sales by SubCategory Generated Successfully';
PRINT '==============================================================';

PRINT '';
GO

/*------------------------------------------------------------------------------
KPI 048 : Sales by Brand
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which brands generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand-level sales analysis helps identify the most valuable brands,
evaluate supplier performance, optimize inventory allocation, and
support strategic purchasing decisions.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks brands based on total revenue, quantity sold,
and number of orders, highlighting the strongest performing brands.

------------------------------------------------------------------------------
*/

SELECT
    B.BrandName,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
GROUP BY
    B.BrandName
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 048 : Sales by Brand Generated Successfully';
PRINT '==============================================================';

PRINT '';
GO

/*------------------------------------------------------------------------------
KPI 049 : Top 10 Best Selling Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying the best-selling products helps management optimize inventory,
improve product availability, prioritize marketing efforts, and maximize
overall business revenue.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns the Top 10 products ranked by total revenue along with
quantity sold and total orders.

------------------------------------------------------------------------------
*/

SELECT TOP (10)
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName,
	AVG(OI.UnitPrice) AS AverageSellingPrice,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
GROUP BY
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 049 : Top 10 Best Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';
GO

/*------------------------------------------------------------------------------
KPI 050 : Bottom 10 Selling Products
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the lowest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying slow-moving products helps management optimize inventory,
reduce carrying costs, improve promotional strategies, and make informed
decisions regarding product discontinuation or stock replenishment.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns the Bottom 10 products ranked by total revenue along
with quantity sold and total orders.

------------------------------------------------------------------------------
*/

SELECT TOP (10)
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName,
    SUM(OI.LineTotal) AS TotalRevenue,
    SUM(OI.Quantity) AS TotalQuantitySold,
    COUNT(DISTINCT O.OrderID) AS TotalOrders
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
GROUP BY
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName
ORDER BY
    TotalRevenue ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 050 : Bottom 10 Selling Products Generated Successfully';
PRINT '==============================================================';

PRINT '';
GO

/*------------------------------------------------------------------------------
KPI 051 : Product Revenue Ranking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How do products rank based on the revenue they generate?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue ranking helps identify the most valuable products within the
business. This information supports pricing decisions, inventory planning,
marketing campaigns, and product portfolio optimization.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks all products by total revenue generated using the
DENSE_RANK() window function.

Products with equal revenue receive the same rank.

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        SC.SubCategoryName,
        C.CategoryName,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity) AS TotalQuantitySold,
        COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM dbo.OrderItem OI
    INNER JOIN dbo.Product P
        ON OI.ProductID = P.ProductID
    INNER JOIN dbo.Brand B
        ON P.BrandID = B.BrandID
    INNER JOIN dbo.SubCategory SC
        ON P.SubCategoryID = SC.SubCategoryID
    INNER JOIN dbo.Category C
        ON SC.CategoryID = C.CategoryID
    INNER JOIN dbo.[Order] O
        ON OI.OrderID = O.OrderID
    GROUP BY
        P.ProductID,
        P.ProductName,
        B.BrandName,
        SC.SubCategoryName,
        C.CategoryName
)
SELECT
    DENSE_RANK() OVER
    (
        ORDER BY TotalRevenue DESC
    ) AS RevenueRank,
    ProductName,
    BrandName,
    CategoryName,
    SubCategoryName,
    TotalRevenue,
    TotalQuantitySold,
    TotalOrders
FROM ProductRevenue
ORDER BY RevenueRank;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 051 : Product Revenue Ranking Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 052 : Product Revenue Contribution (%)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of the total business revenue is contributed by each
product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue contribution analysis helps identify products that contribute the
most to overall business revenue. This supports portfolio optimization,
marketing investment decisions, and revenue concentration analysis.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates each product's contribution to the overall revenue
using a window function. Products with the highest contribution can be
identified immediately.

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        B.BrandName,
        SC.SubCategoryName,
        C.CategoryName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.OrderItem OI
    INNER JOIN dbo.Product P
        ON OI.ProductID = P.ProductID
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
        SC.SubCategoryName,
        C.CategoryName
)
SELECT
    ProductName,
    BrandName,
    CategoryName,
    SubCategoryName,
    TotalRevenue,
    ROUND
    (
        TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (), 2
    ) AS RevenueContributionPercentage
FROM ProductRevenue
ORDER BY
    RevenueContributionPercentage DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 052 : Product Revenue Contribution (%) Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 053 : Average Selling Price by Product
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average selling price of each product?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Selling Price (ASP) helps evaluate product pricing consistency,
identify premium products, compare pricing across brands, and support
pricing strategy decisions.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates the average selling price for each product based on
all completed sales transactions.

Products are ranked from the highest to the lowest average selling price.

------------------------------------------------------------------------------
*/

SELECT
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName,
    ROUND(AVG(OI.UnitPrice), 2) AS AverageSellingPrice,
    SUM(OI.Quantity) AS TotalQuantitySold,
    SUM(OI.LineTotal) AS TotalRevenue
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
    ON SC.CategoryID = C.CategoryID
GROUP BY
    P.ProductName,
    B.BrandName,
    SC.SubCategoryName,
    C.CategoryName
ORDER BY
    AverageSellingPrice DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 053 : Average Selling Price by Product Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 054 : Average Quantity Sold per Order
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average quantity of products sold per customer order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Quantity per Order helps understand customer purchasing behavior,
basket size, and order composition. It assists in identifying opportunities
for cross-selling, upselling, and promotional strategies to increase the
average basket size.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates the average number of product units purchased per
order and also provides total quantity sold and total orders for reference.

------------------------------------------------------------------------------
*/

SELECT
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND
    (
        CAST(SUM(OI.Quantity) AS DECIMAL(18,2)) / COUNT(DISTINCT O.OrderID), 2
    ) AS AverageQuantityPerOrder
FROM dbo.[Order] O
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 054 : Average Quantity Sold per Order Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 055 : Top 10 Highest Revenue Orders
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customer orders generated the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying high-value orders helps the business understand purchasing
patterns, recognize premium customers, and evaluate opportunities for
upselling, personalized offers, and customer retention.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks all customer orders by total order revenue and returns
the Top 10 highest-value orders along with customer and order details.

------------------------------------------------------------------------------
*/

WITH OrderRevenue AS
(
    SELECT
        O.OrderID,
        O.OrderDate,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        SUM(OI.LineTotal) AS TotalRevenue,
        SUM(OI.Quantity) AS TotalQuantity,
        COUNT(OI.OrderItemID) AS TotalProducts
    FROM dbo.[Order] O
    INNER JOIN dbo.Customer C
        ON O.CustomerID = C.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        O.OrderID,
        O.OrderDate,
        C.FirstName,
        C.LastName
)
SELECT TOP (10)
    ROW_NUMBER() OVER
    (
        ORDER BY TotalRevenue DESC
    ) AS RevenueRank,
    OrderID,
    OrderDate,
    CustomerName,
    TotalProducts,
    TotalQuantity,
    TotalRevenue
FROM OrderRevenue
ORDER BY TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 055 : Top 10 Highest Revenue Orders Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 056 : Largest Orders by Quantity
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customer orders contain the highest quantity of products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Analyzing high-volume orders helps identify bulk purchasing behavior,
large customers, wholesale opportunities, and inventory planning.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query ranks customer orders based on the total quantity of products
purchased and returns the Top 10 largest orders.

------------------------------------------------------------------------------
*/

WITH OrderQuantity AS
(
    SELECT
        O.OrderID,
        O.OrderDate,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        SUM(OI.Quantity) AS TotalQuantity,
        COUNT(*) AS TotalProducts,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.Customer C
        ON O.CustomerID = C.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        O.OrderID,
        O.OrderDate,
        C.FirstName,
        C.LastName
)
SELECT TOP (10)
    ROW_NUMBER() OVER
    (
        ORDER BY TotalQuantity DESC
    ) AS QuantityRank,
    OrderID,
    OrderDate,
    CustomerName,
    TotalProducts,
    TotalQuantity,
    TotalRevenue
FROM OrderQuantity
ORDER BY
    TotalQuantity DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 056 : Largest Orders by Quantity Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 057 : Monthly Sales Growth (%)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has monthly sales revenue changed compared to the previous month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly Sales Growth is one of the most important KPIs for business
performance evaluation. It helps management identify growth trends,
seasonality, and revenue fluctuations over time.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates monthly revenue and compares it with the previous
month to determine the Month-over-Month (MoM) Growth Percentage.

Positive values indicate growth, while negative values indicate decline.

------------------------------------------------------------------------------
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate),
        MONTH(O.OrderDate),
        DATENAME(MONTH, O.OrderDate)
),
RevenueGrowth AS
(
    SELECT
        SalesYear,
        SalesMonth,
        MonthName,
        MonthlyRevenue,
        LAG(MonthlyRevenue)
        OVER
        (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    SalesYear,
    MonthName,
    MonthlyRevenue,
    PreviousMonthRevenue,
    ROUND
    (
        (MonthlyRevenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue,0),2
    ) AS MonthlyGrowthPercentage
FROM RevenueGrowth
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 057 : Monthly Sales Growth (%) Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 058 : Year-over-Year Sales Growth (%)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has annual sales revenue changed compared to the previous year?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Year-over-Year (YoY) growth measures long-term business performance,
eliminates seasonal fluctuations, and helps management evaluate
overall business growth.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates yearly revenue and compares it with the previous
year to determine the Year-over-Year (YoY) Growth Percentage.

Positive values indicate business growth, while negative values indicate
a decline in annual revenue.

------------------------------------------------------------------------------
*/

WITH YearlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        SUM(OI.LineTotal) AS YearlyRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate)
),
RevenueGrowth AS
(
    SELECT
        SalesYear,
        YearlyRevenue,
        LAG(YearlyRevenue)
        OVER
        (
            ORDER BY SalesYear
        ) AS PreviousYearRevenue
    FROM YearlyRevenue
)
SELECT
    SalesYear,
    YearlyRevenue,
    PreviousYearRevenue,
    ROUND
    (
        (YearlyRevenue - PreviousYearRevenue) * 100.0 / NULLIF(PreviousYearRevenue, 0),2
    ) AS YearlyGrowthPercentage
FROM RevenueGrowth
ORDER BY
    SalesYear;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 058 : Year-over-Year Sales Growth (%) Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 059 : Quarter-wise Sales Performance
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does sales revenue vary across different quarters of the year?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Quarter-wise sales analysis helps identify seasonal trends, evaluate
business performance across financial quarters, and support strategic
planning, budgeting, and forecasting.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates total revenue, total orders, and total quantity sold
for each quarter, allowing management to compare business performance
throughout the year.

------------------------------------------------------------------------------
*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    CONCAT('Q', DATEPART(QUARTER, O.OrderDate)) AS SalesQuarter,
    SUM(OI.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND
    (
        AVG(O.NetAmount), 2
    ) AS AverageOrderValue
FROM dbo.[Order] O
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    DATEPART(QUARTER, O.OrderDate)
ORDER BY
    SalesYear,
    DATEPART(QUARTER, O.OrderDate);

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 059 : Quarter-wise Sales Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 060 : Running Total Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does cumulative revenue grow over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Running Total Revenue helps visualize cumulative business growth over
time. It enables management to monitor revenue progression, evaluate
business momentum, and compare actual performance against targets.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates monthly revenue and continuously accumulates it to
display the running total revenue over time.

------------------------------------------------------------------------------
*/

WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate),
        MONTH(O.OrderDate),
        DATENAME(MONTH, O.OrderDate)
)
SELECT
    SalesYear,
    SalesMonth,
    MonthName,
    MonthlyRevenue,
    SUM(MonthlyRevenue)
        OVER
        (
            ORDER BY
                SalesYear,
                SalesMonth
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningTotalRevenue
FROM MonthlyRevenue
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 060 : Running Total Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 061 : Average Revenue per Order
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average revenue generated from each customer order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Revenue per Order (ARPO) is one of the most important sales KPIs.
It helps measure customer spending behavior, evaluate pricing strategies,
and monitor the effectiveness of upselling and cross-selling initiatives.

A higher Average Revenue per Order generally indicates better sales
performance and improved customer purchasing behavior.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Orders
• Total Revenue
• Average Revenue per Order

This KPI provides a quick summary of customer spending efficiency.

------------------------------------------------------------------------------
*/

WITH OrderSummary AS
(
    SELECT
        O.OrderID,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        O.OrderID
)
SELECT
    COUNT(*) AS TotalOrders,
    SUM(TotalRevenue) AS TotalRevenue,
    ROUND
    (
        AVG(TotalRevenue),2
    ) AS AverageRevenuePerOrder
FROM OrderSummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 061 : Average Revenue per Order Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 062 : Revenue vs Quantity Trend
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does revenue change as the quantity of products purchased increases?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding the relationship between quantity sold and revenue helps
identify purchasing patterns, evaluate pricing strategies, and determine
whether higher quantities lead to proportionally higher revenue.

This analysis is useful for:

• Bundle Offer Analysis
• Bulk Purchase Behavior
• Pricing Optimization
• Customer Spending Patterns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query groups orders by the total quantity of products purchased and
calculates:

• Number of Orders
• Total Revenue
• Average Revenue

This helps visualize how revenue changes with different order quantities.

------------------------------------------------------------------------------
*/

WITH OrderSummary AS
(
    SELECT
        O.OrderID,
        SUM(OI.Quantity) AS TotalQuantity,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        O.OrderID
)
SELECT
    TotalQuantity,
    COUNT(*) AS TotalOrders,
    SUM(TotalRevenue) AS TotalRevenue,
    ROUND(AVG(TotalRevenue),2) AS AverageRevenue
FROM OrderSummary
GROUP BY
    TotalQuantity
ORDER BY
    TotalQuantity;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 062 : Revenue vs Quantity Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 063 : Order Size Distribution
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customer orders distributed based on the number of products
purchased in each order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Order Size Distribution helps understand customer purchasing behavior by
categorizing orders into different basket sizes.

This analysis helps the business:

• Understand customer buying patterns
• Identify the most common basket size
• Design bundle offers
• Create quantity-based promotions
• Improve cross-selling and upselling strategies

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query classifies each order into one of the following categories:

• Small Orders
• Medium Orders
• Large Orders
• Bulk Orders

It then calculates:

• Total Orders
• Total Revenue
• Average Revenue
• Average Quantity

------------------------------------------------------------------------------
*/

WITH OrderSummary AS
(
    SELECT
        O.OrderID,
        SUM(OI.Quantity) AS TotalQuantity,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.[Order] O
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        O.OrderID
)
SELECT
    CASE
        WHEN TotalQuantity <= 2 THEN 'Small Order'
        WHEN TotalQuantity BETWEEN 3 AND 5 THEN 'Medium Order'
        WHEN TotalQuantity BETWEEN 6 AND 10 THEN 'Large Order'
        ELSE 'Bulk Order'
    END AS OrderSize,
    COUNT(*) AS TotalOrders,
    SUM(TotalRevenue) AS TotalRevenue,
    ROUND(AVG(TotalRevenue),2) AS AverageRevenue,
    ROUND(AVG(CAST(TotalQuantity AS DECIMAL(10,2))),2) AS AverageQuantity
FROM OrderSummary
GROUP BY
    CASE
        WHEN TotalQuantity <= 2 THEN 'Small Order'
        WHEN TotalQuantity BETWEEN 3 AND 5 THEN 'Medium Order'
        WHEN TotalQuantity BETWEEN 6 AND 10 THEN 'Large Order'
        ELSE 'Bulk Order'
    END
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 063 : Order Size Distribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 064 : Revenue Pareto Analysis (80/20 Rule)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products contribute the majority of the business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Pareto Principle (80/20 Rule) states that approximately 80% of
business revenue is generated by around 20% of products.

This analysis helps management:

• Identify high-value products
• Prioritize inventory investment
• Optimize marketing campaigns
• Improve product portfolio decisions
• Focus on products generating maximum business value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Revenue
• Running Revenue
• Revenue Contribution (%)
• Cumulative Revenue Contribution (%)

Products at the top of the list contribute the majority of total revenue.

------------------------------------------------------------------------------
*/

WITH ProductRevenue AS(
    SELECT
        P.ProductID,
        P.ProductName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product P
    INNER JOIN dbo.OrderItem OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName
)
SELECT
    ProductID,
    ProductName,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (),2) AS RevenueContributionPercentage,
    SUM(TotalRevenue)OVER(
            ORDER BY TotalRevenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningRevenue,
    ROUND(SUM(TotalRevenue)OVER(ORDER BY TotalRevenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) * 100.0 / SUM(TotalRevenue) OVER (), 2
    ) AS CumulativeRevenuePercentage
FROM ProductRevenue
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 064 : Revenue Pareto Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 065 : Sales Dashboard Dataset
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we prepare a clean and comprehensive sales dataset for visualization
and dashboard reporting?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Business Intelligence tools such as Power BI, Tableau, and Excel require
well-structured datasets rather than aggregated reports.

This KPI prepares a denormalized sales dataset that can be directly
connected to dashboards without requiring additional SQL transformations.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The dataset contains:

• Order Information
• Customer Information
• Product Information
• Category Information
• Brand Information
• Employee Information
• Store Information
• Payment Information
• Revenue Metrics

This serves as the primary fact dataset for executive dashboards.

------------------------------------------------------------------------------
*/

SELECT
    O.OrderID,
    O.OrderDate,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    C.City,
    C.State,
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SC.SubCategoryName,
    E.FirstName + ' ' + E.LastName AS EmployeeName,
    S.StoreName,
    PM.MethodName,
    OI.Quantity,
    OI.UnitPrice,
    OI.DiscountAmount,
    OI.TaxAmount,
    OI.LineTotal
FROM dbo.[Order] O
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
INNER JOIN dbo.Payment PAY
    ON O.OrderID = PAY.OrderID
INNER JOIN dbo.PaymentMethod PM
    ON PAY.PaymentMethodID = PM.PaymentMethodID
ORDER BY
    O.OrderDate,
    O.OrderID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 065 : Sales Dashboard Dataset Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 066 : Revenue by Country
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which countries generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue by Country helps businesses identify high-performing geographic
markets. This KPI supports expansion planning, regional marketing
strategies, inventory allocation, and international sales analysis.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

for each country.

The results are sorted by revenue in descending order.

------------------------------------------------------------------------------
*/

SELECT
    C.Country,
    SUM(OI.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
FROM dbo.[Order] O
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
GROUP BY
    C.Country
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 066 : Revenue by Country Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 067 : Revenue by State
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which states generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue by State helps businesses identify their strongest regional
markets. This KPI supports regional sales analysis, marketing allocation,
store expansion planning, and inventory optimization.

Management can use this KPI to determine which states contribute the most
to the company's overall revenue.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

for each state.

Results are sorted from highest revenue to lowest revenue.

------------------------------------------------------------------------------
*/

SELECT
    C.State,
    SUM(OI.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
FROM dbo.[Order] O
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
GROUP BY
    C.State
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 067 : Revenue by State Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 068 : Revenue by City
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which cities generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue by City provides detailed geographic insights into business
performance. It helps management identify high-performing cities,
allocate marketing budgets effectively, optimize inventory distribution,
and make informed decisions regarding new store locations.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

for each city.

Results are sorted by Total Revenue in descending order.

------------------------------------------------------------------------------
*/

SELECT
    C.City,
    C.State,
    C.Country,
    SUM(OI.LineTotal) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
FROM dbo.[Order] O
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
GROUP BY
    C.City,
    C.State,
    C.Country
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 068 : Revenue by City Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 069 : Store-wise Revenue Ranking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store Revenue Ranking helps management evaluate the performance of each
store, identify top-performing locations, recognize underperforming
stores, and optimize operational strategies.

This KPI is useful for:

• Store Performance Evaluation
• Regional Comparison
• Expansion Planning
• Performance-Based Incentives
• Revenue Benchmarking

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

It then ranks stores based on Total Revenue using DENSE_RANK().

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS(
    SELECT
        S.StoreID,
        S.StoreName,
        S.City,
        S.State,
        SUM(OI.LineTotal) AS TotalRevenue,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantitySold,
        ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName,
        S.City,
        S.State
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalRevenue DESC) AS StoreRank,
    StoreID,
    StoreName,
    City,
    State,
    TotalRevenue,
    TotalOrders,
    TotalQuantitySold,
    AverageOrderValue
FROM StoreRevenue
ORDER BY
    StoreRank;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 069 : Store-wise Revenue Ranking Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 070 : Revenue Contribution (%) by Store
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much does each store contribute to the company's total revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Contribution analysis helps management understand which stores
are driving overall business performance.

This KPI is useful for:

• Store Performance Evaluation
• Resource Allocation
• Marketing Budget Planning
• Store Expansion Decisions
• Executive Dashboards

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Revenue
• Revenue Contribution (%)
• Running Revenue
• Cumulative Revenue Contribution (%)

Stores contributing the highest percentage of revenue appear first.

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        S.City,
        S.State,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName,
        S.City,
        S.State
)
SELECT
    StoreID,
    StoreName,
    City,
    State,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / SUM(TotalRevenue) OVER (), 2) AS RevenueContributionPercentage,
    SUM(TotalRevenue) OVER(
            ORDER BY TotalRevenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS RunningRevenue,
    ROUND(SUM(TotalRevenue) OVER
            (ORDER BY TotalRevenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) * 100.0 / SUM(TotalRevenue) OVER (),2) AS CumulativeRevenuePercentage
FROM StoreRevenue
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 070 : Revenue Contribution (%) by Store Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 071 : Top 10 Stores by Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which are the Top 10 revenue-generating stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying the highest-performing stores helps management recognize
successful business locations, understand regional demand, reward store
performance, and replicate best practices across other stores.

This KPI is useful for:

• Executive Reporting
• Performance Recognition
• Expansion Planning
• Revenue Benchmarking
• Regional Business Analysis

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies the Top 10 stores based on Total Revenue and
displays:

• Revenue Rank
• Store Information
• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        S.City,
        S.State,
        SUM(OI.LineTotal) AS TotalRevenue,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantitySold,
        ROUND
        (AVG(O.NetAmount),2) AS AverageOrderValue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName,
        S.City,
        S.State
)
SELECT TOP (10)
    DENSE_RANK() OVER(ORDER BY TotalRevenue DESC) AS RevenueRank,
    StoreID,
    StoreName,
    City,
    State,
    TotalRevenue,
    TotalOrders,
    TotalQuantitySold,
    AverageOrderValue
FROM StoreRevenue
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 071 : Top 10 Stores by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 072 : Bottom 10 Stores by Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which are the Bottom 10 revenue-generating stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying the lowest-performing stores helps management understand
which locations require attention.

This KPI is useful for:

• Performance Improvement
• Operational Review
• Marketing Strategy
• Inventory Optimization
• Store Closure or Expansion Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies the Bottom 10 stores based on Total Revenue and
displays:

• Revenue Rank
• Store Information
• Total Revenue
• Total Orders
• Total Quantity Sold
• Average Order Value

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        S.City,
        S.State,
        SUM(OI.LineTotal) AS TotalRevenue,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantitySold,
        ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName,
        S.City,
        S.State
)
SELECT TOP (10)
    DENSE_RANK() OVER (ORDER BY TotalRevenue ASC) AS RevenueRank,
    StoreID,
    StoreName,
    City,
    State,
    TotalRevenue,
    TotalOrders,
    TotalQuantitySold,
    AverageOrderValue
FROM StoreRevenue
ORDER BY
    TotalRevenue ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 072 : Bottom 10 Stores by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 073 : Average Revenue per Store
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average revenue generated by each store?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Revenue per Store is an important executive KPI used to evaluate
overall store performance and business efficiency.

It helps management:

• Measure store productivity
• Benchmark store performance
• Evaluate expansion opportunities
• Compare business performance over time
• Monitor operational efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Stores
• Total Revenue
• Average Revenue per Store
• Highest Store Revenue
• Lowest Store Revenue

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName
)
SELECT
    COUNT(*) AS TotalStores,
    SUM(TotalRevenue) AS TotalRevenue,
    ROUND
    (AVG(TotalRevenue), 2) AS AverageRevenuePerStore,
    MAX(TotalRevenue) AS HighestStoreRevenue,
    MIN(TotalRevenue) AS LowestStoreRevenue
FROM StoreRevenue;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 073 : Average Revenue per Store Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 074 : Store Performance Classification
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can stores be classified based on their revenue performance?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store Performance Classification enables management to quickly identify
high-performing, average-performing, and underperforming stores.

This KPI supports:

• Performance Evaluation
• Incentive Programs
• Store Improvement Plans
• Expansion Decisions
• Executive Dashboards

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query classifies each store into one of three categories:

• High Performing
• Medium Performing
• Low Performing

Classification is based on comparison with the Average Store Revenue.

------------------------------------------------------------------------------
*/

WITH StoreRevenue AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        S.City,
        S.State,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Store S
    INNER JOIN dbo.[Order] O
        ON S.StoreID = O.StoreID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        S.StoreID,
        S.StoreName,
        S.City,
        S.State
),
AverageRevenue AS
(
    SELECT
        AVG(TotalRevenue) AS AvgRevenue
    FROM StoreRevenue
)
SELECT
    SR.StoreID,
    SR.StoreName,
    SR.City,
    SR.State,
    SR.TotalRevenue,
    CASE
        WHEN SR.TotalRevenue >= AR.AvgRevenue * 1.20 THEN 'High Performing'
        WHEN SR.TotalRevenue >= AR.AvgRevenue * 0.80 THEN 'Medium Performing'
        ELSE 'Low Performing'
    END AS PerformanceCategory
FROM StoreRevenue SR
CROSS JOIN AverageRevenue AR
ORDER BY
    SR.TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 074 : Store Performance Classification Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 075 : Sales Analysis Dashboard Dataset
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we prepare a comprehensive sales dataset that can be directly used
for Power BI, Tableau, or other Business Intelligence dashboards?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Business Intelligence dashboards require a clean and denormalized dataset
instead of multiple normalized tables.

This dataset combines:

• Order Information
• Customer Information
• Product Information
• Category Information
• Brand Information
• Store Information
• Employee Information
• Payment Information
• Revenue Metrics

into one analytical dataset.

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

This dataset serves as the foundation for:

• Executive Dashboard
• Sales Dashboard
• Customer Dashboard
• Product Dashboard
• Store Dashboard
• Geographic Dashboard

------------------------------------------------------------------------------
*/

SELECT
    O.OrderID,    -- Order Information
    O.OrderDate,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    DATEPART(QUARTER, O.OrderDate) AS SalesQuarter,
	C.CustomerID,		 -- Customer Information
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    C.City,
    C.State,
    C.Country,
    S.StoreID,		 -- Store Information
    S.StoreName,
    S.City AS StoreCity,
    S.State AS StoreState,
    E.EmployeeID,		 -- Employee Information
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    P.ProductID,		 -- Product Information
    P.ProductName,
    B.BrandName,
    CAT.CategoryName,
    SC.SubCategoryName,
    PM.MethodName,		 -- Payment Information
    OI.Quantity,    -- Sales Metrics
    OI.UnitPrice,
    OI.DiscountAmount,
    OI.TaxAmount,
    OI.LineTotal
FROM dbo.[Order] O
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID
INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category CAT
    ON SC.CategoryID = CAT.CategoryID
INNER JOIN dbo.Payment PAY
    ON O.OrderID = PAY.OrderID
INNER JOIN dbo.PaymentMethod PM
    ON PAY.PaymentMethodID = PM.PaymentMethodID
ORDER BY
    O.OrderDate,
    O.OrderID,
    P.ProductName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 075 : Sales Analysis Dashboard Dataset Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO