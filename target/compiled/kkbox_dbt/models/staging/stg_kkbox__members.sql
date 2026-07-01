with source as (

    select * from `kkbox-analytics`.`kkbox_raw`.`members`

),

cleaned as (

    select
        msno as member_id,
        city,
        -- 'bd' (age) is famously dirty: 0s, negatives, and values like 1000.
        -- Keep only plausible ages; everything else becomes NULL.
        case when bd between 1 and 100 then bd end as age,
        nullif(trim(gender), '') as gender,
        registered_via as registration_channel,
        parse_date('%Y%m%d', cast(registration_init_time as string)) as registration_date
    from source

)

select * from cleaned