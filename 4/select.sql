-- страница оплаченного заказа
SELECT *
FROM "order" AS o
WHERE o.is_paid = true AND o.id = 8;

-- список заказов по умолчанию
SELECT o.id, o.customer_email, o.total_sum
FROM "order" AS O
WHERE o.is_paid = true
ORDER BY o.sort
LIMIT 100;

-- список заказов, отсортированный по цене
SELECT o.id, o.customer_email, o.total_sum
FROM "order" AS O
WHERE o.is_paid = true
ORDER BY o.total_sum DESC
LIMIT 100;

-- список конкретных товаров
SELECT o.id, o.customer_email, o.total_sum
FROM "order" AS O
WHERE 
-- o.is_paid = true AND
o.id in (1,5,7,8,10,34)
ORDER BY o.sort
LIMIT 100;

-- поиск опалаченного заказа по имени пользователя
SELECT o.id, o.customer_email, o.total_sum
FROM "order" AS O
WHERE o.is_paid = true AND o.customer_email like '%@a90c.37ba'
ORDER BY o.sort
LIMIT 100;

-- отчет по недавно созданным заказам
SELECT *
FROM "order" AS o
WHERE 
-- o.is_paid = true  AND
o.created_at BETWEEN '2023-02-01 00:00:00' AND '2023-03-01 00:00:00'
LIMIT 100;

-- поиск json
SELECT
  custom->'code' AS error_message
FROM
  "order" AS o
WHERE
  custom @> '{ "error": true }';

-- B Tree
-- CREATE INDEX btree_idx_order ON "order" USING btree (id); -- создается по умолчанию
-- DROP INDEX btree_idx_order;
CREATE INDEX btree_idx_sort_order ON "order" USING btree (sort);

-- partial
CREATE INDEX idx_is_paid_true_order ON "order" (id) WHERE is_paid = true;

-- hash
CREATE INDEX hash_idx_id_order ON "order" USING hash (id);

-- gin для полнотекстового поиска
CREATE INDEX gin_idx_customer_email_order ON "order" USING gin (customer_email gin_trgm_ops);

-- Brin для таблиц, в которых часть данных уже по своей природе как-то отсортирована
CREATE INDEX brin_idx_created_at_order ON "order" USING brin (created_at);

-- gin для поиска по содержимому полей типа JSON
CREATE INDEX gin_idx_custom_order on "order" USING gin (custom jsonb_path_ops);
