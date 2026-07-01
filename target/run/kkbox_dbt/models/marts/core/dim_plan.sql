
  
    

    create or replace table `kkbox-analytics`.`dbt_dev_marts`.`dim_plan`
      
    
    

    
    OPTIONS()
    as (
      with distinct_plans as (

    select distinct
        payment_plan_days,
        plan_list_price

    from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__transactions`

    where payment_plan_days > 0

)

select
    to_hex(md5(cast(coalesce(cast(payment_plan_days as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(plan_list_price as string), '_dbt_utils_surrogate_key_null_') as string))) as plan_key,
    payment_plan_days,
    plan_list_price,
    round(plan_list_price / payment_plan_days * 30, 2) as monthly_equiv_price,

    case
        when payment_plan_days <= 31 then 'Monthly'
        when payment_plan_days <= 100 then 'Quarterly'
        else 'Long-term'
    end as plan_type

from distinct_plans
    );
  