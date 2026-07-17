/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 25_Performance_Optimization.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script demonstrates SQL Server performance optimization techniques
using the RetailSalesDB database.

The objective of this script is to analyze database performance,
identify optimization opportunities, and demonstrate best practices
for writing efficient SQL queries.

Topics Covered:

    • Database Performance Overview
    • Index Usage Statistics
    • Missing Index Recommendations
    • Unused Index Analysis
    • Slow Query Analysis
    • Query Cost Analysis
    • Query Optimization Techniques
    • SARGable vs Non-SARGable Queries
    • Covering Indexes
    • EXISTS vs IN
    • SELECT * vs Column Selection
    • JOIN Optimization
    • Pagination Best Practices
    • Statistics & Execution Plans
    • Performance Optimization Checklist

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Performance Optimization Analysis...';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 2 : Database Performance Overview
==============================================================================*/

PRINT 'Generating Database Performance Overview...';

SELECT

    D.name AS DatabaseName,

    D.compatibility_level AS CompatibilityLevel,

    D.recovery_model_desc AS RecoveryModel,

    D.user_access_desc AS UserAccess,

    D.state_desc AS DatabaseState,

    D.is_auto_close_on AS AutoClose,

    D.is_auto_shrink_on AS AutoShrink,

    D.is_read_only AS ReadOnly,

    CAST
    (
        SUM(MF.size) * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS DatabaseSizeMB

FROM sys.databases AS D

INNER JOIN sys.master_files AS MF
    ON D.database_id = MF.database_id

WHERE

    D.name = DB_NAME()

GROUP BY

    D.name,
    D.compatibility_level,
    D.recovery_model_desc,
    D.user_access_desc,
    D.state_desc,
    D.is_auto_close_on,
    D.is_auto_shrink_on,
    D.is_read_only;

PRINT 'Database Performance Overview Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 3 : Index Usage Statistics
==============================================================================*/

PRINT 'Generating Index Usage Statistics...';

SELECT

    OBJECT_NAME(I.object_id) AS TableName,

    I.name AS IndexName,

    I.type_desc AS IndexType,

    ISNULL(S.user_seeks, 0) AS UserSeeks,

    ISNULL(S.user_scans, 0) AS UserScans,

    ISNULL(S.user_lookups, 0) AS UserLookups,

    ISNULL(S.user_updates, 0) AS UserUpdates,

    ISNULL(S.last_user_seek, NULL) AS LastUserSeek,

    ISNULL(S.last_user_scan, NULL) AS LastUserScan,

    ISNULL(S.last_user_lookup, NULL) AS LastUserLookup,

    ISNULL(S.last_user_update, NULL) AS LastUserUpdate

FROM sys.indexes AS I

LEFT JOIN sys.dm_db_index_usage_stats AS S

    ON I.object_id = S.object_id
   AND I.index_id = S.index_id
   AND S.database_id = DB_ID()

WHERE

    OBJECTPROPERTY(I.object_id, 'IsUserTable') = 1
    AND I.name IS NOT NULL

ORDER BY

    TableName,
    IndexName;

PRINT 'Index Usage Statistics Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 4 : Missing Index Recommendations
==============================================================================*/

PRINT 'Generating Missing Index Recommendations...';

SELECT

    DB_NAME(MID.database_id) AS DatabaseName,

    OBJECT_NAME(MID.object_id, MID.database_id) AS TableName,

    MIGS.user_seeks AS UserSeeks,

    MIGS.user_scans AS UserScans,

    CAST
    (
        MIGS.avg_total_user_cost
        AS DECIMAL(10,2)
    ) AS AvgQueryCost,

    CAST
    (
        MIGS.avg_user_impact
        AS DECIMAL(10,2)
    ) AS AvgImprovementPercent,

    MID.equality_columns AS EqualityColumns,

    MID.inequality_columns AS InequalityColumns,

    MID.included_columns AS IncludedColumns

FROM sys.dm_db_missing_index_group_stats AS MIGS

INNER JOIN sys.dm_db_missing_index_groups AS MIG

    ON MIGS.group_handle = MIG.index_group_handle

INNER JOIN sys.dm_db_missing_index_details AS MID

    ON MIG.index_handle = MID.index_handle

WHERE

    MID.database_id = DB_ID()

ORDER BY

    AvgImprovementPercent DESC,
    UserSeeks DESC;

PRINT 'Missing Index Recommendations Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 5 : Unused Index Analysis
==============================================================================*/

PRINT 'Generating Unused Index Analysis...';

SELECT

    OBJECT_NAME(I.object_id) AS TableName,

    I.name AS IndexName,

    I.type_desc AS IndexType,

    ISNULL(S.user_seeks, 0) AS UserSeeks,

    ISNULL(S.user_scans, 0) AS UserScans,

    ISNULL(S.user_lookups, 0) AS UserLookups,

    ISNULL(S.user_updates, 0) AS UserUpdates,

    S.last_user_seek,

    S.last_user_scan,

    S.last_user_lookup,

    S.last_user_update

FROM sys.indexes AS I

LEFT JOIN sys.dm_db_index_usage_stats AS S

    ON I.object_id = S.object_id
   AND I.index_id = S.index_id
   AND S.database_id = DB_ID()

WHERE

    OBJECTPROPERTY(I.object_id, 'IsUserTable') = 1

    AND I.index_id > 0

    AND I.is_primary_key = 0

    AND I.is_unique_constraint = 0

    AND ISNULL(S.user_seeks, 0) = 0

    AND ISNULL(S.user_scans, 0) = 0

    AND ISNULL(S.user_lookups, 0) = 0

ORDER BY

    TableName,

    IndexName;

PRINT 'Unused Index Analysis Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 6 : Slow Query Analysis
==============================================================================*/

PRINT 'Generating Slow Query Analysis...';

SELECT TOP (20)

    QS.execution_count AS ExecutionCount,

    CAST
    (
        QS.total_elapsed_time / 1000.0
        AS DECIMAL(18,2)
    ) AS TotalElapsedTimeMS,

    CAST
    (
        (QS.total_elapsed_time * 1.0 / QS.execution_count) / 1000.0
        AS DECIMAL(18,2)
    ) AS AverageElapsedTimeMS,

    CAST
    (
        QS.total_worker_time / 1000.0
        AS DECIMAL(18,2)
    ) AS TotalCPUTimeMS,

    QS.total_logical_reads AS TotalLogicalReads,

    QS.total_logical_writes AS TotalLogicalWrites,

    QS.last_execution_time AS LastExecutionTime,

    SUBSTRING
    (
        ST.text,
        (QS.statement_start_offset / 2) + 1,
        (
            (
                CASE QS.statement_end_offset
                    WHEN -1 THEN DATALENGTH(ST.text)
                    ELSE QS.statement_end_offset
                END
                - QS.statement_start_offset
            ) / 2
        ) + 1
    ) AS QueryText

FROM sys.dm_exec_query_stats AS QS

CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) AS ST

