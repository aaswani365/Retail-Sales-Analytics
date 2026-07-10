# Business Requirements Document (BRD)

# Retail Sales Analytics & Inventory Management System

Version: 1.0

---

# 1. Introduction

Retail organizations generate thousands of transactions every day across multiple stores, products, customers, and suppliers. Managing this data efficiently is essential for improving sales performance, inventory management, customer satisfaction, and business profitability.

This project aims to design and develop a production-inspired retail database using Microsoft SQL Server that supports operational reporting and business intelligence through SQL analysis and Power BI dashboards.

---

# 2. Business Problem

The retail company currently lacks a centralized system to analyze sales, inventory, customer purchasing behavior, supplier performance, and store performance.

Business users spend significant time preparing reports manually, making it difficult to make timely business decisions.

A centralized analytics database is required to provide accurate, consistent, and reliable business insights.

---

# 3. Project Objectives

The primary objectives of this project are:

- Design a normalized SQL Server database
- Store realistic retail business data
- Track customer orders
- Manage inventory across stores
- Monitor supplier performance
- Analyze sales trends
- Measure business KPIs
- Support Power BI reporting
- Demonstrate SQL skills for portfolio purposes

---

# 4. Stakeholders

| Stakeholder | Responsibilities |
|-------------|------------------|
| CEO | Business performance monitoring |
| Sales Manager | Sales analysis |
| Inventory Manager | Stock management |
| Store Manager | Store performance |
| Finance Team | Revenue & payments |
| Procurement Team | Supplier management |
| Data Analyst | Reporting & dashboard development |

---

# 5. Project Scope

The project includes:

- Product Management
- Customer Management
- Supplier Management
- Store Management
- Inventory Management
- Order Processing
- Payment Tracking
- Returns Management
- SQL Analytics
- Power BI Reporting

---

# 6. Out of Scope

The following features are intentionally excluded:

- User Authentication
- Employee Payroll
- GST Billing
- Online Payment Gateway Integration
- Mobile Application
- Website Development

---

# 7. Key Performance Indicators (KPIs)

The project will support analysis of:

## Sales KPIs

- Total Revenue
- Total Orders
- Average Order Value
- Monthly Revenue
- Yearly Revenue
- Revenue Growth %

---

## Customer KPIs

- Total Customers
- Repeat Customers
- Customer Lifetime Value
- Average Basket Size
- Customer Retention Rate

---

## Product KPIs

- Top Selling Products
- Least Selling Products
- Category Performance
- Brand Performance
- Supplier Performance

---

## Inventory KPIs

- Current Stock
- Low Stock Products
- Inventory Turnover
- Reorder Analysis
- Out of Stock Products

---

## Store KPIs

- Store Revenue
- Store Profit
- Orders by Store
- Top Performing Store

---

# 8. Expected Reports

The solution should support reports such as:

- Daily Sales Report
- Monthly Sales Report
- Category Sales Report
- Brand Performance Report
- Customer Purchase Report
- Supplier Performance Report
- Inventory Report
- Store Performance Report
- Payment Summary
- Return Analysis Report

---

# 9. Expected Dataset

| Table | Records |
|--------|--------:|
| Categories | 20 |
| SubCategories | 100 |
| Brands | 100 |
| Suppliers | 100 |
| Products | 500 |
| Stores | 10 |
| Employees | 25 |
| Customers | 5,000 |
| Orders | 25,000 |
| OrderItems | 75,000 |
| Payments | 25,000 |
| Inventory | 5,000 |
| Returns | 2,500 |

Approximate Total Records: 138,000+

---

# 10. Success Criteria

The project will be considered successful if it:

- Implements a normalized relational database
- Maintains referential integrity
- Supports advanced SQL analysis
- Provides realistic business data
- Enables interactive Power BI dashboards
- Demonstrates SQL Server best practices
- Serves as a professional Data Analyst portfolio project

---

Document Version: 1.0
Status: Approved