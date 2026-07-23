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

/*------------------------------------------------------------------------------
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

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(OI.Quantity) * 1.0 / NULLIF(COUNT(DISTINCT O.OrderID),0)DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(DISTINCT O.OrderID) AS TotalOrders,
    SUM(OI.Quantity) AS TotalItemsPurchased,
    ROUND(SUM(OI.Quantity) * 1.0 / NULLIF(COUNT(DISTINCT O.OrderID),0),2) AS AverageBasketSize
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

/*------------------------------------------------------------------------------
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

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY AVG(O.NetAmount) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
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

/*------------------------------------------------------------------------------
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

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS CustomerRank,
    C.CustomerID,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(O.OrderID) AS TotalOrders,
    SUM(O.NetAmount) AS TotalRevenue,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue,
    CASE
        WHEN SUM(O.NetAmount) >= 100000 THEN 'Platinum'
        WHEN SUM(O.NetAmount) >= 50000 THEN 'Gold'
        WHEN SUM(O.NetAmount) >= 25000 THEN 'Silver'
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

/*------------------------------------------------------------------------------
KPI 116 : RFM Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can customers be scored based on Recency, Frequency, and Monetary
(RFM) values to understand customer value and engagement?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

RFM Analysis is one of the most widely used customer segmentation
techniques in Retail, Banking, E-commerce, CRM, and Marketing.

It measures:

R → Recency
F → Frequency
M → Monetary

Customers with:

• Recent Purchases
• High Purchase Frequency
• High Spending

are considered the most valuable customers.

This KPI helps management:

• Build Loyalty Programs
• Identify VIP Customers
• Predict Customer Churn
• Improve Customer Retention
• Personalize Marketing Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer ID
• Customer Name
• Recency (Days)
• Frequency (Orders)
• Monetary (Revenue)

Then assigns:

• R Score (1-5)
• F Score (1-5)
• M Score (1-5)

using NTILE(5).

Finally generates

• RFM Score
• Overall Customer Ranking

------------------------------------------------------------------------------*/

WITH CustomerMetrics AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName, ' ',C.LastName) AS CustomerName,
        DATEDIFF(DAY,MAX(O.OrderDate),GETDATE()) AS Recency,
        COUNT(O.OrderID) AS Frequency,
        SUM(O.NetAmount) AS Monetary
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
),
RFMScore AS
(
    SELECT
        *,
        NTILE(5) OVER(
ORDER BY Recency ASC
        ) AS RScore,

        NTILE(5) OVER
        (
            ORDER BY Frequency DESC
        ) AS FScore,

        NTILE(5) OVER
        (
            ORDER BY Monetary DESC
        ) AS MScore

    FROM CustomerMetrics
)

SELECT

    CustomerID,

    CustomerName,

    Recency,

    Frequency,

    Monetary,

    RScore,

    FScore,

    MScore,

    CONCAT
    (
        RScore,
        FScore,
        MScore
    ) AS RFMScore,

    DENSE_RANK() OVER
    (
        ORDER BY

            (RScore + FScore + MScore) DESC,

            Monetary DESC
    ) AS CustomerRank

FROM RFMScore

ORDER BY

    CustomerRank;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 116 : RFM Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 117 : Customer Segmentation
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can customers be segmented based on their RFM Scores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Segmentation helps businesses personalize marketing strategies,
improve retention, and maximize customer lifetime value.

Using RFM scores, customers can be grouped into meaningful business
segments based on purchasing behavior.

This KPI helps management:

• Identify VIP Customers
• Target Marketing Campaigns
• Improve Customer Retention
• Increase Customer Lifetime Value
• Personalize Customer Experience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer ID
• Customer Name
• R Score
• F Score
• M Score
• RFM Score
• Customer Segment

Customer Segments

Champions
Loyal Customers
Potential Loyalists
Promising
Need Attention
At Risk
Lost Customers

------------------------------------------------------------------------------*/

WITH CustomerMetrics AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        DATEDIFF(DAY,MAX(O.OrderDate),GETDATE()) AS Recency,
        COUNT(O.OrderID) AS Frequency,
        SUM(O.NetAmount) AS Monetary
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
),
RFMScore AS
(
    SELECT
        *,
        6 - NTILE(5) OVER (ORDER BY Recency ASC) AS RScore,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS FScore,
        NTILE(5) OVER (ORDER BY Monetary DESC) AS MScore
    FROM CustomerMetrics
)

SELECT

    CustomerID,

    CustomerName,

    Recency,

    Frequency,

    Monetary,

    RScore,

    FScore,

    MScore,

    CONCAT(RScore,FScore,MScore) AS RFMScore,

    CASE

        WHEN RScore >= 4
         AND FScore >= 4
         AND MScore >= 4
            THEN 'Champions'

        WHEN RScore >= 3
         AND FScore >= 4
            THEN 'Loyal Customers'

        WHEN RScore >= 4
         AND FScore >= 2
            THEN 'Potential Loyalists'

        WHEN RScore >= 3
         AND FScore <= 2
            THEN 'Promising'

        WHEN RScore = 2
         AND FScore >= 3
            THEN 'Need Attention'

        WHEN RScore <= 2
         AND FScore >= 3
            THEN 'At Risk'

        ELSE 'Lost Customers'

    END AS CustomerSegment

