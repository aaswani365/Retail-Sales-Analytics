/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 30_Return_Analysis.sql
Description     : Return Analytics KPIs for Product Returns, Refund Analysis & Reverse Logistics

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

Total KPIs      : 30 (KPI 226 – KPI 255)
Difficulty      : Beginner → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module provides comprehensive return analytics to monitor product
returns, refund amounts, return reasons, return statuses, customer return
behavior, product quality issues, and reverse logistics performance.

The KPIs help business users identify return patterns, reduce return rates,
improve product quality, optimize inventory decisions, and enhance customer
satisfaction through data-driven insights.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Return Analysis

Total KPIs         : 30

Estimated Runtime  : < 10 Seconds

Primary SQL Concepts
--------------------

• SELECT
• GROUP BY
• JOIN
• Aggregate Functions
• CASE
• Common Table Expressions (CTEs)
• Window Functions
• Ranking Functions
• DATE Functions
• Percentage Calculations
• NULLIF
• CAST
• ROUND

==============================================================================*/


USE RetailSalesDB;
GO

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT '30_Return_Analysis.sql';
PRINT '==============================================================';

PRINT 'Starting Return Analysis...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 226 : Total Returns
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many product returns have been recorded?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Total Returns is one of the primary indicators of product quality,
customer satisfaction, and operational performance.

Monitoring return volume helps identify trends, measure customer behavior,
and evaluate the effectiveness of sales and inventory strategies.

This KPI helps management:

• Monitor Overall Return Volume
• Measure Reverse Logistics Activity
• Evaluate Customer Satisfaction
• Identify Product Quality Issues
• Support Executive Dashboards

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Returns
• Total Quantity Returned
• Total Refund Amount

------------------------------------------------------------------------------
*/

SELECT

    COUNT(ReturnID) AS TotalReturns,

    SUM(QuantityReturned) AS TotalQuantityReturned,

    ROUND
    (
        SUM(RefundAmount),
        2
    ) AS TotalRefundAmount

FROM dbo.[Return];

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 226 : Total Returns Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 227 : Total Refund Amount
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the total refund amount issued for returned products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Refund amount is a key financial metric that measures the monetary impact
of product returns on the business.

Monitoring refunds helps management evaluate return costs, identify
financial losses, and improve product quality and customer satisfaction.

This KPI helps management:

• Monitor Refund Expenses
• Measure Financial Impact of Returns
• Analyze Reverse Logistics Cost
• Support Financial Reporting
• Improve Product Quality

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Refund Amount
• Average Refund Amount
• Highest Refund Amount
• Lowest Refund Amount

------------------------------------------------------------------------------*/

SELECT
    ROUND(SUM(RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(RefundAmount),2) AS AverageRefundAmount,
    ROUND(MAX(RefundAmount),2) AS HighestRefundAmount,
    ROUND(MIN(RefundAmount),2) AS LowestRefundAmount
FROM dbo.[Return];

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 227 : Total Refund Amount Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 228 : Return Rate (%)
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of sold items have been returned?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return Rate is one of the most important retail KPIs used to evaluate
product quality, customer satisfaction, and overall business performance.

A high return rate may indicate product defects, incorrect product
descriptions, logistics issues, or customer dissatisfaction.

This KPI helps management:

• Measure Return Performance
• Monitor Product Quality
• Evaluate Customer Satisfaction
• Improve Inventory Planning
• Reduce Business Losses

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Quantity Sold
• Total Quantity Returned
• Return Rate (%)

Formula

Return Rate (%) = (Total Quantity Returned / Total Quantity Sold) × 100

------------------------------------------------------------------------------*/

SELECT
    SUM(OI.Quantity) AS TotalQuantitySold,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.QuantityReturned) * 100.0 / NULLIF(SUM(OI.Quantity), 0),2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 228 : Return Rate (%) Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 229 : Returns by Return Status
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are product returns distributed across different return statuses?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return status analysis helps management monitor the progress of return
requests and identify bottlenecks in the return processing workflow.

This KPI helps management:

• Monitor Return Processing
• Track Return Workflow
• Identify Pending Returns
• Improve Reverse Logistics
• Support Operational Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Return Status
• Total Returns
• Total Quantity Returned
• Total Refund Amount
• Percentage of Total Returns

Returns are grouped by Return Status.

------------------------------------------------------------------------------*/

SELECT
    RS.StatusName AS ReturnStatus,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(COUNT(R.ReturnID) * 100.0 / SUM(COUNT(R.ReturnID)) OVER (),2) AS ReturnPercentage
