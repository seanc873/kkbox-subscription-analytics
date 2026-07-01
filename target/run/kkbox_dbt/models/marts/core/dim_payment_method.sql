
  
    

    create or replace table `kkbox-analytics`.`dbt_dev_marts`.`dim_payment_method`
      
    
    

    
    OPTIONS()
    as (
      select distinct
    payment_method_id as payment_method_key,
    concat('Method ', cast(payment_method_id as string)) as payment_method_label

from `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__transactions`

where payment_method_id is not null
    );
  