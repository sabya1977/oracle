-- SQL Query to display all model details along with their car names
-- This query joins MODEL_DETAILS with CAR_NAMES, CAR_MAKERS and COUNTRIES
-- to provide a comprehensive view of car models and their descriptions

SELECT 
    md.MODELID,
    md.MODEL,
    cm.MAKER AS BRAND_NAME,
    cm.FULLNAME AS MANUFACTURER,
    c.COUNTRYNAME AS ORIGIN_COUNTRY,
    c.COUNTRY_CODE,
    cn.DESCR AS MODEL_DESCRIPTION
FROM 
    CARS.MODEL_DETAILS md
JOIN 
    CARS.CAR_MAKERS cm ON md.MAKER = cm.ID
LEFT JOIN 
    CARS.CAR_NAMES cn ON md.MODEL = cn.MODEL
LEFT JOIN 
    CARS.COUNTRIES c ON cm.COUNTRY = c.COUNTRYID
ORDER BY 
    c.COUNTRYNAME, cm.MAKER, md.MODEL;
