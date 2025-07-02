select 
	student_id
from exams
where subject='Chemistry' OR subject='Physics'
group by student_id
having count(distinct marks)=1 and count(subject)=2