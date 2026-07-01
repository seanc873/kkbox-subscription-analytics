
    
    

with dbt_test__target as (

  select daily_listening_key as unique_field
  from `kkbox-analytics`.`dbt_dev_marts`.`fct_daily_listening`
  where daily_listening_key is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


