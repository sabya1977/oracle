CREATE OR REPLACE PACKAGE customer_rules
IS
    FUNCTION min_balance RETURN PLS_INTEGER;  /* Toronto */
    
    FUNCTION eligible_for_discount 
       (customer_in IN customer%ROWTYPE) 
       RETURN BOOLEAN;

    FUNCTION eligible_for_discount 
       (customer_id_in IN customer.customer_id%TYPE) 
       RETURN BOOLEAN;

END customer_rules;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
