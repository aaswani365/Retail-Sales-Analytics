/*==============================================================================
Project         : Retail Sales Analytics & Inventory Management System
Module          : 29_Employee_Performance.sql
Description     : Employee Performance KPIs for Workforce Performance Insights

Author          : Akshay Aswani
Version         : 1.0
Database        : RetailSalesDB

KPI Range       : 196 - 225
Total KPIs      : 30
Difficulty      : Intermediate → Advanced SQL

Purpose
------------------------------------------------------------------------------
This module analyzes employee performance, sales productivity, customer
service efficiency, order management, revenue contribution, and operational
performance to generate actionable business insights.

These KPIs help organizations evaluate employee productivity, identify
top-performing employees, monitor sales performance, measure workforce
efficiency, optimize staffing decisions, and support data-driven
performance management.

==============================================================================*/

/*==============================================================================
Module Statistics
==============================================================================

Module Name        : Employee Performance

KPI Range          : 196 - 225

Total KPIs         : 30

Estimated Runtime  : < 20 Seconds

Primary SQL Concepts
--------------------

• SELECT
• GROUP BY
• INNER JOIN
• Common Table Expressions (CTE)
• Aggregate Functions
• Window Functions
• CASE
• DATE Functions
• DATEDIFF
• DATEADD
• ISNULL
• NULLIF
• HAVING
• TOP
• Ranking Functions
• Conditional Aggregation

==============================================================================*/

USE RetailSalesDB;
GO

PRINT '==============================================================';
PRINT 'Retail Sales Analytics & Inventory Management System';
PRINT '29_Employee_Performance.sql';
PRINT '==============================================================';

PRINT 'Starting Employee Performance KPI Module...';
PRINT '==============================================================';
GO

/*------------------------------------------------------------------------------
KPI 196 : Top Performing Employees by Revenue
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees generate the highest sales revenue?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee revenue contribution is one of the primary performance indicators
used to evaluate workforce productivity and sales performance.

This KPI helps management:

• Identify Top Performing Employees
• Measure Employee Sales Performance
• Design Sales Incentive Programs
• Support Performance Reviews
• Improve Workforce Productivity

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Average Order Value

Employees are ranked based on Total Revenue Generated.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalRevenueGenerated DESC,
    TotalOrdersProcessed DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 196 : Top Performing Employees by Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 197 : Employees by Orders Processed
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees process the highest number of customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

The number of orders processed is a key productivity metric that measures
employee workload and operational efficiency.

This KPI helps management:

• Identify Highly Productive Employees
• Measure Employee Workload
• Support Performance Evaluations
• Improve Workforce Planning
• Optimize Operational Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Average Revenue per Order

Employees are ranked based on the total number of orders processed.

------------------------------------------------------------------------------*/

SELECT TOP (10)
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(AVG(O.NetAmount),2) AS AverageRevenuePerOrder
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalOrdersProcessed DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 197 : Employees by Orders Processed Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 198 : Average Revenue Generated per Employee
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much average revenue is generated by each employee?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average revenue generated per employee helps evaluate employee sales
efficiency and overall business productivity.

This KPI helps management:

• Measure Employee Sales Efficiency
• Compare Employee Performance
• Evaluate Workforce Productivity
• Support Performance Reviews
• Improve Resource Allocation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Average Revenue Generated per Employee

Employees are ranked based on Total Revenue Generated.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 / COUNT(O.OrderID),2) AS AverageRevenuePerEmployee
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalRevenueGenerated DESC,
    AverageRevenuePerEmployee DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 198 : Average Revenue Generated per Employee Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 199 : Employee Revenue Contribution
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How much revenue does each employee contribute to the overall business?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue contribution helps identify employees who have the greatest impact
on business performance.

This KPI helps management:

• Identify High Revenue Contributors
• Measure Employee Business Impact
• Support Incentive Programs
• Evaluate Sales Performance
• Improve Workforce Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Revenue Contribution Percentage

Employees are ranked based on Total Revenue Generated.

Formula

Revenue Contribution % =
(Employee Revenue / Total Business Revenue) × 100

------------------------------------------------------------------------------
*/

