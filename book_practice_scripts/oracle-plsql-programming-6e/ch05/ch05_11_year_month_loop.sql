set serveroutput on size 500000

BEGIN

  <<year_loop>>
  FOR year_number IN 1800..1995
  LOOP

    <<month_loop>>
    FOR month_number IN 1 .. 12
    LOOP
      IF year_loop.year_number = 1900 
      THEN
        dbms_output.put_line('The '||month_number||'th month of '||year_number); 
      END IF;
      -- ... 
    END LOOP month_loop;

  END LOOP year_loop;

END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
