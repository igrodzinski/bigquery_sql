DECLARE var_dataset_name STRING DEFAULT 'DM_';
DECLARE var_table_name STRING DEFAULT 'DIM_BUSINESS';
DECLARE sql_string STRING;
--
CREATE TEMP TABLE columns_list AS
SELECT column_name
FROM `DM_CLIENT_1610.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = var_table_name;
 
SET sql_string = (
  SELECT STRING_AGG(
    CONCAT("SELECT '", column_name, "' AS column_name, ",
    "SAFE_DIVIDE(COUNT(`", column_name, "`), COUNT(*)) * 100 AS fill_percet ",
    "FROM `", var_dataset_name, ".", var_table_name, "`"  
    ),
    " UNION ALL ")
  FROM columns_list
);
 
EXECUTE IMMEDIATE sql_string;
