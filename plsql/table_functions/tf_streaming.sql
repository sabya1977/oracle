-- 
-- name: tf_streaming.sql
-- 
-- Streaming table functions play a crucial role in data warehouse ETLs 
-- (extract-transform-load) operations. Oracle Database makes building 
-- such functions easy through its implementation of PL/SQL cursor variables
-- and the CURSOR expression.
-- 
-- Remember that the collection constructed and returned by a streaming table 
-- function will consume PGA memory, so very large data sets passed in to the 
-- function via the cursor variable could result in errors.
-- 
-- In the below example we will write a simple streaming function to transform
-- employee data by concatenating first_name and last_name. It will also load
-- other attributes of sh.customers table.
-- 
-- Create output table
CREATE TABLE stg_customer_trn
(
    cust_id         NUMBER,
    cust_name       VARCHAR2(60),
    cust_gender     CHAR(1),
    cust_dob_yr     NUMBER(4),
    cust_city       VARCHAR2(30),
    cust_state      VARCHAR2(40)
);
-- 
-- Define customer object type and nested table of the customer object type
-- 
CREATE OR REPLACE TYPE customer_ot 
                AUTHID DEFINER IS OBJECT 
(
    cust_id         NUMBER,
    cust_name       VARCHAR2(60),
    cust_gender     CHAR(1),
    cust_dob_yr     NUMBER(4),
    cust_city       VARCHAR2(30),
    cust_state      VARCHAR2(40),
    cust_rank       VARCHAR2 (15)
);
/
-- 
CREATE OR REPLACE TYPE customer_nt AS TABLE OF customer_ot;
/
--
-- If ORADEV21 has access to the table through a role the following 
-- package definition will give error. So grant SELECT on the table
-- directly to ORDEV21
-- 
GRANT SELECT ON sh.customers TO ORADEV21;
-- 
CREATE OR REPLACE PACKAGE sh.cust_stream_pkg AUTHID DEFINER
IS
    TYPE customer_rc IS REF CURSOR RETURN sh.customers%ROWTYPE;
END cust_stream_pkg;
/
-- 
-- Create a streaming function 
-- 
CREATE OR REPLACE FUNCTION 
            cust_name_merge_fn (rows_in cust_stream_pkg.customer_rc)
            RETURN customer_nt
            AUTHID DEFINER
IS
    /* this is to hold the input parameter cursor */
    TYPE cust_aat IS TABLE OF sh.customers%ROWTYPE INDEX BY PLS_INTEGER;
    l_cust cust_aat;

    /* nested table to be returned after transformation */
    l_cust_mod_rc customer_nt := customer_nt ();
BEGIN 
    FETCH rows_in BULK COLLECT INTO l_cust;
    
    FOR l_cust_row IN 1 .. l_cust.COUNT
    LOOP
        l_cust_mod_rc.EXTEND;
        l_cust_mod_rc (l_cust_mod_rc.LAST) := 
                  customer_ot 
                        (
                        l_cust(l_cust_row).cust_id,
                        l_cust(l_cust_row).cust_first_name
                        || ' ' ||
                        l_cust(l_cust_row).cust_first_name,
                        l_cust(l_cust_row).cust_gender,
                        l_cust(l_cust_row).cust_year_of_birth,
                        l_cust(l_cust_row).cust_city,
                        l_cust(l_cust_row).cust_state_province
                        );
    END LOOP;
    CLOSE rows_in;
    RETURN l_cust_mod_rc;
END;
/
-- 
INSERT INTO stg_customer_trn
SELECT * FROM TABLE (cust_name_merge_fn(
                        CURSOR(SELECT * FROM sh.customers)));
-- 
COMMIT;
-- 
-- Second transformation
-- 
