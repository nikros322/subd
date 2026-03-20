-- Индексы в PostgreSQL

-- Шаг 1: Создание таблицы
DROP TABLE IF EXISTS users; -- если она создана, то дропаем и пересоздаем
CREATE TABLE users (
    id       SERIAL PRIMARY KEY,
    fullname TEXT,
    email    TEXT,
    age      INT
);

-- Шаг 2: Заполнение 100 000 строк
INSERT INTO users (fullname, email, age)
SELECT
    'User' || i,
    'User' || i || '@example.com',
    floor(random() * 100 + 18)::int
FROM generate_series(1, 100000) AS S(i);

-- Шаг 3: EXPLAIN без индекса
-- Seq Scan — перебирает все 100 000 строк
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM users WHERE email = 'User500@example.com';

-- результат:
-- Seq Scan on users  (cost=0.00..2084.00 rows=1 width=38) (actual time=0.059..6.344 rows=1 loops=1)
--   Filter: (email = 'User500@example.com'::text)
--   Rows Removed by Filter: 99999
--   Buffers: shared hit=834
-- Planning Time: 1.689 ms
-- Execution Time: 6.362 ms

-- Шаг 4: Создание индекса
CREATE INDEX idx_user_email ON users(email);

-- Шаг 5: EXPLAIN с индексом
-- Index Scan — находит строку мгновенно через B-дерево
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM users WHERE email = 'User500@example.com';

-- результат:
-- Index Scan using idx_user_email on users  (cost=0.42..3.44 rows=1 width=38) (actual time=0.091..0.092 rows=1 loops=1)
--   Index Cond: (email = 'User500@example.com'::text)
--   Index Searches: 1
--   Buffers: shared hit=1 read=3
-- Planning Time: 2.609 ms
-- Execution Time: 0.110 ms

-- Итог: индекс ускорил запрос в ~58 раз (6.362 ms -> 0.110 ms)
