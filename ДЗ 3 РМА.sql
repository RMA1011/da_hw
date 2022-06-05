--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

with all_models as 
(select model from pc union select model from printer union select model from laptop)
select product.model as model, maker, type
from product join all_models
on product.model = all_models.model

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

with comparison as (select model, case when price > (select avg(price) from pc) then 1 else 0 end flag from printer)
select * from printer join comparison on printer.model = comparison.model


--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

with all_ships_possible as (select name from ships union select ship as name from outcomes)
select all_ships_possible.name from all_ships_possible left join ships on all_ships_possible.name = ships.name
where class is null

--task16 (lesson3)
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����.

select distinct(name) from battles
where date_part('year', date) not in (select launched from ships)

--task17 (lesson3)
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select battle
from outcomes join ships
on outcomes.ship = ships.name

--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag

create view all_products_flag_300 as 
(with all_models_possible as 
(select model, price from pc union
select model, price from laptop union
select model, price from printer)
select model, price, case when price > 300 then 1 else 0 end flag from all_models_possible);

select * from all_products_flag_300

--task2  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

create view all_products_flag_avg_price as 
(with all_models_possible as 
(select model, price from pc union
select model, price from laptop union
select model, price from printer)
select model, price, case when price > (select avg(price) from all_models_possible) then 1 else 0 end flag from all_models_possible);

select * from all_products_flag_avg_price

--task3  (lesson4)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

with all_printers as
(select printer.model as model, price, maker from printer join product
on printer.model = product.model)
select model from all_printers
where maker = 'A' and price > (select avg(price) from all_printers where maker = 'D' or maker = 'C')

--task4 (lesson4)
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model
with marked_products as 
(select product.model as model, maker, type, price from
(select price, model from laptop union
select price, model from pc union
select price, model from printer) all_products join product on all_products.model = product.model)
select model from marked_products
where maker = 'A' and price > (select avg(price) from marked_products where (maker = 'D' or maker = 'C') and type = 'Printer')


--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)
with marked_products as 
(select product.model as model, maker, price from
(select price, model from laptop union
select price, model from pc union
select price, model from printer) all_products join product on all_products.model = product.model)
select avg(price) from marked_products
where maker = 'A'


--task6 (lesson4)
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

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
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)
-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=vKnaTHGjzwTv


--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

-- ����� ����� ������
create table printer_updated as 
(select * from printer where model not in (select model from product where maker = 'D'));

select * from printer_updated

--task9 (lesson4)
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

drop view printer_updated_with_makers;

create view printer_updated_with_makers as
(select code, printer_updated.model as model, color, type, price, maker from printer_updated join (select model, maker from product) as modeling on printer_updated.model = modeling.model);

select * from printer_updated_with_makers 

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

drop view sunk_ships_by_classes;

create view sunk_ships_by_classes as
(select count(ship), case when class is null then '0' else ships.class end "class"
from outcomes left join ships on outcomes.ship = ships.name
where result = 'sunk' 
group by class);

select * from sunk_ships_by_classes;

--task11 (lesson4)
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)
-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

drop table classes_with_flag; 

create table classes_with_flag as
(select *, case when numGuns >= 9 then 1 else 0 end flag from classes);

select * from classes_with_flag;

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)
select country, count(class) from classes
group by country

-- https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".
select count(name)
from ships
where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.
select count(name)
from ships
where name like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)
select count(name) as "count", launched as "year" from ships
group by launched

--https://colab.research.google.com/drive/1jm7OnNeKy8TgKLjNndV157BGJ37FDh0C#scrollTo=7FdYUEgT0pRr