select distinct
    registration_channel as channel_key,
    concat('Channel ', cast(registration_channel as string)) as channel_label

from {{ ref('stg_kkbox__members') }}

where registration_channel is not null