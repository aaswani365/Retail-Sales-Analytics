/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 07_Generate_Orders.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
------------
This script generates realistic customer orders for the Retail Sales Analytics
& Inventory Management System.

The generated data simulates daily retail transactions across multiple stores,
employees, and customers over a two-year period.

The script includes:
1. Random Customer Selection
2. Random Store Selection
3. Store-wise Employee Selection
4. Order Number Generation
5. Random Order Date Generation
6. Order Status Assignment
7. Order Header Creation

Business Rules:
---------------
- One order belongs to one customer.
- One order is handled by one employee.
- One order is placed at one store.
- Employees can only create orders for their assigned store.
- Order dates are generated within the last two years.
- Every order receives a unique business Order Number.
- Financial columns are initialized and updated after OrderItems are generated.
- Order status is assigned using realistic business probabilities.

==============================================================================*/

USE RetailSalesDB;
GO

PRINT 'Starting Order Data Generation...';
GO

/*==============================================================================
                    Section 1 : Configuration
==============================================================================

Description:
------------
Defines configurable values used during order generation.

Business Rules:
---------------
- Number of orders can be changed without modifying the generation logic.
- Order dates are generated within the configured date range.

==============================================================================*/

DECLARE @TotalOrders INT = 5000;

DECLARE @StartDate DATE = DATEADD(YEAR,-2,CAST(GETDATE() AS DATE));

DECLARE @EndDate DATE = CAST(GETDATE() AS DATE);

/*==============================================================================
                    Section 2 : Order Generation Variables
==============================================================================

Description:
------------
Declares variables used throughout the order generation process.

Business Rules:
---------------
- One customer per order.
- One store per order.
- One employee per order.
- One order status per order.
- Financial values are initialized to zero and updated after
  OrderItems are generated.

==============================================================================*/

------------------------------------------------------------
-- Loop Control
------------------------------------------------------------

DECLARE @Counter INT = 1;

------------------------------------------------------------
-- Order Information
------------------------------------------------------------

DECLARE @OrderNumber        VARCHAR(20);

DECLARE @OrderDate          DATETIME2;

------------------------------------------------------------
-- Customer Information
------------------------------------------------------------

DECLARE @CustomerID         INT;

------------------------------------------------------------
-- Store Information
------------------------------------------------------------

DECLARE @StoreID            INT;

------------------------------------------------------------
-- Employee Information
------------------------------------------------------------

DECLARE @EmployeeID         INT;

------------------------------------------------------------
-- Order Status
------------------------------------------------------------

DECLARE @OrderStatusID      INT;

------------------------------------------------------------
-- Financial Information
------------------------------------------------------------

DECLARE @SubTotalAmount     DECIMAL(12,2);

DECLARE @DiscountAmount     DECIMAL(12,2);

DECLARE @TaxAmount          DECIMAL(12,2);

DECLARE @NetAmount          DECIMAL(12,2);

------------------------------------------------------------
-- Remarks
------------------------------------------------------------

DECLARE @Remarks            VARCHAR(255);


/*==============================================================================
                    Section 3 : Order Status Probability
==============================================================================

Description:
------------
Assigns realistic order statuses using weighted business probabilities.

Business Rules:
---------------
- Delivered orders represent the majority of completed sales.
- Recently created orders are more likely to be Pending or Processing.
- Only a small percentage of orders are Cancelled or Returned.

==============================================================================*/

------------------------------------------------------------
-- Status Probability Variable
------------------------------------------------------------

DECLARE @StatusProbability INT;

/*==============================================================================
                    Section 4 : Generate Orders
==============================================================================

Description:
------------
Generates order header records by randomly selecting customers, stores,
employees and assigning realistic order dates and statuses.

Business Rules:
---------------
- Each order belongs to one customer.
- Each order is processed by one employee.
- Employees are selected only from their assigned store.
- Order numbers are unique.
- Financial values are initialized to zero and updated later
  after OrderItems are generated.

==============================================================================*/

WHILE @Counter <= @TotalOrders
BEGIN

/*==============================================================================
                Section 4.1 : Select Customer
==============================================================================

Description:
------------
Randomly selects one active customer for the current order.

Business Rules:
---------------
- Only active customers can place orders.
- Each order is associated with exactly one customer.
- Customer selection is completely random.

==============================================================================*/

------------------------------------------------------------
-- Select Random Customer
------------------------------------------------------------

SELECT TOP (1)

    @CustomerID = CustomerID

FROM dbo.Customer

WHERE IsActive = 1

ORDER BY NEWID();

/*==============================================================================
                Section 4.2 : Select Store
==============================================================================

Description:
------------
Randomly selects one active store for the current order.

Business Rules:
---------------
- Only active stores can process customer orders.
- Each order is associated with exactly one store.
- Store selection is completely random.

==============================================================================*/

------------------------------------------------------------
-- Select Random Store
------------------------------------------------------------

SELECT TOP (1)

    @StoreID = StoreID

FROM dbo.Store

WHERE IsActive = 1

ORDER BY NEWID();

/*==============================================================================
                Section 4.3 : Select Employee
==============================================================================

Description:
------------
Randomly selects one active employee from the selected store to process
the current customer order.

Business Rules:
---------------
- Only active employees can process orders.
- Employees can only process orders for their assigned store.
- Each order is associated with exactly one employee.

==============================================================================*/

------------------------------------------------------------
-- Select Random Employee
------------------------------------------------------------

SELECT TOP (1)

    @EmployeeID = EmployeeID

FROM dbo.Employee

