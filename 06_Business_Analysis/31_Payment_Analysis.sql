/*------------------------------------------------------------------------------
KPI 256 : Payment Overview
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall payment performance of the business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Overview provides a high-level summary of payment transactions,
collections, and payment processing performance. It gives management an
instant snapshot of payment activity across all payment statuses.

This KPI helps management:

• Monitor Overall Payment Activity
• Measure Payment Collections
• Evaluate Payment Processing Efficiency
• Compare Successful vs Pending vs Failed Payments
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Payment Transactions
• Total Payment Amount
• Average Payment Amount
• Successful Payments
• Pending Payments
• Failed Payments
• Refund Payments
• Cancelled Payments

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    SUM(
        CASE
            WHEN PS.StatusName = 'Completed' THEN 1
			ELSE 0
        END
    ) AS SuccessfulPayments,
    SUM(
        CASE
            WHEN PS.StatusName = 'Pending' THEN 1
            ELSE 0
        END
    ) AS PendingPayments,
    SUM(
        CASE
            WHEN PS.StatusName = 'Failed' THEN 1
            ELSE 0
        END
    ) AS FailedPayments,
	SUM(
        CASE
            WHEN PS.StatusName = 'Refunded' THEN 1
            ELSE 0
        END
    ) AS RefundedPayments,
	SUM(
        CASE
            WHEN PS.StatusName = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS CancelledPayments
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 256 : Payment Overview Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 257 : Total Payments Received
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much payment has been successfully collected from customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI measures the total value of completed payment transactions.
Only completed payments are considered because they represent actual
revenue collected by the business.

This KPI helps management:

• Measure Revenue Collection
• Monitor Cash Flow
• Evaluate Payment Success
• Track Collection Performance
• Support Financial Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Completed Payment Transactions
• Total Payments Received
• Average Payment Amount

Only payments with the status 'Completed' are included.

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ISNULL(ROUND(SUM(P.Amount),2),0) AS TotalPaymentsReceived,
    ISNULL(ROUND(AVG(P.Amount),2),0) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 257 : Total Payments Received Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 258 : Payment by Payment Method
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which payment methods are used the most, and how much revenue does each
payment method contribute?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding customer payment preferences helps businesses optimize payment
processing, negotiate payment gateway costs, and promote preferred payment
channels.

This KPI helps management:

• Identify Popular Payment Methods
• Measure Revenue by Payment Method
• Promote Digital Payments
• Optimize Transaction Costs
• Improve Customer Experience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Method
• Total Payment Transactions
• Total Payment Amount
• Average Payment Amount

Results are sorted from highest to lowest payment amount.

------------------------------------------------------------------------------*/

SELECT
    PM.MethodName AS PaymentMethod,
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    PM.MethodName
ORDER BY
    TotalPaymentAmount DESC,
    TotalPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 258 : Payment by Payment Method Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 259 : Payment Status Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are payment transactions distributed across different payment statuses?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Status Analysis helps businesses monitor the health of their payment
processing system by tracking completed, pending, failed, refunded, and
cancelled transactions.

This KPI helps management:

• Monitor Payment Processing
• Identify Failed Transactions
• Track Pending Payments
• Evaluate Payment Success Rate
• Improve Financial Operations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Status
• Total Transactions
• Total Payment Amount
• Average Payment Amount
• Percentage of Total Transactions

Results are sorted by transaction count.

------------------------------------------------------------------------------*/

SELECT
    PS.StatusName AS PaymentStatus,
    COUNT(P.PaymentID) AS TotalTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((COUNT(P.PaymentID) * 100.0) / SUM(COUNT(P.PaymentID)) OVER (),2) AS TransactionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
GROUP BY
    PS.StatusName
ORDER BY
    TotalTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 259 : Payment Status Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 260 : Completed Payments
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many payment transactions have been successfully completed, and what
revenue has been collected from them?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Completed payments represent actual revenue collected by the business.
Monitoring completed transactions helps evaluate payment success, cash flow,
and operational efficiency.

This KPI helps management:

• Measure Successfully Collected Revenue
• Monitor Payment Completion Rate
• Evaluate Payment Processing Efficiency
• Support Financial Reporting
• Track Business Cash Flow

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Completed Payment Transactions
• Total Revenue Collected
• Average Payment Amount
• Minimum Payment Amount
• Maximum Payment Amount

