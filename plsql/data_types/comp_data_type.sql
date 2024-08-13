-- Name: comp_data_type.sql
-- 
-- Composite data types can hold a structure of data, which is more or less like a row of data.
-- Oracle 9.2 onwards four kinds of composite date types are offered.
-- 
-- 
-- SQL UDT: Two implementations are possible: an object type only implementation, which 
-- supports a SQL-level record structure and both an object type and body implementation, 
-- which supports a class instance.
-- 
-- PL/SQL Record Type: This can hold a structure of data, like its SQL UDT cousin. You can 
-- implement it  by anchoring the data type of elements to columns in tables and views, or 
-- you can explicitly define it. 
-- 
-- SQL Collections: This can hold a list of any scalar SQL data type.  SQL collections of
-- scalar variables are Attribute Data Types (ADTs) and have different behaviors than
-- collections of UDTs. 
-- 
-- ADT: SQL collections of scalar variables are Attribute Data Types (ADTs):
-- 
-- An ADT collection in SQL requires that you define a collection of a SQL base data type, 
-- such as a string data type. To be an ADT attribute data type, a collection type must be
-- a standalone collection type (defined at schema level). For example, you cannot create a 
-- RECORD type at schema level. Therefore, a RECORD type cannot be an ADT attribute data type.
-- 
-- There are two ways to implement SQL collections.
-- 
-- VARRAY: It behaves like a standard array. It has fixed number of elements where you define
-- it as an UDT. 
-- 
-- Nested table: It behaves like a list and does not have fixed number of elements at definition.
-- and can scale to meet your runtime needs within your PGA memory constraints.
-- 
-- PL/SQL Collection: This can hold a list of any scalar SQL data type or record type, and it
-- can also hold a list of any PL/SQL record type. You are not limited to a numeric index value
-- as you can use string value too as index (can be used to create key-value structure).
-- 
-- 
-- SQL UDT (Object)
-- 
CREATE OR REPLACE 
    TYPE ora_demo.president_obj IS OBJECT
    (
        salutation VARCHAR2(5),
        name VARCHAR2(30)
    );
/    
--
GRANT EXECUTE ON ora_demo.president_obj to ORADEV21;   
-- 
DECLARE
    president ora_demo.president_obj := ora_demo.president_obj('Mr.', 'Rosevelt');
BEGIN
    DBMS_OUTPUT.PUT_LINE (president.salutation || ' ' || president.name);
END;
/
-- 
-- SQL Collections
-- 
-- SQL Collection :: ADT Nested Table
-- 
CREATE OR REPLACE 
    TYPE ora_demo.name_table IS TABLE of VARCHAR2(30);
/
--
GRANT EXECUTE on ora_demo.name_table to ORADEV21;
--
DECLARE
    lv_name_list ora_demo.name_table := ora_demo.name_table('Sabyasachi', 'Smith', 'Joseph');
BEGIN
    FOR i IN 1 .. lv_name_list.COUNT 
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Name '|| i|| ' '|| lv_name_list(i));
    END LOOP;
END;
/
--
-- SQL Collection :: ADT Nested Table :: Add new members to ADT collection variable
--
DECLARE
    lv_name_list ora_demo.name_table := ora_demo.name_table('Sabyasachi', 'Smith', 'Joseph');
    v_name VARCHAR2 (30);
BEGIN
    lv_name_list.EXTEND;
    lv_name_list (4) := 'Merlin';
    FOR i IN 1 .. lv_name_list.COUNT 
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Name '|| i|| ' '|| lv_name_list(i));
    END LOOP;
END;
/
-- 
-- SQL Collection :: ADT VARRAY
-- 
CREATE OR REPLACE 
    TYPE ora_demo.name_varray IS VARRAY (5) OF VARCHAR2(30);
/
-- 
GRANT EXECUTE on ora_demo.name_varray to ORADEV21;
-- 
DECLARE
    lv_name_list ora_demo.name_table := 
                            ora_demo.name_table('Sabya', 'Smith', 'Joseph', 'Joel', 'Peter');
    /* must intilize the collection */                            
    lv_name_ar ora_demo.name_varray := ora_demo.name_varray ();
