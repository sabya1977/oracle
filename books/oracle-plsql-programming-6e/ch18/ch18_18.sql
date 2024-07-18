CREATE OR REPLACE PACKAGE BODY book_info
IS
   CURSOR bytitle_cur (
      title_filter_in   IN   books.title%TYPE
   ) RETURN books%ROWTYPE
   IS
      SELECT *
        FROM books
       WHERE title LIKE UPPER (title_filter_in);

   CURSOR summary_cur (
      author_in   IN   books.author%TYPE
   ) RETURN author_summary_rt
   IS
      SELECT author, SUM (page_count), COUNT (*)
        FROM books
       WHERE author = author_in;
END book_info;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
