# Entity Relationship Diagram (ER Diagram)

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
3. [Entity Classification](#3-entity-classification)
4. [Relationship Legend](#4-relationship-legend)
5. [Entity Relationship Diagram](#5-entity-relationship-diagram)
6. [Relationship Summary](#6-relationship-summary)
7. [Database Design Highlights](#7-database-design-highlights)
8. [Referential Integrity](#8-referential-integrity)
9. [Normalization](#9-normalization)
10. [Design Principles](#10-design-principles)
11. [How to Read the Diagram](#11-how-to-read-the-diagram)
12. [Best Practices](#12-best-practices)
13. [Conclusion](#13-conclusion)

---

# 1. Purpose

The Entity Relationship (ER) Diagram provides a visual representation of the database structure used in the **Retail Sales Analytics & Inventory Management System**.

It illustrates how tables are connected through primary and foreign key relationships, helping developers, database administrators, and analysts understand the overall database architecture.

This document serves as a reference for:

- Database Developers
- SQL Developers
- Data Analysts
- Power BI Developers
- QA/Test Engineers
- Future Project Contributors

The ER Diagram complements the SQL schema and supporting documentation by providing a high-level overview of the database model.

---

# 2. Database Summary

| Item | Value |
|------|------:|
| Database | RetailSalesDB |
| Database Platform | Microsoft SQL Server |
| Database Type | Relational Database |
| Normalization | Third Normal Form (3NF) |
| Total Tables | 18 |
| Lookup Tables | 9 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| Primary Keys | 18 |
| Foreign Keys | 17 |
| Audit Columns | CreatedDate, ModifiedDate |

---

## Database Modules

The database is organized into logical business modules to improve scalability, maintainability, and reporting capabilities.

| Module | Purpose |
|---------|---------|
| Product Management | Categories, SubCategories, Brands, Suppliers, Products |
| Store Management | Stores and Employees |
| Customer Management | Customer information |
| Inventory Management | Product stock by store |
| Sales Management | Orders and Order Items |
| Payment Management | Payment processing and status tracking |
| Return Management | Product returns and refund processing |

---

## Database Architecture Overview

The RetailSalesDB follows a layered relational architecture:

```
Lookup Tables
        │
        ▼
Master Tables
        │
        ▼
Transaction Tables
```

### Lookup Tables

These tables store reusable reference data used throughout the database.

Examples include:

- Category
- Brand
- Supplier
- PaymentMethod
- OrderStatus
- ReturnStatus

---

### Master Tables

These tables represent the primary business entities.

Examples include:

- Product
- Customer
- Employee
- Store

---

### Transaction Tables

These tables capture daily business operations.

Examples include:

- Inventory
- Order
- OrderItem
- Payment
- Return

---

## Benefits of this Architecture

- Eliminates data redundancy
- Improves data consistency
- Supports referential integrity
- Simplifies reporting
- Optimizes query performance
- Enables future scalability
- Supports Power BI analytics
- Follows SQL Server best practices

---

# 3. Entity Classification

The **RetailSalesDB** is organized into three logical layers to improve maintainability, reduce redundancy, and simplify future enhancements.

---

## 3.1 Lookup Tables

Lookup tables contain relatively static reference data that is reused throughout the database. They help maintain consistency and reduce duplicate values.

| Table | Purpose |
|--------|---------|
| Category | Stores product categories |
| SubCategory | Stores product subcategories |
| Brand | Stores product brands |
| Supplier | Stores supplier information |
| PaymentMethod | Stores available payment methods |
| OrderStatus | Stores order lifecycle statuses |
| PaymentStatus | Stores payment statuses |
| ReturnReason | Stores valid return reasons |
| ReturnStatus | Stores return processing statuses |

### Characteristics

- Low transaction volume
- Frequently referenced
- Rarely updated
- Improve data consistency
- Reduce duplicate values

---

## 3.2 Master Tables

Master tables store the core business entities used by transactional processes.

| Table | Purpose |
|--------|---------|
| Product | Product catalog |
| Store | Retail store information |
| Employee | Employee information |
| Customer | Customer information |

### Characteristics

- Core business entities
- Frequently queried
- Referenced by multiple transaction tables
- Support reporting and analytics

---

## 3.3 Transaction Tables

Transaction tables capture daily operational activities.

| Table | Purpose |
|--------|---------|
| Inventory | Product stock by store |
| Order | Customer orders |
| OrderItem | Products within an order |
| Payment | Payment transactions |
| Return | Returned products |

### Characteristics

- High transaction volume
- Continuously growing
- Store historical business events
- Primary source for reporting and analytics

---

# 4. Relationship Legend

The following symbols and terminology are used throughout the ER Diagram.

## Relationship Symbols

| Symbol | Meaning |
|---------|---------|
| 1 | One |
| ∞ | Many |
| PK | Primary Key |
| FK | Foreign Key |

---

## Relationship Types

### One-to-One (1:1)

One record in the parent table is related to exactly one record in the child table.

Example:

```
Person
   │
   │
Passport
```

> This relationship is **not used** in the current database design.

---

### One-to-Many (1:N)

One record in the parent table can be associated with many records in the child table.

Example:

```
Category
     │
     ├──────────► SubCategory
```

This is the most common relationship used throughout the RetailSalesDB.

---

### Many-to-One (N:1)

Many child records reference a single parent record.

Example:

```
Product
     │
     ▼
Supplier
```

---

## Primary Keys (PK)

Every table uses a surrogate primary key based on:

```sql
INT IDENTITY(1,1)
```

Benefits include:

- Faster joins
- Better indexing
- Smaller storage footprint
- Stable identifiers
- Improved SQL Server performance

---

## Foreign Keys (FK)

Foreign keys establish relationships between tables and enforce referential integrity.

Example:

```
Product
   │
BrandID
   │
   ▼
Brand
```

Benefits:

- Prevent orphan records
- Ensure valid parent-child relationships
- Improve data consistency
- Support accurate reporting

---

# 5. Entity Relationship Diagram

The following Entity Relationship Diagram illustrates all tables and their relationships within the **RetailSalesDB**.

---

<p align="center">

![Retail Sales ER Diagram](Images/ER_Diagram.png)

</p>

---

## Diagram Overview

The ER Diagram represents:

- All database tables
- Primary Keys (PK)
- Foreign Keys (FK)
- One-to-Many relationships
- Logical grouping of entities
- Complete relational structure of the database

The diagram is intended to provide a high-level overview of the database schema and should be used alongside the SQL scripts and Data Dictionary for detailed implementation information.

---

## Reading the Diagram

The diagram is organized from top to bottom using a layered architecture:

```
Lookup Tables
        │
        ▼
Master Tables
        │
        ▼
Transaction Tables
```

This layout reflects the dependency flow of the database:

- Lookup tables provide reference data.
- Master tables store core business entities.
- Transaction tables record day-to-day business activities.

---

# 6. Relationship Summary

The following table summarizes all primary relationships implemented in the RetailSalesDB.

| Parent Table | Child Table | Relationship | Foreign Key |
|--------------|-------------|--------------|-------------|
| Category | SubCategory | One-to-Many | CategoryID |
| SubCategory | Product | One-to-Many | SubCategoryID |
| Brand | Product | One-to-Many | BrandID |
| Supplier | Product | One-to-Many | SupplierID |
| Store | Employee | One-to-Many | StoreID |
| Store | Inventory | One-to-Many | StoreID |
| Product | Inventory | One-to-Many | ProductID |
| Customer | Order | One-to-Many | CustomerID |
| Employee | Order | One-to-Many | EmployeeID |
| OrderStatus | Order | One-to-Many | OrderStatusID |
| Order | OrderItem | One-to-Many | OrderID |
| Product | OrderItem | One-to-Many | ProductID |
| Order | Payment | One-to-Many | OrderID |
| PaymentMethod | Payment | One-to-Many | PaymentMethodID |
| PaymentStatus | Payment | One-to-Many | PaymentStatusID |
| OrderItem | Return | One-to-Many | OrderItemID |
| ReturnReason | Return | One-to-Many | ReturnReasonID |
| ReturnStatus | Return | One-to-Many | ReturnStatusID |

---

## Relationship Flow

The following simplified flow illustrates how data moves through the retail system.

```text
Category
      │
      ▼
SubCategory
      │
      ▼
Product
 ┌────┴────┐
 ▼         ▼
Inventory  OrderItem
              ▲
              │
           Order
        ┌───┴────┐
        ▼        ▼
    Payment    Customer
        │
        ▼
Payment Status

OrderItem
      │
      ▼
Return
```

The complete relationship structure is illustrated in the ER Diagram shown earlier.

---

# 7. Database Design Highlights

The RetailSalesDB has been designed following SQL Server best practices and modern relational database design principles.

## Key Highlights

- Third Normal Form (3NF) database design
- Surrogate primary keys using `INT IDENTITY(1,1)`
- Strict referential integrity through Foreign Keys
- Business validation using CHECK Constraints
- Automatic default values using DEFAULT Constraints
- Optimized indexing strategy
- Audit columns for record tracking
- Lookup tables to reduce data redundancy
- Scalable architecture supporting future enhancements
- Analytics-ready design for Power BI reporting

---

## Why This Design?

The database separates business entities into logical layers.

```
Lookup
    │
    ▼
Master
    │
    ▼
Transaction
```

This architecture provides:

- Better maintainability
- Higher scalability
- Easier reporting
- Reduced redundancy
- Improved performance
- Cleaner database structure

---

# 8. Referential Integrity

Referential integrity ensures that every relationship within the database remains valid.

The RetailSalesDB uses Foreign Key constraints to guarantee consistency across all related tables.

Examples include:

- A Product must belong to a valid Brand.
- A Product must belong to a valid Supplier.
- A Product must belong to a valid SubCategory.
- An Employee must belong to a valid Store.
- An Order must belong to a valid Customer.
- Every Payment must reference an existing Order.
- Every Return must reference an existing Order Item.

---

## Benefits

- Prevents orphan records
- Ensures data consistency
- Protects transactional integrity
- Improves reporting accuracy
- Simplifies application logic

---

## Example

```text
Customer
    │
    │
    ▼
Order
    │
    │
    ▼
OrderItem
```

Without referential integrity, an Order could exist without a valid Customer.

The implemented Foreign Keys prevent these situations.

---

# 9. Normalization

The RetailSalesDB follows the principles of **Third Normal Form (3NF)**.

---

## First Normal Form (1NF)

The database satisfies 1NF because:

- Every table has a Primary Key.
- Columns contain atomic values.
- No repeating groups exist.

---

## Second Normal Form (2NF)

The database satisfies 2NF because:

- Every non-key attribute depends on the entire Primary Key.
- No partial dependencies exist.

---

## Third Normal Form (3NF)

The database satisfies 3NF because:

- Non-key attributes depend only on the Primary Key.
- No transitive dependencies exist.
- Lookup tables store reusable reference data.

Examples:

Instead of storing:

```
Product
CategoryName
BrandName
SupplierName
```

The database stores:

```
Product
CategoryID
BrandID
SupplierID
```

which reference dedicated lookup tables.

---

## Benefits of Normalization

- Eliminates duplicate data
- Improves consistency
- Simplifies maintenance
- Reduces storage requirements
- Improves update performance
- Supports scalable database growth

---

## Normalization Level

| Normal Form | Status |
|--------------|:------:|
| First Normal Form (1NF) | ✅ |
| Second Normal Form (2NF) | ✅ |
| Third Normal Form (3NF) | ✅ |

The RetailSalesDB has been intentionally designed to comply with Third Normal Form while maintaining high performance for transactional processing and business reporting.

---

# 10. Design Principles

The ER Diagram reflects the core design principles followed throughout the RetailSalesDB.

---

## Simplicity

The database structure is designed to be easy to understand and maintain. Each table has a clearly defined responsibility, minimizing unnecessary complexity.

---

## Normalization

The database follows **Third Normal Form (3NF)** to eliminate redundancy and improve data consistency.

Benefits include:

- Reduced duplicate data
- Simplified updates
- Improved data integrity
- Better long-term maintainability

---

## Data Integrity

Primary Keys, Foreign Keys, CHECK Constraints, DEFAULT Constraints, and UNIQUE Constraints work together to ensure the accuracy and consistency of stored data.

Examples include:

- Every Product belongs to a valid Brand.
- Every Order belongs to a valid Customer.
- Every Payment belongs to an existing Order.
- Every Return references an existing Order Item.

---

## Scalability

The schema is designed to support future business growth with minimal structural changes.

Possible future enhancements include:

- Multiple warehouse support
- Product reviews
- Shopping cart functionality
- Promotions and coupons
- Loyalty programs
- Shipment tracking
- Multi-currency support
- Multi-country operations

---

## Performance

The database design emphasizes efficient transactional processing and analytical reporting.

Performance is achieved through:

- Clustered Primary Keys
- Non-Clustered Indexes
- Optimized table relationships
- Appropriate data types
- Third Normal Form (3NF)
- Reduced data redundancy

---

# 11. How to Read the Diagram

The ER Diagram should be interpreted from the top layer downward.

```
Lookup Tables
        │
        ▼
Master Tables
        │
        ▼
Transaction Tables
```

### Step 1 — Lookup Tables

Lookup tables provide reusable reference data for the rest of the database.

Examples:

- Category
- Brand
- Supplier
- Payment Method
- Order Status

---

### Step 2 — Master Tables

Master tables contain the core business entities used in day-to-day operations.

Examples:

- Product
- Store
- Employee
- Customer

---

### Step 3 — Transaction Tables

Transaction tables capture operational activities such as sales, inventory, payments, and returns.

Examples:

- Inventory
- Order
- OrderItem
- Payment
- Return

---

### Reading Relationships

Each connecting line represents a **Primary Key → Foreign Key** relationship.

Example:

```
Customer
     │
     ▼
Order
```

One customer can place many orders, but every order belongs to exactly one customer.

---

# 12. Best Practices

The following best practices should be followed when modifying the database or updating the ER Diagram.

## Database

- Maintain Third Normal Form (3NF)
- Preserve referential integrity
- Avoid duplicate business data
- Use appropriate SQL Server data types
- Apply meaningful constraint names
- Follow project naming conventions

---

## Documentation

Whenever the database schema changes:

- Update the ER Diagram
- Update the Data Dictionary
- Update the Database Design Decisions document
- Update SQL scripts if required
- Review affected relationships

---

## Version Control

When making structural changes:

- Commit SQL changes and documentation updates together.
- Use meaningful Git commit messages.
- Keep the ER Diagram synchronized with the latest schema.

---

# 13. Conclusion

The Entity Relationship Diagram provides a visual representation of the **RetailSalesDB** and serves as the primary reference for understanding the database structure.

It illustrates:

- All database tables
- Primary and Foreign Key relationships
- One-to-Many relationships
- Logical separation of lookup, master, and transaction tables
- Overall database architecture

Together with the SQL scripts, Data Dictionary, Naming Conventions, and Database Design Decisions, this document provides a comprehensive understanding of the Retail Sales Analytics & Inventory Management System.

Maintaining this diagram alongside the database schema ensures that developers, analysts, and future contributors always have an accurate representation of the system.

---

## Document Information

| Property | Value |
|----------|-------|
| Document | Entity Relationship Diagram |
| Project | Retail Sales Analytics & Inventory Management System |
| Database | RetailSalesDB |
| Version | 1.0 |
| Author | Akshay Aswani |
| Created On | July 2026 |
| Last Updated | July 2026 |
| Status | Approved |

---

## Approval

**Status:** Approved

This document serves as the official Entity Relationship Diagram documentation for the **Retail Sales Analytics & Inventory Management System**. It should be maintained alongside the SQL Server database schema and updated whenever structural changes are introduced to ensure continued accuracy and consistency.