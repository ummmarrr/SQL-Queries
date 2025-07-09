/*
	OUTPUT
*/

--M1: using rolling sum and LAG(rolling_sum)
with cte as(
	select match, innings, runs 
		,SUM(Runs)over(order by Innings) scoresum
	from sachin_batting
	where Innings is not null
)
,cte2 as(
	select *
		,LAG(scoresum)over(order by Innings) prescoresum
	from cte 
)
,cte3 as(
	select 1 num , 1000 milestone
	union all
	select 2 num , 5000 milestone
	union all 
	select 3 num , 10000 milestone
)
select c2.match milestone_match_no, c2.innings milestone_innings, c2.runs milestone_match_run, c3.milestone
from cte2 c2,cte3 c3
where c2.scoresum > c3.milestone and c2.prescoresum < c3.milestone



--M2:
with cte1 as(
	select match, innings, runs 
		,SUM(Runs)over(order by Innings) scoresum
	from sachin_batting
	where Innings is not null
)

,cte2 as(
	select 1 num , 1000 milestone
	union all
	select 2 num , 5000 milestone
	union all 
	select 3 num , 10000 milestone
)

select min(match) milestone_match_no,min(innings) milestone_innings, milestone
from cte1 c1
inner join cte2 c2
on scoresum > milestone
group by milestone