Only payments with the status 'Completed' are included.

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalRevenueCollected,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND(MIN(P.Amount),2) AS MinimumPaymentAmount,
    ROUND(MAX(P.Amount),2) AS MaximumPaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 260 : Completed Payments Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 261 : Pending Payments
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many payment transactions are currently pending, and what is their
financial value?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Pending payments represent revenue that has not yet been collected.
Monitoring pending transactions helps businesses improve collection
efficiency, reduce payment delays, and manage cash flow effectively.

This KPI helps management:

• Monitor Outstanding Payments
• Improve Collection Efficiency
• Identify Payment Delays
• Forecast Expected Cash Inflow
• Support Financial Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Pending Payment Transactions
• Total Pending Amount
• Average Pending Payment
• Minimum Pending Payment
• Maximum Pending Payment

Only payments with the status 'Pending' are included.

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS PendingPaymentTransactions,
    ISNULL(ROUND(SUM(P.Amount),2),0) AS TotalPendingAmount,
    ISNULL(ROUND(AVG(P.Amount),2),0) AS AveragePendingPayment,
    ISNULL(ROUND(MIN(P.Amount),2),0) AS MinimumPendingPayment,
    ISNULL(ROUND(MAX(P.Amount),2),0) AS MaximumPendingPayment
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Pending';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 261 : Pending Payments Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 262 : Failed Payments
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many payment transactions failed, and what is the financial value of
those failed transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Failed payments represent lost sales opportunities and potential revenue
leakage. Monitoring failed payment transactions helps identify payment
gateway issues, customer payment failures, and operational bottlenecks.

This KPI helps management:

• Monitor Payment Failures
• Identify Revenue Leakage
• Improve Payment Success Rate
• Evaluate Payment Gateway Performance
• Enhance Customer Payment Experience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Failed Payment Transactions
• Total Failed Payment Amount
• Average Failed Payment
• Minimum Failed Payment
• Maximum Failed Payment

Only payments with the status 'Failed' are included.

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS FailedPaymentTransactions,
    ISNULL(ROUND(SUM(P.Amount),2),0) AS TotalFailedPaymentAmount,
    ISNULL(ROUND(AVG(P.Amount),2),0) AS AverageFailedPayment,
    ISNULL(ROUND(MIN(P.Amount),2),0) AS MinimumFailedPayment,
    ISNULL(ROUND(MAX(P.Amount),2),0) AS MaximumFailedPayment
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Failed';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 262 : Failed Payments Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 263 : Refunded Payments
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many payment transactions have been refunded, and what is the total
refund amount?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Refunded payments represent revenue that has been returned to customers.
Monitoring refunds helps evaluate return policies, customer satisfaction,
and the financial impact of product returns.

This KPI helps management:

• Monitor Refund Transactions
• Measure Revenue Reversed
• Evaluate Return Policies
• Improve Customer Satisfaction
• Support Financial Reconciliation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Refunded Payment Transactions
• Total Refunded Amount
• Average Refund Amount
• Minimum Refund Amount
• Maximum Refund Amount

Only payments with the status 'Refunded' are included.

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS RefundedPaymentTransactions,
    ISNULL(ROUND(SUM(P.Amount),2),0) AS TotalRefundedAmount,
    ISNULL(ROUND(AVG(P.Amount),2),0) AS AverageRefundAmount,
	ISNULL(ROUND(MIN(P.Amount),2),0) AS MinimumRefundAmount,
    ISNULL(ROUND(MAX(P.Amount),2),0) AS MaximumRefundAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Refunded';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 263 : Refunded Payments Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 265 : Payment Success Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of payment transactions are completed successfully?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Success Rate is one of the most important operational payment KPIs.
It measures the effectiveness of the payment process and highlights whether
customers are successfully completing their payments.

A low payment success rate may indicate:

• Payment Gateway Issues
• Customer Checkout Problems
• Bank Authorization Failures
• Technical Issues
• Poor Customer Experience

This KPI helps management:

• Monitor Payment Performance
• Evaluate Payment Gateway Reliability
• Improve Checkout Experience
• Increase Revenue Collection
• Reduce Failed Transactions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Payment Transactions
• Completed Payment Transactions
• Payment Success Rate (%)