WITH EmployeeRevenue AS
(
    SELECT
        E.EmployeeID,
        CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
        E.JobTitle,
        E.StoreID,
        COUNT(O.OrderID) AS TotalOrdersProcessed,
        SUM(O.NetAmount) AS TotalRevenueGenerated
    FROM dbo.Employee E
    INNER JOIN dbo.[Order] O
        ON E.EmployeeID = O.EmployeeID
    GROUP BY
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        E.JobTitle,
        E.StoreID
)
SELECT
    DENSE_RANK() OVER(ORDER BY TotalRevenueGenerated DESC) AS EmployeeRank,
    EmployeeID,
    EmployeeName,
    JobTitle,
    StoreID,
    TotalOrdersProcessed,
    ROUND(TotalRevenueGenerated,2) AS TotalRevenueGenerated,
    ROUND(TotalRevenueGenerated * 100.0 / SUM(TotalRevenueGenerated) OVER (),2) AS RevenueContributionPercentage
FROM EmployeeRevenue
ORDER BY
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 199 : Employee Revenue Contribution Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 200 : Top Employees by Customer Count
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees serve the highest number of unique customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Serving a larger customer base demonstrates employee engagement and
customer handling capability.

This KPI helps management:

• Identify Employees Serving More Customers
• Measure Customer Reach
• Evaluate Customer Engagement
• Support Workforce Planning
• Improve Customer Service Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Unique Customers Served
• Total Orders Processed
• Total Revenue Generated

Employees are ranked based on the number of unique customers served.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT O.CustomerID) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(DISTINCT O.CustomerID) AS TotalUniqueCustomersServed,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalUniqueCustomersServed DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 200 : Top Employees by Customer Count Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 201 : Active vs Inactive Employees
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the distribution of active and inactive employees?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monitoring employee status helps organizations understand workforce
availability and supports staffing, workforce planning, and operational
decision-making.

This KPI helps management:

• Monitor Workforce Availability
• Track Employee Status
• Support HR Planning
• Improve Resource Allocation
• Measure Workforce Health

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Status
• Total Employees
• Percentage of Workforce

Employee Status

• Active
• Inactive

------------------------------------------------------------------------------
*/

SELECT
    CASE
        WHEN E.IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS EmployeeStatus,
    COUNT(*) AS TotalEmployees,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS WorkforcePercentage
FROM dbo.Employee E
GROUP BY
    E.IsActive
ORDER BY
    EmployeeStatus DESC;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 201 : Active vs Inactive Employees Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 202 : Employee Tenure Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How experienced is the current workforce based on employee tenure?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee tenure provides insights into workforce stability, employee
retention, and organizational experience.

This KPI helps management:

• Measure Workforce Experience
• Monitor Employee Retention
• Identify Long-Term Employees
• Support Succession Planning
• Improve Workforce Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Hire Date
• Years of Service
• Employee Tenure Category

Business Rules

New Employee

• Less than 2 Years

Experienced

• Between 2 and 5 Years

Senior

• More than 5 Years

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY DATEDIFF(YEAR, E.HireDate, GETDATE()) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    E.HireDate,
    DATEDIFF(YEAR,E.HireDate,GETDATE()) AS YearsOfService,
    CASE
        WHEN DATEDIFF(YEAR, E.HireDate, GETDATE()) < 2 THEN 'New Employee'
        WHEN DATEDIFF(YEAR, E.HireDate, GETDATE()) BETWEEN 2 AND 5 THEN 'Experienced'
        ELSE 'Senior'
    END AS EmployeeTenureCategory
FROM dbo.Employee E
ORDER BY
    YearsOfService DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 202 : Employee Tenure Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 203 : Employees by Job Title
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How are employees distributed across different job titles?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding workforce distribution by job title helps organizations
evaluate staffing levels, workforce composition, and organizational
structure.

This KPI helps management:

• Monitor Workforce Composition
• Analyze Job Role Distribution
• Support Workforce Planning
• Improve Recruitment Strategy
• Optimize Organizational Structure

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Job Title Rank
• Job Title
• Total Employees
• Active Employees
• Inactive Employees
• Average Salary

