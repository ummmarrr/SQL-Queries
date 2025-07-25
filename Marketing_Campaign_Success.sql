/*
Marketing Campaign Success:
	You have a table of in-app purchases by user. Users that make their first in-app purchase 
	are placed in marketing campaign where they see call-to-actions for more in-app purchases.
 
	Find the number of users that made additional in-app purchases due to the success of the marketing campaign.
	The marketing campaign doesn't start until one day after the initial in-app purchase so users that only made one or 
	multiple purchases on the first day do not count, nor do we count users that over time purchase only the products they 
	purchased on the first day.


	INPUT:
user_id  created_at  product_id  quantity  price
	10	2019-01-01	101	3	55
	10	2019-01-02	119	5	29
	10	2019-03-31	111	2	149
	11	2019-01-02	105	3	234
	11	2019-03-31	120	3	99
	12	2019-01-02	112	2	200
	12	2019-03-31	110	2	299
	13	2019-01-05	113	1	67
	13	2019-03-31	118	3	35
	14	2019-01-06	109	5	199
	14	2019-01-06	107	2	27
	14	2019-03-31	112	3	200
	15	2019-01-08	105	4	234
	15	2019-01-09	110	4	299
	15	2019-03-31	116	2	499
	16	2019-01-10	113	2	67
	16	2019-03-31	107	4	27
	17	2019-01-11	116	2	499
	17	2019-03-31	104	1	154
	18	2019-01-12	114	2	248
	18	2019-01-12	113	4	67
	19	2019-01-12	114	3	248
	20	2019-01-15	117	2	999
	21	2019-01-16	105	3	234
	21	2019-01-17	114	4	248
	22	2019-01-18	113	3	67
	22	2019-01-19	118	4	35
	23	2019-01-20	119	3	29
	24	2019-01-21	114	2	248
	25	2019-01-22	114	2	248
	25	2019-01-22	115	2	72
	25	2019-01-24	114	5	248
	25	2019-01-27	115	1	72
	26	2019-01-25	115	1	72
	27	2019-01-26	104	3	154
	28	2019-01-27	101	4	55
	29	2019-01-27	111	3	149
	30	2019-01-29	111	1	149
	31	2019-01-30	104	3	154
	32	2019-01-31	117	1	999
	33	2019-01-31	117	2	999
	34	2019-01-31	110	3	299
	35	2019-02-03	117	2	999
	36	2019-02-04	102	4	82
	37	2019-02-05	102	2	82
	38	2019-02-06	113	2	67
	39	2019-02-07	120	5	99
	40	2019-02-08	115	2	72
	41	2019-02-08	114	1	248
	42	2019-02-10	105	5	234
	43	2019-02-11	102	1	82
	43	2019-03-05	104	3	154
	44	2019-02-12	105	3	234
	44	2019-03-05	102	4	82
	45	2019-02-13	119	5	29
	45	2019-03-05	105	3	234
	46	2019-02-14	102	4	82
	46	2019-02-14	102	5	29
	46	2019-03-09	102	2	35
	46	2019-03-10	103	1	199
	46	2019-03-11	103	1	199
	47	2019-02-14	110	2	299
	47	2019-03-11	105	5	234
	48	2019-02-14	115	4	72
	48	2019-03-12	105	3	234
	49	2019-02-18	106	2	123
	49	2019-02-18	114	1	248
	49	2019-02-18	112	4	200
	49	2019-02-18	116	1	499
	50	2019-02-20	118	4	35
	50	2019-02-21	118	4	29
	50	2019-03-13	118	5	299
	50	2019-03-14	118	2	199
	51	2019-02-21	120	2	99
	51	2019-03-13	108	4	120
	52	2019-02-23	117	2	999
	52	2019-03-18	112	5	200
	53	2019-02-24	120	4	99
	53	2019-03-19	105	5	234
	54	2019-02-25	119	4	29
	54	2019-03-20	110	1	299
	55	2019-02-26	117	2	999
	55	2019-03-20	117	5	999
	56	2019-02-27	115	2	72
	56	2019-03-20	116	2	499
	57	2019-02-28	105	4	234
	57	2019-02-28	106	1	123
	57	2019-03-20	108	1	120
	57	2019-03-20	103	1	79
	58	2019-02-28	104	1	154
	58	2019-03-01	101	3	55
	58	2019-03-02	119	2	29
	58	2019-03-25	102	2	82
	59	2019-03-04	117	4	999
	60	2019-03-05	114	3	248
	61	2019-03-26	120	2	99
	62	2019-03-27	106	1	123
	63	2019-03-27	120	5	99
	64	2019-03-27	105	3	234
	65	2019-03-27	103	4	79
	66	2019-03-31	107	2	27
	67	2019-03-31	102	5	82

	OUTPUT:
	count_of_userid
	29

*/

select * from marketing_campaign;

WITH CTE AS(
	SELECT *
		,DENSE_RANK()OVER(PARTITION BY user_id ORDER BY created_at) RN
	FROM marketing_campaign
)
,except_first_purchase AS(
	SELECT *
	FROM CTE
	WHERE RN>1
)
,first_purchase AS(
	SELECT *
	FROM CTE
	WHERE RN=1
)

SELECT count(e.user_id) count_of_userid
FROM except_first_purchase e
	 LEFT JOIN first_purchase fp
ON	 e.user_id=fp.user_id 
	 AND e.product_id=fp.product_id
WHERE fp.user_id is null