Payment Success Rate =
(Completed Payments / Total Payments) × 100

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Completed' THEN 1
            ELSE 0
        END
    ) AS CompletedPaymentTransactions,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Completed' THEN 1
                    ELSE 0
                END
            ) * 100.0) / NULLIF(COUNT(P.PaymentID), 0),2) AS PaymentSuccessRatePercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 265 : Payment Success Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 266 : Payment Failure Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What percentage of payment transactions fail during processing?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Failure Rate measures the proportion of transactions that fail before
completion. A high failure rate may indicate technical issues, payment gateway
problems, banking failures, or customer payment difficulties.

This KPI helps management:

• Monitor Payment Reliability
• Identify Technical Issues
• Improve Customer Checkout Experience
• Reduce Revenue Leakage
• Evaluate Payment Gateway Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Payment Transactions
• Failed Payment Transactions
• Payment Failure Rate (%)

Payment Failure Rate =
(Failed Payments / Total Payments) × 100

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Failed' THEN 1
            ELSE 0
        END
    ) AS FailedPaymentTransactions,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Failed' THEN 1
                    ELSE 0
                END
            ) * 100.0) / NULLIF(COUNT(P.PaymentID), 0),2) AS PaymentFailureRatePercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 266 : Payment Failure Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 267 : Payment Collection Efficiency
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How efficiently is the business collecting payments from customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Collection Efficiency measures the percentage of order value that has
been successfully collected through completed payments.

A low collection efficiency may indicate:

• Pending Payments
• Failed Payments
• Cancelled Transactions
• Collection Delays

This KPI helps management:

• Measure Collection Performance
• Monitor Cash Flow
• Improve Revenue Realization
• Identify Outstanding Collections
• Support Financial Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Order Value
• Total Completed Payment Amount
• Payment Collection Efficiency (%)

Payment Collection Efficiency =
(Completed Payment Amount / Total Order Value) × 100

------------------------------------------------------------------------------*/

SELECT
    ROUND(SUM(O.NetAmount),2) AS TotalOrderValue,
    ROUND(SUM(
            CASE
                WHEN PS.StatusName = 'Completed' THEN P.Amount
                ELSE 0
            END),2) AS TotalCollectedAmount,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Completed' THEN P.Amount
                    ELSE 0
                END
            ) * 100.0) / NULLIF(SUM(O.NetAmount), 0),2) AS PaymentCollectionEfficiencyPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 267 : Payment Collection Efficiency Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 268 : Average Payment Processing Time
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much time does it take, on average, to process a payment after an order
is placed?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Processing Time measures the efficiency of the payment workflow.
Long processing times may indicate delays in payment gateways, banking
systems, or internal payment processing.

This KPI helps management:

• Measure Payment Processing Efficiency
• Improve Customer Experience
• Identify Processing Delays
• Optimize Payment Operations
• Monitor Operational Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Average Processing Time (Minutes)
• Minimum Processing Time (Minutes)
• Maximum Processing Time (Minutes)

Processing Time =
PaymentDate − OrderDate

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    ROUND(AVG(DATEDIFF(MINUTE,O.OrderDate,P.PaymentDate)),2) AS AvgProcessingTimeMinutes,
    MIN(DATEDIFF(MINUTE,O.OrderDate,P.PaymentDate)) AS MinimumProcessingTimeMinutes,
    MAX(DATEDIFF(MINUTE,O.OrderDate,P.PaymentDate)) AS MaximumProcessingTimeMinutes
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 268 : Average Payment Processing Time Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 269 : Payment Trend Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has payment collection changed over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Trend Analysis helps businesses monitor payment collection patterns
over time. It enables management to identify seasonal trends, abnormal
payment fluctuations, and overall business growth.

This KPI helps management:

• Monitor Payment Trends
• Analyze Daily Collections
• Identify Seasonal Patterns
• Support Financial Forecasting
• Improve Cash Flow Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Date
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    CAST(P.PaymentDate AS DATE) AS PaymentDate,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    CAST(P.PaymentDate AS DATE)
ORDER BY
    PaymentDate;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 269 : Payment Trend Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 270 : Payment Method Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which payment methods perform the best based on completed transactions,
