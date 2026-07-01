select *
from {{ ref('fct_daily_listening') }}
where activity_date > current_date()