--
-- Demonstrating Oracle DML error logging feature
-- Author: Sabyasachi Mitra
-- Date: 05/20/2025
--
-- Oracle Database logs the following errors during DML operations:
--------------------------------------------------------------------
-- Column values that are too large
-- Constraint violations (NOT NULL, unique, referential, and check 
-- constraints).
-- Errors raised during trigger execution
-- Errors resulting from type conversion between a column in a subquery
-- and the corresponding column of the table
-- Partition mapping errors
-- Certain MERGE operation errors (ORA-30926: Unable to get a stable set
-- of rows for MERGE operation.)
--
DROP TABLE demo_stg.emp1;
DROP TABLE demo_stg.emp2;
DROP TABLE demo_stg.emp3;
--
DROP TABLE ERR$_EMP1;

CREATE TABLE emp1 (
    id      NUMBER PRIMARY KEY,
    name    VARCHAR2(50),
    age     NUMBER,
    salary  NUMBER
);

-- New data to update salaries
CREATE TABLE emp2 (
    id      NUMBER,
    new_salary NUMBER
);
--
CREATE TABLE emp3 (
    id      NUMBER,
    new_age NUMBER
);
--
INSERT INTO emp1 VALUES (1, 'Alice', 30, 5000);
INSERT INTO emp1 VALUES (2, 'Bob', 37, 6000);
INSERT INTO emp1 VALUES (3, 'Charlie', 40, 7000);
--
-- Insert into emp2 - Note that we add a duplicate id to simulate ORA-30926
INSERT INTO emp2 VALUES (1, 5500);
INSERT INTO emp2 VALUES (2, 6500);
INSERT INTO emp2 VALUES (2, 6600);  -- Duplicate row will cause ORA-30926
INSERT INTO emp2 VALUES (4, 7200);  -- No matching id in emp1
--
-- age
INSERT INTO emp3 VALUES (1, 32);
INSERT INTO emp3 VALUES (1, 33);
INSERT INTO emp3 VALUES (2, 39);
COMMIT;
--
BEGIN
    DBMS_ERRLOG.create_error_log(dml_table_name => 'EMP1');
END;
/
--
MERGE INTO emp1 e
USING (
    SELECT e2.id, e2.new_salary, e3.new_age
    FROM
        emp2 e2
    INNER JOIN
        emp3 e3
    ON e2.id = e3.id
) src
ON (e.id = src.id)
WHEN MATCHED THEN
  UPDATE SET e.salary = src.new_salary,
             e.age = src.new_age;
--
MERGE INTO emp1 e
USING (
    SELECT e2.id, e2.new_salary, e3.new_age
    FROM
        emp2 e2
    INNER JOIN
        emp3 e3
    ON e2.id = e3.id
) src
ON (e.id = src.id)
WHEN MATCHED THEN
  UPDATE SET e.salary = src.new_salary,
             e.age = src.new_age
  LOG ERRORS INTO ERR$_EMP1 ('MERGE_ERROR') REJECT LIMIT UNLIMITED;
--
SELECT * FROM emp1;
--
SELECT * FROM ERR$_EMP1;

SELECT
    ID,
    NAME,
    AGE,
    SALARY
FROM
    EMP2;

SELECT
    ID,
    NAME,
    AGE,
    SALARY
FROM
    EMP1;
--
--
DROP TABLE IF EXISTS TEST_DATA;
DROP TABLE IF EXISTS ERR$_TEST_DATA;
DROP TABLE IF EXISTS STAGING_DATA1;
DROP TABLE IF EXISTS STAGING_DATA2;
-- Create target table;
CREATE TABLE IF NOT EXISTS test_data (
    id      NUMBER,
    salary  NUMBER
);

-- Create error logging table
BEGIN
  DBMS_ERRLOG.create_error_log('TEST_DATA');
END;
/
--
-- Source table with text that may cause conversion error
CREATE TABLE IF NOT EXISTS staging_data1 (
    id      VARCHAR2(10),
    salary  VARCHAR2(20)
);
--
CREATE TABLE IF NOT EXISTS staging_data2 (
    id      VARCHAR2(10),
    salary  VARCHAR2(20)
);
--
-- Insert good and bad data
INSERT INTO staging_data1 VALUES ('1', 'abc');  -- invalid number
INSERT INTO staging_data2 VALUES ('2', '1000'); -- valid
--
COMMIT;
-- Now do INSERT with explicit conversion (TO_NUMBER) in SELECT
INSERT INTO test_data (id, salary)
SELECT TO_NUMBER(id), TO_NUMBER(salary)
FROM STAGING_DATA1
LOG ERRORS INTO err$_test_data ('CONVERSION_ERROR') REJECT LIMIT UNLIMITED;
-- UNION ALL
INSERT INTO test_data (id, salary)
SELECT TO_NUMBER(id), TO_NUMBER(salary)
FROM STAGING_DATA2
LOG ERRORS INTO err$_test_data ('CONVERSION_ERROR') REJECT LIMIT UNLIMITED;
--
SELECT * FROM TEST_DATA;
SELECT * FROM ERR$_TEST_DATA;