FROM RFMScore

ORDER BY

    CustomerSegment,
    Monetary DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 117 : Customer Segmentation Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 118 : Dormant Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have not made a purchase for a long period and are
considered dormant?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Dormant customers represent lost revenue opportunities.

Identifying these customers enables businesses to:

• Launch Re-engagement Campaigns
• Offer Personalized Promotions
• Reduce Customer Churn
• Increase Customer Lifetime Value
• Improve Marketing ROI

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• Latest Purchase Date
• Days Since Last Purchase
• Dormancy Status

Business Rule

Customers with more than 180 days since their last purchase are
considered Dormant.

------------------------------------------------------------------------------
*/

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
            DATEDIFF
            (
                DAY,
                MAX(O.OrderDate),
                GETDATE()
            ) DESC
    ) AS CustomerRank,

    C.CustomerID,

    CONCAT
    (
        C.FirstName,
        ' ',
        C.LastName
    ) AS CustomerName,

    COUNT(O.OrderID) AS TotalOrders,

    SUM(O.NetAmount) AS TotalRevenue,

    MAX(O.OrderDate) AS LatestPurchaseDate,

    DATEDIFF
    (
        DAY,
        MAX(O.OrderDate),
        GETDATE()
    ) AS DaysSinceLastPurchase,

    CASE

        WHEN DATEDIFF
             (
                DAY,
                MAX(O.OrderDate),
                GETDATE()
             ) > 180

            THEN 'Dormant'

        ELSE 'Active'

    END AS DormancyStatus

FROM dbo.Customer C

INNER JOIN dbo.[Order] O

    ON C.CustomerID = O.CustomerID

GROUP BY

    C.CustomerID,
    C.FirstName,
    C.LastName

HAVING

    DATEDIFF
    (
        DAY,
        MAX(O.OrderDate),
        GETDATE()
    ) > 180

ORDER BY

    DaysSinceLastPurchase DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 118 : Dormant Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 119 : Reactivated Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers returned to make another purchase after a long period of
inactivity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Reactivated customers indicate successful retention and re-engagement
efforts.

Identifying these customers helps businesses:

• Measure campaign effectiveness
• Improve customer retention
• Evaluate loyalty programs
• Understand customer buying cycles
• Increase Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Previous Purchase Date
• Latest Purchase Date
• Gap Between Purchases (Days)
• Reactivation Status

Business Rule

Gap Between Purchases > 180 Days
→ Reactivated Customer

------------------------------------------------------------------------------
*/

WITH CustomerPurchaseHistory
AS
(
    SELECT

        O.CustomerID,

        O.OrderID,

        O.OrderDate,

        LAG(O.OrderDate)
        OVER
        (
            PARTITION BY O.CustomerID
            ORDER BY O.OrderDate
        ) AS PreviousPurchaseDate

    FROM dbo.[Order] O
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
            DATEDIFF
            (
                DAY,
                PreviousPurchaseDate,
                OrderDate
            ) DESC
    ) AS CustomerRank,

    C.CustomerID,

    CONCAT
    (
        C.FirstName,
        ' ',
        C.LastName
    ) AS CustomerName,

    PreviousPurchaseDate,

    OrderDate AS LatestPurchaseDate,

    DATEDIFF
    (
        DAY,
        PreviousPurchaseDate,
        OrderDate
    ) AS GapBetweenPurchases,

    'Reactivated Customer' AS ReactivationStatus

FROM CustomerPurchaseHistory CPH

INNER JOIN dbo.Customer C

    ON CPH.CustomerID = C.CustomerID

WHERE

    PreviousPurchaseDate IS NOT NULL

    AND

    DATEDIFF
    (
        DAY,
        PreviousPurchaseDate,
        OrderDate
    ) > 180

ORDER BY

    GapBetweenPurchases DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 119 : Reactivated Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 120 : High-Value Loyal Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers are the most valuable and loyal based on their purchase
frequency, spending, and recent activity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

High-value loyal customers are the foundation of long-term business growth.

These customers:

• Purchase frequently
• Spend significantly
• Continue purchasing regularly

Retaining these customers is more profitable than acquiring new ones.

This KPI helps management:

• Identify VIP Customers
• Build Loyalty Programs
• Improve Customer Retention
• Launch Exclusive Promotions
• Increase Customer Lifetime Value

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
• Days Since Last Purchase
• Loyalty Status

Business Rules

VIP Customer

• Total Orders >= 10
• Revenue >= 100000
• Last Purchase <= 90 Days

Otherwise

Regular Customer

------------------------------------------------------------------------------
*/

