select * from brands;
--select *
--from brands b1,brands b2 
--where b2.brand_name in('5-star','britannia')

WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM brands
)
,cte2 as(
	SELECT * 
		,LEAD(rn,1,99999)over(order by (select NULL)) nextrn
	FROM cte 
	where category<> 'NULL'
)
select c2.category,c1.brand_name
from	
	cte c1
	inner join cte2 c2
	on c1.rn between c2.rn and c2.nextrn-1