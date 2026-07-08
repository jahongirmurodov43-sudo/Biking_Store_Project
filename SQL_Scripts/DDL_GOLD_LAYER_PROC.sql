

CREATE OR ALTER PROCEDURE Gold.sp_CalculateStoreKPI
	@store_id INT
AS BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY 
	WITH CTE1 AS (
		SELECT DISTINCT
			S.store_name,
			S.city,
			S.store_id,
			SUM(O2.quantity*O2.list_price) OVER (PARTITION BY S.store_id) AS [GROSS REVENUE],
			SUM((O2.quantity*O2.list_price)*(1-O2.discount)) OVER(PARTITION BY S.store_id) AS [NET REVENUE],
			COUNT(O.order_id) OVER (PARTITION BY S.store_id) AS [TOTAL ORDERS COUNT],
			SUM(O2.quantity) OVER (PARTITION BY S.store_id) AS [TOTA UNIT SOLD]
		FROM Silver.stores AS S
		LEFT JOIN Silver.orders AS O
			ON S.store_id = O.store_id
		LEFT JOIN Silver.order_items AS O2
			ON O.order_id = O2.order_id)

	SELECT * FROM CTE1 AS C
	WHERE C.store_id = @store_id
	END TRY 
	BEGIN CATCH 
	PRINT ERROR_MESSAGE()
	PRINT CAST(ERROR_NUMBER() AS VARCHAR(10));
	END CATCH
END;



CREATE OR ALTER PROCEDURE Gold.sp_GenerateRestockList
	@store_id INT
AS BEGIN 
	SET NOCOUNT ON;
	BEGIN TRY

	SELECT 
		S.store_id,
		P.product_name,
		P.product_id,
		S.quantity
	FROM Silver.stocks AS S
	LEFT JOIN Silver.products AS P
		ON S.product_id = P.product_id
	WHERE S.quantity < 5 AND S.store_id = @store_id
	ORDER BY S.quantity; 
	END TRY
	BEGIN CATCH
	PRINT ERROR_MESSAGE();
	PRINT CAST(ERROR_NUMBER() AS NVARCHAR(10));
	END CATCH
END;




CREATE OR ALTER PROCEDURE Gold.sp_CompareSalesYearOverYear
AS BEGIN 
	SET NOCOUNT ON
	BEGIN TRY
	WITH CTE AS (
		SELECT DISTINCT
			YEAR(O.order_date) AS YEARS,
			SUM(O2.list_price*O2.quantity) OVER (PARTITION BY YEAR(O.order_date)) AS [TOTAL REVENUE BY YEAR],
			SUM((O2.list_price*O2.quantity)*(1-O2.discount)) OVER (PARTITION BY YEAR(O.order_date)) AS [TOTAL NET REVENUE]
		FROM Silver.orders AS O
		LEFT JOIN Silver.order_items AS O2
			ON O.order_id = O2.order_id)


	SELECT 
	YEARS,
	CAST((([TOTAL NET REVENUE]-(LAG([TOTAL NET REVENUE]) OVER (ORDER BY YEARS)))*1.0/(LAG([TOTAL NET REVENUE]) OVER (ORDER BY YEARS))) * 100 AS decimal(10,2)) AS growth_pst
	FROM CTE;
	END TRY
	BEGIN CATCH
	PRINT ERROR_MESSAGE();
	PRINT CAST(ERROR_NUMBER() AS NVARCHAR(10));
	END CATCH
END;



CREATE OR ALTER PROCEDURE Gold.sp_GetCustomerProfile
	@customer_id INT
AS BEGIN 
	SET NOCOUNT ON;
	
	BEGIN TRY 
	WITH CTE  AS (
		SELECT DISTINCT
			C.customer_id,
			SUM(O2.list_price*O2.quantity) OVER (PARTITION BY C.customer_id) AS [TOTAL REVENUE],
			CAST(SUM((O2.list_price*O2.quantity)*(1-O2.discount)) OVER (PARTITION BY C.customer_id)AS decimal(10,3)) AS [TOTAL NET REVENUE],
			COUNT(O2.order_id) OVER (PARTITION BY C.customer_id) AS [TOTAL ORDERS NUMBER]
		FROM Silver.customers AS C
		LEFT JOIN Silver.orders AS O
			ON C.customer_id = O.customer_id
		LEFT JOIN Silver.order_items AS O2
			ON O.order_id = O2.order_id)

	SELECT * FROM CTE
	WHERE customer_id = @customer_id
	ORDER BY [TOTAL NET REVENUE] DESC,[TOTAL ORDERS NUMBER] DESC,[TOTAL REVENUE] DESC;
	

	SELECT DISTINCT
			C.customer_id,
			O2.*
		FROM Silver.customers AS C
		LEFT JOIN Silver.orders AS O
			ON C.customer_id = O.customer_id
		LEFT JOIN Silver.order_items AS O2
			ON O.order_id = O2.order_id
		WHERE C.customer_id = @customer_id;


	WITH CTE AS (
		SELECT DISTINCT
			C.customer_id,
			O2.product_id,
			SUM(O2.quantity) OVER (PARTITION BY O2.product_id,C.customer_id) AS COUNT_OF_PRODUCTS
		FROM Silver.customers AS C
		LEFT JOIN Silver.orders AS O
			ON C.customer_id = O.customer_id
		LEFT JOIN Silver.order_items AS O2
			ON O.order_id = O2.order_id)
	SELECT * FROM CTE
	WHERE customer_id = @customer_id
	ORDER BY COUNT_OF_PRODUCTS DESC;
	
	END TRY 
	BEGIN CATCH
	PRINT ERROR_MESSAGE();
	PRINT CAST(ERROR_NUMBER() AS NVARCHAR(10));
	END CATCH

END;