FROM dbo.[Return] R
INNER JOIN dbo.ReturnStatus RS
    ON R.ReturnStatusID = RS.ReturnStatusID
GROUP BY
    RS.StatusName
ORDER BY
    TotalReturns DESC,
    ReturnStatus;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 229 : Returns by Return Status Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 230 : Returns by Return Reason
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What are the most common reasons for product returns?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return reason analysis helps businesses identify the root causes of
product returns and implement corrective actions to improve product
quality and customer satisfaction.

This KPI helps management:

• Identify Common Return Reasons
• Improve Product Quality
• Reduce Return Rates
• Enhance Customer Satisfaction
• Support Business Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Return Reason
• Total Returns
• Total Quantity Returned
• Total Refund Amount
• Percentage of Total Returns

Returns are grouped by Return Reason.

------------------------------------------------------------------------------*/

SELECT
    RR.ReasonName AS ReturnReason,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(COUNT(R.ReturnID) * 100.0 / SUM(COUNT(R.ReturnID)) OVER (),2) AS ReturnPercentage
FROM dbo.[Return] R
INNER JOIN dbo.ReturnReason RR
    ON R.ReturnReasonID = RR.ReturnReasonID
GROUP BY
    RR.ReasonName
ORDER BY
    TotalReturns DESC,
    ReturnReason;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 230 : Returns by Return Reason Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 231 : Top Returned Products
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest number of returned items?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying the most frequently returned products helps businesses detect
quality issues, manufacturing defects, incorrect product descriptions,
or customer dissatisfaction.

This KPI helps management:

• Identify High Return Products
• Improve Product Quality
• Reduce Return Costs
• Improve Customer Satisfaction
• Support Product Improvement Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned products.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    P.ProductName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND
    (
        SUM(R.RefundAmount),
        2
    ) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
GROUP BY
    P.ProductName
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 231 : Top Returned Products Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 232 : Top Returned Categories
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product categories have the highest number of returned items?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-level return analysis helps identify product groups that generate
the highest return volume. This enables management to focus quality
improvement efforts on specific product categories.

This KPI helps management:

• Identify High Return Categories
• Improve Product Quality
• Reduce Return Costs
• Improve Customer Satisfaction
• Optimize Category Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Name
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned categories.

------------------------------------------------------------------------------*/

SELECT
    C.CategoryName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = P.SubCategoryID
INNER JOIN Category C
	ON C.CategoryID = SC.CategoryID
GROUP BY
    C.CategoryName
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 232 : Top Returned Categories Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 233 : Top Returned Brands
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which brands have the highest number of returned products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand-level return analysis helps identify brands with quality issues,
customer dissatisfaction, or manufacturing defects.

This KPI helps management:

• Evaluate Brand Performance
• Monitor Product Quality
• Improve Supplier Collaboration
• Reduce Refund Costs
• Enhance Customer Satisfaction

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Brand Name
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned brands.

------------------------------------------------------------------------------*/

SELECT
    B.BrandName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
GROUP BY
    B.BrandName
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 233 : Top Returned Brands Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 234 : Store-wise Return Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores receive the highest number of product returns?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-level return analysis helps identify locations with unusually high
return volumes. This can indicate operational issues, product handling
problems, customer service concerns, or regional purchasing behavior.

This KPI helps management:

• Compare Return Performance Across Stores
• Identify High Return Locations
• Improve Store Operations
• Reduce Return Costs
• Support Regional Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned stores.

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
GROUP BY
    S.StoreName
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 234 : Store-wise Return Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 235 : Employee-wise Return Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees are associated with the highest number of returned products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee-level return analysis helps identify whether product returns are
linked to specific sales representatives. High return rates may indicate
incorrect product recommendations, billing mistakes, or customer service
issues.

This KPI helps management:

• Evaluate Employee Return Performance
• Identify Training Opportunities
• Improve Customer Experience
• Reduce Return Costs
• Monitor Sales Quality

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Name
• Job Title
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned products handled by
employees.

------------------------------------------------------------------------------*/

SELECT
    CONCAT(E.FirstName, ' ', E.LastName) AS EmployeeName,
    E.JobTitle,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID
GROUP BY
    CONCAT(E.FirstName, ' ', E.LastName),
    E.JobTitle
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 235 : Employee-wise Return Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 236 : Customer-wise Return Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have returned the highest number of products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer return analysis helps identify customers with unusually high return
activity. This insight supports customer behavior analysis, fraud detection,
return policy evaluation, and customer satisfaction initiatives.

