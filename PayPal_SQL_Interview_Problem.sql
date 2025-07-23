/*
	The question goes as follows: We need to obtain a list of departments with an average salary lower than the overall average salary of the company. 
	However, when calculating the company's average salary, you must exclude the salaries of the department you are comparing it with. For instance, 
	when comparing the average salary of the HR department with the company's average, 
	the HR department's salaries shouldn't be taken into consideration for the calculation of company average salary. 
	Likewise, if you want to compare the average salary of the Finance department with the company's average, 
	the company's average salary should not include the salaries of the Finance department, and so on. 
	Essentially, the company's average salary will be dynamic for each department.
*/

SELECT * FROM emp

WITH dept_avg AS (
  SELECT 
    department_id
    ,AVG(salary) AS avg_salary_dep
	FROM emp
  GROUP BY department_id
)
,cte as(
	SELECT 
	  department_id
	  ,avg_salary_dep
	 
	  ,SUM(avg_salary_dep) OVER (order by department_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS sm
	FROM dept_avg
)
SELECT * 
		,(sm-avg_salary_dep)/2 avg_salary_of_dep_by_ignoring_your_dep_avg_sal 
FROM cte 