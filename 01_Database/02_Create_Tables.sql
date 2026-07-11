/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 02_Create_Tables.sql
Author       : Akshay Aswani
Version      : 2.0
Created On   : July 2026
Last Updated : July 2026

Description:
Creates all database tables for the Retail Sales Analytics &
Inventory Management System.

Execution Order:
1. Lookup Tables
2. Master Tables
3. Transaction Tables

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;
GO

/*==============================================================================
Lookup Tables
==============================================================================*/

/*==============================================================================
Table: Category
Description: Stores the primary classification of products.
==============================================================================*/

CREATE TABLE dbo.Category
(
    CategoryID      INT IDENTITY(1,1) NOT NULL,

    CategoryName    VARCHAR(100) NOT NULL,

    Description     VARCHAR(255) NULL,

    IsActive        BIT NOT NULL
                    CONSTRAINT DF_Category_IsActive DEFAULT (1),
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_Category
        PRIMARY KEY CLUSTERED (CategoryID),

    CONSTRAINT UQ_Category_CategoryName
        UNIQUE (CategoryName)
);
GO

/*==============================================================================
Table: SubCategory
Description: Stores detailed classifications within each category.
==============================================================================*/

CREATE TABLE dbo.SubCategory
(
    SubCategoryID      INT IDENTITY(1,1) NOT NULL,

    CategoryID         INT NOT NULL,

    SubCategoryName    VARCHAR(100) NOT NULL,

    Description        VARCHAR(255) NULL,

    IsActive           BIT NOT NULL
                       CONSTRAINT DF_SubCategory_IsActive DEFAULT (1),

	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_SubCategory
        PRIMARY KEY CLUSTERED (SubCategoryID),

    CONSTRAINT UQ_SubCategory_Category_SubCategory
        UNIQUE (CategoryID, SubCategoryName)
);
GO

/*==============================================================================
Table: Brand
Description: Stores product brand information.
==============================================================================*/

CREATE TABLE dbo.Brand
(
    BrandID        INT IDENTITY(1,1) NOT NULL,

    BrandName      VARCHAR(100) NOT NULL,

    Description    VARCHAR(255) NULL,

    IsActive       BIT NOT NULL
                   CONSTRAINT DF_Brand_IsActive DEFAULT (1),
				   
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_Brand
        PRIMARY KEY CLUSTERED (BrandID),

    CONSTRAINT UQ_Brand_BrandName
        UNIQUE (BrandName)
);
GO

/*==============================================================================
Table: Supplier
Description: Stores supplier information.
==============================================================================*/

CREATE TABLE dbo.Supplier
(
    SupplierID      INT IDENTITY(1,1) NOT NULL,

    SupplierName    VARCHAR(150) NOT NULL,

    ContactName     VARCHAR(100) NULL,

    Phone           VARCHAR(20) NULL,

    Email           VARCHAR(100) NULL,

    Address         VARCHAR(255) NULL,

    City            VARCHAR(100) NULL,

    State           VARCHAR(100) NULL,

    Country         VARCHAR(100) NULL,

    PostalCode      VARCHAR(20) NULL,

    IsActive        BIT NOT NULL
                    CONSTRAINT DF_Supplier_IsActive DEFAULT (1),
					
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_Supplier
        PRIMARY KEY CLUSTERED (SupplierID),

    CONSTRAINT UQ_Supplier_Name
        UNIQUE (SupplierName)
);
GO

/*==============================================================================
Table: PaymentMethod
Description: Stores supported payment methods.
==============================================================================*/

CREATE TABLE dbo.PaymentMethod
(
    PaymentMethodID      INT IDENTITY(1,1) NOT NULL,

    MethodName           VARCHAR(50) NOT NULL,

    Description          VARCHAR(255) NULL,

    IsActive             BIT NOT NULL
                         CONSTRAINT DF_PaymentMethod_IsActive DEFAULT (1),
						 
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_PaymentMethod
        PRIMARY KEY CLUSTERED (PaymentMethodID),

    CONSTRAINT UQ_PaymentMethod_MethodName
        UNIQUE (MethodName)
);
GO

