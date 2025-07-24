/*
	Find the column
employeeid, totalentry, totallogin, totallogout, latestlogin, latestlogout, employee_default_phone_number
*/


/*
		DDL AND DML

-- Create table: employee_checkin_details
CREATE TABLE employee_checkin_details (
    employeeid INT NOT NULL,
    entry_details VARCHAR(10) NOT NULL, -- e.g., 'login' or 'logout'
    timestamp_details DATETIME2(2) NOT NULL
);

-- Create table: employee_details
CREATE TABLE employee_details (
    employeeid INT NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    isdefault BIT NOT NULL  -- BIT is used for boolean in T-SQL
);
-- Insert data into employee_checkin_details
INSERT INTO employee_checkin_details (employeeid, entry_details, timestamp_details) VALUES
(1000, 'login', '2023-06-16 01:00:15.34'),
(1000, 'login', '2023-06-16 02:00:15.34'),
(1000, 'login', '2023-06-16 03:00:15.34'),
(1000, 'logout', '2023-06-16 12:00:15.34'),
(1001, 'login', '2023-06-16 01:00:15.34'),
(1001, 'login', '2023-06-16 02:00:15.34'),
(1001, 'login', '2023-06-16 03:00:15.34'),
(1001, 'logout', '2023-06-16 12:00:15.34');

-- Insert data into employee_details
INSERT INTO employee_details (employeeid, phone_number, isdefault) VALUES
(1001, '9999', 0),
(1001, '1111', 0),
(1001, '2222', 1),
(1003, '3333', 0);
*/

select * from employee_checkin_details order by timestamp_details asc
select * from employee_details

--employeeid, totalentry, totallogin, totallogout, latestlogin, latestlogout, employee_default_phone_number
SELECT e.employeeid
		,ed.phone_number
		,count(1) totalentry
		,SUM(CASE WHEN e.entry_details='login' THEN 1 ELSE 0 END) totallogin
		,SUM(CASE WHEN e.entry_details='logout' THEN 1 ELSE 0 END) total_logout
		,MIN(CASE WHEN e.entry_details='login' THEN e.timestamp_details END) latestlogin
		,MIN(CASE WHEN e.entry_details='logout' THEN e.timestamp_details END) latestlogout
		--,ed.phone_number AS employee_default_phone_number
FROM employee_checkin_details e
		LEFT JOIN employee_details ed
ON e.employeeid=ed.employeeid AND ed.isdefault=1

GROUP BY e.employeeid,ed.phone_number