-- Name: ref_cursor.sql
-- Demonstrates functioning of REF CURSOR with RETURN and SYSREFCURSOR types.
--
-- A cursor variable is a variable that points to or references an underlying cursor.
-- The most important benefit of the cursor variable is that it provides a mechanism for
-- passing results of queries (the rows returned by fetches against a cursor) between dif‐
-- ferent PL/SQL programs. We can also return result set to client using cursor varaiable.
-- 
-- Strong cursor variable (REF CURSOR with RETURN): It attaches a record type 
-- (or row type) to the cursor variable type at the moment of declaration. Any
-- cursor variable declared using that type can only FETCH INTO data structures
-- that match the specified record type. The advantage of a strong type is that
-- the compiler can determine whether or not the developer has properly matched
-- up the cursor variable’s FETCH statements with its cursor object’s query list.
--
SET SERVEROUTPUT ON
DECLARE
    /* cursor type */
    TYPE emp_curtype IS REF CURSOR RETURN ora_demo.emp%ROWTYPE;
    /* cursor variable */
    cv_empcurvar emp_curtype;
    /* record of type cursor variable cv_empcurvar */
    lv_emprec cv_empcurvar%ROWTYPE;
BEGIN
    OPEN cv_empcurvar 
                    FOR 
                        SELECT * FROM ora_demo.emp;
    LOOP
        FETCH
            cv_empcurvar INTO lv_emprec;
        EXIT WHEN cv_empcurvar%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Emp_No: ' || lv_emprec.empno || ' Name: '|| lv_emprec.ename);
    END LOOP;
    CLOSE cv_empcurvar;
END;
/
--
-- Weak cursor type (SYS_REFSYS_REFCURSOR)
-- 
VARIABLE sv_refcursor REFCURSOR
DECLARE
    cv_refcursor SYS_REFCURSOR;
BEGIN
    OPEN cv_refcursor FOR SELECT * FROM ora_demo.emp;
    :sv_refcursor := cv_refcursor;
END;
/
PRINT :sv_refcursor
--
-- Fetching from Cursor Variable into Collections
--
DECLARE
    /* declaring SYS_REFCURSOR */
    TYPE emp_curef_type IS REF CURSOR;
    /* delcaring nested table of emp table columns */
    TYPE nt_joblist IS TABLE OF ora_demo.emp.job%TYPE;
    TYPE nt_sallist IS TABLE OF ora_demo.emp.sal%TYPE;
    TYPE nt_namelist IS TABLE OF ora_demo.emp.ename%TYPE;
    /* declaring variables of nested table type */
    lv_empsal nt_joblist;
    lv_empname nt_namelist;
    lv_empjob nt_joblist;
    /* delcaring cursor variable of type emp_curef_type */
    cv_cur_emp emp_curef_type;
BEGIN
    OPEN cv_cur_emp FOR 
                    SELECT 
                        ename,
                        job,
                        sal
                    FROM ora_demo.emp;
    FETCH cv_cur_emp BULK COLLECT 
                            INTO lv_empname, lv_empjob, lv_empsal;
    CLOSE cv_cur_emp;
    FOR i IN 1 .. lv_empname.LAST
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Name='||lv_empname(i)||' Job='|| lv_empjob (i)||' Sal='|| lv_empsal(i));
        END LOOP;
END;
/
--
-- Cursor Variables as Host Variables
--
-- You can use a cursor variable as a host variable, which makes it useful
-- for passing query results between PL/SQL stored subprograms and their clients.
-- When a cursor variable is a host variable, PL/SQL and the client (the host environment)
-- share a pointer to the SQL work area that stores the result set.
-- To use a cursor variable as a host variable, declare the cursor variable in the host
-- environment and then pass it as an input host variable (bind variable) to PL/SQL. 
-- 
VARIABLE emp_cv REFCURSOR
BEGIN   
    OPEN :emp_cv FOR SELECT * FROM ora_demo.emp;
END;
/
PRINT emp_cv
