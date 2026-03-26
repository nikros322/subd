-- Таблица orders — индекс на колонке status

-- Создание таблицы
DROP TABLE IF EXISTS orders; 

CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    status      TEXT NOT NULL,
    created_at  DATE NOT NULL
);

-- Заполнение 100 000 строк
-- Статусы: 'new', 'processing', 'shipped', 'delivered' — случайно
INSERT INTO orders (customer_id, status, created_at)
SELECT
    floor(random() * 1000 + 1)::int,
    (ARRAY['new', 'processing', 'shipped', 'delivered'])[floor(random() * 4 + 1)::int],
    CURRENT_DATE - (random() * 365)::int
FROM generate_series(1, 100000);

-- Проверка что данные добавились
SELECT COUNT(*) FROM orders;
-- Ожидаемый результат: 100000

-- Проверка распределения по статусам
SELECT status, COUNT(*) FROM orders GROUP BY status ORDER BY status;
-- Примерно по ~25 000 на каждый статус

-- EXPLAIN без индекса
-- Seq Scan — перебирает все 100 000 строк
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM orders WHERE status = 'processing';

-- результат:
-- Seq Scan on orders  (cost=0.00..1481.28 rows=347 width=44) (actual time=0.020..9.849 rows=24939 loops=1)
--   Filter: (status = 'processing'::text)
--   Rows Removed by Filter: 75061
--   Buffers: shared hit=614
-- Planning Time: 0.143 ms
-- Execution Time: 10.757 ms

-- Создание индекса на колонке status
CREATE INDEX idx_orders_status ON orders(status);

-- EXPLAIN с индексом
-- Bitmap Heap Scan — использует индекс, но возвращает много строк (~25%)
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM orders WHERE status = 'processing';

-- результат:
-- Bitmap Heap Scan on orders  (cost=226.40..1151.86 rows=24917 width=20) (actual time=1.748..5.681 rows=24939 loops=1)
--   Recheck Cond: (status = 'processing'::text)
--   Heap Blocks: exact=614
--   Buffers: shared hit=614 read=23
--   -> Bitmap Index Scan on idx_orders_status
--        Index Cond: (status = 'processing'::text)
--        Index Searches: 1
-- Planning Time: 2.586 ms
-- Execution Time: 6.694 ms


-- =============================================
