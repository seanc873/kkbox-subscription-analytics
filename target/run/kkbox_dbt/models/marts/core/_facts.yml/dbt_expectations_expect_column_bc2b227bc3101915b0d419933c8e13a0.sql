
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`dbt_expectations_expect_column_bc2b227bc3101915b0d419933c8e13a0`
    
      
    ) dbt_internal_test