WITH CustomerSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        AVG(O.NetAmount) AS AverageOrderValue,

        MAX(O.OrderDate) AS LatestPurchaseDate,

        DATEDIFF
        (
            DAY,
            MAX(O.OrderDate),
            GETDATE()
        ) AS DaysSinceLastPurchase

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY

            TotalRevenue DESC,

            TotalOrders DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    ROUND
    (
        AverageOrderValue,
        2
    ) AS AverageOrderValue,

    LatestPurchaseDate,

    DaysSinceLastPurchase,

    CASE

        WHEN

            TotalOrders >= 10

            AND

            TotalRevenue >= 100000

            AND

            DaysSinceLastPurchase <= 90

        THEN 'VIP Customer'

        ELSE 'Regular Customer'

    END AS LoyaltyStatus

FROM CustomerSummary

ORDER BY

    TotalRevenue DESC,

    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 120 : High-Value Loyal Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 121 : Customers at Risk of Churn
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers are likely to churn based on their purchase inactivity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer churn directly impacts business growth and profitability.

Customers who have not purchased recently but have a history of purchasing
should be identified early for retention campaigns.

This KPI helps management:

• Identify Churn Risk Customers
• Launch Retention Campaigns
• Improve Customer Lifetime Value
• Reduce Customer Attrition
• Support CRM Strategies

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• Latest Purchase Date
• Days Since Last Purchase
• Churn Risk Level

Business Rules

Days Since Last Purchase

0 - 90 Days      → Low Risk
91 - 180 Days    → Medium Risk
181 - 365 Days   → High Risk
>365 Days        → Very High Risk

------------------------------------------------------------------------------
*/

WITH CustomerSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        MAX(O.OrderDate) AS LatestPurchaseDate,

        DATEDIFF
        (
            DAY,
            MAX(O.OrderDate),
            GETDATE()
        ) AS DaysSinceLastPurchase

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY DaysSinceLastPurchase DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    LatestPurchaseDate,

    DaysSinceLastPurchase,

    CASE

        WHEN DaysSinceLastPurchase <= 90
            THEN 'Low Risk'

        WHEN DaysSinceLastPurchase <= 180
            THEN 'Medium Risk'

        WHEN DaysSinceLastPurchase <= 365
            THEN 'High Risk'

        ELSE 'Very High Risk'

    END AS ChurnRiskLevel

FROM CustomerSummary

ORDER BY

    DaysSinceLastPurchase DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 121 : Customers at Risk of Churn Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 122 : Customer Churn Risk Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have the highest probability of churning based on their
purchase behavior?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Churn Risk Score combines Recency, Frequency, and Monetary (RFM)
metrics into a single weighted score to identify customers most likely to
stop purchasing.

This KPI helps management:

• Predict Customer Churn
• Prioritize Retention Campaigns
• Improve Customer Lifetime Value
• Optimize Marketing Spend
• Support CRM Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Recency
• Frequency
• Monetary
• Churn Risk Score (0-100)
• Churn Risk Level

Weightage

Recency   : 50%
Frequency : 30%
Monetary  : 20%

------------------------------------------------------------------------------
*/

WITH CustomerMetrics
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        DATEDIFF
        (
            DAY,
            MAX(O.OrderDate),
            GETDATE()
        ) AS Recency,

        COUNT(O.OrderID) AS Frequency,

        SUM(O.NetAmount) AS Monetary

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
),

