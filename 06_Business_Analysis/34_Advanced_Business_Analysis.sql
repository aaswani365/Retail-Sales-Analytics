/*------------------------------------------------------------------------------
KPI 346 : Pareto Analysis (80/20 Rule)
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products contribute to approximately 80% of the total business revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Pareto Principle (80/20 Rule) states that approximately 80% of business
results come from 20% of the products or customers.

This analysis helps identify the products that generate the majority of
revenue, allowing management to prioritize inventory, marketing, pricing,
and supply chain decisions.

This KPI helps management:

• Identify High Revenue Products
• Focus Marketing Efforts
• Optimize Inventory Investment
• Improve Product Portfolio
• Support Executive Decision-Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Product Revenue
• Revenue Percentage
• Cumulative Revenue
• Cumulative Percentage
• Pareto Category (Top 80% / Remaining 20%)

------------------------------------------------------------------------------*/

WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName
),
ParetoAnalysis AS(
    SELECT
        ProductID,
        ProductName,
        TotalRevenue,
        SUM(TotalRevenue) OVER(ORDER BY TotalRevenue DESC ROWS UNBOUNDED PRECEDING) AS CumulativeRevenue,
        SUM(TotalRevenue) OVER() AS GrandTotalRevenue
    FROM ProductRevenue
)
SELECT
    ProductID,
    ProductName,
    ROUND(TotalRevenue,2) AS TotalRevenue,
    ROUND((TotalRevenue * 100.0) / GrandTotalRevenue,2) AS RevenuePercentage,
    ROUND(CumulativeRevenue,2) AS CumulativeRevenue,
    ROUND((CumulativeRevenue * 100.0) / GrandTotalRevenue,2) AS CumulativePercentage,
    CASE
        WHEN (CumulativeRevenue * 100.0) / GrandTotalRevenue <= 80 THEN 'Top 80% Revenue'
        ELSE 'Remaining 20%'
    END AS ParetoCategory
FROM ParetoAnalysis
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 346 : Pareto Analysis (80/20 Rule) Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 347 : ABC Product Classification
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can products be classified into A, B, and C categories based on their
contribution to total revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

ABC Analysis classifies inventory based on revenue contribution.

Category A:
• Top 80% of total revenue
• High-value products requiring strict inventory control

Category B:
• Next 15% of total revenue
• Medium-value products requiring moderate monitoring

Category C:
• Remaining 5% of total revenue
• Low-value products requiring minimal inventory control

This KPI helps management:

• Prioritize Inventory Investment
• Optimize Stock Levels
• Improve Purchasing Decisions
• Reduce Holding Costs
• Improve Supply Chain Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Total Revenue
• Revenue Percentage
• Cumulative Revenue Percentage
• ABC Category

------------------------------------------------------------------------------*/

;WITH ProductRevenue AS
(
    SELECT
        P.ProductID,
        P.ProductName,
        SUM(OI.LineTotal) AS TotalRevenue
    FROM dbo.Product AS P
    INNER JOIN dbo.OrderItem AS OI
        ON P.ProductID = OI.ProductID
    GROUP BY
        P.ProductID,
        P.ProductName
),
RevenueAnalysis AS
(
    SELECT
        ProductID,
        ProductName,
        TotalRevenue,
        SUM(TotalRevenue) OVER (ORDER BY TotalRevenue DESC ROWS UNBOUNDED PRECEDING) AS CumulativeRevenue,
        SUM(TotalRevenue) OVER() AS GrandTotalRevenue
    FROM ProductRevenue
)
SELECT
    ProductID,
    ProductName,
    ROUND(TotalRevenue,2) AS TotalRevenue,
    ROUND((TotalRevenue * 100.0) / GrandTotalRevenue,2) AS RevenuePercentage,
    ROUND((CumulativeRevenue * 100.0) / GrandTotalRevenue,2) AS CumulativeRevenuePercentage,
    CASE
        WHEN(CumulativeRevenue * 100.0) / GrandTotalRevenue <= 80 THEN 'A'
        WHEN(CumulativeRevenue * 100.0) / GrandTotalRevenue <= 95 THEN 'B'
        ELSE 'C'
    END AS ABCCategory
FROM RevenueAnalysis
ORDER BY
    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 347 : ABC Product Classification Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 348 : XYZ Inventory Classification
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have stable, moderate, or highly variable demand based on
sales quantity?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

XYZ Analysis classifies inventory according to demand variability.

Category X
• Stable demand
• Predictable sales
• Easier inventory planning

Category Y
• Moderate demand variability
• Seasonal or fluctuating demand

Category Z
• Highly unpredictable demand
• Requires careful inventory monitoring

This KPI helps management:

• Improve Demand Forecasting
• Optimize Inventory Planning
• Reduce Stockout Risk
• Improve Safety Stock Decisions
• Support Supply Chain Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Average Monthly Quantity Sold
• Standard Deviation
• Coefficient of Variation (CV %)
• XYZ Category

Classification

X → CV ≤ 20%

Y → CV >20% and ≤50%

Z → CV >50%

------------------------------------------------------------------------------*/

;WITH MonthlySales AS
(
    SELECT
        OI.ProductID,
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        SUM(OI.Quantity) AS MonthlyQuantitySold
    FROM dbo.OrderItem AS OI
    INNER JOIN dbo.[Order] AS O
        ON OI.OrderID = O.OrderID
    GROUP BY
        OI.ProductID,
        YEAR(O.OrderDate),
        MONTH(O.OrderDate)
),
DemandStatistics AS
(
    SELECT
        ProductID,
        AVG(CAST(MonthlyQuantitySold AS DECIMAL(18,2))) AS AverageMonthlyQuantity,
        STDEV(CAST(MonthlyQuantitySold AS DECIMAL(18,2))) AS DemandStdDev
    FROM MonthlySales
    GROUP BY
        ProductID
)
SELECT
    P.ProductID,
    P.ProductName,
    ROUND(DS.AverageMonthlyQuantity,2) AS AverageMonthlyQuantity,
    ROUND(ISNULL(DS.DemandStdDev,0),2) AS DemandStandardDeviation,
    ROUND((ISNULL(DS.DemandStdDev,0) / NULLIF(DS.AverageMonthlyQuantity,0)) * 100,2) AS CoefficientOfVariation,
    CASE
        WHEN(ISNULL(DS.DemandStdDev,0) / NULLIF(DS.AverageMonthlyQuantity,0)) * 100 <= 20 THEN 'X'
        WHEN(ISNULL(DS.DemandStdDev,0) / NULLIF(DS.AverageMonthlyQuantity,0)) * 100 <= 50 THEN 'Y'
        ELSE 'Z'
    END AS XYZCategory
FROM DemandStatistics AS DS
INNER JOIN dbo.Product AS P
    ON DS.ProductID = P.ProductID
ORDER BY
    CoefficientOfVariation ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 348 : XYZ Inventory Classification Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 349 : Customer RFM Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can customers be segmented based on their purchasing behaviour using
Recency, Frequency, and Monetary (RFM) analysis?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

RFM Analysis is one of the most widely used customer segmentation techniques.

Recency
How recently the customer made a purchase.

Frequency
How often the customer purchases.

Monetary
How much revenue the customer generates.

This KPI helps management:

• Identify Loyal Customers
• Identify High Value Customers
• Detect At-Risk Customers
• Improve Customer Retention
• Build Targeted Marketing Campaigns

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Customer ID
• Customer Name
• Last Purchase Date
• Recency (Days)
• Frequency (Orders)
• Monetary Value
• R Score
• F Score
• M Score
• RFM Score

Higher RFM Score indicates a better customer.

------------------------------------------------------------------------------*/

