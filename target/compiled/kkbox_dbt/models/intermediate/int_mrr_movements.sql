with mrr as (

    select
        member_id,
        month_start,
        mrr

    from `kkbox-analytics`.`dbt_dev_intermediate`.`int_mrr_monthly`

),

months as (

    select distinct
        month_start

    from `kkbox-analytics`.`dbt_dev_marts`.`dim_date`

    where month_start <= date '2017-04-01'

),

-- Each member's active span, extended one month so churn appears
member_span as (

    select
        member_id,
        min(month_start) as first_month,
        date_add(max(month_start), interval 1 month) as churn_check_month

    from mrr

    group by member_id

),

-- A complete month grid per member (no gaps)
grid as (

    select
        s.member_id,
        m.month_start

    from member_span s

    join months m
        on m.month_start between s.first_month and s.churn_check_month

),

-- Fill in MRR (0 when the member wasn't active that month)
filled as (

    select
        g.member_id,
        g.month_start,
        coalesce(mr.mrr, 0) as mrr

    from grid g

    left join mrr mr
        on g.member_id = mr.member_id
       and g.month_start = mr.month_start

),

-- Look back one month with LAG
sequenced as (

    select
        member_id,
        month_start,
        mrr,
        lag(mrr) over (
            partition by member_id
            order by month_start
        ) as prev_mrr,
        lag(month_start) over (
            partition by member_id
            order by month_start
        ) as prev_month

    from filled

)

select
    member_id,
    month_start,
    mrr,
    prev_mrr,

    case
        when (prev_mrr is null or prev_mrr = 0)
             and mrr > 0
             and prev_month is null then 'new'
        when (prev_mrr = 0 or prev_mrr is null)
             and mrr > 0 then 'reactivation'
        when prev_mrr > 0
             and mrr = 0 then 'churn'
        when mrr > prev_mrr then 'expansion'
        when mrr < prev_mrr then 'contraction'
        else 'retained'
    end as movement_type,

    case
        when prev_mrr > 0 and mrr = 0 then -prev_mrr -- churn is a negative
        when prev_mrr is null then mrr              -- new adds full MRR
        else mrr - coalesce(prev_mrr, 0)
    end as movement_amount

from sequenced

where not (
    mrr = 0
    and coalesce(prev_mrr, 0) = 0
) -- Drop dead-air months