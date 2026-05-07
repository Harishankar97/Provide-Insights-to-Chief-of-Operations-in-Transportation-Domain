with ct1 as(
    select 
        c.city_id,
        c.city_name,
        t.month,
        sum(t.total_target_trips) as target
    from 
        targets_db.monthly_target_trips t
    join 
        trips_db.dim_city c
        on c.city_id = t.city_id
    group by 
        t.month, t.city_id
),
ct2 as (
    select 
        ct1.city_id,
        ct1.city_name,
        d.month_name,
        d.date,
        ct1.target
    from 
        ct1
    join 
        trips_db.dim_date d
        on ct1.month = d.start_of_month
),
ct3 as (
    select 
        ct2.city_name,
        ct2.month_name,
        COUNT(f.trip_id) AS actual_trip,
        ct2.target
    from 
        ct2 
        join 
        trips_db.fact_trips f
        on f.city_id = ct2.city_id AND f.date = ct2.date
    group by 
        ct2.city_name, ct2.month_name, ct2.target
)
select 
    ct3.city_name,
    ct3.month_name,
    ct3.actual_trip,
    ct3.target,
    case 
        when ct3.actual_trip > ct3.target then 'Above Target'
        else 'Below Target'
    end as performance_status,
    ROUND(
        ((ct3.actual_trip - ct3.target) * 100.0 / ct3.target),
        2
    ) as percentage_difference
from 
    ct3;
