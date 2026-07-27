# Naming Conventions

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
2. [General Naming Rules](#2-general-naming-rules)
3. [Database Naming](#3-database-naming)
4. [Schema Naming](#4-schema-naming)
5. [Table Naming](#5-table-naming)
6. [Column Naming](#6-column-naming)
7. [Primary Key Naming](#7-primary-key-naming)
8. [Foreign Key Naming](#8-foreign-key-naming)
9. [Constraint Naming](#9-constraint-naming)
10. [Index Naming](#10-index-naming)
11. [Stored Procedure Naming](#11-stored-procedure-naming)
12. [View Naming](#12-view-naming)
13. [User Defined Function Naming](#13-user-defined-function-naming)
14. [Trigger Naming](#14-trigger-naming)
15. [Variable Naming](#15-variable-naming)
16. [Temporary Tables](#16-temporary-tables)
17. [File Naming](#17-file-naming)
18. [SQL Formatting Standards](#18-sql-formatting-standards)
19. [Documentation Standards](#19-documentation-standards)
20. [Naming Convention Checklist](#20-naming-convention-checklist)
21. [Approval](#21-approval)

---

# 1. Purpose

This document defines the naming conventions used throughout the Retail Sales Analytics & Inventory Management System. Following consistent naming standards improves readability, maintainability, collaboration, and long-term scalability of the database project.

---

# 2. General Naming Rules

- Use **PascalCase** for all database objects.
- Use meaningful and descriptive names.
- Avoid abbreviations unless they are industry standard.
- Use singular names for tables.
- Avoid spaces and special characters.
- Maintain consistent naming across the project.

**Example**

✅ Customer

❌ Customers_Data

❌ Cust

❌ tblCustomer

## Reserved Keywords

Avoid using SQL Server reserved keywords as object names.

Examples to avoid:

- User
- Table
- Group
- Order
- Select
- Index

If a business requirement requires a reserved keyword (for example, `Order`), use square brackets when referencing the object in SQL statements.

Example:

```sql
SELECT *
FROM dbo.[Order];
```

---

# 3. Database Naming

Format

```
<ProjectName>DB
```

Example

```
RetailSalesDB
```

---

# 4. Schema Naming

Default schema

```
dbo
```

---

# 5. Table Naming

Use singular nouns.

Examples

```
Category
SubCategory
Brand
Supplier
Product
Store
Employee
Customer
Order
OrderItem
Payment
Inventory
Return
PaymentMethod
ReturnReason
```

---

# 6. Column Naming

Use PascalCase.

Examples

```
ProductID
ProductName
CategoryID
StoreID
OrderDate
SellingPrice
CreatedDate
```

Avoid

```
product_name

productname

prodName
```

---

# 7. Primary Key Naming

Every table uses

```
<TableName>ID
```

Examples

```
ProductID
CustomerID
StoreID
OrderID
SupplierID
```

---

# 8. Foreign Key Naming

Use the exact primary key name from the referenced table.

Examples

```
CategoryID

SubCategoryID

ProductID

CustomerID

StoreID
```

---

# 9. Constraint Naming

## Primary Key

Format

```
PK_<TableName>
```

Examples

```
PK_Product

PK_Order

PK_Customer
```

---

## Foreign Key

Format

```
FK_<ChildTable>_<ParentTable>
```

Examples

```
FK_Product_Category

FK_Product_SubCategory

FK_Order_Customer

FK_OrderItem_Product

FK_Inventory_Store
```

---

## Default Constraint

Format

```
DF_<TableName>_<ColumnName>
```

Examples

```
DF_Product_IsActive

DF_Order_OrderDate
```

---

## Check Constraint

Format

```
CK_<TableName>_<ColumnName>
```

Examples

```
CK_Product_SellingPrice

CK_Product_Stock

CK_Employee_Salary
```

---

## Unique Constraint

Format

```
UQ_<TableName>_<ColumnName>
```

Examples

```
UQ_Product_SKU

UQ_Customer_Email
```

---

# 10. Index Naming

## Clustered Index

```
CX_<TableName>
```

Example

```
CX_Order
```

---

## Non-Clustered Index

```
IX_<TableName>_<ColumnName>
```

Examples

```
IX_Product_ProductName

IX_Order_OrderDate

IX_Customer_City
```

---

# 11. Stored Procedure Naming

Format

```
usp_<Action><Object>
```

Examples

```
usp_GetTopCustomers

usp_GetMonthlySales

usp_UpdateInventory

usp_InsertOrder
```

---

# 12. View Naming

Format

```
vw_<Description>
```

Examples

```
vw_SalesSummary

vw_ProductInventory

vw_CustomerRevenue
```

---

# 13. User Defined Function Naming

Format

```
fn_<Description>
```

Examples

```
fn_CalculateProfit

fn_TotalSales

fn_OrderCount
```

---

# 14. Trigger Naming

Format

```
trg_<TableName>_<Action>
```

Examples

```
trg_Product_Insert

trg_Order_Update

trg_Inventory_Delete
```

---

# 15. Variable Naming

Local variables

```
@ProductID

@CustomerID

@OrderDate

@TotalAmount
```

Table variables

```
@SalesSummary

@TopProducts
```

---

# 16. Temporary Tables

Local

```
#Sales

#TopCustomers
```

Global

```
##MonthlySales
```

---

# 17. File Naming

Use numeric prefixes to maintain execution order.

Examples

```
01_Create_Database.sql

02_Create_Tables.sql

03_Create_Constraints.sql

04_Create_Indexes.sql

05_Insert_Lookup_Data.sql

06_Generate_Master_Data.sql
```

---

# 18. SQL Formatting Standards

- SQL keywords in **UPPERCASE**
- One column per line in `SELECT`
- One table per line in `JOIN`
- Indent nested queries
- Align commas consistently
- End every statement with a semicolon (`;`) where appropriate
- Separate logical sections with comments

Example

```sql
SELECT
    ProductID,
    ProductName,
    SellingPrice
FROM Product
WHERE SellingPrice > 1000
ORDER BY ProductName;
```

---

# 19. Documentation Standards

Every SQL script should include the following standardized header:

Every SQL script should include the following standardized header:

- Project
- Database
- File Name
- Author
- Version
- Created On
- Last Updated
- Description

Example

```sql
/*============================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 02_Create_Tables.sql
Author       : Akshay Aswani
Version      : 2.0
Created On   : July 2026
Last Updated : July 2026
Description	 : Creates all database tables for the Retail Sales Analytics & Inventory Management System.
============================================================*/
```

---

# 20. Naming Convention Checklist

- PascalCase naming
- Singular table names
- Descriptive object names
- Standardized constraints
- Consistent index names
- Consistent procedure names
- Consistent audit column names
- Consistent file naming
- Professional SQL formatting
- Standardized documentation headers

---

**Document Version:** 1.0

**Status:** Approved

**Approved By:** Project Author

This document defines the official SQL Server naming conventions for the Retail Sales Analytics & Inventory Management System.