revenue collected, and average payment value?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Method Performance helps evaluate the effectiveness of each payment
channel. It identifies which payment methods contribute the most revenue and
which methods customers prefer.

This KPI helps management:

• Evaluate Payment Method Performance
• Identify Preferred Payment Channels
• Increase Digital Payment Adoption
• Optimize Payment Infrastructure
• Reduce Transaction Costs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Method
• Completed Transactions
• Total Revenue Collected
• Average Payment Amount
• Revenue Contribution (%)

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    PM.MethodName AS PaymentMethod,
    COUNT(P.PaymentID) AS CompletedTransactions,
    ROUND(SUM(P.Amount),2) AS TotalRevenueCollected,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    PM.MethodName
ORDER BY
    TotalRevenueCollected DESC,
    CompletedTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 270 : Payment Method Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 271 : Store-wise Payment Collection
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores collect the highest payment revenue from completed transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-wise Payment Collection measures the payment performance of each store
by analyzing completed payment transactions. It helps management compare
stores based on revenue collection and payment activity.

This KPI helps management:

• Compare Store Collection Performance
• Identify High Revenue Stores
• Monitor Store Cash Flow
• Evaluate Store Operations
• Support Regional Performance Analysis

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount
• Revenue Contribution (%)

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    S.StoreName
ORDER BY
    TotalPaymentAmount DESC,
    CompletedPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 271 : Store-wise Payment Collection Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 272 : Employee-wise Payment Collection
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees have collected the highest payment revenue from completed
transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee-wise Payment Collection measures how effectively employees convert
sales into completed payments. This KPI helps evaluate employee performance
from a payment collection perspective.

This KPI helps management:

• Compare Employee Collection Performance
• Identify Top Revenue Collectors
• Evaluate Payment Handling Efficiency
• Support Employee Performance Reviews
• Improve Operational Productivity

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Name
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount
• Revenue Contribution (%)

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.Employee E
    ON O.EmployeeID = E.EmployeeID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    CONCAT(E.FirstName,' ',E.LastName)
ORDER BY
    TotalPaymentAmount DESC,
    CompletedPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 272 : Employee-wise Payment Collection Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 273 : Customer Payment Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which customers contribute the highest payment revenue through completed
transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Customer Payment Analysis identifies high-value customers based on completed
payments. It helps businesses understand customer purchasing behaviour,
prioritize valuable customers, and support customer retention strategies.

This KPI helps management:

• Identify High-Value Customers
• Measure Customer Revenue Contribution
• Support Loyalty Programs
• Improve Customer Segmentation
• Increase Customer Lifetime Value

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Customer Name
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount
• Revenue Contribution (%)

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    CONCAT(C.FirstName,' ',C.LastName)
ORDER BY
    TotalPaymentAmount DESC,
    CompletedPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 273 : Customer Payment Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 274 : Daily Payment Collection
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much payment revenue is collected each day from completed transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Daily Payment Collection helps businesses monitor cash inflow on a day-to-day
basis. It enables finance teams to identify collection trends, detect unusual
payment fluctuations, and support cash flow planning.

This KPI helps management:

• Monitor Daily Cash Collection
• Identify Revenue Trends
• Forecast Cash Flow
• Detect Collection Anomalies
• Support Financial Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Date
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    CAST(P.PaymentDate AS DATE) AS PaymentDate,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    CAST(P.PaymentDate AS DATE)
ORDER BY
    PaymentDate;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 274 : Daily Payment Collection Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 275 : Monthly Payment Collection
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much payment revenue is collected each month from completed transactions?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly Payment Collection provides a high-level view of revenue collection
performance over time. It helps management identify seasonal trends, monitor
business growth, and support financial forecasting.

This KPI helps management:

• Monitor Monthly Cash Collection
• Identify Seasonal Trends
• Compare Monthly Performance
• Support Financial Forecasting
• Measure Business Growth

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Year
• Month
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    YEAR(P.PaymentDate) AS PaymentYear,
    MONTH(P.PaymentDate) AS PaymentMonth,
    DATENAME(MONTH, P.PaymentDate) AS MonthName,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    YEAR(P.PaymentDate),
    MONTH(P.PaymentDate),
    DATENAME(MONTH, P.PaymentDate)
