CREATE OR REPLACE PACKAGE pets_inc  -- Modified Line
IS
   max_pets_in_facility CONSTANT INTEGER := 120;
   pet_is_sick EXCEPTION;

   CURSOR pet_cur (pet_id_in in pet.id%TYPE) RETURN pet%ROWTYPE;

   FUNCTION next_pet_shots (pet_id_in IN pet.id%TYPE) RETURN DATE;
   PROCEDURE set_schedule (pet_id_in IN pet.id%TYPE);

END pets_inc;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
