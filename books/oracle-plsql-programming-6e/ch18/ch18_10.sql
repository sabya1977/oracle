CREATE OR REPLACE PACKAGE BODY company  -- Modified Line
IS
BEGIN
   /*
   || Initialization section of company_pkg updates the global
   || package data of a different package. This is a no-no!  -- Modified Line
   */
   SELECT SUM (salary) 
     INTO employee_pkg.max_salary 
     FROM employee;

END company;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
