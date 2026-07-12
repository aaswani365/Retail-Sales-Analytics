/*============================================================
Project     : Retail Sales Analytics & Inventory Management System
Database    : RetailSalesDB
File Name   : 06_Generate_Master_Data.sql
Author      : Akshay Aswani
Version     : 1.0
Description : Inserts sample data into all master tables.
============================================================*/

USE RetailSalesDB;
GO

PRINT 'Starting Master Data Generation...';
GO

------------------------------------------------------------
-- SECTION 1 : Store
------------------------------------------------------------

ALTER TABLE dbo.Store
ADD CONSTRAINT FK_Store_Manager
FOREIGN KEY (ManagerEmployeeID)
REFERENCES dbo.Employee(EmployeeID);

PRINT 'Inserting Store Data...';
GO

SET IDENTITY_INSERT dbo.Store ON;

INSERT INTO dbo.Store
(
    StoreID,
    StoreName,
    ManagerEmployeeID,
    Address,
    City,
    State,
    PostalCode,
    Country,
    Phone,
    IsActive,
    CreatedDate,
    ModifiedDate
)
VALUES

(1,'Jaipur Central',NULL,'MI Road','Jaipur','Rajasthan','302001','India','0141-4501001',1,SYSDATETIME(),NULL),
(2,'Jaipur Malviya Nagar',NULL,'Malviya Nagar','Jaipur','Rajasthan','302017','India','0141-4501002',1,SYSDATETIME(),NULL),
(3,'Delhi Connaught Place',NULL,'Connaught Place','New Delhi','Delhi','110001','India','011-4501003',1,SYSDATETIME(),NULL),
(4,'Gurugram Cyber City',NULL,'Cyber City','Gurugram','Haryana','122002','India','0124-4501004',1,SYSDATETIME(),NULL),
(5,'Noida Sector 18',NULL,'Sector 18','Noida','Uttar Pradesh','201301','India','0120-4501005',1,SYSDATETIME(),NULL),

(6,'Mumbai Andheri',NULL,'Andheri West','Mumbai','Maharashtra','400053','India','022-4501006',1,SYSDATETIME(),NULL),
(7,'Mumbai Powai',NULL,'Powai','Mumbai','Maharashtra','400076','India','022-4501007',1,SYSDATETIME(),NULL),
(8,'Pune Hinjewadi',NULL,'Hinjewadi Phase 1','Pune','Maharashtra','411057','India','020-4501008',1,SYSDATETIME(),NULL),
(9,'Ahmedabad SG Highway',NULL,'SG Highway','Ahmedabad','Gujarat','380015','India','079-4501009',1,SYSDATETIME(),NULL),
(10,'Surat City Centre',NULL,'City Light Road','Surat','Gujarat','395007','India','0261-4501010',1,SYSDATETIME(),NULL),

(11,'Indore Vijay Nagar',NULL,'Vijay Nagar','Indore','Madhya Pradesh','452010','India','0731-4501011',1,SYSDATETIME(),NULL),
(12,'Bhopal MP Nagar',NULL,'MP Nagar','Bhopal','Madhya Pradesh','462011','India','0755-4501012',1,SYSDATETIME(),NULL),
(13,'Lucknow Hazratganj',NULL,'Hazratganj','Lucknow','Uttar Pradesh','226001','India','0522-4501013',1,SYSDATETIME(),NULL),
(14,'Chandigarh Sector 17',NULL,'Sector 17','Chandigarh','Chandigarh','160017','India','0172-4501014',1,SYSDATETIME(),NULL),
(15,'Ludhiana Ferozepur Road',NULL,'Ferozepur Road','Ludhiana','Punjab','141001','India','0161-4501015',1,SYSDATETIME(),NULL),

(16,'Hyderabad Hitech City',NULL,'Hitech City','Hyderabad','Telangana','500081','India','040-4501016',1,SYSDATETIME(),NULL),
(17,'Bengaluru Whitefield',NULL,'Whitefield','Bengaluru','Karnataka','560066','India','080-4501017',1,SYSDATETIME(),NULL),
(18,'Chennai OMR',NULL,'Old Mahabalipuram Road','Chennai','Tamil Nadu','600096','India','044-4501018',1,SYSDATETIME(),NULL),
(19,'Kolkata Salt Lake',NULL,'Salt Lake Sector V','Kolkata','West Bengal','700091','India','033-4501019',1,SYSDATETIME(),NULL),
(20,'Bhubaneswar Patia',NULL,'Patia','Bhubaneswar','Odisha','751024','India','0674-4501020',1,SYSDATETIME(),NULL);

SET IDENTITY_INSERT dbo.Store OFF;
GO

PRINT 'Store data inserted successfully.';
GO

------------------------------------------------------------
-- SECTION 2 : Employee
------------------------------------------------------------

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Manager
FOREIGN KEY (ManagerEmployeeID)
REFERENCES dbo.Employee(EmployeeID);

PRINT 'Inserting Employee Data...';
GO

SET IDENTITY_INSERT dbo.Employee ON;

INSERT INTO dbo.Employee
(
    EmployeeID,
    StoreID,
    ManagerEmployeeID,
    FirstName,
    LastName,
    Email,
    Phone,
    JobTitle,
    Salary,
    HireDate,
    IsActive,
    CreatedDate,
    ModifiedDate
)
VALUES

------------------------------------------------------------
-- Store 1
------------------------------------------------------------

