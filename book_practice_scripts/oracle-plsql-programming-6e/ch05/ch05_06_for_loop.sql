set serveroutput on 500000

DECLARE

  start_period_number pls_integer := 1;
  end_period_number pls_integer := 10;
  current_period pls_integer := 5;

BEGIN

  dbms_output.put_line('forward loop...');
  FOR loop_counter IN 1 .. 10
  LOOP
    dbms_output.put_line(loop_counter);
    -- ... executable statements ...
  END LOOP;

  dbms_output.put_line('reverse loop...');
  FOR loop_counter IN REVERSE 1 .. 10
  LOOP
    dbms_output.put_line(loop_counter);
    -- ... executable statements ...
  END LOOP;

  dbms_output.put_line('no loop...');
  FOR loop_counter IN REVERSE 10 .. 1
  LOOP
    dbms_output.put_line('no loop: '||loop_counter);
    /* This loop body will never execute even once! */
  END LOOP;

  dbms_output.put_line('variable-delimitted loop...');
  FOR calc_index IN start_period_number .. 
                    LEAST (end_period_number, current_period)
  LOOP
    dbms_output.put_line(calc_index);
    -- ... executable statements ...
  END LOOP;

END;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
