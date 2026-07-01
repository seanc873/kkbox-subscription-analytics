
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`not_null_stg_kkbox__members_member_id`
    
      
    ) dbt_internal_test