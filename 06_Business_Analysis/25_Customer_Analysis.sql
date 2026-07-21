/*------------------------------------------------------------------------------
KPI 076 : Customer Overview
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
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

------------------------------------------------------------------------------
*/

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

/*
------------------------------------------------------------------------------
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