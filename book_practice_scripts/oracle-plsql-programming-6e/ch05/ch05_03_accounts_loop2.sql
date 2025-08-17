DECLARE
   account_id  accounts.account_id%TYPE := 2;
   balance_remaining  accounts.balance%TYPE;
BEGIN
   LOOP
      /* Calculate the balance */
      balance_remaining := account_balance (account_id);

      /* Embed the IF logic into the EXIT statement */
      EXIT WHEN balance_remaining < 1000;

      /* Apply balance if still executing the loop */
      apply_balance (account_id, balance_remaining);
   END LOOP; 
END;
/


/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
