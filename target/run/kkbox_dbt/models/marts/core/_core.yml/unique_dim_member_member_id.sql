
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`unique_dim_member_member_id`
    
      
    ) dbt_internal_test