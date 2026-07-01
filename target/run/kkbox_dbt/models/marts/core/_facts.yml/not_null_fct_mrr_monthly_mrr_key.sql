
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`not_null_fct_mrr_monthly_mrr_key`
    
      
    ) dbt_internal_test