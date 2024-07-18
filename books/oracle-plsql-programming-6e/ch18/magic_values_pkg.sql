CREATE OR REPLACE PACKAGE magic_values_pkg
IS
   footing_difference NUMBER DEFAULT 78;
   cust_status VARCHAR2(1);

   PROCEDURE adjust_line_item;

   PROCEDURE reopen_customer;

END magic_values_pkg;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
