# Retail Sales Analytics & Inventory Management System

<p align="center">

Enterprise SQL Business Intelligence Project built using **Microsoft SQL Server**

Designed to analyse retail business performance through **375 Business KPIs**, advanced SQL analytics, and dashboard-ready datasets for Power BI.

</p>

---

## Project Overview

The **Retail Sales Analytics & Inventory Management System** is a comprehensive end-to-end SQL analytics project that simulates a real-world retail business environment.

The project demonstrates how relational database design, advanced SQL querying, and business intelligence techniques can transform transactional retail data into meaningful insights for operational and executive decision-making.

The solution covers the complete retail lifecycle, including:

* Customer Management
* Product Management
* Inventory Management
* Order Processing
* Payment Management
* Supplier Management
* Employee Performance
* Return Management
* Executive Business Reporting

Built using **Microsoft SQL Server**, the project follows enterprise database design principles and provides scalable, dashboard-ready datasets suitable for Power BI visualisations.

---

# Project Statistics

| Category            |                Value |
| ------------------- | -------------------: |
| Database Platform   | Microsoft SQL Server |
| Database Tables     |               **18** |
| SQL Modules         |               **34** |
| Business KPIs       |              **375** |
| Documentation Files |              **13+** |
| Business Domains    |               **12** |
| Dashboard Ready     |                ✅ Yes |
| Database Design     |       3NF Normalised |

---

# Key Features

* Enterprise relational database design
* Fully normalised database (3NF)
* Modular SQL architecture
* Advanced SQL analytics
* 375 Business KPIs
* Executive-level business reporting
* Power BI-ready datasets
* Comprehensive documentation
* Performance optimisation scripts
* Data validation framework
* Case study with business recommendations
* Professional GitHub project structure

---

# Business Domains Covered

* Executive KPIs
* Sales Analytics
* Customer Analytics
* Customer Behaviour Analysis
* Product Performance
* Inventory Health
* Employee Performance
* Supplier Performance
* Return Analysis
* Payment Analysis
* Time Series Analysis
* Advanced Business Intelligence

# Technology Stack

| Category         | Technologies                                   |
| ---------------- | ---------------------------------------------- |
| Database         | Microsoft SQL Server                           |
| Query Language   | T-SQL (Transact-SQL)                           |
| Database Design  | Relational Database (3NF)                      |
| Development Tool | SQL Server Management Studio (SSMS)            |
| Data Modelling   | Entity Relationship Diagram (ERD)              |
| Analytics        | SQL, Window Functions, CTEs, Ranking Functions |
| Dashboard        | Microsoft Power BI                             |
| Documentation    | Markdown                                       |
| Version Control  | Git & GitHub                                   |

---

# Project Architecture

The project follows a modular, enterprise-grade architecture to ensure scalability, maintainability, and ease of execution.

```text
Retail Business Data
        │
        ▼
Database Design (18 Tables)
        │
        ▼
Data Generation
        │
        ▼
Database Objects
(Views, Functions,
Stored Procedures, Triggers)
        │
        ▼
Data Validation
        │
        ▼
Business Analysis
(375 KPIs)
        │
        ▼
Executive Reports
        │
        ▼
Power BI Dashboards
```

---

# Database Modules

The project is organised into multiple logical modules.

| Module                   | Purpose                                                                       |
| ------------------------ | ----------------------------------------------------------------------------- |
| Database Setup           | Creates the RetailSalesDB database, tables, constraints, and indexes          |
| Data Generation          | Populates lookup, master, and transactional tables with realistic retail data |
| Database Objects         | Implements Views, Stored Procedures, User Defined Functions, and Triggers     |
| Data Validation          | Performs schema validation, data quality checks, and integrity verification   |
| Database Maintenance     | Includes maintenance tasks and performance optimisation scripts               |
| Business Analysis        | Contains analytical SQL scripts implementing 375 business KPIs                |
| Business Analysis Output | Stores exported results, reports, and screenshots                             |
| Power BI                 | Dashboard files and visualisations                                            |
| Documentation            | Technical and business documentation                                          |
| Case Study               | Business problem, insights, and recommendations                               |

