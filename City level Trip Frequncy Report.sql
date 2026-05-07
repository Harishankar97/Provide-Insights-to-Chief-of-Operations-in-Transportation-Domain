USE trips_db;
WITH total_repeat_passengers_by_city AS (
    SELECT 
        r.city_id,
        SUM(r.repeat_passenger_count) AS total_repeat_passengers
    FROM 
        dim_repeat_trip_distribution r
    GROUP BY 
        r.city_id
),
repeat_passenger_percentage AS (
    SELECT 
        r.city_id,
        r.trip_count,
        r.repeat_passenger_count,
        (r.repeat_passenger_count * 100.0 / t.total_repeat_passengers) AS percentage
    FROM 
        dim_repeat_trip_distribution r
    JOIN 
        total_repeat_passengers_by_city t
    ON 
        r.city_id = t.city_id
)
SELECT 
    c.city_name,
    MAX(CASE WHEN rp.trip_count = '2-Trips' THEN rp.percentage END) AS "2-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '3-Trips' THEN rp.percentage END) AS "3-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '4-Trips' THEN rp.percentage END) AS "4-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '5-Trips' THEN rp.percentage END) AS "5-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '6-Trips' THEN rp.percentage END) AS "6-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '7-Trips' THEN rp.percentage END) AS "7-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '8-Trips' THEN rp.percentage END) AS "8-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '9-Trips' THEN rp.percentage END) AS "9-Trips (%)",
    MAX(CASE WHEN rp.trip_count = '10-Trips' THEN rp.percentage END) AS "10-Trips (%)"
FROM 
    repeat_passenger_percentage rp
JOIN 
    dim_city c
ON 
    rp.city_id = c.city_id
GROUP BY 
    c.city_name
ORDER BY 
    c.city_name;
