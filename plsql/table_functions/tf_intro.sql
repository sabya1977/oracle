-- name: tf_intro.sql
-- 
/*
-------------------------
What Is a Table Function?
-------------------------
A table function is a function that can be invoked inside the FROM clause of a 
SELECT statement. They return collections (usually nested tables or varrays), 
which can then be transformed with the TABLE clause into a dataset of rows and
columns that can be processed in a SQL statement. Table functions come in very
handy when you need to:

1) Merge session-specific data with data from tables: you've got data, and lots of
it sitting in tables. But in your session (and not in any tables), you have some
data - and you need to "merge" these two sources together in an SQL statement. 
In other words, you need the set-oriented power of SQL to get some answers. With
the TABLE operator, you can accomplish precisely that.

2) Programmatically construct a dataset to be passed as rows and columns to the 
host environment: Your webpage needs to display some data in a nice neat report. 
That data is, however, far from neat. In fact, you need to execute procedural 
code to construct the dataset. Sure, you could construct the data, insert into a
table, and then SELECT from the table. But with a table function, you can 
deliver that data immediately to the webpage, without any need for non-query 
DML.

3) Emulate a parameterized view: Oracle Database does not allow you to pass 
parameters to a view, but you can pass parameters to a function, and use that
as the basis for what is in essence a parameterized view.

4) Improve performance of parallelized queries with pipelined table functions Many
data warehouse applications rely on Parallel Query to greatly improve performance of massive ETL operations. But if you execute a table function in the FROM clause, that query will serialize (blocked by the call to the function). Unless you define that function a a pipelined function and enable it for parallel execution.
Reduce consumption of Process Global Area (pipelined table functions): 

5) Collections (which are constructed and returned by "normal" table functions) 
can consume an awful lot of PGA (Process Global Area). But if you define that 
table function as pipelined, PGA consumption becomes a non-issue.

To call a function from within the FROM clause of a query, you need to:

1) Define the RETURN datatype of the function to be a collection type (usually 
a nested table or a varray, but under some circumstances you can also use an 
associative array). The type must be defined at the schema level (CREATE [OR 
REPLACE] TYPE) or in package specification (for pipelined table functions only).

2) Make sure that all parameters to the function are of mode IN and have SQL-
-compatible datatypes. (You cannot, for example, call a function with a Boolean
or record type argument inside a query.)

3) Embed the call to the function inside the TABLE clause. Note: as of 12.1, 
you can often invoke the function directly in the FROM clause with using TABLE.
In this tutorial, I will show you how to build and query from a very simply 
table function, one that returns an array of strings (and, more generally, 
scalars). The next tutorial will show you how to work with table functions that
return collections of multiple columns.

*/
-- 
-- Valid Collection Types for Table Functions:
-- 1. The collection type must be declared so that the SQL engine
-- can resolve a reference to it, that it should be declared at schema level.
-- 
-- 2. The collection type (or the attributes within that type) must be 
-- SQL-compatible. You cannot, for example, return a collection of Booleans
-- for a table function.
-- 
-- Create a type
-- 
CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
-- 
-- Create a table function
-- 
CREATE OR REPLACE FUNCTION random_strings (count_in IN INTEGER)
   RETURN strings_t
   AUTHID DEFINER
IS
   l_strings   strings_t := strings_t ();
BEGIN
   l_strings.EXTEND (count_in);

   FOR indx IN 1 .. count_in
   LOOP
      l_strings (indx) := DBMS_RANDOM.string ('u', 10);
   END LOOP;

   RETURN l_strings;
END;
/
-- 
SET SERVEROUTPUT ON
DECLARE
   l_strings   strings_t := random_strings (5);
BEGIN
   FOR indx IN 1 .. l_strings.COUNT
   LOOP
      DBMS_OUTPUT.put_line (l_strings (indx));
   END LOOP;
END;
/
-- 
-- Use Table Function in TABLE Clause
-- 
-- In the FROM clause of your query, you can use TABLE clause
-- You can (and should) give that TABLE clause a table alias. 
-- 
-- COLUMN_VALUE is the name of the single column returned by the table function.
SELECT rs.COLUMN_VALUE my_string FROM TABLE (random_strings (5)) rs;
-- 
-- On 12.1 and higher, don't bother with the TABLE clause 
SELECT rs.COLUMN_VALUE no_table FROM random_strings (5) rs;
-- 
-- You can also call built-in functions for the value returned 
-- by the table function.
SELECT SUM (LENGTH (COLUMN_VALUE)) total_length,
       AVG (LENGTH (COLUMN_VALUE)) average_length
FROM TABLE (random_strings (count_in =>5));
-- 
-- Table function to display employee names of a department
-- 
CREATE OR REPLACE 
    TYPE emp_name IS TABLE OF VARCHAR2(10);
/
-- 
CREATE OR REPLACE FUNCTION emp_name_tab (dno_in IN NUMBER)
   RETURN emp_name
   AUTHID DEFINER
IS
   l_emp_name emp_name := emp_name ();
BEGIN   
   SELECT
      ename
   BULK COLLECT INTO l_emp_name
   FROM   
      emp
   WHERE deptno = dno_in;
   
   RETURN l_emp_name;
END;
/
-- 
SELECT e.COLUMN_VALUE FROM emp_name_tab(10) e;
-- 
-- 
SELECT e.COLUMN_VALUE FROM emp_name_tab(10) e
UNION ALL
SELECT e.COLUMN_VALUE FROM emp_name_tab(30) e;
-- 
-- 
-- Left Correlations and Table Functions
-- 
-- A left correlation join occurs when you pass as an argument 
-- to your table function a column value from a table or view 
-- referenced to the left in the table clause.
-- 
SET SERVEROUTPUT ON
BEGIN 
   FOR rec IN (
               SELECT 
                  d.deptno dno, 
                  et.COLUMN_VALUE emp_name
               FROM 
                  dept d,
                  emp_name_tab (d.deptno) et
               )
   LOOP
      DBMS_OUTPUT.PUT_LINE (rec.dno || ' ' || rec.emp_name);
   END LOOP;
END;
/
-- 
-- To invoke a table function inside a SELECT statement, it must be defined 
-- at the schema level (CREATE OR REPLACE FUNCTION - we've seen this already) 
-- or in the specification of a package. It cannot be defined as a nested subpro
-- gram or a private subprogram.
-- 
CREATE OR REPLACE PACKAGE emp_name_disp_pkg
IS
   FUNCTION emp_name_tab (dno_in IN NUMBER) RETURN emp_name;
   FUNCTION emp_t RETURN emp_name;
END;
/
-- 
CREATE OR REPLACE PACKAGE BODY emp_name_disp_pkg
IS
   FUNCTION emp_name_tab (dno_in IN NUMBER) RETURN emp_name
   IS
      l_emp_name emp_name := emp_name ();
   BEGIN
      SELECT
         ename
      BULK COLLECT INTO l_emp_name
      FROM   
         emp
      WHERE deptno = dno_in;      
      RETURN l_emp_name;
   END;
-- 
/* return default value - constructir of type emp_name */
   FUNCTION emp_t RETURN emp_name
   IS
   BEGIN
         RETURN emp_name('Sabyasachi');
   END;
END;
/
-- 
SET SERVEROUTPUT ON
SELECT e.COLUMN_VALUE FROM emp_name_disp_pkg.emp_name_tab(10) e
UNION ALL
SELECT e.COLUMN_VALUE FROM emp_name_disp_pkg.emp_name_tab(30) e;
-- 
SELECT e.COLUMN_VALUE FROM emp_name_disp_pkg.emp_t() e;
            