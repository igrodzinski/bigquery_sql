DECLARE dataset_name STRING DEFAULT 'DM_';

CREATE TEMP TABLE completeness_results AS
SELECT '' AS table_name, '' AS column_name, 0.0 AS fill_percent
WHERE FALSE;

FOR t IN (
  SELECT table_name
  FROM `${dataset_name}.INFORMATION_SCHEMA.TABLES`
  WHERE table_name LIKE 'DIM_%'
)
DO
  CREATE TEMP TABLE columns_list AS
  SELECT column_name
  FROM `${dataset_name}.INFORMATION_SCHEMA.COLUMNS`
  WHERE table_name = t.table_name;

  DECLARE sql_string STRING;

  SET sql_string = (
    SELECT STRING_AGG(
      CONCAT(
        "SELECT '", t.table_name, "' AS table_name, '", column_name, "' AS column_name, ",
        "SAFE_DIVIDE(COUNT(`", column_name, "`), COUNT(*)) * 100 AS fill_percent ",
        "FROM `", dataset_name, ".", t.table_name, "`"
      ),
      " UNION ALL "
    )
    FROM columns_list
  );

  EXECUTE IMMEDIATE FORMAT("""
    INSERT INTO completeness_results
    %s
  """, sql_string);

  DROP TABLE columns_list;
END FOR;

SELECT * FROM completeness_results;