Job titles are ranked based on the total number of employees.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS JobTitleRank,
    E.JobTitle,
    COUNT(*) AS TotalEmployees,
    SUM(
        CASE
            WHEN E.IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveEmployees,
    SUM(
        CASE
            WHEN E.IsActive = 0 THEN 1
            ELSE 0
        END
    ) AS InactiveEmployees,
    ROUND(AVG(E.Salary),2) AS AverageSalary
FROM dbo.Employee E
GROUP BY
    E.JobTitle
ORDER BY
    TotalEmployees DESC,
    AverageSalary DESC,
    E.JobTitle;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 203 : Employees by Job Title Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 204 : Salary Distribution Analysis
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How is employee salary distributed across different job titles?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Salary distribution analysis helps organizations evaluate compensation
structure, identify salary variations across job roles, and support
workforce budgeting.

This KPI helps management:

• Analyze Salary Distribution
• Compare Compensation Across Job Titles
• Support Payroll Planning
• Evaluate Workforce Cost
• Improve Compensation Strategy

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Salary Rank
• Job Title
• Total Employees
• Minimum Salary
• Average Salary
• Maximum Salary
• Total Salary Expense

Job titles are ranked based on Average Salary.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY AVG(E.Salary) DESC) AS SalaryRank,
    E.JobTitle,
    COUNT(*) AS TotalEmployees,
    ROUND(MIN(E.Salary),2) AS MinimumSalary,
    ROUND(AVG(E.Salary),2) AS AverageSalary,
	ROUND(MAX(E.Salary),2) AS MaximumSalary,
	ROUND(SUM(E.Salary),2) AS TotalSalaryExpense
FROM dbo.Employee E
GROUP BY
    E.JobTitle
ORDER BY
    AverageSalary DESC,
    TotalEmployees DESC,
    E.JobTitle;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 204 : Salary Distribution Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 205 : Revenue Generated per Salary Dollar
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees generate the highest revenue relative to their salary?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Revenue generated per salary dollar measures employee productivity by
comparing sales performance against employee compensation.

This KPI helps management:

• Measure Employee Productivity
• Evaluate Return on Payroll Investment
• Identify High Value Employees
• Support Compensation Reviews
• Improve Workforce Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Salary
• Total Revenue Generated
• Revenue per Salary Dollar

Formula

Revenue per Salary Dollar =
Total Revenue Generated / Salary

Employees are ranked based on Revenue per Salary Dollar.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) / NULLIF(E.Salary, 0) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    ROUND(E.Salary,2) AS Salary,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) / NULLIF(E.Salary, 0),2) AS RevenuePerSalaryDollar
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID,
    E.Salary
ORDER BY
    RevenuePerSalaryDollar DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 205 : Revenue Generated per Salary Dollar Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 206 : Store-wise Employee Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How do employees perform across different stores?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Store-wise employee performance helps management compare workforce
productivity across store locations and identify stores with the most
effective employees.

This KPI helps management:

• Compare Employee Performance by Store
• Measure Store Productivity
• Identify High Performing Stores
• Optimize Workforce Allocation
• Support Operational Planning

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store Rank
• Store ID
• Store Name
• Total Employees
• Total Orders Processed
• Total Revenue Generated
• Average Revenue per Employee

Formula

Average Revenue per Employee =
Total Revenue Generated / Total Employees

Stores are ranked based on Total Revenue Generated.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS StoreRank,
    S.StoreID,
    S.StoreName,
    COUNT(DISTINCT E.EmployeeID) AS TotalEmployees,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 / COUNT(DISTINCT E.EmployeeID),2) AS AverageRevenuePerEmployee
FROM dbo.Store S
INNER JOIN dbo.Employee E
    ON S.StoreID = E.StoreID
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    S.StoreID,
    S.StoreName
ORDER BY
    TotalRevenueGenerated DESC,
    AverageRevenuePerEmployee DESC,
    S.StoreName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 206 : Store-wise Employee Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 207 : Top Performing Employee in Each Store
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Who is the highest revenue-generating employee in each store?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Identifying the top-performing employee in every store helps management
recognize outstanding performers, compare employee productivity across
stores, and support performance-based reward programs.

This KPI helps management:

• Identify Top Employee in Each Store
• Compare Employee Performance Across Stores
• Support Recognition Programs
• Improve Workforce Productivity
• Benchmark Store Performance

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Store ID
• Store Name
• Employee ID
• Employee Name
• Job Title
• Total Orders Processed
• Total Revenue Generated
• Employee Rank Within Store

Employees are ranked within each store based on Total Revenue Generated.

------------------------------------------------------------------------------*/

WITH EmployeePerformance AS
(
    SELECT
        S.StoreID,
        S.StoreName,
        E.EmployeeID,
        CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
        E.JobTitle,
        COUNT(O.OrderID) AS TotalOrdersProcessed,
        SUM(O.NetAmount) AS TotalRevenueGenerated,
        ROW_NUMBER() OVER(PARTITION BY S.StoreID ORDER BY SUM(O.NetAmount) DESC,COUNT(O.OrderID) DESC) AS EmployeeRank
    FROM dbo.Store S
    INNER JOIN dbo.Employee E
        ON S.StoreID = E.StoreID
    INNER JOIN dbo.[Order] O
        ON E.EmployeeID = O.EmployeeID
    GROUP BY
        S.StoreID,
        S.StoreName,
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        E.JobTitle
)
SELECT
    StoreID,
    StoreName,
    EmployeeID,
    EmployeeName,
    JobTitle,
    TotalOrdersProcessed,
    ROUND(TotalRevenueGenerated,2) AS TotalRevenueGenerated,
    EmployeeRank
