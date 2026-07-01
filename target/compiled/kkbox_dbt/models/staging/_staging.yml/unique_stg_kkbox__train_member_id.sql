
    
    

with dbt_test__target as (

  select member_id as unique_field
  from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__train`
  where member_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


