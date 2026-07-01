select *
from `kkbox-analytics`.`dbt_dev_marts`.`fct_daily_listening`
where activity_date > current_date()