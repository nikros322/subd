--Получение списка представлений
SELECT table_name, view_definition
FROM information_schema.views
WHERE table_schema = 'bookings';
--Код представления airplanes
SELECT airplane_code,
    (model ->> lang()) AS model,
    range,
    speed
FROM airplanes_data ml;
--Код представления airports
SELECT airport_code,
    (airport_name ->> lang()) AS airport_name,
    (city ->> lang()) AS city,
    (country ->> lang()) AS country,
    coordinates,
    timezone
FROM airports_data ml;
--Код представления timetable
SELECT f.flight_id,
    f.route_no,
    r.departure_airport,
    r.arrival_airport,
    f.status,
    r.airplane_code,
    f.scheduled_departure,
    (f.scheduled_departure AT TIME ZONE dep.timezone) AS scheduled_departure_local,
    f.actual_departure,
    (f.actual_departure AT TIME ZONE dep.timezone) AS actual_departure_local,
    f.scheduled_arrival,
    (f.scheduled_arrival AT TIME ZONE arr.timezone) AS scheduled_arrival_local,
    f.actual_arrival,
    (f.actual_arrival AT TIME ZONE arr.timezone) AS actual_arrival_local
FROM flights f
JOIN routes r ON (r.route_no = f.route_no AND r.validity @> f.scheduled_departure)
JOIN airports_data dep ON (dep.airport_code = r.departure_airport)
JOIN airports_data arr ON (arr.airport_code = r.arrival_airport);
--Поиск триггеров
SELECT trigger_name, event_manipulation, event_object_table, action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'bookings';
