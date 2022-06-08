--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

-- мысль: номер страницы можно получить, если разделить номер конкретной строки на 2 и округлить вниз! а уже внутри этого деления считать их на 1-2

drop view pages_all_products;

create view pages_all_products as
with all_models as
(select model from laptop union select model from printer union select model from pc)
select maker, model, type, pos, page from (select *, row_number() over (partition by page order by model) as pos from (select *, floor(ceil((row_number() over (order by model))+0.5)/2) as page
from product) as sample_one) as sample_two;

select * from pages_all_products;


sample:
1 1
2 1
1 2
2 2
1 3
2 3

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

drop view distribution_by_type;

create view distribution_by_type as 
(select maker, type, round(((count(*) over (partition by type)*100)/(select count(*)::numeric 
from product)), 0) as "percent"
from product);

select * from distribution_by_type;

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/
-- https://colab.research.google.com/drive/1XTSYIAGTuDG2OnvkxEBNo7itcu1D_Ofr#scrollTo=1aETfy2dlPFZ


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

drop table ships_two_words;

create table ships_two_words as
(select * from ships
where name like '% %');

select * from ships_two_words;

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

with all_ships as
(select case when name is null and ship is null 
then null 
when name is not null and ship is null 
then null 
when name is null and ship is not null 
then ship else name 
end "name", class from ships full join outcomes 
on ships.name = outcomes.ship)
select name from all_ships
where class is null and name like 'S%';

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

select * from ((
select model from 
(select model, row_number() over (order by price desc) as price_rank 
from printer) as sample
where price_rank <= 3
) union 
(
select product.model as "model" from
product join printer
on product.model = printer.model
where maker = 'A' 
and price > (select avg(price) from product join printer on product.model = printer.model where maker = 'A'))) as united_sample