/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 01_Create_Database.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
Creates a fresh RetailSalesDB database for development and testing.

Business Rules:
---------------
- Existing database is dropped (Development Environment Only).
- Active connections are terminated automatically.
- A clean database is created for executing all setup scripts.

==============================================================================*/

/*==============================================================================
NOTE:
-----
This script is intended for development and testing only.

Executing this script will:
- Drop the existing RetailSalesDB database (if it exists).
- Permanently delete all data stored in the database.
- Terminate all active database connections.

Do NOT execute this script in a Production environment.

==============================================================================*/

PRINT 'Creating RetailSalesDB...';
GO

-- Drop database if it already exists (Development Only)

IF DB_ID('RetailSalesDB') IS NOT NULL
BEGIN
    ALTER DATABASE RetailSalesDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE RetailSalesDB;
END
GO

-- Create Database

CREATE DATABASE RetailSalesDB;
GO

-- Use Database

USE RetailSalesDB;
GO

PRINT '=============================================';
PRINT 'RetailSalesDB created successfully.';
PRINT 'Database setup completed.';
PRINT '=============================================';
GO

PRINT '====================================';
PRINT '01_Create_Database.sql completed.';
PRINT '====================================';