set serveroutput on size 500000

DECLARE
   CURSOR occupancy_cur IS 
      SELECT pet_id, room_number
      FROM occupancy WHERE occupied_dt = TRUNC(SYSDATE);
   occupancy_rec occupancy_cur%ROWTYPE;
BEGIN
   OPEN occupancy_cur;
   LOOP
      FETCH occupancy_cur INTO occupancy_rec;
      EXIT WHEN occupancy_cur%NOTFOUND;
      update_bill 
         (occupancy_rec.pet_id, occupancy_rec.room_number);
   END LOOP;
   CLOSE occupancy_cur;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
