/*------------------------------------------------------------------------------
KPI 106 : Customer Purchase Frequency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How frequently does each customer place orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Purchase Frequency measures how often customers make purchases.

It helps management:

• Identify loyal customers
• Understand buying behavior
• Improve customer retention
• Design targeted marketing campaigns
• Support customer segmentation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• First Purchase Date
• Latest Purchase Date
• Purchase Frequency (Orders)

Customers are ranked by total number of orders placed.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
    MIN(O.OrderDate) AS FirstPurchaseDate,
    MAX(O.OrderDate) AS LatestPurchaseDate
FROM dbo.Customer C
INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID,
    C.FirstName,
    C.LastName
ORDER BY
    TotalOrders DESC,
    LatestPurchaseDate DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 106 : Customer Purchase Frequency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 107 : Average Days Between Purchases
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many days, on average, does a customer take to place the next order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Purchase Interval helps understand customer buying habits.

A shorter interval indicates highly engaged customers, while a longer
interval may signal declining engagement or churn risk.

This KPI helps management:

• Measure customer engagement
• Identify loyal customers
• Predict future purchases
• Support churn analysis
• Improve marketing campaign timing

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• First Purchase Date
• Latest Purchase Date
• Customer Lifetime (Days)
• Average Days Between Purchases

Formula

Average Days Between Purchases =
Customer Lifetime Days / (Total Orders - 1)

------------------------------------------------------------------------------*/

WITH CustomerOrders AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        COUNT(O.OrderID) AS TotalOrders,
        MIN(O.OrderDate) AS FirstPurchaseDate,
        MAX(O.OrderDate) AS LatestPurchaseDate,
        DATEDIFF(DAY,MIN(O.OrderDate),MAX(O.OrderDate)) AS CustomerLifetimeDays
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    DENSE_RANK() OVER(ORDER BY ROUND(CustomerLifetimeDays * 1.0 / NULLIF(TotalOrders - 1,0),2)) AS CustomerRank,
    CustomerID,
    CustomerName,
    TotalOrders,
    FirstPurchaseDate,
    LatestPurchaseDate,
    CustomerLifetimeDays,
    ROUND(CustomerLifetimeDays * 1.0 / NULLIF(TotalOrders - 1,0),2) AS AverageDaysBetweenPurchases
FROM CustomerOrders
WHERE TotalOrders > 1
ORDER BY
    AverageDaysBetweenPurchases,
    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 107 : Average Days Between Purchases Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 108 : Repeat Purchase Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of customers have made more than one purchase?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Repeat Purchase Rate measures customer loyalty and retention.

Customers who return to purchase again are more valuable than one-time
buyers because they generate recurring revenue and reduce customer
acquisition costs.

This KPI helps management:

• Measure Customer Loyalty
• Evaluate Customer Retention
• Improve Marketing Effectiveness
• Track Customer Engagement
• Support Customer Lifetime Value Analysis

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• One-Time Customers
• Repeat Customers
• Repeat Purchase Rate (%)

Formula

Repeat Purchase Rate (%) =
(Repeat Customers / Total Customers) × 100

------------------------------------------------------------------------------*/

