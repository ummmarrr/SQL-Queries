select * from orders
--1.
select order_id,order_value
from orders
where status='Cancelled' and city='Mumbai'

--2.
select * from restaurants
select name,cuisine
from restaurants
group by name,cuisine
having avg(avg_rating)>4

--3.
select * from delivery_partners
select * from orders


select avg(o.delivery_time) avg_deliveyr_time_for_bike_vs_scooter, d.vehicle_type
from orders o
inner join delivery_partners d on o.delivery_partner_id=d.partner_id
group by d.vehicle_type

--4.
select partner_name
from orders o
inner join delivery_partners d on o.delivery_partner_id=d.partner_id
where order_date='2023-10-15'
group by partner_name
having count(order_id)>1


--5.
select order_date, SUM(order_value) daily_revenue
from orders
where order_date between '2023-10-15' and '2023-10-17'
group by order_date
order by order_date asc

--6. 
select 
	count(case when delivery_time > predicted_delivery_time then 1 END)*1.0 / 
	count(order_id) delay_percentage
from orders

--7.
--Hard
select order_date,order_value
	,SUM(order_value)over(order by order_date rows between 1 preceding and current row) moving_avg 
from orders
where city='Bangalore'


--8.
--CAse study
select *
from orders where city='Mumbai' 

select 
	SUM(case when order_date='2023-10-15' then order_value else 0 END)
		over(order by order_date) oct15
	,SUM(case when order_date='2023-10-18' then order_value else 0 END)
		over(order by order_date) oct18
from orders
where city='Mumbai' and order_date In('2023-10-15','2023-10-18')
