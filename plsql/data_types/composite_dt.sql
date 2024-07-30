-- Name: composite_dt.sql
-- 
-- Composite data types differ from scalar data types because they hold copies of more
-- than one thing.It can hold collections of rows or data. 
-- Beginning Oracle 9i Release 2, following composite data types are offered by Oracle
-- 
-- SQL UDT: Defined at DB level. Two implementation are possible. An Object type which 
-- supports SQL-level record structure and another which supports Object type and Body 
-- implementation with member functions, class instance.
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
-- PL/SQL Record types: Defined in PL/SQL blocks. We already covered it.
--
--
-- SQL Collections: SQL collections can exist for scalar data types or SQL UDT elements.
-- Oracle calls SQL collections of scalar columns Attribute Data Types (ADTs). SQL collections
-- are defined at DB level as DB objects.
--
-- SQL collections may be tables (or lists) of values or varrays (or arrays in traditional
-- programming languages). Tables have no upward limit on the number of elements in the 
-- collection, which is why they act like lists. Varrays have a maximum number of elements 
-- set when you define their types.
--
-- Tables and Vararrays must be constructed by  calling the type name, or default constructor
-- , with a list of members. New members are added at the end of either type of collection in 
-- the same way. You add new members to a collection by using a two-step process that extends 
-- space and assigns a value to an indexed location.
--
-- ADT Collection: SQL collections of scalar variables are Attribute Data Types (ADTs). 
-- An ADT collection in SQL requires that you define a collection of a SQL base data type, 
-- such as a string data type. To be an ADT attribute data type, a collection type must be
-- a standalone collection type (defined at schema level). For example, you cannot create a 
-- RECORD type at schema level. Therefore, a RECORD type cannot be an ADT attribute data type.
-- 
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
-- Add new members to ADT collection variable
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
-- SQL ADT(Attribute Data type) Collection using VARRAY
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
-- SQL UDT (User-defined type) Collection: A UDT collection in SQL requires that 
-- you define a collection of a SQL UDT. SQL UDT IS OBJECT that we have defined 
-- before. It's defined at the DB level as object.
--
DROP TYPE ora_demo.person_tab;
DROP TYPE ora_demo.person_t;
--
CREATE OR REPLACE 
    TYPE ora_demo.person_t IS OBJECT
    (
        name VARCHAR2 (30),
        age NUMBER
        -- CONSTRUCTOR FUNCTION person_t RETURN SELF AS RESULT
        -- MEMBER FUNCTION get_name RETURN VARCHAR2,
        -- MEMBER FUNCTION set_name (name VARCHAR2) RETURN person_t,
        -- MEMBER FUNCTION to_string RETURN VARCHAR2
    )
    /* specifies that any object instance and subtype of this type can be created  */
    -- INSTANTIABLE NOT FINAL; 
/    
--
GRANT EXECUTE ON ora_demo.person_t TO ORADEV21;
--
CREATE OR REPLACE
    TYPE ora_demo.person_tab IS TABLE OF ora_demo.person_t;
/    
--
GRANT EXECUTE ON ora_demo.person_tab TO ORADEV21;
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
-- Object Table function using UDT using TABLE operator. 
-- The following example will return a collection of Object types using a function
-- functions which returns UDT collection objects using TABLE operator from SELECT
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
SELECT 
    NAME AS PERSON_NAME, AGE AS PERSON_AGE
FROM 
    TABLE(ora_demo.get_person());
--
-- PL/SQL Collection: PL/SQL collections are declared as TYPE inside PL/SQL block and 
-- not maintained as schema objects in the Database as SQL collections.
--
-- There are four types of PL/SQL collections:
--
-- ADT Collections (TABLE OF and VARRAY)
-- Associative Arrays of Scalar Variables
-- Associative Arrays of Composite Variables
-- UDT Collections 
--
-- ADT Collections: 
-- Following examples shows PL/SQL ADT collections. 
-- We can also define VARRAY collections of fixed length. 
--
set serveroutput on
DECLARE
    TYPE num_table IS TABLE OF NUMBER;
    /* if we do not initialize the following variable, it'll give error in EXTEND */
    /* ORA-06531: Reference to uninitialized collection */
    -- lv_collection num_table;
    lv_collection num_table := num_table(1,2);
BEGIN   
    lv_collection.EXTEND;
    lv_collection (lv_collection.COUNT) := 3;
    /* the following line will give error as we did not EXTEND the collection */
    -- lv_collection (4) := 4;
    FOR i IN 1 .. lv_collection.COUNT 
    LOOP
        DBMS_OUTPUT.PUT_LINE('lv_collection'|| i|| ': ' || lv_collection(i));
    END LOOP;
END;
/
--
-- Associative Arrays of Scalar Variables:
--
-- Associative Array are oldest PL/SQL collections. They can only be defined inside 
-- PL/SQL blocks. Associative arrays cannot be initialized because you must assign 
-- values one at a time to them.
--
-- One advantage of Associative array is they can be used for Key-value pair structure.
--
set serveroutput on
DECLARE
    TYPE numbers IS TABLE OF NUMBER INDEX BY VARCHAR2(2);
    lv_num_collection numbers;
BEGIN 
    lv_num_collection ('NJ') := 10002104;
    lv_num_collection ('MD') := 10002105;
    lv_num_collection ('IL') := 10002106;
    lv_num_collection ('CA') := 10002107;
    DBMS_OUTPUT.PUT_LINE('NJ Pin Code:' || lv_num_collection('NJ'));
    DBMS_OUTPUT.PUT_LINE('CA Pin Code:' || lv_num_collection('CA'));
END;
/
--
-- Associative Arrays of Composite Variables 
--
DECLARE
    TYPE person IS RECORD
    (
        id NUMBER,
        name VARCHAR2(20)
    );
    TYPE person_tab IS TABLE OF person INDEX BY BINARY_INTEGER;
    person_db person_tab;
BEGIN   
    person_db(1).id := 1;
    person_db(1).name := 'Tim';
    person_db(2).id := 2;
    person_db(2).name := 'Bill';
    person_db(3).id := 3;
    person_db(3).name := 'Mike';

    FOR i IN 1 .. person_db.COUNT 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || person_db(i).name);
        DBMS_OUTPUT.PUT_LINE('ID: ' || person_db(i).id);
    END LOOP;
END;
/




