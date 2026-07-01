with movements as (

    select *
    from {{ ref('int_mrr_movements') }}

),

plan_info as (

    select
        member_id,
        month_start,
        plan_key,
        is_auto_renew

    from {{ ref('int_mrr_monthly') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['m.member_id', 'm.month_start']) }} as mrr_key,
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