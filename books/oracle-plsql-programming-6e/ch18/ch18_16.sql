DECLARE
   c_pet CONSTANT pet.id%TYPE := 1099;  -- Modified Line
   v_next_appointment DATE;  -- Added Line
BEGIN
   IF pets_inc.max_pets_in_facility > 100
   THEN
      OPEN pets_inc.pet_cur(c_pet);  -- Modified Line
   ELSE
      v_next_appointment := 
	     pets_inc.next_pet_shots (c_pet);  -- Modified Line
   END IF;
EXCEPTION
   WHEN pets_inc.pet_is_sick
   THEN
      pets_inc.set_schedule (c_pet);  -- Modified Line
END;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
