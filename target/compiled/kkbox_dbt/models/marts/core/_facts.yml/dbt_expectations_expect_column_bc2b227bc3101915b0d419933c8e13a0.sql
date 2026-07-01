






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and total_seconds >= 0 and total_seconds <= 200000
)
 as expression


    from `kkbox-analytics`.`dbt_dev_marts`.`fct_daily_listening`
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors







