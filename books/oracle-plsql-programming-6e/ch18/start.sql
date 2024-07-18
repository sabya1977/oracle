REM This Wrapper Exists Because SPOOL was Acting Funny if it
REM was Included Directly in the ch18_driver.sql Script.
REM It would Create the File but it Would be Blank...

SPOOL ch18_results.txt
@@ch18_driver.sql
SPOOL OFF



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
