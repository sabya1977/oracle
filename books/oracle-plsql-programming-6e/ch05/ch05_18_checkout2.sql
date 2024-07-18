BEGIN
   INSERT INTO occupancy_history (pet_id, NAME, checkout_date)
      SELECT pet_id, NAME, checkout_date
        FROM occupancy WHERE checkout_date IS NOT NULL;
   DELETE FROM occupancy WHERE checkout_date IS NOT NULL;
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
