/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 33_Time_Series_Analysis.sql
Description     : Time Series Analysis KPIs for Business Trend & Growth Insights

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

KPI Range       : 316 - 345
Total KPIs      : 30
Difficulty      : Intermediate → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module analyzes business performance over time by measuring revenue
trends, sales growth, customer growth, seasonal patterns, rolling metrics,
running totals, moving averages, forecasting baselines, and executive
business trends.

These KPIs help organizations monitor business growth, identify seasonal
patterns, measure month-over-month and year-over-year performance, evaluate
long-term trends, support forecasting, and enable data-driven strategic
decision-making.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Time Series Analysis

KPI Range          : 316 - 345

Total KPIs         : 30

Estimated Runtime  : < 25 Seconds

Primary SQL Concepts
--------------------

• SELECT
• GROUP BY
• INNER JOIN
• LEFT JOIN
• Common Table Expressions (CTE)
• Aggregate Functions
• Window Functions
• LAG
• LEAD
• ROW_NUMBER
• DENSE_RANK
• SUM() OVER()
• AVG() OVER()
• Running Totals
• Rolling Aggregations
• CASE
• DATE Functions
• YEAR
• MONTH
• DATEPART
• DATEDIFF
• DATEADD
• ISNULL
• NULLIF
• Conditional Aggregation

==============================================================================*/

USE RetailSalesDB;
GO

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT '33_Time_Series_Analysis.sql';
PRINT '==============================================================';

PRINT 'Starting Time Series Analysis KPI Module...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 316 : Daily Revenue Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does daily revenue change over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Daily Revenue Trend is one of the most fundamental business KPIs. It helps
organizations monitor day-to-day sales performance, detect unusual revenue
patterns, identify peak selling days, and evaluate overall business growth.

This KPI helps management:

• Monitor Daily Business Performance
• Identify Peak Revenue Days
• Detect Revenue Drops
• Support Sales Forecasting
• Improve Operational Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Date
• Total Orders
• Total Revenue
• Average Order Value

Average Order Value (AOV) =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    CAST(O.OrderDate AS DATE) AS SalesDate,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    CAST(O.OrderDate AS DATE)
ORDER BY
    SalesDate;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 316 : Daily Revenue Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 317 : Weekly Revenue Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does weekly revenue change over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Weekly Revenue Trend provides a higher-level view of business performance by
aggregating daily sales into weekly periods. It helps identify weekly business
cycles, monitor growth, and evaluate the effectiveness of promotions and
marketing campaigns.

This KPI helps management:

• Monitor Weekly Sales Performance
• Identify High Revenue Weeks
• Measure Weekly Business Growth
• Evaluate Marketing Campaign Impact
• Support Operational Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Week Number
• Week Start Date
• Week End Date
• Total Orders
• Total Revenue
• Average Order Value

Average Order Value (AOV) =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    DATEPART(WEEK, O.OrderDate) AS WeekNumber,
    MIN(CAST(O.OrderDate AS DATE)) AS WeekStartDate,
    MAX(CAST(O.OrderDate AS DATE)) AS WeekEndDate,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    DATEPART(WEEK, O.OrderDate)
ORDER BY
    SalesYear,
    WeekNumber;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 317 : Weekly Revenue Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 318 : Monthly Revenue Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has monthly revenue changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly Revenue Trend provides a strategic view of business performance by
tracking revenue generated each month.

This KPI helps management:

• Measure Monthly Business Growth
• Identify High Performing Months
• Detect Revenue Decline
• Monitor Business Performance
• Support Financial Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Total Orders
• Total Revenue
• Average Order Value (AOV)

Average Order Value (AOV) =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID), 0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 318 : Monthly Revenue Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 319 : Quarterly Revenue Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has quarterly revenue changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Quarterly Revenue Trend provides a strategic business view by aggregating
monthly sales into financial quarters.

This KPI helps management:

• Monitor Quarterly Business Performance
• Compare Quarterly Revenue
• Identify Seasonal Business Patterns
• Support Financial Planning
• Evaluate Long-Term Business Growth

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Quarter
• Total Orders
• Total Revenue
• Average Order Value (AOV)

Average Order Value (AOV) =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    DATEPART(QUARTER, O.OrderDate) AS SalesQuarter,
    CONCAT('Q',DATEPART(QUARTER, O.OrderDate)) AS QuarterName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    DATEPART(QUARTER, O.OrderDate)
ORDER BY
    SalesYear,
    SalesQuarter;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 319 : Quarterly Revenue Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 320 : Yearly Revenue Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has yearly revenue changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Yearly Revenue Trend provides a high-level view of business growth by
