CREATE OR REPLACE PACKAGE personnel
IS
   CURSOR emps_for_dept (
      deptno_in IN employee.deptno%TYPE  -- Modified Line
   )  -- Modified Line
   IS
      SELECT * FROM employee 
       WHERE deptno = deptno_in;

   PROCEDURE open_emps_for_dept(
      deptno_in IN employee.deptno%TYPE,
      close_if_open IN BOOLEAN := TRUE
   );  -- Modified Line

   PROCEDURE close_emps_for_dept;
   
END personnel;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
