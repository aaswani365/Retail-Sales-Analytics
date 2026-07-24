/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 25_Customer_Analysis.sql
Description     : Customer Analysis KPIs for Customer Insights

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

KPI Range       : 076 - 105
Total KPIs      : 30
Difficulty      : Intermediate SQL

Purpose
------------------------------------------------------------------------------
This module analyzes customer demographics, engagement, loyalty,
registration trends, purchasing behavior summaries, and customer
performance to generate actionable business insights.

These KPIs help organizations understand customer growth, customer
activity, loyalty program effectiveness, customer value, and engagement
patterns to support data-driven marketing, sales, and customer
relationship management strategies.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Customer Analysis

KPI Range          : 076 - 105

Total KPIs         : 30

Estimated Runtime  : < 15 Seconds

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
PRINT '25_Customer_Analysis.sql';
PRINT '==============================================================';

PRINT 'Starting Customer Analysis KPI Module...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 076 : Customer Overview
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall summary of the customer base?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Overview provides a high-level summary of the customer database.
It helps management understand customer growth, engagement, and loyalty.

This KPI supports:

• Executive Dashboards
• Customer Base Analysis
• Business Growth Monitoring
• Customer Health Assessment

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Active Customers
• Inactive Customers
• Active Customer Percentage
• Total Loyalty Points
• Average Loyalty Points
• First Customer Registration
• Latest Customer Registration

------------------------------------------------------------------------------*/

SELECT
    COUNT(CustomerID) AS TotalCustomers,
    SUM
    (
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,
    SUM
    (
        CASE
            WHEN IsActive = 0 THEN 1
            ELSE 0
        END
    ) AS InactiveCustomers,
    ROUND(SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(CustomerID),2) AS ActiveCustomerPercentage,
    SUM(LoyaltyPoints) AS TotalLoyaltyPoints,
    ROUND(AVG(CAST(LoyaltyPoints AS DECIMAL(18,2))),2) AS AverageLoyaltyPoints,
    MIN(RegistrationDate) AS FirstCustomerRegistration,
    MAX(RegistrationDate) AS LatestCustomerRegistration
FROM dbo.Customer;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 076 : Customer Overview Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 077 : Active vs Inactive Customers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the distribution of Active and Inactive customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer activity status is one of the most important business KPIs.

It helps management understand:

• Customer Engagement
• Customer Retention
• Dormant Customer Base
• Marketing Opportunities
• Overall Customer Health

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Status
• Total Customers
• Customer Percentage
• Average Loyalty Points
• First Registration Date
• Latest Registration Date

------------------------------------------------------------------------------
*/

SELECT
    CASE
        WHEN IsActive = 1 THEN 'Active Customer'
        ELSE 'Inactive Customer'
    END AS CustomerStatus,
    COUNT(CustomerID) AS TotalCustomers,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID)) OVER (),2) AS CustomerPercentage,
    AVG(LoyaltyPoints) AS AverageLoyaltyPoints,
    MIN(RegistrationDate) AS FirstRegistrationDate,
    MAX(RegistrationDate) AS LatestRegistrationDate
FROM dbo.Customer
GROUP BY
    IsActive
ORDER BY
    TotalCustomers DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 077 : Active vs Inactive Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 078 : Customer Registration Trend
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has customer registration changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Registration Trend helps businesses monitor customer acquisition
performance and identify seasonal growth patterns.

This KPI supports:

• Customer Acquisition Analysis
• Growth Monitoring
• Marketing Campaign Evaluation
• Business Expansion Planning
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Registration Year
• Registration Quarter
• Registration Month
• Month Name
• Total New Customers

Results are displayed chronologically.

------------------------------------------------------------------------------
*/

SELECT
    YEAR(RegistrationDate) AS RegistrationYear,
    DATEPART(QUARTER, RegistrationDate) AS RegistrationQuarter,
    MONTH(RegistrationDate) AS RegistrationMonth,
    DATENAME(MONTH, RegistrationDate) AS MonthName,
    COUNT(CustomerID) AS NewCustomers
FROM dbo.Customer
GROUP BY
    YEAR(RegistrationDate),
    DATEPART(QUARTER, RegistrationDate),
    MONTH(RegistrationDate),
    DATENAME(MONTH, RegistrationDate)
ORDER BY
    RegistrationYear,
    RegistrationMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 078 : Customer Registration Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 079 : Customers by Country
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers distributed across different countries?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Country Analysis helps businesses understand their geographic
customer distribution and identify high-value markets.

This KPI supports:

• Geographic Expansion
• Regional Marketing
• Customer Distribution Analysis
• Business Growth Planning
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Country
• Total Customers
• Active Customers
• Inactive Customers
• Customer Percentage
• Total Loyalty Points
• Average Loyalty Points

Countries are ranked by Total Customers.

------------------------------------------------------------------------------
*/

SELECT
    Country,
    COUNT(CustomerID) AS TotalCustomers,
    SUM(
        CASE
            WHEN IsActive = 1
                THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,
    SUM(
        CASE
            WHEN IsActive = 0
                THEN 1
            ELSE 0
        END
    ) AS InactiveCustomers,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID)) OVER (),2) AS CustomerPercentage,
    SUM(LoyaltyPoints) AS TotalLoyaltyPoints,
    ROUND(AVG(CAST(LoyaltyPoints AS DECIMAL(18,2))),2) AS AverageLoyaltyPoints
FROM dbo.Customer
GROUP BY
    Country
ORDER BY
    TotalCustomers DESC,
    Country;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 079 : Customers by Country Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 080 : Customers by State
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers distributed across different states?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

