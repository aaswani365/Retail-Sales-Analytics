/*==============================================================================
Project Name  : Retail Sales Analytics & Inventory Management System

File Name     : 10_Generate_Returns.sql

Author        : Akshay Aswani

Created Date  : July 2026

Description   :
    Generates realistic Return transaction data for the Retail Sales
    Analytics & Inventory Management System.

Business Rules:
    - Approximately 10% of Order Items are returned.
    - Return Quantity cannot exceed Purchased Quantity.
    - Refund Amount is calculated proportionally.
    - Return Date is generated between 1 and 30 days after Payment Date.
    - Return Date cannot be greater than the current system date.
    - Return Reasons are randomly selected from the master table.
    - Return Statuses follow a realistic business distribution.
    - One Return record per Order Item.

Execution Order:
    01_Create_Database.sql
    02_Create_Tables.sql
    03_Create_Constraints.sql
    04_Create_Indexes.sql
    05_Index_Validation.sql
    06_Generate_Employees.sql
    07_Generate_Orders.sql
    08_Generate_OrderItems.sql
    09_Generate_Payments.sql
    10_Generate_Returns.sql

==============================================================================*/

/*==============================================================================
                    Part 2 : Variables
==============================================================================*/

------------------------------------------------------------
-- Execution Timer
------------------------------------------------------------

DECLARE @StartTime DATETIME2 = SYSDATETIME();

------------------------------------------------------------
-- Return Variables
------------------------------------------------------------

DECLARE @OrderItemID            INT;
DECLARE @OrderID                INT;
DECLARE @PaymentDate            DATETIME2;

DECLARE @ReturnReasonID         INT;
DECLARE @ReturnStatusID         INT;

DECLARE @ReturnDate             DATETIME2;

DECLARE @QuantityPurchased      INT;
DECLARE @QuantityReturned       INT;

DECLARE @LineTotal              DECIMAL(12,2);
DECLARE @RefundAmount           DECIMAL(12,2);

DECLARE @Remarks                VARCHAR(255);

------------------------------------------------------------
-- Randomization Variables
------------------------------------------------------------

DECLARE @RandomNumber           INT;
DECLARE @ReturnDelayDays        INT;
DECLARE @ReturnProbability      INT;

------------------------------------------------------------
-- Return Reason Variables
------------------------------------------------------------

DECLARE @DamagedReasonID        INT;
DECLARE @DefectiveReasonID      INT;
DECLARE @WrongItemReasonID      INT;
DECLARE @MissingPartsReasonID   INT;
DECLARE @QualityIssueReasonID   INT;
DECLARE @ChangedMindReasonID    INT;
DECLARE @IncorrectSizeReasonID  INT;
DECLARE @LateDeliveryReasonID   INT;
DECLARE @DuplicateOrderReasonID INT;
DECLARE @OtherReasonID          INT;

------------------------------------------------------------
-- Return Status Variables
------------------------------------------------------------

DECLARE @RequestedStatusID      INT;
DECLARE @ApprovedStatusID       INT;
DECLARE @RejectedStatusID       INT;
DECLARE @ReceivedStatusID       INT;
DECLARE @RefundedStatusID       INT;

/*==============================================================================
                    Part 3 : Data Cleanup
==============================================================================*/

------------------------------------------------------------
-- Remove Existing Return Data
------------------------------------------------------------

DELETE FROM dbo.[Return];

DBCC CHECKIDENT
(
    'dbo.[Return]',
    RESEED,
    0
);

PRINT '==============================================================';
PRINT 'Previous Return data cleared successfully.';
PRINT '==============================================================';

------------------------------------------------------------
-- Drop Temporary Tables (if they exist)
------------------------------------------------------------

DROP TABLE IF EXISTS #OrderItems;
DROP TABLE IF EXISTS #ReturnReasons;
DROP TABLE IF EXISTS #ReturnStatus;

PRINT '==============================================================';
PRINT 'Temporary tables dropped successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 4 : Load Reference Data
==============================================================================*/

/*------------------------------------------------------------
                Part 4.1 : Load Order Items
------------------------------------------------------------*/

------------------------------------------------------------
-- Temporary Table
------------------------------------------------------------

CREATE TABLE #OrderItems
(
    OrderItemID        INT,
    OrderID            INT,
    PaymentDate        DATETIME2,
    Quantity           INT,
    LineTotal          DECIMAL(12,2)
);

