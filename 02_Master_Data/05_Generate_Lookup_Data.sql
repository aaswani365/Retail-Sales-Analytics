/*==============================================================================
Project      : Retail Sales Analytics & Inventory Management System
Database     : RetailSalesDB
File Name    : 05_Generate_Lookup_Data.sql
Author       : Akshay Aswani
Version      : 1.0
Created On   : July 2026
Last Updated : July 2026

Description:
This script populates all lookup tables with predefined business reference
data required for the Retail Sales Analytics & Inventory Management System.

The lookup data provides standardized business values used throughout the
database to ensure consistency, maintain referential integrity, and support
master data generation, transaction processing, reporting, and analytics.

The script includes:
1. Product Categories
2. Product Subcategories
3. Brands
4. Payment Methods
5. Return Reasons
6. Order Statuses
7. Payment Statuses
8. Return Statuses

Features:
- Inserts predefined business reference data
- Maintains referential integrity
- Uses dynamic lookup techniques where required
- Prevents duplicate data generation
- Includes validation after data generation
- Suitable for development, testing, and analytics

Execution Order:
1. Product Categories
2. Product Subcategories
3. Brands
4. Payment Methods
5. Return Reasons
6. Order Statuses
7. Payment Statuses
8. Return Statuses

==============================================================================*/

USE RetailSalesDB;
GO

SET NOCOUNT ON;

