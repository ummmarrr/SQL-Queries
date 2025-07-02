--Google SQL interview question
--find companies who have atleast 2 users who speks English and German both the languages
with cte as(
	select 
		user_id
		,avg(company_id) company
		,rank()over(partition by company_id order by user_id) no_of_user
	from company_users
	where language in ('German','English')
	group by user_id,company_id
	having count(language)=2 
)

select company
from cte
where no_of_user=2