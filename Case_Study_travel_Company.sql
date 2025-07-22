select * from booking_table
select * from user_table

/* 
	INPUT:
Booking_id  Booking_date  User_id  Line_of_business
	b1	2022-03-23	u1	Flight
	b2	2022-03-27	u2	Flight
	b3	2022-03-28	u1	Hotel
	b4	2022-03-31	u4	Flight
	b5	2022-04-02	u1	Hotel
	b6	2022-04-02	u2	Flight
	b7	2022-04-06	u5	Flight
	b8	2022-04-06	u6	Hotel
	b9	2022-04-06	u2	Flight
	b10	2022-04-10	u1	Flight
	b11	2022-04-12	u4	Flight
	b12	2022-04-16	u1	Flight
	b13	2022-04-19	u2	Flight
	b14	2022-04-20	u5	Hotel
	b15	2022-04-22	u6	Flight
	b16	2022-04-26	u4	Hotel
	b17	2022-04-28	u2	Hotel
	b18	2022-04-30	u1	Hotel
	b19	2022-05-04	u4	Hotel
	b20	2022-05-06	u1	Flight

*/

/*
	Q1.
		OUTPUT:
Segment	Total_user_count User_who_booked_flight_in_2022
	s1	3	2
	s2	2	2
	s3	5	1

*/
SELECT   U.Segment,COUNT(DISTINCT U.User_id) Total_user_count
		 ,COUNT(DISTINCT CASE WHEN Line_of_Business='Flight' AND MONTH(B.booking_date)=4 
			 AND YEAR(B.booking_date)=2022 THEN B.User_id END) User_who_booked_flight_in_2022
FROM	 booking_table B
		 RIGHT JOIN user_table U
ON		 B.User_id=U.User_id
GROUP BY U.Segment

------------------------------------------------------------------------------------------------

/*
	Q2. Write a query to identify first user whose first booking was hotel booking

	OUTPUT:
		Booking_id
		b8
*/

--M1:
select * from booking_table order by user_id,booking_date

WITH CTE AS(
	SELECT *
		,ROW_NUMBER()OVER(PARTITION BY user_id order by booking_date) RN
	FROM booking_table
)
SELECT TOP 1 Booking_id
FROM CTE
WHERE RN=1 AND line_of_business='Hotel'
ORDER BY booking_date;


--M2:
WITH FVCTE AS(
	SELECT *
		  ,FIRST_VALUE(line_of_business)over(partition by user_id order by booking_date) fv
	FROM booking_table
)
SELECT Top 1 user_id
FROM FVCTE 
WHERE fv='Hotel'
ORDER BY booking_date

------------------------------------------------------------------------------------------------

/*
	Q3. Write a query to calculate days between the first and lasst booking of each user

	OUTPUT:

	user_id	datedifff
	u1	44
	u2	32
	u4	34
	u5	14
	u6	16

*/
--WITH  CTE AS(
--	SELECt *
--		,first_value(booking_date)OVER(PARTITION BY user_id ORDER BY booking_date ASC) fv
--		,last_value(booking_date)OVER(
--			PARTITION BY user_id 
--			ORDER BY booking_date DESC
--			ROWS BETWEEN Unbounded preceding AND Unbounded following) lv

--	FROM booking_table
--)
--SELECT user_id
--	  ,DATEDIFF(DAY,fv ,lv) AS diff
--FROM CTE 
	SELECT user_id, 
		   DATEDIFF(DAY,min(booking_date),max(booking_date))datedifff
	FROM booking_table
	group by user_id


------------------------------------------------------------------------------------------------

/*
	Q4. Write a query to count number of flights and hotel booking in each of the user segment in the year 2022		

	OUTPUT:
*/
select U.segment
	,SUM(CASE WHEN line_of_business='Flight' THEN 1 ELSE 0 END) no_of_flights 
	,SUM(CASE WHEN line_of_business='Hotel' THEN 1 ELSE 0 END) no_of_hotels
from booking_table B
	 inner join user_table U
ON B.user_id=U.user_id
WHERE YEAR(booking_date)=2022
GROUP BY U.segment