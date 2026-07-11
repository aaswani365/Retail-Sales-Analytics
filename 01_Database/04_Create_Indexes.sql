/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 04_Create_Indexes.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
Creates nonclustered indexes to improve query performance for
transaction processing, reporting, and Power BI analytics.

The script includes:
1. Lookup Table Indexes
2. Master Table Indexes
3. Transaction Table Indexes
4. Composite Indexes

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;
GO

/*==============================================================================
				Section 1 : Lookup Table Indexes
==============================================================================

Purpose:
--------
Improve searching and joining on lookup tables.

==============================================================================*/

/*==============================================================================
				Section 2 : Master Table Indexes
==============================================================================
					Master Tables
					-------------
					- Product(ProductName)
					- Customer(Phone)
					- Employee(Email)
					- Store(City)
==============================================================================*/

/* Search products by name */

CREATE NONCLUSTERED INDEX IX_Product_ProductName
ON dbo.Product(ProductName);
GO

/* Search customers by phone */

CREATE NONCLUSTERED INDEX IX_Customer_Phone
ON dbo.Customer(Phone);
GO

/* Search employees by email */

CREATE NONCLUSTERED INDEX IX_Employee_Email
ON dbo.Employee(Email);
GO

/* Search stores by city */

CREATE NONCLUSTERED INDEX IX_Store_City
ON dbo.Store(City);
GO

/*==============================================================================
				Section 3 : Transaction Table Indexes
==============================================================================
					Transaction Tables
					------------------
					- Inventory(ProductID)
					- Inventory(StoreID)
					- Order(CustomerID)
					- Order(EmployeeID)
					- Order(OrderDate)
					- OrderItem(ProductID)
					- OrderItem(OrderID)
					- Payment(OrderID)
					- Return(OrderItemID)
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

/* Retrieve returns by order item */

CREATE NONCLUSTERED INDEX IX_Return_OrderItemID
ON dbo.[Return](OrderItemID);
GO

/*==============================================================================
				Section 4 : Composite Indexes
==============================================================================
					Composite Indexes
					-----------------
					- Inventory(StoreID, ProductID)
					- Order(CustomerID, OrderDate)
					- OrderItem(OrderID, ProductID)
==============================================================================*/

/* Inventory lookup by store and product */

CREATE NONCLUSTERED INDEX IX_Inventory_Store_Product
ON dbo.Inventory(StoreID, ProductID);
GO

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

PRINT 'All indexes created successfully.';
GO