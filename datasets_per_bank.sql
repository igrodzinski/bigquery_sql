WITH PatternedDatasets AS (
  -- Krok 1: Znajdź i zgrupuj datasety pasujące do wzorca '_DDDD'
  SELECT
    SUBSTR(schema_name, -4) AS four_digits,
    STRING_AGG(REPLACE(schema_name, CONCAT('_', SUBSTR(schema_name, -4)), ''), ', ') AS dataset_list
  FROM
    INFORMATION_SCHEMA.SCHEMATA
  WHERE
    -- Filtruj tylko te nazwy, które kończą się podkreślnikiem i 4 cyframi
    REGEXP_CONTAINS(schema_name, r'_\d{4}$')
  GROUP BY
    four_digits
),
SpecialDataset AS (
  -- Krok 2: Znajdź specjalny dataset 'gcp_prod_logs', jeśli istnieje
  SELECT
    '---' AS four_digits, -- Placeholder dla cyfr
    'gcp_prod_logs' AS dataset_list
  FROM
    INFORMATION_SCHEMA.SCHEMATA
  WHERE
    schema_name = 'gcp_prod_logs'
)

-- Krok 3: Połącz oba zbiory wyników
SELECT * FROM PatternedDatasets
UNION ALL
SELECT * FROM SpecialDataset;
