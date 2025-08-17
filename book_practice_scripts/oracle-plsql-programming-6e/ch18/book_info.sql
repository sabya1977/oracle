CREATE OR REPLACE PACKAGE BODY book_info
IS
   CURSOR bytitle_cur (
      title_filter_in   IN   books.title%TYPE
   ) 
   /* This Cursor Does Not Specify a RETURN Clause */
   /* Even though the Data Returned by the Cursor is the Same as that */
   /* Declared in the Specification, the Lack of a RETURN Clause will */ 
   /* Cause this Declaration to Fail at Compile-time */
   IS
      SELECT *
        FROM books
       WHERE title LIKE UPPER (title_filter_in);      

   CURSOR summary_cur (
      author_in   IN   books.author%TYPE
   ) RETURN author_summary_rt
   /* This Cursor's Data Does Not Match its RETURN Clause */
   IS
      SELECT SYSDATE 
        FROM DUAL;
END book_info;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
