with transactions as (

    -- Ignore cancellation rows when working out coverage
    select *
    from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__transactions`

    where is_cancel = 0
      and payment_plan_days > 0

),

months as (

    select distinct
        month_start

    from `kkbox-analytics`.`dbt_dev_marts`.`dim_date`

    where month_start <= date '2017-04-01'

),

-- Step 2: Expand each payment into every month it covers
coverage as (

    select
        t.member_id,
        m.month_start,
        t.transaction_date,
        t.payment_plan_days,
        t.plan_list_price,
        t.is_auto_renew

    from transactions t

    join months m
        on m.month_start
        between date_trunc(t.transaction_date, month)
            and date_trunc(t.membership_expire_date, month)

),

-- Step 3: If several payments cover one month, keep the most recent
governing as (

    select *

    from coverage

    qualify row_number() over (
        partition by member_id, month_start
        order by transaction_date desc, plan_list_price desc
    ) = 1

)

-- Step 4: The governing plan's monthly price is this month's MRR
select
    member_id,
    month_start,
    to_hex(md5(cast(coalesce(cast(payment_plan_days as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(plan_list_price as string), '_dbt_utils_surrogate_key_null_') as string))) as plan_key,
    round(plan_list_price / payment_plan_days * 30, 2) as mrr,
    is_auto_renew

from governing