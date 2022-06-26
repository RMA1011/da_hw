--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
with total_info as
(select department.name as Department, employee.name as Employee, salary as Salary, dense_rank() over (partition by employee.departmentId order by salary desc) as ranker from employee join department on employee.departmentid = department.id)
select Department, Employee, Salary from total_info where ranker <= 3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
select member_name, status,
sum(amount*unit_price) as "costs"
from Payments join FamilyMembers
on FamilyMembers.member_id = Payments.family_member
where date like "2005%" --а можно year(date)=2005
group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
with name_counter as (select count(*) as counter, name from passenger group by name)
select distinct(name) 
from pass_in_trip join passenger 
on pass_in_trip.id = passenger.id
where name in (select name from name_counter where counter>1);

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as "count"
from student
where first_name like "Anna%"

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
select count(distinct(classroom)) as 'count'
from schedule
where date like '2019-09-02%'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32
select FLOOR((sum(TIMESTAMPDIFF(year, birthday,now()))/count(member_id))) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, sum(amount*unit_price) as costs
from payments join goods ON 
payments.good = goods.good_id
join goodtypes on
goods.type = goodtypes.good_type_id
where date like "2005%"
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(TIMESTAMPDIFF(year, birthday,now())) as year
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select max(student_age) as 'max_year' from
(select (extract(year from now()) - extract(year from birthday)) as student_age
from student join Student_in_class
on student.id = student_in_class.student
join class on student_in_class.class = class.id
where class.name like '10%') as ages

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, sum(amount*unit_price) as 'costs'
from payments join goods on payments.good = goods.good_id
join familymembers on payments.family_member = familymembers.member_id
join goodtypes on goodtypes.good_type_id = goods.type
where good_type_name = 'entertainment'
group by status, member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete from Company
where id in
(select company from 
(select company, dense_rank() over (order by c) as total_rank 
from (
select company, count(*) as c 
from trip 
group by company) as flights) as ranker where total_rank = 1)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom from
(select classroom, dense_rank() over (order by c desc) as rang
from 
(select classroom, count(classroom) as c
from Schedule
group by classroom) as checker) as test
where rang = 1


--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select distinct(last_name)
from Teacher join Schedule
on Teacher.id = Schedule.teacher
join Subject on schedule.subject = subject.id
where subject.name = 'Physical Culture'
order by last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select CONCAT(last_name,'.',SUBSTRING(first_name from 1 for 1),'.', SUBSTRING(middle_name from 1 for 1),'.') as name
from student
order by name