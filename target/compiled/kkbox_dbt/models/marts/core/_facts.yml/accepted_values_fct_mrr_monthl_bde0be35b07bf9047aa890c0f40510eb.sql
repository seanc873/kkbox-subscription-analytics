
    
    

with all_values as (

    select
        movement_type as value_field,
        count(*) as n_records

    from `kkbox-analytics`.`dbt_dev_marts`.`fct_mrr_monthly`
    group by movement_type

)

select *
from all_values
where value_field not in (
    'new','expansion','contraction','churn','reactivation','retained'
)


