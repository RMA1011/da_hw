--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
SELECT name, class 
FROM Ships
WHERE launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
select name, class
from ships s 
where launched > 1920 and launched <= 1942

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class

-- ������� 1: �� �������, ��� � ������ ������ ���� ���� �� ���� �������. 
-- ����� ����� ������ ������ ��� join - ���� Class � ���� ������� ���� � Ships!
select count(class), class 
from ships s 
group by class
-- ������� 2: �� �������, ��� ����� ���� ������ � 0 ��������. ����� ����� ������������� �� Classes
-- �������: ����� ������������� ����, Bismarck!
select count(ships.class), classes.class
from classes left join ships
on classes.class = ships.class
group by classes.class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
select class, country
from classes
where bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
select ship
from outcomes
where battle = 'North Atlantic' and result = 'sunk'


-- ������� 6: ������� �������� (ship) ���������� ������������ �������
-- � ��� ���� �� ����������: ��������� ������� ��� �� ���� ����������� ��� ����������.
-- ������� ���� �������� ����, ����� � ���� �������� ���� �� ���� �������, � ������ ����� ������ �������

select ship
from outcomes join battles
on outcomes.battle = battles.name
where result = 'sunk' and date = 
(select max(date) 
from battles join outcomes 
on battles.name = outcomes.battle
where result = 'sunk')

-- �����: Fuso, Yamashiro


-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������

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

-- �����: �/�, ������ ��� Fuso � Yamashiro ��� � Ships

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
-- ������ ��������: �� ������ ���� �� � �������������� ships.name ������ ship
-- ������ ��� ���� ships.name != ship, �� �� �� ������� ������ �� �������

select name, ships.class
from classes join ships
on classes.class = ships.class
where bore >= 16 and name in 
(select ship 
from outcomes 
where result = 'sunk')

-- ���� ��� ������������� ������������ ship, �� ����� ���� �� left join outcomes

select ship, ships.class
from outcomes left join ships
on outcomes.ship = ships.name
left join classes
on ships.class = classes.class
where (bore >= 16 and result = 'sunk') or result = 'sunk'


-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
select class
from classes
where country = 'USA'

-- �����: Iowa, North Carolina, Tennessee

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class
select name, Ships.class
from Classes join ships
on classes.class = ships.class
where country = 'USA'

-- ������� 20 (� �������): ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.
select maker, avg(hd) 
from PC join product 
on pc.model = product.model 
where maker in 
(select maker 
from printer join product 
on printer.model = product.model) 
group by maker
