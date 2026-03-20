-- Индексы в PostgreSQL

-- Шаг 1: Создание таблицы
DROP TABLE IF EXISTS users;

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

-- Результат:
-- Seq Scan on users
-- Rows Removed by Filter: 99999
-- Execution Time: 6.362 ms

-- Шаг 4: Создание индекса
CREATE INDEX idx_user_email ON users(email);

-- Шаг 5: EXPLAIN с индексом
-- Index Scan — находит строку мгновенно через B-дерево
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM users WHERE email = 'User500@example.com';

-- Результат:
-- Index Scan using idx_user_email on users
-- Execution Time: 0.110 ms
-- Ускорение: ~58x