;WITH CustomerRFM AS
(
    SELECT
        C.CustomerID,
        CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
        MAX(O.OrderDate) AS LastPurchaseDate,
        DATEDIFF(DAY,MAX(O.OrderDate), 
		(SELECT MAX(OrderDate)FROM dbo.[Order])) AS Recency,
        COUNT(DISTINCT O.OrderID) AS Frequency,
        SUM(OI.LineTotal) AS MonetaryValue
    FROM dbo.Customer AS C
    INNER JOIN dbo.[Order] AS O
        ON C.CustomerID = O.CustomerID
    INNER JOIN dbo.OrderItem AS OI
        ON O.OrderID = OI.OrderID
    GROUP BY
        C.CustomerID,
        C.FirstName,
        C.LastName
)
SELECT
    CustomerID,
    CustomerName,
    CAST(LastPurchaseDate AS DATE) AS LastPurchaseDate,
    Recency,
    Frequency,
    ROUND(MonetaryValue,2) AS MonetaryValue,
    NTILE(5) OVER (ORDER BY Recency ASC) AS RScore,
    NTILE(5) OVER (ORDER BY Frequency DESC) AS FScore,
    NTILE(5) OVER (ORDER BY MonetaryValue DESC) AS MScore,
    CONCAT(NTILE(5) OVER (ORDER BY Recency ASC), NTILE(5) OVER (ORDER BY Frequency DESC),NTILE(5) OVER (ORDER BY MonetaryValue DESC)) AS RFMScore
FROM CustomerRFM
ORDER BY
    MonetaryValue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 349 : Customer RFM Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 350 : Customer Cohort Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How do customers acquired in the same month behave over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Cohort Analysis groups customers based on the month of their first purchase
and tracks how many continue purchasing in subsequent months.

This KPI helps management:

• Measure Customer Retention
• Analyze Customer Loyalty
• Evaluate Marketing Campaign Effectiveness
• Identify Customer Churn Trends
• Improve Customer Lifecycle Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Cohort Month
• Activity Month
• Cohort Size
• Active Customers
• Retention Percentage

------------------------------------------------------------------------------*/

;WITH FirstPurchase AS
(
    SELECT
        CustomerID,
        MIN(CAST(OrderDate AS DATE)) AS FirstPurchaseDate
    FROM dbo.[Order]
    GROUP BY
        CustomerID
),
CustomerActivity AS
(
    SELECT
        O.CustomerID,
        DATEFROMPARTS(YEAR(FP.FirstPurchaseDate), MONTH(FP.FirstPurchaseDate),1) AS CohortMonth,
        DATEFROMPARTS(YEAR(O.OrderDate), MONTH(O.OrderDate),1) AS ActivityMonth
    FROM dbo.[Order] AS O
    INNER JOIN FirstPurchase AS FP
        ON O.CustomerID = FP.CustomerID
),
CohortData AS
(
    SELECT
        CohortMonth,
        ActivityMonth,
        COUNT(DISTINCT CustomerID) AS ActiveCustomers
    FROM CustomerActivity
    GROUP BY
        CohortMonth,
        ActivityMonth
),
CohortSize AS
(
    SELECT
        CohortMonth,
        COUNT(DISTINCT CustomerID) AS CohortSize
    FROM CustomerActivity
    GROUP BY
        CohortMonth
)
SELECT
    CD.CohortMonth,
    CD.ActivityMonth,
    CS.CohortSize,
    CD.ActiveCustomers,
    ROUND(CD.ActiveCustomers * 100.0 / CS.CohortSize,2) AS RetentionPercentage
FROM CohortData AS CD
INNER JOIN CohortSize AS CS
    ON CD.CohortMonth = CS.CohortMonth
ORDER BY
    CD.CohortMonth,
    CD.ActivityMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 350 : Customer Cohort Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 351 : Customer Lifetime Segmentation
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can customers be segmented based on their lifetime value generated for
the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Lifetime Segmentation categorizes customers according to the total
revenue they have generated throughout their relationship with the business.

This KPI helps management:

• Identify VIP Customers
• Improve Customer Retention
• Prioritize High-Value Customers
• Personalize Marketing Campaigns
• Optimize Customer Relationship Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Customer ID
• Customer Name
• Total Orders
• Lifetime Revenue
• Average Order Value
• Lifetime Segment

Segmentation

VIP          → Top 10%

Premium      → Next 20%

Standard     → Next 40%

Basic        → Remaining Customers

------------------------------------------------------------------------------
*/

;WITH CustomerLifetime AS
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

        SUM(OI.LineTotal) AS LifetimeRevenue

    FROM dbo.Customer AS C

    INNER JOIN dbo.[Order] AS O

        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName
)

SELECT

    CustomerID,

    CustomerName,

    TotalOrders,

    ROUND
    (
        LifetimeRevenue,
        2
    ) AS LifetimeRevenue,

    ROUND
    (
        LifetimeRevenue
        /
        NULLIF(TotalOrders,0),
        2
    ) AS AverageOrderValue,

    CASE

        WHEN NTILE(10)
             OVER
             (
                 ORDER BY LifetimeRevenue DESC
             ) = 1

            THEN 'VIP'

        WHEN NTILE(10)
             OVER
             (
                 ORDER BY LifetimeRevenue DESC
             ) <= 3

            THEN 'Premium'

        WHEN NTILE(10)
             OVER
             (
                 ORDER BY LifetimeRevenue DESC
             ) <= 7

            THEN 'Standard'

        ELSE 'Basic'

    END AS LifetimeSegment

FROM CustomerLifetime

ORDER BY

    LifetimeRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 351 : Customer Lifetime Segmentation Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 352 : Cross-Sell Opportunity Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products are most frequently purchased together, creating
cross-selling opportunities?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Cross-selling recommends complementary products that customers commonly
purchase together.

This KPI helps organizations increase Average Order Value (AOV), improve
customer experience, and optimize product placement.

This KPI helps management:

• Identify Product Combinations
• Improve Product Recommendations
• Increase Average Basket Size
• Support Marketing Campaigns
• Optimize Store Layout

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product A
• Product B
• Orders Purchased Together
• Cross-Sell Rank

------------------------------------------------------------------------------
*/

SELECT

    P1.ProductID AS ProductAID,

    P1.ProductName AS ProductA,

    P2.ProductID AS ProductBID,

    P2.ProductName AS ProductB,

    COUNT(DISTINCT OI1.OrderID) AS OrdersPurchasedTogether,

    DENSE_RANK()
    OVER
    (
        ORDER BY
            COUNT(DISTINCT OI1.OrderID) DESC
    ) AS CrossSellRank

FROM dbo.OrderItem AS OI1

INNER JOIN dbo.OrderItem AS OI2
    ON OI1.OrderID = OI2.OrderID
   AND OI1.ProductID < OI2.ProductID
INNER JOIN dbo.Product AS P1
    ON OI1.ProductID = P1.ProductID
INNER JOIN dbo.Product AS P2
    ON OI2.ProductID = P2.ProductID
GROUP BY
    P1.ProductID,
    P1.ProductName,
    P2.ProductID,
    P2.ProductName
HAVING
    COUNT(DISTINCT OI1.OrderID) >= 2
ORDER BY
    OrdersPurchasedTogether DESC,
    ProductA,
    ProductB;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 352 : Cross-Sell Opportunity Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 353 : Up-Sell Opportunity Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest Average Selling Price (ASP), making them
ideal candidates for up-selling opportunities?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Up-selling encourages customers to purchase higher-value products instead of
standard alternatives.

This KPI identifies products whose Average Selling Price (ASP) is above the
overall business ASP, making them strong candidates for premium positioning,
sales recommendations, and promotional campaigns.

This KPI helps management:

• Identify Premium Products
• Increase Average Order Value (AOV)
• Improve Revenue Per Transaction
• Support Product Promotion Strategy
• Maximize Revenue Growth

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Quantity Sold
• Total Revenue
• Average Selling Price
• Overall Business ASP
• Revenue Rank
• Up-Sell Category

Up-Sell Category

• Premium Candidate
• Standard Product

------------------------------------------------------------------------------
*/

