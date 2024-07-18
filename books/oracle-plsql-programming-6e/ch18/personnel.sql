CREATE OR REPLACE PACKAGE BODY personnel
IS
   PROCEDURE open_emps_for_dept(
      deptno_in IN employee.deptno%TYPE,
      close_if_open IN BOOLEAN := TRUE
   )
   IS
   BEGIN
      /* Close the Cursor if it's Open and close_if_open is TRUE */
      IF emps_for_dept%ISOPEN AND close_if_open
      THEN
         CLOSE emps_for_dept;
      END IF;

      /* Remember to Always Check the Cursor's State Before Opening It. */
      /* In this Case, it May have been Left Open, but the Value Passed in */
      /* for close_if_open may be FALSE, so the Cursor Could Still be Open */
      IF NOT emps_for_dept%ISOPEN
      THEN
         OPEN emps_for_dept ( deptno_in );
      END IF;
   END open_emps_for_dept;

   PROCEDURE close_emps_for_dept
   IS
   BEGIN
      /* Remember to Always Check the Cursor's State Before Closing It. */
      /* The Cursor may have been Closed Already, or the Call into this */
      /* Procedure could be Out-of-sequence. */
      IF emps_for_dept%ISOPEN
      THEN
         CLOSE emps_for_dept;
      END IF;
   END;
   
END personnel;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
