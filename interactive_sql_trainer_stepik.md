# Интерактивный тренажер по SQL https://stepik.org/course/63054

# Задание https://stepik.org/lesson/305012/step/8?unit=287020
## Для тех книг в таблице book, которые есть в таблице supply, не только увеличить их количество в таблице book ( увеличить их количество на значение столбца amountтаблицы supply), но и пересчитать их цену (для каждой книги найти сумму цен из таблиц book и supply и разделить на 2).

## Решение

```sql
UPDATE book, supply 
SET book.amount = book.amount + supply.amount,
    book.price = (book.price + supply.price) / 2
WHERE book.title = supply.title AND book.author = supply.author;
```

# Задание https://stepik.org/lesson/305012/step/9?unit=287020
## Удалить из таблицы supply книги тех авторов, общее количество экземпляров книг которых в таблице book превышает 10.

## Решение

```sql
DELETE FROM supply 
WHERE author IN (
        SELECT author 
        FROM book
        GROUP BY author
        HAVING SUM(amount) > 10
      );
```

# Задание https://stepik.org/lesson/305012/step/10?unit=287020
## Создать таблицу заказ (ordering), куда включить авторов и названия тех книг, количество экземпляров которых в таблице book меньше среднего количества экземпляров книг в таблице book. В таблицу включить столбец   amount, в котором для всех книг указать одинаковое значение - среднее количество экземпляров книг в таблице book.

## Решение

```sql
CREATE TABLE ordering AS
SELECT author, title, 
   (
    SELECT ROUND(AVG(amount)) 
    FROM book
   ) AS amount
FROM book
WHERE amount < (SELECT AVG(amount) FROM book);
```

# Задание https://stepik.org/lesson/305012/step/11?unit=287020
## Придумайте один или несколько запросов корректировки данных к  таблицам book и  supply.

## Решение

```sql
DELETE FROM supply
WHERE price < (SELECT AVG(price) FROM book);
```

# Задание https://stepik.org/lesson/297510/step/2?unit=279270
## Вывести из таблицы trip информацию о командировках тех сотрудников, фамилия которых заканчивается на букву «а», в отсортированном по убыванию даты последнего дня командировки виде. В результат включить столбцы name, city, per_diem, date_first, date_last.

## Решение

```sql
SELECT name, city, per_diem, date_first, date_last
FROM trip
WHERE SUBSTRING_INDEX(name, ' ', 1) LIKE '%а'
ORDER BY date_last DESC
```

# Задание https://stepik.org/lesson/297510/step/3?unit=279270
## Вывести в алфавитном порядке фамилии и инициалы тех сотрудников, которые были в командировке в Москве.

## Решение

```sql
SELECT DISTINCT name
FROM trip
WHERE city = 'Москва'
ORDER BY name
```

# Задание https://stepik.org/lesson/297510/step/4?unit=279270
## Для каждого города посчитать, сколько раз сотрудники в нем были.  Информацию вывести в отсортированном в алфавитном порядке по названию городов. Вычисляемый столбец назвать Количество. 

## Решение

```sql
SELECT city, count(city) AS Количество
FROM trip
GROUP BY city
ORDER BY city
```

# Задание https://stepik.org/lesson/297510/step/5?unit=279270
## Вывести два города, в которых чаще всего были в командировках сотрудники. Вычисляемый столбец назвать Количество.

## Решение

```sql
SELECT city, count(city) AS Количество
FROM trip
GROUP BY city
ORDER BY Количество DESC
LIMIT 2
```

# Задание https://stepik.org/lesson/297510/step/6?unit=279270
## Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга (фамилии и инициалы сотрудников, город ,  длительность командировки в днях, при этом первый и последний день относится к периоду командировки). Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, а потом по убыванию названий городов (в обратном алфавитном порядке).

## Решение

```sql
SELECT name, city, (DATEDIFF(date_last, date_first) + 1) AS Длительность
FROM trip
WHERE city NOT IN ('Москва', 'Санкт-Петербург')
ORDER BY Длительность DESC, city DESC
```

# Задание https://stepik.org/lesson/297510/step/7?unit=279270
## Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. В результат включить столбцы name, city, date_first, date_last.

## Решение

```sql
SELECT name, city, date_first, date_last
FROM trip
WHERE DATEDIFF(date_last, date_first) = (SELECT MIN(DATEDIFF(date_last, date_first)) FROM trip)
```

# Задание https://stepik.org/lesson/297510/step/8?unit=279270
## Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). В результат включить столбцы name, city, date_first, date_last. Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .

## Решение

```sql
SELECT name, city, date_first, date_last
FROM trip
WHERE MONTH(date_last) = MONTH(date_first)
ORDER BY city, name
```

# Задание https://stepik.org/lesson/297510/step/9?unit=279270
## Вывести название месяца и количество командировок для каждого месяца. Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце. Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. Название столбцов – Месяц и Количество.

## Решение

```sql
SELECT MONTHNAME(date_first) AS Месяц, count(MONTHNAME(date_first)) AS Количество
FROM trip
GROUP BY MONTHNAME(date_first) 
ORDER BY Количество DESC, Месяц
```

# Задание https://stepik.org/lesson/297510/step/10?unit=279270
## Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок, первый день которых пришелся на февраль или март 2020 года. Значение суточных для каждой командировки занесено в столбец per_diem. Вывести фамилию и инициалы сотрудника, город, первый день командировки и сумму суточных. Последний столбец назвать Сумма. Информацию отсортировать сначала  в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных.

## Решение

```sql
SELECT name, city, date_first, (DATEDIFF(date_last, date_first) + 1) * per_diem AS Сумма
FROM trip
WHERE YEAR(date_first) = 2020 AND MONTH(date_first) IN (2, 3)
ORDER BY name, Сумма DESC
```
# Задание https://stepik.org/lesson/297510/step/11?unit=279270
## Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма.

## Решение

```sql
SELECT name, SUM((DATEDIFF(date_last, date_first) + 1) * per_diem) AS Сумма
FROM trip
GROUP BY name
HAVING COUNT(name) > 3
ORDER BY Сумма DESC
```