State-wise customer analysis helps businesses identify their strongest
regional markets and understand customer distribution at a more granular
level.

This KPI supports:

• Regional Business Analysis
• Sales Territory Planning
• State-wise Marketing Campaigns
• Expansion Strategy
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• State
• Total Customers
• Active Customers
• Inactive Customers
• Customer Percentage
• Total Loyalty Points
• Average Loyalty Points

States are ranked by Total Customers.

------------------------------------------------------------------------------
*/

SELECT

    State,

    COUNT(CustomerID) AS TotalCustomers,

    SUM
    (
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,

    SUM
    (
        CASE
            WHEN IsActive = 0 THEN 1
            ELSE 0
        END
    ) AS InactiveCustomers,

    ROUND
    (
        COUNT(CustomerID) * 100.0
        /
        SUM(COUNT(CustomerID)) OVER (),
        2
    ) AS CustomerPercentage,

    SUM(LoyaltyPoints) AS TotalLoyaltyPoints,

    ROUND
    (
        AVG(CAST(LoyaltyPoints AS DECIMAL(18,2))),
        2
    ) AS AverageLoyaltyPoints

FROM dbo.Customer

GROUP BY

    State

ORDER BY

    TotalCustomers DESC,

    State;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 080 : Customers by State Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 081 : Customer Lifetime Value (Approx.)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have generated the highest lifetime value for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Lifetime Value (CLV) is one of the most valuable customer metrics.

It helps businesses:

• Identify High-Value Customers
• Prioritize Customer Retention
• Design Loyalty Programs
• Optimize Marketing Spend
• Increase Customer Profitability

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Information
• Total Orders
• Total Quantity Purchased
• Total Revenue
• Average Order Value
• Customer Lifetime Value (Approx.)

Customers are ranked by Lifetime Value.

------------------------------------------------------------------------------
*/

WITH CustomerSales AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        C.City,
        C.State,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantityPurchased,
        SUM(OI.LineTotal) AS CustomerLifetimeValue,
        ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State
)
SELECT
    DENSE_RANK() OVER ( ORDER BY CustomerLifetimeValue DESC) AS CustomerRank,
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    TotalQuantityPurchased,
    CustomerLifetimeValue,
    AverageOrderValue
FROM CustomerSales
ORDER BY
    CustomerLifetimeValue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 081 : Customer Lifetime Value (Approx.) Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 082 : Average Revenue per Customer
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average revenue generated per customer?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Revenue per Customer (ARPC) is an important business metric used
to measure customer value and overall business performance.

This KPI helps management:

• Measure Customer Profitability
• Compare Customer Spending Trends
• Evaluate Marketing ROI
• Track Customer Value Growth
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Customers with Orders
• Total Revenue
• Average Revenue per Customer
• Average Orders per Customer
• Average Order Value

------------------------------------------------------------------------------
*/

WITH CustomerRevenue AS
(
    SELECT

        C.CustomerID,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    LEFT JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    LEFT JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.CustomerID
)

SELECT

    COUNT(CustomerID) AS TotalCustomers,

    COUNT
    (
        CASE
            WHEN TotalOrders > 0 THEN 1
        END
    ) AS CustomersWithOrders,

    SUM(ISNULL(TotalRevenue,0)) AS TotalRevenue,

    ROUND
    (
        AVG(ISNULL(TotalRevenue,0)),
        2
    ) AS AverageRevenuePerCustomer,

    ROUND
    (
        AVG(CAST(TotalOrders AS DECIMAL(18,2))),
        2
    ) AS AverageOrdersPerCustomer,

    ROUND
    (
        SUM(ISNULL(TotalRevenue,0))
        /
        NULLIF(SUM(TotalOrders),0),
        2
    ) AS AverageOrderValue

FROM CustomerRevenue;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 082 : Average Revenue per Customer Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 083 : Top 20 Customers by Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Who are the Top 20 customers based on total revenue generated?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Top customers contribute a significant portion of business revenue.

Identifying these customers helps businesses:

• Improve Customer Retention
• Reward Loyal Customers
• Build VIP Programs
• Increase Customer Lifetime Value
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies the Top 20 customers based on revenue and displays:

• Customer Rank
• Customer Information
• Total Orders
• Total Quantity Purchased
• Total Revenue
• Average Revenue per Order
• Loyalty Points

------------------------------------------------------------------------------
*/

WITH CustomerRevenue AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        C.City,
        C.State,
        C.LoyaltyPoints,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantityPurchased,
        SUM(OI.LineTotal) AS TotalRevenue,
        ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageRevenuePerOrder
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State,
        C.LoyaltyPoints
)
SELECT TOP (20)
    DENSE_RANK() OVER ( ORDER BY TotalRevenue DESC) AS CustomerRank,
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    TotalQuantityPurchased,
    TotalRevenue,
    AverageRevenuePerOrder,
    LoyaltyPoints
FROM CustomerRevenue
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 083 : Top 20 Customers by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 084 : Bottom 20 Customers by Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Who are the Bottom 20 customers based on total revenue generated?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Not every customer contributes equally to business revenue.

Identifying low-value customers helps businesses:

• Launch Customer Re-engagement Campaigns
• Increase Customer Lifetime Value
• Improve Customer Retention
• Analyze Low Purchasing Behavior
• Create Personalized Promotions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies the Bottom 20 customers based on revenue and displays:

• Customer Rank
• Customer Information
• Total Orders
• Total Quantity Purchased
• Total Revenue
• Average Revenue per Order
• Loyalty Points

------------------------------------------------------------------------------
*/

