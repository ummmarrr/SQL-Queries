/*
	Question:
		write a query to print total rides and profit rides for each driver
		profit ride is when the end location of current ride is same as start location on next ride

	INPUT:
	id	     start_time	          end_time	  start_loc	end_loc
	dri_1	09:00:00.0000000	09:30:00.0000000	a	b
	dri_1	09:30:00.0000000	10:30:00.0000000	b	c
	dri_1	11:00:00.0000000	11:30:00.0000000	d	e
	dri_1	12:00:00.0000000	12:30:00.0000000	f	g
	dri_1	13:30:00.0000000	14:30:00.0000000	c	h
	dri_2	12:15:00.0000000	12:30:00.0000000	f	g
	dri_2	13:30:00.0000000	14:30:00.0000000	c	h


	OUTPUT:

		id		profit_ride 	total_rides
		dri_1	1				5
		dri_2	0				2

*/
---------------------------------------------------------------------------------------
select * from drivers;
--M1:
WITH rncte as(
	SELECT 
		*
		,count(1)OVER(partition by id order by end_time) total_rides
		,ROW_NUMBER()OVER(PARTITION BY id ORDER BY end_time) RN
	FROM drivers
)
,CTE AS(
	SELECT r1.id,count(1) profit_ride
	FROM rncte r1
		 INNER JOIN rncte r2
	ON r1.end_loc=r2.start_loc AND r1.RN=r2.RN-1
	GROUP BY r1.id
)
SELECT R.id,MAX(ISNULL(C.profit_ride,0)) profit_ride,MAX(R.total_rides) total_rides
FROM CTE C 
	RIGHT JOIN rncte R
	ON C.id=R.id
GROUP BY R.id

--M2: 
WITH precte AS(
	SELECT
		*
		,LAG(end_loc)OVER(PARTITION BY id order by end_time) preend
	FROM drivers
)
SELECT
	id
	,SUM(CASE WHEN start_loc=preend THEN 1 ELSE 0 END) profit_ride
	,COUNT(id) total_ride
FROM precte 
GROUP BY id