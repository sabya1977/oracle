set serveroutput on size 500000

DECLARE
   CURSOR checked_out_cur IS 
      SELECT pet_id, name, checkout_date 
        FROM occupancy WHERE  checkout_date IS NOT NULL;
BEGIN
   FOR checked_out_rec IN checked_out_cur 
   LOOP
      BEGIN
         INSERT INTO occupancy_history (pet_id, NAME, checkout_date)
         SELECT pet_id, NAME, checkout_date
           FROM occupancy WHERE checkout_date IS NOT NULL;
         DELETE FROM occupancy WHERE checkout_date IS NOT NULL;
      EXCEPTION
         WHEN OTHERS THEN
            log_checkout_error (checked_out_rec);
      END;
   END LOOP;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
