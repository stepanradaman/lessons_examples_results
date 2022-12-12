-- -------------------------------------------------- общее
-- Создать таблицу
-- CREATE TABLE test (
-- 	id int,
-- 	name varchar(20),
-- 	age float,
-- 	PRIMARY KEY (id)
-- );

-- Удалить таблицу
-- DROP TABLE test

-- Вставить данные
-- INSERT INTO test (id, name, age)
-- VALUES
-- 	(1, 'Frank', 55.1),
-- 	(2, 'Jane', 43.2),
-- 	(3, 'James', 27.5);

-- Показать всё, ну или с ALL
-- SELECT *
-- FROM test

-- Добавить столбец
-- ALTER TABLE test ADD surname varchar(100);

-- Изменить ячейку
-- UPDATE test 
-- SET name = 'New Test Name'
-- WHERE id = 2;

-- Показать с псевдонимом и отсортировать в обратку по name
-- SELECT
-- 	id,
-- 	name as aliasname,
-- 	age
-- FROM test
-- ORDER BY name DESC

-- Создать новую таблицу
-- CREATE TABLE phones (
-- 	id int,
-- 	name varchar(20),
-- 	number int,
-- 	PRIMARY KEY (id)
-- );

-- Вставить телефоны в новую таблицу
-- INSERT INTO phones (id, name, number)
-- VALUES
-- 	(1, 'Frank', 12345),
-- 	(2, 'Jane', 13579),
-- 	(3, 'James', 54321);

-- SELECT *
-- FROM test

-- UPDATE test 
-- SET name = 'Jane'
-- WHERE id = 2;

-- Объединить (слева от phones вставить test по условию)
-- SELECT test.name, test.age, phones.number
-- FROM test
-- LEFT OUTER JOIN phones ON test.name = phones.name

-- Объединить, но показать только то, что нашлось (слева от phones вставить test по условию)
-- SELECT test.name, test.age, phones.number
-- FROM test
-- INNER JOIN phones ON test.name = phones.name

-- Изменить ячейку
-- UPDATE test
-- SET surname =
-- CASE
-- 	WHEN test.id = 1 THEN 'Simpson'
-- 	WHEN test.id = 2 THEN 'Simpson'
-- 	WHEN test.id = 3 THEN 'NoSimpson'
-- END
-- WHERE test.id IN (1, 2, 3)

-- Показать
-- SELECT *
-- FROM test
-- ORDER BY id

-- Функция Disslove (Объединяем с суммированием)
-- SELECT
-- SUM(age) as years,
-- test.surname
-- FROM test
-- GROUP BY surname

-- --------------------------------------------------

-- Добавить расширение POSTGIS
-- CREATE EXTENSION postgis;
-- CREATE EXTENSION postgis_topology;

-- Создать таблицу с геометрией
-- CREATE TABLE points (
-- 	id int,
-- 	name varchar(30),
-- 	geom geometry,
-- 	PRIMARY KEY (id)
-- );

-- Вставить данные с городами
-- INSERT INTO points (id, name, geom)
-- VALUES
-- 	(1, 'New York', ST_SetSRID(ST_MakePoint(-71, 42), 4326)),
-- 	(2, 'Moscow', ST_SetSRID(ST_MakePoint(-61, 22), 4326)),
-- 	(3, 'San-Francisco', ST_SetSRID(ST_MakePoint(-31, 42), 4326));

-- SELECT *
-- FROM points

-- Посчитать расстояние от городов до некоторой точки
-- SELECT
-- 	id,
-- 	name,
-- 	geom,
-- 	ST_DistanceSphere(geom, ST_SetSRID(ST_MakePoint(-71, 42), 4326)) as distance
-- FROM points

-- Вывести как JSON
-- SELECT ST_AsGeoJSON(geom) FROM points

-- импорт shp в postgis через cmd (а можно просто чере qgis)
-- # shp2pgsql shaperoads.shp myschema.roadstable | psql -d roadsdb

