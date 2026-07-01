
  
    

    create or replace table `kkbox-analytics`.`dbt_dev_marts`.`fct_daily_listening`
      
    partition by activity_date
    

    
    OPTIONS()
    as (
      


with logs as (
    select *
    from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__user_logs`
)

select
    to_hex(md5(cast(coalesce(cast(member_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(activity_date as string), '_dbt_utils_surrogate_key_null_') as string))) as daily_listening_key,
    member_id,
    activity_date,
    songs_25pct,
    songs_50pct,
    songs_75pct,
    songs_985pct,
    songs_100pct,
    unique_songs,
    total_seconds
from logs
    );
  