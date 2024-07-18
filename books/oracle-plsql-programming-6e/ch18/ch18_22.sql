DECLARE
   one_emp personnel.emps_for_dept%ROWTYPE;
BEGIN
   personnel.open_emps_for_dept (1055);

   LOOP
      EXIT WHEN personnel.emps_for_dept%NOTFOUND;
      FETCH personnel.emps_for_dept INTO one_emp;
--      ...  -- Removed Line
   END LOOP;

   personnel.close_emps_for_dept;
END;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
