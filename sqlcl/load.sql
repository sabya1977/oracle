-- 
-- Desc: Illustrate how to load csv files into Oracle tables using SQLcl
-- Date: 11-03-2024
-- Author: Sabyasachi Mitra
-- 
show loadformat
/*
csv
column_names on
delimiter ,
enclosures ""
double
encoding UTF8
row_limit off
row_terminator default
skip_rows 0
skip_after_names
*/
--  
-- This will show the DDL for the mentioned
-- csv file even before the table exists
-- 
load table cities C:\Users\sabya\gitrepos\data\worldcities.csv show_ddl
-- 
DROP TABLE cities;
-- 
CREATE TABLE ORADEV21.CITIES
 (
  CITY VARCHAR2(55),
  CITY_ASCII VARCHAR2(55),
  LAT NUMBER(8, 4),
  LNG NUMBER(9, 4),
  COUNTRY VARCHAR2(55),
  ISO2 VARCHAR2(26),
  ISO3 VARCHAR2(26),
  ADMIN_NAME VARCHAR2(128),
  CAPITAL VARCHAR2(26),
  POPULATION NUMBER(15),
  ID NUMBER(15)
 );
--  
-- load the table using load command
-- 
set loadformat csv column_names on row_limit off

load cities C:\Users\sabya\gitrepos\data\worldcities.csv
