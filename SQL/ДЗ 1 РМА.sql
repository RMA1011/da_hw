--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select class, count(ship)
from outcomes full join ships
on outcomes.ship = ships.name
where result = 'sunk' or result is NULL
group by class

-- или через all, но тогда строго ненулевые значения

select class, count(name)
from ships
where name in (select ship from outcomes where result = 'sunk' or result is NULL)
group by class


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.
select class, min(launched)
from ships
group by class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

SELECT class, count(ships)
FROM outcomes left join ships
on outcomes.ship = ships.name
where result = 'sunk' and class not in
(select count(ships) from outcomes left join class
on outcomes.ship = ships.name where result = 'sunk')

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with total_ships_info as (SELECT * 
FROM outcomes left join ships
on outcomes.ship = ships.name left join classes 
on ships.class = classes.class)
select distinct(ship)
from total_ships_info left join (select displacement, max(numGuns) max_guns from Classes group by displacement) as displacement_info
on displacement_info.displacement = total_ships_info.displacement
where numGuns = max_guns




--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, 
--имеющих наименьший объем RAM. Вывести: Maker

with weakest_pc as (select * from pc where ram = (select min(ram) from pc))
select distinct(maker)
from product
where model in (select model from weakest_pc where speed = (select max(speed) from weakest_pc)) 
and maker in (select distinct(maker) from printer join product on product.model = printer.model)

-- Остатки классной работы

--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class

select case
	when ships.name is null
		and outcomes.ship is not null then outcomes.ship
	when outcomes.ship is null
		and ships.name is not null then ships.name
	when ships.name is not null
		and outcomes.ship is not null then ships.name
	else null
end full_name,
case
when class is null
then '0'
else class
end new_class
from outcomes full join ships
on outcomes.ship = ships.name

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

with launch_year as (select launched from ships)
select name from battles
where date_part('year', date) not in (select launched from launch_year)

-- Если правильно понял задание, то with на самом деле не нужен
select name from battles
where date_part('year', date) not in (select launched from ships)