------------------------------------------------------------
-- Load Order Item Data
------------------------------------------------------------

INSERT INTO #OrderItems
(
    OrderItemID,
    OrderID,
    PaymentDate,
    Quantity,
    LineTotal
)
SELECT
    OI.OrderItemID,
    OI.OrderID,
    P.PaymentDate,
    OI.Quantity,
    OI.LineTotal
FROM dbo.OrderItem OI
INNER JOIN dbo.Payment P
    ON OI.OrderID = P.OrderID;

------------------------------------------------------------
-- Validation
------------------------------------------------------------

DECLARE @TotalOrderItems INT;

SELECT @TotalOrderItems = COUNT(*)
FROM #OrderItems;

PRINT CONCAT
(
    'Order Items Loaded : ',
    @TotalOrderItems
);

PRINT 'Order Items loaded successfully.';

/*------------------------------------------------------------
                Part 4.2 : Load Return Reasons
------------------------------------------------------------*/

------------------------------------------------------------
-- Temporary Table
------------------------------------------------------------

CREATE TABLE #ReturnReasons
(
    ReturnReasonID    INT,
    ReasonName        VARCHAR(100)
);

------------------------------------------------------------
-- Load Return Reasons
------------------------------------------------------------

INSERT INTO #ReturnReasons
(
    ReturnReasonID,
    ReasonName
)
SELECT
    ReturnReasonID,
    ReasonName
FROM dbo.ReturnReason
WHERE IsActive = 1;

DECLARE @TotalReturnReasons INT;

SELECT @TotalReturnReasons = COUNT(*)
FROM #ReturnReasons;

PRINT CONCAT
(
    'Return Reasons Loaded : ',
    @TotalReturnReasons
);

------------------------------------------------------------
-- Load Return Reason IDs
------------------------------------------------------------

SELECT @DamagedReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Damaged Product';

SELECT @DefectiveReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Defective Product';

SELECT @WrongItemReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Wrong Item Delivered';

SELECT @MissingPartsReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Missing Parts';

SELECT @QualityIssueReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Quality Issue';

SELECT @ChangedMindReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Changed Mind';

SELECT @IncorrectSizeReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Incorrect Size';

SELECT @LateDeliveryReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Late Delivery';

SELECT @DuplicateOrderReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Duplicate Order';

SELECT @OtherReasonID = ReturnReasonID
FROM #ReturnReasons
WHERE ReasonName = 'Other';

PRINT 'Return Reasons loaded successfully.';

/*------------------------------------------------------------
                Part 4.3 : Load Return Status
------------------------------------------------------------*/

------------------------------------------------------------
-- Temporary Table
------------------------------------------------------------

CREATE TABLE #ReturnStatus
(
    ReturnStatusID    INT,
    StatusName        VARCHAR(100)
);

------------------------------------------------------------
-- Load Return Status
------------------------------------------------------------

INSERT INTO #ReturnStatus
(
    ReturnStatusID,
    StatusName
)
SELECT
    ReturnStatusID,
    StatusName
FROM dbo.ReturnStatus
WHERE IsActive = 1;

DECLARE @TotalReturnStatus INT;

SELECT @TotalReturnStatus = COUNT(*)
FROM #ReturnStatus;

PRINT CONCAT
(
    'Return Status Loaded : ',
    @TotalReturnStatus
);

------------------------------------------------------------
-- Load Return Status IDs
------------------------------------------------------------

SELECT @RequestedStatusID = ReturnStatusID
FROM #ReturnStatus
WHERE StatusName = 'Requested';

SELECT @ApprovedStatusID = ReturnStatusID
FROM #ReturnStatus
WHERE StatusName = 'Approved';

SELECT @RejectedStatusID = ReturnStatusID
FROM #ReturnStatus
WHERE StatusName = 'Rejected';

SELECT @ReceivedStatusID = ReturnStatusID
FROM #ReturnStatus
WHERE StatusName = 'Received';

SELECT @RefundedStatusID = ReturnStatusID
FROM #ReturnStatus
WHERE StatusName = 'Refunded';

PRINT 'Return Status loaded successfully.';

/*==============================================================================
                    Part 5 : Return Generation
==============================================================================*/

/*------------------------------------------------------------
                Part 5.1 : OrderItem Processing Loop
------------------------------------------------------------*/

