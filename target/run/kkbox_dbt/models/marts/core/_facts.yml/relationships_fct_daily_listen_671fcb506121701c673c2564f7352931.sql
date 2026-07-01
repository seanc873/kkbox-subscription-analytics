
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`relationships_fct_daily_listen_671fcb506121701c673c2564f7352931`
    
      
    ) dbt_internal_test