SELECT media_login, device_id, url, start_dt_time, end_dt_time, 
(SELECT DISTINCT COUNT(*) FROM panelists_info_base WHERE gender = 'Female') AS females,	
(SELECT DISTINCT COUNT(*) FROM panelists_info_base WHERE gender = 'Male') AS males
FROM mobile_internet_media_consumption
WHERE media_login IN (SELECT media_login FROM panelists_info_base WHERE gender = 'Female') */ --РАСЧЕТНЫЕ СТОЛБЦЫ ПО КОЛ-ВУ Ж И М,
																							--С ВЫВОДОМ ТОЛЬКО ПО Ж

SELECT DISTINCT COUNT (*) media_login FROM panelists_info_base WHERE panelists_info_base.gender = 'Female'
SELECT DISTINCT COUNT (*) media_login FROM panelists_info_base WHERE panelists_info_base.gender = 'Male'

SELECT ip_adress, gender, age, city_name, tv_count, hh_group, income
FROM desktop_internet_media_consumption INNER JOIN panelists_info_base ON 
desktop_internet_media_consumption.media_login = panelists_info_base.media_login */ --INNER JOIN ДВУХ ТАБЛИЦ ПО media_login

SELECT ip_adress, device_id, gender, age, city_name, tv_count, hh_group, income
FROM desktop_internet_media_consumption, panelists_info_base, mobile_internet_media_consumption 
WHERE desktop_internet_media_consumption.media_login = panelists_info_base.media_login 
AND mobile_internet_media_consumption.media_login = panelists_info_base.media_login */ --ОБЪЕДИНЕНИЕ ПО INNER JOIN 
																					   --ТРЕХ ТАБЛИЦ ПО media_login

SELECT ip_adress, device_id, gender, age, city_name, tv_count, hh_group, income
FROM desktop_internet_media_consumption AS dim, panelists_info_base AS plst, mobile_internet_media_consumption AS mim
WHERE dim.media_login = plst.media_login 
AND mim.media_login = plst.media_login */ --ПСЕВДОНИМЫ ТАБЛИЦ

--САМООБЪЕДИНЕНИЕ:
SELECT plst1.media_login, plst1.gender, plst1.age, plst1.city_name, plst1.tv_count, plst1.hh_group, plst1.income
FROM panelists_info_base AS plst1, panelists_info_base AS plst2
WHERE plst1.media_login = plst2.media_login AND plst2.city_name = 'Казань' */ --ОДНА ТАБЛИЦА КАК ДВЕ

--ЕСТЕСТВЕННОЕ ОБЪЕДИНЕНИЕ:
SELECT plst.*, pwb.proj_coeff, pwb.weight_quote
FROM panelists_info_base AS plst, panelists_weighted_base AS pwb
WHERE plst.media_login = pwb.media_login */ --К ОДНОЙ ТАБЛИЦЕ ПРИКЛЕИВАЕМ НЕСКОЛЬКО СТОЛБЦОВ ИЗ ДРУГОЙ

--ВНЕШНЕЕ ОБЪЕДИНЕНИЕ (ЛЕВОЕ ИЛИ ПРАВО):
SELECT panelists_info_base.*, radio_media_consumption.device_id, radio_media_consumption.media_login
FROM panelists_info_base RIGHT OUTER JOIN radio_media_consumption 
ON panelists_info_base.media_login = radio_media_consumption.media_login */

--ВНЕШНЕЕ ПОЛНОЕ ОБЪЕДИНЕНИЕ:
SELECT panelists_info_base.*, radio_media_consumption.device_id, radio_media_consumption.media_login 
FROM panelists_info_base FULL OUTER JOIN radio_media_consumption 
ON panelists_info_base.media_login = radio_media_consumption.media_login */

SELECT panelists_info_base.*
FROM panelists_info_base 
WHERE gender = 'Female' and hh_group = 'HH without kid 0-17'
UNION
SELECT panelists_info_base.*
FROM panelists_info_base
WHERE age BETWEEN 20 AND 30 AND gender = 'Male' 
ORDER BY hh_group, age */ --ОБЪЕДИНЕНИЕ ЧЕРЕЗ UNION И СОРТИРОВКА

SELECT * 
INTO copy_panelists_info_base
FROM panelists_info_base */ --СОЗДАНИЕ КОПИИ ТАБЛИЦЫ

SELECT COUNT(*) FROM copy_panelists_info_base

INSERT INTO copy_panelists_info_base SELECT * FROM panelists_info_base --ДОБАВЛЕНИЕ В ИМЕЮЩУЮСЯ ТАБЛИЦУ ДАННЫХ ИЗ ДРУГОЙ ТАБЛИЦЫ

SELECT * FROM copy_panelists_info_base 

UPDATE copy_panelists_info_base 
SET city_name = 'Караганда' 
WHERE media_login = 'ssp1006581' */ --ОБНОВЛЕНИЕ/ЗАМЕНА ДАННЫХ В ОПРЕДЕЛЕННОМ СТОЛБЦЕ ДЛЯ ОПРЕДЕЛЕННОЙ СТРОКИ (ПО УСЛОВИЮ)

DELETE FROM copy_panelists_info_base 
WHERE city_name = 'Караганда' */ --УДАЛЕНИЕ СТРОК ИЗ ТАБЛИЦЫ ПО УСЛОВИЮ