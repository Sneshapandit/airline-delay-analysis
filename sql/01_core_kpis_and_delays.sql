-- Q1: Count total flights
SELECT COUNT(*) AS total_flights
FROM flights;

-- Q2: Calculate average delay time (average arrival delay on completed flights)
SELECT ROUND(AVG(ARRIVAL_DELAY), 2) AS avg_arrival_delay_min
FROM flights
WHERE FLIGHT_STATUS = 'Completed'
  AND ARRIVAL_DELAY IS NOT NULL;

-- Q3: Find delayed flights (15+ min arrival delay) by airline
SELECT
    f.AIRLINE AS airline_code,
    COALESCE(a.AIRLINE, f.AIRLINE) AS airline_name,
    COUNT(*) AS delayed_flights_15plus
FROM flights f
LEFT JOIN airlines a
    ON f.AIRLINE = a.IATA_CODE
WHERE f.FLIGHT_STATUS = 'Completed'
  AND f.ARRIVAL_DELAY >= 15
GROUP BY f.AIRLINE, a.AIRLINE
ORDER BY delayed_flights_15plus DESC;

-- Q4: Find airport-wise delays (top 15 IATA-matched origin airports by completed flights)
SELECT
    f.ORIGIN_AIRPORT AS airport_code,
    p.AIRPORT AS airport_name,
    p.CITY AS city,
    p.STATE AS state,
    COUNT(*) AS completed_flights,
    ROUND(AVG(f.DEPARTURE_DELAY), 2) AS avg_departure_delay_min,
    ROUND(AVG(f.ARRIVAL_DELAY), 2) AS avg_arrival_delay_min
FROM flights f
INNER JOIN airports p
    ON f.ORIGIN_AIRPORT = p.IATA_CODE
WHERE f.FLIGHT_STATUS = 'Completed'
GROUP BY f.ORIGIN_AIRPORT, p.AIRPORT, p.CITY, p.STATE
ORDER BY completed_flights DESC
LIMIT 15;

-- Q5: Calculate cancellation rate (%)
SELECT
    COUNT(*) AS total_flights,
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(
        CAST(SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM flights;
