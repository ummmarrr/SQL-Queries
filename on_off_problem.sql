select * from event_status

with cte as(
	select 
		* 
		,lag(status,1,'on')over(order by event_time) prev
	from event_status
)
,cte2 as(
	select *
		,sum(case when status='on' and prev='off' then 1 else 0 end)over(order by event_time) calc_sum
	from cte
)
select 
	min(event_time) login_time
	,max(event_time) logout_time
	,count(*)-1 as ccount
from cte2
group by calc_sum