SELECT audience, metric, operator, date1, value_counts, date2, order_numb 
FROM bht1 
WHERE order_numb > 3 AND (operator = 'МТС' OR order_numb = 2) AND date2 IN ('Май 2018', 'Июн 2018', 'Июл 2018', 'Авг 2018', 'Сен 2018', 'Окт 2018')
ORDER BY value_counts DESC */ --НА СЛОЖНЫЕ УСЛОВИЯ И ИХ КОМБИНАЦИЮ, СО СПИСКОМ И СОРТИРОВКОЙ 

SELECT audience, metric, operator, date1, value_counts, date2, order_numb 
FROM bht1 
WHERE order_numb > 3 AND operator LIKE '[^М]%' 
ORDER BY value_counts DESC */ --НА УСЛОВИЯ И ОТБОР ПО ТИПУ РЕГУЛЯРНОГО ВЫРАЖЕНИЯ, С ПРИМЕНЕНИЕМ МЕТАСИМВОЛОВ

SELECT audience, metric, LOWER (operator) AS operator, date1, value_counts, date2, order_numb, order_numb * 2 AS order_numb_calc
FROM bht1
WHERE order_numb > 2 */ --НА ВЫЧИСЛЯЕМЫЕ ПОЛЯ И ИХ ПЕРЕНАЗЫВАНИЯ

SELECT COUNT(DISTINCT order_numb), MAX(date2)
FROM bht1 
WHERE order_numb < 3 */ --НА УНИКАЛЬНЫЕ ЗНАЧЕНИЯ И ИСПОЛЬЗОВАНИЕ ВСТРОЕННЫХ ФУНКЦИЙ

SELECT date2, COUNT (DISTINCT operator) AS operator_unique, COUNT (DISTINCT value_counts) AS value_counts_unique
FROM bht1
WHERE order_numb >= 2
GROUP BY date2
HAVING COUNT (DISTINCT value_counts) >= 10
ORDER BY value_counts_unique, date2 */ --НА ГРУППИРОВКУ, С УСЛОВИЕМ ПО РЕЗУЛЬТАТУ ГРУППИРОВКИ И СОРТИРОВКОЙ

SELECT audience, metric, LOWER (operator) AS operator, date1, value_counts, date2, order_numb 
FROM bht1
WHERE date1 IN (SELECT date1 
				FROM bht1 
				WHERE value_counts IN ('0,2217', '0,2487', '0,2302')) */ --НА ПОДЗАПРОСЫ ВНУТРИ ОДНОЙ ТАБЛИЦЫ

SELECT audience, metric, LOWER (operator) AS operator, date1, value_counts, date2, order_numb 
FROM bht1
WHERE date1 IN (SELECT date1 
				FROM bht1 
				WHERE value_counts IN (SELECT value_counts 
										FROM bht1 
										WHERE date2 = 'Янв 2019')) */ --НА СЛОЖНЫЕ ВЛОЖЕННЫЕ ПОДЗАПРОСЫ: ОТОБРАТЬ value_counts,
																	--ГДЕ date2 = Янв 2019, ПО КОТОРЫМ ОТОБРАТЬ date1, ПО КОТОРЫМ
																	--ПОСТРОИТСЯ ВСЯ ТАБЛИЦА

SELECT audience, metric, operator, date1, value_counts, date2, order_numb, 
		(SELECT COUNT (*) FROM bht2 WHERE operator = 'МЕГАФОН') AS lines 
FROM bht1
ORDER BY date2 DESC --НА ПОДЗАПРОС С РАСЧЕТНЫМ ПОЛЕМ (КОТОРОЕ ЕЩЁ И ПСЕВДОНИМ) И ФИЛЬТРОМ ПО ЗНАЧЕНИЯМ ИЗ ДРУГОЙ ТАБЛИЦЫ
