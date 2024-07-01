/*
simple_tab_func.sql
--
Author: Sabyasachi Mitra
Date: 03/30/2024
Tested on: Oracle 21c
--
Oracle Table functions: Table functions are used to return PL/SQL collections that mimic tables. 
They can be queried like a regular table by using the TABLE operator in the FROM clause. They  
return collections (usually nested tables or varrays), which can then be transformed with the 
TABLE clause into a dataset of rows and columns that can be processed in a SQL statement.
--
Part 1: Deals with simple Table functions
--
*/
--
-- create tyep
CREATE OR REPLACE TYPE t_tf_emp_row AS OBJECT 
(
    emp_id NUMBER(6),
    name VARCHAR2(50)
);
/
--
CREATE TYPE t_tf_emp_tab IS TABLE OF t_tf_emp_row;
/
--
-- the below table function will take a numeric arguement
-- anad returns as many number of rows from the emp table.
--
CREATE OR REPLACE FUNCTION get_emp_tf (num_rows IN NUMBER) RETURN t_tf_emp_tab AS
    l_emp_tab t_tf_emp_tab := t_tf_emp_tab();
BEGIN
    SELECT t_tf_emp_row(empno, ename) BULK COLLECT INTO l_emp_tab FROM emp WHERE rownum <= num_rows;
    RETURN l_emp_tab;
END;
/
--
SELECT * FROM TABLE(get_emp_tf(10));
-- or from 12.2 or higher
SELECT * FROM get_emp_tf(10);