WITH CustomerPurchaseSummary AS
(
    SELECT
        O.CustomerID,
        COUNT(O.OrderID) AS TotalOrders
    FROM dbo.[Order] O
    GROUP BY
        O.CustomerID
)
SELECT
    COUNT(*) AS TotalCustomers,
    SUM(
        CASE
            WHEN TotalOrders = 1 THEN 1
            ELSE 0
        END
    ) AS OneTimeCustomers,
    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,
    ROUND(SUM(
            CASE
                WHEN TotalOrders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 /COUNT(*),2) AS RepeatPurchaseRatePercentage
FROM CustomerPurchaseSummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 108 : Repeat Purchase Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 109 : One-Time vs Repeat Customers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers are one-time buyers and which are repeat customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Classifying customers based on purchasing behavior helps businesses
identify loyal customers and customers who require retention efforts.

This KPI helps management:

• Identify Repeat Customers
• Identify One-Time Buyers
• Improve Customer Retention
• Support Loyalty Programs
• Build Targeted Marketing Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• First Purchase Date
• Latest Purchase Date
• Customer Type

Customer Type Rules

Total Orders = 1  → One-Time Customer
Total Orders > 1  → Repeat Customer

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(O.NetAmount) AS TotalRevenue,
    MIN(O.OrderDate) AS FirstPurchaseDate,
    MAX(O.OrderDate) AS LatestPurchaseDate,
    CASE
        WHEN COUNT(O.OrderID) = 1
            THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS CustomerType
FROM dbo.Customer C
INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID,
    C.FirstName,
    C.LastName
ORDER BY
    TotalOrders DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 109 : One-Time vs Repeat Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 110 : Customer Lifetime Orders
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have placed the highest number of orders during their
lifetime?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Lifetime Orders measure the long-term engagement of customers.

Customers with a higher number of lifetime orders are generally more
valuable and loyal.

This KPI helps management:

• Identify Loyal Customers
• Support Loyalty Programs
• Improve Customer Retention
• Build VIP Customer Lists
• Analyze Customer Engagement

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Lifetime Orders
• Total Revenue
• Average Order Value
• First Purchase Date
• Latest Purchase Date

Customers are ranked based on Total Lifetime Orders.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalLifetimeOrders,
    SUM(O.NetAmount) AS TotalRevenue,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue,
    MIN(O.OrderDate) AS FirstPurchaseDate,
    MAX(O.OrderDate) AS LatestPurchaseDate
FROM dbo.Customer C
INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID,
    C.FirstName,
    C.LastName
ORDER BY
    TotalLifetimeOrders DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 110 : Customer Lifetime Orders Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 111 : Customer Lifetime Revenue
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers generate the highest lifetime revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Lifetime Revenue measures the total revenue generated by each
customer throughout their relationship with the business.

High lifetime revenue customers contribute significantly to business
growth and profitability.

This KPI helps management:

• Identify High-Value Customers
• Prioritize Customer Retention
• Support VIP Customer Programs
• Improve Customer Segmentation
• Increase Customer Lifetime Value (CLV)

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Lifetime Revenue
• Average Order Value
• First Purchase Date
• Latest Purchase Date

Customers are ranked by Total Lifetime Revenue.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(O.NetAmount) AS TotalLifetimeRevenue,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue,
    MIN(O.OrderDate) AS FirstPurchaseDate,
    MAX(O.OrderDate) AS LatestPurchaseDate
FROM dbo.Customer C
INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID,
    C.FirstName,
    C.LastName
ORDER BY
    TotalLifetimeRevenue DESC,
    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 111 : Customer Lifetime Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 112 : Average Basket Size
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average number of items purchased per order by each customer?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Basket Size measures how many products customers typically
purchase in a single transaction.

A larger basket size often indicates successful cross-selling,
up-selling, and customer engagement.

This KPI helps management:

• Evaluate Cross-Selling Effectiveness
• Improve Product Bundling
• Optimize Promotions
• Increase Average Order Size
• Understand Customer Buying Behavior

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Items Purchased
• Average Basket Size

Formula

Average Basket Size =
Total Items Purchased / Total Orders

------------------------------------------------------------------------------
*/

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
        SUM(OI.Quantity) * 1.0 /
        NULLIF(COUNT(DISTINCT O.OrderID),0)
        DESC
    ) AS CustomerRank,

    C.CustomerID,

    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,

    COUNT(DISTINCT O.OrderID) AS TotalOrders,

    SUM(OI.Quantity) AS TotalItemsPurchased,

    ROUND
    (
        SUM(OI.Quantity) * 1.0
        /
        NULLIF(COUNT(DISTINCT O.OrderID),0),
        2
    ) AS AverageBasketSize

FROM dbo.Customer C

INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID

INNER JOIN dbo.OrderItem OI
    ON O.OrderID = OI.OrderID

GROUP BY

    C.CustomerID,
    C.FirstName,
    C.LastName

ORDER BY

    AverageBasketSize DESC,
    TotalItemsPurchased DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 112 : Average Basket Size Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 113 : Average Order Value by Customer
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers spend the highest average amount per order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Order Value (AOV) measures the average amount spent by a customer
every time they place an order.

Unlike Lifetime Revenue, AOV identifies customers who consistently place
high-value orders.