ORDER BY

    QS.total_elapsed_time DESC;

PRINT 'Slow Query Analysis Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 7 : Query Cost Analysis
==============================================================================*/

PRINT 'Generating Query Cost Analysis...';

SELECT TOP (20)

    QS.execution_count AS ExecutionCount,

    CAST
    (
        QS.total_worker_time / 1000.0
        AS DECIMAL(18,2)
    ) AS TotalCPUTimeMS,

    CAST
    (
        (QS.total_worker_time * 1.0 / QS.execution_count) / 1000.0
        AS DECIMAL(18,2)
    ) AS AverageCPUTimeMS,

    QS.total_logical_reads AS TotalLogicalReads,

    CAST
    (
        QS.total_logical_reads * 1.0 / QS.execution_count
        AS DECIMAL(18,2)
    ) AS AverageLogicalReads,

    QS.total_logical_writes AS TotalLogicalWrites,

    CAST
    (
        QS.total_elapsed_time / 1000.0
        AS DECIMAL(18,2)
    ) AS TotalElapsedTimeMS,

    SUBSTRING
    (
        ST.text,
        (QS.statement_start_offset / 2) + 1,
        (
            (
                CASE QS.statement_end_offset
                    WHEN -1 THEN DATALENGTH(ST.text)
                    ELSE QS.statement_end_offset
                END
                - QS.statement_start_offset
            ) / 2
        ) + 1
    ) AS QueryText