---

# Project Workflow

The complete execution flow follows a structured development lifecycle:

```text
Database Creation
        │
        ▼
Schema Implementation
        │
        ▼
Data Population
        │
        ▼
Database Objects
        │
        ▼
Validation & Quality Checks
        │
        ▼
Business KPI Analysis
        │
        ▼
Executive Reporting
        │
        ▼
Power BI Dashboard Development
```

---

# SQL Techniques Demonstrated

This project demonstrates a wide range of SQL concepts used in enterprise environments, including:

### Database Design

* Primary Keys
* Foreign Keys
* Constraints
* Indexes
* Normalisation (3NF)

### Query Development

* SELECT Statements
* JOIN Operations
* GROUP BY & HAVING
* Aggregate Functions
* CASE Expressions
* Date Functions

### Advanced SQL

* Common Table Expressions (CTEs)
* Window Functions
* Ranking Functions
* Correlated Subqueries
* Derived Tables
* Conditional Aggregation

### Database Programming

* Views
* Stored Procedures
* User Defined Functions
* Triggers

### Business Intelligence

* KPI Development
* Trend Analysis
* Benchmarking
* Customer Segmentation
* Product Analysis
* Executive Reporting

# Repository Structure

The project is organised using a modular enterprise-grade folder structure to ensure maintainability, scalability, and ease of navigation.

```text
Retail-Sales-Analytics/
│
├── 📄 README.md
├── 📄 LICENSE
├── 📄 .gitignore
│
├── 📁 01_Database_Setup/
│   ├── 01_Create_Database.sql
│   ├── 02_Create_Tables.sql
│   ├── 03_Create_Constraints.sql
│   └── 04_Create_Indexes.sql
│
├── 📁 02_Data_Generation/
│   ├── 05_Generate_Lookup_Data.sql
│   ├── 06_Generate_Master_Data.sql
│   ├── 07_Generate_Orders.sql
│   ├── 08_Generate_OrderItems.sql
│   ├── 09_Generate_Payments.sql
│   ├── 10_Generate_Returns.sql
│   └── 11_Generate_Inventory.sql
│
├── 📁 03_Database_Objects/
│   ├── 12_Create_Views.sql
│   ├── 13_Create_Stored_Procedures.sql
│   ├── 14_Create_Functions.sql
│   └── 15_Create_Triggers.sql
│
├── 📁 04_Data_Validation/
│   ├── 16_Validate_Schema.sql
│   ├── 17_Validate_Constraints.sql
│   ├── 18_Validate_Indexes.sql
│   ├── 19_Validate_Views.sql
│   ├── 20_Validate_Lookup_Data.sql
│   ├── 21_Validate_Master_Data.sql
│   ├── 22_Validate_Transaction_Data.sql
│   └── 23_Run_Data_Quality_Checks.sql
│
├── 📁 05_Database_Maintenance/
│   ├── 24_Database_Maintenance.sql
│   └── 25_Performance_Optimization.sql
│
├── 📁 06_Business_Analysis/
│   ├── 01_Executive_KPIs.sql
│   ├── 02_Sales_Analysis.sql
│   ├── 03_Customer_Analysis.sql
│   ├── 04_Customer_Behavior.sql
│   ├── 05_Product_Analysis.sql
│   ├── 06_Inventory_Analysis.sql
│   ├── 07_Employee_Performance.sql
│   ├── 08_Return_Analysis.sql
│   ├── 09_Payment_Analysis.sql
│   ├── 10_Supplier_Analysis.sql
│   ├── 11_Time_Series_Analysis.sql
│   ├── 12_Advanced_SQL_Analysis.sql
│   └── README.md
│
├── 📁 07_Business_Analysis_Output/
│
├── 📁 08_PowerBI/
│
├── 📁 09_Datasets/
│
├── 📁 10_Execution_Order/
│   └── Run_Project.sql
│
├── 📁 11_Documentation/
│
└── 📁 12_Case_Study/
```

---

# Folder Description

