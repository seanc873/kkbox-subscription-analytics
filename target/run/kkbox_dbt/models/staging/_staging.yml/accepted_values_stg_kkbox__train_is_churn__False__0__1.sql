
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`accepted_values_stg_kkbox__train_is_churn__False__0__1`
    
      
    ) dbt_internal_test