set serveroutput on size 500000

BEGIN

  FOR loop_index IN 1 .. 100
  LOOP
    IF MOD (loop_index, 2) = 0
    THEN
      /* We have an even number, so perform calculation */
      calc_values (loop_index);
    END IF;
  END LOOP;

  dbms_output.put_line('---------------------');

  FOR even_number IN 1 .. 50
  LOOP
    calc_values (even_number*2);
  END LOOP;

END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