WHERE StoreID = @StoreID
      AND IsActive = 1

ORDER BY NEWID();

/*==============================================================================
                Section 4.4 : Generate Order Date
==============================================================================

Description:
------------
Generates a random order date within the configured date range.

Business Rules:
---------------
- Order dates are generated between @StartDate and @EndDate.
- The generated date includes a random time component.
- Every order receives one unique OrderDate.

==============================================================================*/

------------------------------------------------------------
-- Generate Random Order Date
------------------------------------------------------------

SET @OrderDate =
DATEADD
(
    SECOND,
    ABS(CHECKSUM(NEWID())) % 86400,
    CAST
    (
        DATEADD
        (
            DAY,
            ABS(CHECKSUM(NEWID())) %
            (DATEDIFF(DAY,@StartDate,@EndDate)+1),
            @StartDate
        )
        AS DATETIME2
    )
);
	
/*==============================================================================
                Section 4.5 : Generate Order Number
==============================================================================

Description:
------------
Generates a unique business Order Number for each customer order.

Business Rules:
---------------
- Every order receives a unique Order Number.
- Order Number follows the format:
      ORD-YYYYXXXXXX
- YYYY represents the order year.
- XXXXXX is a sequential number padded with leading zeros.

==============================================================================*/

------------------------------------------------------------
-- Generate Order Number
------------------------------------------------------------

SET @OrderNumber =
    'ORD-' +
    CAST(YEAR(@OrderDate) AS VARCHAR(4)) +
    RIGHT('000000' + CAST(@Counter AS VARCHAR(6)), 6);
	
/*==============================================================================
                Section 4.6 : Assign Order Status
==============================================================================

Description:
------------
Assigns a realistic order status based on predefined business probabilities.

Business Rules:
---------------
- Delivered orders represent the majority of completed sales.
- Shipped and Processing orders represent orders currently in transit.
- Pending orders are awaiting processing.
- Cancelled and Returned orders occur less frequently.

Status Distribution:
--------------------
Delivered  : 70%
Shipped    : 12%
Processing : 8%
Pending    : 5%
Cancelled  : 3%
Returned   : 2%

==============================================================================*/

------------------------------------------------------------
-- Generate Status Probability
------------------------------------------------------------

SET @StatusProbability = ABS(CHECKSUM(NEWID())) % 100 + 1;

------------------------------------------------------------
-- Assign Order Status
------------------------------------------------------------

IF @StatusProbability <= 70
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Delivered';
END

ELSE IF @StatusProbability <= 82
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Shipped';
END

ELSE IF @StatusProbability <= 90
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Processing';
END

ELSE IF @StatusProbability <= 95
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Pending';
END

ELSE IF @StatusProbability <= 98
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Cancelled';
END

ELSE
BEGIN
    SELECT @OrderStatusID = OrderStatusID
    FROM dbo.OrderStatus
    WHERE StatusName = 'Returned';
END;

/*==============================================================================
                Section 4.7 : Insert Order
==============================================================================

Description:
------------
Inserts the generated order into the Order table.

Business Rules:
---------------
- Each order receives a unique Order Number.
- Financial values are initialized to zero.
- Financial values are updated after OrderItems are generated.
- One order belongs to one customer, one store and one employee.

==============================================================================*/

------------------------------------------------------------
-- Insert Order
------------------------------------------------------------

INSERT INTO dbo.[Order]
(
    OrderNumber,
    CustomerID,
    StoreID,
    EmployeeID,
    OrderDate,
    SubTotalAmount,
    DiscountAmount,
    TaxAmount,
    NetAmount,
    OrderStatusID,
    Remarks
)
VALUES
(
    @OrderNumber,
    @CustomerID,
    @StoreID,
    @EmployeeID,
    @OrderDate,
    0.00,
    0.00,
    0.00,
    0.00,
    @OrderStatusID,
    NULL
);

------------------------------------------------------------
-- Next Order
------------------------------------------------------------

SET @Counter = @Counter + 1;

END;

/*==============================================================================
                    Section 5 : Generation Summary
==============================================================================

Description:
------------
Displays the total number of generated orders.

==============================================================================*/

PRINT 'Order generation completed successfully.';

PRINT 'Total Orders Generated : ' + CAST(@TotalOrders AS VARCHAR(10));
GO


/*==============================================================================
                    Section 6 : Validation
==============================================================================

Description:
------------
Validates the generated order data.

==============================================================================*/

------------------------------------------------------------
-- Total Orders
------------------------------------------------------------

SELECT COUNT(*) AS TotalOrders
FROM dbo.[Order];

------------------------------------------------------------
-- Orders by Status
------------------------------------------------------------

SELECT
    OS.StatusName,
    COUNT(*) AS TotalOrders
FROM dbo.[Order] O
JOIN dbo.OrderStatus OS
    ON O.OrderStatusID = OS.OrderStatusID
GROUP BY OS.StatusName
ORDER BY TotalOrders DESC;

------------------------------------------------------------
-- Orders by Store
------------------------------------------------------------

SELECT
    S.StoreName,
    COUNT(*) AS TotalOrders
FROM dbo.[Order] O
JOIN dbo.Store S
    ON O.StoreID = S.StoreID
GROUP BY S.StoreName
ORDER BY TotalOrders DESC;

------------------------------------------------------------
-- Orders by Year
------------------------------------------------------------

SELECT
    YEAR(OrderDate) AS OrderYear,
    COUNT(*) AS TotalOrders
FROM dbo.[Order]
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;
GO