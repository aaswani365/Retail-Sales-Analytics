/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 03_Create_Constraints.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
This script creates all database constraints required to enforce
referential integrity and business rules.

The script includes:
1. Foreign Key Constraints
2. CHECK Constraints

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;
GO

/*==============================================================================
Section 1 : Foreign Key Constraints
==============================================================================

Purpose:
--------
Foreign key constraints establish relationships between tables and enforce
referential integrity.

Benefits:
---------
- Prevent orphan records
- Ensure valid parent-child relationships
- Improve data consistency
- Support reliable joins and reporting

Execution Order:
----------------
1. Lookup Relationships
2. Master Table Relationships
3. Transaction Table Relationships

==============================================================================*/

/*==============================================================================
				Lookup Relationships
==============================================================================

Description:
------------
Creates relationships between lookup tables.

Relationship:
SubCategory → Category

==============================================================================*/

/* Links each SubCategory record to a Category. */

ALTER TABLE dbo.SubCategory
ADD CONSTRAINT FK_SubCategory_Category
FOREIGN KEY (CategoryID)
REFERENCES dbo.Category(CategoryID);
GO

/*==============================================================================
				End of Lookup Relationships
==============================================================================*/

/*==============================================================================
				Master Table Relationships
==============================================================================

Description:
------------
Creates relationships between master tables and lookup tables.

Relationships:
--------------
Employee  → Store
Product   → Brand
Product   → Supplier
Product   → SubCategory

==============================================================================*/

/* Employee belongs to one Store */

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Store
FOREIGN KEY (StoreID)
REFERENCES dbo.Store(StoreID);
GO

/* Links each product to its corresponding brand. */

ALTER TABLE dbo.Product
ADD CONSTRAINT FK_Product_Brand
FOREIGN KEY (BrandID)
REFERENCES dbo.Brand(BrandID);
GO

/* Links each product to its supplier. */

ALTER TABLE dbo.Product
ADD CONSTRAINT FK_Product_Supplier
FOREIGN KEY (SupplierID)
REFERENCES dbo.Supplier(SupplierID);
GO

/* Link each product belongs to its SubCategory */

ALTER TABLE dbo.Product
ADD CONSTRAINT FK_Product_SubCategory
FOREIGN KEY (SubCategoryID)
REFERENCES dbo.SubCategory(SubCategoryID);
GO

/*==============================================================================
				End of Master Relationships
==============================================================================*/

/*==============================================================================
				Transaction Table Relationships
==============================================================================

Description:
------------
Creates relationships between transactional data and master tables.

Relationships:
--------------
Inventory → Store
Inventory → Product
Order → Customer
Order → Employee
Order → OrderStatus
OrderItem → Order
OrderItem → Product
Payment → Order
Payment → PaymentMethod
Payment → PaymentStatus
Return → OrderItem
Return → ReturnReason
Return → ReturnStatus
==============================================================================*/

/* Links each inventory record to a store. */

ALTER TABLE dbo.Inventory
ADD CONSTRAINT FK_Inventory_Store
FOREIGN KEY (StoreID)
REFERENCES dbo.Store(StoreID);
GO

/* Links each inventory record to a prdouct. */

ALTER TABLE dbo.Inventory
ADD CONSTRAINT FK_Inventory_Product
FOREIGN KEY (ProductID)
REFERENCES dbo.Product(ProductID);
GO

/* Links each Order record to a Customer. */

ALTER TABLE dbo.[Order]
ADD CONSTRAINT FK_Order_Customer
FOREIGN KEY (CustomerID)
REFERENCES dbo.Customer(CustomerID);
GO

/* Links each Order record to a Employee. */

ALTER TABLE dbo.[Order]
ADD CONSTRAINT FK_Order_Employee
FOREIGN KEY (EmployeeID)
REFERENCES dbo.Employee(EmployeeID);
GO

/* Links each Order record to a OrderStatus. */

