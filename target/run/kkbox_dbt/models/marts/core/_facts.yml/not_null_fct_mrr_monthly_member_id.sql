
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select member_id
from `kkbox-analytics`.`dbt_dev_marts`.`fct_mrr_monthly`
where member_id is null



  
  
      
    ) dbt_internal_test