# Project Architecture

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Created On:** July 2026  
**Last Updated:** July 2026

---

# Purpose

This document describes the overall architecture of the **Retail Sales Analytics & Inventory Management System**. It explains how the database is organized into logical layers, how data flows between entities, and the design principles used to build a scalable, maintainable, and analytics-ready SQL Server database.

---

## Table of Contents

1. [Database Overview](#1-database-overview)
2. [Architecture Overview](#2-architecture-overview)
3. [Database Layers](#3-database-layers)
4. [Data Flow](#4-data-flow)
5. [Database Design Principles](#5-database-design-principles)
6. [Technology Stack](#6-technology-stack)
7. [Target Dataset](#7-target-dataset)
8. [Future Scalability](#8-future-scalability)
9. [Conclusion](#9-conclusion)

---

# 1. Database Overview

The project is designed as a normalized relational database using **Microsoft SQL Server**. The architecture separates business data into three logical layers:

- Lookup Tables
- Master Tables
- Transaction Tables

This layered architecture improves:

- Data consistency
- Maintainability
- Scalability
- Query performance
- Business reporting

---

# 2. Architecture Overview

```text
RetailSalesDB
│
├── Lookup Tables
│
├── Master Tables
│
└── Transaction Tables
```

Each layer has a specific responsibility within the database.

---

# 3. Database Layers

## Lookup Tables

Lookup tables store reusable business values that minimize redundancy and improve consistency.

| Table | Purpose |
|---------|---------|
| Category | Product categories |
| SubCategory | Product subcategories |
| Brand | Product brands |
| Supplier | Product suppliers |
| PaymentMethod | Payment methods |
| OrderStatus | Order lifecycle statuses |
| PaymentStatus | Payment statuses |
| ReturnReason | Product return reasons |
| ReturnStatus | Return processing statuses |

---

## Master Tables

Master tables store the core business entities.

| Table | Purpose |
|---------|---------|
| Store | Store information |
| Employee | Employee details |
| Customer | Customer information |
| Product | Product catalog |

---

## Transaction Tables

Transaction tables capture day-to-day business activities.

| Table | Purpose |
|---------|---------|
| Inventory | Product stock by store |
| Order | Customer orders |
| OrderItem | Products within an order |
| Payment | Customer payments |
| Return | Product returns |

---

# 4. Data Flow

The simplified business flow is illustrated below.

```text
Category
      │
      ▼
SubCategory
      │
      ▼
Product
      │
      ▼
Inventory
      │
      ▼
Customer
      │
      ▼
Order
      │
      ▼
OrderItem
      │
      ├────────► Payment
      │
      └────────► Return
```

This workflow represents the movement of business data from product classification through inventory, customer purchases, payment processing, and product returns.

---

# 5. Database Design Principles

The database has been designed following SQL Server best practices.

### Normalization

- Third Normal Form (3NF)

### Data Integrity

- Primary Keys
- Foreign Keys
- CHECK Constraints
- DEFAULT Constraints
- UNIQUE Constraints

### Performance

- Clustered Primary Keys
- Optimized Indexes
- Appropriate Data Types

### Maintainability

- Consistent Naming Conventions
- Modular Database Structure
- Audit Columns
- Reusable Lookup Tables

### Scalability

- Easy to add new lookup values
- Supports future business modules
- Designed for large transactional datasets

---

# 6. Technology Stack

| Component | Technology |
|-----------|------------|
| Database | Microsoft SQL Server |
| Query Language | T-SQL |
| Reporting | Power BI |
| Version Control | Git & GitHub |
| Documentation | Markdown |
| ER Diagram | Database Diagram / PNG |

---

# 7. Target Dataset

| Item | Value |
|------|------:|
| Total Tables | 18 |
| Lookup Tables | 9 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| Expected Records | 500,000+ *(Planned)* |
| Database | SQL Server |
| Reporting Tool | Power BI |

The project is designed to simulate a medium-sized retail business with sufficient data volume for advanced SQL analysis and interactive Power BI dashboards.

---

# 8. Future Scalability

The database architecture is designed to support future enhancements without major structural changes.

Possible future enhancements include:

- Warehouse Management
- Shipment Tracking
- Promotions and Discounts
- Coupon Management
- Loyalty Program
- Product Reviews
- Online Orders
- Multi-Currency Support
- Multi-Warehouse Inventory
- Sales Forecasting

---

# 9. Conclusion

The Retail Sales Analytics & Inventory Management System follows a modular and scalable database architecture that separates lookup, master, and transaction data into logical layers.

The architecture ensures:

- High data integrity
- Reduced redundancy
- Improved maintainability
- Better query performance
- Scalability for future enhancements
- Efficient reporting through SQL Server and Power BI

This architecture provides a strong foundation for both **Online Transaction Processing (OLTP)** and **Business Intelligence (BI)** reporting, making it suitable as a production-inspired database project and professional data analytics portfolio.