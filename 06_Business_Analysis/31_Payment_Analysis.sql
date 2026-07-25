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