summarizing annual sales performance.

This KPI helps management:

• Evaluate Annual Business Growth
• Compare Yearly Revenue Performance
• Measure Long-Term Business Trends
• Support Strategic Planning
• Assist Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Total Orders
• Total Revenue
• Average Order Value (AOV)

Average Order Value (AOV) =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID), 0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate)
ORDER BY
    SalesYear;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 320 : Yearly Revenue Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 321 : Daily Order Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does the number of customer orders change on a daily basis?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Daily Order Trend measures daily customer purchasing activity and helps
organizations understand order volume fluctuations over time.

This KPI helps management:

• Monitor Daily Order Activity
• Identify Peak Order Days
• Detect Demand Fluctuations
• Improve Workforce Planning
• Support Operational Decision-Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Date
• Total Orders
• Total Revenue
• Average Revenue per Order

Average Revenue per Order =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    CAST(O.OrderDate AS DATE) AS SalesDate,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageRevenuePerOrder
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    CAST(O.OrderDate AS DATE)
ORDER BY
    SalesDate;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 321 : Daily Order Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 322 : Weekly Order Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does customer order volume change on a weekly basis?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Weekly Order Trend helps organizations monitor order demand over time by
aggregating daily transactions into weekly periods.

This KPI helps management:

• Monitor Weekly Order Performance
• Identify Peak Order Weeks
• Detect Demand Changes
• Improve Workforce Planning
• Support Sales Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Week Number
• Week Start Date
• Week End Date
• Total Orders
• Total Revenue
• Average Revenue per Order

Average Revenue per Order =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    DATEPART(WEEK, O.OrderDate) AS WeekNumber,
    MIN(CAST(O.OrderDate AS DATE)) AS WeekStartDate,
    MAX(CAST(O.OrderDate AS DATE)) AS WeekEndDate,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageRevenuePerOrder
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    DATEPART(WEEK, O.OrderDate)
ORDER BY
    SalesYear,
    WeekNumber;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 322 : Weekly Order Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 323 : Monthly Order Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does customer order volume change on a monthly basis?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly Order Trend provides a strategic view of customer purchasing activity
by aggregating orders at the monthly level.

This KPI helps management:

• Monitor Monthly Order Performance
• Identify Peak Ordering Months
• Detect Changes in Customer Demand
• Support Capacity Planning
• Improve Sales Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Total Orders
• Total Revenue
• Average Revenue per Order

Average Revenue per Order =
Total Revenue / Total Orders

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageRevenuePerOrder
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 323 : Monthly Order Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 324 : Customer Growth Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has the number of new customers changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Growth Trend measures how many new customers are acquired each month,
providing insight into business expansion and customer acquisition
performance.

This KPI helps management:

• Monitor Customer Acquisition
• Measure Business Growth
• Evaluate Marketing Effectiveness
• Identify Growth Trends
• Support Strategic Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Year
• Month
• Month Name
• New Customers
• Cumulative Customers

New Customer =
Customer's First Purchase Month

------------------------------------------------------------------------------*/

;WITH FirstPurchase AS
(
    SELECT
        CustomerID,
        MIN(CAST(OrderDate AS DATE)) AS FirstPurchaseDate
    FROM dbo.[Order]
    GROUP BY
        CustomerID
)
SELECT
    YEAR(FirstPurchaseDate) AS SalesYear,
    MONTH(FirstPurchaseDate) AS SalesMonth,
    DATENAME(MONTH, FirstPurchaseDate) AS MonthName,
    COUNT(CustomerID) AS NewCustomers,
    SUM(COUNT(CustomerID)) OVER (ORDER BY YEAR(FirstPurchaseDate),MONTH(FirstPurchaseDate) ROWS UNBOUNDED PRECEDING) AS CumulativeCustomers
