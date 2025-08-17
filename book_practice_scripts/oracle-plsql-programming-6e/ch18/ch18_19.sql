DECLARE
   onebook   book_info.bytitle_cur%ROWTYPE;
BEGIN
   OPEN book_info.bytitle_cur ('%PL/SQL%');

   LOOP
      EXIT WHEN book_info.bytitle_cur%NOTFOUND;
      FETCH book_info.bytitle_cur INTO onebook;
      book_info.display (onebook);
   END LOOP;

   CLOSE book_info.bytitle_cur;
END;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
