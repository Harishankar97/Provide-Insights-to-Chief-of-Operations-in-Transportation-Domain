with ct1 as (select c.city_name , d.month_name ,
sum(f.total_passengers) as total_passengers,
sum(f.repeat_passengers) as repeate_passengers,
sum(f.repeat_passengers) as repeate_passengers_month,
sum(f.total_passengers) as total_passengers_month,
sum(sum(f.repeat_passengers)) over (partition by city_name) as repeate_passengers_city,
sum(sum(f.total_passengers)) over (partition by city_name) as total_passengers_city
from trips_db.fact_passenger_summary f
join trips_db.dim_city c
on c.city_id = f.city_id 
join trips_db.dim_date d
on d.date = f.month 
group by c.city_name, d.month_name )
select ct1.city_name , ct1.month_name , ct1.total_passengers , ct1.repeate_passengers,
((ct1.repeate_passengers_month) *100 / nullif(ct1.total_passengers_month,0)) as monthly_repeate_passengers_rate,
((ct1.repeate_passengers_city) *100 / nullif(ct1.total_passengers_city,0)) as city_repeate_passengers_rate
from ct1
order by ct1.city_name , ct1.month_name