RFMScore
AS
(
    SELECT

        *,

        NTILE(5) OVER
        (
            ORDER BY Recency DESC
        ) AS RScore,

        NTILE(5) OVER
        (
            ORDER BY Frequency ASC
        ) AS FScore,

        NTILE(5) OVER
        (
            ORDER BY Monetary ASC
        ) AS MScore

    FROM CustomerMetrics
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY

            (
                (RScore * 0.50)
              + (FScore * 0.30)
              + (MScore * 0.20)
            ) DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    Recency,

    Frequency,

    Monetary,

    ROUND
    (
        (
            (
                (RScore * 0.50)
              + (FScore * 0.30)
              + (MScore * 0.20)
            ) / 5.0
        ) * 100,
        2
    ) AS ChurnRiskScore,

    CASE

        WHEN
        (
            (
                (RScore * 0.50)
              + (FScore * 0.30)
              + (MScore * 0.20)
            ) / 5.0
        ) * 100 >= 80

            THEN 'Very High Risk'

        WHEN
        (
            (
                (RScore * 0.50)
              + (FScore * 0.30)
              + (MScore * 0.20)
            ) / 5.0
        ) * 100 >= 60

            THEN 'High Risk'

        WHEN
        (
            (
                (RScore * 0.50)
              + (FScore * 0.30)
              + (MScore * 0.20)
            ) / 5.0
        ) * 100 >= 40

            THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS ChurnRiskLevel

FROM RFMScore

ORDER BY

    ChurnRiskScore DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 122 : Customer Churn Risk Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 123 : Preferred Payment Method by Customer
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the most frequently used payment method for each customer?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer payment preferences helps businesses optimize
payment experiences, personalize promotions, and improve checkout
conversion rates.

This KPI helps management:

• Identify Customer Payment Preferences
• Optimize Payment Channels
• Improve Customer Experience
• Design Payment-Based Promotions
• Support Digital Payment Strategies

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Preferred Payment Method
• Total Transactions
• Total Amount Paid

The preferred payment method is determined by the highest number of
transactions. If multiple methods have the same count, the one with the
higher payment amount is selected.

------------------------------------------------------------------------------
*/

WITH PaymentSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        PM.MethodName,

        COUNT(P.PaymentID) AS TotalTransactions,

        SUM(P.Amount) AS TotalAmountPaid,

        ROW_NUMBER() OVER
        (
            PARTITION BY C.CustomerID
            ORDER BY

                COUNT(P.PaymentID) DESC,

                SUM(P.Amount) DESC
        ) AS RN

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.Payment P

        ON O.OrderID = P.OrderID

    INNER JOIN dbo.PaymentMethod PM

        ON P.PaymentMethodID = PM.PaymentMethodID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName,

        PM.MethodName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY TotalAmountPaid DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    MethodName AS PreferredPaymentMethod,

    TotalTransactions,

    TotalAmountPaid

FROM PaymentSummary

WHERE RN = 1

ORDER BY

    TotalAmountPaid DESC,

    TotalTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 123 : Preferred Payment Method by Customer Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 124 : Preferred Shopping Day
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

On which day of the week does each customer shop most frequently?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer shopping day preferences helps businesses optimize
marketing campaigns, staffing, promotions, and inventory planning.

This KPI helps management:

• Identify Customer Shopping Patterns
• Optimize Weekend Promotions
• Improve Workforce Planning
• Increase Marketing Effectiveness
• Support Seasonal Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Customer Rank
• Customer ID
• Customer Name
• Preferred Shopping Day
• Total Orders
• Total Revenue

The preferred shopping day is determined by:

• Highest Number of Orders
• Highest Revenue (used as a tie-breaker)

Each customer appears only once with their preferred shopping day.

------------------------------------------------------------------------------
*/

WITH ShoppingDaySummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        DATENAME(WEEKDAY, O.OrderDate) AS ShoppingDay,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY C.CustomerID
            ORDER BY

                COUNT(O.OrderID) DESC,

                SUM(O.NetAmount) DESC
        ) AS RN

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName,

        DATENAME(WEEKDAY, O.OrderDate)
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY TotalRevenue DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    ShoppingDay AS PreferredShoppingDay,

    TotalOrders,

    TotalRevenue

FROM ShoppingDaySummary

WHERE RN = 1

ORDER BY

    TotalRevenue DESC,

    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 124 : Preferred Shopping Day Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 125 : Preferred Shopping Month
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

During which month does each customer make the most purchases?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer shopping month preferences helps businesses
identify seasonal purchasing behavior and optimize promotional campaigns.

This KPI helps management:

• Identify Seasonal Customers
• Plan Monthly Promotions
• Forecast Demand
• Improve Inventory Planning
• Support Personalized Marketing Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Customer Rank
• Customer ID
• Customer Name
• Preferred Shopping Month
• Total Orders
• Total Revenue

The preferred shopping month is determined by:

• Highest Number of Orders
• Highest Revenue (used as a tie-breaker)

Each customer appears only once with their preferred shopping month.

------------------------------------------------------------------------------
*/

WITH ShoppingMonthSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        DATENAME(MONTH, O.OrderDate) AS ShoppingMonth,

        MONTH(O.OrderDate) AS MonthNumber,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY C.CustomerID
            ORDER BY

                COUNT(O.OrderID) DESC,

                SUM(O.NetAmount) DESC,

                MONTH(O.OrderDate)
        ) AS RN

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName,

        DATENAME(MONTH, O.OrderDate),

        MONTH(O.OrderDate)
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY TotalRevenue DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    ShoppingMonth AS PreferredShoppingMonth,

    TotalOrders,

    TotalRevenue

FROM ShoppingMonthSummary

WHERE RN = 1

ORDER BY

    TotalRevenue DESC,

    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 125 : Preferred Shopping Month Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 126 : Customer Buying Pattern
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the purchasing behavior of each customer based on their average
order value?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer buying patterns helps businesses classify customers
based on spending habits.

This KPI helps management:

• Identify High-Spending Customers
• Personalize Marketing Campaigns
• Improve Customer Segmentation
• Optimize Pricing Strategies
• Increase Customer Lifetime Value

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
• Buying Pattern

Buying Pattern Classification

• High Value Buyer
• Medium Value Buyer
• Low Value Buyer

------------------------------------------------------------------------------
*/

WITH CustomerPurchaseSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        ROUND
        (
            AVG(O.NetAmount),
            2
        ) AS AverageOrderValue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY AverageOrderValue DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    AverageOrderValue,

    CASE

        WHEN AverageOrderValue >= 10000
            THEN 'High Value Buyer'

        WHEN AverageOrderValue >= 5000
            THEN 'Medium Value Buyer'

        ELSE 'Low Value Buyer'

    END AS BuyingPattern

FROM CustomerPurchaseSummary

ORDER BY

    AverageOrderValue DESC,
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 126 : Customer Buying Pattern Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 127 : Cross-Category Buyers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers purchase products from multiple product categories?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customers who purchase across multiple categories are generally more
engaged and valuable to the business.