| Folder                          | Description                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------- |
| **01_Database_Setup**           | Creates the database, tables, constraints, and indexes.                         |
| **02_Data_Generation**          | Generates lookup, master, inventory, payment, return, and transactional data.   |
| **03_Database_Objects**         | Contains Views, Stored Procedures, Functions, and Triggers.                     |
| **04_Data_Validation**          | Performs schema validation, integrity checks, and data quality verification.    |
| **05_Database_Maintenance**     | Database maintenance scripts and performance optimisation.                      |                                                                                                                                                                                                                                                                     |
| **06_Business_Analysis** 		  | SQL scripts implementing Executive KPIs, Sales Analysis, Customer Analysis, **Customer Behavior**, Product Analysis, Inventory Analysis, Employee Performance, Return Analysis, Payment Analysis, Supplier Analysis, Time Series Analysis, and Advanced SQL Analysis (375 KPIs). |
| **07_Business_Analysis_Output** | Stores exported query outputs, screenshots, reports, and analysis results.      |
| **08_PowerBI**                  | Power BI dashboards and supporting files.                                       |
| **09_Datasets**                 | Source datasets, processed data, and supporting files.                          |
| **10_Execution_Order**          | Master execution script for running the project in the correct sequence.        |
| **11_Documentation**            | Technical documentation, executive reports, architecture, and project guides.   |
| **12_Case_Study**               | Business problem statement, insights, recommendations, and future enhancements. |

---

# Project Scale

| Component                 |       Count |
| ------------------------- | ----------: |
| Database Tables           |          18 |
| SQL Modules               |          34 |
| Business KPIs             |         375 |
| Business Analysis Domains |          12 |
| Documentation Files       |         13+ |
| Power BI Dashboards       | 7 (Planned) |
| Case Study Documents      |           6 |

```
```

# Business KPI Coverage

The project delivers **375 business-focused KPIs** organised into twelve analytical domains. These KPIs provide comprehensive insights into sales performance, customer behaviour, operational efficiency, inventory management, financial performance, and executive decision-making.

---

## KPI Distribution

| Module                     | KPI Range         | Total KPIs |
| -------------------------- | ----------------- | ---------: |
| Executive KPIs             | KPI 001 – KPI 045 |         45 |
| Sales Analysis             | KPI 046 – KPI 075 |         30 |
| Customer Analysis          | KPI 076 – KPI 105 |         30 |
| Customer Behavior          | KPI 106 – KPI 135 |         30 |
| Product Analysis           | KPI 136 – KPI 165 |         30 |
| Inventory Analysis         | KPI 166 – KPI 195 |         30 |
| Employee Performance       | KPI 196 – KPI 225 |         30 |
| Return Analysis            | KPI 226 – KPI 255 |         30 |
| Payment Analysis           | KPI 256 – KPI 285 |         30 |
| Supplier Analysis          | KPI 286 – KPI 315 |         30 |
| Time Series Analysis       | KPI 316 – KPI 345 |         30 |
| Advanced Business Analysis | KPI 346 – KPI 375 |         30 |

---

## Analytical Capabilities

The KPI framework covers every major operational area of a retail business.

### Executive Analytics

* Business Health Monitoring
* Revenue Overview
* Profitability Overview
* Operational Performance
* Executive Scorecards

### Sales Analytics

* Revenue Analysis
* Sales Trends
* Average Order Value
* Store Performance
* Product Sales Performance

### Customer Analytics

* Customer Segmentation
* Purchase Behaviour
* Customer Value
* Retention Analysis
* Revenue Contribution

### Product Analytics

* Product Profitability
* Product Ranking
* Category Performance
* Brand Performance
* Product Lifecycle

### Inventory Analytics

* Inventory Valuation
* Inventory Turnover
* Stock Availability
* Reorder Monitoring
* Dead Stock Analysis

### Employee Analytics

* Sales Productivity
* Revenue Contribution
* Employee Benchmarking
* Operational Efficiency

### Supplier Analytics

* Supplier Performance
* Product Contribution
* Procurement Analysis
* Supply Chain Benchmarking

### Return Analytics

