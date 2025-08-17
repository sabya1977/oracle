set serveroutput on size 500000

DECLARE

   CURSOR books_cur(author_in IN books.author%TYPE) IS
   SELECT *
     FROM books
    WHERE author = author_in;

   book_count PLS_INTEGER;

BEGIN

   FOR book_rec IN books_cur (author_in => 'FEUERSTEIN, STEVEN')
   LOOP
      -- ... process data ...
      book_count := books_cur%ROWCOUNT;
   END LOOP;

   IF book_count > 10 
   THEN
     dbms_output.put_line('Lotsa books, time for vacation.');
   ELSE
     dbms_output.put_line('Keep writing slacker.');
   END IF;

END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
