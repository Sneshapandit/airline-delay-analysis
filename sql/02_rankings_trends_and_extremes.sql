-- Q6: Find busiest airports (top 15 IATA-matched origin airports by total flights)
SELECT
    f.ORIGIN_AIRPORT AS airport_code,
    p.AIRPORT AS airport_name,
    p.CITY AS city,
    p.STATE AS state,
    COUNT(*) AS total_flights
FROM flights f
INNER JOIN airports p
    ON f.ORIGIN_AIRPORT = p.IATA_CODE
GROUP BY f.ORIGIN_AIRPORT, p.AIRPORT, p.CITY, p.STATE
ORDER BY total_flights DESC
LIMIT 15;

-- Q7: Analyze monthly flight trends (volume, cancellations, and average arrival delay)
SELECT
    MONTH AS month,
    COUNT(*) AS total_flights,
    SUM(CASE WHEN FLIGHT_STATUS = 'Completed' THEN 1 ELSE 0 END) AS completed_flights,
    SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS cancelled_flights,
    ROUND(
        CAST(SUM(CASE WHEN CANCELLED = 1 THEN 1 ELSE 0 END) AS REAL) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_pct,
    ROUND(
        AVG(CASE WHEN FLIGHT_STATUS = 'Completed' THEN ARRIVAL_DELAY END),
        2
    ) AS avg_arrival_delay_min
FROM flights
GROUP BY MONTH
ORDER BY MONTH;

-- Q8: Rank airlines by on-time performance (< 15 min arrival delay on completed flights)
WITH airline_otp AS (
    SELECT
        f.AIRLINE AS airline_code,
        COALESCE(a.AIRLINE, f.AIRLINE) AS airline_name,
        COUNT(*) AS completed_flights,
        SUM(CASE WHEN f.ARRIVAL_DELAY < 15 THEN 1 ELSE 0 END) AS on_time_flights,
        ROUND(
            CAST(SUM(CASE WHEN f.ARRIVAL_DELAY < 15 THEN 1 ELSE 0 END) AS REAL) * 100.0
            / COUNT(*),
            2
        ) AS on_time_pct
    FROM flights f
    LEFT JOIN airlines a
        ON f.AIRLINE = a.IATA_CODE
    WHERE f.FLIGHT_STATUS = 'Completed'
      AND f.ARRIVAL_DELAY IS NOT NULL
    GROUP BY f.AIRLINE, a.AIRLINE
)
SELECT
    RANK() OVER (ORDER BY on_time_pct DESC) AS otp_rank,
    airline_code,
    airline_name,
    completed_flights,
    on_time_flights,
    on_time_pct
FROM airline_otp
ORDER BY otp_rank, airline_code;

-- Q9: Calculate average departure delay (overall completed flights & by airline)
SELECT
    ROUND(AVG(DEPARTURE_DELAY), 2) AS overall_avg_departure_delay_min
FROM flights
WHERE FLIGHT_STATUS = 'Completed'
  AND DEPARTURE_DELAY IS NOT NULL;

-- Q10: Find flights with the longest arrival delays (top 15 completed flights)
SELECT
    f.FLIGHT_DATE AS flight_date,
    f.AIRLINE AS airline_code,
    COALESCE(a.AIRLINE, f.AIRLINE) AS airline_name,
    f.FLIGHT_NUMBER AS flight_number,
    f.ORIGIN_AIRPORT AS origin_airport,
    f.DESTINATION_AIRPORT AS destination_airport,
    ROUND(f.DEPARTURE_DELAY, 1) AS departure_delay_min,
    ROUND(f.ARRIVAL_DELAY, 1) AS arrival_delay_min
FROM flights f
LEFT JOIN airlines a
    ON f.AIRLINE = a.IATA_CODE
WHERE f.FLIGHT_STATUS = 'Completed'
  AND f.ARRIVAL_DELAY IS NOT NULL
ORDER BY f.ARRIVAL_DELAY DESC
LIMIT 15;