* Return Rate
* Refund Analysis
* Return Reasons
* Product Quality Indicators

### Payment Analytics

* Payment Methods
* Payment Success Rate
* Revenue Collection
* Transaction Analysis

### Time Series Analytics

* Daily Trends
* Monthly Trends
* Quarterly Trends
* Yearly Trends
* Growth Analysis

### Advanced Business Analytics

* Pareto Analysis (80/20 Rule)
* ABC Product Classification
* XYZ Inventory Classification
* RFM Customer Analysis
* Cohort Analysis
* Cross-Sell Analysis
* Up-Sell Analysis
* Product Affinity Analysis
* Business KPI Scorecards
* Executive Performance Dashboards

---

## Business Value

The KPI framework enables organisations to:

* Monitor business performance in real time.
* Identify revenue growth opportunities.
* Improve customer retention.
* Optimise product and inventory management.
* Measure employee and supplier performance.
* Reduce operational inefficiencies.
* Support executive decision-making with data-driven insights.
* Build interactive Power BI dashboards using SQL-ready datasets.

# Power BI Dashboards

The SQL queries developed in this project generate dashboard-ready datasets that can be directly connected to **Microsoft Power BI** for interactive reporting and executive decision-making.

Each dashboard focuses on a specific business domain and provides actionable insights through modern visualisations and KPI tracking.

---

## Dashboard Portfolio

| Dashboard                     | Description                                                                                                                  |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Executive Summary Dashboard   | High-level business overview with revenue, profit, customers, orders, and executive KPIs.                                    |
| Sales Dashboard               | Sales trends, revenue analysis, store performance, top-selling products, and order analysis.                                 |
| Customer Dashboard            | Customer segmentation, purchase behaviour, retention analysis, customer lifetime value, and RFM analysis.                    |
| Product Dashboard             | Product profitability, category performance, brand analysis, top and low-performing products.                                |
| Inventory Dashboard           | Inventory valuation, stock availability, inventory turnover, reorder monitoring, and dead stock analysis.                    |
| Employee Dashboard            | Employee productivity, revenue contribution, sales ranking, and operational performance.                                     |
| Supplier Dashboard            | Supplier contribution, procurement performance, inventory support, and supplier benchmarking.                                |
| Return Dashboard              | Return rate, refund analysis, return reasons, product quality trends, and financial impact.                                  |
| Payment Dashboard             | Payment methods, transaction trends, payment success rate, and revenue collection analysis.                                  |
| Executive Scorecard Dashboard | Consolidated business scorecard with Business Health Index, profitability score, operational efficiency, and strategic KPIs. |

---

# Dashboard Features

The Power BI solution is designed to provide interactive and executive-ready reporting.

### Interactive Filtering

* Date Filters
* Store Filters
* Product Category Filters
* Brand Filters
* Customer Filters
* Employee Filters
* Supplier Filters

---

### KPI Cards

* Total Revenue
* Total Profit
* Total Orders
* Total Customers
* Average Order Value
* Inventory Value
* Return Rate
* Payment Success Rate
* Business Health Index

---

### Visualisations

The dashboards include a variety of visualisations, including:

* KPI Cards
* Clustered Bar Charts
* Stacked Bar Charts
* Line Charts
* Area Charts
* Pie & Donut Charts
* Tree Maps
* Scatter Charts
* Matrix Reports
* Heat Maps
* Decomposition Tree
* Waterfall Charts
* Drill-through Reports

---

# SQL → Power BI Workflow

```text
Retail Database (SQL Server)
            │
            ▼
Business Analysis SQL Scripts
            │
            ▼
375 Business KPIs
            │
            ▼
Power BI Data Model
            │
            ▼
Interactive Dashboards
            │
            ▼
Executive Business Reporting
```

---

# Business Benefits

The dashboard solution enables business users to:

* Monitor business performance in real time.
* Analyse trends across sales, customers, products, inventory, and suppliers.
* Identify opportunities for revenue growth.
* Improve operational efficiency.
* Track KPI performance across departments.
* Support strategic decision-making with interactive visualisations.

---

# Dashboard Status

