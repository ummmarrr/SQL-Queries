create table transactions(
order_id int,
cust_id int,
order_date date,
amount int
);
delete from transactions;
insert into transactions values 
(1,1,'2020-01-15',150)
,(2,1,'2020-02-10',150)
,(3,2,'2020-01-16',150)
,(4,2,'2020-02-25',150)
,(5,3,'2020-01-10',150)
,(6,3,'2020-02-20',150)
,(7,4,'2020-01-20',150)
,(8,5,'2020-02-20',150)
;



select * from transactions;
WITH CTE AS(
	SELECT
	cust_id
	,MIN(order_date) firstorderdate
	FROM transactions
	GROUP BY cust_id
)
,CTE2 AS(
	SELECT 
		t.cust_id
		,t.order_date
		,CASE WHEN t.order_date=c.firstorderdate THEN 1 ELSE 0 END FLAG
	FROM transactions T
	INNER JOIN CTE C
	ON C.cust_id=T.cust_id
)
SELECT MONTH(order_date),COUNT(CASE WHEN FLAG=1 THEN 1 END) total
FROM CTE2
GROUP BY MONTH(order_date)