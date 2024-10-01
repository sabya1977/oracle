-- name collections_definition.sql
-- To demonstrate all types of collections in Oracle PL/SQL and SQL
--
-- PL/SQL Collections :: PL/SQL Collections are declared as TYPE inside PL/SQL block.
-- They are not maintained as schema objects in the Database as SQL collections.
-- There are four types of PL/SQL collections:
--
-- ADT Collections (TABLE OF and VARRAY)
-- Associative Arrays of Scalar Variables
-- Associative Arrays of Composite Variables
-- UDT Collections 
--
-- 
-- PL/SQL Collections :: ADT Collections (VARRAY)
-- 
SET SERVEROUTPUT ON
DECLARE
    TYPE arv_plsql_varray IS VARRAY(3) OF VARCHAR2(2);
    /* must be initialized */
    lv_state arv_plsql_varray := arv_plsql_varray ('NY', 'MD');
BEGIN
    /* maximum length of the array */   
    DBMS_OUTPUT.PUT_LINE('LIMIT=> ' || lv_state.LIMIT);
    /* current length of the array */   
    DBMS_OUTPUT.PUT_LINE('COUNT=> ' || lv_state.COUNT);
    /* Extend space and assign to the new index. */
    lv_state.EXTEND;
    lv_state(lv_state.COUNT) := 'NJ';
    FOR i IN 1..lv_state.COUNT 
        LOOP
            DBMS_OUTPUT.PUT_LINE('State Code => ' || i || ' ' || lv_state(i));
    END LOOP;
END;
/
-- 
-- PL/SQL Collections :: ADT Collections (TABLE)
-- 
DECLARE
    TYPE arv_plsql_table IS TABLE OF VARCHAR2(2);
    /* must be initialized */
    lv_state arv_plsql_table := arv_plsql_table (NULL);
BEGIN
    /* LIMIT is blank */
    DBMS_OUTPUT.PUT_LINE('LIMIT=> ' || lv_state.LIMIT);
    lv_state(lv_state.COUNT) := 'CA';
    lv_state.EXTEND;
    lv_state(lv_state.COUNT) := 'NY';
    lv_state.EXTEND;
    lv_state(lv_state.COUNT) := 'NJ';
    lv_state.EXTEND;
    lv_state(lv_state.COUNT) := 'MD';
    lv_state.EXTEND;
    lv_state(lv_state.COUNT) := 'IL';
    FOR i IN 1..lv_state.COUNT
        LOOP
            DBMS_OUTPUT.PUT_LINE('State Code => ' || i || ' ' || lv_state(i));
    END LOOP;
END;
/
-- 
-- PL/SQL Collections :: Associative Arrays of Scalar variable
-- 
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
-- PL/SQL Collections :: Associative Arrays of Composite Variables
-- 
DECLARE
    TYPE lrc_city IS RECORD
    (
        city_code VARCHAR2(2),
        city_name VARCHAR2(20)
    );
    TYPE lt_city_table IS TABLE OF lrc_city INDEX BY BINARY_INTEGER;
    lv_city_list lt_city_table;
BEGIN   
    lv_city_list(1).city_code := 'NY';
    lv_city_list(1).city_name := 'New York';
    lv_city_list(2).city_code := 'CA';
    lv_city_list(2).city_name := 'California';
    lv_city_list(3).city_code := 'NJ';
    lv_city_list(3).city_name := 'New Jersy';
    lv_city_list(4).city_code := 'IL';
    lv_city_list(4).city_name := 'Illinois';
    lv_city_list(5).city_code := 'OH';
    lv_city_list(5).city_name := 'Ohio';

    FOR i IN 1 .. lv_city_list.COUNT 
    LOOP
        DBMS_OUTPUT.PUT_LINE('City Code,Name=> ' || lv_city_list(i).city_code 
                    || ',' || lv_city_list(i).city_name);
    END LOOP;
END;
/
-- 
-- PL/SQL Collections :: UDT Collections
-- 
CREATE OR REPLACE TYPE 
    ora_demo.obj_country IS OBJECT
    (
        country_code    VARCHAR2(2),
        country_name    VARCHAR2 (20),
        country_ISD     VARCHAR2 (3)
    );
/
-- 
GRANT EXECUTE ON ora_demo.obj_country TO ORADEV21;
-- 
DECLARE
    TYPE lt_cty_list IS VARRAY(5) OF ora_demo.obj_country;
    lv_cty_list lt_cty_list := lt_cty_list (ora_demo.obj_country ('IN', 'India', '91'));
BEGIN
    lv_cty_list.EXTEND;
    lv_cty_list (lv_cty_list.COUNT) := ora_demo.obj_country ('CN', 'China', '86');
    FOR i IN 1..lv_cty_list.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE('City Code, Name, ID=> ' || 
                        lv_cty_list(i).country_code || ', '|| 
                        lv_cty_list(i).country_name || ', ' ||
                        lv_cty_list(i).country_ISD
                            );
    END LOOP;
END;
/
-- 
-- SQL Collections :: This can hold a list of any scalar SQL data type or UDTs. SQL collections
-- of scalar variables are Attribute Data Types (ADTs) and have different behaviors than
-- collections of UDTs. 
-- 
-- SQL Collections :: There are two ways to implement SQL collections.
-- 
-- VARRAY: It behaves like a standard array. It has fixed number of elements where you define
-- it as an UDT. 
-- 
-- Nested table: It behaves like a list and does not have fixed number of elements at definition.
-- and can scale to meet your runtime needs within your PGA memory constraints.
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