--write a query to display the records which have 3 or more consecutive rows
--with the amount of people more than 100 (inclusive) each day
/*
id  visit_date  no_of_people
1	2017-07-01	10
2	2017-07-02	109
3	2017-07-03	150
4	2017-07-04	99
5	2017-07-05	145
6	2017-07-06	1455
7	2017-07-07	199
8	2017-07-08	188
*/


with consec_cte as(
	select * 
		,ROW_NUMBER()over(order by id) rn
		,id - ROW_NUMBER()over(order by id) diff
	from stadium
	where no_of_people>=100
)
,valid_cte as(
	select diff
	from consec_cte
	group by diff
	having count(diff)>2
)
select c.id,c.visit_date,c.no_of_people 
from 
	valid_cte v
	inner join consec_cte c
	on v.diff=c.diff

