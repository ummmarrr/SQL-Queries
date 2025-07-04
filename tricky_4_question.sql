select * from students;

--Q1: List of student who score more than average marks in each subject
with cte as(
	select 
		subject,AVG(marks) avg_sub
	from students
	group by subject
)
select 
	s.studentname
from students s
inner join cte c 
on s.subject=c.subject and s.marks > c.avg_Sub

--Q2: % of std who score more than 90 in any subject 
--M1: Non optimized
with cte1 as(
	select
		count(distinct studentname) reqcnt
	from students
	where marks>90
)
,cte2 as(
	select count(distinct studentname) actcnt
	from students
)
select round(c1.reqcnt*100.0/c2.actcnt,2)
from cte1 c1,cte2 c2

--M2: Optimized

select * from students
select
	count(distinct case when marks>90 then studentid end)*100.0 / count(distinct studentname)
from students 
group by studentname


--Q3: Write an SQL query to get the second highest and second-lowest marks for each subjec
with second_cte as(
	select
		subject
		,marks
		,dense_rank()over(partition by subject order by marks desc) second_highest
		,dense_rank()over(partition by subject order by marks asc) second_lowest
	from students
)
select 
	subject
	--,marks
	,MAX(case 
		when second_highest=2 then marks 
	end) as second_highest_marks
	,MAX(case 
		when second_lowest=2 then marks 
	end) as second_lowest_marks
from second_cte
group by subject


--Q4: For each student and test, identify if their marks increased or decreased from the previous test.

--select * from students;
--with cte as(
--	select
--		*
--		,row_number()over(partition by studentname order by marks)rn_marks
--		,row_number()over(partition by studentname order by testdate)rn_date
--		,row_number()over(partition by studentname order by marks) - row_number()over(partition by studentname order by testdate) diff
--	from students
--)
--select 
--	studentname
--	,case
--		when avg(diff)=0 and max(diff)=0
--		then 'inc' else 'dec'
--	end as result
--from cte 
--group by studentname

with pre_mark as(
	select *
		,LAG(marks,1)over(partition by studentname order by subject,testdate) prev_marks
	from students
)
select
	studentname
	,case 
		when prev_marks > marks
		then 'decreased'
		when  prev_marks < marks
		then 'increased'
		else 'NULL'
	end as result
from pre_mark