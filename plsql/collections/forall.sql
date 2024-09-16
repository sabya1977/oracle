-- 
-- FORALL :: The FORALL syntax allows us to bind the contents of a collection
-- to a single DML statement, allowing the DML to be run for each row in the 
-- collection without requiring a context switch each time. 
-- 
DROP TABLE forall_test;
-- 
CREATE TABLE forall_test (
  id           NUMBER(10),
  code         VARCHAR2(10),
  description  VARCHAR2(50));
-- 
ALTER TABLE forall_test ADD (
  CONSTRAINT forall_test_pk PRIMARY KEY (id));
-- 
ALTER TABLE forall_test ADD (
  CONSTRAINT forall_test_uk UNIQUE (code));
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_forall_test_tab IS TABLE OF forall_test%ROWTYPE;

  l_tab    t_forall_test_tab := t_forall_test_tab();
  l_start  NUMBER;
  l_size   NUMBER            := 1000000;
  l_elapsed_time NUMBER      := 0;

BEGIN

-- Populate collection.
  FOR i IN 1 .. l_size LOOP
    l_tab.extend;

    l_tab(l_tab.last).id          := i;
    l_tab(l_tab.last).code        := TO_CHAR(i);
    l_tab(l_tab.last).description := 'Description: ' || TO_CHAR(i);
  END LOOP;

EXECUTE IMMEDIATE 'TRUNCATE TABLE forall_test';

-- Time regular inserts.
  l_start := DBMS_UTILITY.get_time;

-- row-by-row INSERT
  FOR i IN l_tab.first .. l_tab.last LOOP
    INSERT INTO forall_test (id, code, description)
    VALUES (l_tab(i).id, l_tab(i).code, l_tab(i).description);
  END LOOP;
  
  DBMS_OUTPUT.put_line('Normal Inserts: ' || 
                       (DBMS_UTILITY.get_time - l_start)/100);
  
  EXECUTE IMMEDIATE 'TRUNCATE TABLE forall_test';

-- Time bulk inserts.  
  l_start := DBMS_UTILITY.get_time;

  FORALL i IN l_tab.first .. l_tab.last
    INSERT INTO forall_test VALUES l_tab(i);

  DBMS_OUTPUT.put_line('Bulk Inserts  : ' || 
                       (DBMS_UTILITY.get_time - l_start)/100);

  COMMIT;
END;
/  
/*
-- For 100,000 rows
Normal Inserts: 2.27
Bulk Inserts  : .47
--
-- For 1 million records
Normal Inserts: 35.28
Bulk Inserts  : 8.2
*/
-- 
-- SQL%BULK_ROWCOUNT :: The SQL%BULK_ROWCOUNT cursor attribute gives 
-- granular information about the rows affected by each iteration of 
-- the FORALL statement.
-- 
-- Every row in the driving collection has a corresponding row in the 
-- SQL%BULK_ROWCOUNT cursor attribute.
--
DROP TABLE bulk_rowcount_test;
-- 
CREATE TABLE bulk_rowcount_test AS
SELECT *
FROM   dba_objects;
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_array_tab IS TABLE OF VARCHAR2(30);
  l_array t_array_tab := t_array_tab('SCOTT', 'SYS',
                                     'SYSTEM', 'HR', 'SH'); 
BEGIN
-- perform bulk delete operation
  FORALL i IN l_array.first .. l_array.last 
    DELETE FROM bulk_rowcount_test
    WHERE owner = l_array(i);

-- Report effected row 
FOR i IN l_array.first .. l_array.last 
    LOOP
      DBMS_OUTPUT.put_line('Element: ' || RPAD(l_array(i), 15, ' ') ||
      ' Rows affected: ' || SQL%BULK_ROWCOUNT(i));
  END LOOP;
END;
/                                          
--
/*
Element: SCOTT           Rows affected: 0
Element: SYS             Rows affected: 54377
Element: SYSTEM          Rows affected: 481
Element: HR              Rows affected: 34
Element: SH              Rows affected: 310
*/
--
-- 
-- SAVE EXCEPTIONS and SQL%BULK_EXCEPTION :: One problem with FORALL syantx
-- is if one of those individual operations results in an exception. If there
-- is no exception handler, all the work done by the current bulk operation is
-- rolled back.If there is an exception handler, the work done prior to the 
-- exception is kept, but no more processing is done.
-- Neither of these situations is very satisfactory, so instead we should use 
-- the SAVE EXCEPTIONS clause to capture the exceptions and allow us to continue
-- past them.
-- We can subsequently look at the exceptions by referencing the SQL%BULK_
-- EXCEPTION cursor attribute. 
-- 
-- 
DROP TABLE exception_test;
-- 
CREATE TABLE exception_test (
  id  NUMBER(10) NOT NULL
);
-- 
SET SERVEROUTPUT ON
DECLARE
  TYPE t_tab IS TABLE OF exception_test%ROWTYPE;

  l_tab          t_tab := t_tab();
  l_error_count  NUMBER;
  
  ex_dml_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
BEGIN
  -- Fill the collection.
  FOR i IN 1 .. 100 LOOP
    l_tab.extend;
    l_tab(l_tab.last).id := i;
  END LOOP;

  -- Cause a failure.
  l_tab(50).id := NULL;
  l_tab(51).id := NULL;
  
  EXECUTE IMMEDIATE 'TRUNCATE TABLE exception_test';

  -- Perform a bulk operation.
  BEGIN
    FORALL i IN l_tab.first .. l_tab.last SAVE EXCEPTIONS
      INSERT INTO exception_test
      VALUES l_tab(i);
  EXCEPTION
    WHEN ex_dml_errors THEN
      l_error_count := SQL%BULK_EXCEPTIONS.count;
      DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
      FOR i IN 1 .. l_error_count LOOP
        DBMS_OUTPUT.put_line('Error: ' || i || 
          ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
          /* - sign is required for error code */
          ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
      END LOOP;
  END;
END;
/
-- 
-- Bulk Binds and Triggers
-- For bulk updates and deletes the timing points remain unchanged. Each row in 
-- the collection triggers a before statement, before row, after row and after 
-- statement timing point. For bulk inserts, the statement level triggers only
-- fire at the start and the end of the the whole bulk operation, rather than 
-- for each row of the collection. This can cause some confusion if you are 
-- relying on the timing points from row-by-row processing.