FROM sys.dm_exec_query_stats AS QS

CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) AS ST

ORDER BY

    AverageLogicalReads DESC,
    AverageCPUTimeMS DESC;

PRINT 'Query Cost Analysis Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 8 : Query Optimization Examples
==============================================================================*/

PRINT 'Demonstrating Query Optimization Techniques...';

PRINT '==============================================================';
PRINT 'Example 1 : Avoid Unnecessary DISTINCT';
PRINT '==============================================================';

/*
BAD PRACTICE

Using DISTINCT when duplicate rows cannot occur
adds unnecessary sorting overhead.
*/

-- Example Only

SELECT DISTINCT

    CustomerID

FROM dbo.Customer;

PRINT '--------------------------------------------------------------';

/*
GOOD PRACTICE

Remove DISTINCT when uniqueness is already guaranteed
by the Primary Key.
*/

SELECT

    CustomerID

FROM dbo.Customer;

PRINT '==============================================================';
PRINT 'Example 2 : Return Only Required Columns';
PRINT '==============================================================';

/*
BAD PRACTICE

Returning every column increases network traffic
and memory usage.
*/

SELECT *

FROM dbo.Product;

PRINT '--------------------------------------------------------------';

/*
GOOD PRACTICE

Return only the required columns.
*/

SELECT

    ProductID,
    ProductName,
    CostPrice

FROM dbo.Product;

PRINT '==============================================================';
PRINT 'Example 3 : Filter Data Early';
PRINT '==============================================================';

/*
GOOD PRACTICE

Apply filtering in the WHERE clause so SQL Server
processes fewer rows.
*/

SELECT

    OrderID,
    CustomerID,
    SubTotalAmount

FROM dbo.[Order]

WHERE SubTotalAmount > 5000;

PRINT '==============================================================';
PRINT 'Example 4 : Use Appropriate WHERE Conditions';
PRINT '==============================================================';

/*
GOOD PRACTICE

Use indexed columns whenever possible
to reduce logical reads.
*/

SELECT

    CustomerID,
    FirstName

FROM dbo.Customer

WHERE CustomerID = 100;

PRINT '==============================================================';
PRINT 'Example 5 : Use TOP When Appropriate';
PRINT '==============================================================';

/*
GOOD PRACTICE

Return only the rows required by the application.
*/

SELECT TOP (10)

    ProductID,
    ProductName,
    CostPrice

FROM dbo.Product

ORDER BY CostPrice DESC;

PRINT '==============================================================';
PRINT 'Query Optimization Examples Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 9 : SARGable vs Non-SARGable Queries
==============================================================================*/

PRINT 'Demonstrating SARGable vs Non-SARGable Queries...';

PRINT '==============================================================';
PRINT 'Example 1 : NON-SARGABLE Query';
PRINT '==============================================================';

/*
BAD PRACTICE

Applying a function to an indexed column prevents SQL Server
from performing an Index Seek.

Expected Result:
• Index Scan
• Higher Logical Reads
*/

-- Example Only (Do Not Execute for Performance Testing)

SELECT

    OrderID,
    CustomerID,
    OrderDate

FROM dbo.[Order]

WHERE YEAR(OrderDate) = 2025;

PRINT '==============================================================';
PRINT 'Example 2 : SARGABLE Query';
PRINT '==============================================================';

/*
GOOD PRACTICE

Use a date range instead of applying YEAR().

Expected Result:
• Index Seek
• Lower Logical Reads
*/

SELECT

    OrderID,
    CustomerID,
    OrderDate

FROM dbo.[Order]

WHERE

    OrderDate >= '2025-01-01'
    AND OrderDate < '2026-01-01';