/*==============================================================================
Table: ReturnReason
Description: Stores predefined reasons for product returns.
==============================================================================*/

CREATE TABLE dbo.ReturnReason
(
    ReturnReasonID      INT IDENTITY(1,1) NOT NULL,

    ReasonName          VARCHAR(100) NOT NULL,

    Description         VARCHAR(255) NULL,

    IsActive            BIT NOT NULL
                        CONSTRAINT DF_ReturnReason_IsActive DEFAULT (1),
						
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_ReturnReason
        PRIMARY KEY CLUSTERED (ReturnReasonID),

    CONSTRAINT UQ_ReturnReason_ReasonName
        UNIQUE (ReasonName)
);
GO

/*==============================================================================
Table: OrderStatus
Description: Stores predefined order statuses.
==============================================================================*/

CREATE TABLE dbo.OrderStatus
(
    OrderStatusID      INT IDENTITY(1,1) NOT NULL,

    StatusName         VARCHAR(50) NOT NULL,

    Description        VARCHAR(255) NULL,

    IsActive           BIT NOT NULL
                       CONSTRAINT DF_OrderStatus_IsActive DEFAULT (1),
					   
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_OrderStatus
        PRIMARY KEY CLUSTERED (OrderStatusID),

    CONSTRAINT UQ_OrderStatus_StatusName
        UNIQUE (StatusName)
);
GO

/*==============================================================================
Table: PaymentStatus
Description: Stores predefined payment statuses.
==============================================================================*/

CREATE TABLE dbo.PaymentStatus
(
    PaymentStatusID    INT IDENTITY(1,1) NOT NULL,

    StatusName         VARCHAR(50) NOT NULL,

    Description        VARCHAR(255) NULL,

    IsActive           BIT NOT NULL
                       CONSTRAINT DF_PaymentStatus_IsActive DEFAULT (1),
					   
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_PaymentStatus
        PRIMARY KEY CLUSTERED (PaymentStatusID),

    CONSTRAINT UQ_PaymentStatus_StatusName
        UNIQUE (StatusName)
);
GO

/*==============================================================================
Table: ReturnStatus
Description: Stores predefined return statuses.
==============================================================================*/

CREATE TABLE dbo.ReturnStatus
(
    ReturnStatusID     INT IDENTITY(1,1) NOT NULL,

    StatusName         VARCHAR(50) NOT NULL,

    Description        VARCHAR(255) NULL,

    IsActive           BIT NOT NULL
                       CONSTRAINT DF_ReturnStatus_IsActive DEFAULT (1),
					   
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_ReturnStatus
        PRIMARY KEY CLUSTERED (ReturnStatusID),

    CONSTRAINT UQ_ReturnStatus_StatusName
        UNIQUE (StatusName)
);
GO



PRINT 'Lookup tables created successfully.';
GO

/*==============================================================================
Master Tables
==============================================================================*/

/*==============================================================================
Table: Store
Description: Stores information about retail store locations.
==============================================================================*/

CREATE TABLE dbo.Store
(
    StoreID         INT IDENTITY(1,1) NOT NULL,

    StoreName       VARCHAR(100) NOT NULL,

	ManagerEmployeeID INT NULL,

    Address         VARCHAR(255) NOT NULL,

    City            VARCHAR(100) NOT NULL,

    State           VARCHAR(100) NOT NULL,

    PostalCode      VARCHAR(20) NULL,

    Country         VARCHAR(100) NOT NULL,

    Phone           VARCHAR(20) NULL,

    IsActive        BIT NOT NULL
                    CONSTRAINT DF_Store_IsActive DEFAULT (1),
					
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_Store
        PRIMARY KEY CLUSTERED (StoreID),

    CONSTRAINT UQ_Store_StoreName
        UNIQUE (StoreName)
);
GO

/*==============================================================================
Table: Employee
Description: Stores employee information.
==============================================================================*/

