# Data Dictionary

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Last Updated:** July 2026

---

# Purpose

This document provides detailed information about every table and column in the RetailSalesDB database.

It serves as the official reference for database developers, data analysts, BI developers, and future project maintenance.

---

# Database Summary

| Category | Count |
|----------|------:|
| Lookup Tables | 6 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| Total Tables | 15 |

---

# Naming Standards

- Primary Keys use `INT IDENTITY(1,1)`
- Foreign Keys reference the parent table's primary key.
- Monetary values use `DECIMAL(10,2)`
- Date fields use `DATE`
- Date & Time fields use `DATETIME2`
- Boolean values use `BIT`
- Table names are singular.
- Column names follow PascalCase.

---

# Lookup Tables

---

# 1. Category

## Description

Stores the primary classification of products.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| CategoryID | INT | PK, IDENTITY | Unique category identifier |
| CategoryName | VARCHAR(100) | NOT NULL, UNIQUE | Category name |
| Description | VARCHAR(255) | NULL | Category description |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- One Category can contain many SubCategories.

---

# 2. SubCategory

## Description

Stores detailed classifications within each Category.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| SubCategoryID | INT | PK, IDENTITY | Unique subcategory identifier |
| CategoryID | INT | FK, NOT NULL | References Category |
| SubCategoryName | VARCHAR(100) | NOT NULL | Subcategory name |
| Description | VARCHAR(255) | NULL | Description |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- Belongs to one Category.
- One SubCategory can contain many Products.

---

# 3. Brand

## Description

Stores product brand information.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| BrandID | INT | PK, IDENTITY | Unique brand identifier |
| BrandName | VARCHAR(100) | NOT NULL, UNIQUE | Brand name |
| Description | VARCHAR(255) | NULL | Brand description |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- One Brand can have many Products.

---

# 4. Supplier

## Description

Stores supplier information.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| SupplierID | INT | PK, IDENTITY | Unique supplier identifier |
| SupplierName | VARCHAR(150) | NOT NULL | Supplier name |
| ContactName | VARCHAR(100) | NULL | Contact person |
| Phone | VARCHAR(20) | NULL | Phone number |
| Email | VARCHAR(100) | NULL | Email address |
| Address | VARCHAR(255) | NULL | Address |
| City | VARCHAR(100) | NULL | City |
| State | VARCHAR(100) | NULL | State |
| Country | VARCHAR(100) | NULL | Country |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- One Supplier supplies many Products.

---

# 5. PaymentMethod

## Description

Stores supported payment methods.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| PaymentMethodID | INT | PK, IDENTITY | Unique payment method |
| MethodName | VARCHAR(50) | NOT NULL | Payment method |
| Description | VARCHAR(255) | NULL | Description |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- One Payment Method can be used in many Payments.

---

# 6. ReturnReason

## Description

Stores predefined reasons for product returns.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ReturnReasonID | INT | PK, IDENTITY | Unique return reason |
| ReasonName | VARCHAR(100) | NOT NULL | Return reason |
| Description | VARCHAR(255) | NULL | Description |
| IsActive | BIT | DEFAULT 1 | Active status |

### Relationships

- One Return Reason can be associated with many Returns.

---

# Master Tables

---

# 7. Store

## Description

Stores information about all retail store locations where products are sold and inventory is maintained.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| StoreID | INT | PK, IDENTITY | Unique store identifier |
| StoreName | VARCHAR(100) | NOT NULL | Store name |
| Address | VARCHAR(255) | NOT NULL | Store address |
| City | VARCHAR(100) | NOT NULL | City |
| State | VARCHAR(100) | NOT NULL | State |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| Country | VARCHAR(100) | NOT NULL | Country |
| Phone | VARCHAR(20) | NULL | Contact number |
| IsActive | BIT | DEFAULT 1 | Store status |

### Relationships

- One Store can have many Employees.
- One Store can have many Inventory records.

### Business Rules

