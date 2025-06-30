SELECT * FROM activity order by event_date
----------------------------------------------------------------------

--1. Find total active users each day
select event_date,count(distinct user_id)
from activity
group by event_date
----------------------------------------------------------------------

--2.Find total active users each week
select DATEPART(week,event_date),count(distinct user_id)
from activity
group by DATEPART(week,event_date)
----------------------------------------------------------------------

--3. date wise total number of users who made the purchase same day they installed the app
--M1: Non-optimized
with cte as(
	select event_date, user_id, count(event_name) no_of_distinct_event
	from activity
	group by event_date, user_id
	having count(event_name)=2
)
,cte2 as(
	select event_date, count(user_id) total
	from cte 
	group by event_date
)
, cte_date as(
	select distinct event_date from activity
)

select cd.event_date, ISNULL(total,0) required_col
from cte_date cd
left join cte2 c on cd.event_date=c.event_date

--M2:Optimized
select * from activity

select event_date,count(total_user) req_user
from(
	select event_date,user_id,case when count(distinct event_name)=2 then USER_ID else NULL end total_user
	from activity
	group by event_date,user_id
) a
group by event_date
----------------------------------------------------------------------

--4. percentage of paid users in India, USA and any other country should be tagged as others
'''
	1. filter people who purchased
	2. Group by country
'''
--M1 Non optimized
WITH paid_cte AS (
    SELECT country, COUNT(1) AS total_paid_user
    FROM activity
    WHERE event_name = 'app-purchase'
    GROUP BY country
)
,paid_cte2 as(
SELECT 
    CASE 
        WHEN country = 'India' THEN 'India'
        WHEN country = 'USA' THEN 'USA'
        ELSE 'Others' END AS mapped_country,
    
    CASE 
        WHEN country = 'India' THEN 1
        WHEN country = 'USA' THEN 2
        ELSE 3 END AS new_col
FROM paid_cte
)
select mapped_country, count(new_col) total_people
from paid_cte2
group by mapped_country


--M2 optimized
WITH paid_cte AS (
    SELECT COUNT(1) AS total_paid_user
	,case when country in ('India','USA') Then country else 'others' end AS mapped_country
    FROM activity
    WHERE event_name = 'app-purchase'
    GROUP BY case when country in ('India','USA') Then country else 'others' end
)
,total_cnt as(
	select SUM(total_paid_user) total from paid_cte
)
select p.mapped_country, ROUND(p.total_paid_user*100.0/t.total,0) req_percentage
from paid_cte p,total_cnt t
--------------------------------------------------------------------



--5. Question 5: Among all the users who installed the app on a given day, 
--   how many did in app purchared on the very next day . day wise result

--M1  -->Non optimized
select * from activity order by event_date
with nextday as(
	select b.event_date
	from activity a
	inner join activity b on a.user_id=b.user_id 
	where a.event_name='app-installed' and b.event_name='app-purchase' and DATEDIFF(DAY,a.event_date,b.event_date)=1
)
, alldate as(
	select distinct event_date from activity
)

select a.event_date,count(n.event_date) as total
from alldate a 
left join nextday n on a.event_date=n.event_date
group by a.event_date

--M2 Optimized
select * from activity

with prevaddedcte as(
	select *
	,LAG(event_name,1)over(partition by user_id order by event_date) prev_event
	,LAG(event_date,1)over(partition by user_id order by event_date) prev_date
	from activity
)
select event_date,
count(case when event_name='app-purchase' and prev_event='app-installed' and datediff(day,prev_date,event_date)=1 then user_id else NULL end) total_req_user
from prevaddedcte
group by event_date