FROM EmployeePerformance
WHERE EmployeeRank = 1
ORDER BY
    TotalRevenueGenerated DESC,
    StoreName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 207 : Top Performing Employee in Each Store Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 208 : Manager Team Size Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How many employees report to each manager?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Understanding team size helps organizations evaluate management span of
control, workforce distribution, and organizational hierarchy.

This KPI helps management:

• Measure Team Size
• Analyze Reporting Structure
• Identify Large and Small Teams
• Support Workforce Planning
• Improve Organizational Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Manager Rank
• Manager Employee ID
• Manager Name
• Job Title
• Store ID
• Total Direct Reports
• Active Team Members
• Inactive Team Members

Managers are ranked based on the number of direct reports.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(E.EmployeeID) DESC) AS ManagerRank,
    M.EmployeeID AS ManagerEmployeeID,
    CONCAT(M.FirstName,' ',M.LastName) AS ManagerName,
    M.JobTitle,
    M.StoreID,
    COUNT(E.EmployeeID) AS TotalDirectReports,
    SUM(
        CASE
            WHEN E.IsActive = 1 THEN 1
            ELSE 0
        END
    ) AS ActiveTeamMembers,
    SUM(
        CASE
            WHEN E.IsActive = 0 THEN 1
            ELSE 0
        END
    ) AS InactiveTeamMembers
FROM dbo.Employee M
INNER JOIN dbo.Employee E
    ON M.EmployeeID = E.ManagerEmployeeID
GROUP BY
    M.EmployeeID,
    M.FirstName,
    M.LastName,
    M.JobTitle,
    M.StoreID
ORDER BY
    TotalDirectReports DESC,
    ManagerName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 208 : Manager Team Size Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 209 : Manager Performance by Team Revenue
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which managers lead the highest revenue-generating teams?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Measuring team revenue helps organizations evaluate managerial
effectiveness and understand how teams contribute to overall business
performance.

This KPI helps management:

• Evaluate Manager Performance
• Compare Team Revenue
• Identify High Performing Managers
• Support Leadership Reviews
• Improve Workforce Productivity

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Manager Rank
• Manager Employee ID
• Manager Name
• Job Title
• Store ID
• Total Team Members
• Total Orders Processed
• Total Team Revenue
• Average Revenue per Team Member

Managers are ranked based on Total Team Revenue Generated.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS ManagerRank,
    M.EmployeeID AS ManagerEmployeeID,
    CONCAT(M.FirstName,' ',M.LastName) AS ManagerName,
    M.JobTitle,
    M.StoreID,
    COUNT(DISTINCT E.EmployeeID) AS TotalTeamMembers,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalTeamRevenue,
    ROUND(SUM(O.NetAmount) * 1.0 / COUNT(DISTINCT E.EmployeeID),2) AS AverageRevenuePerTeamMember
FROM dbo.Employee M
INNER JOIN dbo.Employee E
    ON M.EmployeeID = E.ManagerEmployeeID
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    M.EmployeeID,
    M.FirstName,
    M.LastName,
    M.JobTitle,
    M.StoreID
ORDER BY
    TotalTeamRevenue DESC,
    TotalTeamMembers DESC,
    ManagerName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 209 : Manager Performance by Team Revenue Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 210 : Newly Hired Employees
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees have been hired most recently?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monitoring newly hired employees helps organizations track workforce
growth, onboarding activities, and recent recruitment efforts.

This KPI helps management:

• Monitor Recent Hiring
• Track Workforce Expansion
• Support Onboarding Planning
• Analyze Recruitment Trends
• Improve Workforce Management

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Hire Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Hire Date
• Days Since Hire
• Employee Status

Employees are ranked based on the most recent Hire Date.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY E.HireDate DESC) AS HireRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    E.HireDate,
    DATEDIFF(DAY,E.HireDate,GETDATE()) AS DaysSinceHire,
    CASE
        WHEN E.IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS EmployeeStatus
