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
-- ADT Collection: An ADT collection in SQL requires that you define a collection of a SQL 
-- base data type, such as a string data type.  
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
-- SQL ADT Collection using VARRAY
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
