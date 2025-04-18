SELECT
  dim_city.city_name,
    COUNT(fact_trips.trip_id) AS total_trips,
    CASE
        WHEN COALESCE(SUM(fact_trips.distance_travelled_km), 0) > 0 THEN 
            ROUND(COALESCE(SUM(fact_trips.fare_amount),0) / COALESCE(SUM(fact_trips.distance_travelled_km), 0), 2)
        ELSE 
            NULL
  END AS avg_fare_per_km,
    CASE
        WHEN COALESCE(COUNT(fact_trips.trip_id), 0) > 0 THEN 
            ROUND(COALESCE(SUM(fact_trips.fare_amount),0) / COALESCE(COUNT(fact_trips.trip_id), 0),2)
        ELSE 
            NULL
  END AS avg_fare_per_trip,
    CASE
        WHEN COALESCE((SELECT COUNT(fact_trips.trip_id) FROM trips_db.fact_trips), 0) > 0 THEN 
            ROUND(COALESCE(COUNT(fact_trips.trip_id), 0) * 100 / COALESCE((SELECT COUNT(fact_trips.trip_id) FROM trips_db.fact_trips), 0), 2)
        ELSE 
            NULL
  END AS percentage_contribution_to_total_trips
    
FROM
  trips_db.fact_trips
    LEFT JOIN 
  trips_db.dim_city ON dim_city.city_id = fact_trips.city_id
GROUP BY
  dim_city.city_name
ORDER BY
  total_trips DESC;