/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 04_Create_Indexes.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
------------
Creates NONCLUSTERED indexes to improve query performance for
master tables, transaction tables, reporting queries, and
composite search operations.

Sections:
---------
1. Master Table Indexes
2. Lookup Table Indexes
3. Transaction Table Indexes
4. Reporting Indexes
5. Composite Indexes

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;
GO

/*==============================================================================
                    Section 1 : Master Table Indexes
==============================================================================

Master Tables
-------------
- Product(ProductName)
- Customer(Phone)
- Store(City)

Contains
-------------
- IX_Product_ProductName
- IX_Customer_Phone
- IX_Store_City

==============================================================================*/

/* Search products by name */

CREATE NONCLUSTERED INDEX IX_Product_ProductName
ON dbo.Product(ProductName);
GO

/* Search customers by phone */

CREATE NONCLUSTERED INDEX IX_Customer_Phone
ON dbo.Customer(Phone);
GO

/* Search stores by city */

CREATE NONCLUSTERED INDEX IX_Store_City
ON dbo.Store(City);
GO


/*==============================================================================
				Section 2 : Lookup Table Indexes
==============================================================================

Lookup Tables
-------------
- None

(Note: Primary Keys already provide clustered indexes.

==============================================================================*/

/*==============================================================================
				Section 3 : Transaction Table Indexes
==============================================================================

Transaction Tables
------------------
- Inventory(ProductID)
- Inventory(StoreID)
- Order(CustomerID)
- Order(EmployeeID)
- Order(StoreID)
- Order(OrderDate)
- OrderItem(ProductID)
- OrderItem(OrderID)
- Payment(OrderID)
- Payment(PaymentDate)
- Return(OrderItemID)
- Return(ReturnDate)

Contains
-------------
- IX_Inventory_ProductID
- IX_Inventory_StoreID
- IX_Order_CustomerID
- IX_Order_EmployeeID
- IX_Order_StoreID
- IX_Order_OrderDate
- IX_OrderItem_ProductID
- IX_OrderItem_OrderID
- IX_Payment_OrderID
- IX_Payment_PaymentDate
- IX_Return_OrderItemID
- IX_Return_ReturnDate
					
==============================================================================*/

/* Find inventory by product */

CREATE NONCLUSTERED INDEX IX_Inventory_ProductID
ON dbo.Inventory(ProductID);
GO

/* Find inventory by store */

CREATE NONCLUSTERED INDEX IX_Inventory_StoreID
ON dbo.Inventory(StoreID);
GO

/* Customer order history */

CREATE NONCLUSTERED INDEX IX_Order_CustomerID
ON dbo.[Order](CustomerID);
GO

/* Orders processed by employee */

CREATE NONCLUSTERED INDEX IX_Order_EmployeeID
ON dbo.[Order](EmployeeID);
GO

/* Orders processed by Store */

CREATE NONCLUSTERED INDEX IX_Order_StoreID
ON dbo.[Order](StoreID);
GO

/* Reporting by order date */

CREATE NONCLUSTERED INDEX IX_Order_OrderDate
ON dbo.[Order](OrderDate);
GO

/* Product sales analysis */

CREATE NONCLUSTERED INDEX IX_OrderItem_ProductID
ON dbo.OrderItem(ProductID);
GO

/* Retrieve items for an order */

CREATE NONCLUSTERED INDEX IX_OrderItem_OrderID
ON dbo.OrderItem(OrderID);
GO

/* Retrieve payments by order */

CREATE NONCLUSTERED INDEX IX_Payment_OrderID
ON dbo.Payment(OrderID);
GO

/* Retrieve payments by PaymentDate */

CREATE NONCLUSTERED INDEX IX_Payment_PaymentDate
ON dbo.Payment(PaymentDate);
GO

/* Retrieve returns by order item */

CREATE NONCLUSTERED INDEX IX_Return_OrderItemID
ON dbo.[Return](OrderItemID);
GO

/* Retrieve returns by return date */

CREATE NONCLUSTERED INDEX IX_Return_ReturnDate
ON dbo.[Return](ReturnDate);
GO

/*==============================================================================
                    Section 4 : Reporting Indexes
==============================================================================

Reporting Indexes
-----------------
- Product(SubCategoryID)
- Product(BrandID)

Contains
-------------
IX_Product_SubCategoryID
IX_Product_BrandID

==============================================================================*/

/* Retrieve products by SubCategory */

CREATE NONCLUSTERED INDEX IX_Product_SubCategoryID
ON dbo.Product(SubCategoryID);
GO

/* Retrieve products by Brand */

CREATE NONCLUSTERED INDEX IX_Product_BrandID
ON dbo.Product(BrandID);
GO

/*==============================================================================
				Section 5 : Composite Indexes
==============================================================================
Composite Indexes
-----------------
- Order(CustomerID, OrderDate)
- OrderItem(OrderID, ProductID)

Contains
-------------
- IX_Order_Customer_OrderDate
- IX_OrderItem_Order_Product

==============================================================================*/

/* Customer order history by date */

CREATE NONCLUSTERED INDEX IX_Order_Customer_OrderDate
ON dbo.[Order](CustomerID, OrderDate);
GO

/* Product performance within orders */

CREATE NONCLUSTERED INDEX IX_OrderItem_Order_Product
ON dbo.OrderItem(OrderID, ProductID);
GO

/*==============================================================================
These indexes improve search performance, JOIN operations,
report generation, and Power BI dashboards.
==============================================================================*/

PRINT '==============================================================';
PRINT '04_Create_Indexes.sql executed successfully.';
PRINT 'All recommended indexes have been created.';
PRINT '==============================================================';
GO