-- Через qgis просто добавил shp афганистана с diva-gis и хочу его глянуть AFG_adm0
-- SELECT * 
-- FROM "AFG_adm0"

-- посчитал площадь
-- SELECT ST_Area(geom, true) FROM "AFG_adm0";

-- show data_directory;

-------------------------------------------------

-- показать уникальные значения (можно по разным атрибутам: по паре, по тройке и тд)
-- SELECT DISTINCT name, id
-- FROM points;

-- количество уникальных значений в столбце
-- SELECT COUNT(DISTINCT name)
-- FROM points;

-- сколько id по условию
-- SELECT COUNT(id)
-- FROM points
-- WHERE id > 2;

-- выборка по массиву
-- SELECT *
-- FROM points
-- WHERE id IN (1, 2)

-- сортировка по убыванию/возрастанию
-- SELECT DISTINCT name
-- FROM points
-- ORDER BY name ASC;

-- SELECT DISTINCT name
-- FROM points
-- ORDER BY name DESC;

-- минимум/максимум/среднее
-- SELECT MIN(id)
-- FROM points;

-- SELECT AVG(id)
-- FROM points;

-------------------------------------------------регулярные выражения примеры
-- LIKE 'U%' - начинается с U
-- LIKE '%u' - заканчивается на u
-- LIKE 'U%u' - начинается с U и заканчивается на u
-- LIKE '%John%' - содержит John
-- LIKE '_as_' - 1 - любая, 2 и 3 - as, последняя - любая
-- LIKE '_as%' - 1 - любая, 2 и 3 - as, последняя - от 0 до n символов

-- с пределом
-- SELECT name
-- FROM test
-- WHERE name LIKE 'J%'
-- LIMIT 10;

-------------------------------------------------ключевые слова

-- UNION с удалением дубликатов / UNION ALL - без удаления дубликатов
-- SELECT name
-- FROM test
-- UNION
-- SELECT name
-- FROM points;

-- INTERSECT - совпадения name
-- SELECT name
-- FROM test
-- INTERSECT
-- SELECT name
-- FROM points;

-- EXCEPT - найти что-то из test, где нет name из другой таблицы 
-- / EXCEPT ALL - включение зависимости от количества дубликатов
-- SELECT name
-- FROM test
-- EXCEPT
-- SELECT name
-- FROM points;


-------------------------------------------------упрощение
-- JOIN ON test.id = points.id = JOIN ON USING(id)

-------------------------------------------------подзапросы
-- дай id, которые есть в id другой таблицы
-- SELECT id
-- FROM test
-- WHERE id IN (SELECT id
-- 			FROM points);

-------------------------------------------------подзапросы
-- дай id, которые есть в id другой таблицы
-- SELECT id
-- FROM test
-- WHERE id IN (SELECT id
-- 			FROM points);

-------------------------------------------------внешние ключи
-- PRIMERY KEY - первичный ключ
-- FOREIGN KEY - ссылка на первичный ключ (он мне не даст включить в таблицу с внешним ключом любые данные)
-- https://www.youtube.com/watch?v=4NVHu34abo0&t=4240s

-- CREATE TABLE publisher (
-- 	publisher_id int,
-- 	publisher_name text,
	
-- 	CONSTRAINT PK_publisher_publisher_id PRIMARY KEY (publisher_id)
-- );

-- CREATE TABLE book (
-- 	book_id int,
-- 	title text,
-- 	publisher_id int,
	
-- 	CONSTRAINT PK_book_book_id PRIMARY KEY (book_id),
-- 	CONSTRAINT FK_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
-- );

-- и только так будет работать
-- INSERT INTO publisher
-- VALUES
-- (1, 'John'),
-- (2, 'James'),
-- (3, 'Jo');

-- SELECT *
-- FROM publisher

-- Вот это катит (то есть Foreign ключ толбко такой какой есть Primary)
-- INSERT INTO book
-- VALUES
-- (1, 'title_1', 1);

