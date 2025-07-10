/*
	there is a phonelog table that has information about callers' call history.
	write a SQL to find out callers whose first and last call was to the same person on a given day.
*/
-----------------------------------------------------------------------------------------------------
--with modifycte as (
--	select * 
--		,datepart(day,datecalled) whichday
--		,row_number()over(partition by callerid,datepart(day,datecalled) order by datepart(hour,datecalled)) rn
--	from phonelog
--)
--,smcte as(
--	select *
--		,SUM(case when rn=1 then 1 else 0 end)over(order by callerid,datepart(day,datecalled)) sm	
--	from modifycte
--)
--select *
--from smcte

select * from phonelog;
with firstlastcallcte as(
	select 
		callerid
		,cast(datecalled as date) date
		,min(datecalled) firstcalldate
		,max(datecalled) lastcalldate
	from phonelog
	group by callerid,cast(datecalled as date) 
)

select 
	f.callerid
	,f.date
	,p1.recipientid firstcallreceiver
	,p2.recipientid lastcallreceiver
from 
	firstlastcallcte f
	inner join phonelog p1 on p1.callerid=f.callerid and p1.datecalled=f.firstcalldate
	inner join phonelog p2 on p2.callerid=f.callerid and p2.datecalled=f.lastcalldate
where p1.recipientid=p2.recipientid