DECLARE
  end_of_file1  BOOLEAN := TRUE;
  end_of_file2  BOOLEAN := FALSE;
  checkline  VARCHAR2(80) := '1234';
  againstline  VARCHAR2(80) := 'abcd';
  retval  BOOLEAN;
BEGIN
  LOOP
    -- ...
    IF (end_of_file1 AND end_of_file2)
    THEN
      retval := TRUE;
      EXIT;
    ELSIF (checkline != againstline)
    THEN
      retval := FALSE;
      EXIT;
    ELSIF (end_of_file1 OR end_of_file2)
    THEN
      retval := FALSE;
      EXIT;
    END IF;
  END LOOP;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
