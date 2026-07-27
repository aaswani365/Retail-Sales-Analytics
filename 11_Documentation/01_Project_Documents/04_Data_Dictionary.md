# Data Dictionary

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Created On:** July 2026  
**Last Updated:** July 2026

---

## Table of Contents

1. [Purpose](#1-purpose)
2. [Database Summary](#2-database-summary)
3. [Legend](#3-legend)
4. [Naming Standards](#4-naming-standards)
5. [Lookup Tables](#5-lookup-tables)
6. [Master Tables](#6-master-tables)
7. [Transaction Tables](#7-transaction-tables)
8. [Data Dictionary Summary](#8-data-dictionary-summary)
9. [Conclusion](#9-conclusion)

---

# 1. Purpose

The purpose of this document is to provide a complete reference for all database objects used in the **Retail Sales Analytics & Inventory Management System**.

This data dictionary defines every table, column, data type, constraint, relationship, and business rule implemented within the SQL Server database.

It serves as the primary reference for:

- Database Developers
- Data Analysts
- Power BI Developers
- Test Engineers
- Future Maintenance Teams

---

# 2. Database Summary

| Item | Value |
|------|------:|
| Database | RetailSalesDB |
| SQL Server Version | SQL Server |
| Total Tables | 18 |
| Lookup Tables | 9 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| Primary Keys | 18 |
| Foreign Keys | 17+ |
| Normalization | Third Normal Form (3NF) |
| Reporting Tool | Power BI |

---

# 3. Legend

| Abbreviation | Meaning |
|-------------|---------|
| PK | Primary Key |
| FK | Foreign Key |
| UQ | Unique Constraint |
| CK | Check Constraint |
| DF | Default Constraint |
| NN | NOT NULL |
| NULL | Nullable |
| IDENTITY | Auto Increment |

---

# 4. Naming Standards

The database follows the naming standards defined in **03_Naming_Conventions.md**.

Highlights include:

- PascalCase object names
- Singular table names
- Descriptive column names
- Standardized constraint names
- Consistent audit columns
- Standardized SQL formatting

Audit columns used across the project:

| Column | Description |
|---------|-------------|
| CreatedDate | Record creation timestamp |
| ModifiedDate | Last modification timestamp |

---

# 5. Lookup Tables

Lookup tables store reusable reference values used throughout the application.

---

## 5.1 Category

### Purpose

Stores high-level product classifications.

### Relationships

- One Category → Many SubCategories

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| CategoryID | INT | PK, IDENTITY | Unique category identifier |
| CategoryName | VARCHAR(100) | NN, UQ | Category name |
| Description | VARCHAR(255) | NULL | Category description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation date |
| ModifiedDate | DATETIME2 | NULL | Last modified date |

### Business Rules

- Category names must be unique.
- Inactive categories cannot be assigned to new products.

---

## 5.2 SubCategory

### Purpose

Stores product subcategories.

### Relationships

- Many SubCategories → One Category
- One SubCategory → Many Products

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| SubCategoryID | INT | PK, IDENTITY | Unique subcategory identifier |
| CategoryID | INT | FK, NN | Parent category |
| SubCategoryName | VARCHAR(100) | NN | Subcategory name |
| Description | VARCHAR(255) | NULL | Description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation date |
| ModifiedDate | DATETIME2 | NULL | Last modified date |

### Business Rules

- Every subcategory belongs to one category.
- Duplicate names within the same category are not allowed.

---

## 5.3 Brand

### Purpose

Stores product brand information.

### Relationships

- One Brand → Many Products

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| BrandID | INT | PK, IDENTITY | Unique brand identifier |
| BrandName | VARCHAR(100) | NN, UQ | Brand name |
| Description | VARCHAR(255) | NULL | Brand description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation date |
| ModifiedDate | DATETIME2 | NULL | Last modified date |

### Business Rules

- Brand names must be unique.

---

## 5.4 Supplier

### Purpose

Stores supplier information.

### Relationships

- One Supplier → Many Products

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| SupplierID | INT | PK, IDENTITY | Unique supplier identifier |
| SupplierName | VARCHAR(150) | NN, UQ | Supplier name |
| ContactName | VARCHAR(100) | NULL | Contact person |
| Phone | VARCHAR(20) | NULL | Phone number |
| Email | VARCHAR(100) | NULL | Email address |
| Address | VARCHAR(255) | NULL | Supplier address |
| City | VARCHAR(100) | NULL | City |
| State | VARCHAR(100) | NULL | State |
| Country | VARCHAR(100) | NULL | Country |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation date |
| ModifiedDate | DATETIME2 | NULL | Last modified date |

### Business Rules

- Supplier names must be unique.

---

## 5.5 PaymentMethod

### Purpose

Stores available payment methods.

### Relationships

- One Payment Method → Many Payments

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| PaymentMethodID | INT | PK, IDENTITY | Unique payment method identifier |
| MethodName | VARCHAR(50) | NN, UQ | Payment method |
| Description | VARCHAR(255) | NULL | Description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation date |
| ModifiedDate | DATETIME2 | NULL | Last modified date |

### Business Rules

- Payment method names must be unique.

---

## 5.6 OrderStatus

### Purpose

Stores the lifecycle status of customer orders.

### Relationships

- One Order Status → Many Orders

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| OrderStatusID | INT | PK, IDENTITY | Unique order status identifier |
| StatusName | VARCHAR(50) | NN, UQ | Order status name |
| Description | VARCHAR(255) | NULL | Status description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Status names must be unique.
- Only predefined statuses are allowed.

---

## 5.7 PaymentStatus

### Purpose

Stores the payment processing status.

### Relationships

- One Payment Status → Many Payments

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| PaymentStatusID | INT | PK, IDENTITY | Unique payment status identifier |
| StatusName | VARCHAR(50) | NN, UQ | Payment status |
| Description | VARCHAR(255) | NULL | Status description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Status names must be unique.

---

## 5.8 ReturnReason

### Purpose

Stores valid reasons for returning products.

### Relationships

- One Return Reason → Many Returns

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ReturnReasonID | INT | PK, IDENTITY | Unique return reason identifier |
| ReasonName | VARCHAR(100) | NN, UQ | Return reason |
| Description | VARCHAR(255) | NULL | Reason description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Return reasons must be unique.

---

## 5.9 ReturnStatus

### Purpose

Stores the processing status of product returns.

### Relationships

- One Return Status → Many Returns

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ReturnStatusID | INT | PK, IDENTITY | Unique return status identifier |
| StatusName | VARCHAR(50) | NN, UQ | Return status |
| Description | VARCHAR(255) | NULL | Status description |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Status names must be unique.

---

# 6. Master Tables

Master tables store the core business entities used throughout the system.

---

## 6.1 Store

### Purpose

Stores information about retail store locations.

### Relationships

- One Store → Many Employees
- One Store → Many Inventory Records

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| StoreID | INT | PK, IDENTITY | Unique store identifier |
| StoreName | VARCHAR(100) | NN | Store name |
| StoreCode | VARCHAR(20) | NN, UQ | Unique store code |
| Phone | VARCHAR(20) | NULL | Contact number |
| Email | VARCHAR(100) | NULL | Store email |
| Address | VARCHAR(255) | NULL | Street address |
| City | VARCHAR(100) | NN | City |
| State | VARCHAR(100) | NN | State |
| Country | VARCHAR(100) | NN | Country |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| OpeningDate | DATE | NULL | Store opening date |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Store codes must be unique.
- Every employee belongs to one store.
- Inventory is maintained separately for each store.

---

## 6.2 Employee

### Purpose

Stores employee information.

### Relationships

- Many Employees → One Store
- One Employee → Many Orders

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| EmployeeID | INT | PK, IDENTITY | Unique employee identifier |
| StoreID | INT | FK, NN | Assigned store |
| FirstName | VARCHAR(100) | NN | First name |
| LastName | VARCHAR(100) | NN | Last name |
| Gender | CHAR(1) | NN, CK | Gender |
| DateOfBirth | DATE | NULL | Date of birth |
| Phone | VARCHAR(20) | NULL | Phone number |
| Email | VARCHAR(100) | NULL, UQ | Email address |
| HireDate | DATE | NN | Joining date |
| JobTitle | VARCHAR(100) | NN | Job title |
| Salary | DECIMAL(10,2) | NN, CK | Salary |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Salary must be greater than zero.
- Gender must be M, F, or O.
- Email addresses must be unique.

---

## 6.3 Customer

### Purpose

Stores customer information.

### Relationships

- One Customer → Many Orders

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| CustomerID | INT | PK, IDENTITY | Unique customer identifier |
| FirstName | VARCHAR(100) | NN | First name |
| LastName | VARCHAR(100) | NN | Last name |
| Gender | CHAR(1) | NN, CK | Gender |
| DateOfBirth | DATE | NULL | Date of birth |
| Phone | VARCHAR(20) | NULL | Phone number |
| Email | VARCHAR(100) | NULL, UQ | Email address |
| Address | VARCHAR(255) | NULL | Address |
| City | VARCHAR(100) | NULL | City |
| State | VARCHAR(100) | NULL | State |
| Country | VARCHAR(100) | NULL | Country |
| PostalCode | VARCHAR(20) | NULL | Postal code |
| LoyaltyPoints | INT | NN, DF | Loyalty reward points |
| RegistrationDate | DATE | NN | Customer registration date |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Loyalty points cannot be negative.
- Email addresses must be unique.
- Gender must be M, F, or O.

---

## 6.4 Product

### Purpose

Stores product catalog information.

### Relationships

- Many Products → One Brand
- Many Products → One Supplier
- Many Products → One SubCategory
- One Product → Many Inventory Records
- One Product → Many Order Items

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ProductID | INT | PK, IDENTITY | Unique product identifier |
| ProductName | VARCHAR(150) | NN | Product name |
| SKU | VARCHAR(50) | NN, UQ | Stock Keeping Unit |
| BrandID | INT | FK, NN | Product brand |
| SupplierID | INT | FK, NN | Product supplier |
| SubCategoryID | INT | FK, NN | Product subcategory |
| CostPrice | DECIMAL(10,2) | NN, CK | Cost price |
| SellingPrice | DECIMAL(10,2) | NN, CK | Selling price |
| WarrantyMonths | INT | NN, CK | Warranty period |
| Weight | DECIMAL(10,2) | NULL, CK | Product weight |
| ReorderLevel | INT | NN, CK | Minimum stock level |
| IsActive | BIT | NN, DF | Active status |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- SKU must be unique.
- Selling Price must be greater than or equal to Cost Price.
- Cost Price cannot be negative.
- Warranty Months cannot be negative.
- Reorder Level cannot be negative.

---

# 7. Transaction Tables

Transaction tables store day-to-day business operations such as inventory updates, customer orders, payments, and returns.

---

## 7.1 Inventory

### Purpose

Stores the current inventory quantity of each product available at every store.

### Relationships

- Many Inventory Records → One Store
- Many Inventory Records → One Product

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| InventoryID | INT | PK, IDENTITY | Unique inventory identifier |
| StoreID | INT | FK, NN | Store identifier |
| ProductID | INT | FK, NN | Product identifier |
| QuantityOnHand | INT | NN, CK | Current available quantity |
| LastStockUpdate | DATETIME2 | NN | Last inventory update |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Quantity On Hand cannot be negative.
- Each inventory record represents one product in one store.
- Inventory is maintained independently for each store.

---

## 7.2 Order

### Purpose

Stores customer order information.

### Relationships

- Many Orders → One Customer
- Many Orders → One Employee
- Many Orders → One Order Status
- One Order → Many Order Items
- One Order → Many Payments

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| OrderID | INT | PK, IDENTITY | Unique order identifier |
| CustomerID | INT | FK, NN | Customer placing the order |
| EmployeeID | INT | FK, NN | Employee handling the order |
| OrderStatusID | INT | FK, NN | Current order status |
| OrderDate | DATETIME2 | NN, DF | Date and time of order |
| OrderTotal | DECIMAL(12,2) | NN, CK | Total order amount |
| DiscountAmount | DECIMAL(12,2) | NN, CK | Discount applied |
| TaxAmount | DECIMAL(12,2) | NN, CK | Tax amount |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Order Total cannot be negative.
- Discount Amount cannot be negative.
- Tax Amount cannot be negative.
- Every order belongs to one customer.
- Every order must have a valid status.

---

## 7.3 OrderItem

### Purpose

Stores individual products included in each customer order.

### Relationships

- Many Order Items → One Order
- Many Order Items → One Product

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| OrderItemID | INT | PK, IDENTITY | Unique order item identifier |
| OrderID | INT | FK, NN | Parent order |
| ProductID | INT | FK, NN | Ordered product |
| Quantity | INT | NN | Quantity ordered |
| UnitPrice | DECIMAL(10,2) | NN | Selling price per unit |
| LineTotal | DECIMAL(12,2) | NN | Total value of the line item |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Quantity must be greater than zero.
- Unit Price cannot be negative.
- Line Total should equal Quantity × Unit Price.

---

## 7.4 Payment

### Purpose

Stores payment transactions for customer orders.

### Relationships

- Many Payments → One Order
- Many Payments → One Payment Method
- Many Payments → One Payment Status

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| PaymentID | INT | PK, IDENTITY | Unique payment identifier |
| OrderID | INT | FK, NN | Associated order |
| PaymentMethodID | INT | FK, NN | Payment method |
| PaymentStatusID | INT | FK, NN | Payment status |
| PaymentDate | DATETIME2 | NN | Payment date |
| PaymentAmount | DECIMAL(12,2) | NN, CK | Amount paid |
| TransactionReference | VARCHAR(100) | NULL | External transaction reference |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Payment Amount must be greater than zero.
- Every payment belongs to one order.
- Every payment must use a valid payment method.
- Payment status must exist before recording payment.

---

## 7.5 Return

### Purpose

Stores information about returned products.

### Relationships

- Many Returns → One Order Item
- Many Returns → One Return Reason
- Many Returns → One Return Status

### Columns

| Column | Data Type | Constraints | Description |
|---------|-----------|-------------|-------------|
| ReturnID | INT | PK, IDENTITY | Unique return identifier |
| OrderItemID | INT | FK, NN | Returned order item |
| ReturnReasonID | INT | FK, NN | Reason for return |
| ReturnStatusID | INT | FK, NN | Current return status |
| ReturnDate | DATETIME2 | NN | Return date |
| ReturnQuantity | INT | NN, CK | Quantity returned |
| RefundAmount | DECIMAL(12,2) | NN, CK | Refund amount |
| Remarks | VARCHAR(255) | NULL | Additional comments |
| CreatedDate | DATETIME2 | NN, DF | Record creation timestamp |
| ModifiedDate | DATETIME2 | NULL | Last modification timestamp |

### Business Rules

- Return Quantity must be greater than zero.
- Refund Amount cannot be negative.
- Every return must reference a valid order item.
- Every return must have a valid reason and status.

---

# 8. Data Dictionary Summary

## Database Statistics

| Item | Count |
|------|------:|
| Database | RetailSalesDB |
| Total Tables | 18 |
| Lookup Tables | 9 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| Primary Keys | 18 |
| Foreign Keys | 17 |
| CHECK Constraints | 9+ |
| DEFAULT Constraints | 25+ |
| UNIQUE Constraints | 10+ |
| Indexes | Optimized for reporting and transactional queries |

---

## Database Design Highlights

The Retail Sales Analytics & Inventory Management System has been designed following SQL Server best practices and enterprise database standards.

### Key Features

- Fully normalized database (Third Normal Form - 3NF)
- Consistent naming conventions
- Strong referential integrity using Foreign Keys
- Business validation using CHECK Constraints
- Automatic values using DEFAULT Constraints
- Audit columns for data tracking
- Optimized indexes for query performance
- Scalable architecture for future enhancements

---

## Business Coverage

The database supports the following business processes:

- Product Management
- Category Management
- Supplier Management
- Inventory Management
- Store Management
- Employee Management
- Customer Management
- Order Processing
- Payment Processing
- Return Management
- Sales Analytics
- Inventory Analytics

---

## Related Documentation

This data dictionary should be used together with the following project documentation:

| Document | Purpose |
|----------|---------|
| 01_Business_Requirements.md | Business requirements and project objectives |
| 02_Project_Architecture.md | Overall database architecture |
| 03_Naming_Conventions.md | Database naming standards |
| 05_Database_Design_Decisions.md | Design decisions and implementation rationale |
| 06_ER_Diagram.md | Database entity relationship diagram |

---

## Best Practices

When modifying the database:

- Follow the naming conventions defined in the project.
- Maintain referential integrity.
- Avoid introducing redundant data.
- Update the data dictionary whenever the schema changes.
- Keep the ER Diagram synchronized with the database.
- Ensure business rules remain enforced through constraints whenever possible.

---

# 9. Conclusion

The **Data Dictionary** serves as the central reference for the **Retail Sales Analytics & Inventory Management System** database.

It documents every table, column, relationship, constraint, and business rule implemented within the SQL Server database.

Maintaining this document ensures:

- Consistent database development
- Improved collaboration among developers and analysts
- Easier database maintenance
- Better understanding of business entities
- Reliable reporting and analytics
- Simplified onboarding for future contributors

This document should be updated whenever database objects are added, modified, or removed to ensure it remains the authoritative source of database metadata.

---

# Document Information

| Property | Value |
|----------|-------|
| Document | Data Dictionary |
| Project | Retail Sales Analytics & Inventory Management System |
| Database | RetailSalesDB |
| Version | 1.0 |
| Author | Akshay Aswani |
| Created On | July 2026 |
| Last Updated | July 2026 |
| Status | Approved |

---

# Revision History

| Version | Date | Author | Description |
|----------|------|--------|-------------|
| 1.0 | July 2026 | Akshay Aswani | Initial version of the Data Dictionary documenting all database tables, columns, relationships, constraints, and business rules. |

---

# Approval

**Status:** Approved

This document serves as the official data dictionary for the **Retail Sales Analytics & Inventory Management System** and should be maintained alongside the SQL Server database schema to ensure accuracy and consistency throughout the project lifecycle.