Identifying Cross-Category Buyers helps management:

• Improve Cross-Selling Opportunities
• Design Product Bundles
• Increase Average Order Value
• Improve Recommendation Systems
• Increase Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Distinct Categories Purchased
• Total Orders
• Total Revenue
• Customer Type

Business Rules

1 Category      → Single Category Buyer
2-3 Categories  → Cross-Category Buyer
4+ Categories   → Multi-Category Buyer

------------------------------------------------------------------------------
*/

WITH CustomerCategorySummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(DISTINCT CAT.CategoryID) AS CategoriesPurchased,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem OI

        ON O.OrderID = OI.OrderID

    INNER JOIN dbo.Product P

        ON OI.ProductID = P.ProductID

    INNER JOIN dbo.SubCategory SC

        ON P.SubCategoryID = SC.SubCategoryID

    INNER JOIN dbo.Category CAT

        ON SC.CategoryID = CAT.CategoryID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY

            CategoriesPurchased DESC,

            TotalRevenue DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    CategoriesPurchased,

    TotalOrders,

    TotalRevenue,

    CASE

        WHEN CategoriesPurchased = 1

            THEN 'Single Category Buyer'

        WHEN CategoriesPurchased BETWEEN 2 AND 3

            THEN 'Cross-Category Buyer'

        ELSE 'Multi-Category Buyer'

    END AS CustomerType

FROM CustomerCategorySummary

ORDER BY

    CategoriesPurchased DESC,

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 127 : Cross-Category Buyers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 128 : Premium Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers qualify as Premium Customers based on their purchasing
behavior?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Premium customers contribute significantly to business revenue and are
more likely to make repeat purchases.

Identifying Premium Customers helps management:

• Build VIP Membership Programs
• Launch Exclusive Offers
• Improve Customer Retention
• Increase Customer Lifetime Value
• Reward Loyal Customers

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
• Days Since Last Purchase
• Premium Status

Business Rules

Premium Customer

• Revenue >= 100,000
• Orders >= 10
• Average Order Value >= 5,000
• Last Purchase <= 90 Days

Otherwise

Regular Customer

------------------------------------------------------------------------------
*/

WITH CustomerSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        ROUND
        (
            AVG(O.NetAmount),
            2
        ) AS AverageOrderValue,

        MAX(O.OrderDate) AS LatestPurchaseDate,

        DATEDIFF
        (
            DAY,
            MAX(O.OrderDate),
            GETDATE()
        ) AS DaysSinceLastPurchase

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY

            TotalRevenue DESC,

            TotalOrders DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    AverageOrderValue,

    LatestPurchaseDate,

    DaysSinceLastPurchase,

    CASE

        WHEN

            TotalRevenue >= 100000

            AND TotalOrders >= 10

            AND AverageOrderValue >= 5000

            AND DaysSinceLastPurchase <= 90

            THEN 'Premium Customer'

        ELSE 'Regular Customer'

    END AS PremiumStatus

FROM CustomerSummary

ORDER BY

    TotalRevenue DESC,

    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 128 : Premium Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 129 : Discount-Oriented Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers primarily purchase discounted products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding discount-oriented customers helps businesses evaluate
promotion effectiveness and identify price-sensitive customer segments.

This KPI helps management:

• Measure Promotion Effectiveness
• Identify Price-Sensitive Customers
• Optimize Discount Strategies
• Improve Marketing Campaigns
• Increase Profitability

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Discounted Orders
• Discount Usage Percentage
• Total Discount Received
• Customer Type

Business Rules

Discount Usage

>= 70%  → Highly Discount-Oriented
40–69%  → Moderate Discount-Oriented
< 40%   → Regular Buyer

------------------------------------------------------------------------------
*/

