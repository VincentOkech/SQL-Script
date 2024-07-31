CREATE DATABASE projects;

USE projects;


SELECT * FROM hr;


SET sql_safe_updates=0;
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE hr;

UPDATE hr
SET birthdate = CASE 
  WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
  ELSE NULL
END;
  
  select birthdate from hr;
  
  alter table hr 
  modify column birthdate DATE;
  
  select birthdate from hr;
  
  UPDATE hr
  SET hire_date = CASE 
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
  END;
  
  UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN STR_TO_DATE(hire_date, '%m/%d/%Y')
    WHEN hire_date LIKE '%-%' THEN
        CASE
            WHEN hire_date LIKE '____-__-__' THEN hire_date  -- Already in YYYY-MM-DD format
            ELSE STR_TO_DATE(hire_date, '%m-%d-%Y')
        END
    ELSE NULL
END;

 describe hr; 
 
alter table hr 
  modify column hire_date DATE;
  
select termdate from hr;
  
UPDATE hr 
SET termdate = CASE
    WHEN termdate = ' ' OR termdate = '' THEN NULL
    ELSE DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
END;
-- WHERE termdate IS NOT NULL AND termdate != ' ' AND termdate != '';

alter table hr 
modify column termdate DATE;


select * from hr;

ALTER TABLE hr 
add column age INT;

UPDATE hr 
set age = timestampdiff(YEAR, birthdate, CURDATE());

select birthdate, age from hr;


select min(age) as youngest, max(age) as oldest
from hr;

select count(*) from hr
where age <18;


DELETE FROM hr
WHERE age < 18
LIMIT 1000;



select gender, count(*) AS count
from hr
where termdate is null
group by gender;


select race, COUNT(*)
from hr
where termdate is null
group by race
order by count(*) desc;


select min(age) as youngest,
max(age) as oldest
from hr
where termdate is null;

select 
	case when age >=18 and age <=24 then '18-24'
		when age >=25 and age <=34 then '25-34'
		when age >=35 and age<=54 then '35-54'
		when age >=55 and age<=64 then '55+'
        ELSE 'weird'
	
    END AS age_group,
    count(*) as COUNT
from hr
where termdate is null
group by age_group
order by age_group;

select gender, 
	case when age >=18 and age <=24 then '18-24'
		when age >=25 and age <=34 then '25-34'
		when age >=35 and age<=54 then '35-54'
		when age >=55 and age<=64 then '55+'
        ELSE 'weird'
	
    END AS age_group,
    count(*) as COUNT
from hr
where termdate is null
group by age_group, gender
order by age_group;

select location, count(*)
from hr
where termdate is null
group by location;


select round(avg((datediff(termdate, hire_date))/365),0) as average_length_employment
 from hr 
 where termdate <= curdate() and termdate is not null
 ;
 
 
 select department, gender, count(*) as numbers
 from hr
 where termdate is null
 group by department, gender
 order by department;


select jobtitle, count(*) as numbers
from hr
 where termdate is null
 group by jobtitle
 order by jobtitle desc;
 
 
 select department, count(*) as Numbers
 from hr
 where termdate is not null 
 group by department 
 order by Numbers desc;

with subquery as
(select department, count(*) as total_count,
SUM(case when termdate is not null and termdate <=curdate() then 1 else 0 end) as terminated_count
from hr
where age > 18
group by department)

select department, total_count, terminated_count, terminated_count/total_count as termination_rate
from subquery
order by termination_rate desc ;


 

select location_state, count(*) as numbers 
from hr 
where termdate is not null 
group by location_state 
order by numbers desc;


select 
 year , hires, terminations,
 hires - terminations as net_change, 
 round((hires - terminations/hires)* 100, 2) as net_change_percent
 from (
 select year (hire_date) as year,
 count(*) as hires,
 sum(case when termdate is not null and termdate <=curdate() then 1 else 0 end) as terminations 
 from hr
 where termdate is not null
 group by year(hire_date)
 )
 as subqueryy
 order by year asc;
 
 
 
 
 select department, round(avg(datediff(termdate, hire_date)/365), 0) as avg_tenure 
 from hr 
 where termdate <=curdate() and termdate is not null 
 group by department;
 