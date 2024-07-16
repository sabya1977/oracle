REM   Script: The Cursor FOR Loop
REM   An exploration into the very useful and elegant cursor FOR loop, in which we declaratively tell the PL/SQL engine "I want to do X for each row fetched by the cursor." But we leave it up to that fine engine to do all the administrative work for us (open, fetch, close) - PLUS this loop is automatically optimized to return 100 rows with each fetch!

-- Simplest Form - SELECT inside the loop
-- You can embed the SELECT directly inside the FOR loop. That's easiest, but that also means you cannot reuse the SELECT in another FOR loop, if you have that need.
BEGIN 
   FOR rec IN (SELECT * FROM hr.employees) 
   LOOP 
      DBMS_OUTPUT.put_line (rec.last_name); 
   END LOOP; 
END;
/

-- Cursor FOR Loop with Explicit Cursor
-- You can also declare the cursor explicitly and then reference that in the FOR loop. You can then use that same cursor in another context, such as another FOR loop.
DECLARE 
   CURSOR emps_cur 
   IS 
      SELECT * FROM hr.employees; 
BEGIN 
   FOR rec IN emps_cur 
   LOOP 
      DBMS_OUTPUT.put_line (rec.last_name); 
   END LOOP; 
 
   FOR rec IN emps_cur 
   LOOP 
      DBMS_OUTPUT.put_line (rec.salary); 
   END LOOP; 
END;
/

-- Parameterized Cursor FOR Loop
-- You can add a parameter list to a cursor, just like you can a function. You can only have IN parameters. Well, that makes sense, right?
DECLARE 
   CURSOR emps_cur (department_id_in IN INTEGER) 
   IS 
      SELECT * FROM hr.employees 
       WHERE department_id = department_id_in; 
BEGIN 
   FOR rec IN emps_cur (1700) 
   LOOP 
      DBMS_OUTPUT.put_line (rec.last_name); 
   END LOOP; 
 
   FOR rec IN emps_cur (50) 
   LOOP 
      DBMS_OUTPUT.put_line (rec.salary); 
   END LOOP; 
END;
/

-- Package Based Cursor
-- You can declare a cursor at the package level and then reference that cursor in multiple program units. Remember, though, that if you explicitly open a packaged cursor (as in OPEN emus_pkg.emps_cur), it will stay open until you close it explicitly (or disconnect). 
CREATE OR REPLACE PACKAGE emps_pkg 
IS 
   CURSOR emps_cur 
   IS 
      SELECT * FROM hr.employees; 
END;
/

-- Using a Package-based Cursor
BEGIN 
   FOR rec IN emps_pkg.emps_cur 
   LOOP 
      DBMS_OUTPUT.put_line (rec.last_name); 
   END LOOP; 
END;
/

-- Hide SELECT in Package-based Cursor
-- You can even hide the SELECT inside the package body in case you don't want developers to know the details of the query.
CREATE OR REPLACE PACKAGE emps_pkg 
IS 
   CURSOR emps_cur 
      RETURN hr.employees%ROWTYPE; 
END;
/

CREATE OR REPLACE PACKAGE BODY emps_pkg 
IS 
   CURSOR emps_cur RETURN hr.employees%ROWTYPE 
   IS 
      SELECT * FROM hr.employees; 
END;
/

BEGIN
   FOR rec IN emps_pkg.emps_cur
   LOOP
      DBMS_OUTPUT.put_line (rec.last_name);
   END LOOP;
END;
/