(1,1,NULL,'Aarav','Sharma','aarav.sharma@retailsales.com','9876500001','Store Manager',85000,'2021-01-15',1,SYSDATETIME(),NULL),
(2,1,1,'Priya','Verma','priya.verma@retailsales.com','9876500002','Assistant Manager',60000,'2022-03-10',1,SYSDATETIME(),NULL),
(3,1,2,'Rahul','Gupta','rahul.gupta@retailsales.com','9876500003','Inventory Executive',38000,'2023-02-18',1,SYSDATETIME(),NULL),
(4,1,2,'Neha','Singh','neha.singh@retailsales.com','9876500004','Cashier',28000,'2024-05-22',1,SYSDATETIME(),NULL),
(5,1,2,'Mohit','Jain','mohit.jain@retailsales.com','9876500005','Sales Executive',32000,'2025-01-11',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 2
------------------------------------------------------------

(6,2,NULL,'Rohit','Mehta','rohit.mehta@retailsales.com','9876500006','Store Manager',85000,'2021-02-08',1,SYSDATETIME(),NULL),
(7,2,6,'Sneha','Kapoor','sneha.kapoor@retailsales.com','9876500007','Assistant Manager',60000,'2022-04-16',1,SYSDATETIME(),NULL),
(8,2,7,'Aman','Agarwal','aman.agarwal@retailsales.com','9876500008','Inventory Executive',38000,'2023-06-20',1,SYSDATETIME(),NULL),
(9,2,7,'Riya','Sharma','riya.sharma@retailsales.com','9876500009','Cashier',28000,'2024-03-05',1,SYSDATETIME(),NULL),
(10,2,7,'Karan','Verma','karan.verma@retailsales.com','9876500010','Sales Executive',32000,'2025-02-12',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 3
------------------------------------------------------------

(11,3,NULL,'Vivek','Gupta','vivek.gupta@retailsales.com','9876500011','Store Manager',85000,'2021-03-12',1,SYSDATETIME(),NULL),
(12,3,11,'Ananya','Jain','ananya.jain@retailsales.com','9876500012','Assistant Manager',60000,'2022-05-25',1,SYSDATETIME(),NULL),
(13,3,12,'Aditya','Singh','aditya.singh@retailsales.com','9876500013','Inventory Executive',38000,'2023-07-08',1,SYSDATETIME(),NULL),
(14,3,12,'Pooja','Mehta','pooja.mehta@retailsales.com','9876500014','Cashier',28000,'2024-02-14',1,SYSDATETIME(),NULL),
(15,3,12,'Nikhil','Kapoor','nikhil.kapoor@retailsales.com','9876500015','Sales Executive',32000,'2025-03-21',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 4
------------------------------------------------------------

(16,4,NULL,'Sandeep','Arora','sandeep.arora@retailsales.com','9876500016','Store Manager',85000,'2021-04-11',1,SYSDATETIME(),NULL),
(17,4,16,'Kavya','Gupta','kavya.gupta@retailsales.com','9876500017','Assistant Manager',60000,'2022-06-19',1,SYSDATETIME(),NULL),
(18,4,17,'Deepak','Sharma','deepak.sharma@retailsales.com','9876500018','Inventory Executive',38000,'2023-08-02',1,SYSDATETIME(),NULL),
(19,4,17,'Simran','Kaur','simran.kaur@retailsales.com','9876500019','Cashier',28000,'2024-04-28',1,SYSDATETIME(),NULL),
(20,4,17,'Harsh','Verma','harsh.verma@retailsales.com','9876500020','Sales Executive',32000,'2025-04-10',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 5
------------------------------------------------------------

(21,5,NULL,'Abhishek','Malhotra','abhishek.malhotra@retailsales.com','9876500021','Store Manager',85000,'2021-05-07',1,SYSDATETIME(),NULL),
(22,5,21,'Ishita','Sharma','ishita.sharma@retailsales.com','9876500022','Assistant Manager',60000,'2022-07-13',1,SYSDATETIME(),NULL),
(23,5,22,'Yash','Gupta','yash.gupta@retailsales.com','9876500023','Inventory Executive',38000,'2023-09-15',1,SYSDATETIME(),NULL),
(24,5,22,'Megha','Jain','megha.jain@retailsales.com','9876500024','Cashier',28000,'2024-06-03',1,SYSDATETIME(),NULL),
(25,5,22,'Arjun','Singh','arjun.singh@retailsales.com','9876500025','Sales Executive',32000,'2025-05-17',1,SYSDATETIME(),NULL);

------------------------------------------------------------

PRINT 'Employee data for Stores 1-5 inserted successfully.';
GO

------------------------------------------------------------
-- Store 6
------------------------------------------------------------

(26,6,NULL,'Rakesh','Sharma','rakesh.sharma@retailsales.com','9876500026','Store Manager',85000,'2021-06-10',1,SYSDATETIME(),NULL),
(27,6,26,'Nisha','Verma','nisha.verma@retailsales.com','9876500027','Assistant Manager',60000,'2022-08-14',1,SYSDATETIME(),NULL),
(28,6,27,'Saurabh','Gupta','saurabh.gupta@retailsales.com','9876500028','Inventory Executive',38000,'2023-01-19',1,SYSDATETIME(),NULL),
(29,6,27,'Komal','Singh','komal.singh@retailsales.com','9876500029','Cashier',28000,'2024-07-05',1,SYSDATETIME(),NULL),
(30,6,27,'Varun','Jain','varun.jain@retailsales.com','9876500030','Sales Executive',32000,'2025-06-09',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 7
------------------------------------------------------------

(31,7,NULL,'Ankit','Mehta','ankit.mehta@retailsales.com','9876500031','Store Manager',85000,'2021-07-15',1,SYSDATETIME(),NULL),
(32,7,31,'Pallavi','Kapoor','pallavi.kapoor@retailsales.com','9876500032','Assistant Manager',60000,'2022-09-11',1,SYSDATETIME(),NULL),
(33,7,32,'Gaurav','Agarwal','gaurav.agarwal@retailsales.com','9876500033','Inventory Executive',38000,'2023-03-22',1,SYSDATETIME(),NULL),
(34,7,32,'Ruchi','Sharma','ruchi.sharma@retailsales.com','9876500034','Cashier',28000,'2024-08-16',1,SYSDATETIME(),NULL),
(35,7,32,'Manish','Verma','manish.verma@retailsales.com','9876500035','Sales Executive',32000,'2025-02-28',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 8
------------------------------------------------------------

(36,8,NULL,'Sunil','Gupta','sunil.gupta@retailsales.com','9876500036','Store Manager',85000,'2021-08-09',1,SYSDATETIME(),NULL),
(37,8,36,'Shreya','Jain','shreya.jain@retailsales.com','9876500037','Assistant Manager',60000,'2022-10-04',1,SYSDATETIME(),NULL),
(38,8,37,'Hemant','Singh','hemant.singh@retailsales.com','9876500038','Inventory Executive',38000,'2023-05-14',1,SYSDATETIME(),NULL),
(39,8,37,'Aarti','Mehta','aarti.mehta@retailsales.com','9876500039','Cashier',28000,'2024-01-30',1,SYSDATETIME(),NULL),
(40,8,37,'Nitin','Kapoor','nitin.kapoor@retailsales.com','9876500040','Sales Executive',32000,'2025-07-12',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 9
------------------------------------------------------------

(41,9,NULL,'Ashish','Arora','ashish.arora@retailsales.com','9876500041','Store Manager',85000,'2021-09-21',1,SYSDATETIME(),NULL),
(42,9,41,'Divya','Gupta','divya.gupta@retailsales.com','9876500042','Assistant Manager',60000,'2022-11-17',1,SYSDATETIME(),NULL),
(43,9,42,'Kunal','Sharma','kunal.sharma@retailsales.com','9876500043','Inventory Executive',38000,'2023-06-11',1,SYSDATETIME(),NULL),
(44,9,42,'Sonal','Kaur','sonal.kaur@retailsales.com','9876500044','Cashier',28000,'2024-09-08',1,SYSDATETIME(),NULL),
(45,9,42,'Prateek','Verma','prateek.verma@retailsales.com','9876500045','Sales Executive',32000,'2025-03-26',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 10
------------------------------------------------------------

(46,10,NULL,'Lokesh','Malhotra','lokesh.malhotra@retailsales.com','9876500046','Store Manager',85000,'2021-10-12',1,SYSDATETIME(),NULL),
(47,10,46,'Tanvi','Sharma','tanvi.sharma@retailsales.com','9876500047','Assistant Manager',60000,'2022-12-09',1,SYSDATETIME(),NULL),
(48,10,47,'Sachin','Gupta','sachin.gupta@retailsales.com','9876500048','Inventory Executive',38000,'2023-07-27',1,SYSDATETIME(),NULL),
(49,10,47,'Bhavna','Jain','bhavna.jain@retailsales.com','9876500049','Cashier',28000,'2024-10-15',1,SYSDATETIME(),NULL),
(50,10,47,'Ayush','Singh','ayush.singh@retailsales.com','9876500050','Sales Executive',32000,'2025-04-19',1,SYSDATETIME(),NULL);

PRINT 'Employee data for Stores 6-10 inserted successfully.';
GO

------------------------------------------------------------
-- Store 11
------------------------------------------------------------

(51,11,NULL,'Vikas','Sharma','vikas.sharma@retailsales.com','9876500051','Store Manager',85000,'2021-11-08',1,SYSDATETIME(),NULL),
(52,11,51,'Pooja','Gupta','pooja.gupta@retailsales.com','9876500052','Assistant Manager',60000,'2022-01-18',1,SYSDATETIME(),NULL),
(53,11,52,'Rohit','Verma','rohit.verma@retailsales.com','9876500053','Inventory Executive',38000,'2023-02-09',1,SYSDATETIME(),NULL),
(54,11,52,'Neha','Kapoor','neha.kapoor@retailsales.com','9876500054','Cashier',28000,'2024-03-21',1,SYSDATETIME(),NULL),
(55,11,52,'Arpit','Singh','arpit.singh@retailsales.com','9876500055','Sales Executive',32000,'2025-05-11',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 12
------------------------------------------------------------

(56,12,NULL,'Naveen','Jain','naveen.jain@retailsales.com','9876500056','Store Manager',85000,'2021-12-12',1,SYSDATETIME(),NULL),
(57,12,56,'Anjali','Sharma','anjali.sharma@retailsales.com','9876500057','Assistant Manager',60000,'2022-02-15',1,SYSDATETIME(),NULL),
(58,12,57,'Sumit','Gupta','sumit.gupta@retailsales.com','9876500058','Inventory Executive',38000,'2023-03-17',1,SYSDATETIME(),NULL),
(59,12,57,'Ritika','Mehta','ritika.mehta@retailsales.com','9876500059','Cashier',28000,'2024-06-10',1,SYSDATETIME(),NULL),
(60,12,57,'Kush','Agarwal','kush.agarwal@retailsales.com','9876500060','Sales Executive',32000,'2025-01-22',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 13
------------------------------------------------------------

(61,13,NULL,'Deepak','Verma','deepak.verma@retailsales.com','9876500061','Store Manager',85000,'2021-08-18',1,SYSDATETIME(),NULL),
(62,13,61,'Sneha','Singh','sneha.singh@retailsales.com','9876500062','Assistant Manager',60000,'2022-09-24',1,SYSDATETIME(),NULL),
(63,13,62,'Harshit','Kapoor','harshit.kapoor@retailsales.com','9876500063','Inventory Executive',38000,'2023-04-14',1,SYSDATETIME(),NULL),
(64,13,62,'Muskan','Jain','muskan.jain@retailsales.com','9876500064','Cashier',28000,'2024-07-09',1,SYSDATETIME(),NULL),
(65,13,62,'Akash','Sharma','akash.sharma@retailsales.com','9876500065','Sales Executive',32000,'2025-03-02',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 14
------------------------------------------------------------

(66,14,NULL,'Tarun','Mehta','tarun.mehta@retailsales.com','9876500066','Store Manager',85000,'2021-05-28',1,SYSDATETIME(),NULL),
(67,14,66,'Isha','Gupta','isha.gupta@retailsales.com','9876500067','Assistant Manager',60000,'2022-07-12',1,SYSDATETIME(),NULL),
(68,14,67,'Nitin','Arora','nitin.arora@retailsales.com','9876500068','Inventory Executive',38000,'2023-06-06',1,SYSDATETIME(),NULL),
(69,14,67,'Rashmi','Verma','rashmi.verma@retailsales.com','9876500069','Cashier',28000,'2024-08-13',1,SYSDATETIME(),NULL),
(70,14,67,'Yogesh','Singh','yogesh.singh@retailsales.com','9876500070','Sales Executive',32000,'2025-06-01',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 15
------------------------------------------------------------

(71,15,NULL,'Sanjay','Malhotra','sanjay.malhotra@retailsales.com','9876500071','Store Manager',85000,'2021-04-09',1,SYSDATETIME(),NULL),
(72,15,71,'Komal','Kapoor','komal.kapoor@retailsales.com','9876500072','Assistant Manager',60000,'2022-06-21',1,SYSDATETIME(),NULL),
(73,15,72,'Mayank','Gupta','mayank.gupta@retailsales.com','9876500073','Inventory Executive',38000,'2023-08-11',1,SYSDATETIME(),NULL),
(74,15,72,'Shweta','Sharma','shweta.sharma@retailsales.com','9876500074','Cashier',28000,'2024-09-18',1,SYSDATETIME(),NULL),
(75,15,72,'Kartik','Jain','kartik.jain@retailsales.com','9876500075','Sales Executive',32000,'2025-07-08',1,SYSDATETIME(),NULL);

PRINT 'Employee data for Stores 11-15 inserted successfully.';
GO

------------------------------------------------------------
-- Store 16
------------------------------------------------------------

(76,16,NULL,'Amit','Sharma','amit.sharma@retailsales.com','9876500076','Store Manager',85000,'2021-02-16',1,SYSDATETIME(),NULL),
(77,16,76,'Nidhi','Gupta','nidhi.gupta@retailsales.com','9876500077','Assistant Manager',60000,'2022-03-28',1,SYSDATETIME(),NULL),
(78,16,77,'Rahul','Kapoor','rahul.kapoor@retailsales.com','9876500078','Inventory Executive',38000,'2023-05-03',1,SYSDATETIME(),NULL),
(79,16,77,'Priyanka','Verma','priyanka.verma@retailsales.com','9876500079','Cashier',28000,'2024-02-11',1,SYSDATETIME(),NULL),
(80,16,77,'Vishal','Jain','vishal.jain@retailsales.com','9876500080','Sales Executive',32000,'2025-04-23',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 17
------------------------------------------------------------

(81,17,NULL,'Rajat','Singh','rajat.singh@retailsales.com','9876500081','Store Manager',85000,'2021-06-21',1,SYSDATETIME(),NULL),
(82,17,81,'Meenakshi','Sharma','meenakshi.sharma@retailsales.com','9876500082','Assistant Manager',60000,'2022-07-19',1,SYSDATETIME(),NULL),
(83,17,82,'Anurag','Gupta','anurag.gupta@retailsales.com','9876500083','Inventory Executive',38000,'2023-09-07',1,SYSDATETIME(),NULL),
(84,17,82,'Pallavi','Jain','pallavi.jain@retailsales.com','9876500084','Cashier',28000,'2024-05-15',1,SYSDATETIME(),NULL),
(85,17,82,'Rohan','Mehta','rohan.mehta@retailsales.com','9876500085','Sales Executive',32000,'2025-02-27',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 18
------------------------------------------------------------

(86,18,NULL,'Manoj','Agarwal','manoj.agarwal@retailsales.com','9876500086','Store Manager',85000,'2021-09-14',1,SYSDATETIME(),NULL),
(87,18,86,'Riya','Kapoor','riya.kapoor@retailsales.com','9876500087','Assistant Manager',60000,'2022-10-09',1,SYSDATETIME(),NULL),
(88,18,87,'Sachin','Verma','sachin.verma@retailsales.com','9876500088','Inventory Executive',38000,'2023-11-18',1,SYSDATETIME(),NULL),
(89,18,87,'Ankita','Singh','ankita.singh@retailsales.com','9876500089','Cashier',28000,'2024-07-20',1,SYSDATETIME(),NULL),
(90,18,87,'Harsh','Sharma','harsh.sharma@retailsales.com','9876500090','Sales Executive',32000,'2025-06-14',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 19
------------------------------------------------------------

(91,19,NULL,'Sumit','Malhotra','sumit.malhotra@retailsales.com','9876500091','Store Manager',85000,'2021-03-25',1,SYSDATETIME(),NULL),
(92,19,91,'Kritika','Gupta','kritika.gupta@retailsales.com','9876500092','Assistant Manager',60000,'2022-05-12',1,SYSDATETIME(),NULL),
(93,19,92,'Abhinav','Jain','abhinav.jain@retailsales.com','9876500093','Inventory Executive',38000,'2023-06-29',1,SYSDATETIME(),NULL),
(94,19,92,'Sakshi','Mehta','sakshi.mehta@retailsales.com','9876500094','Cashier',28000,'2024-08-24',1,SYSDATETIME(),NULL),
(95,19,92,'Yash','Kapoor','yash.kapoor@retailsales.com','9876500095','Sales Executive',32000,'2025-05-06',1,SYSDATETIME(),NULL),

------------------------------------------------------------
-- Store 20
------------------------------------------------------------

(96,20,NULL,'Ashok','Verma','ashok.verma@retailsales.com','9876500096','Store Manager',85000,'2021-08-04',1,SYSDATETIME(),NULL),
(97,20,96,'Divya','Sharma','divya.sharma@retailsales.com','9876500097','Assistant Manager',60000,'2022-09-23',1,SYSDATETIME(),NULL),
(98,20,97,'Kamal','Gupta','kamal.gupta@retailsales.com','9876500098','Inventory Executive',38000,'2023-10-10',1,SYSDATETIME(),NULL),
(99,20,97,'Monika','Jain','monika.jain@retailsales.com','9876500099','Cashier',28000,'2024-11-01',1,SYSDATETIME(),NULL),
(100,20,97,'Naveen','Singh','naveen.singh@retailsales.com','9876500100','Sales Executive',32000,'2025-07-15',1,SYSDATETIME(),NULL);

SET IDENTITY_INSERT dbo.Employee OFF;
GO

PRINT 'Employee data inserted successfully.';
GO


------------------------------------------------------------
-- Update Store Managers
------------------------------------------------------------

UPDATE dbo.Store SET ManagerEmployeeID = 1  WHERE StoreID = 1;
UPDATE dbo.Store SET ManagerEmployeeID = 6  WHERE StoreID = 2;
UPDATE dbo.Store SET ManagerEmployeeID = 11 WHERE StoreID = 3;
UPDATE dbo.Store SET ManagerEmployeeID = 16 WHERE StoreID = 4;
UPDATE dbo.Store SET ManagerEmployeeID = 21 WHERE StoreID = 5;

UPDATE dbo.Store SET ManagerEmployeeID = 26 WHERE StoreID = 6;
UPDATE dbo.Store SET ManagerEmployeeID = 31 WHERE StoreID = 7;
UPDATE dbo.Store SET ManagerEmployeeID = 36 WHERE StoreID = 8;
UPDATE dbo.Store SET ManagerEmployeeID = 41 WHERE StoreID = 9;
UPDATE dbo.Store SET ManagerEmployeeID = 46 WHERE StoreID = 10;

UPDATE dbo.Store SET ManagerEmployeeID = 51 WHERE StoreID = 11;
UPDATE dbo.Store SET ManagerEmployeeID = 56 WHERE StoreID = 12;
UPDATE dbo.Store SET ManagerEmployeeID = 61 WHERE StoreID = 13;
UPDATE dbo.Store SET ManagerEmployeeID = 66 WHERE StoreID = 14;
UPDATE dbo.Store SET ManagerEmployeeID = 71 WHERE StoreID = 15;

UPDATE dbo.Store SET ManagerEmployeeID = 76 WHERE StoreID = 16;
UPDATE dbo.Store SET ManagerEmployeeID = 81 WHERE StoreID = 17;
UPDATE dbo.Store SET ManagerEmployeeID = 86 WHERE StoreID = 18;
UPDATE dbo.Store SET ManagerEmployeeID = 91 WHERE StoreID = 19;
UPDATE dbo.Store SET ManagerEmployeeID = 96 WHERE StoreID = 20;

PRINT 'Store managers updated successfully.';
GO

/*============================================================
SECTION 3 : CUSTOMER
Description : Lookup Tables
============================================================*/

PRINT 'Preparing Customer Lookup Tables...';

SET NOCOUNT ON;

------------------------------------------------------------
-- First Name Lookup
------------------------------------------------------------

DECLARE @FirstNames TABLE
(
    FirstNameID INT PRIMARY KEY,
    FirstName VARCHAR(50)
);

INSERT INTO @FirstNames
VALUES
(1,'Aarav'),
(2,'Vivaan'),
(3,'Aditya'),
(4,'Vihaan'),
(5,'Arjun'),
(6,'Sai'),
(7,'Krishna'),
(8,'Rahul'),
(9,'Rohan'),
(10,'Mohit'),
(11,'Karan'),
(12,'Aman'),
(13,'Akash'),
(14,'Vikas'),
(15,'Sandeep'),
(16,'Rakesh'),
(17,'Deepak'),
(18,'Nitin'),
(19,'Rajat'),
(20,'Harsh'),
(21,'Yash'),
(22,'Mayank'),
(23,'Manish'),
(24,'Abhishek'),
(25,'Naveen'),
(26,'Tarun'),
(27,'Ankit'),
(28,'Pankaj'),
(29,'Rohit'),
(30,'Sachin'),
(31,'Priya'),
(32,'Ananya'),
(33,'Sneha'),
(34,'Pooja'),
(35,'Neha'),
(36,'Kavya'),
(37,'Riya'),
(38,'Anjali'),
(39,'Simran'),
(40,'Nidhi'),
(41,'Shreya'),
(42,'Muskan'),
(43,'Komal'),
(44,'Ritika'),
(45,'Ishita'),
(46,'Divya'),
(47,'Megha'),
(48,'Swati'),
(49,'Aarti'),
(50,'Monika');

------------------------------------------------------------
-- Last Name Lookup
------------------------------------------------------------

DECLARE @LastNames TABLE
(
    LastNameID INT PRIMARY KEY,
    LastName VARCHAR(50)
);

INSERT INTO @LastNames
VALUES
(1,'Sharma'),
(2,'Verma'),
(3,'Gupta'),
(4,'Singh'),
(5,'Jain'),
(6,'Agarwal'),
(7,'Kapoor'),
(8,'Mehta'),
(9,'Malhotra'),
(10,'Arora'),
(11,'Bansal'),
(12,'Mittal'),
(13,'Goyal'),
(14,'Mathur'),
(15,'Joshi'),
(16,'Choudhary'),
(17,'Saxena'),
(18,'Khanna'),
(19,'Srivastava'),
(20,'Pandey'),
(21,'Mishra'),
(22,'Yadav'),
(23,'Patel'),
(24,'Shah'),
(25,'Reddy'),
(26,'Nair'),
(27,'Iyer'),
(28,'Kulkarni'),
(29,'Deshmukh'),
(30,'Pillai');

------------------------------------------------------------
-- City Lookup
------------------------------------------------------------

DECLARE @Cities TABLE
(
    CityID INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20)
);

INSERT INTO @Cities
VALUES
(1,'Jaipur','Rajasthan','302001'),
(2,'Jodhpur','Rajasthan','342001'),
(3,'Udaipur','Rajasthan','313001'),
(4,'Delhi','Delhi','110001'),
(5,'Gurugram','Haryana','122001'),
(6,'Noida','Uttar Pradesh','201301'),
(7,'Lucknow','Uttar Pradesh','226001'),
(8,'Ahmedabad','Gujarat','380001'),
(9,'Surat','Gujarat','395001'),
(10,'Mumbai','Maharashtra','400001'),
(11,'Pune','Maharashtra','411001'),
(12,'Nagpur','Maharashtra','440001'),
(13,'Indore','Madhya Pradesh','452001'),
(14,'Bhopal','Madhya Pradesh','462001'),
(15,'Hyderabad','Telangana','500001'),
(16,'Bengaluru','Karnataka','560001'),
(17,'Chennai','Tamil Nadu','600001'),
(18,'Kolkata','West Bengal','700001'),
(19,'Chandigarh','Chandigarh','160017'),
(20,'Bhubaneswar','Odisha','751001');

PRINT 'Customer lookup tables created successfully.';

------------------------------------------------------------
-- Generate Customer Dataset
------------------------------------------------------------

;WITH Numbers AS
(
    SELECT TOP (500)
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS CustomerNumber
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
),

CustomerData AS
(
    SELECT

        N.CustomerNumber,

        FN.FirstName,

        LN.LastName,

        C.City,

        C.State,

        C.PostalCode,

        CONCAT
        (
            ((N.CustomerNumber * 17) % 999) + 1,
            ' Main Street'
        ) AS Address,

        CONCAT
        (
            LOWER(FN.FirstName),
            '.',
            LOWER(LN.LastName),
            N.CustomerNumber,
            '@gmail.com'
        ) AS Email,

        CONCAT
        (
            '900',
            FORMAT(N.CustomerNumber,'0000000')
        ) AS Phone,

        DATEADD
        (
            DAY,
            -((N.CustomerNumber * 13) % 2500),
            CAST(GETDATE() AS DATE)
        ) AS RegistrationDate,

        CASE
            WHEN (N.CustomerNumber % 20) = 0
            THEN 0
            ELSE 1
        END AS IsActive,

        (N.CustomerNumber * 137) % 5001
        AS LoyaltyPoints

    FROM Numbers N

    INNER JOIN @FirstNames FN
        ON FN.FirstNameID =
           ((N.CustomerNumber - 1) % 50) + 1

    INNER JOIN @LastNames LN
        ON LN.LastNameID =
           ((N.CustomerNumber - 1) % 30) + 1

    INNER JOIN @Cities C
        ON C.CityID =
           ((N.CustomerNumber - 1) % 20) + 1
)

------------------------------------------------------------
-- Insert Customer Data
------------------------------------------------------------

INSERT INTO dbo.Customer
(
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    PostalCode,
    Country,
    RegistrationDate,
    IsActive,
    CreatedDate,
    ModifiedDate,
    LoyaltyPoints
)
SELECT
    FirstName,
    LastName,
    Email,
    Phone,
    Address,
    City,
    State,
    PostalCode,
    'India',
    RegistrationDate,
    IsActive,
    SYSDATETIME(),
    NULL,
    LoyaltyPoints
FROM CustomerData;

PRINT 'Customer data inserted successfully.';


------------------------------------------------------------
-- Customer Data Validation
------------------------------------------------------------

PRINT 'Validating Customer Data...';

------------------------------------------------------------
-- Total Customers
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalCustomers
FROM dbo.Customer;

------------------------------------------------------------
-- Active vs Inactive Customers
------------------------------------------------------------

SELECT
    IsActive,
    COUNT(*) AS CustomerCount
FROM dbo.Customer
GROUP BY IsActive;

------------------------------------------------------------
-- Duplicate Email Check
------------------------------------------------------------

SELECT
    Email,
    COUNT(*) AS DuplicateCount
FROM dbo.Customer
GROUP BY Email
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Duplicate Phone Check
------------------------------------------------------------

SELECT
    Phone,
    COUNT(*) AS DuplicateCount
FROM dbo.Customer
GROUP BY Phone
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Customers by State
------------------------------------------------------------

SELECT
    State,
    COUNT(*) AS TotalCustomers
FROM dbo.Customer
GROUP BY State
ORDER BY TotalCustomers DESC,
         State;

------------------------------------------------------------
-- Customers by City
------------------------------------------------------------

SELECT
    City,
    COUNT(*) AS TotalCustomers
FROM dbo.Customer
GROUP BY City
ORDER BY TotalCustomers DESC,
         City;

------------------------------------------------------------
-- Loyalty Points Summary
------------------------------------------------------------

SELECT
    MIN(LoyaltyPoints) AS MinimumPoints,
    MAX(LoyaltyPoints) AS MaximumPoints,
    AVG(CAST(LoyaltyPoints AS DECIMAL(10,2))) AS AveragePoints
FROM dbo.Customer;

------------------------------------------------------------
-- Registration Date Range
------------------------------------------------------------

SELECT
    MIN(RegistrationDate) AS EarliestRegistration,
    MAX(RegistrationDate) AS LatestRegistration
FROM dbo.Customer;

------------------------------------------------------------
-- Sample Customer Records
------------------------------------------------------------

SELECT TOP (20)
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    City,
    State,
    RegistrationDate,
    LoyaltyPoints,
    IsActive
FROM dbo.Customer
ORDER BY CustomerID;

------------------------------------------------------------
-- Customers Registered Per Year
------------------------------------------------------------

SELECT
    YEAR(RegistrationDate) AS RegistrationYear,
    COUNT(*) AS TotalCustomers
FROM dbo.Customer
GROUP BY YEAR(RegistrationDate)
ORDER BY RegistrationYear;

------------------------------------------------------------
-- Top 10 Customers by Loyalty Points
------------------------------------------------------------

SELECT TOP (10)
    CustomerID,
    FirstName,
    LastName,
    LoyaltyPoints
FROM dbo.Customer
ORDER BY LoyaltyPoints DESC,
         CustomerID;

PRINT 'Customer data validation completed successfully.';
PRINT 'Customer data inserted successfully.';
GO

------------------------------------------------------------
-- SECTION 4 : Supplier
------------------------------------------------------------

/*============================================================
SECTION 4 : SUPPLIER
Description : Supplier Lookup Tables
============================================================*/

PRINT 'Preparing Supplier Lookup Tables...';

SET NOCOUNT ON;

------------------------------------------------------------
-- Supplier Name Lookup
------------------------------------------------------------

DECLARE @SupplierNames TABLE
(
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(150)
);

INSERT INTO @SupplierNames
VALUES
(1,'TechNova Electronics'),
(2,'Prime Mobile Distributors'),
(3,'Global Computer Supplies'),
(4,'Digital World Technologies'),
(5,'Fresh Harvest Foods'),
(6,'Nature Fresh Grocery'),
(7,'Pure Dairy Products'),
(8,'Golden Bakery Supplies'),
(9,'Healthy Choice Foods'),
(10,'Evergreen Beverages'),
(11,'Spark Personal Care'),
(12,'Clean Home Essentials'),
(13,'Fashion Hub Distributors'),
(14,'Elite Apparel Suppliers'),
(15,'Classic Footwear Pvt Ltd'),
(16,'Comfort Shoes India'),
(17,'Royal Furniture House'),
(18,'Modern Living Furniture'),
(19,'Office Stationery World'),
(20,'Smart Office Supplies'),
(21,'Happy Kids Toys'),
(22,'Champion Sports Goods'),
(23,'Kitchen King Products'),
(24,'Home Appliance Solutions'),
(25,'Bright Lighting India'),
(26,'Urban Lifestyle Products'),
(27,'Fresh Farm Organics'),
(28,'Green Valley Foods'),
(29,'Metro Electronics'),
(30,'Infinity Gadgets'),
(31,'National FMCG Suppliers'),
(32,'Crystal Household Products'),
(33,'Premium Fashion House'),
(34,'Lifestyle Brands India'),
(35,'City Furniture Mart'),
(36,'Supreme Kitchenware'),
(37,'Max Office Solutions'),
(38,'Quick Supply Chain'),
(39,'Reliable Wholesale Traders'),
(40,'Vision Retail Supplies'),
(41,'Future Consumer Products'),
(42,'Smart Retail Distributors'),
(43,'Universal Trading Company'),
(44,'Perfect Home Products'),
(45,'BlueSky Enterprises'),
(46,'NextGen Distributors'),
(47,'ValueMart Wholesale'),
(48,'Elite Retail Partners'),
(49,'Quality Supply Co.'),
(50,'Retail Connect India');

------------------------------------------------------------
-- Contact Person Lookup
------------------------------------------------------------

DECLARE @ContactNames TABLE
(
    ContactID INT PRIMARY KEY,
    ContactName VARCHAR(100)
);

INSERT INTO @ContactNames
VALUES
(1,'Rajesh Sharma'),
(2,'Amit Verma'),
(3,'Rohit Gupta'),
(4,'Sanjay Singh'),
(5,'Vikas Jain'),
(6,'Deepak Mehta'),
(7,'Ankit Kapoor'),
(8,'Nitin Agarwal'),
(9,'Rahul Arora'),
(10,'Karan Patel'),
(11,'Priya Sharma'),
(12,'Sneha Verma'),
(13,'Ananya Gupta'),
(14,'Neha Singh'),
(15,'Pooja Jain'),
(16,'Ritika Kapoor'),
(17,'Shreya Mehta'),
(18,'Kavya Patel'),
(19,'Muskan Arora'),
(20,'Simran Malhotra');

------------------------------------------------------------
-- City Lookup
------------------------------------------------------------

DECLARE @SupplierCities TABLE
(
    CityID INT PRIMARY KEY,
    City VARCHAR(100),
    State VARCHAR(100),
    PostalCode VARCHAR(20)
);

INSERT INTO @SupplierCities
VALUES
(1,'Jaipur','Rajasthan','302001'),
(2,'Delhi','Delhi','110001'),
(3,'Mumbai','Maharashtra','400001'),
(4,'Pune','Maharashtra','411001'),
(5,'Ahmedabad','Gujarat','380001'),
(6,'Surat','Gujarat','395001'),
(7,'Bengaluru','Karnataka','560001'),
(8,'Hyderabad','Telangana','500001'),
(9,'Chennai','Tamil Nadu','600001'),
(10,'Kolkata','West Bengal','700001');

------------------------------------------------------------
-- Generate Supplier Dataset
------------------------------------------------------------

;WITH Numbers AS
(
    SELECT 1 AS SupplierNumber

    UNION ALL

    SELECT SupplierNumber + 1
    FROM Numbers
    WHERE SupplierNumber < 50
),

SupplierData AS
(
    SELECT

        N.SupplierNumber,

        SN.SupplierName,

        CN.ContactName,

        CONCAT
        (
            ((N.SupplierNumber * 19) % 999) + 1,
            ' Industrial Area'
        ) AS Address,

        SC.City,

        SC.State,

        SC.PostalCode,

        CONCAT
        (
            LOWER(REPLACE(SN.SupplierName,' ',''))
            ,
            '@gmail.com'
        ) AS Email,

        CONCAT
        (
            '910',
            FORMAT(N.SupplierNumber,'0000000')
        ) AS Phone,

        CASE
            WHEN N.SupplierNumber % 20 = 0
            THEN 0
            ELSE 1
        END AS IsActive

    FROM Numbers N

    INNER JOIN @SupplierNames SN
        ON SN.SupplierID = N.SupplierNumber

    INNER JOIN @ContactNames CN
        ON CN.ContactID =
           ((N.SupplierNumber - 1) % 20) + 1

    INNER JOIN @SupplierCities SC
        ON SC.CityID =
           ((N.SupplierNumber - 1) % 10) + 1
)

------------------------------------------------------------
-- Insert Supplier Data
------------------------------------------------------------

INSERT INTO dbo.Supplier
(
    SupplierName,
    ContactName,
    Phone,
    Email,
    Address,
    City,
    State,
    Country,
    PostalCode,
    IsActive,
    CreatedDate,
    ModifiedDate
)
SELECT
    SupplierName,
    ContactName,
    Phone,
    Email,
    Address,
    City,
    State,
    'India',
    PostalCode,
    IsActive,
    SYSDATETIME(),
    NULL
FROM SupplierData

OPTION (MAXRECURSION 50);

PRINT 'Supplier data inserted successfully.';

------------------------------------------------------------
-- Supplier Data Validation
------------------------------------------------------------

PRINT 'Validating Supplier Data...';

------------------------------------------------------------
-- Total Suppliers
------------------------------------------------------------

SELECT
    COUNT(*) AS TotalSuppliers
FROM dbo.Supplier;

------------------------------------------------------------
-- Active vs Inactive Suppliers
------------------------------------------------------------

SELECT
    IsActive,
    COUNT(*) AS SupplierCount
FROM dbo.Supplier
GROUP BY IsActive;

------------------------------------------------------------
-- Duplicate Supplier Name Check
------------------------------------------------------------

SELECT
    SupplierName,
    COUNT(*) AS DuplicateCount
FROM dbo.Supplier
GROUP BY SupplierName
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Duplicate Email Check
------------------------------------------------------------

SELECT
    Email,
    COUNT(*) AS DuplicateCount
FROM dbo.Supplier
GROUP BY Email
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Duplicate Phone Check
------------------------------------------------------------

SELECT
    Phone,
    COUNT(*) AS DuplicateCount
FROM dbo.Supplier
GROUP BY Phone
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- Suppliers by State
------------------------------------------------------------

SELECT
    State,
    COUNT(*) AS TotalSuppliers
FROM dbo.Supplier
GROUP BY State
ORDER BY TotalSuppliers DESC,
         State;

------------------------------------------------------------
-- Suppliers by City
------------------------------------------------------------

SELECT
    City,
    COUNT(*) AS TotalSuppliers
FROM dbo.Supplier
GROUP BY City
ORDER BY TotalSuppliers DESC,
         City;

------------------------------------------------------------
-- Sample Supplier Records
------------------------------------------------------------

SELECT TOP (20)
    SupplierID,
    SupplierName,
    ContactName,
    Phone,
    Email,
    City,
    State,
    Country,
    IsActive
FROM dbo.Supplier
ORDER BY SupplierID;

------------------------------------------------------------
-- Supplier Contact Summary
------------------------------------------------------------

SELECT
    COUNT(ContactName) AS TotalContacts,
    COUNT(Email) AS TotalEmails,
    COUNT(Phone) AS TotalPhoneNumbers
FROM dbo.Supplier;

PRINT 'Supplier data validation completed successfully.';
GO

------------------------------------------------------------
-- SECTION 5 : Product
------------------------------------------------------------

-- INSERT Statements

PRINT 'Product data inserted successfully.';
GO

PRINT 'Master Data Generation Completed Successfully.';
GO