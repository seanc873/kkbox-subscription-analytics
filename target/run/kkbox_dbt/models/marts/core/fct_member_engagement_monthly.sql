
  
    

    create or replace table `kkbox-analytics`.`dbt_dev_marts`.`fct_member_engagement_monthly`
      
    
    

    
    OPTIONS()
    as (
      with engagement as (

    select *
    from `kkbox-analytics`.`dbt_dev_intermediate`.`int_monthly_engagement`

),

members as (

    select
        member_id,
        is_churn

    from `kkbox-analytics`.`dbt_dev_marts`.`dim_member`

)

select
    to_hex(md5(cast(coalesce(cast(e.member_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(e.month_start as string), '_dbt_utils_surrogate_key_null_') as string))) as engagement_key,
    e.member_id,
    e.month_start as date_key,
    e.active_days,
    e.total_seconds,
    e.songs_completed,
    e.total_plays,
    e.avg_seconds_per_active_day,
    m.is_churn

from engagement e

left join members m
    on e.member_id = m.member_id
    );
  