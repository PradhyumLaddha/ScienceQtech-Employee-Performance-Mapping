-- Create a database 
CREATE DATABASE if not exists employee;
USE employee;

-- Query to fetch details from Table
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT 
FROM emp_record_table;

-- Query for employee rating
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2; 

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4; 

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING BETWEEN 2 AND 4; 

-- Query to Concatenate first_name and last_name
SELECT concat(FIRST_NAME, " ", LAST_NAME) AS NAME 
FROM emp_record_table
WHERE DEPT = "FINANCE";

-- Query to list employee who have someone reporting to them
SELECT MANAGER_ID, count(EMP_ID), ROLE AS REPOTERS FROM emp_record_table
GROUP BY MANAGER_ID
ORDER BY count(EMP_ID);

-- Query to list down all the employees from the healthcare and finance departments using union
SELECT EMP_ID, concat (FIRST_NAME, " ", LAST_NAME) AS NAME,  DEPT
FROM emp_record_table 
WHERE DEPT = "FINANCE" 
UNION 
SELECT EMP_ID, concat (FIRST_NAME, " ", LAST_NAME) AS NAME,  DEPT
FROM emp_record_table
WHERE DEPT = "HEALTHCARE"

-- Query to list down employee with ratings
SELECT EMP_ID, FIRST_NAME , LAST_NAME,  ROLE, EMP_RATING , DEPT , MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS
MAX_EMP_RATING FROM emp_record_table

-- Query to calculate the minimum and the maximum salary of the employees in each role
SELECT ROLE, MAX(SALARY) , MIN(SALARY)
FROM emp_record_table
GROUP BY ROLE

-- Query to ssign ranks to each employee based on their experience
SELECT EMP_ID, EXP , RANK () OVER (ORDER BY EXP DESC) 
FROM emp_record_table

-- Query to create a view that displays employees in various countries whose salary is more than six thousand
CREATE VIEW EMPLOYEE_COUNTRIES AS
SELECT EMP_ID, FIRST_NAME , LAST_NAME, COUNTRY , SALARY
FROM emp_record_table
WHERE SALARY > 6000;
SELECT * FROM EMPLOYEE_COUNTRIES

-- Nested Query to find employees with experience of more than ten years
SELECT EMP_ID, FIRST_NAME , LAST_NAME, EXP
FROM emp_record_table
WHERE EXP IN ( SELECT EXP FROM emp_record_table WHERE EXP>10) 
ORDER BY EXP;

-- Query to create a stored procedure to retrieve the details of the employees whose experience is more than three years
DELIMITER &&
CREATE PROCEDURE EMP_EXPERIENCE ()
BEGIN
SELECT * FROM EMP_RECORD_TABLE
WHERE EXP > 3;
END &&

CALL EMP_EXPERIENCE ();

-- Query using stored functions in the project table to check whether the job profile assigned
DROP FUNCTION IF EXISTS JOB_PROFILE
DELIMITER &&
CREATE FUNCTION JOB_PROFILE (EXPERIENCE INT)
RETURNS varchar(2255) DETERMINISTIC 
BEGIN
DECLARE JOB_PROFILE VARCHAR(2255);
IF EXPERIENCE <= 2 THEN
SET JOB_PROFILE = “JUNIOR_DATA_SCIENTIST”;

ELSEIF EXPERIENCE <= 5 THEN
SET JOB_PROFILE = “ASSOCIATE_DATA_SCIENTIST”;

ELSEIF EXPERIENCE <= 10 THEN
SET JOB_PROFILE = “SENIOR_DATA_SCIENTIST”;

ELSEIF EXPERIENCE <=  12 THEN
SET JOB_PROFILE = “LEAD_DATA_SCIENTIST”;
 
ELSEIF EXPERIENCE > 12 THEN
SET JOB_PROFILE = “MANAGER”;

END IF;
RETURN J(OB_PROFILE);
END &&
DELIMITER &&;

SELECT FIRST_NAME , LAST_NAME, DEPT , EXP, ROLE,  JOB_PROFILE(EXP) AS DESIGNATION 
FROM data_science_team 
ORDER BY EXP;

-- Query to Create an index to improve the cost and performance 
CREATE INDEX FIRST_NAME ON emp_record_table (FIRST_NAME(15));

-- Query to calculate the bonus for all the employees, based on their ratings and salaries
SELECT EMP_ID, SALARY, ((SALARY*0.05)*EMP_RATING) AS BONUS
FROM emp_record_table

-- Query calculate the average salary distribution based on the continent and country
SELECT CONTINENT,COUNTRY, AVG(SALARY) 
FROM emp_record_table
GROUP BY CONTINENT,COUNTRY