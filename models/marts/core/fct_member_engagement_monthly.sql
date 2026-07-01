with engagement as (

    select *
    from {{ ref('int_monthly_engagement') }}

),

members as (

    select
        member_id,
        is_churn

    from {{ ref('dim_member') }}

)

select
    {{ dbt_utils.generate_surrogate_key(['e.member_id', 'e.month_start']) }} as engagement_key,
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