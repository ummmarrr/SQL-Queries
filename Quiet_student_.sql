/*	Write an SQL query to report the students (student_id, student_name) being "quiet" in ALL exams.
	A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score in any of the exam.
	Don't return the student who has never taken any exam. Return the result table ordered by student_id.
*/
--select * from students;
--select * from exams;
with joincte as(
	select e.*
	from	
		students s
		inner join exams e
		on s.student_id=e.student_id
)

,minmaxcte as(
select
	exam_id
	,min(score) mini
	,max(score) maxi
from exams
group by exam_id
)
,lastfilter as(
	select
		j.student_id,j.score,m.exam_id
		,ISNULL(m.exam_id,-1) filtercol
	from 
		joincte j
		left join minmaxcte m 
		on j.exam_id=m.exam_id AND j.score<>mini AND j.score<>maxi
)
select student_id
from lastfilter
group by student_id
having min(filtercol)<>-1 