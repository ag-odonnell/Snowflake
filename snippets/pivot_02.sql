
-- Step 1: Create source table with numeric months
CREATE OR REPLACE TABLE EMPLOYEE_SALES_LONG (
    EMPLOYEE STRING,
    MONTH NUMBER,
    SALES NUMBER
);

-- Step 2: Insert sample data
INSERT INTO EMPLOYEE_SALES_LONG (EMPLOYEE, MONTH, SALES) VALUES
  ('Alice', 202501, 100),  -- January
  ('Alice', 202502, 120),  -- February
  ('Alice', 202503, 120),  -- March
  ('Alice', 202504, 150),  -- April
  ('Bob', 202501, 90),
  ('Bob', 202502, 110),
  ('Bob', 202503, 90),
  ('Bob', 202504, 110);

SELECT * FROM EMPLOYEE_SALES_LONG;

CREATE OR REPLACE TABLE EMPLOYEE_SALES_WIDE AS
-- Step 1: Extract 2-digit month portion from YYYYMM
WITH extracted AS (
  SELECT
    EMPLOYEE,
    RIGHT(MONTH::STRING, 2) AS MO_NUM,
    SALES
  FROM EMPLOYEE_SALES_LONG
),

-- Step 2: Pivot using MO_NUM as month key
pivoted AS (
  SELECT *
  FROM extracted
  PIVOT (
    MAX(SALES)
    FOR MO_NUM IN ('01', '02', '03', '04', '05', '06',
                   '07', '08', '09', '10', '11', '12')
  )
)

-- Step 3: Create output table with renamed columns
SELECT
  EMPLOYEE,
  "'01'",
  "'02'" AS SALES_02
FROM pivoted;
SELECT * FROM EMPLOYEE_SALES_WIDE;
