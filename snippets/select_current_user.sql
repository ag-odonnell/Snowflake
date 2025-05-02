-- SELECT CURRENT_USER();

SELECT 
    CURRENT_USER() AS user_id,
    CURRENT_ROLE() AS role,
    CURRENT_ACCOUNT() AS account,
    CURRENT_REGION() AS region,
    CURRENT_DATABASE() AS database,
    CURRENT_SCHEMA() AS schema;
