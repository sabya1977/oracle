CREATE OR REPLACE PACKAGE employee_pkg
AS
   max_salary NUMBER;

   SUBTYPE fullname_t IS VARCHAR2 (200);
  
   FUNCTION fullname (
      l  employee.last_name%TYPE,
      f  employee.first_name%TYPE)
      RETURN fullname_t;

   FUNCTION fullname (
      employee_id_in IN employee.employee_id%TYPE)
      RETURN fullname_t;

END employee_pkg;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
