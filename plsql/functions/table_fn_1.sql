/*
Author: Steven Feuerstein
--
What Is a Table Function?

A table function is a function that can be invoked inside the FROM clause of a SELECT statement. 
They return collections (usually nested tables or varrays), which can then be transformed with 
the TABLE clause into a dataset of rows and columns that can be processed in a SQL statement. 
Table functions come in very handy when you need to:

Merge session-specific data with data from tables: you've got data, and lots of it sitting in tables. 
But in your session (and not in any tables), you have some data - and you need to "merge" these two 
sources together in an SQL statement. In other words, you need the set-oriented power of SQL to get 
some answers. With the TABLE operator, you can accomplish precisely that.

Programmatically construct a dataset to be passed as rows and columns to the host environment: 
Your webpage needs to display some data in a nice neat report. That data is, however, far from neat. 
In fact, you need to execute procedural code to construct the dataset. Sure, you could construct 
the data, insert into a table, and then SELECT from the table. But with a table function, you can 
deliver that data immediately to the webpage, without any need for non-query DML.

Emulate a parameterized view: Oracle Database does not allow you to pass parameters to a view, 
but you can pass parameters to a function, and use that as the basis for what is in essence a 
parameterized view.

Improve performance of parallelized queries with pipelined table functions Many data warehouse 
applications rely on Parallel Query to greatly improve performance of massive ETL operations. 
But if you execute a table function in the FROM clause, that query will serialize (blocked by 
the call to the function). Unless you define that function a a pipelined function and enable 
it for parallel execution.

Reduce consumption of Process Global Area (pipelined table functions): Collections (which are 
constructed and returned by "normal" table functions) can consume an awful lot of PGA (Process Global Area). 
But if you define that table function as pipelined, PGA consumption becomes a non-issue.

To call a function from within the FROM clause of a query, you need to:

Define the RETURN datatype of the function to be a collection type (usually a nested table or a 
varray, but under some circumstances you can also use an associative array). The type must be defined
 at the schema level (CREATE [OR REPLACE] TYPE) or in package specification (for pipelined table functions only).
Make sure that all parameters to the function are of mode IN and have SQL-compatible datatypes. 
(You cannot, for example, call a function with a Boolean or record type argument inside a query.)
Embed the call to the function inside the TABLE clause. Note: as of 12.1, you can often invoke the 
function directly in the FROM clause with using TABLE.

In this tutorial, I will show you how to build and query from a very simply table function, one that 
returns an array of strings (and, more generally, scalars). The next tutorial will show you how to work 
with table functions that return collections of multiple columns.

Note: if you are not yet familiar with PL/SQL collections, I suggest you check out my "Working with Collections" 
YouTube playlist - the link's at the bottom of this tutorial.
*/
--
/* 
Create Table Function:

First, let's create the nested table type to be returned by the function, then create a function that 
returns an array of random strings. Finally, demonstrate that the function works - inside a PL/SQL block. 
*/
--
CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
/

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
/* 
Use Table Function in TABLE Clause:

In the FROM clause of your query, right where you would have the table name, type in:

TABLE (your_function_name (parameter list))
You can (and should) give that TABLE clause a table alias. You can, starting in Oracle Database 12c, 
also use named notation when invoking the function. You can also call built-in functions for the value 
returned by the table function. All this is demonstrated below.

Notice that Oracle Database automatically uses the string "COLUMN_VALUE" as the name of the single column
 returned by the table function. You can, as shown, rename it using a column alias. 
*/
--
SELECT rs.COLUMN_VALUE my_string FROM TABLE (random_strings (5)) rs
/

SELECT COLUMN_VALUE my_string FROM TABLE (random_strings (count_in => 5))
/

SELECT SUM (LENGTH (COLUMN_VALUE)) total_length,
       AVG (LENGTH (COLUMN_VALUE)) average_length
  FROM TABLE (random_strings (5))