WITH CustomerDiscountSummary
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        COUNT
        (
            CASE
                WHEN OI.DiscountAmount > 0
                THEN 1
            END
        ) AS DiscountedOrders,

        SUM(OI.DiscountAmount) AS TotalDiscountReceived

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

    DENSE_RANK() OVER
    (
        ORDER BY
            TotalDiscountReceived DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    DiscountedOrders,

    ROUND
    (
        DiscountedOrders * 100.0 / TotalOrders,
        2
    ) AS DiscountUsagePercentage,

    TotalDiscountReceived,

    CASE

        WHEN DiscountedOrders * 100.0 / TotalOrders >= 70

            THEN 'Highly Discount-Oriented'

        WHEN DiscountedOrders * 100.0 / TotalOrders >= 40

            THEN 'Moderate Discount-Oriented'

        ELSE 'Regular Buyer'

    END AS CustomerType

FROM CustomerDiscountSummary

ORDER BY

    DiscountUsagePercentage DESC,

    TotalDiscountReceived DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 129 : Discount-Oriented Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 130 : Seasonal Customers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers exhibit seasonal purchasing behavior?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Seasonal customers tend to purchase during specific periods of the year,
such as festivals, holidays, or seasonal sales.

Understanding seasonal buying behavior helps businesses:

• Improve Seasonal Marketing Campaigns
• Optimize Inventory Planning
• Forecast Seasonal Demand
• Increase Customer Engagement
• Personalize Promotional Offers

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Preferred Season
• Total Orders
• Total Revenue
• Seasonal Purchase Percentage
• Customer Type

Business Rules

>= 70% Orders in One Season → Highly Seasonal
40–69% Orders              → Moderately Seasonal
< 40% Orders               → Regular Customer

Season Mapping

Winter : Dec, Jan, Feb
Spring : Mar, Apr, May
Summer : Jun, Jul, Aug
Autumn : Sep, Oct, Nov

------------------------------------------------------------------------------
*/

WITH SeasonalOrders
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        CASE

            WHEN MONTH(O.OrderDate) IN (12,1,2)
                THEN 'Winter'

            WHEN MONTH(O.OrderDate) IN (3,4,5)
                THEN 'Spring'

            WHEN MONTH(O.OrderDate) IN (6,7,8)
                THEN 'Summer'

            ELSE 'Autumn'

        END AS Season,

        COUNT(O.OrderID) AS SeasonOrders,

        SUM(O.NetAmount) AS SeasonRevenue

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName,

        CASE

            WHEN MONTH(O.OrderDate) IN (12,1,2)
                THEN 'Winter'

            WHEN MONTH(O.OrderDate) IN (3,4,5)
                THEN 'Spring'

            WHEN MONTH(O.OrderDate) IN (6,7,8)
                THEN 'Summer'

            ELSE 'Autumn'

        END
),

SeasonRanking
AS
(
    SELECT

        *,

        SUM(SeasonOrders)
        OVER
        (
            PARTITION BY CustomerID
        ) AS TotalOrders,

        ROW_NUMBER()
        OVER
        (
            PARTITION BY CustomerID
            ORDER BY

                SeasonOrders DESC,

                SeasonRevenue DESC
        ) AS RN

    FROM SeasonalOrders
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY SeasonRevenue DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    Season AS PreferredSeason,

    SeasonOrders,

    TotalOrders,

    SeasonRevenue,

    ROUND
    (
        SeasonOrders * 100.0 / TotalOrders,
        2
    ) AS SeasonalPurchasePercentage,

    CASE

        WHEN SeasonOrders * 100.0 / TotalOrders >= 70

            THEN 'Highly Seasonal'

        WHEN SeasonOrders * 100.0 / TotalOrders >= 40

            THEN 'Moderately Seasonal'

        ELSE 'Regular Customer'

    END AS CustomerType

FROM SeasonRanking

WHERE RN = 1

ORDER BY

    SeasonalPurchasePercentage DESC,

    SeasonRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 130 : Seasonal Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 131 : Weekend vs Weekday Buyers
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Do customers primarily shop on weekdays or weekends?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer shopping preferences between weekdays and weekends
helps businesses optimize staffing, promotional campaigns, and inventory
allocation.

This KPI helps management:

• Optimize Workforce Planning
• Improve Weekend Promotions
• Schedule Marketing Campaigns
• Forecast Peak Shopping Periods
• Improve Store Operations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Weekday Orders
• Weekend Orders
• Total Orders
• Weekend Shopping Percentage
• Shopping Preference

Business Rules

Weekend Orders > Weekday Orders
    → Weekend Buyer

Otherwise
    → Weekday Buyer

Weekend

• Saturday
• Sunday

Weekday

• Monday
• Tuesday
• Wednesday
• Thursday
• Friday

------------------------------------------------------------------------------
*/

WITH CustomerShoppingPattern AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        SUM(
            CASE
                WHEN DATENAME(WEEKDAY, O.OrderDate) IN ('Saturday','Sunday') THEN 1
                ELSE 0
            END
        ) AS WeekendOrders,
        SUM(
            CASE
                WHEN DATENAME(WEEKDAY, O.OrderDate) NOT IN ('Saturday','Sunday') THEN 1
                ELSE 0
            END
        ) AS WeekdayOrders,
        COUNT(O.OrderID) AS TotalOrders
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalOrders DESC) AS CustomerRank,
    CustomerID,
    CustomerName,
    WeekdayOrders,
    WeekendOrders,
    TotalOrders,
    ROUND(WeekendOrders * 100.0 / TotalOrders,2) AS WeekendShoppingPercentage,
    CASE
        WHEN WeekendOrders > WeekdayOrders THEN 'Weekend Buyer'
        ELSE 'Weekday Buyer'
    END AS ShoppingPreference
FROM CustomerShoppingPattern
ORDER BY
    WeekendShoppingPercentage DESC,
    TotalOrders DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 131 : Weekend vs Weekday Buyers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 132 : Customer Return Behavior
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers return products most frequently?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer return behavior helps businesses identify customers
with unusually high return rates, improve product quality, optimize return
policies, and reduce operational costs.

This KPI helps management:

