--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������. �������: ����� � ����� ����������� ��������.

select class, count(ship)
from outcomes full join ships
on outcomes.ship = ships.name
where result = 'sunk' or result is NULL
group by class

-- ��� ����� all, �� ����� ������ ��������� ��������

select class, count(name)
from ships
where name in (select ship from outcomes where result = 'sunk' or result is NULL)
group by class


--task2
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������. ���� ��� ������ �� ���� ��������� ������� ����������, ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.
select class, min(launched)
from ships
group by class

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������, ������� ��� ������ � ����� ����������� ��������.

SELECT class, count(ships)
FROM outcomes left join ships
on outcomes.ship = ships.name
where result = 'sunk' and class not in
(select count(ships) from outcomes left join class
on outcomes.ship = ships.name where result = 'sunk')

--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������ ����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).

with total_ships_info as (SELECT * 
FROM outcomes left join ships
on outcomes.ship = ships.name left join classes 
on ships.class = classes.class)
select distinct(ship)
from total_ships_info left join (select displacement, max(numGuns) max_guns from Classes group by displacement) as displacement_info
on displacement_info.displacement = total_ships_info.displacement
where numGuns = max_guns




--task5
--������������ �����: ������� �������������� ���������, ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��, 
--������� ���������� ����� RAM. �������: Maker

with weakest_pc as (select * from pc where ram = (select min(ram) from pc))
select distinct(maker)
from product
where model in (select model from weakest_pc where speed = (select max(speed) from weakest_pc)) 
and maker in (select distinct(maker) from printer join product on product.model = printer.model)

-- ������� �������� ������

--task11
--�������: ������� ������ ���� �������� � �����. ��� ��� � ���� ��� ������ - ������� 0, ��� ��������� - class

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
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����. (����� with)

with launch_year as (select launched from ships)
select name from battles
where date_part('year', date) not in (select launched from launch_year)

-- ���� ��������� ����� �������, �� with �� ����� ���� �� �����
select name from battles
where date_part('year', date) not in (select launched from ships)