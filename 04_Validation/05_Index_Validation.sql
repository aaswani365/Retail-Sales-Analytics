/*==============================================================================
                    Index_Validation.sql
==============================================================================

Description:
------------
Displays all NONCLUSTERED and UNIQUE indexes created in the
Retail Sales Analytics database.

Purpose:
--------
- Verify index creation
- Validate deployment
- Review indexed columns
- Excludes Primary Key indexes

==============================================================================*/

SELECT
    t.name AS TableName,
    ind.name AS IndexName,
    ind.type_desc AS IndexType,
    col.name AS ColumnName,
    ic.key_ordinal AS ColumnOrder,
    ind.is_unique AS IsUnique,
    ind.is_unique_constraint AS IsUniqueConstraint
FROM sys.indexes ind
INNER JOIN sys.index_columns ic
    ON ind.object_id = ic.object_id
   AND ind.index_id = ic.index_id
INNER JOIN sys.columns col
    ON ic.object_id = col.object_id
   AND ic.column_id = col.column_id
INNER JOIN sys.tables t
    ON ind.object_id = t.object_id
WHERE ind.is_primary_key = 0
  AND ind.type > 0
ORDER BY
    t.name,
    ind.name,
    ic.key_ordinal;


/*==============================================================================
                    Index Count by Table
==============================================================================*/

SELECT
    t.name AS TableName,
    COUNT(*) AS TotalIndexes
FROM sys.indexes i
JOIN sys.tables t
ON i.object_id = t.object_id
WHERE i.type > 0
AND i.is_primary_key = 0
GROUP BY t.name
ORDER BY t.name;