| Dashboard           | Status     |
| ------------------- | ---------- |
| Executive Summary   | 🔄 Planned |
| Sales Dashboard     | 🔄 Planned |
| Customer Dashboard  | 🔄 Planned |
| Product Dashboard   | 🔄 Planned |
| Inventory Dashboard | 🔄 Planned |
| Employee Dashboard  | 🔄 Planned |
| Supplier Dashboard  | 🔄 Planned |
| Return Dashboard    | 🔄 Planned |
| Payment Dashboard   | 🔄 Planned |
| Executive Scorecard | 🔄 Planned |

> **Note:** The SQL foundation and KPI framework are complete. The Power BI dashboards will be developed using the generated KPI datasets and analytical outputs from this repository.

# Documentation

Comprehensive documentation has been prepared to ensure the project is easy to understand, execute, maintain, and extend.

The documentation covers database architecture, implementation decisions, business logic, executive reporting, and repository guidance.

---

## Project Documentation

| Document                     | Description                                                                        |
| ---------------------------- | ---------------------------------------------------------------------------------- |
| Business_Requirements.md     | Functional and business requirements of the project.                               |
| Project_Architecture.md      | Overall project architecture and workflow.                                         |
| Naming_Conventions.md        | Database and SQL naming standards followed throughout the project.                 |
| Data_Dictionary.md           | Detailed description of all database tables and columns.                           |
| ER_Diagram.md                | Entity Relationship Diagram and database relationships.                            |
| Database_Design_Decisions.md | Design principles, normalisation, indexing strategy, and implementation decisions. |

---

## Database Object Documentation

| Document                           | Description                                     |
| ---------------------------------- | ----------------------------------------------- |
| Views_Documentation.md             | Documentation for all database views.           |
| Stored_Procedures_Documentation.md | Details of stored procedures and their purpose. |
| Functions_Documentation.md         | Documentation for user-defined functions.       |
| Triggers_Documentation.md          | Trigger implementation and business rules.      |

---

## Database Administration

| Document                    | Description                                                                    |
| --------------------------- | ------------------------------------------------------------------------------ |
| Maintenance_Guide.md        | Database maintenance procedures and best practices.                            |
| Performance_Optimization.md | Query optimisation, indexing strategy, and performance tuning recommendations. |

---

## Executive Reports

| Document                                | Description                                                                    |
| --------------------------------------- | ------------------------------------------------------------------------------ |
| 35_Executive_Business_Report.md         | Executive business report summarising analytical findings and recommendations. |
| 36_KPI_Index.md                         | Complete index of all 375 business KPIs.                                       |
| 37_Project_Summary.md                   | High-level summary of the complete project.                                    |
| 38_Project_Features.md                  | Comprehensive list of project capabilities and features.                       |
| 39_Project_Learnings.md                 | Technical and business lessons learned during development.                     |
| 40_Repository_Guide.md                  | Guide to navigating the repository and understanding its structure.            |
| 41_Portfolio_Highlights.md *(Optional)* | Key achievements and portfolio highlights for recruiters and hiring managers.  |

---

## Query Documentation

| Document                       | Description                                                                 |
| ------------------------------ | --------------------------------------------------------------------------- |
| Business_Query_Explanations.md | Explanation of important SQL queries, business logic, and KPI calculations. |

---

# Case Study

The repository also includes a complete business case study that demonstrates how SQL analytics can be applied to solve real-world retail business challenges.

---

## Case Study Documents

| Document                    | Description                                                    |
| --------------------------- | -------------------------------------------------------------- |
| Business_Problem.md         | Definition of the business challenge addressed by the project. |
| Dataset_Overview.md         | Overview of the dataset, business entities, and data model.    |
| KPI_Definitions.md          | Business definitions and objectives for all KPI categories.    |
| Key_Insights.md             | Major findings derived from the analytical process.            |
| Business_Recommendations.md | Strategic recommendations based on KPI analysis.               |
| Future_Enhancements.md      | Opportunities for future development and project expansion.    |

---

# Learning Outcomes

This project demonstrates practical knowledge in:

