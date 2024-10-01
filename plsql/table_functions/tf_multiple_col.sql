-- 
-- name: tf_multiple_col.sql
-- 
-- Returning Multiple Columns
-- We have seen that emp_name_tab function can return only one value. We will
-- now see how a table function can return more than one columns.
-- 
-- Table function to display employee names of a department
-- 
-- 
CREATE OR REPLACE 
            TYPE emp_obj IS OBJECT
    (
        eno     NUMBER (4),
        ename   VARCHAR2 (10),
        esal    NUMBER (7,2)
    );
/    
CREATE OR REPLACE 
    TYPE emp_rec IS TABLE OF emp_obj;
/
-- 
CREATE OR REPLACE FUNCTION emp_rec_cols (dno_in IN NUMBER)
   RETURN emp_rec
   AUTHID DEFINER
IS
   l_emp_rec emp_rec := emp_rec (emp_obj(1, 'Sabya', 200));
BEGIN   
    FOR erec IN 
            (
                SELECT 
                    empno,
                    ename,
                    sal
                FROM 
                    emp
                WHERE deptno = dno_in
            )
    LOOP
        l_emp_rec.EXTEND;
        l_emp_rec(l_emp_rec.LAST) := emp_obj (erec.empno, erec.ename, erec.sal);
    END LOOP;
   RETURN l_emp_rec;
END;
/
-- 
SELECT e.eno, e.ename, e.esal FROM TABLE(emp_rec_cols(10)) e;
-- 
/*
    ENO ENAME        ESAL
_______ _________ _______
      1 Sabya         200
   7839 KING         5000
   7782 CLARK        2450
   7934 MILLER       1300
*/   
-- 
-- With Bulk Bind
-- 
CREATE OR REPLACE FUNCTION emp_rec_cols_bulk (dno_in IN NUMBER)
   RETURN emp_rec
   AUTHID DEFINER
IS
   l_emp_rec emp_rec := emp_rec ();
BEGIN   
    SELECT 
    emp_obj(
        empno,
        ename,
        sal
    )
    BULK COLLECT INTO l_emp_rec
    FROM 
        emp
    WHERE deptno = dno_in;
   RETURN l_emp_rec;
END;
/
-- 
SELECT e.eno, e.ename, e.esal FROM emp_rec_cols_bulk(10) e;
-- 
-- With Left corelation
-- 
SELECT d.deptno, e.eno, e.ename, e.esal FROM 
dept d,
emp_rec_cols_bulk(d.deptno) e;
-- 
