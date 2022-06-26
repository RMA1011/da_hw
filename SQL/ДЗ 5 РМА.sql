--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6, дополнительно)
-- SQL: Создайте таблицу с синтетическими данными (10000 строк, 3 колонки, все типы int) и заполните ее случайными данными от 0 до 1 000 000. Проведите EXPLAIN операции и сравните базовые операции.
-- Провести базовые селекты
-- https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-random-range/

drop table new_table;

CREATE OR REPLACE FUNCTION random_between(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random()* (high-low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

create table new_table as
(select generate_series(1, 10000)::INT as id, random_between (0, 1000000)::INT as one, random_between (0, 1000000)::INT as two, random_between (0, 1000000)::INT as three);  

-- базовые операции: select min(), avg(), max(), distinct. Нужно создать копию с индексом и без индекса, после чего сравнить скорость выполнения запросов


explain analyze select * from new_table; 
-- planning time: 0.109 ms, execution: 1.044 ms

explain analyze select count(*) from new_table; 
-- planning 0.059, execution 1.188 ms

explain analyze select count(one) from new_table; 
-- planning 0.037, execution 1.309 ms

explain analyze select avg(one) from new_table;
-- planning 0.054, execution 1.361

explain analyze select max(one) from new_table; 
-- planning 0.047, execution 1.345 ms

explain analyze select min(one) from new_table; 
-- planning 0.073, execution 1.340 ms

explain analyze select count(one), count(two), count(three) from new_table; 
-- planning 0.036, execution 1.483 ms

explain analyze select avg(one), avg(two), avg(three) from new_table; 
-- planning 0.034, execution 1.789 ms

explain analyze select max(one), max(two), max(three) from new_table; 
-- planning 0.050, execution 1.568 ms

explain analyze select min(one), min(two), min(three) from new_table; 
-- planning 0.051, execution 1.567 ms


--task2 (lesson6, дополнительно)
-- GCP (Google Cloud Platform): Через GCP загрузите данные csv в базу PSQL по личным реквизитам (используя только bash и интерфейс bash) 
-- https://www.alibabacloud.com/help/en/analyticdb-for-postgresql/latest/use-the-copy-command-to-import-data-from-your-computer-to-analyticdb-for-postgresql
-- https://www.baeldung.com/linux/csv-parsing



--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model
with all_model as
(select price, model from pc union select price, model from laptop union select price, model from printer)
select model
from all_model
where price = (select max(price) from all_model)


--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
with all_models as
(select price, model from pc union all select price, model from printer union select price, model from laptop)
select * from
(select price, all_models.model, maker, type, case when price > (select max(price) from printer) then 1 else 0 end flag, row_number() over (partition by type order by price asc) as price_range
from all_models join product on all_models.model = product.model) as sample;

create index price_index on all_products_with_index_task5 (price_range);