/

/* On 12.1 and higher, don't bother with the TABLE clause */

SELECT rs.COLUMN_VALUE no_table FROM random_strings (5) rs
/
--
--
/*
Blending Table Function and In-Table Data:

Now that the data from my function can be treated as rows and columns, I can use it just as 
I would any other dataset in my SELECT statement. Namely, I can join to this "inline view", 
perform set operations like UNION and INTERSECT, and more. Here are some examples for you to explore:
*/
--
SELECT e.last_name
  FROM TABLE (random_strings (3)) rs, hr.employees e
 WHERE LENGTH (e.last_name) <= LENGTH (COLUMN_VALUE)
/

SELECT COLUMN_VALUE last_name 
  FROM TABLE (random_strings (10)) rs
UNION ALL
SELECT e.last_name
  FROM hr.employees e
 WHERE e.department_id = 100
/
--
-- I can also call the table function inside a SELECT statement that is inside PL/SQL:

BEGIN
   FOR rec IN (SELECT COLUMN_VALUE my_string FROM TABLE (random_strings (5)))
   LOOP
      DBMS_OUTPUT.put_line (rec.my_string);
   END LOOP;
END;
/
--
/*
Left Correlations and Table Functions:

A left correlation join occurs when you pass as an argument to your table function a column value from a 
table or view referenced to the left in the table clause. This technique is used with XMLTABLE and JSON_TABLE 
built-in functions, but also applied to your own table functions.

Here's the thing to remember: the function will be called for each row in the table/view that is providing 
the column to the function. Clearly, this could cause some performance issues, so be sure that is what you 
want and need to do. The following code demonstrates this behavior.
*/
CREATE TABLE things
(
   thing_id     NUMBER,
   thing_name   VARCHAR2 (100)
)
/

BEGIN
   INSERT INTO things VALUES (1, 'Thing 1');
   INSERT INTO things VALUES (2, 'Thing 2');
   COMMIT;
END;
/

CREATE OR REPLACE TYPE numbers_t IS TABLE OF NUMBER
/

CREATE OR REPLACE FUNCTION more_numbers (id_in IN NUMBER)
   RETURN numbers_t
IS
   l_numbers   numbers_t := numbers_t ();
BEGIN
   l_numbers.EXTEND (id_in * 5);

   FOR indx IN 1 .. id_in * 5
   LOOP
      l_numbers (indx) := indx;
   END LOOP;

   DBMS_OUTPUT.put_line ('more numbers');
   RETURN l_numbers;
END;
/

BEGIN
   FOR rec IN (SELECT th.thing_name, t.COLUMN_VALUE thing_number
                 FROM things th, TABLE (more_numbers (th.thing_id)) t)
   LOOP
      DBMS_OUTPUT.put_line ('more numbers ' || rec.thing_number);
   END LOOP;
END;
/
--
--
/*
Where Table Functions Can Be Defined:

To invoke a table function inside a SELECT statement, it must be defined at the schema level 
(CREATE OR REPLACE FUNCTION - you've seen this already) or in the specification of a package. 
It cannot be defined as a nested subprogram or a private subprogram. 

Here's an example of a package-based table function:
*/
CREATE OR REPLACE TYPE strings_t IS TABLE OF VARCHAR2 (100);
/

CREATE OR REPLACE PACKAGE tf
IS
   FUNCTION strings RETURN strings_t;
END;
/

CREATE OR REPLACE PACKAGE BODY tf
IS
   FUNCTION strings RETURN strings_t
   IS
   BEGIN
      RETURN strings_t ('abc');
   END;
END;
/

SELECT COLUMN_VALUE my_string FROM TABLE (tf.strings)
/
-- --
-- But a reference to a nested or private subprogram cannot be resolved in the SQL layer, 
-- which is where of course the SELECT statement executes, so errors result, as shown below.
DECLARE
   FUNCTION nested_strings (count_in IN INTEGER) RETURN strings_t
   IS
   BEGIN
      RETURN strings_t ('abc');
   END;
