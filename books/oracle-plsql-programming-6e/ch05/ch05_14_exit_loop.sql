SET serveroutput ON SIZE 10000

VARIABLE max_pets  NUMBER;

BEGIN
  :max_pets := 2;
END;
/

DECLARE
   CURSOR occupancy_cur IS 
      SELECT pet_id, room_number
        FROM occupancy WHERE occupied_dt = TRUNC(SYSDATE);
   pet_count INTEGER := 0;
BEGIN
   FOR occupancy_rec IN occupancy_cur
   LOOP
      update_bill 
         (occupancy_rec.pet_id, occupancy_rec.room_number);
      pet_count := pet_count + 1;
      EXIT WHEN pet_count >= :max_pets;
   END LOOP;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
