/*==============================================================================
                    Lookup & Master Data Validation
==============================================================================*/

PRINT '==================================================';
PRINT 'Lookup & Master Data Validation';
PRINT '==================================================';

------------------------------------------------------------
-- Lookup Tables
------------------------------------------------------------

SELECT 'Category' AS TableName,
       COUNT(*) AS TotalRecords
FROM dbo.Category

UNION ALL

SELECT 'SubCategory',
       COUNT(*)
FROM dbo.SubCategory

UNION ALL

SELECT 'Brand',
       COUNT(*)
FROM dbo.Brand

UNION ALL

SELECT 'PaymentMethod',
       COUNT(*)
FROM dbo.PaymentMethod

UNION ALL

SELECT 'ReturnReason',
       COUNT(*)
FROM dbo.ReturnReason

UNION ALL

SELECT 'OrderStatus',
       COUNT(*)
FROM dbo.OrderStatus

UNION ALL

SELECT 'PaymentStatus',
       COUNT(*)
FROM dbo.PaymentStatus

UNION ALL

SELECT 'ReturnStatus',
       COUNT(*)
FROM dbo.ReturnStatus

UNION ALL

SELECT 'Store',
       COUNT(*)
FROM dbo.Store

UNION ALL

SELECT 'Employee',
       COUNT(*)
FROM dbo.Employee

UNION ALL

SELECT 'Customer',
       COUNT(*)
FROM dbo.Customer

UNION ALL

SELECT 'Supplier',
       COUNT(*)
FROM dbo.Supplier;

PRINT 'Record count validation completed successfully.';


-----------------------------------------------------------

PRINT '==================================================';
PRINT 'Active Record Validation';
PRINT '==================================================';

SELECT 'Store' AS TableName,
       COUNT(*) AS ActiveRecords
FROM dbo.Store
WHERE IsActive = 1

UNION ALL

SELECT 'Employee',
       COUNT(*)
FROM dbo.Employee
WHERE IsActive = 1

UNION ALL

SELECT 'Customer',
       COUNT(*)
FROM dbo.Customer
WHERE IsActive = 1

UNION ALL

SELECT 'Supplier',
       COUNT(*)
FROM dbo.Supplier
WHERE IsActive = 1

UNION ALL

SELECT 'PaymentMethod',
       COUNT(*)
FROM dbo.PaymentMethod
WHERE IsActive = 1;

-----------------------------------------------------

PRINT '==================================================';
PRINT 'Store Manager Validation';
PRINT '==================================================';

SELECT
    s.StoreID,
    s.StoreName,
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS StoreManager
FROM dbo.Store s
INNER JOIN dbo.Employee e
    ON s.ManagerEmployeeID = e.EmployeeID
ORDER BY s.StoreID;

-------------------------------------------------------------------------------

PRINT '==================================================';
PRINT 'Employee Store Validation';
PRINT '==================================================';

SELECT
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    s.StoreName
FROM dbo.Employee e
INNER JOIN dbo.Store s
    ON e.StoreID = s.StoreID
ORDER BY e.EmployeeID;

--------------------------------------------------------------------

PRINT '==================================================';
PRINT 'Supplier Validation';
PRINT '==================================================';

SELECT
    SupplierID,
    SupplierName,
    ContactName,
    City,
    State,
    IsActive
FROM dbo.Supplier
ORDER BY SupplierID;

--------------------------------------------------------------------

PRINT '==================================================';
PRINT 'Customer Validation';
PRINT '==================================================';

SELECT TOP (20)
       CustomerID,
       FirstName,
       LastName,
       Email,
       City,
       LoyaltyPoints
FROM dbo.Customer
ORDER BY CustomerID;

------------------------------------------------------------------------

PRINT '==================================================';
PRINT 'Duplicate Email Validation';
PRINT '==================================================';

SELECT Email,
       COUNT(*) AS Total
FROM dbo.Customer
WHERE Email IS NOT NULL
GROUP BY Email
HAVING COUNT(*) > 1;

SELECT Email,
       COUNT(*) AS Total
FROM dbo.Employee
GROUP BY Email
HAVING COUNT(*) > 1;