• Identify Frequent Return Customers
• Improve Product Quality
• Detect Return Abuse
• Optimize Return Policies
• Improve Customer Satisfaction

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Rank
• Customer ID
• Customer Name
• Total Orders
• Total Returned Items
• Total Refund Amount
• Return Rate (%)
• Return Behavior

Business Rules

Return Rate

>= 30%  → Frequent Return Customer
10–29%  → Moderate Return Customer
< 10%   → Low Return Customer

------------------------------------------------------------------------------
*/

WITH CustomerReturnSummary AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        COUNT(DISTINCT O.OrderID) AS TotalOrders,
        ISNULL(SUM(R.QuantityReturned),0) AS TotalReturnedItems,
        ISNULL(SUM(R.RefundAmount),0) AS TotalRefundAmount
    FROM dbo.Customer C
    INNER JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem OI
        ON O.OrderID = OI.OrderID
    LEFT JOIN dbo.[Return] R
        ON OI.OrderItemID = R.OrderItemID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalRefundAmount DESC) AS CustomerRank,
    CustomerID,
    CustomerName,
    TotalOrders,
    TotalReturnedItems,
    TotalRefundAmount,
    ROUND(TotalReturnedItems * 100.0 / NULLIF(TotalOrders,0),2) AS ReturnRate,
    CASE
        WHEN
            TotalReturnedItems * 100.0 / NULLIF(TotalOrders,0) >= 30 THEN 'Frequent Return Customer'
        WHEN
            TotalReturnedItems * 100.0 / NULLIF(TotalOrders,0) >= 10 THEN 'Moderate Return Customer'
        ELSE 'Low Return Customer'
    END AS ReturnBehavior
FROM CustomerReturnSummary
ORDER BY
    ReturnRate DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 132 : Customer Return Behavior Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 133 : Customer Loyalty Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can customers be assigned a loyalty score based on their purchasing
behavior?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

A Customer Loyalty Score helps businesses identify customers who
consistently purchase, spend more, and remain actively engaged.

This KPI helps management:

• Measure Customer Loyalty
• Identify High-Value Customers
• Improve Loyalty Programs
• Increase Customer Retention
• Support Personalized Marketing

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
• Days Since Last Purchase
• Loyalty Score (0-100)
• Loyalty Level

Weightage

Purchase Frequency : 40%
Revenue            : 40%
Recency            : 20%

------------------------------------------------------------------------------
*/

WITH CustomerMetrics
AS
(
    SELECT

        C.CustomerID,

        CONCAT
        (
            C.FirstName,
            ' ',
            C.LastName
        ) AS CustomerName,

        COUNT(O.OrderID) AS TotalOrders,

        SUM(O.NetAmount) AS TotalRevenue,

        AVG(O.NetAmount) AS AverageOrderValue,

        DATEDIFF
        (
            DAY,
            MAX(O.OrderDate),
            GETDATE()
        ) AS DaysSinceLastPurchase

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
),

ScoredCustomers
AS
(
    SELECT

        *,

        NTILE(5) OVER
        (
            ORDER BY TotalOrders DESC
        ) AS FrequencyScore,

        NTILE(5) OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS RevenueScore,

        6 - NTILE(5) OVER
        (
            ORDER BY DaysSinceLastPurchase ASC
        ) AS RecencyScore

    FROM CustomerMetrics
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
        (
            (FrequencyScore * 0.40)
          + (RevenueScore * 0.40)
          + (RecencyScore * 0.20)
        ) DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    ROUND(AverageOrderValue,2) AS AverageOrderValue,

    DaysSinceLastPurchase,

    ROUND
    (
        (
            (
                (FrequencyScore * 0.40)
              + (RevenueScore * 0.40)
              + (RecencyScore * 0.20)
            ) / 5.0
        ) * 100,
        2
    ) AS LoyaltyScore,

    CASE

        WHEN
        (
            (
                (FrequencyScore * 0.40)
              + (RevenueScore * 0.40)
              + (RecencyScore * 0.20)
            ) / 5.0
        ) * 100 >= 80

            THEN 'Platinum'

        WHEN
        (
            (
                (FrequencyScore * 0.40)
              + (RevenueScore * 0.40)
              + (RecencyScore * 0.20)
            ) / 5.0
        ) * 100 >= 60

            THEN 'Gold'

        WHEN
        (
            (
                (FrequencyScore * 0.40)
              + (RevenueScore * 0.40)
              + (RecencyScore * 0.20)
            ) / 5.0
        ) * 100 >= 40

            THEN 'Silver'

        ELSE 'Bronze'

    END AS LoyaltyLevel

FROM ScoredCustomers

ORDER BY

    LoyaltyScore DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 133 : Customer Loyalty Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 134 : Customer Engagement Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers are the most engaged with the business based on their
purchasing activity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Engagement measures how actively customers interact with the
business.

Highly engaged customers purchase frequently, spend consistently,
remain active, and are less likely to churn.

This KPI helps management:

• Identify Highly Engaged Customers
• Improve Customer Retention
• Increase Customer Lifetime Value
• Personalize Marketing Campaigns
• Support Loyalty Programs

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
• Days Since Last Purchase
• Engagement Score (0-100)
• Engagement Level

Weightage

Frequency : 35%
Revenue   : 35%
Recency   : 30%

------------------------------------------------------------------------------
*/

WITH CustomerMetrics AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        COUNT(O.OrderID) AS TotalOrders,
        SUM(O.NetAmount) AS TotalRevenue,
        AVG(O.NetAmount) AS AverageOrderValue,
        DATEDIFF(DAY,MAX(O.OrderDate),
GETDATE()
        ) AS DaysSinceLastPurchase

    FROM dbo.Customer C

    INNER JOIN dbo.[Order] O

        ON C.CustomerID = O.CustomerID

    GROUP BY

        C.CustomerID,
        C.FirstName,
        C.LastName
),