FROM FirstPurchase
GROUP BY
    YEAR(FirstPurchaseDate),
    MONTH(FirstPurchaseDate),
    DATENAME(MONTH, FirstPurchaseDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 324 : Customer Growth Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 325 : Product Growth Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has the number of products sold changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product Growth Trend measures the monthly quantity of products sold, helping
organizations understand demand trends and product movement over time.

This KPI helps management:

• Monitor Product Demand
• Identify Growth Trends
• Support Inventory Planning
• Improve Sales Forecasting
• Optimize Product Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Products Sold
• Distinct Products Sold
• Cumulative Products Sold

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    SUM(OI.Quantity) AS ProductsSold,
    COUNT(DISTINCT OI.ProductID) AS DistinctProductsSold,
    SUM(SUM(OI.Quantity)) OVER (ORDER BY YEAR(O.OrderDate),MONTH(O.OrderDate) ROWS UNBOUNDED PRECEDING) AS CumulativeProductsSold
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 325 : Product Growth Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 326 : Store Growth Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each store's sales revenue changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store Growth Trend measures monthly revenue generated by each store, enabling
organizations to compare store performance and identify growth patterns.

This KPI helps management:

• Monitor Store Performance
• Compare Store Growth
• Identify High Performing Stores
• Support Expansion Planning
• Improve Regional Sales Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Store ID
• Store Name
• Sales Year
• Sales Month
• Month Name
• Total Orders
• Total Revenue

------------------------------------------------------------------------------*/

SELECT
    S.StoreID,
    S.StoreName,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue
FROM dbo.Store AS S
INNER JOIN dbo.[Order] AS O
    ON S.StoreID = O.StoreID
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    S.StoreID,
    S.StoreName,
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    S.StoreName,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 326 : Store Growth Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 327 : Revenue Running Total
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has cumulative revenue grown over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Running Total provides a cumulative view of revenue growth, helping
organizations understand long-term business performance instead of viewing
each period in isolation.

This KPI helps management:

• Monitor Cumulative Revenue Growth
• Measure Long-Term Business Performance
• Track Revenue Progression
• Support Executive Reporting
• Compare Growth Across Time

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Monthly Revenue
• Cumulative Revenue

Running Total =
Sum of all monthly revenue up to the current month.

------------------------------------------------------------------------------*/

;WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
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
    ROUND(MonthlyRevenue,2) AS MonthlyRevenue,
    ROUND(SUM(MonthlyRevenue) OVER (ORDER BY SalesYear,SalesMonth ROWS UNBOUNDED PRECEDING),2) AS CumulativeRevenue
FROM MonthlyRevenue
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 327 : Revenue Running Total Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 328 : Revenue Moving Average
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the 3-month moving average of revenue over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Moving Average smooths short-term fluctuations in monthly revenue,
making it easier to identify the underlying business trend.

Unlike monthly revenue, which may fluctuate due to promotions or seasonality,
the moving average provides a clearer picture of long-term business
performance.

This KPI helps management:

• Identify Revenue Trends
• Reduce Short-Term Noise
• Monitor Business Stability
• Support Revenue Forecasting
• Improve Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Monthly Revenue
• 3-Month Moving Average Revenue

Moving Average Window

Current Month
+ Previous Month
+ Previous 2 Months

------------------------------------------------------------------------------*/

;WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
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
    ROUND(MonthlyRevenue,2) AS MonthlyRevenue,
    ROUND(AVG(MonthlyRevenue)OVER (ORDER BY SalesYear,SalesMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS ThreeMonthMovingAverage
FROM MonthlyRevenue
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 328 : Revenue Moving Average Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 329 : Month-over-Month (MoM) Revenue Growth
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has monthly revenue changed compared to the previous month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Month-over-Month (MoM) Revenue Growth measures short-term business growth by
comparing the current month's revenue with the previous month's revenue.

This KPI helps management:

• Monitor Monthly Business Growth
• Identify Revenue Acceleration
• Detect Revenue Decline
• Evaluate Sales Performance
• Support Short-Term Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Current Month Revenue
• Previous Month Revenue
• Revenue Growth
• Revenue Growth Percentage

Revenue Growth =
Current Month Revenue − Previous Month Revenue

Revenue Growth % = ((Current Month Revenue − Previous Month Revenue) / Previous Month Revenue) × 100

------------------------------------------------------------------------------*/

;WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate),
        MONTH(O.OrderDate),
        DATENAME(MONTH, O.OrderDate)
),
RevenueTrend AS
(
    SELECT
        SalesYear,
        SalesMonth,
        MonthName,
        MonthlyRevenue,
        LAG(MonthlyRevenue) OVER(ORDER BY SalesYear,SalesMonth) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    SalesYear,
    SalesMonth,
    MonthName,
    ROUND(MonthlyRevenue,2) AS CurrentMonthRevenue,
    ROUND(ISNULL(PreviousMonthRevenue,0),2) AS PreviousMonthRevenue,
    ROUND(MonthlyRevenue - ISNULL(PreviousMonthRevenue,0),2) AS RevenueGrowth,
    ROUND((MonthlyRevenue - PreviousMonthRevenue) * 100.0 / NULLIF(PreviousMonthRevenue,0),2) AS RevenueGrowthPercentage
FROM RevenueTrend
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 329 : Month-over-Month (MoM) Revenue Growth Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 330 : Quarter-over-Quarter (QoQ) Revenue Growth
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has quarterly revenue changed compared to the previous quarter?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Quarter-over-Quarter (QoQ) Revenue Growth measures business growth by
comparing revenue generated in the current quarter with the previous quarter.

This KPI provides a broader business perspective than Month-over-Month
analysis and is widely used in executive reporting.

This KPI helps management:

• Measure Quarterly Business Growth
• Identify Revenue Trends
• Detect Business Slowdowns
• Evaluate Quarterly Performance
• Support Strategic Decision-Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Quarter
• Current Quarter Revenue
• Previous Quarter Revenue
• Revenue Growth
• Revenue Growth Percentage

Revenue Growth =
Current Quarter Revenue − Previous Quarter Revenue

Revenue Growth % =((Current Quarter Revenue − Previous Quarter Revenue) / Previous Quarter Revenue) × 100

------------------------------------------------------------------------------*/

WITH QuarterlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        DATEPART(QUARTER, O.OrderDate) AS SalesQuarter,
        CONCAT('Q',DATEPART(QUARTER, O.OrderDate)) AS QuarterName,
        SUM(OI.LineTotal) AS QuarterlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate),
        DATEPART(QUARTER, O.OrderDate)
),
RevenueTrend AS
(
    SELECT
        SalesYear,
        SalesQuarter,
        QuarterName,
        QuarterlyRevenue,
        LAG(QuarterlyRevenue) OVER (ORDER BY SalesYear,SalesQuarter) AS PreviousQuarterRevenue
    FROM QuarterlyRevenue
)
SELECT
    SalesYear,
    QuarterName,
    ROUND(QuarterlyRevenue,2) AS CurrentQuarterRevenue,
    ROUND(ISNULL(PreviousQuarterRevenue,0),2) AS PreviousQuarterRevenue,
    ROUND(QuarterlyRevenue - ISNULL(PreviousQuarterRevenue,0),2) AS RevenueGrowth,
    ROUND((QuarterlyRevenue - PreviousQuarterRevenue) * 100.0 / NULLIF(PreviousQuarterRevenue,0),2) AS RevenueGrowthPercentage
