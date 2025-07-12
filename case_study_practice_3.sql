--1. Calculate % revenue from veg items in Bangalore (Oct) 

select * 
from 
	orders o
	inner join menu_items m
	on o.restaurant_id=m.restaurant_id
where o.city='Bangalore' and DATEPART(month,order_date)=10 and m.is_vegetarian=1


--2. Find days where holiday AOV exceeded non-holiday AOV by >20% (use date_dim).






--3. For repeat customers, find avg delay of their FIRST order.
select * from orders

with cte as(
	select *
		,delivery_time-predicted_delivery_time as delay
		,rank()over(order by order_date asc) rn
	from orders
	where customer_id in
						(select customer_id
						from orders
						group by customer_id
						having count(customer_id)>1)

)
select avg(delay) avg_first_order_delay
from cte
where rn=1



--4. Top 3 Menu Categories
	--Rank categories by order count per city (exclude cancellations).
select * from orders
select * from menu_items

with cte as(
	select 
		o.city
		,m.name
		,count(m.name) categ_cnt_in_that_city
		--,DENSE_RANK()over(partition by o.city order by m.name desc) rn

	from 
		orders o
		inner join menu_items m
		on o.restaurant_id=m.restaurant_id
	where o.cancellation_reason is NULL
	group by o.city,m.name
)
,cte2 as(
	select city
		, name as category
		, categ_cnt_in_that_city as order_count
		,DENSE_RANK()over(partition by city order by categ_cnt_in_that_city desc) "rank"
	from cte
)
select * from cte2 where rank<4

--5. 
--Find partners with delivery time within 10% of prediction for 3+ CONSECUTIVE orders
--output: partner_id, streak_length
select * from orders
/*
	step
	1. calculate lower_predicted_delivery and higher_predicted_delivery
	2.calculate a new col 'FLAG' =1 if delivery_time between lower_predicted_delivery and higher_predicted_delivery else 0
*/
with cte as(
	select
		order_id
		,order_date
		,delivery_partner_id
		,CASE 
			WHEN delivery_time BETWEEN 0.9* predicted_delivery_time AND 1.1 * predicted_delivery_time 
			THEN 1 ELSE 0 
		END as flag
	from orders
)
, cte2 as(
	select *
		,LAG(flag,1,0)over(partition by delivery_partner_id order by order_date) pflag
		,LEAD(flag,1,0)over(part	ition by delivery_partner_id order by order_date) nflag
	from cte 
)

select delivery_partner_id
from cte2
where
	flag=1 and pflag=1 and nflag=1