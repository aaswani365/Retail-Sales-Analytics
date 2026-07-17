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
Employee  → Manager (Self Reference)
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

/* Employee belongs to one Store */

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Manager
FOREIGN KEY (ManagerEmployeeID)
REFERENCES dbo.Employee(EmployeeID);

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
Order → Store
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

/* Links each Order record to a Store. */

ALTER TABLE dbo.[Order]
ADD CONSTRAINT FK_Order_Store
FOREIGN KEY (StoreID)
REFERENCES dbo.Store(StoreID);
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

Description:
------------
Creates CHECK constraints to enforce business rules and maintain
data integrity.

Business Rules:
---------------
- Prices cannot be negative.
- Selling price cannot be lower than cost price.
- Inventory quantities cannot be negative.
- Discount percentages must be valid.

==============================================================================*/

/*==============================================================================
                    Section 2.1 : Product Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Product table to enforce valid pricing and inventory thresholds.

Rules:
------
- Cost Price must be zero or greater.
- Selling Price must be greater than or equal to Cost Price.
- Reorder Level cannot be negative.

==============================================================================*/

------------------------------------------------------------
-- Product : Cost Price Validation
------------------------------------------------------------

ALTER TABLE dbo.Product
ADD CONSTRAINT CK_Product_CostPrice
CHECK (CostPrice >= 0);
GO

------------------------------------------------------------
-- Product : Selling Price Validation
------------------------------------------------------------

ALTER TABLE dbo.Product
ADD CONSTRAINT CK_Product_SellingPrice
CHECK (SellingPrice >= CostPrice);
GO

------------------------------------------------------------
-- Product : Reorder Level Validation
------------------------------------------------------------

ALTER TABLE dbo.Product
ADD CONSTRAINT CK_Product_ReorderLevel
CHECK (ReorderLevel >= 0);
GO

/*==============================================================================
                Section 2.2 : Inventory Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Inventory table to ensure valid
stock quantities.

Business Rules:
---------------
- Quantity In Stock must be zero or greater.

==============================================================================*/

------------------------------------------------------------
-- Inventory : Quantity In Stock Validation
------------------------------------------------------------

ALTER TABLE dbo.Inventory
ADD CONSTRAINT CK_Inventory_QuantityInStock
CHECK (QuantityInStock >= 0);
GO

/*==============================================================================
                Section 2.3 : Employee Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Employee table to enforce valid
salary and employment data.

Business Rules:
---------------
- Salary must be greater than zero.
- Hire Date cannot be in the future.

==============================================================================*/

------------------------------------------------------------
-- Employee : Salary Validation
------------------------------------------------------------

ALTER TABLE dbo.Employee
ADD CONSTRAINT CK_Employee_Salary
CHECK (Salary > 0);
GO

------------------------------------------------------------
-- Employee : Hire Date Validation
------------------------------------------------------------

ALTER TABLE dbo.Employee
ADD CONSTRAINT CK_Employee_HireDate
CHECK (HireDate <= CAST(GETDATE() AS DATE));
GO

/*==============================================================================
                Section 2.4 : Customer Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Customer table to ensure valid
registration dates and loyalty points.

Business Rules:
---------------
- Registration Date cannot be in the future.
- Loyalty Points must be zero or greater.

==============================================================================*/

------------------------------------------------------------
-- Customer : Registration Date Validation
------------------------------------------------------------

ALTER TABLE dbo.Customer
ADD CONSTRAINT CK_Customer_RegistrationDate
CHECK (RegistrationDate <= CAST(GETDATE() AS DATE));
GO

------------------------------------------------------------
-- Customer : Loyalty Points Validation
------------------------------------------------------------

ALTER TABLE dbo.Customer
ADD CONSTRAINT CK_Customer_LoyaltyPoints
CHECK (LoyaltyPoints >= 0);
GO

/*==============================================================================
                Section 2.5 : Order Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Order table to ensure valid
order dates and monetary values.

Business Rules:
---------------
- Order Date cannot be in the future.
- Sub Total Amount must be zero or greater.
- Discount Amount must be zero or greater.
- Tax Amount must be zero or greater.
- Net Amount must be zero or greater.

==============================================================================*/

------------------------------------------------------------
-- Order : Order Date Validation
------------------------------------------------------------

ALTER TABLE dbo.[Order]
ADD CONSTRAINT CK_Order_OrderDate
CHECK (OrderDate <= SYSDATETIME());
GO