;WITH OverallASP AS
(
    SELECT

        AVG
        (
            CAST(LineTotal / NULLIF(Quantity,0) AS DECIMAL(18,2))
        ) AS BusinessASP

    FROM dbo.OrderItem
),

ProductSales AS
(
    SELECT

        P.ProductID,

        P.ProductName,

        SUM(OI.Quantity) AS QuantitySold,

        SUM(OI.LineTotal) AS TotalRevenue,

        SUM(OI.LineTotal)
        /
        NULLIF(SUM(OI.Quantity),0) AS AverageSellingPrice

    FROM dbo.Product AS P

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        P.ProductID,

        P.ProductName
)

SELECT

    PS.ProductID,

    PS.ProductName,

    PS.QuantitySold,

    ROUND
    (
        PS.TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        PS.AverageSellingPrice,
        2
    ) AS AverageSellingPrice,

    ROUND
    (
        OA.BusinessASP,
        2
    ) AS OverallBusinessASP,

    DENSE_RANK()
    OVER
    (
        ORDER BY PS.TotalRevenue DESC
    ) AS RevenueRank,

    CASE

        WHEN PS.AverageSellingPrice > OA.BusinessASP

            THEN 'Premium Candidate'

        ELSE 'Standard Product'

    END AS UpSellCategory

FROM ProductSales AS PS

CROSS JOIN OverallASP AS OA

ORDER BY

    AverageSellingPrice DESC,

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 353 : Up-Sell Opportunity Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

PRINT '';

/*------------------------------------------------------------------------------
KPI 354 : Product Affinity Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product pairs have the strongest purchasing affinity based on the
frequency with which they appear together in customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product Affinity Analysis measures the relationship between products that are
frequently purchased together. Unlike simple cross-selling, affinity analysis
helps identify strong product associations that can improve merchandising,
bundling, recommendation engines, and promotional campaigns.

This KPI helps management:

• Discover Strong Product Relationships
• Create Product Bundles
• Improve Recommendation Engines
• Optimize Store Layout
• Increase Basket Size

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product A
• Product B
• Orders Purchased Together
• Product A Orders
• Product B Orders
• Affinity Score (%)

Affinity Score =
(Orders Purchased Together ÷ Product A Orders) × 100

------------------------------------------------------------------------------
*/

;WITH ProductOrders AS
(
    SELECT

        ProductID,

        COUNT(DISTINCT OrderID) AS TotalOrders

    FROM dbo.OrderItem

    GROUP BY

        ProductID
)

SELECT

    P1.ProductID AS ProductAID,

    P1.ProductName AS ProductA,

    P2.ProductID AS ProductBID,

    P2.ProductName AS ProductB,

    COUNT(DISTINCT OI1.OrderID) AS OrdersPurchasedTogether,

    PO1.TotalOrders AS ProductAOrders,

    PO2.TotalOrders AS ProductBOrders,

    ROUND
    (
        COUNT(DISTINCT OI1.OrderID) * 100.0
        /
        NULLIF(PO1.TotalOrders,0),
        2
    ) AS AffinityScorePercentage

FROM dbo.OrderItem AS OI1

INNER JOIN dbo.OrderItem AS OI2

    ON OI1.OrderID = OI2.OrderID

   AND OI1.ProductID < OI2.ProductID

INNER JOIN dbo.Product AS P1

    ON OI1.ProductID = P1.ProductID

INNER JOIN dbo.Product AS P2

    ON OI2.ProductID = P2.ProductID

INNER JOIN ProductOrders AS PO1

    ON P1.ProductID = PO1.ProductID

INNER JOIN ProductOrders AS PO2

    ON P2.ProductID = PO2.ProductID

GROUP BY

    P1.ProductID,

    P1.ProductName,

    P2.ProductID,

    P2.ProductName,

    PO1.TotalOrders,

    PO2.TotalOrders

HAVING

    COUNT(DISTINCT OI1.OrderID) >= 2

ORDER BY

    AffinityScorePercentage DESC,

    OrdersPurchasedTogether DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 354 : Product Affinity Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 355 : Revenue Waterfall Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is gross revenue transformed into net revenue after discounts, taxes,
and product returns?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Waterfall Analysis breaks down revenue into its individual
components, helping management understand how different business factors
impact final revenue.

This KPI helps management:

• Understand Revenue Composition
• Measure Discount Impact
• Evaluate Tax Contribution
• Analyze Refund Impact
• Support Financial Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Gross Revenue
• Total Discounts
• Net Revenue After Discount
• Total Tax
• Revenue Including Tax
• Total Refund Amount
• Final Net Revenue

Calculation

Gross Revenue
− Discounts
= Net Revenue

Net Revenue
+ Tax
= Revenue Including Tax

Revenue Including Tax
− Refund Amount
= Final Net Revenue

------------------------------------------------------------------------------
*/

SELECT

    ROUND
    (
        SUM(OI.UnitPrice * OI.Quantity),
        2
    ) AS GrossRevenue,

    ROUND
    (
        SUM(OI.DiscountAmount),
        2
    ) AS TotalDiscount,

    ROUND
    (
        SUM(OI.UnitPrice * OI.Quantity)
        -
        SUM(OI.DiscountAmount),
        2
    ) AS NetRevenueAfterDiscount,

    ROUND
    (
        SUM(OI.TaxAmount),
        2
    ) AS TotalTax,

    ROUND
    (
        (
            SUM(OI.UnitPrice * OI.Quantity)
            -
            SUM(OI.DiscountAmount)
        )
        +
        SUM(OI.TaxAmount),
        2
    ) AS RevenueIncludingTax,

    ROUND
    (
        ISNULL(SUM(R.RefundAmount),0),
        2
    ) AS TotalRefundAmount,

    ROUND
    (
        (
            (
                SUM(OI.UnitPrice * OI.Quantity)
                -
                SUM(OI.DiscountAmount)
            )
            +
            SUM(OI.TaxAmount)
        )
        -
        ISNULL(SUM(R.RefundAmount),0),
        2
    ) AS FinalNetRevenue

FROM dbo.OrderItem AS OI

LEFT JOIN dbo.[Return] AS R

    ON OI.OrderItemID = R.OrderItemID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 355 : Revenue Waterfall Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 356 : Profit Bridge Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is gross profit affected by discounts, taxes, refunds, and product cost?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Profit Bridge Analysis explains how revenue is converted into profit by
showing the impact of each financial component.

Unlike Revenue Waterfall, this KPI includes product cost and calculates
actual gross profit.

This KPI helps management:

• Measure Gross Profit
• Understand Cost Structure
• Evaluate Discount Impact
• Analyze Refund Losses
• Support Executive Financial Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Gross Revenue
• Product Cost
• Gross Margin
• Total Discount
• Net Revenue
• Total Tax
• Total Refund
• Final Gross Profit

Calculation

Gross Revenue
− Product Cost
= Gross Margin

Gross Margin
− Discount
+ Tax
− Refund
= Final Gross Profit

------------------------------------------------------------------------------
*/

SELECT

    ROUND
    (
        SUM(OI.UnitPrice * OI.Quantity),
        2
    ) AS GrossRevenue,

    ROUND
    (
        SUM(OI.CostPrice * OI.Quantity),
        2
    ) AS ProductCost,

    ROUND
    (
        SUM((OI.UnitPrice - OI.CostPrice) * OI.Quantity),
        2
    ) AS GrossMargin,

    ROUND
    (
        SUM(OI.DiscountAmount),
        2
    ) AS TotalDiscount,

    ROUND
    (
        SUM(OI.LineTotal),
        2
    ) AS NetRevenue,

    ROUND
    (
        SUM(OI.TaxAmount),
        2
    ) AS TotalTax,

    ROUND
    (
        ISNULL(SUM(R.RefundAmount),0),
        2
    ) AS TotalRefundAmount,

    ROUND
    (
        SUM((OI.UnitPrice - OI.CostPrice) * OI.Quantity)
        -
        SUM(OI.DiscountAmount)
        +
        SUM(OI.TaxAmount)
        -
        ISNULL(SUM(R.RefundAmount),0),
        2
    ) AS FinalGrossProfit

