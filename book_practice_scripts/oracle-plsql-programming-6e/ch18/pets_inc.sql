CREATE OR REPLACE PACKAGE BODY pets_inc  
IS
   CURSOR pet_cur (pet_id_in IN pet.id%TYPE) RETURN pet%ROWTYPE
   IS
      SELECT *
        FROM pet p
       WHERE p.id = pet_id_in;

   FUNCTION next_pet_shots (pet_id_in IN pet.id%TYPE)
      RETURN DATE
   /* This Implementation is Just a Stub, Presumably to be Replaced by 
      Something that Does Something Meaningful Later On */
   IS
   BEGIN
      RETURN SYSDATE;
   END next_pet_shots;

   PROCEDURE set_schedule (pet_id_in IN pet.id%TYPE)
   /* This Implementation is Just a Stub, Presumably to be Replaced by */
   /* Something that Does Something Meaningful Later On */
   IS
   BEGIN
      /* Null is a No-Op. */
      /* The Statement is Included to Satisfy the Compile-Time Syntax-Checker */ 
      NULL;
   END;

END pets_inc;
/



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