FROM RevenueTrend
ORDER BY
    SalesYear,
    SalesQuarter;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 330 : Quarter-over-Quarter (QoQ) Revenue Growth Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 331 : Year-over-Year (YoY) Revenue Growth
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has yearly revenue changed compared to the previous year?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Year-over-Year (YoY) Revenue Growth measures annual business growth by
comparing the current year's revenue with the previous year's revenue.

Unlike Month-over-Month and Quarter-over-Quarter analysis, YoY Growth removes
short-term fluctuations and provides a clearer view of long-term business
performance.

This KPI helps management:

• Measure Long-Term Business Growth
• Evaluate Annual Performance
• Detect Growth Trends
• Support Strategic Planning
• Improve Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Current Year Revenue
• Previous Year Revenue
• Revenue Growth
• Revenue Growth Percentage

Revenue Growth =
Current Year Revenue − Previous Year Revenue

Revenue Growth % =
((Current Year Revenue − Previous Year Revenue)
/ Previous Year Revenue) × 100

------------------------------------------------------------------------------*/

;WITH YearlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        SUM(OI.LineTotal) AS YearlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate)
),
RevenueTrend AS
(
    SELECT
        SalesYear,
        YearlyRevenue,
        LAG(YearlyRevenue) OVER(ORDER BY SalesYear) AS PreviousYearRevenue
    FROM YearlyRevenue
)
SELECT
    SalesYear,
    ROUND(YearlyRevenue,2) AS CurrentYearRevenue,
    ROUND(ISNULL(PreviousYearRevenue,0),2) AS PreviousYearRevenue,
    ROUND(YearlyRevenue - ISNULL(PreviousYearRevenue,0),2) AS RevenueGrowth,
    ROUND((YearlyRevenue - PreviousYearRevenue) * 100.0 / NULLIF(PreviousYearRevenue,0),2) AS RevenueGrowthPercentage
FROM RevenueTrend
ORDER BY
    SalesYear;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 331 : Year-over-Year (YoY) Revenue Growth Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 332 : Sales Seasonality Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which months consistently perform better or worse in terms of sales revenue,
regardless of the year?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Sales Seasonality Analysis helps identify recurring seasonal business
patterns by comparing the average revenue generated in each calendar month
across all available years.

This KPI helps management:

• Identify Seasonal Demand
• Plan Inventory Levels
• Optimize Marketing Campaigns
• Improve Workforce Planning
• Support Revenue Forecasting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Month Number
• Month Name
• Number of Years
• Average Monthly Revenue
• Highest Monthly Revenue
• Lowest Monthly Revenue

