CREATE OR REPLACE PACKAGE valerr
IS
   FUNCTION get RETURN VARCHAR2;
END valerr;
/
CREATE OR REPLACE PACKAGE BODY valerr
IS
   v VARCHAR2(1) := 'ABC';

   FUNCTION get RETURN VARCHAR2 
   IS
   BEGIN
      RETURN v;
   END;
BEGIN
   DBMS_OUTPUT.PUT_LINE ('Before I show you v...');

EXCEPTION
  WHEN OTHERS 
  THEN
    DBMS_OUTPUT.PUT_LINE ('Trapped the error!');
	 
END valerr;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
