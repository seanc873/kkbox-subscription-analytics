

  create or replace view `kkbox-analytics`.`dbt_dev_intermediate`.`int_monthly_engagement`
  OPTIONS()
  as with logs as (

    select *
    from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__user_logs`

)

select
    member_id,
    date_trunc(activity_date, month) as month_start,
    count(distinct activity_date) as active_days,
    sum(total_seconds) as total_seconds,
    sum(songs_100pct) as songs_completed,
    sum(
        songs_25pct
        + songs_50pct
        + songs_75pct
        + songs_985pct
        + songs_100pct
    ) as total_plays,
    safe_divide(
        sum(total_seconds),
        count(distinct activity_date)
    ) as avg_seconds_per_active_day

from logs

group by
    member_id,
    date_trunc(activity_date, month);

