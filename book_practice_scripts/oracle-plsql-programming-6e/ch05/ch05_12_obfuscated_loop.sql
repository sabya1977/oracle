set serveroutput on size 500000

DECLARE

  start_id  PLS_INTEGER := 3;
  end_id  PLS_INTEGER := 4;

BEGIN

  FOR i IN start_id .. end_id
  LOOP
    FOR j IN 1 .. 7
    LOOP
      FOR k IN 1 .. 24
      LOOP
         build_schedule (i, j, k);
      END LOOP;
    END LOOP;
  END LOOP;

END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
