/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 21_Database_Maintenance.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script performs routine database maintenance tasks for the
Retail Sales Analytics & Inventory Management System.

Maintenance tasks include:

    • Database information
    • Table row counts
    • Index fragmentation analysis
    • Index maintenance
    • Statistics maintenance
    • Database health checks
    • File space information

These scripts help maintain database performance,
optimize query execution, and ensure database health.

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Database Maintenance...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.1 : Database Properties Report
==============================================================================*/

PRINT 'Generating Database Properties Report...';

SELECT

    name AS DatabaseName,

    database_id AS DatabaseID,

    recovery_model_desc AS RecoveryModel,

    compatibility_level AS CompatibilityLevel,

    state_desc AS DatabaseState,

    collation_name AS Collation,

    create_date AS CreatedDate,

    SUSER_SNAME(owner_sid) AS DatabaseOwner,

    user_access_desc AS UserAccess,

    is_read_only AS IsReadOnly,

    is_auto_close_on AS AutoClose,

    is_auto_shrink_on AS AutoShrink

FROM sys.databases

WHERE name = DB_NAME();

PRINT 'Database Properties Report Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2.2 : Table Row Count Report
==============================================================================*/

PRINT 'Generating Table Row Count Report...';

SELECT

    SCHEMA_NAME(T.schema_id) AS SchemaName,

    T.name AS TableName,

    SUM(P.rows) AS TotalRows

FROM sys.tables AS T

INNER JOIN sys.partitions AS P
    ON T.object_id = P.object_id

WHERE

    P.index_id IN (0,1)

AND T.is_ms_shipped = 0

GROUP BY

    SCHEMA_NAME(T.schema_id),

    T.name

ORDER BY

    TotalRows DESC,

    TableName ASC;

PRINT 'Table Row Count Report Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.1 : Index Fragmentation Report
==============================================================================*/

PRINT 'Generating Index Fragmentation Report...';

SELECT

    OBJECT_SCHEMA_NAME(IPS.object_id) AS SchemaName,

    OBJECT_NAME(IPS.object_id) AS TableName,

    I.name AS IndexName,

    I.type_desc AS IndexType,

    IPS.index_level,

    IPS.page_count,

    CAST
    (
        IPS.avg_fragmentation_in_percent
        AS DECIMAL(6,2)
    ) AS FragmentationPercent,

    CASE
        WHEN IPS.avg_fragmentation_in_percent > 30
            THEN 'REBUILD'

        WHEN IPS.avg_fragmentation_in_percent BETWEEN 5 AND 30
            THEN 'REORGANIZE'

        ELSE 'NO ACTION'
    END AS RecommendedAction

FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) AS IPS

INNER JOIN sys.indexes AS I
    ON IPS.object_id = I.object_id
   AND IPS.index_id = I.index_id

WHERE

    IPS.page_count > 100

ORDER BY

    FragmentationPercent DESC,

    TableName,

    IndexName;

PRINT 'Index Fragmentation Report Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.2 : Generate REBUILD Index Commands
==============================================================================*/

PRINT 'Generating Index REBUILD Commands...';

SELECT

    OBJECT_SCHEMA_NAME(IPS.object_id) AS SchemaName,

    OBJECT_NAME(IPS.object_id) AS TableName,

    I.name AS IndexName,

    CAST
    (
        IPS.avg_fragmentation_in_percent
        AS DECIMAL(6,2)
    ) AS FragmentationPercent,

    'ALTER INDEX [' + I.name + '] ON [' +
    OBJECT_SCHEMA_NAME(IPS.object_id) + '].[' +
    OBJECT_NAME(IPS.object_id) +
    '] REBUILD;' AS RebuildCommand

FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) AS IPS

INNER JOIN sys.indexes AS I
    ON IPS.object_id = I.object_id
   AND IPS.index_id = I.index_id

WHERE

    IPS.page_count > 100

AND IPS.avg_fragmentation_in_percent > 30

ORDER BY

    FragmentationPercent DESC;

PRINT 'Index REBUILD Commands Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3.3 : Generate REORGANIZE Index Commands
==============================================================================*/

PRINT 'Generating Index REORGANIZE Commands...';

SELECT

    OBJECT_SCHEMA_NAME(IPS.object_id) AS SchemaName,

    OBJECT_NAME(IPS.object_id) AS TableName,

    I.name AS IndexName,

    CAST
    (
        IPS.avg_fragmentation_in_percent
        AS DECIMAL(6,2)
    ) AS FragmentationPercent,

    'ALTER INDEX [' + I.name + '] ON [' +
    OBJECT_SCHEMA_NAME(IPS.object_id) + '].[' +
    OBJECT_NAME(IPS.object_id) +
    '] REORGANIZE;' AS ReorganizeCommand

FROM sys.dm_db_index_physical_stats
(
    DB_ID(),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) AS IPS

INNER JOIN sys.indexes AS I
    ON IPS.object_id = I.object_id
   AND IPS.index_id = I.index_id

WHERE

    IPS.page_count > 100

AND IPS.avg_fragmentation_in_percent BETWEEN 5 AND 30

ORDER BY

    FragmentationPercent DESC;

PRINT 'Index REORGANIZE Commands Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4.1 : Update Database Statistics
==============================================================================*/

PRINT 'Updating Database Statistics...';

EXEC sp_updatestats;

PRINT 'Database Statistics Updated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 5.1 : Database Integrity Check
==============================================================================*/

PRINT 'Running Database Integrity Check...';

DBCC CHECKDB
(
    RetailSalesDB
)
WITH NO_INFOMSGS;

PRINT 'Database Integrity Check Completed Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 5.2 : Database File Space Report
==============================================================================*/

PRINT 'Generating Database File Space Report...';

SELECT

    DB_NAME() AS DatabaseName,

    DF.name AS LogicalFileName,

    DF.physical_name AS PhysicalFileName,

    DF.type_desc AS FileType,

    CAST
    (
        DF.size * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS TotalSizeMB,

    CAST
    (
        FILEPROPERTY(DF.name, 'SpaceUsed') * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS UsedSpaceMB,

    CAST
    (
        (DF.size - FILEPROPERTY(DF.name, 'SpaceUsed')) * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS FreeSpaceMB,

    CAST
    (
        (
            (DF.size - FILEPROPERTY(DF.name, 'SpaceUsed')) * 100.0
        ) / DF.size
        AS DECIMAL(6,2)
    ) AS FreeSpacePercent

FROM sys.database_files AS DF

ORDER BY

    DF.type_desc,
    DF.name;

PRINT 'Database File Space Report Generated Successfully.';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 6 : Completion Message
==============================================================================*/

PRINT '==============================================================';
PRINT 'Database Maintenance Completed Successfully!';
PRINT '==============================================================';

PRINT 'Maintenance Tasks Executed:';

PRINT '  ✓ Database Size Report';
PRINT '  ✓ Table Row Count Report';
PRINT '  ✓ Index Fragmentation Report';
PRINT '  ✓ Generate REBUILD Index Commands';
PRINT '  ✓ Generate REORGANIZE Index Commands';
PRINT '  ✓ Update Database Statistics';
PRINT '  ✓ Database Integrity Check (DBCC CHECKDB)';
PRINT '  ✓ Database File Space Report';

PRINT '==============================================================';
PRINT '21_Database_Maintenance.sql Completed Successfully.';
PRINT '==============================================================';

GO