-- А вот так не катит, иначе ошибка
-- INSERT INTO book
-- VALUES
-- (1, 'title_1', 10);

-- SELECT *
-- FROM book

------------------------------------------------- оконные функции
-- MAX, MIN, AVG, COUNT, SUM

------------------------------------------------- представления (view)
-- https://www.youtube.com/watch?v=Q7aR6J7kSSo&t=1645s
-- сделать типа прокси, позволяет скрыть инфу, дать объект и работать с ним, фильтр,
-- изменять нельзя через оконные функции

-- CREATE VIEW test_view AS
-- SELECT id, name
-- FROM test
-- WHERE id > 1;

-- CREATE OR REPLACE VIEW;
-- ALTER VIEW test_view RENAME TO new_test_view;

------------------------------------------------- case then
-- SELECT id, name,
-- 	CASE
-- 		WHEN id < 2 THEN 'yes'
-- 		WHEN id > 2 THEN 'no'
-- 		ELSE 'fuck'
-- 	END AS amount
-- FROM test;

------------------------------------------------- проверка на нули
-- Добавить столбец
-- ALTER TABLE test ADD nullsurname varchar(100);

-- если в ячейке null - будет нет данных
-- SELECT id, name, COALESCE(nullsurname, 'нет данных') AS testnull
-- FROM test;

-- где совпадение со словом - будет нет данных
-- SELECT id, name, COALESCE(NULLIF(name, 'Frank'), 'нет данных') AS testnull
-- FROM test;

------------------------------------------------- функции SQL
-- без аргументов
-- CREATE OR REPLACE FUNCTION testFunction() RETURNS void AS $$
-- 	UPDATE test
-- 	SET nullsurname = 'no'
-- 	WHERE nullsurname IS NULL;
-- $$ LANGUAGE SQL;

-- SELECT testFunction();

-- SELECT *
-- FROM test

-- CREATE OR REPLACE FUNCTION testSumFunction() RETURNS float AS $$
-- 	SELECT SUM(age)
-- 	FROM test
-- $$ LANGUAGE SQL;

-- SELECT testSumFunction() AS testSum;

-- с аргументами (здесь только OUT-ы)
-- CREATE OR REPLACE FUNCTION testMaxFunctionArg(OUT maxage real, OUT minage real) AS $$
-- 	SELECT MAX(age), MIN(age)
-- 	FROM test
-- $$ LANGUAGE SQL;
-- SELECT * FROM testMaxFunctionArg();

-- с аргументами (здесь есть IN и OUT-ы): считает те значения по условию-аргументу
-- CREATE OR REPLACE FUNCTION testMaxFunctionArgWithIn(arg real, OUT maxage real, OUT minage real) AS $$
-- 	SELECT MAX(age), MIN(age)
-- 	FROM test
-- 	WHERE age < arg
-- $$ LANGUAGE SQL;

-- SELECT * FROM testMaxFunctionArgWithIn(50);

-- вывести много строк. Например для вывода по группам
-- CREATE OR REPLACE FUNCTION testMaxFunctionArgRows()
-- 	RETURNS SETOF double precision AS $$
-- 		SELECT AVG(age)
-- 		FROM test
-- 		GROUP BY id
-- $$ LANGUAGE SQL;

-- SELECT * FROM testMaxFunctionArgRows();

-- вывести много строк. Условие включено
-- CREATE OR REPLACE FUNCTION testMaxFunctionArgRowsTable(agen float)
-- 	RETURNS TABLE (idn int, namen text, agen float4) AS $$
-- 		SELECT id, name, age
-- 		FROM test
-- 		WHERE age < agen
-- $$ LANGUAGE SQL;

-- SELECT * FROM testMaxFunctionArgRowsTable(30);

------------------------------------------------- функции plpgSQL
-- без аргументов
-- CREATE OR REPLACE FUNCTION PGtestFunction() RETURNS real AS $$
-- 	BEGIN
-- 		RETURN SUM(age) 
-- 		FROM test;
-- 	END;
-- $$ LANGUAGE plpgsql;
-- DROP FUNCTION PGtestFunction()
-- SELECT PGtestFunction();

