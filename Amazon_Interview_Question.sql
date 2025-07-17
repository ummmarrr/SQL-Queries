--Q. write a SQL to list emp name along with thier manager and and senior manager name
--(senior manager is manager's manager)

/*
	INPUT: 

	emp_id	emp_name	department_id	salary	manager_id	emp_age
		1	Ankit		100				10000			4	39
		2	Mohit		100				15000			5	48
		3	Vikas		100				12000			4	37
		4	Rohit		100				14000			2	16
		5	Mudit		200				20000			6	55
		6	Agam		200				12000			2	14
		7	Sanjay		200				9000			2	13
		8	Ashish		200				5000			2	12
		9	Mukesh		300				6000			6	51
		10	Rakesh		500				7000			6	50

	OUTPUT:
	emp_name  manager_name	M_managers_name
		Ankit	Rohit	Mohit
		Mohit	Mudit	Agam
		Vikas	Rohit	Mohit
		Rohit	Mohit	Mudit
		Mudit	Agam	Mohit
		Agam	Mohit	Mudit
		Sanjay	Mohit	Mudit
		Ashish	Mohit	Mudit
		Mukesh	Agam	Mohit
		Rakesh	Agam	Mohit
*/

--DDL & DML
create table emp(
emp_id int,
emp_name varchar(20),
department_id int,
salary int,
manager_id int,
emp_age int);

insert into emp
values
(1, 'Ankit', 100,10000, 4, 39);
insert into emp
values (2, 'Mohit', 100, 15000, 5, 48);
insert into emp
values (3, 'Vikas', 100, 12000,4,37);
insert into emp
values (4, 'Rohit', 100, 14000, 2, 16);
insert into emp
values (5, 'Mudit', 200, 20000, 6,55);
insert into emp
values (6, 'Agam', 200, 12000,2, 14);
insert into emp
values (7, 'Sanjay', 200, 9000, 2,13);
insert into emp
values (8, 'Ashish', 200,5000,2,12);
insert into emp
values (9, 'Mukesh',300,6000,6,51);
insert into emp
values (10, 'Rakesh',500,7000,6,50);
---------------------------------------

SELECT * 
FROM emp

SELECT 
	e.emp_name, m1.emp_name AS manager_name, m2.emp_name AS M_managers_name
FROM 
	emp m1
	RIGHT JOIN emp e ON e.manager_id=m1.emp_id
	LEFT JOIN emp m2 ON m1.manager_id=m2.emp_id