------------------------------------------------------------
-- Order : Sub Total Validation
------------------------------------------------------------

ALTER TABLE dbo.[Order]
ADD CONSTRAINT CK_Order_SubTotalAmount
CHECK (SubTotalAmount >= 0);
GO

------------------------------------------------------------
-- Order : Discount Validation
------------------------------------------------------------

ALTER TABLE dbo.[Order]
ADD CONSTRAINT CK_Order_DiscountAmount
CHECK (DiscountAmount >= 0);
GO

------------------------------------------------------------
-- Order : Tax Validation
------------------------------------------------------------

ALTER TABLE dbo.[Order]
ADD CONSTRAINT CK_Order_TaxAmount
CHECK (TaxAmount >= 0);
GO

------------------------------------------------------------
-- Order : Net Amount Validation
------------------------------------------------------------

ALTER TABLE dbo.[Order]
ADD CONSTRAINT CK_Order_NetAmount
CHECK (NetAmount >= 0);
GO

/*==============================================================================
                Section 2.6 : OrderItem Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the OrderItem table to ensure valid
quantities and monetary values.

Business Rules:
---------------
- Quantity must be greater than zero.
- Cost Price must be zero or greater.
- Unit Price must be zero or greater.
- Discount Amount must be zero or greater.
- Tax Amount must be zero or greater.
- Line Total must be zero or greater.

==============================================================================*/

------------------------------------------------------------
-- OrderItem : Quantity Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_Quantity
CHECK (Quantity > 0);
GO

------------------------------------------------------------
-- OrderItem : Cost Price Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_CostPrice
CHECK (CostPrice >= 0);
GO

------------------------------------------------------------
-- OrderItem : Unit Price Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_UnitPrice
CHECK (UnitPrice >= 0);
GO

------------------------------------------------------------
-- OrderItem : Discount Amount Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_DiscountAmount
CHECK (DiscountAmount >= 0);
GO

------------------------------------------------------------
-- OrderItem : Tax Amount Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_TaxAmount
CHECK (TaxAmount >= 0);
GO

------------------------------------------------------------
-- OrderItem : Line Total Validation
------------------------------------------------------------

ALTER TABLE dbo.OrderItem
ADD CONSTRAINT CK_OrderItem_LineTotal
CHECK (LineTotal >= 0);
GO

/*==============================================================================
                Section 2.7 : Payment Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Payment table to ensure valid
payment dates and payment amounts.

Business Rules:
---------------
- Payment Date cannot be in the future.
- Payment Amount must be greater than zero.

==============================================================================*/

------------------------------------------------------------
-- Payment : Payment Date Validation
------------------------------------------------------------

ALTER TABLE dbo.Payment
ADD CONSTRAINT CK_Payment_PaymentDate
CHECK (PaymentDate <= SYSDATETIME());
GO

------------------------------------------------------------
-- Payment : Payment Amount Validation
------------------------------------------------------------

ALTER TABLE dbo.Payment
ADD CONSTRAINT CK_Payment_Amount
CHECK (Amount > 0);
GO

/*==============================================================================
                Section 2.8 : Return Business Rules
==============================================================================

Description:
------------
Creates CHECK constraints for the Return table to ensure valid
return dates, quantities, and refund amounts.

Business Rules:
---------------
- Return Date cannot be in the future.
- Quantity Returned must be greater than zero.
- Refund Amount must be zero or greater.

==============================================================================*/

------------------------------------------------------------
-- Return : Return Date Validation
------------------------------------------------------------

ALTER TABLE dbo.[Return]
ADD CONSTRAINT CK_Return_ReturnDate
CHECK (ReturnDate <= SYSDATETIME());
GO

------------------------------------------------------------
-- Return : Quantity Returned Validation
------------------------------------------------------------

ALTER TABLE dbo.[Return]
ADD CONSTRAINT CK_Return_QuantityReturned
CHECK (QuantityReturned > 0);
GO

------------------------------------------------------------
-- Return : Refund Amount Validation
------------------------------------------------------------

ALTER TABLE dbo.[Return]
ADD CONSTRAINT CK_Return_RefundAmount
CHECK (RefundAmount >= 0);
GO

PRINT '==============================================================';
PRINT '03_Create_Constraints.sql execution completed.';
PRINT 'Please review the Messages tab for any errors.';
PRINT '==============================================================';
GO