## Database Engineering

* Relational Database Design
* Database Normalisation (3NF)
* Constraints & Indexing
* Data Integrity
* Database Performance Optimisation

---

## SQL Development

* Advanced T-SQL
* Window Functions
* Common Table Expressions (CTEs)
* Ranking Functions
* Aggregate Functions
* Correlated Subqueries
* Views
* Stored Procedures
* User Defined Functions
* Triggers

---

## Business Intelligence

* KPI Development
* Retail Business Analytics
* Executive Reporting
* Data-Driven Decision Making
* Dashboard-Ready Data Preparation
* Business Performance Benchmarking

---

## Documentation Standards

The project follows professional documentation practices by including:

* Technical documentation
* Functional documentation
* Business documentation
* Executive reporting
* Repository guides
* Case study documentation

This ensures the repository is suitable for learning, portfolio presentation, technical interviews, and enterprise reference projects.

# Future Enhancements

Although the project is feature-complete for **Version 1.0**, it has been designed with scalability in mind. The following enhancements can be implemented in future releases.

---

## Business Intelligence

* Develop interactive Power BI dashboards.
* Implement executive scorecards with drill-through capabilities.
* Build department-specific dashboards.
* Enable real-time KPI monitoring.

---

## Database Enhancements

* Implement SQL Server Agent Jobs for scheduled automation.
* Add automated backup and recovery scripts.
* Introduce table partitioning for large datasets.
* Implement advanced indexing strategies.
* Create audit logging tables.

---

## Advanced Analytics

* Sales forecasting using Machine Learning.
* Customer churn prediction.
* Inventory demand forecasting.
* Dynamic pricing analysis.
* Market Basket Analysis.
* Recommendation Engine.
* Customer Sentiment Analysis.

---

## Cloud Deployment

* Azure SQL Database
* Azure Data Factory
* Azure Synapse Analytics
* Microsoft Fabric
* Power BI Service
* Azure Blob Storage

---

## Data Engineering

* Automated ETL Pipelines
* Incremental Data Loading
* Data Warehouse Design
* Star Schema Modelling
* Data Lake Integration

---

## Security

* Role-Based Access Control (RBAC)
* Dynamic Data Masking
* Row-Level Security
* Database Encryption
* Audit Logging

---

# Project Highlights

## Enterprise-Level Features

* 18 Relational Database Tables
* Fully Normalised Database (3NF)
* 34 Modular SQL Development Scripts
* 375 Business KPIs
* Advanced SQL Analytics
* Executive Business Reporting
* Dashboard-Ready Datasets
* Comprehensive Technical Documentation
* Business Case Study
* GitHub Portfolio Ready

---

## Skills Demonstrated

### Database

* Microsoft SQL Server
* Relational Database Design
* Data Modelling
* Database Optimisation

### SQL

* T-SQL
* Window Functions
* Common Table Expressions (CTEs)
* Stored Procedures
* Functions
* Triggers
* Views

### Business Intelligence

* KPI Development
* Retail Analytics
* Executive Reporting
* Business Analysis
* Data Visualisation Preparation

### Professional Practices

* Git Version Control
* GitHub Repository Management
* Technical Documentation
* Business Documentation
* Enterprise Project Organisation

---

# Contributing

Contributions, suggestions, and improvements are welcome.

If you have ideas for enhancing this project, feel free to:

* Fork the repository
* Create a feature branch
* Submit a Pull Request
* Open an Issue for discussion

---

# License

This project is licensed under the **MIT License**.

See the `LICENSE` file for complete details.

---

# Author

## Akshay Aswani

**NOC Engineer | Aspiring Data Analyst | SQL Developer | Power BI Enthusiast**

### Connect with me

* GitHub: https://github.com/aaswani365
* LinkedIn: https://www.linkedin.com/in/akshayaswani365/

---

# If you found this project helpful

Please consider:

⭐ Star this repository

🍴 Fork this repository

💬 Share your feedback

---

<p align="center">

**Thank you for visiting this project!**

*Turning data into meaningful business insights through SQL and Business Intelligence.*

</p>
