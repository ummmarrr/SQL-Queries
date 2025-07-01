select * from bms;
--M1: Lag % Lead Method
with structure_cte as(
	select *
		,LAG(is_empty,1) over (order by seat_no) p1
		,LAG(is_empty,2) over (order by seat_no) p2
		,LEAD(is_empty,1) over (order by seat_no) n1
		,LEAD(is_empty,2) over (order by seat_no) n2
	from bms
)
select
	seat_no
from structure_cte
where 
	((is_empty='Y') AND ((p1='Y' and p2='Y')OR(p1='Y' and n1='Y')OR(n1='Y' and n2='Y')))

---------------------------------------------------------------------------------
--M2: Using aggregation
with structure_cte_2 as(
	select *
		,SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 2 preceding and current row) p
		,SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between 1 preceding and 1 following) pn
		,SUM(case when is_empty='Y' then 1 else 0 end) over (order by seat_no rows between current row and 2 following) n
	from bms
)
select
	seat_no
from str
ucture_cte_2
where p=3 OR n=3 OR pn=3



---------------------------------------------------------------------------------
--M3: using row_no
with difference_cte as(
	SELECT
		*
		,ROW_NUMBER()over(order by seat_no) rank
		,seat_no-ROW_NUMBER()over(order by seat_no) diff
	FROM bms
	where is_empty='Y'
)
, req_row as(
	select
		diff
	from difference_cte
	group by diff
	having count(seat_no)>2
)
select
	d.seat_no
from difference_cte d
inner join req_row r on d.diff=r.diff