ORDER BY
    PaymentYear,
    PaymentMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 275 : Monthly Payment Collection Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 276 : Payment Collection by Weekday
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

On which days of the week does the business receive the highest payment
collections?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Weekly payment patterns help businesses understand customer purchasing
behaviour and optimize staffing, payment infrastructure, and financial
operations.

This KPI helps management:

• Identify Peak Collection Days
• Optimize Store Operations
• Improve Workforce Planning
• Support Financial Forecasting
• Understand Customer Behaviour

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Weekday
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    DATEPART(WEEKDAY, P.PaymentDate) AS WeekdayNumber,
    DATENAME(WEEKDAY, P.PaymentDate) AS WeekdayName,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    DATEPART(WEEKDAY, P.PaymentDate),
    DATENAME(WEEKDAY, P.PaymentDate)
ORDER BY
    WeekdayNumber;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 276 : Payment Collection by Weekday Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 277 : Payment Method Success Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which payment methods have the highest payment success rate?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Different payment methods may perform differently due to gateway reliability,
bank processing, customer preferences, or technical issues.

This KPI helps management:

• Evaluate Payment Gateway Performance
• Identify Reliable Payment Methods
• Reduce Payment Failures
• Improve Customer Checkout Experience
• Optimize Digital Payment Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Method
• Total Payment Transactions
• Completed Payments
• Payment Success Rate (%)

Payment Success Rate =
(Completed Payments / Total Payment Transactions) × 100

------------------------------------------------------------------------------*/

SELECT
    PM.MethodName AS PaymentMethod,
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Completed' THEN 1
            ELSE 0
        END
    ) AS CompletedPaymentTransactions,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Completed' THEN 1
                    ELSE 0
                END) * 100.0) / NULLIF(COUNT(P.PaymentID), 0),2) AS PaymentSuccessRatePercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
GROUP BY
    PM.MethodName
ORDER BY
    PaymentSuccessRatePercentage DESC,
    TotalPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 277 : Payment Method Success Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 278 : Average Order Payment Value
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the average payment amount collected per completed order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Order Payment Value measures the average revenue collected from each
completed order. It helps evaluate customer spending patterns and overall
transaction value.

This KPI helps management:

• Measure Customer Spending
• Monitor Revenue Quality
• Compare Order Values
• Support Pricing Strategies
• Evaluate Sales Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Completed Orders
• Total Payments Received
• Average Order Payment Value

Average Order Payment Value =
Total Completed Payment Amount / Total Completed Orders

------------------------------------------------------------------------------*/

SELECT
    COUNT(DISTINCT P.OrderID) AS CompletedOrders,
    ROUND(SUM(P.Amount),2) AS TotalPaymentsReceived,
    ROUND(SUM(P.Amount) / NULLIF(COUNT(DISTINCT P.OrderID), 0),2) AS AverageOrderPaymentValue
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed';

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 278 : Average Order Payment Value Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 279 : Payment Method Revenue Contribution
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much revenue does each payment method contribute to the total completed
payment collection?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI measures the percentage contribution of each payment method towards
the business's total collected revenue.

Understanding revenue contribution helps businesses:

• Promote High Performing Payment Methods
• Negotiate Payment Gateway Charges
• Increase Digital Payment Adoption
• Optimize Payment Infrastructure
• Improve Customer Convenience

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Method
• Completed Transactions
• Total Revenue Collected
• Revenue Contribution (%)

Revenue Contribution =
(Payment Method Revenue / Total Completed Revenue) × 100

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    PM.MethodName AS PaymentMethod,
    COUNT(P.PaymentID) AS CompletedTransactions,
    ROUND(SUM(P.Amount),2) AS TotalRevenueCollected,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    PM.MethodName
ORDER BY
    RevenueContributionPercentage DESC,
    TotalRevenueCollected DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 279 : Payment Method Revenue Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 280 : Payment Status Revenue Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is the total payment value distributed across different payment statuses?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Payment Status Revenue Analysis helps businesses understand how much revenue
has been successfully collected, is pending, has failed, has been refunded,
or has been cancelled.

This KPI helps management:

• Monitor Revenue by Payment Status
• Measure Revenue at Risk
• Track Refund Impact
• Improve Collection Performance
• Support Financial Reconciliation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Status
• Total Transactions
• Total Payment Amount
• Average Payment Amount
• Revenue Contribution (%)

