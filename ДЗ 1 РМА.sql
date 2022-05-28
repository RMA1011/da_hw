--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
SELECT name, class 
FROM Ships
WHERE launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
select name, class
from ships s 
where launched > 1920 and launched <= 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class

-- Вариант 1: мы считаем, что в каждом классе есть хотя бы один корабль. 
-- Тогда можем решить задачу без join - поле Class и сами корабли есть в Ships!
select count(class), class 
from ships s 
group by class
-- Вариант 2: мы считаем, что могут быть классы с 0 кораблей. Тогда нужно отталкиваться от Classes
-- Спойлер: такой действительно есть, Bismarck!
select count(ships.class), classes.class
from classes left join ships
on classes.class = ships.class
group by classes.class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select class, country
from classes
where bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select ship
from outcomes
where battle = 'North Atlantic' and result = 'sunk'


-- Задание 6: Вывести название (ship) последнего потопленного корабля
-- В лоб идти не получается: последние морские бои по дате закончились без потоплений.
-- Сначала надо получить дату, когда в боях потопили хотя бы один корабль, и только потом искать корабли

select ship
from outcomes join battles
on outcomes.battle = battles.name
where result = 'sunk' and date = 
(select max(date) 
from battles join outcomes 
on battles.name = outcomes.battle
where result = 'sunk')

-- ответ: Fuso, Yamashiro


-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля

select ship, class 
from Ships join outcomes
on ships.name = outcomes.ship 
where ship in
(select ship
from outcomes join battles
on outcomes.battle = battles.name
where result = 'sunk' and date = 
(select max(date) 
from battles join outcomes 
on battles.name = outcomes.battle
where result = 'sunk'))

-- ответ: н/д, потому что Fuso и Yamashiro нет в Ships

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
-- Важная оговорка: мы должны быть ОК с использованием ships.name вместо ship
-- Потому что если ships.name != ship, то мы не получим данные по калибру

select name, ships.class
from classes join ships
on classes.class = ships.class
where bore >= 16 and name in 
(select ship 
from outcomes 
where result = 'sunk')

-- Если нам принципиально использовать ship, то нужно идти от left join outcomes

select ship, ships.class
from outcomes left join ships
on outcomes.ship = ships.name
left join classes
on ships.class = classes.class
where (bore >= 16 and result = 'sunk') or result = 'sunk'


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
select class
from classes
where country = 'USA'

-- ответ: Iowa, North Carolina, Tennessee

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class
select name, Ships.class
from Classes join ships
on classes.class = ships.class
where country = 'USA'

-- Задание 20 (с занятия): Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
select maker, avg(hd) 
from PC join product 
on pc.model = product.model 
where maker in 
(select maker 
from printer join product 
on printer.model = product.model) 
group by maker
