/*============================================================
Project : Retail Sales Analytics & Inventory Management System
File    : 01_Create_Database.sql
Author  : Akshay Aswani
Version : 1.0
Database: RetailSalesDB
=============================================================*/

-- Drop database if it already exists (Development Only)

IF DB_ID('RetailSalesDB') IS NOT NULL
BEGIN
    ALTER DATABASE RetailSalesDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RetailSalesDB;
END
GO

-- Create Database

CREATE DATABASE RetailSalesDB;
GO

-- Use Database

USE RetailSalesDB;
GO

PRINT 'RetailSalesDB created successfully.';
GO