USE Biking_Store_Project

GO

IF OBJECT_ID('Bronze.brands','U') IS NOT NULL
	DROP TABLE Bronze.brands;

GO 

CREATE TABLE Bronze.brands (
	brand_id INT,
	brande_name NVARCHAR(50)
);

GO


IF OBJECT_ID('Bronze.categories','U') IS NOT NULL
	DROP TABLE Bronze.categories;

GO

CREATE TABLE Bronze.categories(
	category_id INT,
	category_name NVARCHAR(50)
);

GO


IF OBJECT_ID('Bronze.customers','U') IS NOT NULL
	DROP TABLE Bronze.customers;

GO

CREATE TABLE Bronze.customers(
	customer_id INT,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	phone NVARCHAR(50),
	email NVARCHAR(50),
	street NVARCHAR(50),
	city NVARCHAR(50),
	state NVARCHAR(50),
	zip_code NVARCHAR(50)
);

GO

IF OBJECT_ID('Bronze.order_items','U') IS NOT NULL
	DROP TABLE Bronze.order_items;

GO

CREATE TABLE Bronze.order_items (
	order_id INT,
	item_id INT,
	product_id INT,
	quantity INT,
	list_price DECIMAL(10,4),
	discount DECIMAL(4,4));

GO

IF OBJECT_ID('Bronze.orders','U') IS NOT NULL
	DROP TABLE Bronze.orders;

GO 


CREATE TABLE Bronze.orders (
	order_id INT,
	customer_id INT,
	order_status INT,
	order_date DATE,
	required_date NVARCHAR(50),
	shipped_date NVARCHAR(50),
	store_id INT,
	staff_id INT
);

GO

IF OBJECT_ID('Bronze.products','U') IS NOT NULL
	DROP TABLE Bronze.products;

GO


CREATE TABLE Bronze.products (
	product_id INT,
	product_name NVARCHAR(100),
	brand_id INT,
	category_id INT,
	model_year INT,
	list_price DECIMAL(10,4)
);


GO

IF OBJECT_ID('Bronze.staffs','U') IS NOT NULL
	DROP TABLE Bronze.staffs;

GO 

CREATE TABLE Bronze.staffs (
	staff_id INT,
	first_name NVARCHAR(50),
	last_name NVARCHAR(50),
	email NVARCHAR(50),
	phone NVARCHAR(50),
	active INT,
	store_id INT,
	manager_id NVARCHAR(50)
);


GO 

IF OBJECT_ID('Bronze.stocks','U') IS NOT NULL
	DROP TABLE Bronze.stocks;

GO


CREATE TABLE Bronze.stocks (
	store_id INT,
	product_id INT,
	quantity INT
);


GO

IF OBJECT_ID('Bronze.stores','U') IS NOT NULL
	DROP TABLE Bronze.stores;

GO

CREATE TABlE Bronze.stores (
	store_id INT,
	store_name NVARCHAR(50),
	phone NVARCHAR(50),
	email NVARCHAR(50),
	street NVARCHAR(50),
	city NVARCHAR(50),
	state NVARCHAR(50),
	zip_code NVARCHAR(50)
);