------------------------------------------------------------------------------*/

;WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        YEAR(O.OrderDate),
        MONTH(O.OrderDate),
        DATENAME(MONTH, O.OrderDate)
)
SELECT
    SalesMonth,
    MonthName,
    COUNT(*) AS NumberOfYears,
    ROUND(AVG(MonthlyRevenue),2) AS AverageMonthlyRevenue,
    ROUND(MAX(MonthlyRevenue),2) AS HighestMonthlyRevenue,
    ROUND(MIN(MonthlyRevenue),2) AS LowestMonthlyRevenue
FROM MonthlyRevenue
GROUP BY
    SalesMonth,
    MonthName
ORDER BY
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 332 : Sales Seasonality Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 333 : Holiday Sales Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How do sales perform during holidays compared to normal business days?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Holiday Sales Analysis helps organizations measure the impact of major
holidays on revenue generation and customer purchasing behavior.

This KPI helps management:

• Measure Holiday Sales Performance
• Evaluate Promotional Campaigns
• Identify High Revenue Holidays
• Improve Marketing Strategy
• Support Seasonal Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Holiday Type
• Total Orders
• Total Revenue
• Average Order Value

Note:
This KPI assumes holidays include:

• New Year's Day
• Republic Day
• Independence Day
• Gandhi Jayanti
• Christmas Day

Additional holidays can easily be added to the CASE statement.

------------------------------------------------------------------------------*/

SELECT
    CASE
        WHEN MONTH(O.OrderDate) = 1 AND DAY(O.OrderDate) = 1 THEN 'New Year'
        WHEN MONTH(O.OrderDate) = 1 AND DAY(O.OrderDate) = 26 THEN 'Republic Day'
        WHEN MONTH(O.OrderDate) = 8 AND DAY(O.OrderDate) = 15 THEN 'Independence Day'
        WHEN MONTH(O.OrderDate) = 10 AND DAY(O.OrderDate) = 2 THEN 'Gandhi Jayanti'
        WHEN MONTH(O.OrderDate) = 12 AND DAY(O.OrderDate) = 25 THEN 'Christmas'
        ELSE 'Regular Day'
    END AS HolidayType,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    CASE
        WHEN MONTH(O.OrderDate) = 1 AND DAY(O.OrderDate) = 1 THEN 'New Year'
        WHEN MONTH(O.OrderDate) = 1 AND DAY(O.OrderDate) = 26 THEN 'Republic Day'
        WHEN MONTH(O.OrderDate) = 8 AND DAY(O.OrderDate) = 15 THEN 'Independence Day'
        WHEN MONTH(O.OrderDate) = 10 AND DAY(O.OrderDate) = 2 THEN 'Gandhi Jayanti'
        WHEN MONTH(O.OrderDate) = 12 AND DAY(O.OrderDate) = 25 THEN 'Christmas'
        ELSE 'Regular Day'
    END
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 333 : Holiday Sales Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 334 : Weekend Sales Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How do sales perform on weekends compared to weekdays?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Weekend Sales Trend helps organizations understand customer purchasing
behavior during weekends and compare it with normal working days.

This KPI helps management:

• Measure Weekend Business Performance
• Identify Customer Shopping Patterns
• Optimize Store Staffing
• Improve Weekend Promotions
• Support Sales Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Day Type
• Total Orders
• Total Revenue
• Average Order Value
• Average Daily Revenue

Weekend Days:
• Saturday
• Sunday

Weekdays:
• Monday to Friday

------------------------------------------------------------------------------*/

SELECT
    CASE
        WHEN DATENAME(WEEKDAY, O.OrderDate) IN ('Saturday','Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END AS DayType,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT CAST(O.OrderDate AS DATE)),0),2) AS AverageDailyRevenue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, O.OrderDate) IN ('Saturday','Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 334 : Weekend Sales Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 335 : Weekday Sales Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which weekdays generate the highest and lowest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Weekday Sales Trend helps organizations identify customer purchasing
patterns across different weekdays. Understanding weekday performance
supports staffing decisions, promotional planning, inventory allocation,
and operational efficiency.

This KPI helps management:

• Identify Best Performing Weekdays
• Measure Daily Customer Demand
• Optimize Staffing Levels
• Plan Marketing Campaigns
• Improve Operational Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Weekday Name
• Total Orders
• Total Revenue
• Average Order Value
• Average Daily Revenue
• Revenue Rank

------------------------------------------------------------------------------*/

SELECT
    DATENAME(WEEKDAY, O.OrderDate) AS WeekdayName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT CAST(O.OrderDate AS DATE)),0),2) AS AverageDailyRevenue,
    DENSE_RANK() OVER (ORDER BY SUM(OI.LineTotal) DESC) AS RevenueRank
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    DATENAME(WEEKDAY, O.OrderDate),
    DATEPART(WEEKDAY, O.OrderDate)