FROM dbo.OrderItem AS OI

LEFT JOIN dbo.[Return] AS R

    ON OI.OrderItemID = R.OrderItemID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 356 : Profit Bridge Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 357 : Revenue Contribution Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of total business revenue is contributed by each store,
product category, brand, and supplier?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Contribution Analysis helps identify which business dimensions
contribute the most to overall revenue.

Instead of only showing revenue values, this KPI highlights each entity's
share of total business revenue.

This KPI helps management:

• Identify Major Revenue Contributors
• Compare Business Dimensions
• Support Strategic Investment
• Optimize Product Portfolio
• Improve Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Contribution Type
• Contribution Name
• Total Revenue
• Revenue Contribution (%)
• Revenue Rank

------------------------------------------------------------------------------
*/

;WITH RevenueContribution AS
(
    /* Store Contribution */

    SELECT

        'Store' AS ContributionType,

        S.StoreName AS ContributionName,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Store AS S

    INNER JOIN dbo.[Order] AS O

        ON S.StoreID = O.StoreID

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        S.StoreName

    UNION ALL

    /* Category Contribution */

    SELECT

        'Category',

        C.CategoryName,

        SUM(OI.LineTotal)

    FROM dbo.Category AS C

    INNER JOIN dbo.SubCategory AS SC

        ON C.CategoryID = SC.CategoryID

    INNER JOIN dbo.Product AS P

        ON SC.SubCategoryID = P.SubCategoryID

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        C.CategoryName

    UNION ALL

    /* Brand Contribution */

    SELECT

        'Brand',

        B.BrandName,

        SUM(OI.LineTotal)

    FROM dbo.Brand AS B

    INNER JOIN dbo.Product AS P

        ON B.BrandID = P.BrandID

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        B.BrandName

    UNION ALL

    /* Supplier Contribution */

    SELECT

        'Supplier',

        S.SupplierName,

        SUM(OI.LineTotal)

    FROM dbo.Supplier AS S

    INNER JOIN dbo.Product AS P

        ON S.SupplierID = P.SupplierID

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        S.SupplierName
)

SELECT

    ContributionType,

    ContributionName,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue * 100.0
        /
        SUM(TotalRevenue)
        OVER
        (
            PARTITION BY ContributionType
        ),
        2
    ) AS RevenueContributionPercentage,

    DENSE_RANK()
    OVER
    (
        PARTITION BY ContributionType

        ORDER BY TotalRevenue DESC
    ) AS RevenueRank

FROM RevenueContribution

ORDER BY

    ContributionType,

    RevenueRank;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 357 : Revenue Contribution Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 358 : Store Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each store perform compared to the overall business average?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store Benchmarking compares every store against the business average to
identify high-performing and underperforming locations.

Instead of only viewing revenue, management can quickly determine whether a
store performs Above Average, Average, or Below Average.

This KPI helps management:

• Compare Store Performance
• Identify Best Performing Stores
• Detect Underperforming Stores
• Support Expansion Decisions
• Improve Regional Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Store ID
• Store Name
• Total Orders
• Total Revenue
• Average Order Value
• Business Average Revenue
• Revenue Difference
• Performance Benchmark

Performance Benchmark

Above Average
Average
Below Average

------------------------------------------------------------------------------
*/

;WITH StorePerformance AS
(
    SELECT

        S.StoreID,

        S.StoreName,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Store AS S

    INNER JOIN dbo.[Order] AS O

        ON S.StoreID = O.StoreID

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        S.StoreID,

        S.StoreName
)

SELECT

    StoreID,

    StoreName,

    TotalOrders,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalOrders,0),
        2
    ) AS AverageOrderValue,

    ROUND
    (
        AVG(TotalRevenue) OVER(),
        2
    ) AS BusinessAverageRevenue,

    ROUND
    (
        TotalRevenue
        -
        AVG(TotalRevenue) OVER(),
        2
    ) AS RevenueDifference,

    CASE

        WHEN TotalRevenue > AVG(TotalRevenue) OVER()

            THEN 'Above Average'

        WHEN TotalRevenue = AVG(TotalRevenue) OVER()

            THEN 'Average'

        ELSE 'Below Average'

    END AS PerformanceBenchmark

FROM StorePerformance

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 358 : Store Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 359 : Employee Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each employee perform compared to the overall business average?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee Benchmarking compares employee performance against the business
average to identify top performers and employees requiring additional
support or training.

This KPI helps management:

• Evaluate Employee Productivity
• Identify Top Performers
• Improve Performance Reviews
• Support Incentive Programs
• Optimize Workforce Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Employee ID
• Employee Name
• Total Orders
• Total Revenue
• Average Order Value
• Business Average Revenue
• Revenue Difference
• Performance Benchmark

Performance Benchmark

Above Average
Average
Below Average

------------------------------------------------------------------------------
*/

;WITH EmployeePerformance AS
(
    SELECT

        E.EmployeeID,

        CONCAT
        (
            E.FirstName,
            ' ',
            E.LastName
        ) AS EmployeeName,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Employee AS E

    INNER JOIN dbo.[Order] AS O

        ON E.EmployeeID = O.EmployeeID

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        E.EmployeeID,

        E.FirstName,

        E.LastName
)