Revenue Contribution =
(Payment Status Amount / Total Payment Amount) × 100

------------------------------------------------------------------------------*/

SELECT
    PS.StatusName AS PaymentStatus,
    COUNT(P.PaymentID) AS TotalTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
GROUP BY
    PS.StatusName
ORDER BY
    TotalPaymentAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 280 : Payment Status Revenue Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 281 : Store-wise Payment Success Rate
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which stores have the highest payment success rate?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-wise Payment Success Rate measures the percentage of payment
transactions that are successfully completed at each store.

A low success rate may indicate:

• Store-specific operational issues
• Payment terminal problems
• Network or gateway failures
• Customer payment difficulties

This KPI helps management:

• Compare Store Performance
• Monitor Payment Reliability
• Identify Underperforming Stores
• Improve Customer Experience
• Optimize Store Operations

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Name
• Total Payment Transactions
• Completed Payment Transactions
• Payment Success Rate (%)

Payment Success Rate =
(Completed Payments / Total Payment Transactions) × 100

------------------------------------------------------------------------------*/

SELECT
    S.StoreName,
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Completed' THEN 1
            ELSE 0
        END
    ) AS CompletedPaymentTransactions,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Completed' THEN 1
                    ELSE 0
                END ) * 100.0) / NULLIF(COUNT(P.PaymentID), 0),2) AS PaymentSuccessRatePercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.Store S
    ON O.StoreID = S.StoreID
GROUP BY
    S.StoreName
ORDER BY
    PaymentSuccessRatePercentage DESC,
    TotalPaymentTransactions DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 281 : Store-wise Payment Success Rate Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 282 : Monthly Payment Growth
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has completed payment revenue changed month-over-month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly Payment Growth measures changes in collected revenue between months.
It helps identify business growth, seasonal demand, and periods of declining
or increasing payment collections.

This KPI helps management:

• Measure Revenue Growth
• Compare Monthly Performance
• Identify Seasonal Trends
• Support Financial Forecasting
• Monitor Business Growth

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Year
• Payment Month
• Total Completed Payment Amount
• Previous Month Payment Amount
• Monthly Growth (%)

Monthly Growth (%) =
((Current Month - Previous Month) / Previous Month) × 100

Only completed payments are included.

------------------------------------------------------------------------------*/

WITH MonthlyPayments AS
(
    SELECT
        YEAR(P.PaymentDate) AS PaymentYear,
        MONTH(P.PaymentDate) AS PaymentMonth,
        ROUND(SUM(P.Amount),2) AS TotalPaymentAmount
    FROM dbo.Payment P
    INNER JOIN dbo.PaymentStatus PS
        ON P.PaymentStatusID = PS.PaymentStatusID
    WHERE
        PS.StatusName = 'Completed'
    GROUP BY
        YEAR(P.PaymentDate),
        MONTH(P.PaymentDate)
)
SELECT
    PaymentYear,
    PaymentMonth,
    TotalPaymentAmount,
    LAG(TotalPaymentAmount) OVER (ORDER BY PaymentYear, PaymentMonth) AS PreviousMonthPaymentAmount,
    ROUND(((TotalPaymentAmount - LAG(TotalPaymentAmount) OVER(ORDER BY PaymentYear, PaymentMonth)) * 100.0) / 
		NULLIF(LAG(TotalPaymentAmount)OVER(ORDER BY PaymentYear, PaymentMonth),0),2) AS MonthlyGrowthPercentage
FROM MonthlyPayments
ORDER BY
    PaymentYear,
    PaymentMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 282 : Monthly Payment Growth Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 283 : High Value Payment Transactions
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which completed payment transactions represent the highest-value collections?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

High-value payment transactions contribute significantly to total revenue and
often involve premium customers or large purchases. Monitoring these
transactions helps identify key revenue sources and supports fraud monitoring
and VIP customer management.

This KPI helps management:

• Identify High-Value Transactions
• Monitor Premium Customer Purchases
• Support Fraud Detection
• Analyze Large Revenue Contributors
• Improve Executive Reporting

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query returns:

• Payment ID
• Payment Date
• Order Number
• Customer Name
• Payment Method
• Payment Amount

