-- Замер "ПОСЛЕ": Проверка эффективности индексов
-- Ожидаемое время: ~0.041 ms
-- Ожидаемый план: Index Scan (точечный поиск по индексу)

SET search_path = bookings, public;

EXPLAIN (ANALYZE, BUFFERS)
SELECT tf.fare_conditions, SUM(tf.amount) AS total_revenue
FROM bookings.ticket_flights tf
JOIN bookings.flights f ON tf.flight_id = f.flight_id
WHERE f.scheduled_departure >= '2017-08-01' 
  AND f.scheduled_departure < '2017-09-01'
GROUP BY tf.fare_conditions;
