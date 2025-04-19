create table account
(
    id integer, -- ID счета
    client_id integer, -- ID клиента
    open_dt date, -- дата открытия счета
    close_dt date -- дата закрытия счета
)

create table transaction
(
    id integer,  -- ID транзакции
    account_id integer,  -- ID счета
    transaction_date date,  -- дата транзакции
    amount numeric(10,2), -- сумма транзакции
    type varchar(3) -- тип транзакции
)

/* Вывести ID клиентов, которые за последний месяц по всем своим счетам совершили покупок меньше, чем на 5000 рублей. 
Без использования подзапросов и оконных функций. */

SELECT 
    a.client_id
FROM 
    account a
LEFT JOIN 
    transaction t ON a.id = t.account_id
    AND t.transaction_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
    AND t.transaction_date < DATE_TRUNC('month', CURRENT_DATE)
    AND t.type = 'OUT' -- предполагаем, что OUT - тип для покупок
WHERE 
    a.close_dt IS NULL -- учитываем только открытые счета
    OR a.close_dt >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
GROUP BY 
    a.client_id
HAVING 
    COALESCE(SUM(t.amount), 0) < 5000;
