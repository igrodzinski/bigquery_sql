-- ZAMIEN TO NA WLASNE
DECLARE dataset_name STRING DEFAULT 'my_dataset';
DECLARE table_name STRING DEFAULT 'my_table';

-- Krok 1: Pobierz listę kolumn
CREATE TEMP TABLE columns_list AS
SELECT column_name
FROM `my_dataset.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = table_name;

-- Krok 2: Zbuduj i wykonaj zapytanie dynamiczne
DECLARE sql_string STRING;

SET sql_string = (
  SELECT STRING_AGG(
    FORMAT("""
    SELECT 
      '%1$s' AS column_name,
      SAFE_DIVIDE(COUNT(%1$s), COUNT(*)) * 100 AS fill_percent
    FROM `%2$s.%3$s`""",
      column_name, dataset_name, table_name
    )
    , ' UNION ALL ')
  FROM columns_list
);

EXECUTE IMMEDIATE sql_string;
