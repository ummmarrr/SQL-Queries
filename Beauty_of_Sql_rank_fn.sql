select * from covid;

with increasingly as(
	select *
		,rank()over(partition by city order by cases ) case_rank
		,rank()over(partition by city order by [days] ) day_rank
		,rank()over(partition by city order by cases ) - rank()over(partition by city order by [days] ) diff
	from covid
)
select city
from increasingly
group by city
having count(distinct diff)=1 AND SUM(distinct diff)=0