- StoreName should be unique.
- Only active stores can process orders.

---

# 8. Employee

## Description

Stores employee details responsible for sales and customer order processing.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| EmployeeID | INT | PK, IDENTITY | Unique employee identifier |
| StoreID | INT | FK, NOT NULL | References Store |
| FirstName | VARCHAR(50) | NOT NULL | Employee first name |
| LastName | VARCHAR(50) | NOT NULL | Employee last name |
| Email | VARCHAR(100) | UNIQUE | Email address |
| Phone | VARCHAR(20) | NULL | Phone number |
| JobTitle | VARCHAR(50) | NOT NULL | Employee designation |
| Salary | DECIMAL(10,2) | NOT NULL | Monthly salary |
| HireDate | DATE | NOT NULL | Hiring date |
| IsActive | BIT | DEFAULT 1 | Employee status |

### Relationships

- Many Employees belong to one Store.
- One Employee can process many Orders.

### Business Rules

- Email must be unique.
- Salary cannot be negative.
- HireDate cannot be a future date.

---

# 9. Customer

## Description

Stores customer information used for sales analysis and order history.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| CustomerID | INT | PK, IDENTITY | Unique customer identifier |
| FirstName | VARCHAR(50) | NOT NULL | First name |
| LastName | VARCHAR(50) | NOT NULL | Last name |
| Email | VARCHAR(100) | UNIQUE | Email address |
| Phone | VARCHAR(20) | NULL | Phone number |
| Address | VARCHAR(255) | NULL | Address |
| City | VARCHAR(100) | NULL | City |
| State | VARCHAR(100) | NULL | State |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| Country | VARCHAR(100) | NULL | Country |
| RegistrationDate | DATE | NOT NULL | Registration date |
| IsActive | BIT | DEFAULT 1 | Customer status |

### Relationships

- One Customer can place many Orders.

### Business Rules

- Email should be unique.
- RegistrationDate cannot be a future date.

---

# 10. Product

## Description

Stores detailed information about products available for sale.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ProductID | INT | PK, IDENTITY | Unique product identifier |
| ProductName | VARCHAR(150) | NOT NULL | Product name |
| SKU | VARCHAR(50) | UNIQUE, NOT NULL | Stock Keeping Unit |
| SubCategoryID | INT | FK, NOT NULL | References SubCategory |
| BrandID | INT | FK, NOT NULL | References Brand |
| SupplierID | INT | FK, NOT NULL | References Supplier |
| CostPrice | DECIMAL(10,2) | NOT NULL | Product cost price |
| SellingPrice | DECIMAL(10,2) | NOT NULL | Selling price |
| Barcode | VARCHAR(50) | NULL | Barcode |
| Description | VARCHAR(500) | NULL | Product description |
| IsActive | BIT | DEFAULT 1 | Product status |

### Relationships

- Many Products belong to one SubCategory.
- Many Products belong to one Brand.
- Many Products belong to one Supplier.
- One Product can exist in many Inventory records.
- One Product can appear in many OrderItems.

### Business Rules

- SKU must be unique.
- SellingPrice must be greater than CostPrice.
- CostPrice cannot be negative.
- ProductName cannot be empty.

---

# Transaction Tables

---

# 11. Inventory

## Description

Stores the current stock quantity of each product available at every store.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| InventoryID | INT | PK, IDENTITY | Unique inventory record |
| StoreID | INT | FK, NOT NULL | References Store |
| ProductID | INT | FK, NOT NULL | References Product |
| QuantityOnHand | INT | NOT NULL | Current available stock |
| ReorderLevel | INT | NOT NULL | Minimum stock level before replenishment |
| LastStockUpdate | DATETIME2 | DEFAULT GETDATE() | Last inventory update timestamp |

### Relationships

- Many Inventory records belong to one Store.
- Many Inventory records belong to one Product.

### Business Rules

- QuantityOnHand cannot be negative.
- ReorderLevel cannot be negative.
- Each Store-Product combination should be unique.

