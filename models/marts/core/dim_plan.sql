with distinct_plans as (

    select distinct
        payment_plan_days,
        plan_list_price

    from {{ ref('stg_kkbox__transactions') }}

    where payment_plan_days > 0

)

select
    {{ dbt_utils.generate_surrogate_key(['payment_plan_days', 'plan_list_price']) }} as plan_key,
    payment_plan_days,
    plan_list_price,
    round(plan_list_price / payment_plan_days * 30, 2) as monthly_equiv_price,

    case
        when payment_plan_days <= 31 then 'Monthly'
        when payment_plan_days <= 100 then 'Quarterly'
        else 'Long-term'
    end as plan_type

from distinct_plans