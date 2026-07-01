
    
    

with all_values as (

    select
        is_churn as value_field,
        count(*) as n_records

    from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__train`
    group by is_churn

)

select *
from all_values
where value_field not in (
    '0','1'
)


