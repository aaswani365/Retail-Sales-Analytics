# Business Requirements Document (BRD)

## Retail Sales Analytics & Inventory Management System

**Project:** Retail Sales Analytics & Inventory Management System  
**Database:** RetailSalesDB  
**Version:** 1.0  
**Author:** Akshay Aswani  
**Created On:** July 2026  
**Last Updated:** July 2026

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Business Problem](#2-business-problem)
3. [Project Objectives](#3-project-objectives)
4. [Stakeholders](#4-stakeholders)
5. [Project Scope](#5-project-scope)
6. [Out of Scope](#6-out-of-scope)
7. [Key Performance Indicators](#7-key-performance-indicators-kpis)
8. [Expected Reports](#8-expected-reports)
9. [Expected Dataset](#9-expected-dataset)
10. [Success Criteria](#10-success-criteria)
11. [Assumptions](#11-assumptions)
12. [Business Benefits](#12-business-benefits)
13. [Future Enhancements](#13-future-enhancements)
14. [Conclusion](#14-conclusion)

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

| Table         |             Records |
| ------------- | ------------------: |
| Category      |                  10 |
| SubCategory   |                  30 |
| Brand         |                  30 |
| Supplier      |                  20 |
| PaymentMethod |                   8 |
| OrderStatus   |                   7 |
| PaymentStatus |                   5 |
| ReturnReason  |                  10 |
| ReturnStatus  |                   5 |
| Store         |                  20 |
| Employee      |                 200 |
| Customer      |              10,000 |
| Product       |               5,000 |
| Inventory     |  15,000 *(planned)* |
| Order         | 100,000 *(planned)* |
| OrderItem     | 300,000 *(planned)* |
| Payment       | 100,000 *(planned)* |
| Return        |   8,000 *(planned)* |

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

# 11. Assumptions

- The system supports multiple retail stores.
- Each product belongs to one subcategory.
- Each subcategory belongs to one category.
- Each order is placed by one customer.
- Payments are associated with orders.
- Inventory is maintained separately for each store.
- Returns are processed at the order item level.

---

# 12. Business Benefits

The proposed solution provides the following benefits:

- Centralized retail data management
- Improved reporting accuracy
- Faster business decision-making
- Better inventory control
- Enhanced customer insights
- Performance monitoring across stores
- Scalable architecture for future expansion

---

# 13. Future Enhancements

Potential future enhancements include:

- Warehouse Management
- Shipment Tracking
- Loyalty Program
- Product Reviews
- Promotional Campaigns
- Coupon Management
- Online Ordering
- Multi-Currency Support

---

## Conclusion

This Business Requirements Document defines the functional scope and objectives of the Retail Sales Analytics & Inventory Management System.

The proposed solution delivers a scalable, normalized, and analytics-ready SQL Server database capable of supporting day-to-day retail operations as well as advanced reporting and business intelligence through SQL and Power BI.

The project follows industry-standard database design practices and serves as a strong portfolio project demonstrating database design, SQL development, and analytical reporting skills.

---

**Document Version:** 1.0

**Status:** Approved