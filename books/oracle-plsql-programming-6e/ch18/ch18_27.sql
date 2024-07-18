CREATE OR REPLACE PACKAGE config_pkg  -- Modified Line 
IS
   closed_status     CONSTANT VARCHAR2(1) := 'C';
   open_status       CONSTANT VARCHAR2(1) := 'O';
   active_status     CONSTANT VARCHAR2(1) := 'A';
   inactive_status   CONSTANT VARCHAR2(1) := 'I';

   min_difference    CONSTANT NUMBER := 1;
   max_difference    CONSTANT NUMBER := 100;

   earliest_date     CONSTANT DATE := SYSDATE;
   latest_date       CONSTANT DATE := ADD_MONTHS (SYSDATE, 120); 

END config_pkg;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