CustomerScores
AS
(
    SELECT

        *,

        NTILE(5) OVER
        (
            ORDER BY TotalOrders DESC
        ) AS FrequencyScore,

        NTILE(5) OVER
        (
            ORDER BY TotalRevenue DESC
        ) AS RevenueScore,

        6 - NTILE(5) OVER
        (
            ORDER BY DaysSinceLastPurchase ASC
        ) AS RecencyScore

    FROM CustomerMetrics
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
        (
            (FrequencyScore * 0.35)
          + (RevenueScore * 0.35)
          + (RecencyScore * 0.30)
        ) DESC
    ) AS CustomerRank,

    CustomerID,

    CustomerName,

    TotalOrders,

    TotalRevenue,

    ROUND(AverageOrderValue,2) AS AverageOrderValue,

    DaysSinceLastPurchase,

    ROUND
    (
        (
            (
                (FrequencyScore * 0.35)
              + (RevenueScore * 0.35)
              + (RecencyScore * 0.30)
            ) / 5.0
        ) * 100,
        2
    ) AS EngagementScore,

    CASE

        WHEN
        (
            (
                (FrequencyScore * 0.35)
              + (RevenueScore * 0.35)
              + (RecencyScore * 0.30)
            ) / 5.0
        ) * 100 >= 80

            THEN 'Highly Engaged'

        WHEN
        (
            (
                (FrequencyScore * 0.35)
              + (RevenueScore * 0.35)
              + (RecencyScore * 0.30)
            ) / 5.0
        ) * 100 >= 60

            THEN 'Moderately Engaged'

        WHEN
        (
            (
                (FrequencyScore * 0.35)
              + (RevenueScore * 0.35)
              + (RecencyScore * 0.30)
            ) / 5.0
        ) * 100 >= 40

            THEN 'Low Engagement'

        ELSE 'Inactive'

    END AS EngagementLevel

FROM CustomerScores

ORDER BY

    EngagementScore DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 134 : Customer Engagement Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 135 : Customer Behavior Executive Scorecard
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall health and behavior summary of the customer base?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Customer Behavior Executive Scorecard provides a consolidated view of
key customer behavior metrics for executive decision-making.

This KPI helps management:

• Monitor Customer Health
• Track Customer Engagement
• Evaluate Customer Loyalty
• Measure Customer Retention
• Support Strategic Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Customers
• Active Customers
• Repeat Customers
• Premium Customers
• Average Orders per Customer
• Average Revenue per Customer
• Average Customer Lifetime Value
• Average Days Since Last Purchase

This KPI serves as the executive summary for the entire Customer Behavior
Analysis module.

------------------------------------------------------------------------------
*/

WITH CustomerSummary
AS
(
    SELECT
        C.CustomerID,
        COUNT(O.OrderID) AS TotalOrders,
        SUM(O.NetAmount) AS TotalRevenue,
        MAX(O.OrderDate) AS LatestPurchaseDate,
        C.IsActive
    FROM dbo.Customer C
    LEFT JOIN dbo.[Order] O
        ON C.CustomerID = O.CustomerID
    GROUP BY
        C.CustomerID,
        C.IsActive
)
SELECT
    COUNT(CustomerID) AS TotalCustomers,
    SUM(
        CASE
            WHEN IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveCustomers,
    SUM(
        CASE
            WHEN TotalOrders > 1 THEN 1
            ELSE 0
        END
    ) AS RepeatCustomers,
    SUM
    (
        CASE
            WHEN TotalRevenue >= 100000 AND TotalOrders >= 10 THEN 1
            ELSE 0
        END
    ) AS PremiumCustomers,
    ROUND(AVG(CAST(ISNULL(TotalOrders,0) AS DECIMAL(18,2))),2) AS AverageOrdersPerCustomer,
    ROUND(AVG(CAST(ISNULL(TotalRevenue,0) AS DECIMAL(18,2))),2) AS AverageRevenuePerCustomer,
    ROUND(AVG(CAST(ISNULL(TotalRevenue,0)AS DECIMAL(18,2))),2) AS AverageCustomerLifetimeValue,
    ROUND(AVG(CAST(DATEDIFF(DAY,LatestPurchaseDate,GETDATE())AS DECIMAL(18,2))),2) AS AverageDaysSinceLastPurchase

FROM CustomerSummary;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 135 : Customer Behavior Executive Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';