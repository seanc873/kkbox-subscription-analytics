
  
    

    create or replace table `kkbox-analytics`.`dbt_dev_marts`.`fct_mrr_monthly`
      
    
    

    
    OPTIONS()
    as (
      with movements as (

    select *
    from `kkbox-analytics`.`dbt_dev_intermediate`.`int_mrr_movements`

),

plan_info as (

    select
        member_id,
        month_start,
        plan_key,
        is_auto_renew

    from `kkbox-analytics`.`dbt_dev_intermediate`.`int_mrr_monthly`

)

select
    to_hex(md5(cast(coalesce(cast(m.member_id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(m.month_start as string), '_dbt_utils_surrogate_key_null_') as string))) as mrr_key,
    m.member_id,
    m.month_start as date_key, -- Joins to dim_date
    p.plan_key,                -- Joins to dim_plan
    m.mrr,
    m.movement_type,
    m.movement_amount,
    p.is_auto_renew

from movements m

left join plan_info p
    on m.member_id = p.member_id
   and m.month_start = p.month_start
    );
  