PRINT '==============================================================';
PRINT 'Example 3 : NON-SARGABLE String Search';
PRINT '==============================================================';

/*
BAD PRACTICE

Using LEFT() prevents SQL Server from using an index efficiently.
*/

SELECT

    CustomerID,
    FirstName

FROM dbo.Customer

WHERE LEFT(FirstName,1) = 'A';

PRINT '==============================================================';
PRINT 'Example 4 : SARGABLE String Search';
PRINT '==============================================================';

/*
GOOD PRACTICE

LIKE 'A%' allows SQL Server to use an Index Seek.
*/

SELECT

    CustomerID,
    FirstName

FROM dbo.Customer

WHERE FirstName LIKE 'A%';

PRINT '==============================================================';
PRINT 'Example 5 : NON-SARGABLE ISNULL()';
PRINT '==============================================================';

/*
BAD PRACTICE

Applying ISNULL() to a searchable column
prevents efficient index usage.
*/

SELECT

    ProductID,
    ProductName,
    CostPrice  

FROM dbo.Product

WHERE ISNULL(CostPrice,0) > 1000;

PRINT '==============================================================';
PRINT 'Example 6 : SARGABLE Predicate';
PRINT '==============================================================';

/*
GOOD PRACTICE

Filter NULL values separately.

Allows SQL Server to use indexes efficiently.
*/

SELECT

    ProductID,
    ProductName,
    CostPrice

FROM dbo.Product

WHERE

    CostPrice IS NOT NULL
    AND CostPrice > 1000;

PRINT 'SARGable Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 10 : Covering Index Example
==============================================================================*/

PRINT 'Demonstrating Covering Index Concept...';

PRINT '==============================================================';
PRINT 'Example 1 : Query Without Covering Index';
PRINT '==============================================================';

/*
SCENARIO

This query filters by CustomerID
but also returns OrderDate and TotalAmount.

Without a covering index, SQL Server may perform:

    • Index Seek
    • Key Lookup

Key Lookups become expensive when many rows are returned.
*/

SELECT

    OrderID,
    CustomerID,
    OrderDate,
    SubTotalAmount

FROM dbo.[Order]

WHERE CustomerID = 101;

PRINT '==============================================================';
PRINT 'Recommended Covering Index';
PRINT '==============================================================';

/*
Recommended Covering Index

NOTE:
This statement is provided as an example.
Review before creating in a production environment.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE
        name = 'IX_Order_CustomerID'
        AND object_id = OBJECT_ID('dbo.[Order]')
)
BEGIN

    CREATE NONCLUSTERED INDEX IX_Order_CustomerID

    ON dbo.[Order]
    (
        CustomerID
    )

    INCLUDE
    (
        OrderDate,
        SubTotalAmount
    );

END
ELSE
BEGIN

    PRINT 'Index IX_Order_CustomerID already exists.';

END;
GO

PRINT '==============================================================';
PRINT 'Example 2 : Query After Covering Index';
PRINT '==============================================================';

/*
Expected Benefits

✓ Eliminates Key Lookup

✓ Reduces Logical Reads

✓ Improves Query Performance

Expected Execution Plan

Index Seek
*/

SELECT

    OrderID,
    CustomerID,
    OrderDate,
    SubTotalAmount

FROM dbo.[Order]

WHERE CustomerID = 101;

PRINT 'Covering Index Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 11 : EXISTS vs IN
==============================================================================*/

PRINT 'Demonstrating EXISTS vs IN...';

PRINT '==============================================================';
PRINT 'Example 1 : Using IN';
PRINT '==============================================================';

/*
USING IN

The IN operator compares values against a list returned
by the subquery.

Suitable for:

    • Small result sets
    • Static lookup values

May become less efficient for very large subqueries.
*/

SELECT

    CustomerID,
    FirstName

FROM dbo.Customer

WHERE CustomerID IN
(
    SELECT CustomerID
    FROM dbo.[Order]
);

PRINT '==============================================================';
PRINT 'Example 2 : Using EXISTS';
PRINT '==============================================================';