ORDER BY
    DATEPART(WEEKDAY, O.OrderDate);

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 335 : Weekday Sales Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 336 : Inventory Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has inventory availability changed over time based on product
restocking activities?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Trend helps organizations monitor stock availability and
replenishment patterns over time. It enables inventory managers to
understand whether inventory levels are improving or declining and
supports better replenishment planning.

This KPI helps management:

• Monitor Inventory Availability
• Analyze Restocking Trends
• Improve Inventory Planning
• Detect Stock Shortages
• Support Supply Chain Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Restock Year
• Restock Month
• Month Name
• Products Restocked
• Total Inventory Added
• Average Inventory per Product

------------------------------------------------------------------------------*/

SELECT
    YEAR(I.LastRestockedDate) AS RestockYear,
    MONTH(I.LastRestockedDate) AS RestockMonth,
    DATENAME(MONTH, I.LastRestockedDate) AS MonthName,
    COUNT(DISTINCT I.ProductID) AS ProductsRestocked,
    SUM(I.QuantityInStock) AS TotalInventoryInStock,
    ROUND(AVG(CAST(I.QuantityInStock AS DECIMAL(18,2))),2) AS AverageInventoryPerProduct
FROM dbo.Inventory AS I
WHERE
    I.LastRestockedDate IS NOT NULL
GROUP BY
    YEAR(I.LastRestockedDate),
    MONTH(I.LastRestockedDate),
    DATENAME(MONTH, I.LastRestockedDate)
ORDER BY
    RestockYear,
    RestockMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 336 : Inventory Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 337 : Return Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How have product returns changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return Trend measures the number of returned orders and the associated
refund value over time. Monitoring return trends helps organizations
identify quality issues, customer satisfaction problems, and operational
inefficiencies.

This KPI helps management:

• Monitor Return Volume
• Identify Return Patterns
• Measure Refund Amount
• Improve Product Quality
• Reduce Return Costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Return Year
• Return Month
• Month Name
• Total Returns
• Total Refund Amount
• Average Refund per Return

------------------------------------------------------------------------------*/

SELECT
    YEAR(R.ReturnDate) AS ReturnYear,
    MONTH(R.ReturnDate) AS ReturnMonth,
    DATENAME(MONTH, R.ReturnDate) AS MonthName,
    COUNT(R.ReturnID) AS TotalReturns,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AverageRefundPerReturn
FROM dbo.[Return] AS R
GROUP BY
    YEAR(R.ReturnDate),
    MONTH(R.ReturnDate),
    DATENAME(MONTH, R.ReturnDate)
ORDER BY
    ReturnYear,
    ReturnMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 337 : Return Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 338 : Payment Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has payment activity changed over time across different payment methods?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Trend helps organizations monitor payment transactions over time,
understand customer payment preferences, and identify shifts in payment
behavior.

This KPI helps management:

• Monitor Payment Activity
• Analyze Payment Method Trends
• Measure Revenue Collection
• Understand Customer Preferences
• Support Financial Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Payment Year
• Payment Month
• Month Name
• Payment Method
• Total Payments
• Total Amount Collected
• Average Payment Amount

------------------------------------------------------------------------------*/

SELECT
    YEAR(P.PaymentDate) AS PaymentYear,
    MONTH(P.PaymentDate) AS PaymentMonth,
    DATENAME(MONTH, P.PaymentDate) AS MonthName,
    PM.MethodName,
    COUNT(P.PaymentID) AS TotalPayments,
    ROUND(SUM(P.Amount),2) AS TotalAmountCollected,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment AS P
INNER JOIN dbo.PaymentMethod AS PM
    ON P.PaymentMethodID = PM.PaymentMethodID
GROUP BY
    YEAR(P.PaymentDate),
    MONTH(P.PaymentDate),
    DATENAME(MONTH, P.PaymentDate),
    PM.MethodName
ORDER BY
    PaymentYear,
    PaymentMonth,
    PM.MethodName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 338 : Payment Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 339 : Employee Performance Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has employee sales performance changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee Performance Trend measures monthly sales generated by each employee,
allowing organizations to monitor workforce productivity and identify
performance trends.

This KPI helps management:

