SELECT * FROM purchase_history;


WITH CTE AS(
	SELECT userid
	FROM purchase_history
	GROUP BY userid
	HAVING COUNT(distinct purchasedate)>1
) 
--,NCTE AS(
--	SELECT userid
--	FROM purchase_history
--	GROUP BY userid,productid
--	HAVING COUNT(DISTINCT purchasedate)>1
--)
SELECT userid
FROM CTE
WHERE userid NOT IN(
	SELECT userid
	FROM purchase_history
	GROUP BY userid,productid
	HAVING COUNT(DISTINCT purchasedate)>1
)