CREATE OR REPLACE PACKAGE BODY magic_values_pkg  -- Added Line
IS  -- Added Line
   PROCEDURE adjust_line_item  -- Added Line
   IS   -- Added Line
   BEGIN  -- Added Line
      /* This Implementation is Just a Stub, Presumably to be Replaced by */  -- Added Line
      /* Something that Does Something Meaningful Later On */  -- Added Line

      /* Null is a No-Op. */  -- Added Line
      /* The Statement is Included to Satisfy the Compile-Time Syntax-Checker */  -- Added Line
      NULL;  -- Added Line  ;
   END adjust_line_item;  -- Added Line

   PROCEDURE reopen_customer  -- Added Line
   IS   -- Added Line
   BEGIN  -- Added Line
      /* This Implementation is Just a Stub, Presumably to be Replaced by */  -- Added Line
      /* Something that Does Something Meaningful Later On */  -- Added Line

      /* Null is a No-Op. */  -- Added Line
      /* The Statement is Included to Satisfy the Compile-Time Syntax-Checker */  -- Added Line
      NULL;  -- Added Line  ;
   END reopen_customer;  -- Added Line
BEGIN  -- Added Line
   IF footing_difference BETWEEN 1 and 100
   THEN 
      adjust_line_item;
   END IF;
   
   IF cust_status = 'C' 
   THEN 
      reopen_customer; 
   END IF;
END magic_values_pkg;  -- Added Line
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