SELECT

    EmployeeID,

    EmployeeName,

    TotalOrders,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalOrders,0),
        2
    ) AS AverageOrderValue,

    ROUND
    (
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS BusinessAverageRevenue,

    ROUND
    (
        TotalRevenue
        -
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS RevenueDifference,

    CASE

        WHEN TotalRevenue > AVG(TotalRevenue) OVER()

            THEN 'Above Average'

        WHEN TotalRevenue = AVG(TotalRevenue) OVER()

            THEN 'Average'

        ELSE 'Below Average'

    END AS PerformanceBenchmark

FROM EmployeePerformance

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 359 : Employee Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 360 : Product Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each product perform compared to the overall business average?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Product Benchmarking compares each product's revenue against the average
product revenue across the business.

This KPI helps identify star products, average performers, and products that
may require pricing, marketing, or inventory improvements.

This KPI helps management:

• Identify Best Performing Products
• Detect Low Performing Products
• Optimize Product Portfolio
• Improve Inventory Decisions
• Support Pricing Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Quantity Sold
• Total Revenue
• Average Selling Price
• Business Average Revenue
• Revenue Difference
• Performance Benchmark

Performance Benchmark

Above Average
Average
Below Average

------------------------------------------------------------------------------
*/

;WITH ProductPerformance AS
(
    SELECT

        P.ProductID,

        P.ProductName,

        SUM(OI.Quantity) AS QuantitySold,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Product AS P

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        P.ProductID,

        P.ProductName
)

SELECT

    ProductID,

    ProductName,

    QuantitySold,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(QuantitySold,0),
        2
    ) AS AverageSellingPrice,

    ROUND
    (
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS BusinessAverageRevenue,

    ROUND
    (
        TotalRevenue
        -
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS RevenueDifference,

    CASE

        WHEN TotalRevenue > AVG(TotalRevenue) OVER()

            THEN 'Above Average'

        WHEN TotalRevenue = AVG(TotalRevenue) OVER()

            THEN 'Average'

        ELSE 'Below Average'

    END AS PerformanceBenchmark

FROM ProductPerformance

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 360 : Product Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 361 : Customer Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each customer's purchasing performance compare with the overall
business average?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Benchmarking compares every customer's lifetime revenue against the
average customer revenue across the business.

This KPI helps identify high-value customers, average customers, and
customers that require engagement strategies.

This KPI helps management:

• Identify VIP Customers
• Detect Low-Value Customers
• Improve Customer Retention
• Support CRM Campaigns
• Optimize Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Customer ID
• Customer Name
• Total Orders
• Total Revenue
• Average Order Value
• Business Average Revenue
• Revenue Difference
• Performance Benchmark

Performance Benchmark

Above Average
Average
Below Average

------------------------------------------------------------------------------
*/

;WITH CustomerPerformance AS
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

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Customer AS C

    INNER JOIN dbo.[Order] AS O

        ON C.CustomerID = O.CustomerID

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        C.CustomerID,

        C.FirstName,

        C.LastName
)

SELECT

    CustomerID,

    CustomerName,

    TotalOrders,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalOrders,0),
        2
    ) AS AverageOrderValue,

    ROUND
    (
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS BusinessAverageRevenue,

    ROUND
    (
        TotalRevenue
        -
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS RevenueDifference,

    CASE

        WHEN TotalRevenue > AVG(TotalRevenue) OVER()

            THEN 'Above Average'

        WHEN TotalRevenue = AVG(TotalRevenue) OVER()

            THEN 'Average'

        ELSE 'Below Average'

    END AS PerformanceBenchmark

FROM CustomerPerformance

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 361 : Customer Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 362 : Supplier Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each supplier perform compared to the overall supplier average based
on the revenue generated by their supplied products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier Benchmarking evaluates supplier performance by measuring the revenue
generated from products supplied by each supplier and comparing it with the
business average.

This KPI helps management:

• Evaluate Supplier Performance
• Identify Strategic Suppliers
• Optimize Vendor Relationships
• Improve Procurement Decisions
• Support Supplier Negotiations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Supplier ID
• Supplier Name
• Products Supplied
• Total Revenue
• Average Revenue Per Product
• Business Average Revenue
• Revenue Difference
• Performance Benchmark

Performance Benchmark

Above Average
Average
Below Average

------------------------------------------------------------------------------
*/

;WITH SupplierPerformance AS
(
    SELECT

        S.SupplierID,

        S.SupplierName,

        COUNT(DISTINCT P.ProductID) AS ProductsSupplied,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.Supplier AS S

    INNER JOIN dbo.Product AS P

        ON S.SupplierID = P.SupplierID

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    GROUP BY

        S.SupplierID,

        S.SupplierName
)

SELECT

    SupplierID,

    SupplierName,

    ProductsSupplied,

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(ProductsSupplied,0),
        2
    ) AS AverageRevenuePerProduct,

    ROUND
    (
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS BusinessAverageRevenue,

    ROUND
    (
        TotalRevenue
        -
        AVG(TotalRevenue)
        OVER(),
        2
    ) AS RevenueDifference,

    CASE

        WHEN TotalRevenue > AVG(TotalRevenue) OVER()

            THEN 'Above Average'

        WHEN TotalRevenue = AVG(TotalRevenue) OVER()

            THEN 'Average'

        ELSE 'Below Average'

    END AS PerformanceBenchmark

FROM SupplierPerformance

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 362 : Supplier Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 363 : Inventory Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each product's inventory level compare with the average inventory
level across the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Inventory Benchmarking helps identify products that are overstocked,
understocked, or maintained at optimal inventory levels.

This KPI enables inventory managers to optimize stock investment, reduce
holding costs, and minimize stockout risks.

This KPI helps management:

• Identify Overstocked Products
• Identify Understocked Products
• Optimize Inventory Levels
• Improve Stock Planning
• Reduce Inventory Carrying Costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Current Stock
• Reorder Level
• Business Average Stock
• Stock Difference
• Inventory Benchmark

Inventory Benchmark

Above Average Stock
Average Stock
Below Average Stock

------------------------------------------------------------------------------
*/

;WITH InventoryPerformance AS
(
    SELECT

        P.ProductID,

        P.ProductName,

        SUM(I.QuantityInStock) AS CurrentStock,

        P.ReorderLevel

    FROM dbo.Product AS P

    INNER JOIN dbo.Inventory AS I

        ON P.ProductID = I.ProductID

    GROUP BY

        P.ProductID,

        P.ProductName,

        P.ReorderLevel
)

SELECT

    ProductID,

    ProductName,

    CurrentStock,

    ReorderLevel,

    ROUND
    (
        AVG(CurrentStock)
        OVER(),
        2
    ) AS BusinessAverageStock,

    ROUND
    (
        CurrentStock
        -
        AVG(CurrentStock)
        OVER(),
        2
    ) AS StockDifference,

    CASE

        WHEN CurrentStock > AVG(CurrentStock) OVER()

            THEN 'Above Average Stock'

        WHEN CurrentStock = AVG(CurrentStock) OVER()

            THEN 'Average Stock'

        ELSE 'Below Average Stock'

    END AS InventoryBenchmark

FROM InventoryPerformance

ORDER BY

    CurrentStock DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 363 : Inventory Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 364 : Return Benchmarking
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each product's return performance compare with the average return
performance across the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return Benchmarking helps identify products with unusually high return rates,
allowing management to investigate potential quality issues, supplier
problems, customer dissatisfaction, or incorrect product descriptions.

This KPI helps management:

• Identify High Return Products
• Improve Product Quality
• Evaluate Supplier Performance
• Reduce Return Costs
• Improve Customer Satisfaction

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Product ID
• Product Name
• Quantity Sold
• Quantity Returned
• Return Rate (%)
• Business Average Return Rate (%)
• Return Rate Difference
• Return Benchmark

Return Benchmark

Above Average Returns
Average Returns
Below Average Returns

------------------------------------------------------------------------------
*/

;WITH SalesData AS
(
    SELECT

        P.ProductID,

        P.ProductName,

        SUM(OI.Quantity) AS QuantitySold,

        ISNULL
        (
            SUM(R.QuantityReturned),
            0
        ) AS QuantityReturned

    FROM dbo.Product AS P

    INNER JOIN dbo.OrderItem AS OI

        ON P.ProductID = OI.ProductID

    LEFT JOIN dbo.[Return] AS R

        ON OI.OrderItemID = R.OrderItemID

    GROUP BY

        P.ProductID,

        P.ProductName
),

ReturnPerformance AS
(
    SELECT

        ProductID,

        ProductName,

        QuantitySold,

        QuantityReturned,

        CAST
        (
            QuantityReturned * 100.0
            /
            NULLIF(QuantitySold,0)
            AS DECIMAL(18,2)
        ) AS ReturnRate

    FROM SalesData
)

SELECT

    ProductID,

    ProductName,

    QuantitySold,

    QuantityReturned,

    ReturnRate,

    ROUND
    (
        AVG(ReturnRate)
        OVER(),
        2
    ) AS BusinessAverageReturnRate,

    ROUND
    (
        ReturnRate
        -
        AVG(ReturnRate)
        OVER(),
        2
    ) AS ReturnRateDifference,

    CASE

        WHEN ReturnRate > AVG(ReturnRate) OVER()

            THEN 'Above Average Returns'

        WHEN ReturnRate = AVG(ReturnRate) OVER()

            THEN 'Average Returns'

        ELSE 'Below Average Returns'

    END AS ReturnBenchmark

FROM ReturnPerformance

ORDER BY

    ReturnRate DESC,

    QuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 364 : Return Benchmarking Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 365 : Business KPI Scorecard
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we build a single business scorecard containing the most important KPIs
required by senior management?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Business KPI Scorecard consolidates critical business metrics into one result
set, allowing management to monitor business performance without reviewing
multiple reports.

This KPI helps management:

• Monitor Overall Business Performance
• Review Sales Performance
• Evaluate Customer Growth
• Track Inventory Health
• Monitor Returns
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns

• Total Revenue
• Total Orders
• Average Order Value
• Total Customers
• Total Products
• Total Stores
• Total Employees
• Total Suppliers
• Total Returns
• Return Rate (%)
• Total Inventory
• Inventory Value

------------------------------------------------------------------------------
*/

;WITH BusinessSummary AS
(
    SELECT

        SUM(OI.LineTotal) AS TotalRevenue,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        COUNT(DISTINCT O.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.EmployeeID) AS TotalEmployees,

        COUNT(DISTINCT O.StoreID) AS TotalStores,

        COUNT(DISTINCT OI.ProductID) AS ProductsSold

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID
),

ReturnSummary AS
(
    SELECT

        COUNT(ReturnID) AS TotalReturns,

        SUM(RefundAmount) AS TotalRefundAmount

    FROM dbo.[Return]
),

InventorySummary AS
(
    SELECT

        SUM(I.QuantityInStock) AS TotalInventory,

        SUM(I.QuantityInStock * P.CostPrice) AS InventoryValue

    FROM dbo.Inventory AS I

    INNER JOIN dbo.Product AS P

        ON I.ProductID = P.ProductID
)

SELECT

    ROUND(B.TotalRevenue,2) AS TotalRevenue,

    B.TotalOrders,

    ROUND
    (
        B.TotalRevenue
        /
        NULLIF(B.TotalOrders,0),
        2
    ) AS AverageOrderValue,

    B.TotalCustomers,

    (SELECT COUNT(*) FROM dbo.Product) AS TotalProducts,

    B.TotalStores,

    B.TotalEmployees,

    (SELECT COUNT(*) FROM dbo.Supplier) AS TotalSuppliers,

    R.TotalReturns,

    ROUND
    (
        R.TotalReturns * 100.0
        /
        NULLIF(B.TotalOrders,0),
        2
    ) AS ReturnRatePercentage,

    I.TotalInventory,

    ROUND
    (
        I.InventoryValue,
        2
    ) AS InventoryValue,

    ROUND
    (
        ISNULL(R.TotalRefundAmount,0),
        2
    ) AS TotalRefundAmount

FROM BusinessSummary AS B

CROSS JOIN ReturnSummary AS R

CROSS JOIN InventorySummary AS I;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 365 : Business KPI Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 366 : Executive Business Dashboard Dataset
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we generate a single dashboard-ready dataset that provides executives
with revenue, customer, employee, product, inventory, supplier, and return
performance in one consolidated report?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Executives require a single dataset instead of multiple KPI reports.

This KPI creates a denormalized executive dataset that can directly feed a
Power BI Executive Dashboard.

This KPI helps management:

• Executive Reporting
• Business Monitoring
• Performance Tracking
• Strategic Decision Making
• Power BI Dashboard Development

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns

• Store Information
• Revenue
• Orders
• Customers
• Products Sold
• Employees
• Suppliers
• Returns
• Inventory
• Average Order Value
• Return Rate

------------------------------------------------------------------------------
*/

;WITH SalesSummary AS
(
    SELECT

        O.StoreID,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        COUNT(DISTINCT O.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.EmployeeID) AS TotalEmployees,

        COUNT(DISTINCT OI.ProductID) AS ProductsSold,

        SUM(OI.Quantity) AS QuantitySold,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID

    GROUP BY

        O.StoreID
),

ReturnSummary AS
(
    SELECT

        O.StoreID,

        COUNT(R.ReturnID) AS TotalReturns,

        SUM(R.RefundAmount) AS TotalRefundAmount

    FROM dbo.[Return] AS R

    INNER JOIN dbo.OrderItem AS OI

        ON R.OrderItemID = OI.OrderItemID

    INNER JOIN dbo.[Order] AS O

        ON OI.OrderID = O.OrderID

    GROUP BY

        O.StoreID
),

InventorySummary AS
(
    SELECT

        StoreID,

        SUM(QuantityInStock) AS InventoryUnits,

        COUNT(DISTINCT ProductID) AS InventoryProducts

    FROM dbo.Inventory

    GROUP BY

        StoreID
),

SupplierSummary AS
(
    SELECT

        COUNT(DISTINCT SupplierID) AS TotalSuppliers

    FROM dbo.Supplier
)

SELECT

    S.StoreID,

    S.StoreName,

    SS.TotalOrders,

    SS.TotalCustomers,

    SS.TotalEmployees,

    SS.ProductsSold,

    SS.QuantitySold,

    ROUND
    (
        SS.TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        SS.TotalRevenue
        /
        NULLIF(SS.TotalOrders,0),
        2
    ) AS AverageOrderValue,

    ISNULL(RS.TotalReturns,0) AS TotalReturns,

    ROUND
    (
        ISNULL(RS.TotalRefundAmount,0),
        2
    ) AS TotalRefundAmount,

    ROUND
    (
        ISNULL(RS.TotalReturns,0) * 100.0
        /
        NULLIF(SS.TotalOrders,0),
        2
    ) AS ReturnRatePercentage,

    ISNULL(ISU.InventoryUnits,0) AS InventoryUnits,

    ISNULL(ISU.InventoryProducts,0) AS InventoryProducts,

    SUP.TotalSuppliers

FROM dbo.Store AS S

INNER JOIN SalesSummary AS SS

    ON S.StoreID = SS.StoreID

LEFT JOIN ReturnSummary AS RS

    ON S.StoreID = RS.StoreID

LEFT JOIN InventorySummary AS ISU

    ON S.StoreID = ISU.StoreID

CROSS JOIN SupplierSummary AS SUP

ORDER BY

    TotalRevenue DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 366 : Executive Business Dashboard Dataset Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 367 : Business Health Index
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we measure the overall health of the business using a single composite
score derived from multiple operational and financial KPIs?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Business Health Index (BHI) combines multiple business indicators into one
overall score.

It provides executives with a quick snapshot of business performance instead
of reviewing dozens of individual reports.

This KPI helps management:

• Monitor Overall Business Health
• Track Business Performance
• Support Executive Decision Making
• Identify Operational Risks
• Measure Organizational Performance

------------------------------------------------------------------------------
Business Health Score Components
------------------------------------------------------------------------------

• Revenue Score
• Order Score
• Customer Score
• Return Score
• Inventory Score

Business Health Index = Average of all KPI Scores

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Total Revenue
• Total Orders
• Total Customers
• Return Rate
• Inventory Units
• Revenue Score
• Order Score
• Customer Score
• Return Score
• Inventory Score
• Business Health Index

------------------------------------------------------------------------------
*/

;WITH BusinessMetrics AS
(
    SELECT

        SUM(OI.LineTotal) AS TotalRevenue,

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        COUNT(DISTINCT O.CustomerID) AS TotalCustomers

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID
),

ReturnMetrics AS
(
    SELECT

        COUNT(*) AS TotalReturns

    FROM dbo.[Return]
),

InventoryMetrics AS
(
    SELECT

        SUM(QuantityInStock) AS InventoryUnits

    FROM dbo.Inventory
)

SELECT

    BM.TotalRevenue,

    BM.TotalOrders,

    BM.TotalCustomers,

    RM.TotalReturns,

    ROUND
    (
        RM.TotalReturns * 100.0
        /
        NULLIF(BM.TotalOrders,0),
        2
    ) AS ReturnRatePercentage,

    IM.InventoryUnits,

    /* Revenue Score */

    CASE

        WHEN BM.TotalRevenue >= 5000000 THEN 100
        WHEN BM.TotalRevenue >= 3000000 THEN 80
        WHEN BM.TotalRevenue >= 1000000 THEN 60
        ELSE 40

    END AS RevenueScore,

    /* Order Score */

    CASE

        WHEN BM.TotalOrders >= 5000 THEN 100
        WHEN BM.TotalOrders >= 3000 THEN 80
        WHEN BM.TotalOrders >= 1000 THEN 60
        ELSE 40

    END AS OrderScore,

    /* Customer Score */

    CASE

        WHEN BM.TotalCustomers >= 2000 THEN 100
        WHEN BM.TotalCustomers >= 1000 THEN 80
        WHEN BM.TotalCustomers >= 500 THEN 60
        ELSE 40

    END AS CustomerScore,

    /* Return Score */

    CASE

        WHEN
            (
                RM.TotalReturns * 100.0
                /
                NULLIF(BM.TotalOrders,0)
            ) <= 5

            THEN 100

        WHEN
            (
                RM.TotalReturns * 100.0
                /
                NULLIF(BM.TotalOrders,0)
            ) <= 10

            THEN 80

        ELSE 60

    END AS ReturnScore,

    /* Inventory Score */

    CASE

        WHEN IM.InventoryUnits >= 10000 THEN 100
        WHEN IM.InventoryUnits >= 5000 THEN 80
        WHEN IM.InventoryUnits >= 2000 THEN 60
        ELSE 40

    END AS InventoryScore,

    /* Business Health Index */

    ROUND
    (
        (

        CASE
            WHEN BM.TotalRevenue >= 5000000 THEN 100
            WHEN BM.TotalRevenue >= 3000000 THEN 80
            WHEN BM.TotalRevenue >= 1000000 THEN 60
            ELSE 40
        END

        +

        CASE
            WHEN BM.TotalOrders >= 5000 THEN 100
            WHEN BM.TotalOrders >= 3000 THEN 80
            WHEN BM.TotalOrders >= 1000 THEN 60
            ELSE 40
        END

        +

        CASE
            WHEN BM.TotalCustomers >= 2000 THEN 100
            WHEN BM.TotalCustomers >= 1000 THEN 80
            WHEN BM.TotalCustomers >= 500 THEN 60
            ELSE 40
        END

        +

        CASE
            WHEN (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)) <= 5 THEN 100
            WHEN (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)) <= 10 THEN 80
            ELSE 60
        END

        +

        CASE
            WHEN IM.InventoryUnits >= 10000 THEN 100
            WHEN IM.InventoryUnits >= 5000 THEN 80
            WHEN IM.InventoryUnits >= 2000 THEN 60
            ELSE 40
        END

        ) / 5.0,
        2
    ) AS BusinessHealthIndex