Only completed payments are included.

Results are sorted by highest payment amount.

------------------------------------------------------------------------------*/

SELECT
    P.PaymentID,
    CAST(P.PaymentDate AS DATE) AS PaymentDate,
    O.OrderNumber,
    CONCAT(C.FirstName,' ',C.LastName) AS CustomerName,
    PM.MethodName AS PaymentMethod,
    ROUND(P.Amount,2) AS PaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
INNER JOIN dbo.Customer C
    ON O.CustomerID = C.CustomerID
WHERE
    PS.StatusName = 'Completed'
ORDER BY
    P.Amount DESC,
    P.PaymentDate DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 283 : High Value Payment Transactions Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 284 : Digital vs Cash Payment Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the distribution of completed payment revenue between cash and digital
payment methods?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI measures customer adoption of digital payment methods compared to
traditional cash payments. It helps businesses understand payment behaviour,
reduce cash handling costs, and support digital transformation initiatives.

This KPI helps management:

• Measure Digital Payment Adoption
• Compare Cash vs Digital Revenue
• Monitor Customer Payment Preferences
• Reduce Cash Handling Costs
• Support Digital Business Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Payment Category
• Completed Payment Transactions
• Total Payment Amount
• Average Payment Amount
• Revenue Contribution (%)

Payment Categories:

• Cash
• Digital Payments
  - Credit Card
  - Debit Card
  - UPI
  - Net Banking
  - Digital Wallet
  - Gift Card
  - EMI

Only completed payments are included.

------------------------------------------------------------------------------*/

SELECT
    CASE
        WHEN PM.MethodName = 'Cash' THEN 'Cash'
        ELSE 'Digital Payment'
    END AS PaymentCategory,
    COUNT(P.PaymentID) AS CompletedPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(AVG(P.Amount),2) AS AveragePaymentAmount,
    ROUND((SUM(P.Amount) * 100.0) / SUM(SUM(P.Amount)) OVER (),2) AS RevenueContributionPercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
WHERE
    PS.StatusName = 'Completed'
GROUP BY
    CASE
        WHEN PM.MethodName = 'Cash' THEN 'Cash'
        ELSE 'Digital Payment'
    END
ORDER BY
    TotalPaymentAmount DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 284 : Digital vs Cash Payment Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 285 : Payment Executive Scorecard
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall payment performance of the business in a single executive
dashboard?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The Payment Executive Scorecard consolidates the most important payment KPIs
into a single result set for executive reporting. It provides leadership with
an instant overview of payment operations, revenue collection, and payment
performance.

This KPI helps management:

• Monitor Overall Payment Performance
• Measure Revenue Collection
• Evaluate Payment Success
• Track Pending and Failed Payments
• Support Executive Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Payment Transactions
• Completed Payment Transactions
• Pending Payment Transactions
• Failed Payment Transactions
• Refunded Payment Transactions
• Cancelled Payment Transactions
• Total Payment Amount
• Total Completed Payment Amount
• Payment Success Rate (%)

------------------------------------------------------------------------------*/

SELECT
    COUNT(P.PaymentID) AS TotalPaymentTransactions,
    SUM(CASE
            WHEN PS.StatusName = 'Completed' THEN 1
            ELSE 0
        END
    ) AS CompletedPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Pending' THEN 1
            ELSE 0
        END
    ) AS PendingPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Failed' THEN 1
            ELSE 0
        END
    ) AS FailedPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Refunded' THEN 1
            ELSE 0
        END
    ) AS RefundedPaymentTransactions,
    SUM(
        CASE
            WHEN PS.StatusName = 'Cancelled' THEN 1
            ELSE 0
        END
    ) AS CancelledPaymentTransactions,
    ROUND(SUM(P.Amount),2) AS TotalPaymentAmount,
    ROUND(SUM(
            CASE
                WHEN PS.StatusName = 'Completed' THEN P.Amount
                ELSE 0
            END
        ),
        2
    ) AS TotalCollectedAmount,
    ROUND((SUM(
                CASE
                    WHEN PS.StatusName = 'Completed' THEN 1
                    ELSE 0
                END) * 100.0) / NULLIF(COUNT(P.PaymentID), 0),2) AS PaymentSuccessRatePercentage
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 285 : Payment Executive Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';