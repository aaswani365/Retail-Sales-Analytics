/*==============================================================================
Project       : Retail Sales Analytics & Inventory Management System
File Name     : 17_Validate_Constraints.sql
Created By    : Akshay Aswani
Created Date  : July 2026

Description:
This script validates all database constraints.

Validation Includes:

    • Primary Keys
    • Foreign Keys
    • Unique Constraints
    • Check Constraints
    • Default Constraints

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

PRINT '==============================================================';
PRINT 'Starting Constraint Validation...';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 1 : Validate Primary Keys
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

PRINT '✓ Primary Keys Validated';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 2 : Validate Foreign Keys
==============================================================================*/

SELECT

    FK.name AS ForeignKeyName,

    OBJECT_NAME(FK.parent_object_id) AS ParentTable,

    OBJECT_NAME(FK.referenced_object_id) AS ReferencedTable

FROM sys.foreign_keys AS FK

ORDER BY

    ParentTable,

    ForeignKeyName;

PRINT '✓ Foreign Keys Validated';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 3 : Validate Unique Constraints
==============================================================================*/

SELECT

    TC.TABLE_NAME,

    TC.CONSTRAINT_NAME

FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC

WHERE TC.CONSTRAINT_TYPE = 'UNIQUE'

ORDER BY

    TC.TABLE_NAME;

PRINT '✓ Unique Constraints Validated';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 4 : Validate Check Constraints
==============================================================================*/

SELECT

    OBJECT_NAME(parent_object_id) AS TableName,

    name AS CheckConstraint

FROM sys.check_constraints

ORDER BY

    TableName,

    CheckConstraint;

PRINT '✓ Check Constraints Validated';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 5 : Validate Default Constraints
==============================================================================*/

SELECT

    OBJECT_NAME(parent_object_id) AS TableName,

    name AS DefaultConstraint

FROM sys.default_constraints

ORDER BY

    TableName,

    DefaultConstraint;

PRINT '✓ Default Constraints Validated';
PRINT '==============================================================';
GO

/*==============================================================================
                    Part 6 : Completion
==============================================================================*/

PRINT '==============================================================';
PRINT 'Constraint Validation Completed Successfully!';
PRINT '==============================================================';
GO