CREATE OR REPLACE PACKAGE BODY employee_pkg
AS
   FUNCTION fullname (
      l employee.last_name%TYPE,
      f employee.first_name%TYPE
   )
      RETURN fullname_t
   IS
   BEGIN
      RETURN    l || ',' || f;
   END;

   FUNCTION fullname (employee_id_in IN employee.employee_id%TYPE)
      RETURN fullname_t
   IS
      retval   fullname_t;
   BEGIN
      SELECT fullname (last_name, first_name) INTO retval
        FROM employee
       WHERE employee_id = employee_id_in;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN RETURN NULL;

      WHEN TOO_MANY_ROWS THEN errpkg.record_and_stop;
   END;
END employee_pkg;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
