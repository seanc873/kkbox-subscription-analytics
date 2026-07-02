{{ config(materialized='table') }}

with members as (

    select
        member_id,
        registration_channel,
        age,
        tenure_days,
        is_churn

    from {{ ref('dim_member') }}

    where is_churn is not null -- Only labeled members

),

engagement as (

    -- Listening in the 2 months before the cutoff
    select
        member_id,
        count(distinct activity_date) as active_days,
        sum(total_seconds) as total_seconds,
        sum(songs_100pct) as songs_completed,
        safe_divide(
            sum(total_seconds),
            count(distinct activity_date)
        ) as avg_secs_per_day

    from {{ ref('fct_daily_listening') }}

    where activity_date between date '2017-01-01' and date '2017-02-28'

    group by member_id

),

billing as (

    select
        member_id,
        count(*) as num_transactions,
        sum(
            case
                when is_cancel = 1 then 1
                else 0
            end
        ) as num_cancellations

    from {{ ref('stg_kkbox__transactions') }}

    where transaction_date <= date '2017-02-28'

    group by member_id

),

last_plan as (

    select
        member_id,
        plan_list_price,
        is_auto_renew

    from {{ ref('stg_kkbox__transactions') }}

    where transaction_date <= date '2017-02-28'
      and is_cancel = 0

    qualify row_number() over (
        partition by member_id
        order by transaction_date desc
    ) = 1

)

select
    m.member_id,
    m.registration_channel,
    m.age,
    m.tenure_days,
    coalesce(e.active_days, 0) as active_days,
    coalesce(e.total_seconds, 0) as total_seconds,
    coalesce(e.songs_completed, 0) as songs_completed,
    e.avg_secs_per_day,
    coalesce(b.num_transactions, 0) as num_transactions,
    coalesce(b.num_cancellations, 0) as num_cancellations,
    coalesce(lp.is_auto_renew, 0) as last_auto_renew,
    lp.plan_list_price as last_plan_price,
    m.is_churn

from members m

left join engagement e
    on m.member_id = e.member_id

left join billing b
    on m.member_id = b.member_id

left join last_plan lp
    on m.member_id = lp.member_id