This KPI helps management:

• Identify High Return Customers
• Analyze Customer Return Behavior
• Detect Potential Return Abuse
• Improve Customer Experience
• Optimize Return Policies

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Name
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest return activity.

------------------------------------------------------------------------------*/

SELECT
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
GROUP BY
    CONCAT(C.FirstName, ' ', C.LastName)
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 236 : Customer-wise Return Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 237 : Monthly Return Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How have product returns changed month over month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly return trends help businesses identify seasonal return patterns,
product quality issues, and changes in customer behavior over time.

This KPI helps management:

• Monitor Return Trends
• Identify Seasonal Return Patterns
• Evaluate Product Quality Improvements
• Forecast Future Return Volumes
• Support Strategic Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Year
• Month
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are displayed in chronological order.

------------------------------------------------------------------------------*/

SELECT
    YEAR(R.ReturnDate) AS ReturnYear,
    MONTH(R.ReturnDate) AS ReturnMonth,
    DATENAME(MONTH, R.ReturnDate) AS MonthName,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
GROUP BY
    YEAR(R.ReturnDate),
    MONTH(R.ReturnDate),
    DATENAME(MONTH, R.ReturnDate)
ORDER BY
    ReturnYear,
    ReturnMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 237 : Monthly Return Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 238 : Yearly Return Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How have product returns changed over the years?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Year-over-year return analysis helps management evaluate long-term product
quality, customer satisfaction, and operational improvements.

This KPI helps management:

• Analyze Long-Term Return Trends
• Measure Product Quality Improvements
• Evaluate Customer Satisfaction
• Support Strategic Planning
• Forecast Future Return Volumes

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Return Year
• Total Returns
• Total Quantity Returned
• Total Refund Amount

Results are displayed in chronological order.

------------------------------------------------------------------------------*/

SELECT
    YEAR(R.ReturnDate) AS ReturnYear,
    COUNT(R.ReturnID) AS TotalReturns,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
GROUP BY
    YEAR(R.ReturnDate)
ORDER BY
    ReturnYear;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 238 : Yearly Return Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 239 : Return Quantity Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest quantity returned?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Analyzing return quantities helps identify products that generate the largest
return volume, even if the number of return transactions is relatively low.

This KPI helps management:

• Identify High Return Volume Products
• Detect Product Quality Issues
• Improve Inventory Planning
• Reduce Reverse Logistics Costs
• Improve Customer Satisfaction

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Total Return Transactions
• Total Quantity Returned
• Average Quantity Returned per Transaction

Results are sorted by highest returned quantity.

------------------------------------------------------------------------------
*/

SELECT
    P.ProductName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(AVG(CAST(R.QuantityReturned AS DECIMAL(10,2))),2) AS AvgQuantityPerReturn
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
GROUP BY
    P.ProductName
ORDER BY
    TotalQuantityReturned DESC,
    TotalReturnTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 239 : Return Quantity Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 240 : Refund Amount by Product
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products generate the highest refund amount due to returns?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Refund amount analysis helps identify products that have the greatest
financial impact on the business because of returns.

This KPI helps management:

• Identify High Cost Return Products
• Measure Financial Impact of Returns
• Improve Product Quality
• Reduce Revenue Leakage
• Support Pricing & Supplier Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Average Refund per Return

Results are sorted by highest refund amount.

------------------------------------------------------------------------------*/

SELECT
    P.ProductName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundPerReturn
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
GROUP BY
    P.ProductName
ORDER BY
    TotalRefundAmount DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 240 : Refund Amount by Product Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 241 : Refund Amount by Category
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product categories generate the highest refund amount?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category-level refund analysis helps identify product groups that create
the greatest financial impact due to customer returns.

This KPI helps management:

• Identify High Cost Categories
• Measure Financial Losses
• Improve Category Quality
• Reduce Refund Expenses
• Support Product Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Average Refund per Return

Results are sorted by highest refund amount.

------------------------------------------------------------------------------*/

SELECT
    C.CategoryName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundPerReturn
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = SC.SubCategoryID
INNER JOIN dbo.Category C
	ON SC.CategoryID = C.CategoryID
GROUP BY
    C.CategoryName
ORDER BY
    TotalRefundAmount DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 241 : Refund Amount by Category Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 242 : Refund Amount by Store
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores generate the highest refund amount due to product returns?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-level refund analysis helps identify locations with the greatest
financial losses from returns. High refund amounts may indicate operational
issues, product handling problems, or regional purchasing patterns.

