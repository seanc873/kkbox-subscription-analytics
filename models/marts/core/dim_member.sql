with members as (

    select *
    from {{ ref('stg_kkbox__members') }}

),

labels as (

    select *
    from {{ ref('stg_kkbox__train') }}

),

final as (

    select
        m.member_id,
        m.city,
        m.age,

        case
            when m.age is null then 'Unknown'
            when m.age < 18 then 'Under 18'
            when m.age between 18 and 24 then '18-24'
            when m.age between 25 and 34 then '25-34'
            when m.age between 35 and 44 then '35-44'
            else '45+'
        end as age_band,

        coalesce(m.gender, 'unknown') as gender,
        m.registration_channel,
        m.registration_date,
        date_diff(date '2017-03-31', m.registration_date, day) as tenure_days,
        l.is_churn

    from members m

    left join labels l
        on m.member_id = l.member_id

)

select *
from final