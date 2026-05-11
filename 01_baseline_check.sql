-- Замер "ДО": Выручка за август 2017 года
-- Ожидаемое время: ~50 ms
-- Ожидаемый план: Parallel Seq Scan (сканирование всей таблицы)

SET search_path = bookings, public;

EXPLAIN (ANALYZE, BUFFERS)
SELECT tf.fare_conditions, SUM(tf.amount) AS total_revenue
FROM bookings.ticket_flights tf
JOIN bookings.flights f ON tf.flight_id = f.flight_id
WHERE f.scheduled_departure >= '2017-08-01' 
  AND f.scheduled_departure < '2017-09-01'
GROUP BY tf.fare_conditions;
