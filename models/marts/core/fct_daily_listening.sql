{{
    config(
        materialized='table',
        partition_by={
            'field': 'activity_date',
            'data_type': 'date'
        }
    )
}}


with logs as (
    select *
    from {{ ref('stg_kkbox__user_logs') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['member_id', 'activity_date']) }} as daily_listening_key,
    member_id,
    activity_date,
    songs_25pct,
    songs_50pct,
    songs_75pct,
    songs_985pct,
    songs_100pct,
    unique_songs,
    total_seconds
from logs