# https://stepik.org/course/63054

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
