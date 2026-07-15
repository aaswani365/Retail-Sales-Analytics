/*==============================================================================
Project     : Retail Sales Analytics & Inventory Management System

Script      : 09_Generate_Payments.sql

Purpose     : Generate realistic payment transactions for customer orders.

Description :
--------------
This script generates one payment record for each order.

Features:
- One payment per order
- Random payment method selection
- Random payment status selection
- Payment date based on Order Date
- Payment amount equals Order Net Amount
- Auto-generated transaction reference
- Validation queries
- Completion messages

Author      : Akshay Aswani
Created On  : July 2026

==============================================================================*/

/*==============================================================================
                    Part 2 : Variables
==============================================================================*/

------------------------------------------------------------
-- Order Variables
------------------------------------------------------------

DECLARE @OrderID               INT;
DECLARE @OrderDate             DATETIME2;
DECLARE @NetAmount             DECIMAL(12,2);

------------------------------------------------------------
-- Payment Variables
------------------------------------------------------------

DECLARE @PaymentMethodID       INT;
DECLARE @PaymentStatusID       INT;
DECLARE @PaymentDate           DATETIME2;
DECLARE @Amount                DECIMAL(12,2);
DECLARE @TransactionReference  VARCHAR(100);
DECLARE @Remarks               VARCHAR(255);

------------------------------------------------------------
-- Payment Status Variables
------------------------------------------------------------

DECLARE @PendingStatusID      INT;
DECLARE @CompletedStatusID    INT;
DECLARE @FailedStatusID       INT;
DECLARE @RefundedStatusID     INT;
DECLARE @CancelledStatusID    INT;

------------------------------------------------------------
-- Randomization Variables
------------------------------------------------------------

DECLARE @RandomNumber          INT;
DECLARE @PaymentDelayDays      INT;

------------------------------------------------------------
-- Execution Variables
------------------------------------------------------------

DECLARE @StartTime             DATETIME2 = SYSDATETIME();


/*==============================================================================
                    Part 3 : Data Cleanup
==============================================================================*/

------------------------------------------------------------
-- Delete Existing Payment Records
------------------------------------------------------------

DELETE FROM dbo.Payment;

------------------------------------------------------------
-- Reset Identity Seed
------------------------------------------------------------

DBCC CHECKIDENT ('dbo.Payment', RESEED, 0);

PRINT '==============================================================';
PRINT 'Previous Payment data cleared successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4.1 : Load Orders
==============================================================================*/

------------------------------------------------------------
-- Temporary Orders Table
------------------------------------------------------------

CREATE TABLE #Orders
(
    OrderID         INT PRIMARY KEY,
    OrderDate       DATETIME2,
    NetAmount       DECIMAL(12,2)
);

------------------------------------------------------------
-- Load Orders
------------------------------------------------------------

INSERT INTO #Orders
(
    OrderID,
    OrderDate,
    NetAmount
)
SELECT
    OrderID,
    OrderDate,
    NetAmount
FROM dbo.[Order]
WHERE NetAmount > 0;

PRINT CONCAT('Orders Loaded : ', @@ROWCOUNT);

------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalOrders
FROM #Orders;

PRINT 'Orders loaded successfully.';

/*==============================================================================
                    Part 4.2 : Load Payment Methods
==============================================================================*/

------------------------------------------------------------
-- Temporary Payment Methods Table
------------------------------------------------------------

CREATE TABLE #PaymentMethods
(
    PaymentMethodID     INT PRIMARY KEY,
    MethodName          VARCHAR(100)
);

------------------------------------------------------------
-- Load Payment Methods
------------------------------------------------------------

INSERT INTO #PaymentMethods
(
    PaymentMethodID,
    MethodName
)
SELECT
    PaymentMethodID,
    MethodName
FROM dbo.PaymentMethod;

PRINT CONCAT('Payment Methods Loaded : ', @@ROWCOUNT);

------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalPaymentMethods
FROM #PaymentMethods;

PRINT 'Payment Methods loaded successfully.';

