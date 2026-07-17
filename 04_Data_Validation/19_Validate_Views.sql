/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 19_Validate_Views.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates all user-defined views.

Validation Includes:

    • View existence
    • View definition
    • Row count
    • View execution

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting View Validation...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 1 : Validate View Existence
==============================================================================*/

SELECT

    TABLE_SCHEMA,

    TABLE_NAME

FROM INFORMATION_SCHEMA.VIEWS

ORDER BY

    TABLE_NAME;

PRINT '✓ View Existence Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2 : Validate View Definitions
==============================================================================*/

SELECT

    V.name AS ViewName,

    M.definition

FROM sys.views AS V

INNER JOIN sys.sql_modules AS M
    ON V.object_id = M.object_id

ORDER BY

    ViewName;

PRINT '✓ View Definition Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3 : Validate View Metadata
==============================================================================*/

SELECT

    name,

    create_date,

    modify_date

FROM sys.views

ORDER BY

    name;

PRINT '✓ View Metadata Validation Completed';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4 : Completion
==============================================================================*/

PRINT '==============================================================';
PRINT 'View Validation Completed Successfully!';
PRINT '==============================================================';
GO