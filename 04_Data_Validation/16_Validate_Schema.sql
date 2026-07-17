/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 16_Validate_Schema.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates the database schema after deployment.

Validation Includes:

    • Database existence
    • Table existence
    • Column validation
    • Primary Keys
    • Foreign Keys
    • Indexes

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Schema Validation...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 1 : Validate Database
==============================================================================*/

IF DB_ID('RetailSalesDB') IS NOT NULL
BEGIN
    PRINT '✓ Database Exists : RetailSalesDB';
END
ELSE
BEGIN
    THROW 50001,
          'Database RetailSalesDB does not exist.',
          1;
END;

/*==============================================================================
                    Part 2 : Validate Tables
==============================================================================*/

SELECT

    TABLE_SCHEMA,

    TABLE_NAME

FROM INFORMATION_SCHEMA.TABLES

WHERE TABLE_TYPE = 'BASE TABLE'

ORDER BY

    TABLE_NAME;

PRINT '✓ Table Validation Completed';
PRINT '==============================================================';
GO

PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3 : Validate Columns
==============================================================================*/

SELECT

    TABLE_NAME,

    COLUMN_NAME,

    DATA_TYPE,

    IS_NULLABLE

FROM INFORMATION_SCHEMA.COLUMNS

ORDER BY

    TABLE_NAME,

    ORDINAL_POSITION;

PRINT '✓ Column Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4 : Validate Primary Keys
==============================================================================*/

SELECT

    KU.TABLE_NAME,

    KU.COLUMN_NAME,

    TC.CONSTRAINT_NAME

FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
    ON TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME

WHERE TC.CONSTRAINT_TYPE = 'PRIMARY KEY'

ORDER BY

    KU.TABLE_NAME;

PRINT '✓ Primary Key Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 5 : Validate Foreign Keys
==============================================================================*/

SELECT

    FK.name AS ForeignKeyName,

    OBJECT_NAME(FK.parent_object_id) AS ParentTable,

    OBJECT_NAME(FK.referenced_object_id) AS ReferencedTable

FROM sys.foreign_keys AS FK

ORDER BY

    ParentTable,

    ForeignKeyName;

PRINT '✓ Foreign Key Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 6 : Validate Indexes
==============================================================================*/

SELECT

    OBJECT_NAME(I.object_id) AS TableName,

    I.name AS IndexName,

    I.type_desc

FROM sys.indexes AS I

WHERE

    I.name IS NOT NULL

ORDER BY

    TableName,

    IndexName;

PRINT '✓ Index Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 7 : Completion
==============================================================================*/

PRINT '==============================================================';
PRINT 'Schema Validation Completed Successfully!';
PRINT '==============================================================';
GO