-- 1. Dynamically drop all Foreign Keys in the Silver schema
DECLARE @sql_fk NVARCHAR(MAX) = N'';
SELECT @sql_fk += N'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
                  ' DROP CONSTRAINT ' + QUOTENAME(name) + '; '
FROM sys.foreign_keys
WHERE OBJECT_SCHEMA_NAME(parent_object_id) = 'Silver';

EXEC sp_executesql @sql_fk;

-- 2. Dynamically drop all Tables in the Silver schema
DECLARE @sql_tables NVARCHAR(MAX) = N'';
SELECT @sql_tables += N'DROP TABLE Silver.' + QUOTENAME(name) + '; '
FROM sys.tables
WHERE SCHEMA_NAME(schema_id) = 'Silver';

EXEC sp_executesql @sql_tables;
GO


IF OBJECT_ID('Silver.brands','U') IS NOT NULL
	DROP TABLE Silver.brands;

CREATE TABLE Silver.brands (
	brand_id INT PRIMARY KEY,
	brand_name NVARCHAR(100), 
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO 

IF OBJECT_ID('Silver.categories','U') IS NOT NULL
	DROP TABLE Silver.categories;
	
CREATE TABLE Silver.categories (
	category_id INT PRIMARY KEY,
	category_name NVARCHAR(100),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO 


IF OBJECT_ID('Silver.customers','U') IS NOT NULL
	DROP TABLE Silver.customers;

CREATE TABLE Silver.customers (
	customer_id INT PRIMARY KEY,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	phone NVARCHAR(25),
	email NVARCHAR(100),      
	street NVARCHAR(255),     
	city NVARCHAR(100),
	zip_code NVARCHAR(20),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


IF OBJECT_ID('Silver.stores','U') IS NOT NULL
	DROP TABLE Silver.stores; 

CREATE TABLE Silver.stores (
	store_id INT PRIMARY KEY,
	store_name NVARCHAR(100),
	phone NVARCHAR(25),
	email NVARCHAR(100),
	street NVARCHAR(255),
	city NVARCHAR(100),
	state NVARCHAR(50),
	zip_code NVARCHAR(20),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('Silver.staffs','U') IS NOT NULL
	DROP TABLE Silver.staffs; 

CREATE TABLE Silver.staffs (
	staff_id INT PRIMARY KEY,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	email NVARCHAR(100),
	phone NVARCHAR(25),
	active INT,
	store_id INT,
	manager_id INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE(),
	CONSTRAINT FK_staffs_store FOREIGN KEY (store_id)
		REFERENCES Silver.stores(store_id),
	CONSTRAINT FK_staffs_manager FOREIGN KEY (manager_id)
		REFERENCES Silver.staffs(staff_id)
);
GO 

IF OBJECT_ID('Silver.products','U') IS NOT NULL
	DROP TABLE Silver.products;

CREATE TABLE Silver.products(
	product_id INT PRIMARY KEY,
	product_name NVARCHAR(255), 
	brand_id INT,
	category_id INT,
	model_year INT,             
	list_price DECIMAL(10,3),
	dwh_create_date DATETIME2 DEFAULT GETDATE(),
	CONSTRAINT FK_products_category FOREIGN KEY (category_id)
		REFERENCES Silver.categories(category_id),
	CONSTRAINT FK_products_brand FOREIGN KEY(brand_id)
		REFERENCES Silver.brands(brand_id)
);
GO


IF OBJECT_ID('Silver.stocks','U') IS NOT NULL
	DROP TABLE Silver.stocks; 

CREATE TABLE Silver.stocks (
	store_id INT,
	product_id INT,
	quantity INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE(),
	PRIMARY KEY(store_id, product_id),
	CONSTRAINT FK_stocks_store FOREIGN KEY (store_id)
		REFERENCES Silver.stores(store_id),
	CONSTRAINT FK_stocks_product FOREIGN KEY(product_id)
		REFERENCES Silver.products(product_id)
);
GO 

IF OBJECT_ID('Silver.orders','U') IS NOT NULL
	DROP TABLE Silver.orders;

CREATE TABLE Silver.orders(
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_status INT,
	order_date DATE,
	required_date DATE,
	shipped_date DATE,
	store_id INT,
	staff_id INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE(),
	CONSTRAINT FK_orders_customer FOREIGN KEY(customer_id) 
		REFERENCES Silver.customers(customer_id),
	CONSTRAINT FK_orders_store FOREIGN KEY(store_id) 
		REFERENCES Silver.stores(store_id),
	CONSTRAINT FK_orders_staff FOREIGN KEY (staff_id) 
		REFERENCES Silver.staffs(staff_id)
);
GO

IF OBJECT_ID('Silver.order_items','U') IS NOT NULL
	DROP TABLE Silver.order_items;

CREATE TABLE Silver.order_items(
	order_id INT,
	item_id INT,
	product_id INT,
	quantity INT,
	list_price DECIMAL(10,3),
	discount DECIMAL(5,3),
	dwh_create_date DATETIME2 DEFAULT GETDATE(),
	PRIMARY KEY (order_id, item_id),
	CONSTRAINT FK_items_order FOREIGN KEY (order_id) 
		REFERENCES Silver.orders(order_id),
	CONSTRAINT FK_items_product FOREIGN KEY (product_id) 
		REFERENCES Silver.products(product_id)
);
GO




