--select * from subscriber;

--with filtering_cte as(
--	select /*s1.sender,s1.receiver,*/
--		s2.sender,s2.receiver, s1.sms_no sms1,s2.sms_no sms2
--	from subscriber s1
--	inner join subscriber s2 
--	on s1.receiver=s2.sender and s2.receiver=s1.sender 
--	where s1.sms_no > s2.sms_no
--)
--select
--	sender
--	,receiver
--	,sms1+sms2 total_sms

--from filtering_cte

--find total no of messages exchanged between each person per day
select * from subscriber;
with cte as(
	select
		case
			when sender<receiver 
				THEN sender
				else receiver 
		end as A
		,case
			when sender>receiver 
				THEN sender
				else receiver 
		end as B
		,sms_no as sms
	from subscriber
)
select A,B, SUM(sms) total_sms
from cte
group by A,B