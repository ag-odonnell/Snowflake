
-- Step 1: Create source table with numeric months
CREATE OR REPLACE TABLE EMPLOYEE_SALES_LONG (
    EMPLOYEE STRING,
    MONTH NUMBER,
    SALES NUMBER
);

-- Step 2: Insert sample data
INSERT INTO EMPLOYEE_SALES_LONG (EMPLOYEE, MONTH, SALES) VALUES
  ('Alice', 1, 100),  -- January
  ('Alice', 2, 120),  -- February
  ('Alice', 3, 120),  -- March
  ('Alice', 4, 150),  -- April
  ('Bob', 1, 90),
  ('Bob', 2, 110),
  ('Bob', 3, 90),
  ('Bob', 4, 110);

SELECT * FROM EMPLOYEE_SALES_LONG

--##########################################################################

-- Step 3a: Create wide-format table using PIVOT
CREATE OR REPLACE TABLE EMPLOYEE_SALES_WIDE AS
SELECT *
FROM (
    SELECT EMPLOYEE, MONTH, SALES
    FROM EMPLOYEE_SALES_LONG
)
PIVOT (
    MAX(SALES)
    FOR MONTH IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
);

SELECT * FROM EMPLOYEE_SALES_WIDE

--##########################################################################

-- Step 3b: Create wide table with meaningful column names
CREATE OR REPLACE TABLE EMPLOYEE_SALES_WIDE AS
WITH pivoted AS (
  SELECT *
  FROM (
    SELECT EMPLOYEE, MONTH, SALES
    FROM EMPLOYEE_SALES_LONG
  )
  PIVOT (
    MAX(SALES)
    FOR MONTH IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
  )
)

-- Step 2: Rename the output columns
SELECT
  EMPLOYEE,
  "1"  AS SALES_01,
  "2"  AS SALES_02,
  "3"  AS SALES_03,
  "4"  AS SALES_04,
  "5"  AS SALES_05
FROM pivoted;

SELECT * FROM EMPLOYEE_SALES_WIDE
