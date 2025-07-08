--business_city table has data from the day udaan has started operation
--write a SQL to identify yearwise count of new cities where udaan started their operations
select * from business_city


select year(b1.business_date) year
	  ,count(case when b2.city_id is NULL THEN 1 END) new_cities
from 
	business_city b1
	left join business_city b2
	on b1.city_id=b2.city_id AND year(b1.business_date)>year(b2.business_date)
where b2.city_id is NULL
group by year(b1.business_date)