WITH CustomerRevenue AS
(
    SELECT

        C.CustomerID,

        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,

        C.City,

        C.State,

        C.LoyaltyPoints,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.Quantity) AS TotalQuantityPurchased,

        SUM(OI.LineTotal) AS TotalRevenue,

        ROUND
        (
            SUM(OI.LineTotal)
            /
            NULLIF(COUNT(DISTINCT O.OrderID), 0),
            2
        ) AS AverageRevenuePerOrder

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State,
        C.LoyaltyPoints
)

SELECT TOP (20)

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue ASC
        ) AS CustomerRank,

    CustomerID,

    CustomerName,

    City,

    State,

    TotalOrders,

    TotalQuantityPurchased,

    TotalRevenue,

    AverageRevenuePerOrder,

    LoyaltyPoints

FROM CustomerRevenue

ORDER BY

    TotalRevenue ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 084 : Bottom 20 Customers by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 085 : Revenue Contribution by Customer
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much does each customer contribute to the overall business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Contribution Analysis helps businesses identify their most valuable
customers and understand revenue concentration.

This KPI supports:

• Pareto (80/20) Analysis
• VIP Customer Identification
• Customer Prioritization
• Revenue Concentration Analysis
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer Information
• Total Revenue
• Revenue Contribution (%)
• Cumulative Revenue (%)
• Total Orders
• Loyalty Points

------------------------------------------------------------------------------
*/

WITH CustomerRevenue AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        C.City,
        C.State,
        C.LoyaltyPoints,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State,
        C.LoyaltyPoints
),
RevenueAnalysis AS
(
    SELECT
        *,
        SUM(TotalRevenue) OVER() AS TotalBusinessRevenue
    FROM CustomerRevenue
)
SELECT
    DENSE_RANK() OVER( ORDER BY TotalRevenue DESC) AS CustomerRank,
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    LoyaltyPoints,
    TotalRevenue,
    ROUND(TotalRevenue * 100.0 / TotalBusinessRevenue,2) AS RevenueContributionPercentage,
    ROUND(SUM(TotalRevenue) OVER ( ORDER BY TotalRevenue DESC ROWS UNBOUNDED PRECEDING ) * 100.0 / TotalBusinessRevenue,2) AS CumulativeRevenuePercentage
FROM RevenueAnalysis
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 085 : Revenue Contribution by Customer Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 086 : Repeat Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have placed more than one order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Repeat customers are a strong indicator of customer satisfaction and
business growth.

Identifying repeat customers helps businesses:

• Measure Customer Retention
• Identify Loyal Customers
• Improve Marketing Strategies
• Build Loyalty Programs
• Increase Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies repeat customers and displays:

• Customer Rank
• Customer Information
• Total Orders
• Total Quantity Purchased
• Total Revenue
• Average Order Value
• Loyalty Points

------------------------------------------------------------------------------
*/

WITH CustomerRetention AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        C.City,
        C.State,
        C.LoyaltyPoints,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantityPurchased,
        SUM(OI.LineTotal) AS TotalRevenue,
        ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID), 0),2) AS AverageOrderValue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State,
        C.LoyaltyPoints
    HAVING
        COUNT(DISTINCT O.OrderID) > 1
)
SELECT
    DENSE_RANK() OVER ( ORDER BY TotalOrders DESC, TotalRevenue DESC ) AS CustomerRank,
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    TotalQuantityPurchased,
    TotalRevenue,
    AverageOrderValue,
    LoyaltyPoints
FROM CustomerRetention
ORDER BY
    TotalOrders DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 086 : Repeat Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 087 : One-Time Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have placed only one order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

One-time customers represent potential churn risk and opportunities for
customer retention.

Identifying these customers helps businesses:

• Improve Customer Retention
• Launch Re-engagement Campaigns
• Increase Repeat Purchases
• Improve Customer Lifetime Value
• Support Marketing Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies customers who have placed exactly one order and displays:

• Customer Rank
• Customer Information
• Total Orders
• Total Quantity Purchased
• Total Revenue
• Average Order Value
• Loyalty Points

------------------------------------------------------------------------------
*/

WITH CustomerRetention AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        C.City,
        C.State,
        C.LoyaltyPoints,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        SUM(OI.Quantity) AS TotalQuantityPurchased,
        SUM(OI.LineTotal) AS TotalRevenue,
        ROUND(SUM(OI.LineTotal) / NULLIF(COUNT(DISTINCT O.OrderID),0), 2) AS AverageOrderValue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State,
        C.LoyaltyPoints
    HAVING
        COUNT(DISTINCT O.OrderID) = 1
)
SELECT
    DENSE_RANK() OVER ( ORDER BY TotalRevenue DESC ) AS CustomerRank,
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    TotalQuantityPurchased,
    TotalRevenue,
    AverageOrderValue,
    LoyaltyPoints
FROM CustomerRetention
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 087 : One-Time Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 088 : Repeat Purchase Rate (%)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of customers are repeat customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Repeat Purchase Rate (RPR) is one of the most important customer retention
metrics.

A higher Repeat Purchase Rate indicates:

• Strong Customer Loyalty
• Better Customer Satisfaction
• Successful Retention Strategy
• Higher Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Repeat Customers
• One-Time Customers
• Repeat Purchase Rate (%)
• One-Time Purchase Rate (%)

------------------------------------------------------------------------------
*/