BEGIN
   FOR rec IN (SELECT * FROM TABLE (nested_strings()))
   LOOP
      DBMS_OUTPUT.PUT_LINE (rec.COLUMN_VALUE);
   END LOOP;
END;
/
--
--PLS-00231: function 'NESTED_STRINGS' may not be used in SQL 
-- New to 12.1, you can now use the WITH clause to define functions directly inside a SELECT statement. 
-- Such a function can also be used as a table function (warning: as of July 2018, this syntax is not yet
-- supported in LiveSQL; it will work in SQL Developer, SQLcl or SQL*Plus):
--
WITH 
  FUNCTION strings RETURN strings_t 
  IS 
  BEGIN 
     RETURN strings_t ('abc'); 
  END; 
SELECT COLUMN_VALUE my_string FROM TABLE (strings) 
/
--
--Valid Collection Types for Table Functions
-- There are, basically, two things to keep in mind when it comes to the 
-- collection type used in the RETURN clause of a table function:

-- The collection type must be declared so that the SQL engine can resolve a reference to it.
/* 
The collection type (or the attributes within that type) must be SQL-compatible. You cannot, for example, 
return a collection of Booleans for a table function.
The SQL engine generally can resolve references to types and PL/SQL programs if they are defined at the schema 
level or within the specification of a package. When it comes to table functions, however, types defined within 
a package specification can only be used with pipelined table functions (explored in Module 4 of this class). 
This is demonstrated in the following code. The strings_sl and strings_pl functions can be invoked successfully 
as table functions. 
*/
CREATE OR REPLACE TYPE sl_strings_t IS TABLE OF VARCHAR2 (100);
/

CREATE OR REPLACE PACKAGE tf
IS
   TYPE strings_t IS TABLE OF VARCHAR2 (100);
   FUNCTION strings RETURN strings_t;
   FUNCTION strings_sl RETURN sl_strings_t;
   FUNCTION strings_pl RETURN strings_t PIPELINED;
END;
/

CREATE OR REPLACE PACKAGE BODY tf
IS
   FUNCTION strings RETURN strings_t
   IS
   BEGIN
      RETURN strings_t ('abc');
   END;
   
   FUNCTION strings_sl RETURN sl_strings_t
   IS
   BEGIN
      RETURN sl_strings_t ('abc');
   END;
   
   FUNCTION strings_pl RETURN strings_t PIPELINED
   IS
   BEGIN
      PIPE ROW ('abc');
      RETURN;
   END;
END;
/

SELECT COLUMN_VALUE my_string FROM TABLE (tf.strings)
/

SELECT COLUMN_VALUE my_string FROM TABLE (tf.strings_sl)
/

SELECT COLUMN_VALUE my_string FROM TABLE (tf.strings_pl)
/
--
-- But when I try to use the strings function, I get the "ORA-00902: invalid datatype" error, 
-- since it relies on a package-defined nested table type and it is not pipelined.
--
SELECT COLUMN_VALUE my_string FROM TABLE (tf.strings)
/
--
/*
Summary
You should now have a solid grounding in what constitutes a table function, how to build a table function that 
returns a collection of scalars, and how to invoke that table function inside a SELECT statement.

Just remember:

Define the RETURN datatype of the function to be a collection type (usually a nested table or a varray, but under
some circumstances you can also use an associative array). The type must be defined at the schema level (CREATE [OR REPLACE]
TYPE) or in package specification (for pipelined table functions only).

Make sure that all parameters to the function are of mode IN and have SQL-compatible datatypes. (You cannot, for example, 
call a function with a Boolean or record type argument inside a query.)

Embed the call to the function inside the TABLE clause. Note: as of 12.1, you can often invoke the function directly in 
the FROM clause with using TABLE.
*/