/*
USING EXISTS

EXISTS stops searching as soon as SQL Server finds
the first matching row.

Suitable for:

    • Large tables
    • Correlated subqueries
    • Better scalability
*/

SELECT

    C.CustomerID,
    C.FirstName

FROM dbo.Customer AS C

WHERE EXISTS
(
    SELECT 1

    FROM dbo.[Order] AS O

    WHERE O.CustomerID = C.CustomerID
);

PRINT '==============================================================';
PRINT 'Performance Comparison';
PRINT '==============================================================';

/*
GENERAL GUIDELINES

IN

✓ Good for small lookup lists
✓ Easy to read

EXISTS

✓ Better for correlated subqueries
✓ Stops after first match
✓ Usually preferred for large datasets

NOTE

SQL Server's Query Optimizer may generate identical
execution plans for both queries depending on
statistics, indexes, and data distribution.
*/

PRINT 'EXISTS vs IN Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 12 : SELECT * vs Column Selection
==============================================================================*/

PRINT 'Demonstrating SELECT * vs Column Selection...';

PRINT '==============================================================';
PRINT 'Example 1 : Using SELECT *';
PRINT '==============================================================';

/*
BAD PRACTICE

SELECT * returns every column from the table.

Disadvantages:

    • Reads unnecessary data
    • Increases network traffic
    • Uses more memory
    • May prevent efficient covering index usage
*/

SELECT *

FROM dbo.Product;

PRINT '==============================================================';
PRINT 'Example 2 : Selecting Required Columns';
PRINT '==============================================================';

/*
GOOD PRACTICE

Retrieve only the columns required by the application.

Advantages:

    ✓ Reduces data transfer
    ✓ Uses less memory
    ✓ Improves query performance
    ✓ Allows SQL Server to use Covering Indexes
*/

SELECT

    ProductID,
    ProductName,
    CostPrice

FROM dbo.Product;

PRINT '==============================================================';
PRINT 'Performance Comparison';
PRINT '==============================================================';

/*
SELECT *

✓ Returns every column
✗ Higher I/O
✗ More network traffic
✗ Higher memory usage
✗ Harder to maintain

Explicit Column Selection

✓ Returns only required data
✓ Lower I/O
✓ Faster result transmission
✓ Better execution plans
✓ Easier code maintenance

Recommendation

Always specify the required columns instead of using
SELECT *, especially in production applications.
*/

PRINT 'SELECT * vs Column Selection Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 13 : JOIN Optimization
==============================================================================*/

PRINT 'Demonstrating JOIN Optimization...';

PRINT '==============================================================';
PRINT 'Example 1 : Optimized INNER JOIN';
PRINT '==============================================================';

/*
GOOD PRACTICE

• Join on indexed columns.
• Return only required columns.
• Avoid SELECT *.
*/

SELECT

    O.OrderID,

    C.FirstName,

    O.OrderDate,

    O.SubTotalAmount

FROM dbo.[Order] AS O

INNER JOIN dbo.Customer AS C

    ON O.CustomerID = C.CustomerID;

PRINT '==============================================================';
PRINT 'Example 2 : Filter Before Joining';
PRINT '==============================================================';

/*
GOOD PRACTICE

Filter rows as early as possible to reduce
the number of rows participating in the JOIN.
*/

SELECT

    O.OrderID,

    C.FirstName,

    O.SubTotalAmount

FROM dbo.[Order] AS O

INNER JOIN dbo.Customer AS C

    ON O.CustomerID = C.CustomerID

WHERE

    O.SubTotalAmount > 10000;

PRINT '==============================================================';
PRINT 'Example 3 : Avoid Unnecessary JOINs';
PRINT '==============================================================';

/*
BAD PRACTICE

Joining tables that do not contribute
to the final result increases query cost.
*/

-- Example Only

SELECT

    O.OrderID,

    C.FirstName

FROM dbo.[Order] AS O

INNER JOIN dbo.Customer AS C

    ON O.CustomerID = C.CustomerID

