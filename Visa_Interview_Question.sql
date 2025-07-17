/*
	Say you have access to all the transactions for a given merchant account. 
	Write a query to print the cumulative balance of the merchant account at the end of each day, 
	with the total balance reset back to zero at the end of the month. 
	Output the transaction date and cumulative balance.


	INPUT
		transaction_id	type	amount	transaction_date
			19153	deposit	65.90	2022-07-10 10:00:00.000
			53151	deposit	178.55	2022-07-08 10:00:00.000
			29776	withdrawal	25.90	2022-07-08 10:00:00.000
			16461	withdrawal	45.99	2022-07-08 10:00:00.000
			77134	deposit	32.60	2022-07-10 10:00:00.000

		OUTPUT:
		date	     rol_sum
		2022-07-08	  250.44
		2022-07-10	  348.94
			
*/


-- DDL & DML
CREATE TABLE transactions (
    transaction_id INT,
    type VARCHAR(20) CHECK (type IN ('deposit', 'withdrawal')),
    amount DECIMAL(10, 2),
    transaction_date DATETIME
);

INSERT INTO transactions (transaction_id, type, amount, transaction_date) VALUES
(19153, 'deposit', 65.90, '2022-07-10 10:00:00'),
(53151, 'deposit', 178.55, '2022-07-08 10:00:00'),
(29776, 'withdrawal', 25.90, '2022-07-08 10:00:00'),
(16461, 'withdrawal', 45.99, '2022-07-08 10:00:00'),
(77134, 'deposit', 32.60, '2022-07-10 10:00:00');


---
SELECT * FROM transactions

WITH CTE AS(
	SELECT	
		CAST( transaction_date as DATE) date
		,SUM(CASE WHEN type='wihtdrawal' THEN -1*amount ELSE amount END) amount
	FROM transactions
	GROUP BY CAST( transaction_date as DATE)
)

SELECT
	date
	,SUM(amount)OVER(PARTITION BY YEAR(date),MONTH(date) ORDER BY date) rol_sum
FROM CTE 