FROM dbo.Employee E
ORDER BY
    E.HireDate DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 210 : Newly Hired Employees Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 211 : Employee Productivity Score
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees are the most productive based on revenue generated and
orders processed?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee productivity score provides a balanced measure of employee
performance by considering both sales volume and revenue generation.

This KPI helps management:

• Measure Employee Productivity
• Identify High Performing Employees
• Support Performance Reviews
• Improve Workforce Efficiency
• Design Incentive Programs

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Productivity Score

Formula

Productivity Score =
Total Revenue Generated / Total Orders Processed

Employees are ranked based on Productivity Score.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(O.OrderID), 0) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(O.OrderID), 0),2) AS ProductivityScore
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    ProductivityScore DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 211 : Employee Productivity Score Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 212 : Employee Performance Rating
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How can employees be classified based on their sales performance?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employee performance ratings provide a standardized approach for evaluating
employee productivity and identifying top performers.

This KPI helps management:

• Classify Employee Performance
• Identify Top Performers
• Support Performance Reviews
• Design Incentive Programs
• Improve Workforce Productivity

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Performance Rating

Business Rules

Excellent

• Revenue >= 100000

Good

• Revenue >= 50000

Average

• Revenue >= 25000

Needs Improvement

• Revenue < 25000

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    CASE
        WHEN SUM(O.NetAmount) >= 100000 THEN 'Excellent'
        WHEN SUM(O.NetAmount) >= 50000 THEN 'Good'
        WHEN SUM(O.NetAmount) >= 25000 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS PerformanceRating
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 212 : Employee Performance Rating Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 213 : Employee Monthly Sales Trend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each employee's sales performance changed month over month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly sales trend helps management monitor employee performance over
time rather than relying on cumulative revenue alone.

This KPI helps management:

• Monitor Monthly Sales Performance
• Identify Consistent Top Performers
• Detect Performance Decline
• Measure Sales Trends
• Support Performance Reviews

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee ID
• Employee Name
• Job Title
• Sales Year
• Sales Month
• Total Orders Processed
• Monthly Revenue

Employees are grouped by Year and Month.

------------------------------------------------------------------------------*/

SELECT
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    YEAR(O.OrderDate) AS SalesYear,
    MONTH(O.OrderDate) AS SalesMonth,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS MonthlyRevenue
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    YEAR(O.OrderDate),
    MONTH(O.OrderDate)
ORDER BY
    EmployeeName,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 213 : Employee Monthly Sales Trend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 214 : Employee Monthly Sales Growth
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How has each employee's monthly sales changed compared to the previous
month?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Monthly sales growth helps organizations identify improving employees,
detect declining sales performance, and monitor workforce productivity
over time.

This KPI helps management:

• Measure Employee Sales Growth
• Monitor Monthly Performance Trends
• Identify Improving Employees
• Detect Declining Performance
• Support Performance Reviews

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee ID
• Employee Name
• Sales Year
• Sales Month
• Monthly Revenue
• Previous Month Revenue
• Revenue Growth
• Revenue Growth Percentage

------------------------------------------------------------------------------
*/

WITH MonthlySales AS
(
    SELECT
        E.EmployeeID,
        CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
        YEAR(O.OrderDate) AS SalesYear,
        MONTH(O.OrderDate) AS SalesMonth,
        SUM(O.NetAmount) AS MonthlyRevenue
    FROM dbo.Employee E
    INNER JOIN dbo.[Order] O
        ON E.EmployeeID = O.EmployeeID
    GROUP BY
        E.EmployeeID,
        E.FirstName,
        E.LastName,
        YEAR(O.OrderDate),
        MONTH(O.OrderDate)
)
SELECT
    EmployeeID,
    EmployeeName,
    SalesYear,
    SalesMonth,
    ROUND(MonthlyRevenue,2) AS MonthlyRevenue,
	ROUND(LAG(MonthlyRevenue) OVER(PARTITION BY EmployeeID ORDER BY SalesYear,SalesMonth),2) AS PreviousMonthRevenue,
	ROUND(MonthlyRevenue - LAG(MonthlyRevenue) OVER (PARTITION BY EmployeeID ORDER BY SalesYear,SalesMonth),2) AS RevenueGrowth,
    ROUND((MonthlyRevenue - LAG(MonthlyRevenue) OVER(PARTITION BY EmployeeID ORDER BY SalesYear,SalesMonth)) * 100.0 / 
		NULLIF(LAG(MonthlyRevenue) OVER (PARTITION BY EmployeeID ORDER BY SalesYear,SalesMonth),0),2)AS RevenueGrowthPercentage
