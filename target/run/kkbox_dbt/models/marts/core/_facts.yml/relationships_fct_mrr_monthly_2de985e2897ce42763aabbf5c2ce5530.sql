
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`relationships_fct_mrr_monthly_2de985e2897ce42763aabbf5c2ce5530`
    
      
    ) dbt_internal_test