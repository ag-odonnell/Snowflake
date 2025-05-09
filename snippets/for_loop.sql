
-- This behaves exactly like a traditional for loop in other programming languages:
-- -- yr is the loop variable
-- -- start_year..end_year defines the inclusive range (think of ".." as both "%to" and "yr+1" in one)
-- -- The loop automatically increments by 1
-- -- It executes once for each yr in the range
-- also see: https://github.com/ag-odonnell/Snowflake/blob/main/snippets/scalar_variable_create.sql

FOR yr IN start_year..end_year DO
    -- logic using yr
END FOR;
