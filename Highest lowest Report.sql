with ct1 as (
	select c.city_name, sum(f.new_passengers) as total_new_passengers
    from trips_db.fact_passenger_summary f
    join trips_db.dim_city c 
    on f.city_id = c.city_id
    group by c.city_name 
    ), ct2 as (
    select city_name , total_new_passengers , 
	case
		when rank() over (order by total_new_passengers DESC) <= 3 THEN 'Top 3'
		when rank() over (order by total_new_passengers ASC) <= 3 THEN 'Bottom 3'
		else null
        end as city_category
    from ct1 )
    select * from ct2 where city_category is not null
   