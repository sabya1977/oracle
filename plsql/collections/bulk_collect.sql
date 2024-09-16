-- name collections_operations.sql
-- To demonstrate all types of operations on collections in Oracle PL/SQL
--
-- Recap: Different kinds of SQL and PL/SQL composite data types
-- 
-- SQL user-defined datatype (UDT): This can hold a data structure. Two implementations
-- are possible: an object type only implementation, which supports a SQL-level record structure,
-- and both an object type and body implementation, which supports a class instance.
-- SQL UDTs are defined at schema level. 
--
-- PL/SQL record type: This holds a strcuture of data. You can implement it by anchoring 
-- the data type of elements to columns in tables and views, or you can explicitly define it. 
-- Record types are defined in PL/SQL blocks.
--
-- SQL Collection: This can hold a list of any scalar SQL data type. SQL collections of
-- scalar variables are called Attribute Data Types (ADTs). 
-- 
-- There are two kinds of SQL collections:
-- 
-- Varray which is a fixed length array and nested table. 
-- 
-- Nested table doesn’t have a fixed number of elements at definition and can scale to meet
-- your runtime needs within your PGA memory constraints. 
-- 
-- SQL collections are defined at schema or PL/SQL blocks.
--
-- PL/SQL Collection: This can hold a list of any scalar SQL data type or record type, and it
-- can also hold a list of any PL/SQL record type. PL/SQL collections are implemented using 
-- associative array and defined only at PL/SQL blocks.
--
--
-- BULK COLLECT
--
-- There is an overhead associated with each context switch between the two
-- engines. If PL/SQL code loops through a collection performing the same DML
-- operation for each item in the collection it is possible to reduce context 
-- switches by bulk binding the whole collection to the DML statement in one 
-- operation.
--
-- Bulk binds can improve the performance when loading collections from a queries. 
-- The BULK COLLECT INTO construct binds the output of the query to the collection. 
-- To test this create the following table.
-- 
-- The following code compares the time taken to populate a collection manually
-- and using a bulk bind.
-- 
-- drop and create table
DROP TABLE bulk_collect_test;
--
CREATE TABLE bulk_collect_test AS
SELECT owner,
       object_name,
       object_id
FROM   all_objects;
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_bulk_collect_test_tab IS TABLE OF bulk_collect_test%ROWTYPE;

  l_tab    t_bulk_collect_test_tab := t_bulk_collect_test_tab();
  l_start  NUMBER;
  l_elapsed_time NUMBER;
BEGIN
  -- Time a regular population.
  l_start := DBMS_UTILITY.get_time;

  FOR cur_rec IN (SELECT *
                  FROM   bulk_collect_test)
  LOOP
    l_tab.extend;
    l_tab(l_tab.last) := cur_rec;
  END LOOP;

  l_elapsed_time := DBMS_UTILITY.get_time - l_start;
  l_elapsed_time := l_elapsed_time/100;

  DBMS_OUTPUT.put_line('Regular (' || l_tab.count || ' rows): ' || 
                       (l_elapsed_time));
  
  -- Time bulk population.  
  l_start := DBMS_UTILITY.get_time;

  SELECT *
  BULK COLLECT INTO l_tab
  FROM   bulk_collect_test;
  l_elapsed_time := DBMS_UTILITY.get_time - l_start;
  l_elapsed_time := l_elapsed_time/100;

  DBMS_OUTPUT.put_line('Bulk    (' || l_tab.count || ' rows): ' || 
                       (l_elapsed_time));
END;
/
-- 
-- Bulk Collect with LIMIT to reduce memory footprint
-- 
-- drop and create table
DROP TABLE bulk_collect_test;
--
-- drop and create table
DROP TABLE bulk_collect_test;
--
CREATE TABLE bulk_collect_test AS
SELECT owner,
       object_name,
       object_id
FROM   dba_objects;
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_bulk_collect_test_tab IS TABLE OF bulk_collect_test%ROWTYPE;

  l_tab t_bulk_collect_test_tab;
  l_cnt NUMBER := 0;

  CURSOR c_data IS
    SELECT *
    FROM bulk_collect_test;
BEGIN
  OPEN c_data;
  LOOP
    FETCH c_data
    BULK COLLECT INTO l_tab LIMIT 10000;
    EXIT WHEN l_tab.count = 0;
    l_cnt := l_cnt + l_tab.count;

    -- Process contents of collection here.
    DBMS_OUTPUT.put_line (l_cnt || ' rows processed');
  END LOOP;
  CLOSE c_data;
END;
/