/*==============================================================================
					Section 1 : Product Categories
==============================================================================

Description:
------------
Populates the Category lookup table with predefined product categories
used throughout the retail system.

Business Rules:
---------------
- Each category represents a high-level product classification.
- Category names must be unique.
- Categories are referenced by the SubCategory table.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.Category)
BEGIN

    INSERT INTO dbo.Category
    (
        CategoryName,
        Description
    )
    VALUES
        ('Electronics',                 'Electronic devices and accessories'),
        ('Computers & Accessories',     'Computers, peripherals, and accessories'),
        ('Mobile Phones',               'Smartphones and mobile accessories'),
        ('Home Appliances',             'Household electrical appliances'),
        ('Fashion',                     'Clothing, footwear, and fashion accessories'),
        ('Furniture',                   'Home and office furniture'),
        ('Sports & Fitness',            'Sports equipment and fitness products'),
        ('Books & Stationery',          'Books, office supplies, and stationery'),
        ('Toys & Games',                'Toys, educational products, and games'),
        ('Health & Personal Care',      'Healthcare and personal care products');

END;

PRINT 'Product Categories generated successfully.';

SELECT
    CategoryID,
    CategoryName,
    Description
FROM dbo.Category
ORDER BY CategoryID;


/*==============================================================================
					Section 2 : Product SubCategories
==============================================================================

Description:
------------
Populates the SubCategory lookup table with predefined product
subcategories.

Business Rules:
---------------
- Each subcategory belongs to exactly one category.
- Subcategory names should be unique within a category.
- CategoryID is retrieved dynamically using CategoryName to avoid
  hardcoding identity values.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.SubCategory)
BEGIN

    /* Electronics */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Televisions', 'LED, OLED, and Smart TVs'
    FROM dbo.Category
    WHERE CategoryName = 'Electronics';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Audio Systems', 'Speakers, soundbars, and home audio'
    FROM dbo.Category
    WHERE CategoryName = 'Electronics';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Cameras', 'Digital cameras and accessories'
    FROM dbo.Category
    WHERE CategoryName = 'Electronics';


    /* Computers & Accessories */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Laptops', 'Business and gaming laptops'
    FROM dbo.Category
    WHERE CategoryName = 'Computers & Accessories';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Monitors', 'Computer monitors and displays'
    FROM dbo.Category
    WHERE CategoryName = 'Computers & Accessories';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Keyboards', 'Mechanical and wireless keyboards'
    FROM dbo.Category
    WHERE CategoryName = 'Computers & Accessories';


    /* Mobile Phones */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Smartphones', 'Android and iOS smartphones'
    FROM dbo.Category
    WHERE CategoryName = 'Mobile Phones';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Chargers', 'Mobile phone chargers'
    FROM dbo.Category
    WHERE CategoryName = 'Mobile Phones';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Phone Cases', 'Protective covers and cases'
    FROM dbo.Category
    WHERE CategoryName = 'Mobile Phones';


    /* Home Appliances */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Refrigerators', 'Single and double door refrigerators'
    FROM dbo.Category
    WHERE CategoryName = 'Home Appliances';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Washing Machines', 'Front and top load washing machines'
    FROM dbo.Category
    WHERE CategoryName = 'Home Appliances';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Microwave Ovens', 'Convection and solo microwave ovens'
    FROM dbo.Category
    WHERE CategoryName = 'Home Appliances';


    /* Fashion */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Men''s Clothing', 'Clothing for men'
    FROM dbo.Category
    WHERE CategoryName = 'Fashion';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Women''s Clothing', 'Clothing for women'
    FROM dbo.Category
    WHERE CategoryName = 'Fashion';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Footwear', 'Shoes, sandals, and sneakers'
    FROM dbo.Category
    WHERE CategoryName = 'Fashion';


    /* Furniture */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Chairs', 'Office and home chairs'
    FROM dbo.Category
    WHERE CategoryName = 'Furniture';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Tables', 'Dining, office, and study tables'
    FROM dbo.Category
    WHERE CategoryName = 'Furniture';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Wardrobes', 'Wooden and modular wardrobes'
    FROM dbo.Category
    WHERE CategoryName = 'Furniture';


    /* Sports & Fitness */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Exercise Equipment', 'Gym and fitness equipment'
    FROM dbo.Category
    WHERE CategoryName = 'Sports & Fitness';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Sportswear', 'Sports clothing and accessories'
    FROM dbo.Category
    WHERE CategoryName = 'Sports & Fitness';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Outdoor Gear', 'Camping and outdoor equipment'
    FROM dbo.Category
    WHERE CategoryName = 'Sports & Fitness';


    /* Books & Stationery */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Books', 'Academic and general books'
    FROM dbo.Category
    WHERE CategoryName = 'Books & Stationery';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Office Supplies', 'Office stationery and supplies'
    FROM dbo.Category
    WHERE CategoryName = 'Books & Stationery';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'School Supplies', 'School stationery and educational materials'
    FROM dbo.Category
    WHERE CategoryName = 'Books & Stationery';


    /* Toys & Games */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Educational Toys', 'Learning and educational toys'
    FROM dbo.Category
    WHERE CategoryName = 'Toys & Games';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Action Figures', 'Character action figures'
    FROM dbo.Category
    WHERE CategoryName = 'Toys & Games';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Board Games', 'Indoor board games'
    FROM dbo.Category
    WHERE CategoryName = 'Toys & Games';


    /* Health & Personal Care */

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Personal Care', 'Daily personal care products'
    FROM dbo.Category
    WHERE CategoryName = 'Health & Personal Care';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Healthcare Devices', 'Medical and healthcare devices'
    FROM dbo.Category
    WHERE CategoryName = 'Health & Personal Care';

    INSERT INTO dbo.SubCategory (CategoryID, SubCategoryName, Description)
    SELECT CategoryID, 'Nutrition Supplements', 'Health and nutrition supplements'
    FROM dbo.Category
    WHERE CategoryName = 'Health & Personal Care';

END;

PRINT 'Product SubCategory generated successfully.';

SELECT count(*) as TotalSubCategory
FROM dbo.SubCategory;

