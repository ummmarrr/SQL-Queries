/*
	Write an sql to find details of employees with 3rd highest salary in each department.
	In case there are less then 3 employees in a department then 
	return employee details with lowest salary in that dep.
*/
select * from emp;
with salrank_cte as(
	select * 
		,row_number()over(partition by dep_name order by salary desc) sal_rn
		,count(*)over(partition by dep_name) total
	from emp
)

select * 
from salrank_cte 
where 
	sal_rn=3 and total>=3 
	OR sal_rn=2 and total=2
	OR sal_rn=1 and total=1