WITH CustomerOrders AS
(
    SELECT
        C.CustomerID,
        COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM dbo.Customer C
    LEFT JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID
)
SELECT
    COUNT(CustomerID) AS TotalCustomers,
    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,
    SUM
    (
        CASE
            WHEN TotalOrders = 1 THEN 1
            ELSE 0
        END
    ) AS OneTimeCustomers,
    SUM
    (
        CASE
            WHEN TotalOrders = 0 THEN 1
            ELSE 0
        END
    ) AS CustomersWithoutOrders,
    ROUND
    (
        SUM
        (
            CASE
                WHEN TotalOrders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(CustomerID),2) AS RepeatPurchaseRate,
    ROUND
    (
        SUM
        (
            CASE
                WHEN TotalOrders = 1 THEN 1
                ELSE 0
            END ) * 100.0 / COUNT(CustomerID), 2 ) AS OneTimePurchaseRate
FROM CustomerOrders;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 088 : Repeat Purchase Rate (%) Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 089 : Average Days Between Purchases
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

On average, how many days pass between consecutive purchases for repeat
customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Purchase frequency is a key indicator of customer engagement and loyalty.

This KPI helps businesses:

• Understand Customer Buying Behavior
• Measure Purchase Frequency
• Identify Loyal Customers
• Improve Marketing Timing
• Optimize Customer Retention Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Information
• Total Orders
• First Purchase Date
• Last Purchase Date
• Customer Lifetime (Days)
• Average Days Between Purchases

Only customers with more than one order are included.

------------------------------------------------------------------------------
*/

WITH CustomerPurchaseHistory AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        C.City,
        C.State,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        MIN(O.OrderDate) AS FirstPurchaseDate,
        MAX(O.OrderDate) AS LastPurchaseDate,
        DATEDIFF(DAY, MIN(O.OrderDate), MAX(O.OrderDate)) AS CustomerLifetimeDays
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName,
        C.City,
        C.State
    HAVING
        COUNT(DISTINCT O.OrderID) > 1
)
SELECT
    CustomerID,
    CustomerName,
    City,
    State,
    TotalOrders,
    FirstPurchaseDate,
    LastPurchaseDate,
    CustomerLifetimeDays,
    ROUND(CAST(CustomerLifetimeDays AS DECIMAL(18,2)) / NULLIF(TotalOrders - 1, 0), 2) AS AverageDaysBetweenPurchases
FROM CustomerPurchaseHistory
ORDER BY
    AverageDaysBetweenPurchases ASC,
    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 089 : Average Days Between Purchases Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 090 : Customer Retention Summary
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall customer retention summary for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Retention Summary provides a high-level overview of customer
engagement and loyalty.

This KPI helps management:

• Measure Customer Retention
• Evaluate Customer Loyalty
• Monitor Customer Engagement
• Track Repeat Purchase Behavior
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Customers with Orders
• Repeat Customers
• One-Time Customers
• Customers Without Orders
• Total Orders
• Average Orders per Customer
• Repeat Purchase Rate (%)
• One-Time Purchase Rate (%)
• Customers Without Orders (%)

------------------------------------------------------------------------------
*/

