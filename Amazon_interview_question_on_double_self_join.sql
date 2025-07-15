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

--Q. write a SQL to list emp name along with thier manager and and senior manager name
--senior manager is manager's manager


select e.emp_id,e.emp_name,m.emp_name as manager_name,sm.emp_name as senior_manager, 
		m.salary as manager_salary
from emp e
left join emp m on e.manager_id=m.emp_id
left join emp sm on m.manager_id=sm.emp_id
where m. salary>sm.salary


