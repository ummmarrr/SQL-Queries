/*
	Find the largest order by value for each salesperson and display order details.
	Get the result without using sub query, cte, window functions, temp tables
*/

select * from int_orders

select 
	a.order_number,a.order_date,a.cust_id,a.salesperson_id,a.amount
from int_orders a
inner join int_orders b on a.salesperson_id=b.salesperson_id
group by a.order_number,a.order_date,a.cust_id,a.salesperson_id,a.amount
having a.amount >= max(b.amount)