FROM BusinessMetrics AS BM

CROSS JOIN ReturnMetrics AS RM

CROSS JOIN InventoryMetrics AS IM;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 367 : Business Health Index Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 368 : Revenue Efficiency Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How efficiently does the business generate revenue relative to its customers,
employees, stores, and products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue Efficiency measures how effectively business resources generate
revenue.

Instead of looking only at total revenue, executives can evaluate how much
revenue is generated per customer, employee, store, and product.

This KPI helps management:

• Measure Business Efficiency
• Compare Operational Productivity
• Support Resource Allocation
• Improve Workforce Utilization
• Optimize Business Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Total Revenue
• Revenue per Customer
• Revenue per Employee
• Revenue per Store
• Revenue per Product
• Revenue Efficiency Score

Score Classification

Excellent
Good
Average
Needs Improvement

------------------------------------------------------------------------------
*/

;WITH BusinessMetrics AS
(
    SELECT

        SUM(OI.LineTotal) AS TotalRevenue,

        COUNT(DISTINCT O.CustomerID) AS TotalCustomers,

        COUNT(DISTINCT O.EmployeeID) AS TotalEmployees,

        COUNT(DISTINCT O.StoreID) AS TotalStores,

        COUNT(DISTINCT OI.ProductID) AS TotalProducts

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID
)

