-- 
-- Desc: Illustrate the use of KEEP clause in analytic SQL
-- Date: 11-03-2024
-- Author: Sabyasachi Mitra
-- 
-- 
SELECT * FROM CITIES;
-- Suppose we are asked to produce number of cities 
-- in a country along with maximum population.
SELECT 
    country,
    COUNT(*) num_city, 
    MAX(population) max_pop 
FROM cities
GROUP BY country 
HAVING COUNT(*) > 1000;
-- 
-- In this output while maximum population is given but city name is not given.
-- 
/*
COUNTRY              NO_CITY     MAX_POP
_________________ __________ ___________
United States           5324    18908608
Brazil                  2937    23086000
Italy                   1355     2748109
Japan                   1337    37732000
Russia                  1217    17332000
Germany                 1747     4890363
France                  1152    11060000
China                   1663    26940000
Philippines             1584    24922000
India                   7031    32226000
United Kingdom          1331    11262000
*/
-- 
-- If we add city name in the query, we will 
-- get an error that city is not part of GROUP 
-- BY clause.
-- 
SELECT 
    country,
    city,
    COUNT(*) num_city, 
    MAX(population) max_pop 
FROM cities
GROUP BY country 
HAVING COUNT(*) > 1000;
-- 
-- SQL Error: ORA-00979: not a GROUP BY expression
-- 
-- One way to get the city name is to use subquery factoring
-- 
WITH city_max AS
(
    SELECT 
        country,
        COUNT(*) num_city, 
        MAX(population) max_pop 
    FROM cities
    GROUP BY country HAVING COUNT(*) > 1000
)
SELECT 
    cm.country, c.city, cm.num_city, cm.max_pop
FROM
    cities c
INNER JOIN
    city_max cm
ON c.country = cm.country AND c.population = cm.max_pop;
-- 
-- Another way of achieving this result is to using analytic function
-- 
-- 
WITH max_pop_city AS
(
    SELECT 
        country,
        city,
        population,
        COUNT(*) OVER (PARTITION BY country) AS num_city,
        MAX(population) OVER (PARTITION BY country) AS max_pop
    FROM cities
)
SELECT 
    mc.country,
    mc.city,
    mc.population
FROM 
max_pop_city mc
WHERE mc.max_pop = population AND mc.num_city > 1000;
-- 
/*

COUNTRY           CITY            POPULATION
_________________ ____________ _____________
Brazil            Sπo Paulo         23086000
China             Guangzhou         26940000
France            Paris             11060000
Germany           Berlin             4890363
India             Delhi             32226000
Italy             Rome               2748109
Japan             Tokyo             37732000
Philippines       Manila            24922000
Russia            Moscow            17332000
United Kingdom    London            11262000
United States     New York          18908608
*/
-- 
-- But the more concise way to produce the same result is to use KEEP clause
-- 
SELECT 
    country,
    MAX(city) KEEP (DENSE_RANK FIRST ORDER BY population DESC NULLS LAST) city,
    COUNT(*) num_city, 
    MAX(population) max_pop    
FROM cities
GROUP BY country 
HAVING COUNT(*) > 1000;
-- 
/*
COUNTRY           CITY            NUM_CITY     MAX_POP
_________________ ____________ ___________ ___________
Brazil            Sπo Paulo           2937    23086000
China             Guangzhou           1663    26940000
France            Paris               1152    11060000
Germany           Berlin              1747     4890363
India             Delhi               7031    32226000
Italy             Rome                1355     2748109
Japan             Tokyo               1337    37732000
Philippines       Manila              1584    24922000
Russia            Moscow              1217    17332000
United Kingdom    London              1331    11262000
United States     New York            5324    18908608
*/