/*==============================================================================
                    Part 4.3 : Load Payment Status
==============================================================================*/

------------------------------------------------------------
-- Temporary Payment Status Table
------------------------------------------------------------

CREATE TABLE #PaymentStatus
(
    PaymentStatusID      INT PRIMARY KEY,
    StatusName           VARCHAR(100)
);

------------------------------------------------------------
-- Load Payment Status
------------------------------------------------------------

INSERT INTO #PaymentStatus
(
    PaymentStatusID,
    StatusName
)
SELECT
    PaymentStatusID,
    StatusName
FROM dbo.PaymentStatus;

PRINT CONCAT('Payment Status Loaded : ', @@ROWCOUNT);



------------------------------------------------------------
-- Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalPaymentStatus
FROM #PaymentStatus;

PRINT 'Payment Status loaded successfully.';

------------------------------------------------------------
-- Load Payment Status IDs
------------------------------------------------------------

SELECT @PendingStatusID = PaymentStatusID
FROM #PaymentStatus
WHERE StatusName = 'Pending';

SELECT @CompletedStatusID = PaymentStatusID
FROM #PaymentStatus
WHERE StatusName = 'Completed';

SELECT @FailedStatusID = PaymentStatusID
FROM #PaymentStatus
WHERE StatusName = 'Failed';

SELECT @RefundedStatusID = PaymentStatusID
FROM #PaymentStatus
WHERE StatusName = 'Refunded';

SELECT @CancelledStatusID = PaymentStatusID
FROM #PaymentStatus
WHERE StatusName = 'Cancelled';

/*==============================================================================
                    Part 5.1 : Order Processing Loop
==============================================================================*/

------------------------------------------------------------
-- Order Cursor
------------------------------------------------------------

DECLARE OrderCursor CURSOR FAST_FORWARD
FOR
SELECT
    OrderID,
    OrderDate,
    NetAmount
FROM #Orders
ORDER BY OrderID;

OPEN OrderCursor;

FETCH NEXT FROM OrderCursor
INTO
    @OrderID,
    @OrderDate,
    @NetAmount;

WHILE @@FETCH_STATUS = 0
BEGIN

    
    /*------------------------------------------------------------
                Part 5.2 : Generate Payment Details
	------------------------------------------------------------*/
	
	------------------------------------------------------------
	-- Payment Amount
	------------------------------------------------------------
	
	SET @Amount = @NetAmount;
	
	------------------------------------------------------------
	-- Payment Delay (0 - 3 Days)
	------------------------------------------------------------
	
	------------------------------------------------------------
	-- Payment Date
	------------------------------------------------------------
	
	SET @PaymentDelayDays =
		FLOOR(RAND(CHECKSUM(NEWID())) * 4);
	
	SET @PaymentDate =
		DATEADD(DAY, @PaymentDelayDays, @OrderDate);
	
	IF @PaymentDate > SYSDATETIME()
	BEGIN
		SET @PaymentDate = SYSDATETIME();
	END
	
	------------------------------------------------------------
	-- Generate Random Number (1 - 100)
	------------------------------------------------------------
	
	SET @RandomNumber =
		FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1;
	
	------------------------------------------------------------
	-- Select Payment Method
	------------------------------------------------------------
	
	SELECT TOP (1)
		@PaymentMethodID = PaymentMethodID
	FROM #PaymentMethods
	ORDER BY NEWID();
	
	------------------------------------------------------------
	-- Select Payment Status
	------------------------------------------------------------
	
	IF @RandomNumber <= 88
	BEGIN
		SET @PaymentStatusID = @CompletedStatusID;
	END
	ELSE IF @RandomNumber <= 95
	BEGIN
		SET @PaymentStatusID = @PendingStatusID;
	END
	ELSE IF @RandomNumber <= 98
	BEGIN
		SET @PaymentStatusID = @FailedStatusID;
	END
	ELSE IF @RandomNumber <= 99
	BEGIN
		SET @PaymentStatusID = @RefundedStatusID;
	END
	ELSE
	BEGIN
		SET @PaymentStatusID = @CancelledStatusID;
	END
		
	------------------------------------------------------------
	-- Transaction Reference
	------------------------------------------------------------
	
	SET @TransactionReference =
		'PAY-' + REPLACE(CONVERT(VARCHAR(36), NEWID()), '-', '');
	
	------------------------------------------------------------
	-- Remarks
	------------------------------------------------------------
	
	SET @Remarks = NULL;
	

	/*------------------------------------------------------------
					Part 5.3 : Insert Payment
	------------------------------------------------------------*/
	
	------------------------------------------------------------
	-- Insert Payment
	------------------------------------------------------------
	
	INSERT INTO dbo.Payment
	(
		OrderID,
		PaymentMethodID,
		PaymentStatusID,
		PaymentDate,
		Amount,
		TransactionReference,
		Remarks
	)
	VALUES
	(
		@OrderID,
		@PaymentMethodID,
		@PaymentStatusID,
		@PaymentDate,
		@Amount,
		@TransactionReference,
		@Remarks
	);
	
	------------------------------------------------------------
	-- Next Order
	------------------------------------------------------------
	
	FETCH NEXT FROM OrderCursor
	INTO
		@OrderID,
		@OrderDate,
		@NetAmount;
	
	END
	
	CLOSE OrderCursor;
	DEALLOCATE OrderCursor;
	
	PRINT '==============================================================';
	PRINT 'Payment Generation Completed Successfully.';
	PRINT '==============================================================';
			
	
