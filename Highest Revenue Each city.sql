with ct1 as (select f.city_id , d.month_name , sum(f.fare_amount) as revenue from trips_db.fact_trips f
join trips_db.dim_date d
on f.date = d.date
group by f.city_id,d.month_name),
ct2 as(
select city_id , month_name , revenue,
    (revenue / SUM(revenue) OVER (PARTITION BY city_id)) * 100 AS percentage_contribution
from ct1),
ct3 as (
select c.city_name , ct2.month_name , ct2.revenue , ct2.percentage_contribution,
rank () over (partition by ct2.city_id order by revenue desc) as revenue_rank
from ct2 
join trips_db.dim_city c
on c.city_id = ct2.city_id)
select city_name , month_name , revenue , percentage_contribution from ct3
where revenue_rank = 1