DECLARE
   l_fullname VARCHAR2(100);
   employee_id_in CONSTANT PLS_INTEGER := 1; -- Added Line
BEGIN
   SELECT last_name || ',' || first_name
     INTO l_fullname
     FROM employee
    WHERE employee_id = employee_id_in;
--    ... Line Removed
END;
/ 


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
