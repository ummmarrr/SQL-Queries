--Write a SQL query to find the median salary of each company.
--Bonus points if you can solve it without using any built-in SQL functions..
select * from employee order by company,salary;

--M1: Using 2 window function
with cte as(
select
	company
	,salary
	,row_number()over(partition by company order by salary) rn_asc
	,row_number()over(partition by company order by salary desc) rn_desc
from employee
)
select 
	company
	,avg(CASE 
			WHEN
				rn_asc=rn_desc 
				OR rn_asc=rn_desc-1 
				OR rn_asc=rn_desc+1
			THEN 
				salary 
		END) as median_salary
from cte
group by company


--M2: Using count(1), row_number, between, avg, 
with cte as(
select
	*
	,ROW_NUMBER()over(partition by company order by salary) rn
	,count(1)over(partition by company) company_total_emp
from employee
)

select
	company
	,avg(salary) as median_salary
from cte
where rn  between ROUND(company_total_emp*1.0/2,1) and ROUND(company_total_emp*1.0/2,1)+1
group by company