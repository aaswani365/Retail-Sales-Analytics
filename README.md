# 🛒 Retail Sales Analytics & Inventory Management System

> A production-inspired SQL Server project that simulates a real-world retail business. This project demonstrates database design, normalization, data generation, advanced SQL analysis, and Power BI reporting.

---

## 📖 Table of Contents

- [Project Overview](#-project-overview)
- [Business Problem](#-business-problem)
- [Project Objectives](#-project-objectives)
- [Technology Stack](#-technology-stack)
- [Database Architecture](#-database-architecture)
- [Database Schema](#-database-schema)
- [Project Structure](#-project-structure)
- [Dataset Summary](#-dataset-summary)
- [SQL Concepts Covered](#-sql-concepts-covered)
- [Power BI Dashboards](#-power-bi-dashboards)
- [Setup Instructions](#-setup-instructions)
- [Project Roadmap](#-project-roadmap)
- [Future Enhancements](#-future-enhancements)
- [License](#-license)

---

# 📌 Project Overview

Retail businesses generate thousands of transactions every day across multiple stores, products, customers, and suppliers. Efficiently managing this data requires a well-designed relational database capable of supporting operational reporting and business analytics.

This project demonstrates how to design and build a production-inspired retail database using Microsoft SQL Server. It follows database design best practices and includes realistic business data to support analytical reporting and dashboard development.

---

# 💼 Business Problem

Retail organizations need to answer questions such as:

- Which products generate the highest revenue?
- Which customers purchase most frequently?
- Which stores perform best?
- Which suppliers contribute the highest sales?
- Which products require restocking?
- What is the monthly sales trend?
- What is the return rate by category?

This project provides the database required to answer these business questions using SQL and Power BI.

---

# 🎯 Project Objectives

- Design a normalized relational database
- Implement primary and foreign key relationships
- Generate realistic retail business data
- Perform advanced SQL analysis
- Build business reports
- Create interactive Power BI dashboards
- Demonstrate SQL Server best practices

---

# 🛠 Technology Stack

| Technology | Purpose |
|------------|---------|
| Microsoft SQL Server | Database |
| SQL Server Management Studio (SSMS) | Development |
| T-SQL | SQL Programming |
| Power BI | Dashboard & Reporting |
| Git | Version Control |
| GitHub | Portfolio & Documentation |

---

# 🏗 Database Architecture

The database follows a normalized relational design.

```text
Categories
      │
      ▼
SubCategories
      │
      ▼
Products
      │
      ├──────────────┐
      ▼              ▼
Inventory      OrderItems
                     │
                     ▼
                  Orders
                 /      \
                ▼        ▼
         Customers    Employees
                          │
                          ▼
                       Stores

Products ─────► Brands
Products ─────► Suppliers

Orders ───────► Payments ─────► PaymentMethods

Returns ──────► ReturnReasons
```

---

# 🗄 Database Schema

## Master Tables

- Categories
- SubCategories
- Brands
- Suppliers
- Products
- Stores
- Employees
- Customers
- PaymentMethods
- ReturnReasons

## Transaction Tables

- Orders
- OrderItems
- Payments
- Inventory
- Returns

Total Tables: **15**

---

# 📂 Project Structure

```text
Retail-Sales-Analytics/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── 01_Database/
├── 02_Master_Data/
├── 03_Transaction_Data/
├── 04_Views/
├── 05_Stored_Procedures/
├── 06_Functions/
├── 07_Triggers/
├── 08_SQL_Analysis/
├── 09_Performance_Tuning/
├── 10_PowerBI/
├── 11_Documentation/
├── Dataset/
└── Images/
```

---

# 📊 Dataset Summary

| Table | Planned Records |
|--------|----------------:|
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

Approximate total records: **138,000+**

---

# 📚 SQL Concepts Covered

- Database Design
- Normalization
- Primary Keys
- Foreign Keys
- Constraints
- Indexes
- Views
- Stored Procedures
- User Defined Functions
- Triggers
- Transactions
- Common Table Expressions (CTEs)
- Window Functions
- Ranking Functions
- Aggregate Functions
- PIVOT / UNPIVOT
- Query Optimization

---

# 📈 Power BI Dashboards

The following dashboards will be developed:

- Executive Dashboard
- Sales Dashboard
- Customer Dashboard
- Product Dashboard
- Inventory Dashboard
- Store Dashboard
- Supplier Dashboard
- Profitability Dashboard

---

# ⚙️ Setup Instructions

1. Clone this repository.
2. Open SQL Server Management Studio (SSMS).
3. Execute scripts in the following order:

```text
01_Database
02_Master_Data
03_Transaction_Data
04_Views
05_Stored_Procedures
06_Functions
07_Triggers
08_SQL_Analysis
```

4. Connect Power BI to SQL Server.
5. Build dashboards using the generated dataset.

---

# 🛣 Project Roadmap

- [x] Repository setup
- [ ] Database creation
- [ ] Table creation
- [ ] Constraints
- [ ] Indexes
- [ ] Master data generation
- [ ] Transaction data generation
- [ ] SQL analysis
- [ ] Power BI dashboards
- [ ] Documentation
- [ ] Final project release

---

# 🚀 Future Enhancements

- Sales forecasting
- Customer segmentation (RFM)
- Inventory optimization
- Customer Lifetime Value (CLV)
- Geographic sales analysis
- Incremental data loading
- Performance benchmarking

---

# 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Akshay Aswani**

This project is developed for learning, portfolio demonstration, and Data Analyst interview preparation.