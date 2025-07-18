SELECT * from tbl_orders_copy

SELECT * from tbl_orders


SELECT 
	COALESCE(O.order_id ,C.order_id) AS order_id
	,CASE 
		WHEN O.order_id is null THEN 'D' 
		WHEN C.order_id IS NULL THEN 'I'
	END  AS FLAG
from tbl_orders O
FULL OUTER JOIN tbl_orders_copy C
ON O.order_id=C.order_id
WHERE C.order_id IS NULL OR O.order_id IS NULL