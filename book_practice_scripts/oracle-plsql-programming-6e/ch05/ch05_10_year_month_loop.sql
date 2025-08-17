set serveroutput on size 500000

DECLARE

  year_number PLS_INTEGER := 1992;

BEGIN

  <<year_loop>>
  WHILE year_number <= 1995
  LOOP

    dbms_output.put_line('year = '||year_number);

    <<month_loop>>
    FOR month_number IN 1 .. 12
    LOOP
      dbms_output.put_line('...and month = '||month_number);
      -- ... 
    END LOOP month_loop;
    
    year_number := year_number + 2;

  END LOOP year_loop;

END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
