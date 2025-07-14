-- Krok 1: Ustaw szczegóły dotyczące Twojej tabeli
DECLARE project_id STRING DEFAULT 'twoj-projekt-id';
DECLARE dataset_id STRING DEFAULT 'twoj-zbior-danych';
DECLARE table_id STRING DEFAULT 'twoja-tabela';

-- Krok 2: Zbuduj i wykonaj dynamiczne zapytanie
EXECUTE IMMEDIATE (
  SELECT
    STRING_AGG(
      FORMAT("""
        SELECT
          '%s' AS nazwa_kolumny,
          ROUND(100 * SAFE_DIVIDE(COUNT(%s), COUNT(*)), 2) AS procent_wypelnienia
        FROM
          `%s.%s.%s`
      """,
      column_name, -- Nazwa kolumny wstawiona do zapytania
      column_name, -- Nazwa kolumny użyta w funkcji COUNT
      project_id,  -- ID projektu
      dataset_id,  -- Nazwa zbioru danych
      table_id     -- Nazwa tabeli
      ),
      ' UNION ALL '
    )
  FROM
    `region-eu.INFORMATION_SCHEMA.COLUMNS` -- Pamiętaj o ustawieniu właściwego regionu dla INFORMATION_SCHEMA
  WHERE
    table_schema = dataset_id AND table_name = table_id
);