• Monitor Employee Productivity
• Compare Sales Performance
• Identify Top Performers
• Measure Workforce Efficiency
• Support Performance Reviews

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Employee ID
• Employee Name
• Sales Year
• Sales Month
• Month Name
• Total Orders
• Total Revenue
• Average Order Value

------------------------------------------------------------------------------*/

SELECT
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.Employee AS E
INNER JOIN dbo.[Order] AS O
    ON E.EmployeeID = O.EmployeeID
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    EmployeeName,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 339 : Employee Performance Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 340 : Store Performance Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each store's sales performance changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store Performance Trend measures monthly revenue generated by each store,
allowing organizations to evaluate branch performance and identify
high-performing or underperforming locations.

This KPI helps management:

• Monitor Store Performance
• Compare Store Revenue Trends
• Identify High Performing Stores
• Evaluate Regional Growth
• Support Expansion Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Store ID
• Store Name
• Sales Year
• Sales Month
• Month Name
• Total Orders
• Total Revenue
• Average Order Value

------------------------------------------------------------------------------*/

SELECT
    S.StoreID,
    S.StoreName,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.Store AS S
INNER JOIN dbo.[Order] AS O
    ON S.StoreID = O.StoreID
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    S.StoreID,
    S.StoreName,
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    S.StoreName,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 340 : Store Performance Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 341 : Product Performance Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each product's sales performance changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product Performance Trend measures monthly revenue generated by each product,
helping organizations understand product demand and long-term sales
performance.

This KPI helps management:

• Monitor Product Sales Trends
• Identify Best-Selling Products
• Detect Declining Products
• Improve Inventory Planning
• Support Product Portfolio Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Sales Year
• Sales Month
• Month Name
• Quantity Sold
• Total Revenue
• Average Selling Price

Average Selling Price =
Total Revenue / Quantity Sold

------------------------------------------------------------------------------*/

SELECT
    P.ProductID,
    P.ProductName,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    SUM(OI.Quantity) AS QuantitySold,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    ROUND(SUM(OI.LineTotal) / NULLIF(SUM(OI.Quantity),0),2) AS AverageSellingPrice
FROM dbo.Product AS P
INNER JOIN dbo.OrderItem AS OI
    ON P.ProductID = OI.ProductID
INNER JOIN dbo.[Order] AS O
    ON OI.OrderID = O.OrderID
GROUP BY
    P.ProductID,
    P.ProductName,
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    P.ProductName,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 341 : Product Performance Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 342 : Revenue Forecast Baseline
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Based on historical revenue, what is the expected baseline revenue for the
next month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Forecast Baseline provides a simple forecasting model using the
average revenue of the previous three months. Although not an advanced
forecasting algorithm, it serves as an excellent baseline for budgeting,
planning, and executive reporting.

This KPI helps management:

• Estimate Future Revenue
• Support Budget Planning
• Compare Forecast vs Actual
• Build Forecast Dashboards
• Establish Baseline Predictions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Monthly Revenue
• 3-Month Average Revenue
• Forecast Baseline

Forecast Baseline =
Average Revenue of Current Month
+ Previous Month
+ Previous 2 Months

------------------------------------------------------------------------------*/

