CREATE OR REPLACE PACKAGE book_info
IS
   PRAGMA SERIALLY_REUSABLE;

   CURSOR byauthor_cur (
--      author_in   IN   books.author%TYPE) IS ...;  -- Removed Line
      author_in   IN   books.author%TYPE  -- Added Line
   )  -- Added Line
   IS  -- Added Line
      SELECT *  -- Added Line
        FROM books  -- Added Line
       WHERE author = author_in;  -- Added Line

   CURSOR bytitle_cur (
      title_filter_in   IN   books.title%TYPE)
    RETURN books%ROWTYPE;

END book_info;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