This KPI helps management:

• Compare Store Refund Performance
• Identify High Cost Return Locations
• Improve Store Operations
• Reduce Financial Losses
• Support Regional Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Average Refund per Return

Results are sorted by highest refund amount.

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundPerReturn
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
GROUP BY
    S.StoreName
ORDER BY
    TotalRefundAmount DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 242 : Refund Amount by Store Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 243 : High Value Returns
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which returned products generated the highest refund amounts?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

High-value returns have a significant financial impact on the business.
Identifying these transactions helps management investigate expensive
returns, improve product quality, and minimize revenue leakage.

This KPI helps management:

• Identify Expensive Return Transactions
• Reduce Financial Losses
• Investigate High-Risk Products
• Improve Return Policies
• Support Fraud Detection

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Return ID
• Return Date
• Product Name
• Customer Name
• Store Name
• Quantity Returned
• Refund Amount

Results are sorted from highest to lowest refund amount.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    R.ReturnID,
    CAST(R.ReturnDate AS DATE) AS ReturnDate,
    P.ProductName,
    CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    S.StoreName,
    R.QuantityReturned,
    ROUND(R.RefundAmount,2) AS RefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
ORDER BY
    R.RefundAmount DESC,
    R.QuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 243 : High Value Returns Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 244 : Low Value Returns
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which returned products generated the lowest refund amounts?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Low-value returns are generally less impactful financially but often occur
more frequently. Monitoring these returns helps identify operational issues,
customer behavior patterns, and opportunities to reduce return processing
costs.

This KPI helps management:

• Monitor Frequent Small Refunds
• Identify Low-Cost Return Patterns
• Optimize Return Processing
• Improve Customer Experience
• Analyze Operational Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Return ID
• Return Date
• Product Name
• Customer Name
• Store Name
• Quantity Returned
• Refund Amount

Results are sorted from lowest to highest refund amount.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    R.ReturnID,
    CAST(R.ReturnDate AS DATE) AS ReturnDate,
    P.ProductName,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    S.StoreName,
    R.QuantityReturned,
    ROUND(R.RefundAmount,2) AS RefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
ORDER BY
    R.RefundAmount ASC,
    R.QuantityReturned ASC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 244 : Low Value Returns Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 245 : Repeat Return Customers
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have returned products multiple times?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying repeat return customers helps businesses understand customer
behavior, evaluate return policies, and detect potential return abuse.

This KPI helps management:

• Identify Frequent Return Customers
• Improve Customer Satisfaction
• Detect Return Abuse
• Optimize Return Policies
• Support Customer Retention Strategies

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount

Only customers with more than one return transaction are displayed.

------------------------------------------------------------------------------*/

SELECT
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
GROUP BY
    CONCAT(C.FirstName,' ',C.LastName)
HAVING
    COUNT(R.ReturnID) > 1
ORDER BY
    TotalReturnTransactions DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 245 : Repeat Return Customers Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 246 : Return Analysis by Supplier
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which suppliers are associated with the highest number of returned products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Supplier-level return analysis helps identify suppliers whose products
generate excessive returns. This KPI supports supplier evaluation,
quality assurance, procurement decisions, and contract negotiations.

This KPI helps management:

• Evaluate Supplier Quality
• Identify High Return Suppliers
• Reduce Product Defects
• Improve Procurement Decisions
• Strengthen Supplier Relationships

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Supplier Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount

Results are sorted from highest to lowest returned products.

------------------------------------------------------------------------------*/

SELECT
    S.SupplierName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Supplier S
    ON P.SupplierID = S.SupplierID
GROUP BY
    S.SupplierName
ORDER BY
    TotalQuantityReturned DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 246 : Return Analysis by Supplier Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 247 : Product Return Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which products have the highest return rate based on items sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Return rate is a better indicator of product quality than total returns
because it considers sales volume. A product with fewer sales but many
returns may require immediate attention.

This KPI helps management:

• Evaluate Product Quality
• Compare Products Fairly
• Identify High-Risk Products
• Improve Customer Satisfaction
• Reduce Return Costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Product Name
• Quantity Sold
• Quantity Returned
• Return Rate (%)

Return Rate = (Returned Quantity / Sold Quantity) × 100

------------------------------------------------------------------------------*/