---

# 12. Order

## Description

Stores customer order information.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| OrderID | INT | PK, IDENTITY | Unique order identifier |
| CustomerID | INT | FK, NOT NULL | References Customer |
| EmployeeID | INT | FK, NOT NULL | References Employee |
| OrderDate | DATETIME2 | DEFAULT GETDATE() | Order date and time |
| TotalAmount | DECIMAL(12,2) | NOT NULL | Total order amount |
| OrderStatus | VARCHAR(30) | NOT NULL | Pending, Completed, Cancelled, Returned |
| Remarks | VARCHAR(255) | NULL | Additional notes |

### Relationships

- One Customer can place many Orders.
- One Employee can process many Orders.
- One Order can contain many OrderItems.
- One Order can have many Payments.

### Business Rules

- TotalAmount must be greater than zero.
- OrderDate cannot be in the future.

---

# 13. OrderItem

## Description

Stores individual products included in each customer order.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| OrderItemID | INT | PK, IDENTITY | Unique order item identifier |
| OrderID | INT | FK, NOT NULL | References Order |
| ProductID | INT | FK, NOT NULL | References Product |
| Quantity | INT | NOT NULL | Quantity ordered |
| UnitPrice | DECIMAL(10,2) | NOT NULL | Selling price at the time of purchase |
| Discount | DECIMAL(10,2) | DEFAULT 0 | Discount amount |
| LineTotal | DECIMAL(12,2) | NOT NULL | Total amount for the line item |

### Relationships

- Many OrderItems belong to one Order.
- Many OrderItems reference one Product.
- One OrderItem can have many Returns.

### Business Rules

- Quantity must be greater than zero.
- UnitPrice must be greater than zero.
- Discount cannot exceed UnitPrice.
- LineTotal = (Quantity × UnitPrice) − Discount.

---

# 14. Payment

## Description

Stores payment information for customer orders.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| PaymentID | INT | PK, IDENTITY | Unique payment identifier |
| OrderID | INT | FK, NOT NULL | References Order |
| PaymentMethodID | INT | FK, NOT NULL | References PaymentMethod |
| PaymentDate | DATETIME2 | DEFAULT GETDATE() | Payment date and time |
| PaymentAmount | DECIMAL(12,2) | NOT NULL | Amount paid |
| TransactionReference | VARCHAR(100) | NULL | Payment gateway reference |
| PaymentStatus | VARCHAR(30) | NOT NULL | Success, Failed, Pending |

### Relationships

- Many Payments belong to one Order.
- Many Payments use one Payment Method.

### Business Rules

- PaymentAmount must be greater than zero.
- PaymentDate cannot be in the future.

---

# 15. Return

## Description

Stores details of products returned by customers.

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ReturnID | INT | PK, IDENTITY | Unique return identifier |
| OrderItemID | INT | FK, NOT NULL | References OrderItem |
| ReturnReasonID | INT | FK, NOT NULL | References ReturnReason |
| ReturnDate | DATETIME2 | DEFAULT GETDATE() | Return date |
| ReturnQuantity | INT | NOT NULL | Quantity returned |
| RefundAmount | DECIMAL(12,2) | NOT NULL | Refund amount |
| ReturnStatus | VARCHAR(30) | NOT NULL | Requested, Approved, Rejected, Refunded |

### Relationships

- Many Returns belong to one OrderItem.
- Many Returns use one ReturnReason.

### Business Rules

- ReturnQuantity must be greater than zero.
- RefundAmount cannot be negative.
- ReturnDate cannot be earlier than the original OrderDate.

---

# Data Dictionary Summary

This Data Dictionary defines the structure, purpose, data types, constraints, and relationships of all tables within the Retail Sales Analytics & Inventory Management System. It serves as the primary reference for database development, reporting, and future maintenance.

**Total Tables:** 15

- Lookup Tables: 6
- Master Tables: 4
- Transaction Tables: 5