------------------------------------------------------------
-- OrderItem Cursor
------------------------------------------------------------

DECLARE OrderItemCursor CURSOR FAST_FORWARD
FOR
SELECT
    OrderItemID,
    OrderID,
    PaymentDate,
    Quantity,
    LineTotal
FROM #OrderItems
ORDER BY OrderItemID;

OPEN OrderItemCursor;

FETCH NEXT FROM OrderItemCursor
INTO
    @OrderItemID,
    @OrderID,
    @PaymentDate,
    @QuantityPurchased,
    @LineTotal;

WHILE @@FETCH_STATUS = 0
BEGIN

    /*------------------------------------------------------------
                Part 5.2 : Generate Return Details
	------------------------------------------------------------*/
	
	------------------------------------------------------------
	-- Generate Return Probability (1 - 100)
	------------------------------------------------------------
	
	SET @ReturnProbability =
		FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1;
	
	------------------------------------------------------------
	-- Skip Non-Returned Items
	------------------------------------------------------------
	
	IF @ReturnProbability <= 90
	BEGIN
	
		FETCH NEXT FROM OrderItemCursor
		INTO
			@OrderItemID,
			@OrderID,
			@PaymentDate,
			@QuantityPurchased,
			@LineTotal;
	
		CONTINUE;
	
	END
	
	------------------------------------------------------------
	-- Generate Quantity Returned
	------------------------------------------------------------
	
	IF @QuantityPurchased = 1
	BEGIN
		SET @QuantityReturned = 1;
	END
	ELSE
	BEGIN
		SET @QuantityReturned =
			FLOOR
			(
				RAND(CHECKSUM(NEWID()))
				* @QuantityPurchased
			) + 1;
	END;
	
	------------------------------------------------------------
	-- Calculate Refund Amount
	------------------------------------------------------------
	
	SET @RefundAmount =
	ROUND
	(
		(@LineTotal / @QuantityPurchased)
		* @QuantityReturned,
		2
	);
	
	------------------------------------------------------------
	-- Return Delay (1 - 30 Days)
	------------------------------------------------------------
	
	SET @ReturnDelayDays =
		FLOOR(RAND(CHECKSUM(NEWID())) * 30) + 1;
	
	SET @ReturnDate =
		DATEADD(DAY, @ReturnDelayDays, @PaymentDate);
	
	------------------------------------------------------------
	-- Prevent Future Return Date
	------------------------------------------------------------
	
	IF @ReturnDate > SYSDATETIME()
	BEGIN
		SET @ReturnDate = SYSDATETIME();
	END;
	
	------------------------------------------------------------
	-- Generate Random Number
	------------------------------------------------------------
	
	SET @RandomNumber =
		FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1;
	
	------------------------------------------------------------
	-- Select Return Status
	------------------------------------------------------------
	
	IF @RandomNumber <= 15
	BEGIN
		SET @ReturnStatusID = @RequestedStatusID;
	END
	ELSE IF @RandomNumber <= 40
	BEGIN
		SET @ReturnStatusID = @ApprovedStatusID;
	END
	ELSE IF @RandomNumber <= 45
	BEGIN
		SET @ReturnStatusID = @RejectedStatusID;
	END
	ELSE IF @RandomNumber <= 70
	BEGIN
		SET @ReturnStatusID = @ReceivedStatusID;
	END
	ELSE
	BEGIN
		SET @ReturnStatusID = @RefundedStatusID;
	END;
	
	------------------------------------------------------------
	-- Select Return Reason
	------------------------------------------------------------
	
	SET @RandomNumber =
		FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1;
	
	IF @RandomNumber <= 20
		SET @ReturnReasonID = @DamagedReasonID;
	ELSE IF @RandomNumber <= 35
		SET @ReturnReasonID = @DefectiveReasonID;
	ELSE IF @RandomNumber <= 45
		SET @ReturnReasonID = @WrongItemReasonID;
	ELSE IF @RandomNumber <= 53
		SET @ReturnReasonID = @MissingPartsReasonID;
	ELSE IF @RandomNumber <= 65
		SET @ReturnReasonID = @QualityIssueReasonID;
	ELSE IF @RandomNumber <= 80
		SET @ReturnReasonID = @ChangedMindReasonID;
	ELSE IF @RandomNumber <= 88
		SET @ReturnReasonID = @IncorrectSizeReasonID;
	ELSE IF @RandomNumber <= 93
		SET @ReturnReasonID = @LateDeliveryReasonID;
	ELSE IF @RandomNumber <= 95
		SET @ReturnReasonID = @DuplicateOrderReasonID;
	ELSE
		SET @ReturnReasonID = @OtherReasonID;
	
	------------------------------------------------------------
	-- Remarks
	------------------------------------------------------------
	
	SET @Remarks = NULL;
	



	/*------------------------------------------------------------
					Part 5.3 : Insert Return
	------------------------------------------------------------*/
	
	------------------------------------------------------------
	-- Insert Return
	------------------------------------------------------------
	
	INSERT INTO dbo.[Return]
	(
		OrderItemID,
		ReturnReasonID,
		ReturnStatusID,
		ReturnDate,
		QuantityReturned,
		RefundAmount,
		Remarks
	)
	VALUES
	(
		@OrderItemID,
		@ReturnReasonID,
		@ReturnStatusID,
		@ReturnDate,
		@QuantityReturned,
		@RefundAmount,
		@Remarks
	);
	
	------------------------------------------------------------
	-- Next Order Item
	------------------------------------------------------------
	
	FETCH NEXT FROM OrderItemCursor
	INTO
		@OrderItemID,
		@OrderID,
		@PaymentDate,
		@QuantityPurchased,
		@LineTotal;
	
	END