-- просто сумма аргументов
-- CREATE OR REPLACE FUNCTION sumArg(x int, y int, OUT z int) AS $$
-- 	BEGIN
-- 		z = x + y;
-- 		RETURN; 
-- 	END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM sumArg(1, 2)

-- вариант с условием
-- CREATE OR REPLACE FUNCTION sumArgQuary(agen int) RETURNS SETOF test AS $$
-- 	BEGIN
-- 		RETURN QUERY
-- 		SELECT *
-- 		FROM test
-- 		WHERE age > agen;
-- 	END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM sumArgQuary(30)

-- просто сумма аргументов с внутренними переменными
-- CREATE OR REPLACE FUNCTION sumArgDec(x int, y int, OUT z int) AS $$
-- 	DECLARE
-- 		a int = 3;
-- 	BEGIN
-- 		z = x + y + a;
-- 		RETURN; 
-- 	END;
-- $$ LANGUAGE plpgsql;
-- SELECT * FROM sumArgDec(1, 2)

------------------------------------------------- эксепшены функции plpgSQL
-- создам тестовую таблицу и заполню
-- Создать таблицу
-- CREATE TABLE seasons (
-- 	id int,
-- 	month varchar(30),
-- 	season varchar(30),
-- 	PRIMARY KEY (id)
-- );

-- -- Удалить таблицу
-- -- DROP TABLE test

-- -- Вставить данные
-- INSERT INTO seasons (id, month, season)
-- VALUES
-- 	(1, 'Январь', 'Зима'),
-- 	(2, 'Февраль', 'Зима'),
-- 	(3, 'Март', 'Весна'),
-- 	(4, 'Апрель', 'Весна'),
-- 	(5, 'Май', 'Весна'),
-- 	(6, 'Июнь', 'Лето'),
-- 	(7, 'Июль', 'Лето'),
-- 	(8, 'Август', 'Лето'),
-- 	(9, 'Сентябрь', 'Осень'),
-- 	(10, 'Октябрь', 'Осень'),
-- 	(11, 'Ноябрь', 'Осень'),
-- 	(12, 'Декабрь', 'Зима');


-- -- Показать всё, ну или с ALL
-- SELECT *
-- FROM seasons

-- примеры
-- CREATE OR REPLACE FUNCTION get_season(month_num int) RETURNS text AS $$
-- 	DECLARE
-- 		season text;
-- 	BEGIN
-- 		IF month_num NOT BETWEEN 1 AND 12 THEN
-- 			RAISE EXCEPTION 'Говно. Ты выбрал: (%)', month_num USING HINT = 'Нужно 1 to 12', ERRCODE = 12882;
-- 		END IF;
		
-- 		IF month_num BETWEEN 3 and 5 THEN
-- 			season = 'Весна';
-- 		ELSIF month_num BETWEEN 6 and 8 THEN
-- 			season = 'Лето';
-- 		ELSIF month_num BETWEEN 9 and 11 THEN
-- 			season = 'Осень';
-- 		ELSE
-- 			season = 'Зима';
-- 		END IF;
		
-- 		RETURN season; 
-- 	END;
-- $$ LANGUAGE plpgsql;

-- SELECT * FROM get_season(15)


-- CREATE OR REPLACE FUNCTION get_season_caller(month_num int) RETURNS text AS $$
-- 	DECLARE
-- 		err_ctx text;
-- 		err_msg text;
-- 		err_details text;
-- 		err_code text;
-- 	BEGIN
-- 		RETURN get_season(month_num);
-- 		EXCEPTION WHEN SQLSTATE '12882' THEN
-- 			GET STACKED DIAGNOSTICS
-- 				err_ctx = PG_EXCEPTION_CONTEXT,
-- 				err_msg = MESSAGE_TEXT,
-- 				err_details = PG_EXCEPTION_DETAIL,
-- 				err_code = RETURNED_SQLSTATE;
-- 			RAISE INFO 'Точно говно';
-- 			RAISE INFO 'Ошибка:%', err_ctx;
-- 			RAISE INFO 'Ошибка:%', err_msg;
-- 			RAISE INFO 'Ошибка:%', err_details;
-- 			RAISE INFO 'Ошибка:%', err_code;
-- 			RETURN NULL;
-- 	END;
-- $$ LANGUAGE plpgsql;

