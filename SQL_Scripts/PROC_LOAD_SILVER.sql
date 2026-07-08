CREATE OR ALTER PROCEDURE Silver.load_silver AS

BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRANSACTION;

	BEGIN TRY

		DELETE FROM Silver.order_items;
		DELETE FROM Silver.orders;
		DELETE FROM Silver.stocks;
		DELETE FROM Silver.staffs;
		DELETE FROM Silver.products;


		DELETE FROM Silver.customers;
		DELETE FROM Silver.stores;
		DELETE FROM Silver.categories;
		DELETE FROM Silver.brands;





		INSERT INTO Silver.brands(
			brand_id,
			brand_name)
		SELECT 
			brand_id,
			brande_name
		FROM Bronze.brands;




		INSERT INTO Silver.categories(
			category_id,
			category_name)
		SELECT
			category_id,
			category_name
		FROM Bronze.categories;





		INSERT INTO Silver.customers(
			customer_id,
			first_name,
			last_name,
			phone,
			email,
			street,
			city,
			zip_code)
		SELECT 
		customer_id,
		first_name,
		last_name,
		phone,
		email,
		street,
		city,
		zip_code
		FROM Bronze.customers;





		INSERT INTO Silver.products(
			product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			list_price)
		SELECT 
			product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			list_price
		FROM Bronze.products;






		INSERT INTO Silver.stores(
			store_id,
			store_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code)
		SELECT 
			store_id,
			store_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code
		FROM Bronze.stores;





		INSERT INTO Silver.staffs(
			staff_id,
			first_name,
			last_name,
			email,
			phone,
			active,
			store_id,
			manager_id)
		SELECT 
			staff_id,
			first_name,
			last_name,
			email,
			phone,
			active,
			store_id,
			CASE WHEN manager_id LIKE 'NULL' THEN NULL
			ELSE manager_id
			END AS manager_id 
		FROM Bronze.staffs;







		INSERT INTO Silver.stocks(
			store_id,
			product_id,
			quantity)
		SELECT 
			store_id,
			product_id,
			quantity
		FROM Bronze.stocks;









		INSERT INTO Silver.orders(
			order_id,
			customer_id,
			order_status,
			order_date,
			required_date,
			shipped_date,
			store_id,
			staff_id)
		SELECT 
			order_id,
			customer_id,
			order_status,
			order_date,
			required_date,
			CASE WHEN shipped_date LIKE 'NULL' THEN NULL
			ELSE shipped_date
			END AS shipped_date,
			store_id,
			staff_id
		FROM Bronze.orders;





		INSERT INTO Silver.order_items(
			order_id,
			item_id,
			product_id,
			quantity,
			list_price,
			discount)
		SELECT 
			order_id,
			item_id,
			product_id,
			quantity,
			list_price,
			discount
		FROM Bronze.order_items;



	COMMIT TRANSACTION;
	PRINT'Silver Layer successfully refreshed';

	END TRY

	BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		DECLARE @ERRORMESSAGE NVARCHAR(4000) = ERROR_MESSAGE();
		DECLARE @ERRORSEVERITY INT = ERROR_SEVERITY();
		DECLARE @ERRORRSTATE INT = ERROR_STATE();
		RAISERROR (@ERRORMESSAGE,@ERRORSEVERITY,@ERRORRSTATE);

	END CATCH
END