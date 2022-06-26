--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

with all_models as 
(select model from pc union select model from printer union select model from laptop)
select product.model as model, maker, type
from product join all_models
on product.model = all_models.model

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

with comparison as (select model, case when price > (select avg(price) from pc) then 1 else 0 end flag from printer)
select * from printer join comparison on printer.model = comparison.model


--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

with all_ships_possible as (select name from ships union select ship as name from outcomes)
select all_ships_possible.name from all_ships_possible left join ships on all_ships_possible.name = ships.name
where class is null

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

select distinct(name) from battles
where date_part('year', date) not in (select launched from ships)

--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from outcomes join ships
on outcomes.ship = ships.name

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as 
(with all_models_possible as 
(select model, price from pc union
select model, price from laptop union
select model, price from printer)
select model, price, case when price > 300 then 1 else 0 end flag from all_models_possible);

select * from all_products_flag_300

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as 
(with all_models_possible as 
(select model, price from pc union
select model, price from laptop union
select model, price from printer)
select model, price, case when price > (select avg(price) from all_models_possible) then 1 else 0 end flag from all_models_possible);

select * from all_products_flag_avg_price

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with all_printers as
(select printer.model as model, price, maker from printer join product
on printer.model = product.model)
select model from all_printers
where maker = 'A' and price > (select avg(price) from all_printers where maker = 'D' or maker = 'C')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
with marked_products as 
(select product.model as model, maker, type, price from
(select price, model from laptop union
select price, model from pc union
select price, model from printer) all_products join product on all_products.model = product.model)
select model from marked_products
where maker = 'A' and price > (select avg(price) from marked_products where (maker = 'D' or maker = 'C') and type = 'Printer')


--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with marked_products as 
(select product.model as model, maker, price from
(select price, model from laptop union
select price, model from pc union
select price, model from printer) all_products join product on all_products.model = product.model)
select avg(price) from marked_products
where maker = 'A'


--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as 
(with marked_products as 
(select product.model as model, maker, type, price from
(select price, model from laptop union
select price, model from pc union
select price, model from printer) all_products join product on all_products.model = product.model)
select maker, count(*)
from marked_products
group by maker);

select * from count_products_by_makers

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)
-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=vKnaTHGjzwTv


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

-- Опция через фильтр
create table printer_updated as 
(select * from printer where model not in (select model from product where maker = 'D'));

select * from printer_updated

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

drop view printer_updated_with_makers;

create view printer_updated_with_makers as
(select code, printer_updated.model as model, color, type, price, maker from printer_updated join (select model, maker from product) as modeling on printer_updated.model = modeling.model);

select * from printer_updated_with_makers 

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

drop view sunk_ships_by_classes;

create view sunk_ships_by_classes as
(select count(ship), case when class is null then '0' else ships.class end "class"
from outcomes left join ships on outcomes.ship = ships.name
where result = 'sunk' 
group by class);

select * from sunk_ships_by_classes;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)
-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

drop table classes_with_flag; 

create table classes_with_flag as
(select *, case when numGuns >= 9 then 1 else 0 end flag from classes);

select * from classes_with_flag;

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)
select country, count(class) from classes
group by country

-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".
select count(name)
from ships
where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.
select count(name)
from ships
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
select count(name) as "count", launched as "year" from ships
group by launched

--https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr