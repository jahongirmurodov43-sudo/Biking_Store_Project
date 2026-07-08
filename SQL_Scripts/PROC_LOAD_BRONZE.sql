
CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN

	DECLARE @start_time DATETIME, @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME ;
	BEGIN TRY	
		SET @batch_start_time = GETDATE();
		PRINT'================================================================================================';
		PRINT'Loading Bronze Layer';
		PRINT'================================================================================================';
		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.brands';

		TRUNCATE TABLE Bronze.brands;

		PRINT'>>> Inserting Data Into: Bronze.brands';
		BULK INSERT Bronze.brands
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\brands.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.categories';
		TRUNCATE TABLE Bronze.categories;

		PRINT'>>> Inserting Data Into: Bronze.categories';
		BULK INSERT Bronze.categories
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\categories.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duaration: '+ CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.customers';
		TRUNCATE TABLE Bronze.customers;

		PRINT'>>> Inserting Data Into: Bronze.customers';
		BULK INSERT Bronze.customers
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\customers.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.order_items';
		TRUNCATE TABLE Bronze.order_items;

		PRINT'>>> Inserting Data Into: Bronze.order_items';
		BULK INSERT Bronze.order_items
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\order_items.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.orders';
		TRUNCATE TABLE Bronze.orders;

		PRINT'>>> Inserting Data Into: Bronze.orders';
		BULK INSERT Bronze.orders
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\orders.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';



		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.products';
		TRUNCATE TABLE Bronze.products;

		PRINT'>>> Inserting Data Into: Bronze.products';
		BULK INSERT Bronze.products
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\products.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.staffs';
		TRUNCATE TABLE Bronze.staffs;

		PRINT'>>> Inserting Data Into: Bronze.staffs';
		BULK INSERT Bronze.staffs
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\staffs.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';




		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.stocks';
		TRUNCATE TABLE Bronze.stocks;

		PRINT'>>> Inserting Data Into: Bronze.stocks';
		BULK INSERT Bronze.stocks
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\stocks.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';





		SET @start_time = GETDATE();
		PRINT'>>> Truncating Table: Bronze.stores';
		TRUNCATE TABLE Bronze.stores;

		PRINT'>>> Inserting Data Into: Bronze.stores';
		BULK INSERT Bronze.stores
		FROM 'D:\python\Biking Store Project\drive-download-20260519T133416Z-3-001\stores.csv'
		WITH(
			FORMAT = 'CSV',
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
		PRINT'-----------------------------------------------------------------------------------';

		SET @batch_end_time = GETDATE();
		PRINT'================================================================================================';
		PRINT'Loading Bronze Layer is completed';
		PRINT'		-Total Load Duration: ' + CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) as NVARCHAR) + 'seconds';
		PRINT'================================================================================================';
	END TRY 
	BEGIN CATCH
		PRINT'================================================================================================';
		PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT'Error Message: ' + ERROR_MESSAGE();
		PRINT'Error Message: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'================================================================================================';
	END CATCH

END


