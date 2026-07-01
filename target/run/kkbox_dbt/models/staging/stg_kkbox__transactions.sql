

  create or replace view `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__transactions`
  OPTIONS()
  as with source as (

    select distinct * from `kkbox-analytics`.`kkbox_raw`.`transactions`

),

typed as (

    select
        msno as member_id,
        payment_method_id,
        payment_plan_days,
        plan_list_price,
        actual_amount_paid,
        is_auto_renew,
        is_cancel,
        parse_date('%Y%m%d', cast(transaction_date as string)) as transaction_date,
        parse_date('%Y%m%d', cast(membership_expire_date as string)) as membership_expire_date
    from source

)

select *
from typed;

