DECLARE
   CURSOR checked_out_cur IS 
      SELECT pet_id, name, checkout_date 
        FROM occupancy WHERE  checkout_date IS NOT NULL;
BEGIN
   FOR checked_out_rec IN checked_out_cur 
   LOOP
      INSERT INTO occupancy_history (pet_id, name, checkout_date)
         VALUES (checked_out_rec.pet_id, checked_out_rec.name, 
                 checked_out_rec.checkout_date);
      DELETE FROM occupancy WHERE pet_id = checked_out_rec.pet_id;
   END LOOP;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