SELECT

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalCustomers,0),
        2
    ) AS RevenuePerCustomer,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalEmployees,0),
        2
    ) AS RevenuePerEmployee,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalStores,0),
        2
    ) AS RevenuePerStore,

    ROUND
    (
        TotalRevenue
        /
        NULLIF(TotalProducts,0),
        2
    ) AS RevenuePerProduct,

    ROUND
    (
        (
            (TotalRevenue / NULLIF(TotalCustomers,0))
            +
            (TotalRevenue / NULLIF(TotalEmployees,0))
            +
            (TotalRevenue / NULLIF(TotalStores,0))
            +
            (TotalRevenue / NULLIF(TotalProducts,0))
        ) / 4.0,
        2
    ) AS RevenueEfficiencyScore,

    CASE

        WHEN
        (
            (
                (TotalRevenue / NULLIF(TotalCustomers,0))
                +
                (TotalRevenue / NULLIF(TotalEmployees,0))
                +
                (TotalRevenue / NULLIF(TotalStores,0))
                +
                (TotalRevenue / NULLIF(TotalProducts,0))
            ) / 4.0
        ) >= 100000

            THEN 'Excellent'

        WHEN
        (
            (
                (TotalRevenue / NULLIF(TotalCustomers,0))
                +
                (TotalRevenue / NULLIF(TotalEmployees,0))
                +
                (TotalRevenue / NULLIF(TotalStores,0))
                +
                (TotalRevenue / NULLIF(TotalProducts,0))
            ) / 4.0
        ) >= 50000

            THEN 'Good'

        WHEN
        (
            (
                (TotalRevenue / NULLIF(TotalCustomers,0))
                +
                (TotalRevenue / NULLIF(TotalEmployees,0))
                +
                (TotalRevenue / NULLIF(TotalStores,0))
                +
                (TotalRevenue / NULLIF(TotalProducts,0))
            ) / 4.0
        ) >= 25000

            THEN 'Average'

        ELSE 'Needs Improvement'

    END AS EfficiencyCategory

FROM BusinessMetrics;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 368 : Revenue Efficiency Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 369 : Profitability Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How profitable is the business based on gross profit, profit margin, and
overall financial performance?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Profitability Score provides executives with a single measure that evaluates
how efficiently the business converts revenue into profit.

Unlike Revenue Efficiency, this KPI focuses entirely on profitability by
considering revenue, product cost, gross profit, and profit margin.

This KPI helps management:

• Measure Financial Performance
• Evaluate Profitability
• Monitor Gross Margin
• Support Executive Decision Making
• Improve Pricing Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Total Revenue
• Total Product Cost
• Gross Profit
• Gross Profit Margin (%)
• Profitability Score
• Profitability Category

Profitability Category

Excellent
Good
Average
Needs Improvement

------------------------------------------------------------------------------
*/

;WITH ProfitMetrics AS
(
    SELECT

        SUM(OI.LineTotal) AS TotalRevenue,

        SUM(OI.CostPrice * OI.Quantity) AS TotalProductCost,

        SUM(OI.LineTotal)
        -
        SUM(OI.CostPrice * OI.Quantity) AS GrossProfit

    FROM dbo.OrderItem AS OI
)

SELECT

    ROUND
    (
        TotalRevenue,
        2
    ) AS TotalRevenue,

    ROUND
    (
        TotalProductCost,
        2
    ) AS TotalProductCost,

    ROUND
    (
        GrossProfit,
        2
    ) AS GrossProfit,

    ROUND
    (
        GrossProfit * 100.0
        /
        NULLIF(TotalRevenue,0),
        2
    ) AS GrossProfitMargin,

    ROUND
    (
        GrossProfit * 100.0
        /
        NULLIF(TotalRevenue,0),
        2
    ) AS ProfitabilityScore,

    CASE

        WHEN
            (
                GrossProfit * 100.0
                /
                NULLIF(TotalRevenue,0)
            ) >= 40

            THEN 'Excellent'

        WHEN
            (
                GrossProfit * 100.0
                /
                NULLIF(TotalRevenue,0)
            ) >= 30

            THEN 'Good'

        WHEN
            (
                GrossProfit * 100.0
                /
                NULLIF(TotalRevenue,0)
            ) >= 20

            THEN 'Average'

        ELSE 'Needs Improvement'

    END AS ProfitabilityCategory

FROM ProfitMetrics;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 369 : Profitability Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 370 : Customer Satisfaction Index (CSI)
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Can we estimate overall customer satisfaction using operational business
metrics in the absence of direct customer survey data?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Many organizations do not collect customer satisfaction surveys.

This KPI estimates Customer Satisfaction Index (CSI) using operational
performance indicators that directly influence customer experience.

Factors considered

• Return Rate
• Repeat Purchase Rate
• Average Order Value

