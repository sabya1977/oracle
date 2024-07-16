REM   Script: ''How did I get here?'' DBMS_UTILITY.FORMAT_CALL_STACK
REM   Use the DBMS_UTILITY.FORMAT_CALL_STACK function to answer the question "How did I get here?". Note that this function only shows you the name of the program unit (e.g., package name) and not the name of the subprogram in that program unit. In 12.1 and higher, you can also use the UTL_CALL_STACK package, which offers the advantage of showing you the name of the subprogram from which the call stack was requested.

CREATE OR REPLACE PROCEDURE proc1 
IS 
BEGIN 
   DBMS_OUTPUT.put_line (DBMS_UTILITY.format_call_stack); 
END; 
/

CREATE OR REPLACE PACKAGE pkg1 
IS 
   PROCEDURE proc2; 
END pkg1; 
/

CREATE OR REPLACE PACKAGE BODY pkg1 
IS 
   PROCEDURE proc2 
   IS 
   BEGIN 
      proc1; 
   END; 
END pkg1; 
/

CREATE OR REPLACE PROCEDURE proc3 
IS 
BEGIN 
   FOR indx IN 1 .. 1000 
   LOOP 
      NULL; 
   END LOOP; 
 
   pkg1.proc2; 
END; 
/

CALL proc3


