
-- Step 1: Create source table with numeric months
CREATE OR REPLACE TABLE EMPLOYEE_SALES_LONG (
    EMPLOYEE STRING,
    MONTH NUMBER,
    SALES NUMBER,
    RETURNS NUMBER
);

-- Step 2: Insert sample data
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

CREATE OR REPLACE TEMP TABLE sales_pivot AS
WITH extracted AS (
  SELECT EMPLOYEE, TO_NUMBER(RIGHT(MONTH::STRING, 2)) AS MO_NUM, SALES
  FROM EMPLOYEE_SALES_LONG
)
SELECT *
FROM extracted
PIVOT (
  MAX(SALES)
  FOR MO_NUM IN (1, 2, 3, 4, 5)
);

SELECT * FROM sales_pivot;

--##########################################################################

CREATE OR REPLACE TEMP TABLE returns_pivot AS
WITH extracted AS (
  SELECT EMPLOYEE, TO_NUMBER(RIGHT(MONTH::STRING, 2)) AS MO_NUM, RETURNS
  FROM EMPLOYEE_SALES_LONG
)
SELECT *
FROM extracted
PIVOT (
  MAX(RETURNS)
  FOR MO_NUM IN (1, 2, 3, 4, 5)
);

SELECT * FROM returns_pivot;

--##########################################################################

-- SELECT
--   s.EMPLOYEE,
--   s."1" AS SALES_01,
--   s."2" AS SALES_02,
--   s."3" AS SALES_03,
--   r."1" AS RETURNS_01,
--   r."2" AS RETURNS_02,
--   r."3" AS RETURNS_03
-- FROM sales_pivot s
-- JOIN returns_pivot r
--   ON s.EMPLOYEE = r.EMPLOYEE;

--##########################################################################

CREATE OR REPLACE TABLE EMPLOYEE_SALES_WIDE AS
SELECT
  s.EMPLOYEE,
  s."1" AS SALES_01,
  s."2" AS SALES_02,
  s."3" AS SALES_03,
  s."4" AS SALES_04,
  r."1" AS RETURNS_01,
  r."2" AS RETURNS_02,
  r."3" AS RETURNS_03,
  r."4" AS RETURNS_04
FROM sales_pivot s
JOIN returns_pivot r
  ON s.EMPLOYEE = r.EMPLOYEE;

SELECT * FROM EMPLOYEE_SALES_WIDE;
