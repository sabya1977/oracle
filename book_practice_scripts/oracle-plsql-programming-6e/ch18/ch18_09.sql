CREATE OR REPLACE PACKAGE BODY favorites_pkg
IS
   g_most_popular   PLS_INTEGER;

   PROCEDURE show_favorites (list_in IN codes_nt)
--      IS BEGIN ... END show_favorites; -- Removed Line
   IS  -- Added Line
   BEGIN  -- Added Line
      FOR indx IN list_in.FIRST .. list_in.LAST  -- Added Line
      LOOP  -- Added Line
         DBMS_OUTPUT.put_line (list_in (indx));  -- Added Line
      END LOOP;  -- Added Line
   END show_favorites;  -- Added Line

   FUNCTION most_popular RETURN fav_info_rct
--      IS BEGIN ... END most_popular; -- Removed Line 
   IS  -- Added Line
      retval fav_info_rct;  -- Added Line
      null_cv fav_info_rct;  -- Added Line
   BEGIN  -- Added Line
      OPEN retval FOR  -- Added Line
      SELECT *  -- Added Line
        FROM favorites  -- Added Line
       WHERE code = g_most_popular;  -- Added Line

      RETURN retval;  -- Added Line
   EXCEPTION  -- Added Line
      WHEN NO_DATA_FOUND  -- Added Line
      THEN  -- Added Line
         RETURN null_cv;  -- Added Line
   END most_popular;  -- Added Line 

   PROCEDURE analyze_favorites (year_in IN INTEGER)
--      IS BEGIN ... END analyze_favorites;  Removed Line
   IS  -- Added Line
   BEGIN  -- Added Line
      /* This Implementation is Just a Stub, Presumably to be Replaced by */  -- Added Line
      /* Something that Does Something Meaningful Later On */  -- Added Line

      /* Null is a No-Op. */  -- Added Line
      /* The Statement is Included to Satisfy the Compile-Time Syntax-Checker */  -- Added Line
      NULL;  -- Added Line   
   END analyze_favorites;  -- Added Line

-- Initialization section
BEGIN
   g_most_popular := c_chocolate;

   -- Use new 9i EXTRACT to get year number from SYSDATE!
   analyze_favorites (EXTRACT (YEAR FROM SYSDATE));
END favorites_pkg;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
