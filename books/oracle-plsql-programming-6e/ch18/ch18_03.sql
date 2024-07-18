DECLARE
   l_name employee_pkg.fullname_t;
   employee_id_in CONSTANT PLS_INTEGER := 1; -- Added Line
BEGIN
   l_name := employee_pkg.fullname (employee_id_in); 
--   ... Removed Line
END;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
