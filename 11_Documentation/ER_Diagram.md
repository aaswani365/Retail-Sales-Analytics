# Entity Relationship Diagram (ERD)

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Last Updated:** July 2026

---

# Purpose

This document defines the logical database structure and relationships between all entities in the Retail Sales Analytics & Inventory Management System.

The ER Diagram serves as the blueprint for database development and ensures referential integrity throughout the project.

---

# Database Overview

The database consists of **15 tables** divided into three logical groups.

## 1. Lookup Tables

| Table | Description |
|---------|-------------|
| Category | Product categories |
| SubCategory | Product subcategories |
| Brand | Product brands |
| Supplier | Product suppliers |
| PaymentMethod | Available payment methods |
| ReturnReason | Reasons for returned products |

---

## 2. Master Tables

| Table | Description |
|---------|-------------|
| Product | Product information |
| Store | Store information |
| Employee | Employee details |
| Customer | Customer details |

---

## 3. Transaction Tables

| Table | Description |
|---------|-------------|
| Inventory | Product stock by store |
| Order | Customer orders |
| OrderItem | Products within an order |
| Payment | Order payment information |
| Return | Returned order items |

---

# Entity Relationship Diagram

```text
                           Category
                              │
                              │ 1
                              │
                              ▼
                       SubCategory
                              │
                              │ 1
                              │
                              ▼
                           Product
                    ┌─────────┼──────────┐
                    │         │          │
                    │         │          │
                    ▼         ▼          ▼
                 Brand    Supplier   Inventory
                                        │
                                        │
                              ┌─────────┘
                              │
                              ▼
                          OrderItem
                              │
                              │
                              ▼
                            Order
                     ┌────────┴─────────┐
                     │                  │
                     ▼                  ▼
                Customer          Employee
                                      │
                                      ▼
                                    Store

Order
  │
  ▼
Payment
  │
  ▼
PaymentMethod

OrderItem
    │
    ▼
 Return
    │
    ▼
ReturnReason
```

---

# Primary Keys

| Table | Primary Key |
|---------|-------------|
| Category | CategoryID |
| SubCategory | SubCategoryID |
| Brand | BrandID |
| Supplier | SupplierID |
| Product | ProductID |
| Store | StoreID |
| Employee | EmployeeID |
| Customer | CustomerID |
| Inventory | InventoryID |
| Order | OrderID |
| OrderItem | OrderItemID |
| Payment | PaymentID |
| Return | ReturnID |
| PaymentMethod | PaymentMethodID |
| ReturnReason | ReturnReasonID |

---

# Foreign Keys

| Child Table | Foreign Key | Parent Table |
|--------------|-------------|--------------|
| SubCategory | CategoryID | Category |
| Product | SubCategoryID | SubCategory |
| Product | BrandID | Brand |
| Product | SupplierID | Supplier |
| Employee | StoreID | Store |
| Inventory | ProductID | Product |
| Inventory | StoreID | Store |
| Order | CustomerID | Customer |
| Order | EmployeeID | Employee |
| OrderItem | OrderID | Order |
| OrderItem | ProductID | Product |
| Payment | OrderID | Order |
| Payment | PaymentMethodID | PaymentMethod |
| Return | OrderItemID | OrderItem |
| Return | ReturnReasonID | ReturnReason |

---

# Relationship Cardinality

| Parent | Child | Relationship |
|----------|-------|--------------|
| Category | SubCategory | One-to-Many (1:N) |
| SubCategory | Product | One-to-Many (1:N) |
| Brand | Product | One-to-Many (1:N) |
| Supplier | Product | One-to-Many (1:N) |
| Store | Employee | One-to-Many (1:N) |
| Store | Inventory | One-to-Many (1:N) |
| Product | Inventory | One-to-Many (1:N) |
| Customer | Order | One-to-Many (1:N) |
| Employee | Order | One-to-Many (1:N) |
| Order | OrderItem | One-to-Many (1:N) |
| Product | OrderItem | One-to-Many (1:N) |
| Order | Payment | One-to-Many (1:N) |
| PaymentMethod | Payment | One-to-Many (1:N) |
| OrderItem | Return | One-to-Many (1:N) |
| ReturnReason | Return | One-to-Many (1:N) |

---

# Data Flow

The overall business process is:

1. Suppliers provide products.
2. Products are organized into categories and subcategories.
3. Products are stocked in stores through inventory.
4. Customers place orders.
5. Employees process customer orders.
6. Orders contain one or more order items.
7. Payments are recorded for each order.
8. Customers may return order items.
9. Every return must have a return reason.

---

# Database Design Principles

The database follows these principles:

- Third Normal Form (3NF)
- Primary and Foreign Key constraints
- Referential Integrity
- Lookup tables for reusable values
- Identity columns for surrogate keys
- Standardized naming conventions
- Optimized for analytical reporting

---

# Notes

- All primary keys use `INT IDENTITY(1,1)`.
- All foreign keys reference the corresponding primary key.
- Monetary values use `DECIMAL(10,2)` or `DECIMAL(12,2)` where appropriate.
- Date columns use `DATE` or `DATETIME2`.
- Table names use singular nouns.
- All database objects follow the project's naming conventions.

---

# Approval

**Status:** Approved

This ER Diagram is the official logical data model for the Retail Sales Analytics & Inventory Management System. Any structural changes after approval should be documented and version-controlled.