This KPI helps management:

• Identify Premium Customers
• Evaluate Customer Spending Behavior
• Optimize Pricing Strategy
• Improve Upselling Opportunities
• Support Customer Segmentation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• Average Order Value
• First Purchase Date
• Latest Purchase Date

Formula

Average Order Value =
Total Revenue / Total Orders

Customers are ranked by Average Order Value.

------------------------------------------------------------------------------
*/

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
            AVG(O.TotalAmount) DESC
    ) AS CustomerRank,

    C.CustomerID,

    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.TotalAmount) AS TotalRevenue,

    ROUND
    (
        AVG(O.TotalAmount),
        2
    ) AS AverageOrderValue,

    MIN(O.OrderDate) AS FirstPurchaseDate,

    MAX(O.OrderDate) AS LatestPurchaseDate

FROM dbo.Customer C

INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID

GROUP BY

    C.CustomerID,
    C.FirstName,
    C.LastName

ORDER BY

    AverageOrderValue DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 113 : Average Order Value by Customer Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 114 : Customer Purchase Recency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have purchased most recently, and which customers have
not purchased for a long time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Recency measures the number of days since the customer's latest
purchase.

Customers with recent purchases are generally more engaged, while customers
with long inactivity periods may require re-engagement campaigns.

This KPI helps management:

• Identify Active Customers
• Identify Dormant Customers
• Support Churn Analysis
• Improve Customer Retention
• Build Re-engagement Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Latest Purchase Date
• Days Since Last Purchase
• Recency Status

Business Rules

0–30 Days      → Highly Active
31–90 Days     → Active
91–180 Days    → Inactive
>180 Days      → Dormant

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY MAX(O.OrderDate) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    MAX(O.OrderDate) AS LatestPurchaseDate,
    DATEDIFF(DAY,MAX(O.OrderDate),GETDATE()) AS DaysSinceLastPurchase,
    CASE
        WHEN DATEDIFF(DAY, MAX(O.OrderDate), GETDATE()) <= 30 THEN 'Highly Active'
        WHEN DATEDIFF(DAY, MAX(O.OrderDate), GETDATE()) <= 90 THEN 'Active'
        WHEN DATEDIFF(DAY, MAX(O.OrderDate), GETDATE()) <= 180 THEN 'Inactive'
        ELSE 'Dormant'
    END AS RecencyStatus
FROM dbo.Customer C
INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID
GROUP BY
    C.CustomerID,
    C.FirstName,
    C.LastName
ORDER BY
    LatestPurchaseDate DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 114 : Customer Purchase Recency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 115 : Customer Monetary Value
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers generate the highest monetary value for the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Monetary Value measures the total amount spent by each customer.

This KPI represents the "Monetary" component of RFM Analysis and helps
identify customers who contribute the most revenue.

This KPI helps management:

• Identify High-Value Customers
• Build VIP Customer Programs
• Improve Customer Retention
• Increase Customer Lifetime Value (CLV)
• Support Customer Segmentation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• Average Order Value
• Monetary Value Tier

Business Rules

Revenue >= 100000      → Platinum
Revenue >= 50000       → Gold
Revenue >= 25000       → Silver
Otherwise              → Bronze

------------------------------------------------------------------------------
*/

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY SUM(O.TotalAmount) DESC
    ) AS CustomerRank,

    C.CustomerID,

    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.TotalAmount) AS TotalRevenue,

    ROUND
    (
        AVG(O.TotalAmount),
        2
    ) AS AverageOrderValue,

    CASE

        WHEN SUM(O.TotalAmount) >= 100000
            THEN 'Platinum'

        WHEN SUM(O.TotalAmount) >= 50000
            THEN 'Gold'

        WHEN SUM(O.TotalAmount) >= 25000
            THEN 'Silver'

        ELSE 'Bronze'

    END AS MonetaryValueTier

FROM dbo.Customer C

INNER JOIN dbo.[Order] O
    ON C.CustomerID = O.CustomerID

GROUP BY

    C.CustomerID,
    C.FirstName,
    C.LastName

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 115 : Customer Monetary Value Generated Successfully';
PRINT '==============================================================';

PRINT '';