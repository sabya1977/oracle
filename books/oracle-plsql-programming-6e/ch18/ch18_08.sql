CREATE OR REPLACE PACKAGE BODY favorites_pkg
IS
   -- A private variable
   g_most_popular   PLS_INTEGER;

   -- Implementation of procedure
   PROCEDURE show_favorites (list_in IN codes_nt)
   IS
   BEGIN
      FOR indx IN list_in.FIRST .. list_in.LAST
      LOOP
         DBMS_OUTPUT.put_line (list_in (indx));
      END LOOP;
   END show_favorites;

   -- Implement the function
   FUNCTION most_popular
      RETURN fav_info_rct
   IS
      retval fav_info_rct;
      null_cv fav_info_rct;
   BEGIN
      OPEN retval FOR
      SELECT *
        FROM favorites
       WHERE code = g_most_popular;

      RETURN retval;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN null_cv;
   END most_popular;

END favorites_pkg; -- End label for package
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
