
-- Step 0: Create source table with numeric months
CREATE OR REPLACE TABLE EMPLOYEE_SALES_LONG (
    EMPLOYEE STRING,
    MONTH NUMBER,
    SALES NUMBER,
    RETURNS NUMBER
);

-- Step 1: Insert sample data
INSERT INTO EMPLOYEE_SALES_LONG (EMPLOYEE, MONTH, SALES, RETURNS) VALUES
  ('Alice', 202501, 100, 10),  -- January
  ('Alice', 202502, 120, 20),  -- February
  ('Alice', 202503, 120, 30),  -- March
  ('Alice', 202504, 150, 40),  -- April
  ('Bob', 202501, 90, 10),
  ('Bob', 202502, 110, 20),
  ('Bob', 202503, 90, 30),
  ('Bob', 202504, 110, 40);

SELECT * FROM EMPLOYEE_SALES_LONG;

--##########################################################################

CREATE OR REPLACE TABLE EMPLOYEE_SALES_WIDE AS
WITH 

-- Step 2: Pivot Sales in single CTE
sales_pivot AS (
  SELECT *
  FROM (
    SELECT
      EMPLOYEE,
      TO_NUMBER(RIGHT(MONTH::STRING, 2)) AS MO_NUM,
      SALES
    FROM EMPLOYEE_SALES_LONG
    GROUP BY EMPLOYEE, TO_NUMBER(RIGHT(MONTH::STRING, 2)), SALES
  ) base
  PIVOT (
    MAX(SALES)
    FOR MO_NUM IN (1, 2, 3, 4, 5)
  )
),

--##########################################################################

-- Step 3: Pivot Returns in single CTE
returns_pivot AS (
  SELECT *
  FROM (
    SELECT
      EMPLOYEE,
      TO_NUMBER(RIGHT(MONTH::STRING, 2)) AS MO_NUM,
      RETURNS
    FROM EMPLOYEE_SALES_LONG
    GROUP BY EMPLOYEE, TO_NUMBER(RIGHT(MONTH::STRING, 2)), RETURNS
  ) base
  PIVOT (
    MAX(RETURNS)
    FOR MO_NUM IN (1, 2, 3, 4, 5)
  )
)

--##########################################################################

-- Step 4: Create output table with renamed columns
SELECT 
  s.EMPLOYEE,
  s."1" AS SALES_01,
  s."2" AS SALES_02,
  r."1" AS RETURNS_01,
  r."2" AS RETURNS_02
FROM sales_pivot s
JOIN returns_pivot r
  ON s.EMPLOYEE = r.EMPLOYEE;

-- Step 5: View results
SELECT * FROM EMPLOYEE_SALES_WIDE;
