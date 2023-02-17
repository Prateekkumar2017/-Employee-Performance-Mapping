create database employee;
use employee;
select * from emp_record;
select * from data_science_team;

#Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
select emp_id , first_name , last_name , gender , dept from emp_record;

#Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
#less than two
#greater than four 
#between two and four
select emp_id , first_name , last_name , gender , dept , emp_rating from emp_record
where emp_rating < 2;
select emp_id , first_name , last_name , gender , dept , emp_rating from emp_record
		where emp_rating > 4;
select emp_id , first_name , last_name , gender , dept , emp_rating from emp_record
		where emp_rating between 2 and 4;

#Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
select concat(first_name , " " , last_name) AS NAME from emp_record
where dept = "FINANCE";


#Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
select concat(e.first_name , " " , e.last_name) as Employee_name ,
	concat(m.first_name , " " , m.last_name) as Manager  from emp_record e 
		left outer join emp_record m
	on e.Manager_id = m.emp_id;
    
    
#Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
select emp_id , first_name as name , dept from emp_record where dept="healthcare"
UNION
select emp_id , first_name , dept from emp_record where dept="finance";


#Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating 
#along with the max emp rating for the department.
SELECT  m.EMP_ID,m.FIRST_NAME,m.LAST_NAME,m.ROLE,m.DEPT,m.EMP_RATING,max(m.EMP_RATING)
OVER
(PARTITION BY m.DEPT)AS "MAX_DEPT_RATING"
FROM emp_record m 
ORDER BY DEPT;

#Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
select emp_id , first_name , last_name ,  ROLE , min(salary) , max(salary)  from emp_record
where role in ('President',"Lead","Senior Data Scientist" , "Manager","Associate Data Scientist" , "Junior Data Scientist")
GROUP BY role;


#Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select first_name , last_name , exp , rank () over (order by exp desc) as "Rank"
from emp_record;


#Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
create view emp_country as
		select concat(first_name , " " , last_name) AS "EMP NAME" , country , salary from emp_record
		where salary > 6000;
select * from emp_country;


#Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
select emp_id, concat(first_name , " " , last_name)AS "EMP NAME" , exp from emp_record
	where emp_id in (select manager_id from emp_record) ;


#Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
drop procedure if exists empl_exp;

delimiter $$
create procedure Empl_exp()
begin
select * from emp_record 
WHERE EXP > 3;
end $$

CALL Empl_exp();	

/*Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the 
organization’s set standard.*/
drop procedure if exists assigned_role;

delimiter $$
create function assigned_role(exp int)
returns varchar(40)
deterministic
begin
declare assigned_role varchar(40);
if 
exp>10 and 13 then
set assigned_role='Lead Data Scientist';
elseif exp>5 and 10 then
set assigned_role='Senior Data Scientist';
elseif exp>2 and 5 then
set assigned_role='Associate Data Scientist';
elseif exp<=2 then 
set assigned_role='Junior Data Scientist';
end if;
return(assigned_role);
end $$
select exp,assigned_role(exp) from data_science_team;


/*Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table 
after checking the execution plan.*/
create index index_first_name
on emp_record(First_Name(20));
select * from emp_record
where First_name='Eric';

/*
Write a query to calculate the bonus for all the employees, based on their ratings and salaries 
(Use the formula: 5% of salary * employee rating)*/
select emp_id , concat(first_name,' ' , last_name) as Name , (salary*0.5*emp_rating)as BONUS from emp_record;
update emp_record set salary= (select salary + (select salary*0.5*emp_rating));
select * from emp_record;

/*Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.*/
select emp_id , concat(first_name,' ' , last_name) as Name , salary, country, continent , 
avg(salary)over(partition by country) as Average_Salary_Country,
avg(salary)over(partition by continent)as Average_Salary_Continent,
Count(*)over(partition by country) as Count_by_Country,
Count(*)over(partition by continent)as Count_by_Continent
from emp_record;