;WITH MonthlyRevenue AS
(
    SELECT
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        DATENAME(MONTH, O.OrderDate) AS MonthName,
        SUM(OI.LineTotal) AS MonthlyRevenue
    FROM dbo.[Order] AS O
    INNER JOIN dbo.OrderItem AS OI
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
    ROUND(MonthlyRevenue,2) AS MonthlyRevenue,
    ROUND(AVG(MonthlyRevenue) OVER(ORDER BY SalesYear,SalesMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS ThreeMonthAverageRevenue,
    ROUND(AVG(MonthlyRevenue)OVER(ORDER BY SalesYear,SalesMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS ForecastBaseline
FROM MonthlyRevenue
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 342 : Revenue Forecast Baseline Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 343 : Time Intelligence Dashboard Dataset
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we create a single dataset containing all major time intelligence
metrics for Power BI dashboarding?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Instead of building separate datasets for daily, monthly, quarterly and yearly
analysis, executives prefer one centralized dataset that supports multiple
Power BI visuals.

This KPI prepares a reusable Time Intelligence dataset.

This KPI helps management:

• Build Interactive Dashboards
• Analyze Revenue Trends
• Monitor Order Trends
• Track Customer Growth
• Enable Time Intelligence Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Date
• Sales Year
• Sales Quarter
• Sales Month
• Month Name
• Week Number
• Day Name
• Total Orders
• Total Revenue
• Quantity Sold
• Average Order Value

------------------------------------------------------------------------------*/

SELECT
    CAST(O.OrderDate AS DATE) AS SalesDate,
    YEAR(O.OrderDate) AS SalesYear,
    CONCAT('Q',DATEPART(QUARTER, O.OrderDate)) AS SalesQuarter,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    DATEPART(WEEK, O.OrderDate) AS WeekNumber,
    DATENAME(WEEKDAY, O.OrderDate) AS DayName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    SUM(OI.Quantity) AS QuantitySold,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
GROUP BY
    CAST(O.OrderDate AS DATE),
    YEAR(O.OrderDate),
    DATEPART(QUARTER, O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate),
    DATEPART(WEEK, O.OrderDate),
    DATENAME(WEEKDAY, O.OrderDate)
ORDER BY
    SalesDate;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 343 : Time Intelligence Dashboard Dataset Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 344 : Business Trend Dashboard Dataset
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we create a unified business trend dataset for executive dashboards
covering revenue, customers, products, stores, employees, returns, and
payments?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Executives require a single consolidated dataset that summarizes the key
business metrics by month. This dataset serves as the foundation for an
interactive Business Trend Dashboard in Power BI.

This KPI helps management:

• Monitor Overall Business Performance
• Track Revenue Growth
• Analyze Customer Activity
• Evaluate Product Sales
• Monitor Store Performance
• Support Executive Decision-Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Total Revenue
• Total Orders
• Unique Customers
• Products Sold
• Active Stores
• Active Employees
• Total Returns
• Total Refund Amount
• Total Payments

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    COUNT(DISTINCT O.CustomerID) AS UniqueCustomers,
    SUM(OI.Quantity) AS ProductsSold,
    COUNT(DISTINCT O.StoreID) AS ActiveStores,
    COUNT(DISTINCT O.EmployeeID) AS ActiveEmployees,
    COUNT(DISTINCT R.ReturnID) AS TotalReturns,
    ROUND(ISNULL(SUM(R.RefundAmount),0),2) AS TotalRefundAmount,
    ROUND(ISNULL(SUM(P.Amount),0),2) AS TotalPayments
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
LEFT JOIN dbo.[Return] AS R
    ON OI.OrderItemID = R.OrderItemID
LEFT JOIN dbo.Payment AS P
    ON O.OrderID = P.OrderID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 344 : Business Trend Dashboard Dataset Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 345 : Executive Trend Scorecard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we create a single executive scorecard that summarizes the most important
business KPIs by month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Executive Trend Scorecard provides senior management with a high-level summary
of overall business performance in a single query.

Instead of reviewing multiple reports, executives can quickly monitor revenue,
orders, customers, products, inventory, returns, payments, and operational
performance.

This KPI helps management:

• Monitor Overall Business Health
• Review Monthly Performance
• Compare Business Growth
• Support Strategic Planning
• Enable Executive Decision-Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Sales Year
• Sales Month
• Month Name
• Total Revenue
• Total Orders
• Average Order Value
• Unique Customers
• Products Sold
• Active Stores
• Active Employees
• Total Returns
• Return Rate (%)
• Total Refund Amount
• Total Payments Collected

Return Rate (%) =
(Total Returns / Total Orders) × 100

------------------------------------------------------------------------------*/

SELECT
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    DATENAME(MONTH, O.OrderDate) AS MonthName,
    ROUND(SUM(OI.LineTotal),2) AS TotalRevenue,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageOrderValue,
    COUNT(DISTINCT O.CustomerID) AS UniqueCustomers,
    SUM(OI.Quantity) AS ProductsSold,
    COUNT(DISTINCT O.StoreID) AS ActiveStores,
    COUNT(DISTINCT O.EmployeeID) AS ActiveEmployees,
    COUNT(DISTINCT R.ReturnID) AS TotalReturns,
    ROUND(COUNT(DISTINCT R.ReturnID) * 100.0 / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS ReturnRatePercentage,
    ROUND(ISNULL(SUM(R.RefundAmount),0),2) AS TotalRefundAmount,
    ROUND(ISNULL(SUM(P.Amount),0),2) AS TotalPaymentsCollected
FROM dbo.[Order] AS O
INNER JOIN dbo.OrderItem AS OI
    ON O.OrderID = OI.OrderID
LEFT JOIN dbo.[Return] AS R
    ON OI.OrderItemID = R.OrderItemID
LEFT JOIN dbo.Payment AS P
    ON O.OrderID = P.OrderID
GROUP BY
    YEAR(O.OrderDate),
    MONTH(O.OrderDate),
    DATENAME(MONTH, O.OrderDate)
ORDER BY
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 345 : Executive Trend Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';