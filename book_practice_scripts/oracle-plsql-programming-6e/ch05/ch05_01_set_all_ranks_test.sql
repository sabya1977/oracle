set serveroutput on size 500000
begin
  dbms_output.put_line('set_all_ranks...');
  set_all_ranks(5);
  dbms_output.put_line('-----------------');
  dbms_output.put_line('set_all_ranks2...');
  set_all_ranks2(3);
  dbms_output.put_line('-----------------');
  dbms_output.put_line('set_all_ranks3...');
  set_all_ranks3(4);
end;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
