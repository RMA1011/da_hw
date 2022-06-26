--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

with all_marks as (select name, marks, grade from students join grades on marks >= min_mark and marks <= max_mark),
high_grades as (select name, grade, marks from all_marks where grade >=8 order by grade desc, name asc),
low_grades as (select null, grade, marks from all_marks where grade < 8 order by grade desc, marks asc)
select name, grade, marks from (select * from high_grades union all select * from low_grades);

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem
-- https://www.postgresql.org/docs/14/tablefunc.html

select Doctor, Professor, Singer, Actor
from (select row_number() over (partition by occupation order by name asc) as row_order, name, occupation
from occupations) pivot(max(name) for occupation in ('Doctor' as Doctor,'Professor' as Professor,'Singer' as Singer,'Actor' as Actor)) order by row_order asc;


--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct(city) as City from Station where (City NOT LIKE 'A%') and (City NOT LIKE 'O%') and (City NOT LIKE 'E%') and (City NOT LIKE 'I%') and (City NOT LIKE 'U%'); 
-- но есть более устойчивый подход
select distinct(city) as City from Station where (substr(City, 1,1) not in ('A','O','I','E','U'));

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem
select distinct(city) as City from Station where (substr(City, -1) not in ('a','o','i','e','u'));

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem
select distinct(city) as City from Station where (substr(City, 1,1) not in ('A','O','I','E','U')) or (substr(City, -1) not in ('a','o','i','e','u'));

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem
select distinct(city) as City from Station where (substr(City, 1,1) not in ('A','O','I','E','U')) and (substr(City, -1) not in ('a','o','i','e','u'));


--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem
select name
from Employee
where salary > 2000 and months < 10
order by employee_id asc;


--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
with all_marks as (select name, marks, grade from students join grades on marks >= min_mark and marks <= max_mark),
high_grades as (select name, grade, marks from all_marks where grade >=8 order by grade desc, name asc),
low_grades as (select null, grade, marks from all_marks where grade < 8 order by grade desc, marks asc)
select name, grade, marks from (select * from high_grades union all select * from low_grades);
