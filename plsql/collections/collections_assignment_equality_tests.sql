-- name: collections_assignment_equality_tests.sql
-- 
-- To demonstrate assignment and equality tests of collection variables
-- 
-- Collection Assignment :: Assignments can only be made between collections 
-- of the same type. Not types of similar structures, or with the same name in
-- different packages, but literally the same type.
-- 
SET SERVEROUTPUT on
DECLARE
    TYPE table_type IS TABLE OF NUMBER(10);
    v_tab_1  table_type;
    v_tab_2  table_type;
BEGIN 
    -- Initialise the collection with two values.
    v_tab_1 := table_type(1, 2);
    -- Assignment works.
    v_tab_2 := v_tab_1;
    DBMS_OUTPUT.PUT_LINE('v_tab_2=> ' || v_tab_2(1));
    DBMS_OUTPUT.PUT_LINE('v_tab_2=> ' || v_tab_2(2));
END;
/    
-- 
-- If we repeat that, but this time use two separate types with similar 
-- definitions, we can see the code fails to compile due to the illegal
-- assignment.
-- 
SET SERVEROUTPUT on
DECLARE
    TYPE table_type_1 IS TABLE OF NUMBER(10);
    TYPE table_type_2 IS TABLE OF NUMBER(10);
    v_tab_1  table_type_1;
    v_tab_2  table_type_2;
BEGIN 
    -- Initialise the collection with two values.
    v_tab_1 := table_type_1(1, 2);
    -- Assignment causes compilation error.
    v_tab_2 := v_tab_1;
    DBMS_OUTPUT.PUT_LINE('v_tab_2=> ' || v_tab_2(1));
    DBMS_OUTPUT.PUT_LINE('v_tab_2=> ' || v_tab_2(2));
END;
/
-- 