BEGIN
    FOR i IN 1 .. lv_name_list.COUNT
    LOOP
        /* must use EXTEND to add a new empty element before assigning */
        lv_name_ar.EXTEND;
        lv_name_ar(i) := lv_name_list(i);
    END LOOP;

    FOR i IN 1 .. lv_name_ar.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE ('Name '|| i|| ' '|| lv_name_ar(i));
    END LOOP;
END;
/
-- 
-- SQL UDT :: SQL UDT IS OBJECT is defined at schema level (IS OBJECT). 
-- 
-- Cleanup
-- 
DROP TYPE ora_demo.person_tab;
DROP TYPE ora_demo.person_t;
--
-- SQL UDT (Object) :: Define at schema level
-- 
CREATE OR REPLACE 
    TYPE ora_demo.person_t IS OBJECT
    (
        name VARCHAR2 (30),
        age NUMBER
    )
    /* specifies that any object instance and subtype of this type can be created  */
    -- INSTANTIABLE NOT FINAL; 
/
-- 
-- SQL UDT (Object) :: grant EXECUTE privilege on SQL UDT (Object) person_t to ORADEV21
-- 
GRANT EXECUTE ON ora_demo.person_t TO ORADEV21;
-- 
-- SQL UDT (Object) :: Create an Object, assign values to its members and display them
-- 
DECLARE
    ov_person ora_demo.person_t := ora_demo.person_t('Sabyasachi', 48);
BEGIN
    DBMS_OUTPUT.PUT_LINE ('Name=> ' || ov_person.name);
    DBMS_OUTPUT.PUT_LINE ('Age=> ' || ov_person.age);
END;
/
--
-- SQL UDT Collections :: SQL UDT collection is defined at 
-- schema level as a nested table or VARRAY of SQL UDT (Object)
-- 
-- SQL UDT Collections :: Create SQL UDT collection at schema level.
-- 
CREATE OR REPLACE
    TYPE ora_demo.person_tab IS TABLE OF ora_demo.person_t;
/    
--
-- Grant EXECUTE privilege on SQL UDT collection person_tab to ORADEV21
-- 
GRANT EXECUTE ON ora_demo.person_tab TO ORADEV21;
-- 
-- SQL UDT Collection :: Create an variable of collection, 
-- assign values to its members and display them
-- 
DECLARE
    lv_person_table ora_demo.person_tab :=  ora_demo.person_tab (
                                                                ora_demo.person_t(NULL, NULL)
                                                                );
BEGIN
    lv_person_table.EXTEND;
    lv_person_table(1) := ora_demo.person_t('John', 40);
    DBMS_OUTPUT.PUT_LINE('Name: ' || lv_person_table(1).name);
END;
/
-- 
-- Object Table function using UDT using TABLE operator::
-- 
-- The following example will return a collection of Object types using a function
-- functions which returns UDT collection objects using TABLE operator from SELECT
-- 
-- 
-- The following function will be called by TABLE operator
-- 
CREATE OR REPLACE FUNCTION ora_demo.get_person
        RETURN ora_demo.person_tab IS
    
    lv_person_table ora_demo.person_tab :=  ora_demo.person_tab (
                                                                ora_demo.person_t(NULL, NULL)
                                                                );
    BEGIN 
        lv_person_table.EXTEND;
        lv_person_table(1) := ora_demo.person_t('John', 40);
        lv_person_table.EXTEND;
        lv_person_table(2) := ora_demo.person_t('Smith', 50);
        lv_person_table.EXTEND;
        lv_person_table(3) := ora_demo.person_t('Joan', 20);
        lv_person_table.EXTEND;
        lv_person_table(4) := ora_demo.person_t('Keyes', 55);
        lv_person_table.EXTEND;
        lv_person_table(5) := ora_demo.person_t('Patrick', 55);
        RETURN lv_person_table;
    END;
/
-- 
-- TABLE operator used in SELECT
-- 
SELECT 
    NAME AS PERSON_NAME, AGE AS PERSON_AGE
FROM 
    TABLE(ora_demo.get_person());
-- 
-- 
-- PL/SQL Collections :: 