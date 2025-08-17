-- Query to display car names along with model, description, maker, and country

SELECT 
    cn.ID AS CAR_ID,
    cn.MODEL AS MODEL_NAME,
    cn.DESCR AS DESCRIPTION,
    cm.MAKER AS CAR_MAKER,
    cm.FULLNAME AS MAKER_FULLNAME,
    c.COUNTRYNAME AS COUNTRY,
    c.COUNTRY_CODE
FROM 
    CARS.CAR_NAMES cn
JOIN 
    CARS.MODEL_DETAILS md ON cn.MODEL = md.MODEL
JOIN 
    CARS.CAR_MAKERS cm ON md.MAKER = cm.ID
JOIN 
    CARS.COUNTRIES c ON cm.COUNTRY = c.COUNTRYID
ORDER BY 
    c.COUNTRYNAME, cm.MAKER, cn.MODEL;
