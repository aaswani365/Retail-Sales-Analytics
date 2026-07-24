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