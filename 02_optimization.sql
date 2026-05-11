-- Применение индексов для оптимизации
-- Ускоряем JOIN и фильтрацию по датам

CREATE INDEX idx_tf_flight_id ON bookings.ticket_flights(flight_id);
CREATE INDEX idx_flights_sched_departure ON bookings.flights(scheduled_departure);

-- Важно: обновляем статистику, чтобы планировщик увидел новые индексы
ANALYZE bookings.ticket_flights;
ANALYZE bookings.flights;
