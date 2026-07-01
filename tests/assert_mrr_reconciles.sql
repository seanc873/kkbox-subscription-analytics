-- The sum of monthly movements must equal the change in total MRR.
-- If our waterfall logic has a bug, the two won't agree, and this fails.

with monthly as (

    select
        date_key as month_start,
        sum(mrr) as total_mrr,
        sum(movement_amount) as total_movement

    from {{ ref('fct_mrr_monthly') }}

    group by 1

),

sequenced as (

    select
        month_start,
        total_mrr,
        total_movement,
        lag(total_mrr) over (
            order by month_start
        ) as prev_total_mrr

    from monthly

)

select
    month_start,
    total_movement,
    total_mrr - prev_total_mrr as expected_movement

from sequenced

where prev_total_mrr is not null
    -- Allow a dollar of rounding slack.
    and abs(total_movement - (total_mrr - prev_total_mrr)) > 1