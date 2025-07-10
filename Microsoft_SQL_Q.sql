/*
	A company wants to hire new employees. The budget of the company for the salaries is $70000. 
	The company's criteria for hiring are:
	Keep hiring the senior with the smallest salary until you cannot hire any more seniors.
	Use the remaining budget to hire the junior with the smallest salary.
	Keep hiring the junior with the smallest salary until you cannot hire any more juniors.
	Write an SQL query to find the seniors and juniors hired under the mentioned criteria.
*/

--select * from candidates

with addedcte as(
	select *
		,sum(salary)over(partition by experience order by salary) rolsum
	from candidates
)
,sr_cte as(
	select emp_id,salary,rolsum
	from addedcte
	where experience='Senior' AND rolsum <=70000
)

select emp_id,salary,rolsum
from addedcte
where experience='Junior' AND rolsum <=70000 - (select SUM(salary) from sr_cte)

UNION ALL

SELECT * from sr_cte