FROM MonthlySales
ORDER BY
    EmployeeID,
    SalesYear,
    SalesMonth;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 214 : Employee Monthly Sales Growth Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 215 : Employee Average Customer Spend
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees generate the highest average customer spending?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average customer spend measures an employee's ability to generate higher
value transactions and maximize customer purchasing potential.

This KPI helps management:

• Measure Sales Effectiveness
• Identify High Value Sales Employees
• Evaluate Customer Spending Patterns
• Support Performance Reviews
• Improve Revenue Generation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Customers Served
• Total Revenue Generated
• Average Customer Spend

Formula

Average Customer Spend =
Total Revenue Generated / Total Unique Customers Served

Employees are ranked based on Average Customer Spend.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(DISTINCT O.CustomerID), 0) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(DISTINCT O.CustomerID) AS TotalCustomersServed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 /NULLIF(COUNT(DISTINCT O.CustomerID), 0),2) AS AverageCustomerSpend
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    AverageCustomerSpend DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 215 : Employee Average Customer Spend Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 216 : Employee Performance Dashboard Summary
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

What is the overall workforce performance summary?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

This KPI provides a high-level summary of employee performance, workforce
size, productivity, and revenue generation in a single report.

This KPI helps management:

• Monitor Workforce Performance
• Measure Employee Productivity
• Evaluate Revenue Contribution
• Support Executive Reporting
• Improve Strategic Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Total Employees
• Active Employees
• Inactive Employees
• Employees Processing Orders
• Total Orders Processed
• Total Revenue Generated
• Average Revenue per Employee
• Average Orders per Employee

------------------------------------------------------------------------------*/

SELECT
    COUNT(DISTINCT E.EmployeeID) AS TotalEmployees,
    COUNT(
        DISTINCT CASE
                    WHEN E.IsActive = 1 THEN E.EmployeeID
                 END
    ) AS ActiveEmployees,
    COUNT(
        DISTINCT CASE
                    WHEN E.IsActive = 0 THEN E.EmployeeID
                 END
    ) AS InactiveEmployees,
    COUNT(DISTINCT O.EmployeeID) AS EmployeesProcessingOrders,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(DISTINCT O.EmployeeID), 0),2) AS AverageRevenuePerEmployee,
    ROUND(COUNT(O.OrderID) * 1.0 / NULLIF(COUNT(DISTINCT O.EmployeeID), 0),2) AS AverageOrdersPerEmployee
FROM dbo.Employee E
LEFT JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 216 : Employee Performance Dashboard Summary Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 217 : Employees Without Sales
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees have not processed any customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Employees without sales may indicate newly hired staff, operational
reassignments, training periods, or potential productivity issues.

This KPI helps management:

• Identify Underutilized Employees
• Monitor Workforce Utilization
• Support Performance Reviews
• Improve Staff Allocation
• Optimize Operational Efficiency

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query identifies:

• Employee ID
• Employee Name
• Job Title
• Store ID
• Hire Date
• Employee Status

Only employees with zero processed orders are returned.

------------------------------------------------------------------------------*/

SELECT
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    E.HireDate,
    CASE
        WHEN E.IsActive = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS EmployeeStatus
FROM dbo.Employee E
LEFT JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
WHERE
    O.OrderID IS NULL
ORDER BY
    E.StoreID,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 217 : Employees Without Sales Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 218 : Employee Workload Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees handle the highest operational workload?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Workload analysis helps identify employees handling the highest number of
transactions and customers, enabling better workforce planning and
balanced task allocation.

This KPI helps management:

• Measure Employee Workload
• Identify Overloaded Employees
• Balance Workforce Distribution
• Improve Operational Efficiency
• Support Staffing Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Customers Served
• Average Orders per Customer

Employees are ranked based on Total Orders Processed.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    COUNT(DISTINCT O.CustomerID) AS TotalCustomersServed,
    ROUND(COUNT(O.OrderID) * 1.0 / NULLIF(COUNT(DISTINCT O.CustomerID), 0),2) AS AverageOrdersPerCustomer
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalOrdersProcessed DESC,
    TotalCustomersServed DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 218 : Employee Workload Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 219 : Employee Discount Performance
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees provide the highest total and average discounts to customers?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Discount analysis helps management monitor employee discount behavior,
identify excessive discounting, and evaluate its impact on sales.

This KPI helps management:

