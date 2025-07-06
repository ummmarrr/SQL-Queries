select 
	player_groups
	max (case when city='Bangalore' then name end) as Bangalore
	max(case when city='Mumbai' then name end as Mumbai
	min (case when city 'Delhi' then name end) as Delhi
from
	select
		row_number() over (partition by city order by name asc as player groups
	from 
		players_location) A
	group by 
		player_groups
	order by 
		player_groups