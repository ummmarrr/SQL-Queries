select * from call_details
--M1: using having clause		
select 
	call_number
from call_details
where call_type<>'SMS'
group by call_number
having 
	count(distinct call_type)=2 AND
	SUM(case when call_type='OUT' THEN call_duration END) > SUM(case when call_type='INC' THEN call_duration END)


--M2: Using Join

SELECT 
	c1.call_number
FROM call_details c1
INNER JOIN call_details c2
    ON c1.call_number = c2.call_number
WHERE c1.call_type = 'OUT' AND c2.call_type = 'INC'
group by c1.call_number
having SUM(c1.call_duration) > SUM(c2.call_duration)