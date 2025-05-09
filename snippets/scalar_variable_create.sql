
-- Snowflake supports only scalar variables in its SQL stored procedures (no arrays, no maps, etc.).
-- You can use them for control flow, string construction, dynamic SQL, logging, etc.
-- When you see DECLARE, you're defining scalars unless you're in Snowflake's JavaScript mode (which can support arrays and objects).

CREATE OR REPLACE PROCEDURE SOME_CATALOG.SOME_SCHEMA.CREATE_SOME_TABLE_BY_YEAR(start_year NUMBER, end_year NUMBER)
RETURNS STRING
LANGUAGE SQL
AS
$$
    DECLARE
        yr NUMBER;
        stmt STRING;
        table_name STRING;
        log_message STRING;
    BEGIN
        FOR yr IN start_year..end_year DO

            -- Dynamically name the table
            LET table_name = 'SOME_TABLE_' || yr;

            -- Drop table if it exists (or replace with SKIP/INSERT strategy if preferred)
            IF EXISTS (
                SELECT 1 FROM INFORMATION_SCHEMA.TABLES 
                WHERE TABLE_NAME = :table_name AND TABLE_SCHEMA = 'SOME_SCHEMA' AND TABLE_CATALOG = 'SOME_CATALOG'
            ) THEN
                EXECUTE IMMEDIATE 'DROP TABLE SOME_CATALOG.SOME_SCHEMA.' || table_name;
            END IF;

            -- Build the dynamic SQL for table creation and rescale calculation
            LET stmt = '
                CREATE TABLE SOME_CATALOG.SOME_SCHEMA.' || table_name || '
                CLUSTER BY (BENE_ID)
                AS
                    ...
            ';

            -- Execute the dynamic SQL
            EXECUTE IMMEDIATE :stmt;

            -- Log successful creation
            LET log_message = 'Created table ' || table_name || ' for year ' || yr;
            INSERT INTO SOME_CATALOG.SOME_SCHEMA.SOME_TABLE_LOG
            VALUES (:yr, 'SUCCESS', CURRENT_TIMESTAMP(), CURRENT_USER(), :log_message);

        END FOR;

        RETURN 'Completed Table creation for years ' || start_year || ' to ' || end_year;
    END;
$$;

-- create seperate script to call procedure
CALL SOME_CATALOG.SOME_SCHEMA.CREATE_SOME_TABLE_BY_YEAR(2023, 2024);