CREATE TABLE dbo.Employee
(
    EmployeeID      INT IDENTITY(1,1) NOT NULL,

    StoreID         INT NOT NULL,

	ManagerEmployeeID INT NULL,

    FirstName       VARCHAR(50) NOT NULL,

    LastName        VARCHAR(50) NOT NULL,

    Email           VARCHAR(100) NOT NULL,

    Phone           VARCHAR(20) NULL,

    JobTitle        VARCHAR(50) NOT NULL,

    Salary          DECIMAL(10,2) NOT NULL,

    HireDate        DATE NOT NULL,

    IsActive        BIT NOT NULL
                    CONSTRAINT DF_Employee_IsActive DEFAULT (1),
					
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

    CONSTRAINT PK_Employee
        PRIMARY KEY CLUSTERED (EmployeeID),

    CONSTRAINT UQ_Employee_Email
        UNIQUE (Email)
);
GO

/*==============================================================================
Table: Customer
Description: Stores customer information.
==============================================================================*/

CREATE TABLE dbo.Customer
(
    CustomerID          INT IDENTITY(1,1) NOT NULL,

    FirstName           VARCHAR(50) NOT NULL,

    LastName            VARCHAR(50) NOT NULL,

    Email               VARCHAR(100) NULL,

    Phone               VARCHAR(20) NULL,

    Address             VARCHAR(255) NULL,

    City                VARCHAR(100) NULL,

    State               VARCHAR(100) NULL,

    PostalCode          VARCHAR(20) NULL,

    Country             VARCHAR(100) NULL,

    RegistrationDate    DATE NOT NULL,

    IsActive            BIT NOT NULL
                        CONSTRAINT DF_Customer_IsActive DEFAULT (1),
						
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

	LoyaltyPoints INT NOT NULL
    CONSTRAINT DF_Customer_LoyaltyPoints DEFAULT (0),

    CONSTRAINT PK_Customer
        PRIMARY KEY CLUSTERED (CustomerID),

    CONSTRAINT UQ_Customer_Email
        UNIQUE (Email)
);
GO

/*==============================================================================
Table: Product
Description: Stores product master information.
==============================================================================*/

CREATE TABLE dbo.Product
(
    ProductID           INT IDENTITY(1,1) NOT NULL,

    ProductName         VARCHAR(150) NOT NULL,

    SKU                 VARCHAR(50) NOT NULL,

    SubCategoryID       INT NOT NULL,

    BrandID             INT NOT NULL,

    SupplierID          INT NOT NULL,

    CostPrice           DECIMAL(10,2) NOT NULL,

    SellingPrice        DECIMAL(10,2) NOT NULL,

    Barcode             VARCHAR(50) NULL,

    Description         VARCHAR(500) NULL,

    IsActive            BIT NOT NULL
                        CONSTRAINT DF_Product_IsActive DEFAULT (1),
						
	CreatedDate		DATETIME2 NOT NULL,

	ModifiedDate	DATETIME2 NULL,

	ReorderLevel INT NOT NULL
    CONSTRAINT DF_Product_ReorderLevel DEFAULT (10),

    CONSTRAINT PK_Product
        PRIMARY KEY CLUSTERED (ProductID),

    CONSTRAINT UQ_Product_SKU
        UNIQUE (SKU)
);
GO

PRINT 'Master tables created successfully.';
GO

/*==============================================================================
Transaction Tables
==============================================================================*/

/*==============================================================================
Table: Inventory
Description: Stores product inventory for each store.
==============================================================================*/

CREATE TABLE dbo.Inventory
(
    InventoryID        INT IDENTITY(1,1) NOT NULL,

    StoreID            INT NOT NULL,

    ProductID          INT NOT NULL,

    QuantityOnHand     INT NOT NULL,

    ReorderLevel       INT NOT NULL,

    LastStockUpdate    DATETIME2 NOT NULL
                       CONSTRAINT DF_Inventory_LastStockUpdate
                       DEFAULT (SYSDATETIME()),

    CreatedDate        DATETIME2 NOT NULL
                       CONSTRAINT DF_Inventory_CreatedDate
                       DEFAULT (SYSDATETIME()),

    ModifiedDate       DATETIME2 NULL,

    CONSTRAINT PK_Inventory
        PRIMARY KEY CLUSTERED (InventoryID)
);
GO

