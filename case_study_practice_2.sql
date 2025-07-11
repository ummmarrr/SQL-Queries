--1. Top 3 Restaurants by Average Order Value
select * from orders

select TOP 3 r.name,avg(o.total_amount) avg_order_value
from 
	orders o
	inner join restaurants r 
	on o.restaurant_id=r.restaurant_id
group by r.name
order by avg(o.total_amount) desc


--2. Total Orders per Customer
select * from orders
select * from customers

select c.name,count(o.order_id) total_order_per_customer
from 
	orders o
	inner join customers c
	on o.customer_id=c.customer_id
group by c.name


--3. Most Ordered Item 
	-- Identify the food_item_id with the highest total quantity sold

select * from orderitems;

select TOP 1 food_item_id, SUM(quantity) total_quantity
from orderitems
group by food_item_id
order by total_quantity desc



--4. Monthly Revenue Trend
		--(Show monthly revenue for Swiggy platform)

select 
	datepart(year,order_date) year
	,datepart(month,order_date) month
	,SUM (total_amount) monthly_sum
from orders 
group by datepart(year,order_date),datepart(month,order_date)

--5. Find customers who have placed more than 1 order

select 
	o.customer_id
	,count(o.order_id) #order
from 
	orders o
	inner join customers c
	on o.customer_id=c.customer_id
group by o.customer_id
having count(o.order_id)>1

--6. Average delivery time per city
select * from orders
select * from restaurants

select
	r.name
	,avg(delivery_time) avg_delivery
from 
	orders o
	inner join restaurants r
	on o.restaurant_id=r.restaurant_id
group by r.name
order by r.name


--7. Show MoM revenue growth for each restaurant


WITH monthly_data AS (
    SELECT
        restaurant_id,
        datepart(month, order_date) AS month,
        SUM(total_amount) AS revenue
    FROM Orders
    GROUP BY restaurant_id, datepart(month, order_date)
)
,growth_data AS (
    SELECT *,
           LAG(revenue) OVER (PARTITION BY restaurant_id ORDER BY month) AS prev_revenue
    FROM monthly_data
)
SELECT
    restaurant_id,
    month,
    revenue,
    prev_revenue,
    ROUND(((revenue - prev_revenue) / NULLIF(prev_revenue, 0)) * 100, 2) AS MoM_growth_percent
FROM growth_data
WHERE prev_revenue IS NOT NULL