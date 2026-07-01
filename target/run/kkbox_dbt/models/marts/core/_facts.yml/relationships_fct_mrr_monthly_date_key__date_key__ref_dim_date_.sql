
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
        select *
        from `kkbox-analytics`.`dbt_dev_test_failures`.`relationships_fct_mrr_monthly_date_key__date_key__ref_dim_date_`
    
      
    ) dbt_internal_test