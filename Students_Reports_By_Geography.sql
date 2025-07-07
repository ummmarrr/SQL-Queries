/*        INPUT
		name    city
	1   Sachin  Mumbai
	2   Virat   Delhi
	3   Rahul   Bangalore
	4   Rohit   Mumbai
	5   Mayank  Bangalore
		 OUTPUT
	Bangalore	Mumbai		Delhi
1	 Mayank     Rohit       Virat
2    Rahul		Sachin		NULL
*/
select * from players_location;
with cte as(
	select
		rank()over(partition by city order by name) rn
		, *
	from players_location
)

select
	
	max(case when city='Bangalore' then name END) as Bangalore
	,max(case when city='Mumbai' then name END) as Mumbai
	,max(case when city='Delhi' then name END) as Delhi
from cte 
group by rn
order by rn