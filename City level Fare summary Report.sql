use trips_db ;
with ct1 as (select c.city_name , count(t.trip_id) as total_trip,
sum(t.fare_amount) as total_fare,
sum(t.distance_travelled_km) as total_km
from fact_trips t
join  dim_city c
on c.city_id = t.city_id
group by c.city_name
),
ct2 as ( select sum(total_trip) as grand_total from ct1)
select ct1.city_name , ct1.total_trip,
	(ct1.total_km / ct1.total_trip) AS avg_fare_km,
    (ct1.total_fare / ct1.total_trip) AS avg_fare_trip ,
    (ct1.total_trip / ct2.grand_total ) *100 as contribution_to_trips
FROM ct1,ct2;
