# Naming Conventions

## Retail Sales Analytics & Inventory Management System

**Document Version:** 1.0  
**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Author:** Akshay Aswani  
**Last Updated:** July 2026

---

# Purpose

This document defines the naming standards used throughout the project to ensure consistency, readability, maintainability, and alignment with SQL Server best practices.

---

# General Naming Rules

- Use **PascalCase** for all database objects.
- Use meaningful and descriptive names.
- Avoid abbreviations unless they are industry standard.
- Use singular names for tables.
- Do not use spaces or special characters.
- Avoid SQL reserved keywords.
- Maintain consistent naming across the project.

**Example**

✅ Customer

❌ Customers_Data

❌ Cust

❌ tblCustomer

---

# Database Naming

Format

```
<ProjectName>DB
```

Example

```
RetailSalesDB
```

---

# Schema Naming

Default schema

```
dbo
```

---

# Table Naming

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

# Column Naming

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

# Primary Key Naming

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

# Foreign Key Naming

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

# Constraint Naming

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
CHK_<TableName>_<ColumnName>
```

Examples

```
CHK_Product_SellingPrice

CHK_Product_Stock

CHK_Employee_Salary
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

# Index Naming

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

# View Naming

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

# Stored Procedure Naming

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

# User Defined Function Naming

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

# Trigger Naming

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

# Variable Naming

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

# Temporary Tables

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

# File Naming

Use numeric prefixes to maintain execution order.

Examples

```
01_Create_Database.sql

02_Create_Tables.sql

03_Create_Constraints.sql

04_Create_Indexes.sql

05_Insert_Categories.sql

06_Insert_SubCategories.sql

07_Insert_Brands.sql
```

---

# SQL Formatting Standards

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

# Documentation Standards

Every SQL file must include:

- Project Name
- File Name
- Author
- Version
- Description
- Last Updated

Example

```sql
/*============================================================
Project     : Retail Sales Analytics & Inventory Management System
File Name   : 02_Create_Tables.sql
Author      : Akshay Aswani
Version     : 1.0
Description : Creates all database tables.
============================================================*/
```

---

# Naming Convention Checklist

- PascalCase naming
- Singular table names
- Descriptive object names
- Standardized constraints
- Consistent index names
- Consistent procedure names
- Professional SQL formatting
- Standardized documentation headers

---

# Approval

**Status:** Approved

This document serves as the official naming standard for the Retail Sales Analytics & Inventory Management System project.