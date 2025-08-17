REM   Script: Live SQL AV Schema DBMS_CLOUD.COPY_DATA
REM   The AV schema is the schema used by many Live SQL analytic view tutorials.  THIS SCRIPT WILL NOT RUN ON LIVE SQL. Use this script to run tutorials on your local Autonomous Database Instance using DBMS_CLOUD.COPY_DATA.

drop user av cascade;
--
create user av identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
--
alter user av
quota unlimited on users;
--
--
CREATE TABLE av.geography_dim (
    "REGION_ID"             VARCHAR2(120),
    "REGION_NAME"           VARCHAR2(100),
    "COUNTRY_ID"            VARCHAR2(2),
    "COUNTRY_NAME"          VARCHAR2(120),
    "STATE_PROVINCE_ID"     VARCHAR2(120),
    "STATE_PROVINCE_NAME"   VARCHAR2(400)
);
--
CREATE TABLE av.product_dim (
    "CATEGORY_ID"       INTEGER,
    "CATEGORY_NAME"     VARCHAR2(100),
    "DEPARTMENT_ID"     INTEGER,
    "DEPARTMENT_NAME"   VARCHAR2(100)
);
--
CREATE TABLE av.sales_fact (
    "MONTH_ID"            VARCHAR2(10),
    "CATEGORY_ID"         NUMBER,
    "STATE_PROVINCE_ID"   VARCHAR2(120),
    "UNITS"               NUMBER,
    "SALES"               NUMBER
);
CREATE TABLE av.time_dim (
    "MONTH_ID"           VARCHAR2(30),
    "MONTH_NAME"         VARCHAR2(40),
    "MONTH_LONG_NAME"    VARCHAR2(30),
    "MONTH_END_DATE"     DATE,
    "MONTH_OF_QUARTER"   NUMBER,
    "MONTH_OF_YEAR"      INTEGER,
    "QUARTER_ID"         VARCHAR2(30),
    "QUARTER_NAME"       VARCHAR2(40),
    "QUARTER_END_DATE"   DATE,
    "QUARTER_OF_YEAR"    NUMBER,
    "SEASON"             VARCHAR2(10),
    "SEASON_ORDER"       NUMBER,
    "YEAR_ID"            VARCHAR2(30),
    "YEAR_NAME"          VARCHAR2(40),
    "YEAR_END_DATE"      DATE
);