INNER JOIN dbo.Employee AS E

    ON O.EmployeeID = E.EmployeeID;

PRINT '--------------------------------------------------------------';

/*
GOOD PRACTICE

Remove unnecessary joins when their data
is not required.
*/

SELECT

    O.OrderID,

    C.FirstName

FROM dbo.[Order] AS O

INNER JOIN dbo.Customer AS C

    ON O.CustomerID = C.CustomerID;

PRINT '==============================================================';
PRINT 'JOIN Optimization Best Practices';
PRINT '==============================================================';

/*
✓ Join on indexed columns whenever possible.

✓ Return only required columns.

✓ Filter data early using the WHERE clause.

✓ Avoid unnecessary JOINs.

✓ Use INNER JOIN when unmatched rows are not required.

✓ Review execution plans for expensive JOIN operators
  such as Hash Match when performance tuning.

✓ Ensure join columns use compatible data types.
*/

PRINT 'JOIN Optimization Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 14 : Pagination Best Practices
==============================================================================*/

PRINT 'Demonstrating Pagination Best Practices...';

PRINT '==============================================================';
PRINT 'Example 1 : Retrieving All Rows';
PRINT '==============================================================';

/*
BAD PRACTICE

Retrieving all rows when the application
only needs one page of data.

Disadvantages:

    • Higher I/O
    • Increased memory usage
    • More network traffic
*/

SELECT

    OrderID,

    CustomerID,

    OrderDate,

    SubTotalAmount

FROM dbo.[Order]

ORDER BY

    OrderDate DESC;

PRINT '==============================================================';
PRINT 'Example 2 : Using OFFSET FETCH';
PRINT '==============================================================';

/*
GOOD PRACTICE

Retrieve only the rows required for the
requested page.

Example:

Page Number = 2

Page Size = 10
*/

DECLARE @PageNumber INT = 2;

DECLARE @PageSize INT = 10;

SELECT

    OrderID,

    CustomerID,

    OrderDate,

    SubTotalAmount

FROM dbo.[Order]

ORDER BY

    OrderDate DESC

OFFSET (@PageNumber - 1) * @PageSize ROWS

FETCH NEXT @PageSize ROWS ONLY;

PRINT '==============================================================';
PRINT 'Pagination Best Practices';
PRINT '==============================================================';

/*
✓ Always use ORDER BY with OFFSET FETCH.

✓ Retrieve only the required page.

✓ Use indexed columns for sorting whenever possible.

✓ Avoid returning unnecessary rows.

✓ Keep page sizes reasonable
  (e.g. 10, 25, 50, 100 rows).

✓ Large OFFSET values may become slower
  because SQL Server still processes
  the skipped rows.
*/

PRINT 'Pagination Demonstration Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 15 : Statistics & Execution Plans
==============================================================================*/

PRINT 'Generating Statistics & Execution Plan Information...';

PRINT '==============================================================';
PRINT 'Database Statistics';
PRINT '==============================================================';

SELECT

    OBJECT_NAME(S.object_id) AS TableName,

    S.name AS StatisticsName,

    ST.last_updated AS LastUpdated,

    ST.rows AS TotalRows,

    ST.rows_sampled AS RowsSampled,

    ST.steps AS HistogramSteps,

    ST.modification_counter AS ModificationCount

FROM sys.stats AS S

CROSS APPLY sys.dm_db_stats_properties
(
    S.object_id,
    S.stats_id
) AS ST

WHERE

    OBJECTPROPERTY(S.object_id, 'IsUserTable') = 1

ORDER BY

    TableName,

    StatisticsName;

PRINT '==============================================================';
PRINT 'Execution Plan Best Practices';
PRINT '==============================================================';

/*
Execution Plans help identify:

✓ Index Seek

✓ Index Scan

✓ Table Scan

✓ Key Lookup

✓ Hash Match

✓ Nested Loops

✓ Merge Join

To View an Execution Plan in SSMS

1. Press Ctrl + M

OR

Query
→ Include Actual Execution Plan

Then execute the query.

Review operators with the highest estimated cost.
*/