-- SELECT * FROM get_season_caller(15)

------------------------------------------------- транзакции
-- структура: BEGIN --- COMMIT, отмена - ROLLBACK, сохраняемая точка - SAVEPOINT
-- https://www.youtube.com/watch?v=d6c1S9O1rJ8

-- DROP TABLE users;

-- создам тестовую таблицу и заполню
-- CREATE TABLE users (
-- 	id serial,
-- 	balance decimal,
-- 	PRIMARY KEY (id)
-- );

-- INSERT INTO users (id, balance)
-- VALUES
-- 	(1, 100),
-- 	(2, 200),
-- 	(3, 300)

-- SELECT * FROM users

----------------------- 1
-- BEGIN;
-- 	UPDATE users
-- 	SET balance = balance + 1000
-- 	WHERE id = 2;
	
-- 	SAVEPOINT savepoint_one;
	
-- 	UPDATE users
-- 	SET balance = balance + 2000
-- 	WHERE id = 3;
	
-- 	ROLLBACK TO savepoint_one;
-- COMMIT;

-- SELECT * FROM users
----------------------- 1

----------------------- 2
-- BEGIN;
-- 	UPDATE users
-- 	SET balance = balance + 1000
-- 	WHERE id = 2;
-- ROLLBACK;

-- SELECT * FROM users
-- ROLLBACK;
----------------------- 2

------------------------------------------------- триггеры
-- при совершении какого-то события происходит включение другой функции
-- https://www.youtube.com/watch?v=jv1k1mT_9lU
-- важно: сначала триггеры запускаются, а потом только INSERT, иначе ошибка ключа

-- создам тестовую таблицу и заполню
-- CREATE TABLE profiles (
-- 	id serial,
-- 	user_id int,
-- 	name text,
-- 	PRIMARY KEY (id),
-- 	FOREIGN KEY (user_id) REFERENCES users(id)
-- );

-- INSERT INTO profiles (id, user_id, name)
-- VALUES
-- 	(1, 1, 'John'),
-- 	(2, 2, 'James'),
-- 	(3, 3, 'Homer')

-- SELECT * FROM profiles;

------------------------------------- сам по себе триггер
-- может быть AFTER/BEFORE INSERT/UPDATE/DELETE ON

-- CREATE OR REPLACE FUNCTION new_profile() RETURNS TRIGGER AS $$
-- 	BEGIN
-- 		INSERT INTO profiles(user_id) VALUES (NEW.id);
-- 		RETURN NEW;
-- 	END;
-- $$ LANGUAGE plpgsql;

-- DROP TRIGGER IF EXISTS tr_new_profile ON users;
-- CREATE TRIGGER tr_new_profile AFTER INSERT ON users
-- 	FOR EACH ROW EXECUTE PROCEDURE new_profile();

-- DELETE FROM users WHERE users.id = 4;

-- INSERT INTO users (id, balance)
-- VALUES
-- 	(5, 100)

-- SELECT * FROM profiles
-- SELECT * FROM users

------------------------------------- PostGIS
-- CREATE EXTENSION postgis;
-- CREATE EXTENSION pgrouting;
-- CREATE EXTENSION postgis_raster;
-- CREATE EXTENSION ogr_fdw;
-- CREATE EXTENSION postgis_topology;
-- CREATE EXTENSION postgis_sfcgal;
-- CREATE EXTENSION fuzzystrmatch;
-- CREATE EXTENSION address_standardizer;
-- CREATE EXTENSION address_standardizer_data_us;
-- CREATE EXTENSION postgis_tiger_geocoder;
