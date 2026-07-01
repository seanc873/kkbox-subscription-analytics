
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`accepted_values_fct_mrr_monthl_bde0be35b07bf9047aa890c0f40510eb`
    
      
    ) dbt_internal_test