/*==============================================================================
                    Part 6 : Validation
==============================================================================*/

------------------------------------------------------------
-- Total Payments Generated
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalPayments
FROM dbo.Payment;

------------------------------------------------------------
-- Orders Without Payments
------------------------------------------------------------

SELECT
    COUNT(*) AS OrdersWithoutPayments
FROM dbo.[Order] O
LEFT JOIN dbo.Payment P
    ON O.OrderID = P.OrderID
WHERE P.OrderID IS NULL;

------------------------------------------------------------
-- Payment Status Distribution
------------------------------------------------------------

SELECT
    PS.StatusName,
    COUNT(*) AS TotalPayments
FROM dbo.Payment P
INNER JOIN dbo.PaymentStatus PS
    ON P.PaymentStatusID = PS.PaymentStatusID
GROUP BY
    PS.StatusName
ORDER BY
    TotalPayments DESC;

------------------------------------------------------------
-- Payment Method Distribution
------------------------------------------------------------

SELECT
    PM.MethodName,
    COUNT(*) AS TotalPayments
FROM dbo.Payment P
INNER JOIN dbo.PaymentMethod PM
    ON P.PaymentMethodID = PM.PaymentMethodID
GROUP BY
    PM.MethodName
ORDER BY
    TotalPayments DESC;

------------------------------------------------------------
-- Payment Amount Validation
------------------------------------------------------------

SELECT TOP (10)
    P.PaymentID,
    P.OrderID,
    O.NetAmount AS OrderAmount,
    P.Amount AS PaymentAmount
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
ORDER BY
    P.PaymentID;

------------------------------------------------------------
-- Sample Payment Records
------------------------------------------------------------

SELECT TOP (10)
    PaymentID,
    OrderID,
    PaymentMethodID,
    PaymentStatusID,
    PaymentDate,
    Amount,
    TransactionReference,
    Remarks
FROM dbo.Payment
ORDER BY
    PaymentID;
	
------------------------------------------------------------
-- Amount Mismatch Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS AmountMismatch
FROM dbo.Payment P
INNER JOIN dbo.[Order] O
    ON P.OrderID = O.OrderID
WHERE P.Amount <> O.NetAmount;

/*==============================================================================
                    Part 7 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '09_Generate_Payments.sql executed successfully.';
PRINT 'Payments generated successfully.';
PRINT CONCAT
(
    'Execution Time : ',
    DATEDIFF(SECOND, @StartTime, SYSDATETIME()),
    ' Seconds'
);
PRINT '==============================================================';