ALTER TABLE dbo.[Order]
ADD CONSTRAINT FK_Order_OrderStatus
FOREIGN KEY (OrderStatusID)
REFERENCES dbo.OrderStatus(OrderStatusID);
GO

/* Links each OrderItem record to a Order. */

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT FK_OrderItem_Order
FOREIGN KEY (OrderID)
REFERENCES dbo.[Order](OrderID);
GO

/* Links each OrderItem record to a Product. */

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT FK_OrderItem_Product
FOREIGN KEY (ProductID)
REFERENCES dbo.Product(ProductID);
GO

/* Links each Payment record to a Order. */

ALTER TABLE dbo.Payment
ADD CONSTRAINT FK_Payment_Order
FOREIGN KEY (OrderID)
REFERENCES dbo.[Order](OrderID);
GO

/* Links each Payment record to a PaymentMethod. */

ALTER TABLE dbo.Payment
ADD CONSTRAINT FK_Payment_PaymentMethod
FOREIGN KEY (PaymentMethodID)
REFERENCES dbo.PaymentMethod(PaymentMethodID);
GO

/* Links each Payment record to a PaymentStatus. */

ALTER TABLE dbo.Payment
ADD CONSTRAINT FK_Payment_PaymentStatus
FOREIGN KEY (PaymentStatusID)
REFERENCES dbo.PaymentStatus(PaymentStatusID);
GO

/* Links each Return record to a OrderItem. */

ALTER TABLE dbo.[Return]
ADD CONSTRAINT FK_Return_OrderItem
FOREIGN KEY (OrderItemID)
REFERENCES dbo.OrderItem(OrderItemID);
GO

/* Links each Return record to a ReturnReason. */

ALTER TABLE dbo.[Return]
ADD CONSTRAINT FK_Return_ReturnReason
FOREIGN KEY (ReturnReasonID)
REFERENCES dbo.ReturnReason(ReturnReasonID);
GO

/* Links each Return record to a ReturnStatus. */

ALTER TABLE dbo.[Return]
ADD CONSTRAINT FK_Return_ReturnStatus
FOREIGN KEY (ReturnStatusID)
REFERENCES dbo.ReturnStatus(ReturnStatusID);
GO

/*==============================================================================
				End of Transaction Relationships
==============================================================================*/

/*==============================================================================
				Section 2 : CHECK Constraints
==============================================================================

Purpose:
--------
CHECK constraints enforce business validation rules at the database level.

Benefits:
---------
- Prevent invalid data
- Improve data quality
- Reduce application errors
- Enforce business policies

==============================================================================*/

/*==============================================================================
				Employee Business Rules
==============================================================================

Rules:
------
- Salary must be greater than zero.
- Gender must be M, F or O.

==============================================================================*/

/*==============================================================================
				Customer Business Rules
==============================================================================

Rules:
------
- Gender must be M, F or O.
- Loyalty points cannot be negative.

==============================================================================*/

/*==============================================================================
				Product Business Rules
==============================================================================

Rules:
------
- Cost Price must be zero or greater.
- Selling Price must be greater than or equal to Cost Price.
- Warranty Months cannot be negative.
- Weight cannot be negative.
- Reorder Level cannot be negative.

==============================================================================*/

/*==============================================================================
				Inventory Business Rules
==============================================================================

Rules:
------
- Quantity On Hand cannot be negative.

==============================================================================*/

/*==============================================================================
				Order Business Rules
==============================================================================

Rules:
------
- Order Total cannot be negative.
- Discount Amount cannot be negative.
- Tax Amount cannot be negative.

==============================================================================*/

/*==============================================================================
				Payment Business Rules
==============================================================================

Rules:
------
- Payment Amount must be greater than zero.

==============================================================================*/

/*==============================================================================
				Return Business Rules
==============================================================================

Rules:
------
- Return Quantity must be greater than zero.
- Refund Amount cannot be negative.

==============================================================================*/

PRINT 'All Foreign Key and CHECK Constraints created successfully.';
GO