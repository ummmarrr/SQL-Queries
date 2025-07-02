select * from products
select * from customer_budget;

with adding_cost_cte as(
	select *
		,sum(cost)over(order by cost) costsum
	from products
)
,cte as(
	select cb.customer_id,acc.product_id
	from customer_budget cb 
	left join adding_cost_cte acc on cb.budget >= acc.costsum
	group by cb.customer_id,acc.product_id
)
select customer_id,string_agg(product_id,'') Products_available
from cte
group by customer_id


--M2: Optimized

with adding_cost_cte as(
	select *
		,sum(cost)over(order by cost) costsum
	from products
)
select cb.customer_id,string_agg(acc.product_id,'') Products_available
from customer_budget cb 
left join adding_cost_cte acc on cb.budget >= acc.costsum
group by cb.customer_id