A lower return rate and a higher repeat purchase rate generally indicate
better customer satisfaction.

This KPI helps management:

• Monitor Customer Experience
• Measure Customer Loyalty
• Evaluate Business Quality
• Support Customer Retention
• Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Total Customers
• Repeat Customers
• Repeat Purchase Rate
• Return Rate
• Average Order Value
• Customer Satisfaction Index
• Satisfaction Category

Satisfaction Category

Excellent
Good
Average
Needs Improvement

------------------------------------------------------------------------------
*/

;WITH CustomerMetrics AS
(
    SELECT

        COUNT(DISTINCT CustomerID) AS TotalCustomers,

        COUNT
        (
            DISTINCT
            CASE
                WHEN OrderCount > 1
                THEN CustomerID
            END
        ) AS RepeatCustomers

    FROM
    (
        SELECT

            CustomerID,

            COUNT(OrderID) AS OrderCount

        FROM dbo.[Order]

        GROUP BY

            CustomerID

    ) AS X
),

SalesMetrics AS
(
    SELECT

        COUNT(DISTINCT O.OrderID) AS TotalOrders,

        SUM(OI.LineTotal) AS TotalRevenue

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID
),

ReturnMetrics AS
(
    SELECT

        COUNT(*) AS TotalReturns

    FROM dbo.[Return]
)

SELECT

    CM.TotalCustomers,

    CM.RepeatCustomers,

    ROUND
    (
        CM.RepeatCustomers * 100.0
        /
        NULLIF(CM.TotalCustomers,0),
        2
    ) AS RepeatPurchaseRate,

    ROUND
    (
        RM.TotalReturns * 100.0
        /
        NULLIF(SM.TotalOrders,0),
        2
    ) AS ReturnRate,

    ROUND
    (
        SM.TotalRevenue
        /
        NULLIF(SM.TotalOrders,0),
        2
    ) AS AverageOrderValue,

    ROUND
    (
        (
            (
                CM.RepeatCustomers * 100.0
                /
                NULLIF(CM.TotalCustomers,0)
            )
            +
            (
                100
                -
                (
                    RM.TotalReturns * 100.0
                    /
                    NULLIF(SM.TotalOrders,0)
                )
            )
        ) / 2.0,
        2
    ) AS CustomerSatisfactionIndex,

    CASE

        WHEN
        (
            (
                (
                    CM.RepeatCustomers * 100.0
                    /
                    NULLIF(CM.TotalCustomers,0)
                )
                +
                (
                    100
                    -
                    (
                        RM.TotalReturns * 100.0
                        /
                        NULLIF(SM.TotalOrders,0)
                    )
                )
            ) / 2.0
        ) >= 85

            THEN 'Excellent'

        WHEN
        (
            (
                (
                    CM.RepeatCustomers * 100.0
                    /
                    NULLIF(CM.TotalCustomers,0)
                )
                +
                (
                    100
                    -
                    (
                        RM.TotalReturns * 100.0
                        /
                        NULLIF(SM.TotalOrders,0)
                    )
                )
            ) / 2.0
        ) >= 70

            THEN 'Good'

        WHEN
        (
            (
                (
                    CM.RepeatCustomers * 100.0
                    /
                    NULLIF(CM.TotalCustomers,0)
                )
                +
                (
                    100
                    -
                    (
                        RM.TotalReturns * 100.0
                        /
                        NULLIF(SM.TotalOrders,0)
                    )
                )
            ) / 2.0
        ) >= 55

            THEN 'Average'

        ELSE 'Needs Improvement'

    END AS SatisfactionCategory

FROM CustomerMetrics AS CM

CROSS JOIN SalesMetrics AS SM

CROSS JOIN ReturnMetrics AS RM;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 370 : Customer Satisfaction Index Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 371 : Operational Efficiency Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How efficiently is the business operating based on inventory utilization,
returns, employee productivity, and revenue generation?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Operational Efficiency measures how effectively business resources are
utilized to generate revenue while minimizing operational losses.

This KPI combines multiple operational indicators into a single score that
helps executives quickly evaluate operational performance.

This KPI helps management:

• Measure Operational Performance
• Improve Resource Utilization
• Monitor Employee Productivity
• Reduce Return Impact
• Support Continuous Improvement

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Revenue per Employee
• Revenue per Store
• Inventory Utilization
• Return Rate
• Operational Efficiency Score
• Efficiency Category

Efficiency Category

Excellent
Good
Average
Needs Improvement

------------------------------------------------------------------------------
*/

;WITH BusinessMetrics AS
(
    SELECT

        SUM(OI.LineTotal) AS TotalRevenue,

        COUNT(DISTINCT O.EmployeeID) AS TotalEmployees,

        COUNT(DISTINCT O.StoreID) AS TotalStores,

        COUNT(DISTINCT O.OrderID) AS TotalOrders

    FROM dbo.[Order] AS O

    INNER JOIN dbo.OrderItem AS OI

        ON O.OrderID = OI.OrderID
),

InventoryMetrics AS
(
    SELECT

        SUM(QuantityInStock) AS TotalInventoryUnits

    FROM dbo.Inventory
),

ReturnMetrics AS
(
    SELECT

        COUNT(*) AS TotalReturns

    FROM dbo.[Return]
)

SELECT

    ROUND
    (
        BM.TotalRevenue
        /
        NULLIF(BM.TotalEmployees,0),
        2
    ) AS RevenuePerEmployee,

    ROUND
    (
        BM.TotalRevenue
        /
        NULLIF(BM.TotalStores,0),
        2
    ) AS RevenuePerStore,

    IM.TotalInventoryUnits,

    ROUND
    (
        BM.TotalRevenue
        /
        NULLIF(IM.TotalInventoryUnits,0),
        2
    ) AS InventoryUtilization,

    ROUND
    (
        RM.TotalReturns * 100.0
        /
        NULLIF(BM.TotalOrders,0),
        2
    ) AS ReturnRatePercentage,

    ROUND
    (
        (
            (BM.TotalRevenue / NULLIF(BM.TotalEmployees,0))
            +
            (BM.TotalRevenue / NULLIF(BM.TotalStores,0))
            +
            (BM.TotalRevenue / NULLIF(IM.TotalInventoryUnits,0))
            +
            (100 -
             (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)))
        ) / 4.0,
        2
    ) AS OperationalEfficiencyScore,

    CASE

        WHEN
        (
            (
                (BM.TotalRevenue / NULLIF(BM.TotalEmployees,0))
                +
                (BM.TotalRevenue / NULLIF(BM.TotalStores,0))
                +
                (BM.TotalRevenue / NULLIF(IM.TotalInventoryUnits,0))
                +
                (100 -
                 (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)))
            ) / 4.0
        ) >= 100000

            THEN 'Excellent'

        WHEN
        (
            (
                (BM.TotalRevenue / NULLIF(BM.TotalEmployees,0))
                +
                (BM.TotalRevenue / NULLIF(BM.TotalStores,0))
                +
                (BM.TotalRevenue / NULLIF(IM.TotalInventoryUnits,0))
                +
                (100 -
                 (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)))
            ) / 4.0
        ) >= 50000

            THEN 'Good'

        WHEN
        (
            (
                (BM.TotalRevenue / NULLIF(BM.TotalEmployees,0))
                +
                (BM.TotalRevenue / NULLIF(BM.TotalStores,0))
                +
                (BM.TotalRevenue / NULLIF(IM.TotalInventoryUnits,0))
                +
                (100 -
                 (RM.TotalReturns * 100.0 / NULLIF(BM.TotalOrders,0)))
            ) / 4.0
        ) >= 25000

            THEN 'Average'

        ELSE 'Needs Improvement'

    END AS EfficiencyCategory

FROM BusinessMetrics AS BM

CROSS JOIN InventoryMetrics AS IM

CROSS JOIN ReturnMetrics AS RM;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 371 : Operational Efficiency Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