PRINT '==============================================================';
PRINT 'Statistics Best Practices';
PRINT '==============================================================';

/*
✓ Keep AUTO_CREATE_STATISTICS enabled.

✓ Keep AUTO_UPDATE_STATISTICS enabled.

✓ Update statistics after large data loads.

Example:

UPDATE STATISTICS dbo.Customer;

or

EXEC sp_updatestats;

Accurate statistics help the Query Optimizer
choose efficient execution plans.
*/

PRINT 'Statistics & Execution Plan Information Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 16 : Performance Optimization Checklist
==============================================================================*/

PRINT '==============================================================';
PRINT 'Performance Optimization Checklist';
PRINT '==============================================================';

/*

GENERAL QUERY OPTIMIZATION

✓ Avoid using SELECT * in production queries.

✓ Retrieve only the required columns.

✓ Return only the required number of rows.

✓ Filter data as early as possible.

✓ Write SARGable WHERE conditions.

✓ Avoid unnecessary DISTINCT operations.

--------------------------------------------------------------

INDEX OPTIMIZATION

✓ Create indexes based on workload.

✓ Monitor Index Usage Statistics regularly.

✓ Review Missing Index Recommendations.

✓ Remove or consolidate unused indexes after analysis.

✓ Consider Covering Indexes for frequently executed queries.

--------------------------------------------------------------

QUERY PERFORMANCE

✓ Use EXISTS for correlated subqueries when appropriate.

✓ Use proper JOIN conditions.

✓ Join on indexed columns whenever possible.

✓ Avoid unnecessary JOINs.

✓ Use OFFSET FETCH for pagination.

--------------------------------------------------------------

STATISTICS

✓ Keep AUTO_CREATE_STATISTICS enabled.

✓ Keep AUTO_UPDATE_STATISTICS enabled.

✓ Update statistics after large data loads.

--------------------------------------------------------------

EXECUTION PLANS

✓ Review Actual Execution Plans.

✓ Prefer Index Seek over Index Scan.

✓ Minimize Key Lookups.

✓ Reduce Logical Reads.

✓ Identify expensive operators.

--------------------------------------------------------------

GENERAL BEST PRACTICES

✓ Use appropriate data types.

✓ Keep transactions short.

✓ Avoid unnecessary cursors.

✓ Avoid scalar functions in WHERE clauses.

✓ Regularly monitor database performance.

✓ Periodically review indexes and statistics.

==============================================================

END OF PERFORMANCE OPTIMIZATION CHECKLIST

==============================================================

*/

PRINT 'Performance Optimization Checklist Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                Part 17 : Completion
==============================================================================*/

PRINT '==============================================================';
PRINT 'Performance Optimization Analysis Completed Successfully!';
PRINT '==============================================================';

PRINT 'Summary of Sections Completed:';

PRINT '✓ Part 1  : Introduction';
PRINT '✓ Part 2  : Database Performance Overview';
PRINT '✓ Part 3  : Index Usage Statistics';
PRINT '✓ Part 4  : Missing Index Recommendations';
PRINT '✓ Part 5  : Unused Index Analysis';
PRINT '✓ Part 6  : Slow Query Analysis';
PRINT '✓ Part 7  : Query Cost Analysis';
PRINT '✓ Part 8  : Query Optimization Examples';
PRINT '✓ Part 9  : SARGable vs Non-SARGable Queries';
PRINT '✓ Part 10 : Covering Index Example';
PRINT '✓ Part 11 : EXISTS vs IN';
PRINT '✓ Part 12 : SELECT * vs Column Selection';
PRINT '✓ Part 13 : JOIN Optimization';
PRINT '✓ Part 14 : Pagination Best Practices';
PRINT '✓ Part 15 : Statistics & Execution Plans';
PRINT '✓ Part 16 : Performance Optimization Checklist';

PRINT '==============================================================';
PRINT '22_Performance_Optimization.sql Executed Successfully.';
PRINT '==============================================================';
GO