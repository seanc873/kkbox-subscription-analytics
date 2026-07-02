with active as (

    select
        member_id,
        date_key as month_start

    from {{ ref('fct_mrr_monthly') }}

    where mrr > 0

),

cohorts as (

    select
        member_id,
        date_trunc(registration_date, month) as cohort_month

    from {{ ref('dim_member') }}

    where registration_date is not null

),

joined as (

    select
        c.cohort_month,
        a.member_id,
        date_diff(a.month_start, c.cohort_month, month) as months_since_signup

    from active a

    join cohorts c
        on a.member_id = c.member_id

    where a.month_start >= c.cohort_month

),

cohort_size as (

    select
        cohort_month,
        count(distinct member_id) as cohort_members

    from joined

    where months_since_signup = 0

    group by cohort_month

)

select
    j.cohort_month,
    j.months_since_signup,
    cs.cohort_members,
    count(distinct j.member_id) as active_members,
    safe_divide(
        count(distinct j.member_id),
        cs.cohort_members
    ) as retention_rate

from joined j

join cohort_size cs
    on j.cohort_month = cs.cohort_month

group by
    j.cohort_month,
    j.months_since_signup,
    cs.cohort_members