/*
	Q. problem statement: we have a table which stores data of multiple sections. 
		every section hay 3 numbers we have to find top 4 numbers from any 2 sections (2 numbers each) 
		whose addition should be maximum so in this case we will choose section b where we have 19(10+9) 
		then we need to choose either C or D becaue both has sum of 18 but in D we have 10 which is big from 
		9 so we will give priority to D

	
	INPUT:
		section	number
		A		5
		A		7
		A		10
		B		7
		B		9
		B		10
		C		9
		C		7
		C		9
		D		10
		D		3
		D		8

	OUTPUT:
		section	number
		B		10
		B		9
		D		10
		D		8

*/




WITH CTE AS(
	SELECT *
		,MAX(number)OVER(PARTITION BY section ORDER BY number DESC) maxi
		,ROW_NUMBER()OVER(PARTITION BY section ORDER BY number DESC) RN
	FROM section_data
)
,CTE2 AS(
	SELECT *
		,SUM(number)OVER(PARTITION BY section) AS sm
	FROM CTE
	WHERE RN<3
)
,CTE3 AS(
	SELECT *
		,DENSE_RANK()OVER(ORDER BY sm DESC,maxi DESC) dr
	FROM CTE2
)
SELECT 
	section,number
FROM CTE3
WHERE dr<3