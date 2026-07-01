with spine as (

    {{
        dbt_utils.date_spine(
            datepart="day",
            start_date="cast('2015-01-01' as date)",
            end_date="cast('2017-05-01' as date)"
        )
    }}

)

select
    date_day as date_key,
    extract(year from date_day) as year,
    extract(month from date_day) as month,
    format_date('%B', date_day) as month_name,
    date_trunc(date_day, month) as month_start,
    extract(quarter from date_day) as quarter,
    extract(dayofweek from date_day) as day_of_week, -- 1 = Sunday

    case
        when extract(dayofweek from date_day) in (1, 7) then true
        else false
    end as is_weekend

from spine