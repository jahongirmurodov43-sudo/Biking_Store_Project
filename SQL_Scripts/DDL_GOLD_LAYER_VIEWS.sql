

CREATE VIEW Gold.vw_StoreSalesSummary
AS
SELECT DISTINCT
	S.store_name,
	S.city,
	SUM(O2.quantity*O2.list_price) OVER (PARTITION BY S.store_id) AS [GROSS REVENUE],
	SUM((O2.quantity*O2.list_price)*(1-O2.discount)) OVER(PARTITION BY S.store_id) AS [NET REVENUE],
	COUNT(O.order_id) OVER (PARTITION BY S.store_id) AS [TOTAL ORDERS COUNT],
	SUM(O2.quantity) OVER (PARTITION BY S.store_id) AS [TOTA UNIT SOLD]
FROM Silver.stores AS S
LEFT JOIN Silver.orders AS O
	ON S.store_id = O.store_id
LEFT JOIN Silver.order_items AS O2
	ON O.order_id = O2.order_id




CREATE VIEW Gold.vw_TopSellingProducts
AS
WITH CTE AS (
SELECT DISTINCT
	P.product_id,
	P.product_name,
	SUM(O.quantity) OVER (PARTITION BY P.product_id) AS [TOTAL QUANTITY SOLD],
	SUM(O.quantity*O.list_price) OVER (PARTITION BY P.product_id) AS [REVENUE BY PRODUCT],
	SUM((O.quantity*O.list_price)*(1-O.discount)) OVER (PARTITION BY P.product_id) AS [NET REVENUE BY PRODUCT]
FROM Silver.products AS P
LEFT JOIN Silver.order_items AS O
	ON P.product_id = O.product_id
)

SELECT TOP 10
	C.product_name,
	C.[TOTAL QUANTITY SOLD],
	C.[REVENUE BY PRODUCT],
	C.[NET REVENUE BY PRODUCT]
FROM CTE AS C
ORDER BY C.[TOTAL QUANTITY SOLD] DESC ,C.[REVENUE BY PRODUCT] DESC , C.[NET REVENUE BY PRODUCT] DESC




CREATE VIEW Gold.vw_InventoryStatus
AS
SELECT DISTINCT
	P.product_id,
	P.product_name,
	SUM(S.quantity) OVER (PARTITION BY P.product_id) AS [STOCK QUANTITY]
FROM Silver.products AS P
LEFT JOIN Silver.stocks AS S
	ON P.product_id = S.product_id





CREATE VIEW Gold.vw_StaffPerformance
AS
SELECT DISTINCT
	S.staff_id,
	S.first_name,
	S.last_name,
	SUM(O2.quantity) OVER (PARTITION BY S.staff_id) AS [TOTAL QUANTITY],
	SUM(O2.quantity*O2.list_price) OVER (PARTITION BY S.staff_id) AS [TOTAL REVENUE],
	SUM((O2.quantity*O2.list_price)*(1-O2.discount)) OVER(PARTITION BY S.staff_id) AS [TOTAL NET REVENUE]
FROM Silver.staffs AS S
LEFT JOIN Silver.orders AS O
	ON S.staff_id  = O.staff_id
LEFT JOIN Silver.order_items AS O2
	ON O.order_id = O2.order_id



CREATE VIEW Gold.vw_RegionalTrends
AS
SELECT DISTINCT
	S.state,
	SUM(O2.quantity*O2.list_price) OVER (PARTITION BY S.state) AS [TOTAL REVENUE],
	SUM((O2.quantity*O2.list_price)*(1-O2.discount)) OVER (PARTITION BY S.state) AS [TOTAL NET REVENUE],
	SUM(O2.quantity) OVER (PARTITION BY S.state) AS [TOTAL QUANTITY]
FROM Silver.stores AS S
LEFT JOIN Silver.orders AS O
	ON S.store_id = O.store_id
LEFT JOIN Silver.order_items AS O2
	ON	O.order_id = O2.order_id



CREATE VIEW Gold.vw_SalesByCategory 
AS
SELECT DISTINCT
	C.category_id,
	C.category_name,
	SUM(O.quantity*O.list_price) OVER (PARTITION BY C.category_id) AS [TOTAL REVENUE],
	SUM((O.quantity*O.list_price)*(1-O.discount)) OVER (PARTITION BY C.category_id) AS [TOTAL NET REVENUE],
	SUM(O.quantity) OVER (PARTITION BY C.category_id) AS [TOTAL QUANTITY]
FROM Silver.categories AS C
LEFT JOIN Silver.products AS P
	ON C.category_id = P.category_id 
LEFT JOIN Silver.order_items AS O
	ON P.product_id = O.product_id




