# Database Design Decisions

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Last Updated:** July 2026

---

# Purpose

This document explains the key database design decisions made during the development of the Retail Sales Analytics & Inventory Management System. It provides the rationale behind the database architecture, normalization approach, relationships, and implementation choices.

---

# Database Summary

| Category | Count |
|----------|------:|
| Lookup Tables | 9 |
| Master Tables | 4 |
| Transaction Tables | 5 |
| **Total Tables** | **18** |

---

# 1. Database Architecture

The database is organized into three logical layers:

- Lookup Tables
- Master Tables
- Transaction Tables

This separation improves maintainability, scalability, and readability.

---

# 2. Normalization

The database is designed according to **Third Normal Form (3NF)** to eliminate redundancy and maintain data integrity.

### Key Normalization Decisions

- Categories and SubCategories are stored separately.
- Brands are maintained independently of products.
- Suppliers are stored in a dedicated master table.
- Payment methods are managed through a lookup table.
- Return reasons are maintained in a lookup table.
- Order, Payment, and Return statuses are stored in dedicated lookup tables instead of text fields.

### Benefits

- Eliminates duplicate data
- Prevents update anomalies
- Improves data consistency
- Reduces storage redundancy
- Simplifies maintenance
- Supports scalable database growth

---

# 3. Primary Keys

All tables use an integer surrogate key with:

```sql
INT IDENTITY(1,1)
```

### Why?

- Fast indexing
- Smaller storage than GUID
- Better join performance
- Simple foreign key relationships

---

# 4. Foreign Keys

Foreign keys enforce referential integrity between related tables.

### Example

- Product → Brand
- Product → Supplier
- Order → Customer
- OrderItem → Product

This prevents orphan records and ensures data consistency.

---

# 5. Lookup Tables

Lookup tables are used for reusable business values such as:

- Category
- SubCategory
- Brand
- Supplier
- PaymentMethod
- ReturnReason
- OrderStatus
- PaymentStatus
- ReturnStatus

### Why?

Instead of storing status values as text (VARCHAR), dedicated lookup tables are used.

Example:

Order

| OrderID | OrderStatusID |
|---------:|--------------:|
| 1001 | 3 |

OrderStatus

| OrderStatusID | StatusName |
|--------------:|------------|
| 1 | Pending |
| 2 | Processing |
| 3 | Completed |
| 4 | Cancelled |
| 5 | Returned |

This approach:

- Prevents inconsistent status values
- Enforces referential integrity
- Improves reporting performance
- Supports future business changes without modifying the schema

---

# 6. Product and Inventory Separation

Inventory information is stored in a separate table instead of the Product table.

### Reason

A product can exist in multiple stores.

Example

| Product | Store | Stock |
|----------|-------|------:|
| Laptop | Jaipur | 12 |
| Laptop | Delhi | 8 |
| Laptop | Pune | 15 |

This creates a one-to-many relationship between Product and Inventory.

---

# 7. Order and OrderItem Design

Orders and their items are stored separately.

### Reason

One order may contain multiple products.

Example

| OrderID | Product |
|---------|---------|
| 1001 | Laptop |
| 1001 | Mouse |
| 1001 | Keyboard |

This supports unlimited products per order.

---

# 8. Historical Pricing

The `OrderItem` table stores the product's selling price at the time of purchase.

### Why?

Product prices may change over time.

Example

| Product | Current Price |
|----------|--------------:|
| Laptop | ₹65,000 |

An older order may have been sold for ₹60,000.

Keeping the historical price ensures accurate reporting and auditing.

---

# 9. Payment Design

Payments are stored separately from orders.

### Benefits

- Supports multiple payments for one order
- Supports different payment methods
- Simplifies payment tracking
- Enables future enhancements such as partial payments

---

# 10. Return Management

Returns are linked to `OrderItem` instead of directly to `Order`.

### Reason

Customers often return only selected items from an order.

Example

Order contains:

- Laptop
- Mouse
- Keyboard

Customer returns only the Mouse.

This design accurately tracks item-level returns.

---

# 11. Data Types

The following data types are used consistently:

| Data Type | Purpose |
|-----------|---------|
| INT | Primary & Foreign Keys |
| VARCHAR | Text values |
| DECIMAL(10,2) | Prices |
| DECIMAL(12,2) | Totals and payments |
| DATE | Dates |
| DATETIME2 | Date & Time |
| BIT | Boolean values |

---

# 12. Naming Standards

The project follows consistent naming conventions.

Examples

```
ProductID
CustomerID
OrderID
SupplierID
```

Constraint examples

```
PK_Product
FK_Order_Customer
IX_Product_ProductName
```

---

# 13. Reserved SQL Keywords

Some business entities have names that are SQL Server reserved keywords.

Examples

- Order
- Return

In SQL scripts they are written as:

```sql
[Order]

[Return]
```

This avoids syntax errors while keeping business-friendly names.

---

# 14. Performance Considerations

The database is designed for efficient querying.

Techniques include:

- Primary Keys
- Foreign Keys
- Indexes
- Normalization
- Efficient joins
- Appropriate data types

---

# 15. Audit Columns

Transaction tables include audit columns to support operational tracking.

Standard audit fields include:

- CreatedDate
- ModifiedDate

### Benefits

- Tracks when records are created and updated
- Supports future ETL processes
- Enables auditing and troubleshooting
- Improves enterprise readiness

---

# 16. Scalability

The design supports future expansion.

Possible future enhancements include:

- Promotions
- Coupons
- Warehouses
- Product Reviews
- Loyalty Program
- Online Orders
- Shipment Tracking

Additionally, the database has been designed to support future business growth without requiring structural changes:

- Additional order statuses can be added without changing the database schema.
- New payment and return statuses can be introduced by inserting records into their respective lookup tables.

These features can be added without major structural changes.

---

# Conclusion

The database has been designed using industry best practices to ensure:

- Data integrity
- High performance
- Scalability
- Maintainability
- Readability
- Reporting efficiency

The architecture supports both transactional processing and analytical reporting, making it suitable for SQL Server and Power BI–based business intelligence solutions.