CREATE OR REPLACE PACKAGE BODY valerr
IS
   v VARCHAR2(1);

--   FUNCTION get RETURN VARCHAR2 IS BEGIN ... END;  -- Removed Line
   FUNCTION get RETURN VARCHAR2  -- Added Line
   IS  -- Added Line
   BEGIN  -- Added Line
      RETURN v;  -- Added Line
   END;  -- Added Line
BEGIN
   v := 'ABC';

EXCEPTION
  WHEN OTHERS 
  THEN
    DBMS_OUTPUT.PUT_LINE ('Error initializing valerr:');
    DBMS_OUTPUT.PUT_LINE (SQLERRM);
	 
END valerr;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
