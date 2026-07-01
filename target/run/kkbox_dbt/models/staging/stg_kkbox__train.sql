

  create or replace view `kkbox-analytics`.`dbt_dev_staging`.`stg_kkbox__train`
  OPTIONS()
  as select distinct
    msno as member_id,
    is_churn

from `kkbox-analytics`.`kkbox_raw`.`train`;

