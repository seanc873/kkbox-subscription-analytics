with source as (

    select * from `kkbox-analytics`.`kkbox_raw`.`user_logs`

),

typed as (

    select
        msno as member_id,
        parse_date('%Y%m%d', cast(date as string)) as activity_date,
        num_25, num_50, num_75, num_985, num_100,
        num_unq as unique_songs,
        total_secs as total_seconds
    from source

),

deduped as (

    -- One clean row per member per day
    select
        member_id,
        activity_date,
        sum(num_25) as songs_25pct,
        sum(num_50) as songs_50pct,
        sum(num_75) as songs_75pct,
        sum(num_985) as songs_985pct,
        sum(num_100) as songs_100pct,
        max(unique_songs) as unique_songs,
        sum(total_seconds) as total_seconds
    from typed
    group by member_id, activity_date

)

select *
from deduped