--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко
-- Поскольку в sqlite3 не работает generate_series, сделаем таблицу в pandas
-- https://colab.research.google.com/drive/1tNcGE3iblvosORbDRD9PJaQsCRhAtxhM?usp=sharing


--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from (select email, count(*) as counter from Person group by email)
where counter >= 2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/
with managers as (
select id, name, salary
from Employee where id in (select managerId from Employee))
select Employee.name as "Employee"
from Employee join managers 
on Employee.managerId = managers.id
where Employee.salary > managers.salary


--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
select * from
(select score, dense_rank() over (order by score desc) as "rank"
 from scores)


--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/
select firstName as "firstName", lastName as "lastName", city as "city", state as "state"
from person left join address
on person.personid = address.personid