CREATE OR REPLACE PACKAGE book_info
IS
   CURSOR byauthor_cur (
      author_in   IN   books.author%TYPE
   )
   IS
      SELECT *
        FROM books
       WHERE author = author_in;

   CURSOR bytitle_cur (
      title_filter_in  IN   books.title%TYPE
   ) RETURN books%ROWTYPE;

   TYPE author_summary_rt IS RECORD (
      author                        books.author%TYPE,
      total_page_count              PLS_INTEGER,
      total_book_count              PLS_INTEGER);

   CURSOR summary_cur (
      author_in   IN   books.author%TYPE
   ) RETURN author_summary_rt;
END book_info;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
