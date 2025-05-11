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
