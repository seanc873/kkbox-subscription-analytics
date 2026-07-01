
    
    

with dbt_test__target as (

  select payment_method_key as unique_field
  from `kkbox-analytics`.`dbt_dev_marts`.`dim_payment_method`
  where payment_method_key is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