CLOSE OrderItemCursor;
DEALLOCATE OrderItemCursor;

PRINT '==============================================================';
PRINT 'Return Generation Completed Successfully.';
PRINT '==============================================================';


/*==============================================================================
                    Part 6 : Validation
==============================================================================*/

------------------------------------------------------------
-- Total Returns Generated
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalReturns
FROM dbo.[Return];

------------------------------------------------------------
-- Return Rate
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalReturns,
    (SELECT COUNT(*) FROM dbo.OrderItem) AS TotalOrderItems,
    CAST
    (
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM dbo.OrderItem)
        AS DECIMAL(5,2)
    ) AS ReturnPercentage
FROM dbo.[Return];

------------------------------------------------------------
-- Duplicate Returns
------------------------------------------------------------

SELECT
    OrderItemID,
    COUNT(*) AS TotalReturns
FROM dbo.[Return]
GROUP BY OrderItemID
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Return Status Distribution
------------------------------------------------------------

SELECT
    RS.StatusName,
    COUNT(*) AS TotalReturns
FROM dbo.[Return] R
INNER JOIN dbo.ReturnStatus RS
    ON R.ReturnStatusID = RS.ReturnStatusID
GROUP BY RS.StatusName
ORDER BY TotalReturns DESC;

------------------------------------------------------------
-- Return Reason Distribution
------------------------------------------------------------

SELECT
    RR.ReasonName,
    COUNT(*) AS TotalReturns
FROM dbo.[Return] R
INNER JOIN dbo.ReturnReason RR
    ON R.ReturnReasonID = RR.ReturnReasonID
GROUP BY RR.ReasonName
ORDER BY TotalReturns DESC;

------------------------------------------------------------
-- Quantity Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS InvalidQuantityReturned
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
WHERE R.QuantityReturned > OI.Quantity;

------------------------------------------------------------
-- Refund Amount Validation
------------------------------------------------------------

SELECT
    COUNT(*) AS InvalidRefundAmount
FROM dbo.[Return] R
INNER JOIN dbo.OrderItem OI
    ON R.OrderItemID = OI.OrderItemID
WHERE R.RefundAmount > OI.LineTotal;

------------------------------------------------------------
-- Sample Return Records
------------------------------------------------------------

SELECT TOP (10)
    ReturnID,
    OrderItemID,
    ReturnReasonID,
    ReturnStatusID,
    ReturnDate,
    QuantityReturned,
    RefundAmount
FROM dbo.[Return]
ORDER BY ReturnID;

PRINT '==============================================================';
PRINT 'Return Data Validation Completed Successfully.';
PRINT '==============================================================';

/*==============================================================================
                    Part 7 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT '10_Generate_Returns.sql executed successfully.';
PRINT 'Returns generated successfully.';
PRINT CONCAT
(
    'Execution Time : ',
    DATEDIFF(SECOND, @StartTime, SYSDATETIME()),
    ' Seconds'
);
PRINT '==============================================================';