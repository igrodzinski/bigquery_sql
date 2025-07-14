CREATE TEMP TABLE columns_list AS
SELECT column_name
FROM `my_dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'my_table';

DECLARE sql_string STRING;

SET sql_string = (
  SELECT STRING_AGG(
    CONCAT(
      "SELECT '", column_name, "' AS column_name, ",
      "SAFE_DIVIDE(COUNT(`", column_name, "`), COUNT(*)) * 100 AS fill_percent ",
      "FROM `my_dataset.my_table`"
    ),
    " UNION ALL "
  )
  FROM columns_list
);

EXECUTE IMMEDIATE sql_string;