/*==============================================================================
Table: Order
Description: Stores customer order information.
==============================================================================*/

CREATE TABLE dbo.[Order]
(
    OrderID            INT IDENTITY(1,1) NOT NULL,

    CustomerID         INT NOT NULL,

    EmployeeID         INT NOT NULL,

    OrderDate          DATETIME2 NOT NULL
                       CONSTRAINT DF_Order_OrderDate
                       DEFAULT (SYSDATETIME()),

    TotalAmount        DECIMAL(12,2) NOT NULL,

    OrderStatusID      INT NOT NULL,

    Remarks            VARCHAR(255) NULL,

    CreatedDate        DATETIME2 NOT NULL
                       CONSTRAINT DF_Order_CreatedDate
                       DEFAULT (SYSDATETIME()),

    ModifiedDate       DATETIME2 NULL,

    CONSTRAINT PK_Order
        PRIMARY KEY CLUSTERED (OrderID)
);
GO

/*==============================================================================
Table: OrderItem
Description: Stores products included in an order.
==============================================================================*/

CREATE TABLE dbo.OrderItem
(
    OrderItemID        INT IDENTITY(1,1) NOT NULL,

    OrderID            INT NOT NULL,

    ProductID          INT NOT NULL,

    Quantity           INT NOT NULL,

    UnitPrice          DECIMAL(10,2) NOT NULL,

    Discount           DECIMAL(10,2) NOT NULL
                       CONSTRAINT DF_OrderItem_Discount
                       DEFAULT (0),

    LineTotal          DECIMAL(12,2) NOT NULL,

    CreatedDate        DATETIME2 NOT NULL
                       CONSTRAINT DF_OrderItem_CreatedDate
                       DEFAULT (SYSDATETIME()),

    ModifiedDate       DATETIME2 NULL,

    CONSTRAINT PK_OrderItem
        PRIMARY KEY CLUSTERED (OrderItemID)
);
GO

/*==============================================================================
Table: Payment
Description: Stores payment details for customer orders.
==============================================================================*/

CREATE TABLE dbo.Payment
(
    PaymentID              INT IDENTITY(1,1) NOT NULL,

    OrderID                INT NOT NULL,

    PaymentMethodID        INT NOT NULL,

    PaymentDate            DATETIME2 NOT NULL
                           CONSTRAINT DF_Payment_PaymentDate
                           DEFAULT (SYSDATETIME()),

    PaymentAmount          DECIMAL(12,2) NOT NULL,

    TransactionReference   VARCHAR(100) NULL,

    PaymentStatusID		INT NOT NULL,

    CreatedDate            DATETIME2 NOT NULL
                           CONSTRAINT DF_Payment_CreatedDate
                           DEFAULT (SYSDATETIME()),

    ModifiedDate           DATETIME2 NULL,

    CONSTRAINT PK_Payment
        PRIMARY KEY CLUSTERED (PaymentID)
);
GO

/*==============================================================================
Table: Return
Description: Stores returned products.
==============================================================================*/

CREATE TABLE dbo.[Return]
(
    ReturnID            INT IDENTITY(1,1) NOT NULL,

    OrderItemID         INT NOT NULL,

    ReturnReasonID      INT NOT NULL,

    ReturnDate          DATETIME2 NOT NULL
                        CONSTRAINT DF_Return_ReturnDate
                        DEFAULT (SYSDATETIME()),

    ReturnQuantity      INT NOT NULL,

    RefundAmount        DECIMAL(12,2) NOT NULL,

    ReturnStatusID     INT NOT NULL,

    CreatedDate         DATETIME2 NOT NULL
                        CONSTRAINT DF_Return_CreatedDate
                        DEFAULT (SYSDATETIME()),

    ModifiedDate        DATETIME2 NULL,

    CONSTRAINT PK_Return
        PRIMARY KEY CLUSTERED (ReturnID)
);
GO

PRINT 'Transaction tables created successfully.';
GO