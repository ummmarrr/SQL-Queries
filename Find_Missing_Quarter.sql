select * from stores;
--M1: using subtraction from total (best)
with cte as(
select
	*
	,CAST(SUBSTRING(Quarter,2,1) AS INT) quarter_no
from stores
)
select 
	Store
	,'Q'+ cast(10-SUM(quarter_no)  as char(2)) missing_quarter
from cte
group by Store

--M2: optimizing the above solution
select 
	Store
	,'Q'+ cast(10-SUM(CAST(SUBSTRING(Quarter,2,1) AS INT))  as char(2)) missing_quarter
from stores
group by Store

--M3: recursive cte
with rec_cte as(
	select 
		distinct store,1 quarter_no from stores
	UNION ALL
	select 
		store,quarter_no+1
	from rec_cte
	where quarter_no<4
)
,new_table as(
	select 
		store, 'Q'+CAST(quarter_no as varchar) edited_quarter
	from rec_cte
)
select n.*
from new_table n
left join 
	STORES s on n.store=s.store and n.edited_quarter=s.Quarter
where s.Quarter is null


--M4: cross join (Best)
select * from STORES
with cte as (
	select 
		distinct s1.Store,s2.Quarter
	from STORES s1, STORES s2
)
select c.*
from STORES s
right join cte c on s.store=c.store and s.Quarter=c.quarter
where s.store is null