/*==============================================================================
					Section 3 : Brands
==============================================================================

Description:
------------
Populates the Brand lookup table with well-known brands across different
product categories.

Business Rules:
---------------
- Each brand name must be unique.
- Brands are referenced by the Product table.
- CreatedDate is populated automatically using the default constraint.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.Brand)
BEGIN

    INSERT INTO dbo.Brand
    (
        BrandName,
        Description
    )
    VALUES
        ('Apple',       'Consumer electronics and technology products'),
        ('Samsung',     'Electronics, smartphones, and home appliances'),
        ('Sony',        'Consumer electronics and entertainment products'),
        ('Dell',        'Computers and business technology solutions'),
        ('HP',          'Personal computers, printers, and accessories'),
        ('Lenovo',      'Laptops, desktops, and computer accessories'),
        ('ASUS',        'Gaming laptops, motherboards, and peripherals'),
        ('LG',          'Consumer electronics and home appliances'),
        ('Canon',       'Cameras, printers, and imaging solutions'),
        ('Nikon',       'Digital cameras and optical products'),
        ('Boat',        'Audio devices and mobile accessories'),
        ('JBL',         'Speakers, headphones, and audio equipment'),
        ('Logitech',    'Computer peripherals and gaming accessories'),
        ('Microsoft',   'Software, hardware, and gaming products'),
        ('Intel',       'Processors and computer components'),
        ('Nike',        'Sportswear, footwear, and accessories'),
        ('Adidas',      'Sports apparel and footwear'),
        ('Puma',        'Sportswear and lifestyle products'),
        ('Reebok',      'Fitness apparel and footwear'),
        ('Levi''s',     'Denim clothing and fashion apparel'),
        ('Philips',     'Consumer electronics and healthcare products'),
        ('Panasonic',   'Electronics and home appliances'),
        ('Whirlpool',   'Home appliances'),
        ('Bosch',       'Home appliances and power tools'),
        ('IKEA',        'Furniture and home furnishings'),
        ('Casio',       'Watches, calculators, and musical instruments'),
        ('Himalaya',    'Healthcare and personal care products'),
        ('Dove',        'Personal care and skincare products'),
        ('Nestlé',      'Food and beverage products'),
        ('Amul',        'Dairy and food products');

END;

PRINT 'Product Brand generated successfully.';

select count(*) as TotalBrand
from dbo.Brand;


/*==============================================================================
                    Section 4 : Payment Methods
==============================================================================

Description:
------------
Populates the PaymentMethod lookup table with predefined payment methods
accepted across the retail business.

Business Rules:
---------------
- Each payment method represents a valid payment option.
- Payment method names must be unique.
- Payment methods are referenced by the Payment table.
- Payment methods remain static and are managed by the business.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.PaymentMethod)
BEGIN

    INSERT INTO dbo.PaymentMethod
    (
        MethodName,
        Description,
        IsActive
    )
    VALUES
    ('Cash',
     'Payment made using physical currency at the store.',
     1),

    ('Credit Card',
     'Payment processed using a credit card.',
     1),

    ('Debit Card',
     'Payment processed using a debit card.',
     1),

    ('UPI',
     'Payment made through Unified Payments Interface.',
     1),

    ('Net Banking',
     'Payment made through internet banking.',
     1),

    ('Mobile Wallet',
     'Payment made using digital wallets such as Paytm, PhonePe Wallet or Amazon Pay Wallet.',
     1),

    ('Gift Card',
     'Payment made using store-issued or promotional gift cards.',
     1),

    ('Store Credit',
     'Payment made using store credit issued after returns or promotions.',
     1),

    ('Bank Transfer',
     'Payment transferred directly from a customer bank account.',
     1),

    ('Cash on Delivery',
     'Payment collected when products are delivered.',
     1);

END;

PRINT 'Payment Methods generated successfully.';

------------------------------------------------------------
-- Validate Payment Methods
------------------------------------------------------------

SELECT
    PaymentMethodID,
    MethodName,
    Description,
    IsActive
FROM dbo.PaymentMethod
ORDER BY PaymentMethodID;

/*==============================================================================
					Section 5 : Return Reasons
==============================================================================

Description:
------------
Populates the ReturnReason lookup table with predefined reasons for product
returns initiated by customers.

Business Rules:
---------------
- Each return reason must have a unique name.
- Return reasons are referenced by the Return table.
- CreatedDate is populated automatically using the default constraint.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.ReturnReason)
BEGIN

    INSERT INTO dbo.ReturnReason
    (
        ReasonName,
        Description
    )
    VALUES
        ('Damaged Product',      'Product received in damaged condition'),
        ('Defective Product',    'Product is not functioning as expected'),
        ('Wrong Item Delivered', 'Incorrect product delivered to the customer'),
        ('Missing Parts',        'Product package has missing accessories or parts'),
        ('Quality Issue',        'Product quality did not meet expectations'),
        ('Changed Mind',         'Customer no longer wants the product'),
        ('Incorrect Size',       'Product size was not suitable'),
        ('Late Delivery',        'Product was delivered later than expected'),
        ('Duplicate Order',      'Order was placed more than once by mistake'),
        ('Other',                'Other reason not listed above');

END;

PRINT 'ReturnReason generated successfully.';

SELECT *
FROM dbo.ReturnReason
ORDER BY ReturnReasonID;

/*==============================================================================
					Section 6 : Order Statuses
==============================================================================

Description:
------------
Populates the OrderStatus lookup table with predefined statuses used to
track the lifecycle of customer orders.

Business Rules:
---------------
- Each order status must have a unique name.
- Order statuses are referenced by the Order table.
- CreatedDate is populated automatically using the default constraint.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.OrderStatus)
BEGIN

    INSERT INTO dbo.OrderStatus
    (
        StatusName,
        Description
    )
    VALUES
        ('Pending',     'Order has been placed and is awaiting processing'),
        ('Confirmed',   'Order has been confirmed'),
        ('Processing',  'Order is being prepared for shipment'),
        ('Shipped',     'Order has been shipped'),
        ('Delivered',   'Order has been successfully delivered'),
        ('Cancelled',   'Order has been cancelled'),
        ('Returned',    'Order has been returned by the customer');

END;

PRINT 'OrderStatus generated successfully.';

SELECT *
FROM dbo.OrderStatus
ORDER BY OrderStatusID;

/*==============================================================================
					Section 7 : Payment Statuses
==============================================================================

Description:
------------
Populates the PaymentStatus lookup table with predefined statuses used to
track customer payment transactions.

Business Rules:
---------------
- Each payment status must have a unique name.
- Payment statuses are referenced by the Payment table.
- CreatedDate is populated automatically using the default constraint.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.PaymentStatus)
BEGIN

    INSERT INTO dbo.PaymentStatus
    (
        StatusName,
        Description
    )
    VALUES
        ('Pending',   'Payment is awaiting confirmation'),
        ('Completed', 'Payment has been successfully completed'),
        ('Failed',    'Payment transaction failed'),
        ('Refunded',  'Payment has been refunded to the customer'),
        ('Cancelled', 'Payment was cancelled before completion');

END;

PRINT 'PaymentStatus generated successfully.';

SELECT *
FROM dbo.PaymentStatus
ORDER BY PaymentStatusID;

/*==============================================================================
				Section 8 : Return Statuses
==============================================================================

Description:
------------
Populates the ReturnStatus lookup table with predefined statuses used to
track the progress of customer return requests.

Business Rules:
---------------
- Each return status must have a unique name.
- Return statuses are referenced by the Return table.
- CreatedDate is populated automatically using the default constraint.

==============================================================================*/

IF NOT EXISTS (SELECT 1 FROM dbo.ReturnStatus)
BEGIN

    INSERT INTO dbo.ReturnStatus
    (
        StatusName,
        Description
    )
    VALUES
        ('Requested', 'Customer has submitted a return request'),
        ('Approved',  'Return request has been approved'),
        ('Rejected',  'Return request has been rejected'),
        ('Received',  'Returned item has been received by the store'),
        ('Refunded',  'Refund has been processed successfully');

END;

PRINT 'ReturnStatus generated successfully.';

SELECT *
FROM dbo.ReturnStatus
ORDER BY ReturnStatusID;

PRINT '===============================================';
PRINT 'Lookup Data Generation Completed Successfully.';
PRINT '===============================================';