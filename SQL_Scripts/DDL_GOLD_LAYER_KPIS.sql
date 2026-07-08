
 
CREATE VIEW Gold.vw_KPI_et_total_revenue
AS
SELECT 
CAST(SUM((quantity*list_price)*(1-discount)) AS decimal(10,3)) AS TOTAL_REVENUE 
FROM Silver.order_items;




CREATE VIEW Gold.vw_KPI_Average_Order_Value
AS
SELECT 
CAST((SUM((quantity*list_price)*(1-discount))*1.0)/(COUNT(order_id)) AS decimal(10,3)) AS Average_Order_Value
FROM Silver.order_items;



CREATE VIEW Gold.vw_KPI_Inventory_Turnover
AS
SELECT 
CAST(SUM((quantity*list_price)*(1-discount)) 
/(
SELECT 
AVG(S.quantity*P.list_price*1.0)  
FROM Silver.stocks AS S
LEFT JOIN Silver.products AS P
	ON S.product_id = P.product_id) AS decimal(10,2)) AS Turn_Over_Rate
FROM Silver.order_items;



CREATE VIEW Gold.vw_KPI_Revenue_By_Store
AS
SELECT DISTINCT
	S.store_name,
	CAST(SUM((O2.list_price*O2.quantity)*(1-O2.discount)) OVER (PARTITION BY O.store_id)AS decimal(10,2))AS Revenue_By_Store
FROM Silver.orders AS O
LEFT JOIN Silver.order_items AS O2
	ON O.order_id = O2.order_id
LEFT JOIN Silver.stores AS S
	ON O.store_id = S.store_id


CREATE VIEW Gold.vw_KPI_Gross_Profit_By_Category
AS
SELECT DISTINCT
C.category_id,
CAST(SUM((O.list_price*O.quantity)*(1-O.discount)) OVER (PARTITION BY C.category_id)AS decimal(10,2)) AS Gross_Profit_By_category
FROM Silver.order_items AS O
LEFT JOIN Silver.products AS P
	ON O.product_id = P.product_id
LEFT JOIN Silver.categories AS C
	ON P.category_id = C.category_id;


CREATE VIEW Gold.vw_KPI_Sales_By_Brand
AS
SELECT DISTINCT
B.brand_id,
CAST(SUM((O.list_price*O.quantity)*(1-O.discount)) OVER (PARTITION BY B.brand_id) AS decimal(10,2)) AS Sales_by_Brand
FROM Silver.order_items AS O
LEFT JOIN Silver.products AS P
	ON O.product_id = P.product_id
LEFT JOIN Silver.brands AS B
	ON P.brand_id = B.brand_id

CREATE VIEW Gold.vw_KPI_Staff_Revenue_Contribution
AS
SELECT DISTINCT
S.staff_id,
CAST(SUM((O.list_price*O.quantity)*(1-O.discount)) OVER (PARTITION BY S.staff_id) AS decimal(10,2)) AS Sales_By_Staff
FROM Silver.order_items AS O
LEFT JOIN Silver.orders AS O2
	ON O.order_id = O2.order_id
LEFT JOIN Silver.staffs AS S
	ON O2.staff_id = S.staff_id