SELECT
    P.ProductName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ISNULL(SUM(R.QuantityReturned),0) AS TotalQuantityReturned,
    ROUND((CAST(ISNULL(SUM(R.QuantityReturned),0) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity),0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
GROUP BY
    P.ProductName
ORDER BY
    ReturnRatePercentage DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 247 : Product Return Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 248 : Category Return Rate
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which product categories have the highest return rate based on items sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Category return rate helps identify product groups with quality issues,
customer dissatisfaction, or fulfillment problems.

Unlike total returns, this KPI compares returned quantity against total
quantity sold, enabling fair comparison across categories.

This KPI helps management:

• Identify High-Risk Categories
• Improve Product Quality
• Reduce Return Costs
• Optimize Category Performance
• Improve Customer Satisfaction

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Category Name
• Quantity Sold
• Quantity Returned
• Return Rate (%)

Return Rate = (Returned Quantity / Sold Quantity) × 100

------------------------------------------------------------------------------
*/

SELECT
    C.CategoryName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ISNULL(SUM(R.QuantityReturned),0) AS TotalQuantityReturned,
    ROUND((CAST(ISNULL(SUM(R.QuantityReturned),0) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity),0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.SubCategory SC
    ON P.SubCategoryID = P.SubCategoryID
INNER JOIN Category C
	ON C.CategoryID = SC.CategoryID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
GROUP BY
    C.CategoryName
ORDER BY
    ReturnRatePercentage DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 248 : Category Return Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 249 : Brand Return Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which brands have the highest return rate based on items sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Brand return rate helps evaluate product quality and customer satisfaction
at the brand level. Unlike total returns, return rate considers total units
sold, enabling a fair comparison among brands.

This KPI helps management:

• Evaluate Brand Quality
• Identify High-Risk Brands
• Improve Supplier Performance
• Reduce Return Costs
• Support Brand Management Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Brand Name
• Quantity Sold
• Quantity Returned
• Return Rate (%)

Return Rate = (Returned Quantity / Sold Quantity) × 100

------------------------------------------------------------------------------*/

SELECT
    B.BrandName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ISNULL(SUM(R.QuantityReturned),0) AS TotalQuantityReturned,
    ROUND((CAST(ISNULL(SUM(R.QuantityReturned), 0) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity), 0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.Product P
    ON OI.ProductID = P.ProductID
INNER JOIN dbo.Brand B
    ON P.BrandID = B.BrandID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
GROUP BY
    B.BrandName
ORDER BY
    ReturnRatePercentage DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 249 : Brand Return Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 250 : Store Return Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores have the highest return rate based on items sold?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store return rate helps evaluate store performance by comparing returned
quantity against total quantity sold. This KPI identifies stores with
unusually high return rates, which may indicate issues related to sales,
product handling, inventory management, or customer service.

This KPI helps management:

• Compare Store Performance
• Identify High Return Stores
• Improve Store Operations
• Reduce Return Costs
• Enhance Customer Experience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Quantity Sold
• Quantity Returned
• Return Rate (%)

Return Rate = (Returned Quantity / Sold Quantity) × 100

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    SUM(OI.Quantity) AS TotalQuantitySold,
    ISNULL(SUM(R.QuantityReturned),0) AS TotalQuantityReturned,
    ROUND((CAST(ISNULL(SUM(R.QuantityReturned), 0) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity), 0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
GROUP BY
    S.StoreName
ORDER BY
    ReturnRatePercentage DESC,
    TotalQuantityReturned DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 250 : Store Return Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 251 : Customer Return Score
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers have the highest return score based on their return behavior?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Return Score measures customer return behavior by combining
return frequency, returned quantity, and refund amount.

Unlike simply counting returns, this KPI provides a more comprehensive
view of customers who contribute significantly to return operations.

This KPI helps management:

• Identify High Return Customers
• Detect Potential Return Abuse
• Improve Customer Segmentation
• Optimize Return Policies
• Support Customer Relationship Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Customer Return Score

Customer Return Score =
(Total Return Transactions × 0.4) + (Total Quantity Returned × 0.3) + (Total Refund Amount ÷ 1000 × 0.3)

------------------------------------------------------------------------------*/

SELECT
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND((COUNT(R.ReturnID) * 0.4) + (SUM(R.QuantityReturned) * 0.3) + (SUM(R.RefundAmount) / 1000.0 * 0.3),2) AS CustomerReturnScore
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
GROUP BY
    CONCAT(C.FirstName,' ',C.LastName)
ORDER BY
    CustomerReturnScore DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 251 : Customer Return Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 252 : Return Performance Summary
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall return performance of the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI provides an executive-level summary of return operations by
combining sales, returns, refund amount, and return rate into a single
performance report.

This KPI helps management:

• Monitor Overall Return Performance
• Measure Financial Impact of Returns
• Track Return Efficiency
• Evaluate Product Quality
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Products Sold
• Total Quantity Returned
• Total Return Transactions
• Total Refund Amount
• Overall Return Rate (%)

Overall Return Rate =
(Total Quantity Returned / Total Quantity Sold) × 100

------------------------------------------------------------------------------*/

SELECT
    SUM(OI.Quantity) AS TotalQuantitySold,
    ISNULL(SUM(R.QuantityReturned),0) AS TotalQuantityReturned,
    COUNT(DISTINCT R.ReturnID) AS TotalReturnTransactions,
    ROUND(ISNULL(SUM(R.RefundAmount), 0),2) AS TotalRefundAmount,
    ROUND((CAST(ISNULL(SUM(R.QuantityReturned), 0)AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity), 0)) * 100,2) AS OverallReturnRatePercentage
FROM dbo.OrderItem OI
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 252 : Return Performance Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 253 : Reverse Logistics Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is the overall reverse logistics process performing across stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Reverse logistics includes product returns, refunds, inspections, and
restocking activities. This KPI provides an operational summary to monitor
the efficiency of return processing across all stores.

This KPI helps management:

• Monitor Reverse Logistics Operations
• Compare Store Return Performance
• Measure Refund Impact
• Improve Return Processing Efficiency
• Optimize Inventory Recovery

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Average Refund per Return
• Overall Return Rate (%)

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundPerReturn,
    ROUND((CAST(SUM(R.QuantityReturned) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity),0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
GROUP BY
    S.StoreName
ORDER BY
    ReturnRatePercentage DESC,
    TotalRefundAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 253 : Reverse Logistics Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 254 : Return Performance Dashboard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does return performance compare across stores in terms of returns,
refunds, customers, and products?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI provides a consolidated dashboard-ready dataset for measuring
overall return performance at the store level.

It combines operational and financial return metrics into one report,
making it suitable for executive dashboards.

This KPI helps management:

• Compare Return Performance Across Stores
• Monitor Refund Costs
• Analyze Customer Return Activity
• Evaluate Product Return Volume
• Support Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Return Transactions
• Customers Returning Products
• Products Returned
• Quantity Returned
• Total Refund Amount
• Average Refund Amount
• Return Rate (%)

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(DISTINCT R.ReturnID) AS TotalReturnTransactions,
    COUNT(DISTINCT O.CustomerID) AS CustomersWithReturns,
    COUNT(DISTINCT OI.ProductID) AS ProductsReturned,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundAmount,
    ROUND((CAST(SUM(R.QuantityReturned) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity),0)) * 100,2) AS ReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
WHERE R.ReturnID IS NOT NULL
GROUP BY
    S.StoreName
ORDER BY
    TotalRefundAmount DESC,
    ReturnRatePercentage DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 254 : Return Performance Dashboard Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 255 : Return Executive Scorecard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What are the overall return KPIs that executives should monitor to evaluate
business performance?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI serves as the executive summary for the entire Return Analysis
module. It consolidates the most important return metrics into a single
scorecard suitable for executive dashboards.

This KPI helps management:

• Monitor Overall Return Performance
• Measure Financial Impact
• Evaluate Customer Return Activity
• Track Product Return Volume
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Return Transactions
• Total Quantity Returned
• Total Refund Amount
• Average Refund per Return
• Customers with Returns
• Products Returned
• Overall Return Rate (%)

------------------------------------------------------------------------------*/

SELECT
    COUNT(DISTINCT R.ReturnID) AS TotalReturnTransactions,
    SUM(R.QuantityReturned) AS TotalQuantityReturned,
    ROUND(SUM(R.RefundAmount),2) AS TotalRefundAmount,
    ROUND(AVG(R.RefundAmount),2) AS AvgRefundPerReturn,
    COUNT(DISTINCT O.CustomerID) AS CustomersWithReturns,
    COUNT(DISTINCT OI.ProductID) AS ProductsReturned,
    ROUND((CAST(SUM(R.QuantityReturned) AS DECIMAL(18,2)) / NULLIF(SUM(OI.Quantity),0)) * 100,2) AS OverallReturnRatePercentage
FROM dbo.OrderItem OI
INNER JOIN dbo.[Order] O
    ON OI.OrderID = O.OrderID
LEFT JOIN dbo.[Return] R
    ON OI.OrderItemID = R.OrderItemID
WHERE R.ReturnID IS NOT NULL;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 255 : Return Executive Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';