• Monitor Discount Usage
• Compare Employee Discount Behavior
• Prevent Excessive Discounting
• Improve Pricing Strategy
• Support Sales Performance Evaluation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders
• Total Discount Given
• Average Discount per Order
• Discount Percentage of Sales

Employees are ranked by Total Discount Given.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.DiscountAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.DiscountAmount),2) AS TotalDiscountGiven,
    ROUND(AVG(O.DiscountAmount),2) AS AverageDiscountPerOrder,
    ROUND(SUM(O.DiscountAmount) * 100.0 / NULLIF(SUM(O.SubTotalAmount),0),2) AS DiscountPercentageOfSales
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalDiscountGiven DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 219 : Employee Discount Performance Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 220 : Employee Tax Collection Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees collect the highest amount of tax through customer orders?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Tax collection analysis helps evaluate the tax contribution generated by
employees through sales activities and ensures financial reporting accuracy.

This KPI helps management:

• Monitor Tax Collection
• Compare Employee Tax Contribution
• Analyze Sales Tax Performance
• Support Financial Reporting
• Improve Revenue Analysis

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Tax Collected
• Average Tax per Order
• Tax Percentage of Net Sales

Employees are ranked based on Total Tax Collected.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.TaxAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.TaxAmount),2) AS TotalTaxCollected,
    ROUND(AVG(O.TaxAmount),2) AS AverageTaxPerOrder,
    ROUND(SUM(O.TaxAmount) * 100.0 / NULLIF(SUM(O.NetAmount), 0),2) AS TaxPercentageOfNetSales
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalTaxCollected DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 220 : Employee Tax Collection Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 221 : Employee Average Discount Percentage
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees provide the highest average discount percentage per order?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average discount percentage helps management evaluate employee pricing
behavior and identify employees who consistently offer higher discounts.

This KPI helps management:

• Monitor Discount Strategy
• Compare Employee Pricing Behavior
• Prevent Excessive Discounting
• Improve Profitability
• Support Sales Performance Reviews

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Average Discount Percentage
• Maximum Discount Percentage
• Minimum Discount Percentage

Formula

Discount Percentage =
(DiscountAmount / SubTotalAmount) × 100

Employees are ranked based on Average Discount Percentage.

------------------------------------------------------------------------------
*/

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY
            AVG
            (
                O.DiscountAmount * 100.0 /
                NULLIF(O.SubTotalAmount, 0)
            ) DESC
    ) AS EmployeeRank,

    E.EmployeeID,

    CONCAT
    (
        E.FirstName,
        ' ',
        E.LastName
    ) AS EmployeeName,

    E.JobTitle,

    E.StoreID,

    COUNT(O.OrderID) AS TotalOrdersProcessed,

    ROUND
    (
        AVG
        (
            O.DiscountAmount * 100.0 /
            NULLIF(O.SubTotalAmount, 0)
        ),
        2
    ) AS AverageDiscountPercentage,

    ROUND
    (
        MAX
        (
            O.DiscountAmount * 100.0 /
            NULLIF(O.SubTotalAmount, 0)
        ),
        2
    ) AS MaximumDiscountPercentage,

    ROUND
    (
        MIN
        (
            O.DiscountAmount * 100.0 /
            NULLIF(O.SubTotalAmount, 0)
        ),
        2
    ) AS MinimumDiscountPercentage

FROM dbo.Employee E

INNER JOIN dbo.[Order] O

    ON E.EmployeeID = O.EmployeeID

GROUP BY

    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID

ORDER BY

    AverageDiscountPercentage DESC,

    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 221 : Employee Average Discount Percentage Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 222 : Employee Sales Consistency Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees consistently process customer orders over time?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Sales consistency measures how regularly employees process orders rather
than relying solely on total revenue. Consistent performers contribute to
stable business operations and predictable sales performance.

This KPI helps management:

• Identify Consistent Employees
• Monitor Operational Stability
• Evaluate Workforce Productivity
• Support Performance Reviews
• Improve Staffing Decisions

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Active Sales Days
• Total Orders Processed
• Average Orders per Sales Day

Formula

Average Orders per Sales Day =
Total Orders Processed / Active Sales Days

