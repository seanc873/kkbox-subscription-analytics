select distinct
    registration_channel as channel_key,
    concat('Channel ', cast(registration_channel as string)) as channel_label

from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__members`

where registration_channel is not null