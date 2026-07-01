select distinct
    msno as member_id,
    is_churn

from {{ source('kkbox_raw', 'train') }}