Employees are ranked based on Average Orders per Sales Day.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(O.OrderID) * 1.0 / NULLIF(COUNT(DISTINCT CAST(O.OrderDate AS DATE)), 0) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(DISTINCT CAST(O.OrderDate AS DATE)) AS ActiveSalesDays,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(COUNT(O.OrderID) * 1.0 / NULLIF(COUNT(DISTINCT CAST(O.OrderDate AS DATE)), 0),2) AS AverageOrdersPerSalesDay
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    AverageOrdersPerSalesDay DESC,
    TotalOrdersProcessed DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 222 : Employee Sales Consistency Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 223 : Employee Average Order Value
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees generate the highest average order value?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Average Order Value (AOV) helps evaluate an employee's ability to
encourage customers to purchase higher-value orders.

This KPI helps management:

• Measure Sales Effectiveness
• Identify Upselling Opportunities
• Compare Employee Selling Skills
• Improve Revenue Generation
• Support Performance Reviews

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Revenue Generated
• Average Order Value

Formula

Average Order Value =
Total Revenue Generated / Total Orders Processed

Employees are ranked based on Average Order Value.

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER (ORDER BY AVG(O.NetAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(AVG(O.NetAmount),2) AS AverageOrderValue
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    AverageOrderValue DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 223 : Employee Average Order Value Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 224 : Employee Sales Days Analysis
------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

Which employees are active on the highest number of sales days?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

Sales days indicate employee participation in daily business operations.

This KPI helps management:

• Measure Employee Availability
• Identify Consistent Employees
• Monitor Workforce Utilization
• Support Staffing Decisions
• Evaluate Operational Participation

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Active Sales Days
• Total Orders
• Revenue Generated
• Average Revenue per Sales Day

Formula

Average Revenue per Sales Day =
Total Revenue Generated / Active Sales Days

------------------------------------------------------------------------------*/

SELECT
    DENSE_RANK() OVER(ORDER BY COUNT(DISTINCT CAST(O.OrderDate AS DATE)) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(DISTINCT CAST(O.OrderDate AS DATE))AS ActiveSalesDays,
    COUNT(O.OrderID)AS TotalOrdersProcessed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
    ROUND(SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(DISTINCT CAST(O.OrderDate AS DATE)),0),2) AS AverageRevenuePerSalesDay
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    ActiveSalesDays DESC,
    TotalRevenueGenerated DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 224 : Employee Sales Days Analysis Generated Successfully';
PRINT '==============================================================';

PRINT '';

/*------------------------------------------------------------------------------
KPI 225 : Employee Performance Scorecard
------------------------------------------------------------------------------*/

/*
------------------------------------------------------------------------------
Business Question
------------------------------------------------------------------------------

How does each employee perform across multiple key business metrics?

------------------------------------------------------------------------------
Business Importance
------------------------------------------------------------------------------

A performance scorecard combines multiple KPIs into a single report,
providing management with a comprehensive view of employee performance.

This KPI helps management:

• Evaluate Overall Employee Performance
• Compare Workforce Productivity
• Support Performance Reviews
• Identify High Performers
• Improve Decision Making

------------------------------------------------------------------------------
Expected Insight
------------------------------------------------------------------------------

The query calculates:

• Employee Rank
• Employee ID
• Employee Name
• Job Title
• Store ID
• Total Orders Processed
• Total Customers Served
• Total Revenue Generated
• Average Order Value
• Average Revenue per Customer

Employees are ranked based on Total Revenue Generated.

------------------------------------------------------------------------------
*/

SELECT
    DENSE_RANK() OVER(ORDER BY SUM(O.NetAmount) DESC) AS EmployeeRank,
    E.EmployeeID,
    CONCAT(E.FirstName,' ',E.LastName) AS EmployeeName,
    E.JobTitle,
    E.StoreID,
    COUNT(O.OrderID) AS TotalOrdersProcessed,
    COUNT(DISTINCT O.CustomerID) AS TotalCustomersServed,
    ROUND(SUM(O.NetAmount),2) AS TotalRevenueGenerated,
	ROUND(AVG(O.NetAmount),2) AS AverageOrderValue,
	ROUND(SUM(O.NetAmount) * 1.0 / NULLIF(COUNT(DISTINCT O.CustomerID),0),2) AS AverageRevenuePerCustomer
FROM dbo.Employee E
INNER JOIN dbo.[Order] O
    ON E.EmployeeID = O.EmployeeID
GROUP BY
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.JobTitle,
    E.StoreID
ORDER BY
    TotalRevenueGenerated DESC,
    AverageOrderValue DESC,
    EmployeeName;

PRINT '';

PRINT '==============================================================';
PRINT 'KPI 225 : Employee Performance Scorecard Generated Successfully';
PRINT '==============================================================';

PRINT '';