WITH CustomerOrders AS
(
    SELECT
        C.CustomerID,
        COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM dbo.Customer C
    LEFT JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID
)
SELECT
    COUNT(CustomerID) AS TotalCustomers,
    SUM
    (
        CASE
            WHEN TotalOrders > 0 THEN 1
            ELSE 0
        END
    ) AS CustomersWithOrders,
    SUM
    (
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,
    SUM
    (
        CASE
            WHEN TotalOrders = 1 THEN 1
            ELSE 0
        END
    ) AS OneTimeCustomers,
    SUM
    (
        CASE
            WHEN TotalOrders = 0 THEN 1
            ELSE 0
        END
    ) AS CustomersWithoutOrders,
    SUM(TotalOrders) AS TotalOrders,
    ROUND(AVG(CAST(TotalOrders AS DECIMAL(18,2))),2) AS AverageOrdersPerCustomer,
    ROUND(SUM
        (
            CASE
                WHEN TotalOrders > 1 THEN 1
                ELSE 0
            END ) * 100.0 / COUNT(CustomerID),2) AS RepeatPurchaseRate,
    ROUND(SUM
        (
            CASE
                WHEN TotalOrders = 1 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(CustomerID), 2 ) AS OneTimePurchaseRate,
    ROUND(SUM(
            CASE
                WHEN TotalOrders = 0 THEN 1
                ELSE 0
            END) * 100.0 / COUNT(CustomerID), 2) AS CustomersWithoutOrdersPercentage
FROM CustomerOrders;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 090 : Customer Retention Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 091 : New Customers by Month
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many new customers were acquired each month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer acquisition is one of the most important business growth metrics.

Tracking monthly customer registrations helps businesses:

• Measure Business Growth
• Evaluate Marketing Campaigns
• Monitor Customer Acquisition Trends
• Plan Sales Strategies
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Registration Year
• Registration Month
• New Customers
• Cumulative Customers

Months are displayed in chronological order.

------------------------------------------------------------------------------
*/

WITH MonthlyCustomerRegistrations AS
(
    SELECT
        YEAR(RegistrationDate) AS RegistrationYear,
        MONTH(RegistrationDate) AS RegistrationMonth,
        DATENAME(MONTH, RegistrationDate) AS MonthName,
        COUNT(CustomerID) AS NewCustomers
    FROM dbo.Customer
    GROUP BY
        YEAR(RegistrationDate),
        MONTH(RegistrationDate),
        DATENAME(MONTH, RegistrationDate)
)
SELECT
    RegistrationYear,
    RegistrationMonth,
    MonthName,
    NewCustomers,
    SUM(NewCustomers) OVER ( ORDER BY RegistrationYear, RegistrationMonth ROWS UNBOUNDED PRECEDING ) AS CumulativeCustomers
FROM MonthlyCustomerRegistrations
ORDER BY
    RegistrationYear,
    RegistrationMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 091 : New Customers by Month Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 092 : New Customers by City
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which cities have acquired the highest number of new customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer acquisition by city helps businesses understand regional growth
and identify markets with the highest customer acquisition.

This KPI supports:

• Regional Expansion Planning
• City-wise Marketing Strategy
• Sales Territory Planning
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• City
• State
• Total New Customers
• Active Customers
• Inactive Customers
• Customer Contribution (%)

Cities are ranked by total new customers.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER ( ORDER BY COUNT(CustomerID) DESC) AS CityRank,
    City,
    State,
    COUNT(CustomerID) AS TotalNewCustomers,
    SUM(
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,
    SUM(
        CASE
            WHEN IsActive = 0 THEN 1
            ELSE 0
        END
    ) AS InactiveCustomers,
    ROUND(COUNT(CustomerID) * 100.0 / SUM(COUNT(CustomerID)) OVER (),2) AS CustomerContributionPercentage
FROM dbo.Customer
GROUP BY
    City,
    State
ORDER BY
    TotalNewCustomers DESC,
    City;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 092 : New Customers by City Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 093 : New Customers by Year
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many new customers were acquired each year?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Year-wise customer acquisition helps management evaluate long-term business
growth and compare yearly performance.

This KPI supports:

• Business Growth Analysis
• Annual Performance Review
• Executive Reporting
• Strategic Planning
• Marketing Effectiveness Evaluation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Registration Year
• Total New Customers
• Active Customers
• Inactive Customers
• Customer Contribution (%)
• Cumulative Customers

Years are displayed in chronological order.

------------------------------------------------------------------------------
*/

WITH YearlyCustomerRegistrations AS
(
    SELECT
        YEAR(RegistrationDate) AS RegistrationYear,
        COUNT(CustomerID) AS TotalNewCustomers,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END
        ) AS ActiveCustomers,
        SUM(
            CASE
                WHEN IsActive = 0 THEN 1
                ELSE 0
            END
        ) AS InactiveCustomers
    FROM dbo.Customer
    GROUP BY
        YEAR(RegistrationDate)
)
SELECT
    RegistrationYear,
    TotalNewCustomers,
    ActiveCustomers,
    InactiveCustomers,
    ROUND(TotalNewCustomers * 100.0 / SUM(TotalNewCustomers) OVER(),2) AS CustomerContributionPercentage,
    SUM(TotalNewCustomers) OVER ( ORDER BY RegistrationYear ROWS UNBOUNDED PRECEDING ) AS CumulativeCustomers
FROM YearlyCustomerRegistrations
ORDER BY
    RegistrationYear;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 093 : New Customers by Year Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 094 : New Customers by Quarter
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many new customers were acquired in each quarter?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Quarterly customer acquisition analysis helps businesses identify seasonal
trends and evaluate quarterly marketing performance.

This KPI supports:

• Quarterly Business Review
• Seasonal Trend Analysis
• Marketing Performance Evaluation
• Executive Reporting
• Business Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Registration Year
• Registration Quarter
• Total New Customers
• Active Customers
• Inactive Customers
• Customer Contribution (%)
• Cumulative Customers

Results are displayed chronologically.

------------------------------------------------------------------------------
*/

WITH QuarterlyCustomerRegistrations AS
(
    SELECT
        YEAR(RegistrationDate) AS RegistrationYear,
        DATEPART(QUARTER, RegistrationDate) AS RegistrationQuarter,
        COUNT(CustomerID) AS TotalNewCustomers,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END
        ) AS ActiveCustomers,
        SUM(
            CASE
                WHEN IsActive = 0 THEN 1
                ELSE 0
            END
        ) AS InactiveCustomers
    FROM dbo.Customer
    GROUP BY
        YEAR(RegistrationDate),
        DATEPART(QUARTER, RegistrationDate)
)
SELECT
    RegistrationYear,
    CONCAT('Q', RegistrationQuarter) AS Quarter,
    TotalNewCustomers,
    ActiveCustomers,
    InactiveCustomers,
    ROUND(TotalNewCustomers * 100.0 / SUM(TotalNewCustomers) OVER(), 2) AS CustomerContributionPercentage,
    SUM(TotalNewCustomers) OVER(ORDER BY RegistrationYear, RegistrationQuarter ROWS UNBOUNDED PRECEDING) AS CumulativeCustomers
FROM QuarterlyCustomerRegistrations
ORDER BY
    RegistrationYear,
    RegistrationQuarter;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 094 : New Customers by Quarter Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 095 : Customer Acquisition Summary
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall customer acquisition summary for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer acquisition is one of the primary indicators of business growth.

This KPI provides an executive summary to help management:

• Monitor Customer Growth
• Evaluate Acquisition Performance
• Measure Marketing Effectiveness
• Track Registration Trends
• Support Strategic Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Active Customers
• Inactive Customers
• First Registration Date
• Latest Registration Date
• Total Registration Period (Days)
• Average New Customers per Month
• Average New Customers per Quarter
• Average New Customers per Year

------------------------------------------------------------------------------
*/

WITH CustomerSummary AS
(
    SELECT
        COUNT(CustomerID) AS TotalCustomers,
        SUM(
            CASE
                WHEN IsActive = 1 THEN 1
                ELSE 0
            END
        ) AS ActiveCustomers,
        SUM
        (
            CASE
                WHEN IsActive = 0 THEN 1
                ELSE 0
            END
        ) AS InactiveCustomers,
        MIN(RegistrationDate) AS FirstRegistrationDate,
        MAX(RegistrationDate) AS LatestRegistrationDate,
        DATEDIFF(DAY,MIN(RegistrationDate), MAX(RegistrationDate)) AS RegistrationPeriodDays,
        COUNT(DISTINCT YEAR(RegistrationDate) * 100 + MONTH(RegistrationDate)) AS TotalMonths,
        COUNT(DISTINCT YEAR(RegistrationDate) * 10 + DATEPART(QUARTER, RegistrationDate)) AS TotalQuarters,
        COUNT(DISTINCT YEAR(RegistrationDate)) AS TotalYears
    FROM dbo.Customer
)
SELECT
    TotalCustomers,
    ActiveCustomers,
    InactiveCustomers,
    FirstRegistrationDate,
    LatestRegistrationDate,
    RegistrationPeriodDays,
    ROUND(CAST(TotalCustomers AS DECIMAL(18,2)) / NULLIF(TotalMonths,0),2) AS AverageNewCustomersPerMonth,
    ROUND(CAST(TotalCustomers AS DECIMAL(18,2)) / NULLIF(TotalQuarters,0),2) AS AverageNewCustomersPerQuarter,
    ROUND(CAST(TotalCustomers AS DECIMAL(18,2)) / NULLIF(TotalYears,0),2) AS AverageNewCustomersPerYear
FROM CustomerSummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 095 : Customer Acquisition Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 096 : Revenue by Country
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which countries generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Country-wise revenue analysis helps businesses identify their strongest
geographic markets and make informed expansion decisions.

This KPI supports:

• Geographic Revenue Analysis
• International Market Performance
• Regional Sales Strategy
• Business Expansion Planning
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Country
• Total Customers
• Total Orders
• Total Revenue
• Average Revenue per Customer
• Revenue Contribution (%)

Countries are ranked by total revenue.

------------------------------------------------------------------------------
*/

WITH CountryRevenue AS
(
    SELECT

        C.Country,

        COUNT(DISTINCT C.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.Country
)

SELECT

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS CountryRank,

    Country,

    TotalCustomers,

    TotalOrders,

    TotalRevenue,

    ROUND
    (
        TotalRevenue * 1.0
        /
        NULLIF(TotalCustomers, 0),
        2
    ) AS AverageRevenuePerCustomer,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS RevenueContributionPercentage

FROM CountryRevenue

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 096 : Revenue by Country Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 097 : Revenue by State
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which states generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

State-wise revenue analysis helps businesses identify their strongest
regional markets and optimize sales strategies.

This KPI supports:

• Regional Revenue Analysis
• Sales Territory Planning
• State-wise Performance Evaluation
• Business Expansion Strategy
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• State
• Total Customers
• Total Orders
• Total Revenue
• Average Revenue per Customer
• Revenue Contribution (%)

States are ranked by total revenue.

------------------------------------------------------------------------------
*/

WITH StateRevenue AS
(
    SELECT

        C.State,

        COUNT(DISTINCT C.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.State
)

SELECT

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS StateRank,

    State,

    TotalCustomers,

    TotalOrders,

    TotalRevenue,

    ROUND
    (
        TotalRevenue * 1.0
        /
        NULLIF(TotalCustomers, 0),
        2
    ) AS AverageRevenuePerCustomer,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS RevenueContributionPercentage

FROM StateRevenue

ORDER BY

    TotalRevenue DESC,
    State;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 097 : Revenue by State Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 098 : Top 10 Cities by Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which cities generate the highest revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

City-wise revenue analysis helps businesses identify their strongest local
markets and optimize regional sales strategies.

This KPI supports:

• City Performance Analysis
• Regional Sales Planning
• Marketing Campaign Optimization
• Business Expansion Decisions
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• City Rank
• City
• State
• Total Customers
• Total Orders
• Total Revenue
• Average Revenue per Customer
• Revenue Contribution (%)

Displays only the Top 10 revenue-generating cities.

------------------------------------------------------------------------------
*/

WITH CityRevenue AS
(
    SELECT

        C.City,

        C.State,

        COUNT(DISTINCT C.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.City,
        C.State
)

SELECT TOP (10)

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS CityRank,

    City,

    State,

    TotalCustomers,

    TotalOrders,

    TotalRevenue,

    ROUND
    (
        TotalRevenue * 1.0
        /
        NULLIF(TotalCustomers,0),
        2
    ) AS AverageRevenuePerCustomer,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS RevenueContributionPercentage

FROM CityRevenue

ORDER BY

    TotalRevenue DESC,
    City;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 098 : Top 10 Cities by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 099 : Revenue Contribution by Region
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much does each state (region) contribute to the overall business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue contribution by region helps management understand the geographic
distribution of revenue and identify the highest-performing regions.

This KPI supports:

• Regional Performance Analysis
• Pareto Analysis (80/20 Rule)
• Sales Territory Planning
• Business Expansion Decisions
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Region Rank
• State
• Total Customers
• Total Orders
• Total Revenue
• Revenue Contribution (%)
• Cumulative Revenue Contribution (%)

------------------------------------------------------------------------------
*/

WITH RegionalRevenue AS
(
    SELECT

        C.State,

        COUNT(DISTINCT C.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID

    GROUP BY

        C.State
)

SELECT

    DENSE_RANK()
        OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS RegionRank,

    State,

    TotalCustomers,

    TotalOrders,

    TotalRevenue,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS RevenueContributionPercentage,

    ROUND
    (
        SUM(TotalRevenue)
            OVER
            (
                ORDER BY TotalRevenue DESC
                ROWS UNBOUNDED PRECEDING
            )
        * 100.0
        /
        SUM(TotalRevenue) OVER(),
        2
    ) AS CumulativeRevenueContributionPercentage

FROM RegionalRevenue

ORDER BY

    TotalRevenue DESC,
    State;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 099 : Revenue Contribution by Region Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 100 : Customer Geographic Summary
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall geographic distribution of customers and revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Geographic Summary provides an executive overview of the business's
geographical presence.

This KPI helps management:

• Understand Geographic Coverage
• Measure Market Reach
• Identify Top Performing Locations
• Support Expansion Planning
• Monitor Regional Distribution

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Countries
• Total States
• Total Cities
• Total Customers
• Total Revenue
• Highest Revenue Country
• Highest Revenue State
• Highest Revenue City
• Average Customers per State
• Average Customers per City

------------------------------------------------------------------------------
*/

WITH CountryRevenue AS
(
    SELECT
        Country,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        Country
),
StateRevenue AS
(
    SELECT
        State,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        State
),
CityRevenue AS
(
    SELECT
        City,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        City
)
SELECT
    (SELECT COUNT(DISTINCT Country)
     FROM dbo.Customer) AS TotalCountries,
    (SELECT COUNT(DISTINCT State)
     FROM dbo.Customer) AS TotalStates,
    (SELECT COUNT(DISTINCT City)
     FROM dbo.Customer) AS TotalCities,
    (SELECT COUNT(*)
     FROM dbo.Customer) AS TotalCustomers,
    (SELECT SUM(LineTotal)
     FROM dbo.OrderItem) AS TotalRevenue,
    (SELECT TOP (1) Country
     FROM CountryRevenue
     ORDER BY TotalRevenue DESC) AS HighestRevenueCountry,
    (SELECT TOP (1) State
     FROM StateRevenue
     ORDER BY TotalRevenue DESC) AS HighestRevenueState,
    (SELECT TOP (1) City
     FROM CityRevenue
     ORDER BY TotalRevenue DESC) AS HighestRevenueCity,
    ROUND(CAST((SELECT COUNT(*) FROM dbo.Customer) AS DECIMAL(18,2)) / NULLIF ((SELECT COUNT(DISTINCT State) FROM dbo.Customer),0),2) AS AverageCustomersPerState,
    ROUND(CAST((SELECT COUNT(*) FROM dbo.Customer) AS DECIMAL(18,2)) / NULLIF ((SELECT COUNT(DISTINCT City) FROM dbo.Customer),0),2) AS AverageCustomersPerCity;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 100 : Customer Geographic Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 101 : Customer Segmentation by Spending
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers distributed across spending segments?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer segmentation helps businesses understand customer purchasing
behavior and create targeted marketing campaigns.

This KPI supports:

• Customer Segmentation
• Loyalty Programs
• Personalized Marketing
• Customer Value Analysis
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

Customers are classified into spending segments:

• Platinum  (>= 50,000)
• Gold      (25,000 - 49,999)
• Silver    (10,000 - 24,999)
• Bronze    (<10,000)

------------------------------------------------------------------------------
*/

WITH CustomerRevenue AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    CustomerSegment,
    COUNT(*) AS TotalCustomers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS CustomerPercentage
FROM
(
    SELECT
        CASE
            WHEN TotalRevenue >= 5000000 THEN 'Platinum'
            WHEN TotalRevenue >= 2500000 THEN 'Gold'
            WHEN TotalRevenue >= 1000000 THEN 'Silver'
            ELSE 'Bronze'
        END AS CustomerSegment
    FROM CustomerRevenue
) Segmentation
GROUP BY
    CustomerSegment
ORDER BY
    CASE CustomerSegment
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
        WHEN 'Bronze' THEN 4
    END;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 101 : Customer Segmentation by Spending Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 102 : Customer Segmentation by Purchase Frequency
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers distributed based on the number of orders placed?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Purchase frequency is one of the strongest indicators of customer loyalty.

Segmenting customers based on purchase frequency helps businesses:

• Identify Loyal Customers
• Measure Customer Engagement
• Improve Retention Strategies
• Design Loyalty Programs
• Target Marketing Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

Customers are classified into purchase frequency segments:

• Very Frequent (10+ Orders)
• Frequent (5–9 Orders)
• Occasional (2–4 Orders)
• One-Time (1 Order)

------------------------------------------------------------------------------
*/

WITH CustomerOrders AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        COUNT(DISTINCT O.OrderID) AS TotalOrders
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    PurchaseFrequencySegment,
    COUNT(*) AS TotalCustomers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS CustomerPercentage
FROM
(
    SELECT
        CASE
            WHEN TotalOrders >= 10 THEN 'Very Frequent'
            WHEN TotalOrders >= 5 THEN 'Frequent'
            WHEN TotalOrders >= 2 THEN 'Occasional'
            ELSE 'One-Time'
        END AS PurchaseFrequencySegment
    FROM CustomerOrders
) FrequencySegments
GROUP BY
    PurchaseFrequencySegment
ORDER BY
    CASE PurchaseFrequencySegment
        WHEN 'Very Frequent' THEN 1
        WHEN 'Frequent' THEN 2
        WHEN 'Occasional' THEN 3
        WHEN 'One-Time' THEN 4
    END;

PRINT '';

PRINT '=====================================================================';
PRINT 'KPI 102 : Customer Segmentation by Purchase Frequency Generated Successfully';
PRINT '=====================================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 103 : Customer Segmentation by Loyalty Points
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers distributed based on their loyalty points?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Loyalty points represent customer engagement and long-term relationship
with the business.

Segmenting customers based on loyalty points helps:

• Identify VIP Customers
• Design Reward Programs
• Increase Customer Retention
• Improve Personalized Marketing
• Enhance Customer Experience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

Customers are classified into loyalty segments:

• Platinum
• Gold
• Silver
• Bronze

------------------------------------------------------------------------------
*/

SELECT
    LoyaltySegment,
    COUNT(*) AS TotalCustomers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS CustomerPercentage,
    MIN(LoyaltyPoints) AS MinimumPoints,
    MAX(LoyaltyPoints) AS MaximumPoints,
    AVG(LoyaltyPoints) AS AveragePoints
FROM
(
    SELECT
        CustomerID,
        LoyaltyPoints,
        CASE
            WHEN LoyaltyPoints >= 3000 THEN 'Platinum'
            WHEN LoyaltyPoints >= 2000 THEN 'Gold'
            WHEN LoyaltyPoints >= 900 THEN 'Silver'
            ELSE 'Bronze'
        END AS LoyaltySegment
    FROM dbo.Customer
) AS CustomerSegmentation
GROUP BY
    LoyaltySegment
ORDER BY
    CASE LoyaltySegment
        WHEN 'Platinum' THEN 1
        WHEN 'Gold' THEN 2
        WHEN 'Silver' THEN 3
        WHEN 'Bronze' THEN 4
    END;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 103 : Customer Segmentation by Loyalty Points Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 104 : Customer Segmentation by Purchase Recency
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are customers segmented based on how recently they made a purchase?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Purchase recency is a key indicator of customer engagement.

Segmenting customers by recency helps businesses:

• Identify Active Customers
• Detect At-Risk Customers
• Launch Re-engagement Campaigns
• Improve Customer Retention
• Support CRM Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

Customers are classified into recency segments:

• Active (0–30 Days)
• Warm (31–90 Days)
• Cold (91–180 Days)
• Inactive (>180 Days)

------------------------------------------------------------------------------
*/

WITH CustomerRecency AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        MAX(O.OrderDate) AS LastPurchaseDate,
        DATEDIFF(DAY,MAX(O.OrderDate),GETDATE()) AS DaysSinceLastPurchase
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    RecencySegment,
    COUNT(*) AS TotalCustomers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(),2) AS CustomerPercentage,
    MIN(DaysSinceLastPurchase) AS MinimumDays,
    MAX(DaysSinceLastPurchase) AS MaximumDays,
    AVG(DaysSinceLastPurchase) AS AverageDays
FROM
(
    SELECT
        DaysSinceLastPurchase,
        CASE
            WHEN DaysSinceLastPurchase <= 30 THEN 'Active'
            WHEN DaysSinceLastPurchase <= 90
                THEN 'Warm'
            WHEN DaysSinceLastPurchase <= 180
                THEN 'Cold'
            ELSE 'Inactive'
        END AS RecencySegment
    FROM CustomerRecency
) AS CustomerSegmentation
GROUP BY
    RecencySegment
ORDER BY
    CASE RecencySegment
        WHEN 'Active' THEN 1
        WHEN 'Warm' THEN 2
        WHEN 'Cold' THEN 3
        WHEN 'Inactive' THEN 4
    END;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 104 : Customer Segmentation by Purchase Recency Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO

/*------------------------------------------------------------------------------
KPI 105 : Customer Insights Summary
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall customer insight summary for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Insights Summary provides a high-level overview of customer
behavior, engagement, loyalty, and revenue.

This KPI supports:

• Executive Reporting
• Customer Health Monitoring
• Customer Lifetime Value Analysis
• Customer Retention Strategy
• Business Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Active Customers
• Customers with Orders
• Repeat Customers
• One-Time Customers
• Average Revenue per Customer
• Average Orders per Customer
• Average Loyalty Points
• Average Customer Lifetime Value
• Average Days Since Last Purchase

------------------------------------------------------------------------------
*/

WITH LatestOrderDate AS
(
    SELECT
        MAX(OrderDate) AS MaxOrderDate
    FROM dbo.[Order]
),
CustomerSummary AS
(
    SELECT
        C.CustomerID,
        C.IsActive,
        C.LoyaltyPoints,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        ISNULL(SUM(OI.LineTotal),0) AS TotalRevenue,
        MAX(O.OrderDate) AS LastPurchaseDate
    FROM dbo.Customer C
    LEFT JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    LEFT JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.IsActive,
        C.LoyaltyPoints
)
SELECT
    COUNT(*) AS TotalCustomers,
    SUM(
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,
    SUM(
        CASE
            WHEN TotalOrders > 0 THEN 1
            ELSE 0
        END
    ) AS CustomersWithOrders,
    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,
    SUM(
        CASE
            WHEN TotalOrders = 1 THEN 1
            ELSE 0
        END
    ) AS OneTimeCustomers,
    ROUND(AVG(TotalRevenue),2) AS AverageRevenuePerCustomer,
    ROUND(AVG(CAST(TotalOrders AS DECIMAL(18,2))),2) AS AverageOrdersPerCustomer,
    ROUND(AVG(CAST(LoyaltyPoints AS DECIMAL(18,2))),2) AS AverageLoyaltyPoints,
    ROUND(SUM(TotalRevenue) * 1.0 / COUNT(*),2) AS AverageCustomerLifetimeValue,
    ROUND(AVG(CAST(DATEDIFF(DAY,LastPurchaseDate,LOD.MaxOrderDate) AS DECIMAL(18,2))),2) AS AverageDaysSinceLastPurchase
FROM CustomerSummary CS
CROSS JOIN LatestOrderDate LOD;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 105 : Customer Insights Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

GO