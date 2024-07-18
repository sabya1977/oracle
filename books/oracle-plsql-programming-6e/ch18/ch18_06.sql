CREATE OR REPLACE PACKAGE favorites_pkg
   AUTHID CURRENT_USER
IS
   -- Two constants; notice that I give understandable
   -- names to otherwise obscure values.
   
   c_chocolate CONSTANT PLS_INTEGER := 16;
   c_strawberry CONSTANT PLS_INTEGER := 29;
   
   -- A nested table TYPE declaration
   TYPE codes_nt IS TABLE OF INTEGER;
   
   -- A nested table declared from the generic type.
   my_favorites codes_nt;

   -- A REF CURSOR returning favorites information.
   TYPE fav_info_rct IS REF CURSOR RETURN favorites%ROWTYPE;
   
   -- A procedure that accepts a list of favorites
   -- (using a type defined above) and displays the
   -- favorite information from that list.
   PROCEDURE show_favorites (list_in IN codes_nt);
   
   -- A function that returns all the information in
   -- the favorites table about the most popular item.
   FUNCTION most_popular RETURN fav_info_rct;

END favorites_pkg; -- End label for package
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
