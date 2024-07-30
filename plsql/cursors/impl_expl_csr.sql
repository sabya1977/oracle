-- Name: impl_expl_csr.sql
-- 
-- demonstrates implicit and explicit cursors
-- 
-- Implicit Cursor: ou create an implicit cursor when you use a
-- SELECT statement with an INTO clause or BULK COLLECT INTO clause, 
-- or you embed a SELECT statement inside a cursor FOR loop statement. 
-- Data Manipulation Language (DML) statements inside any execution or 
-- exception block are also implicit cursors. These DML statements
-- include INSERT, UPDATE, DELETE, and MERGE statements.
--
-- we can use implicit cursor attributes such as SQL%ROWCOUNT and SQL%FOUND 
-- to check the status of the DML statements inside the PL/SQL block.
-- 
CREATE TABLE ora_demo.emp_tmp AS SELECT * FROM ora_demo.emp;
--
VARIABLE deptno NUMBER
EXECUTE :deptno := 10
BEGIN
    DELETE FROM ora_demo.emp_tmp
    WHERE deptno = :deptno;

    IF (SQL%FOUND) THEN
        DBMS_OUTPUT.PUT_LINE (
                    'Delete succeeded for department number ' || :deptno
        );
    ELSE
        DBMS_OUTPUT.PUT_LINE ('No department number ' || :deptno);
    END IF;
END;
/
--
-- Cusrsor FOR LOOP - Static Implicit cursor
-- 
BEGIN 
    FOR cv_cursor IN 
            (
                SELECT 
                    empno,
                    ename,
                    job,
                    sal,
                    dname,
                    loc
                FROM
                    ora_demo.emp e
                INNER JOIN
                    ora_demo.dept d
                ON e.deptno = d.deptno
            ) LOOP
            DBMS_OUTPUT.PUT_LINE ('EID='||cv_cursor.empno||' Name='||cv_cursor.ename||
                        ' Job='||cv_cursor.job||' Salary='||cv_cursor.sal||' Dept='||
                        cv_cursor.dname||' Location='|| cv_cursor.loc);
    END LOOP;
END;
/
--
-- Cusrsor FOR LOOP - Dynamic Implicit cursor
-- the difference between a dynamic implicit cursor and static implicit 
-- cursor is that the dynamic one embeds locally scoped variables. 
-- 
DECLARE
    lv_deptno NUMBER :=10;
BEGIN 
    FOR cv_cursor IN 
            (
                SELECT 
                    empno,
                    ename,
                    job,
                    sal,
                    dname,
                    loc
                FROM
                    ora_demo.emp e
                INNER JOIN
                    ora_demo.dept d
                ON e.deptno = d.deptno
                WHERE d.deptno = lv_deptno
            ) LOOP
            DBMS_OUTPUT.PUT_LINE ('EID='||cv_cursor.empno||' Name='||cv_cursor.ename||
                        ' Job='||cv_cursor.job||' Salary='||cv_cursor.sal||' Dept='||
                        cv_cursor.dname||' Location='|| cv_cursor.loc);
    END LOOP;
END;
/
--
-- Explicit cursor: You create an explicit cursor when you define a cursor inside a declaration
-- block. 
-- 
-- Explicit cursors require you to open, fetch, and close them regardless of whether you’re 
-- using simple loop statements, WHILE loops statements, or cursor FOR loop statements. You 
-- use the OPEN statement to open cursors, the FETCH statement to fetch records from cursors, 
-- and the CLOSE statement to close and release resources of cursors.
-- 
-- Static Explicit cusrsor: Static SELECT statements return the same query each time with 
-- potentially different results. The results change as the data changes in the tables or
--  views.
-- 
DECLARE
    lv_ename ora_demo.emp.ename%TYPE;
    CURSOR csr_emp IS
        SELECT 
            ename
        FROM 
            ora_demo.emp;
BEGIN 
        OPEN csr_emp;
        LOOP
            FETCH csr_emp 
                        INTO lv_ename;
            EXIT WHEN csr_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE ('Name= '|| lv_ename);
        END LOOP;
        CLOSE csr_emp;
END;
/
    --
-- 
-- Dynamic Explicit cursor:  Dynamic SELECT statements act like parameterized
-- subroutines. They run different queries each time, depending on the actual para-
-- meters provided when they’re opened. 
--
-- Dynamic explicit cursor with parameters
--
VARIABLE sal NUMBER
EXEC :sal := 1000
DECLARE
    lv_sal NUMBER := :sal;
    CURSOR csr_emp_dept (cv_sal NUMBER) IS
            SELECT 
                e.ename,
                e.sal,
                d.dname
            FROM 
                emp e
            INNER JOIN
                dept d
            ON e.deptno = d.deptno AND e.sal > cv_sal;

    lv_emp_rec csr_emp_dept%ROWTYPE;
BEGIN   
    OPEN csr_emp_dept(lv_sal);
    LOOP
        FETCH csr_emp_dept INTO lv_emp_rec;
        EXIT WHEN csr_emp_dept%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE ('Employee Name='||lv_emp_rec.ename||
            ' Salary='||lv_emp_rec.sal||' Dept. Name='||lv_emp_rec.dname);
    END LOOP;
END;
/
-- 
-- Same can be achieved using FOR LOOP cursor
--
VARIABLE sal NUMBER
EXEC :sal := 1000
DECLARE
    lv_sal NUMBER := :sal;
    CURSOR csr_emp_dept (cv_sal NUMBER) IS
            SELECT 
                e.ename,
                e.sal,
                d.dname
            FROM 
                emp e
            INNER JOIN
                dept d
            ON e.deptno = d.deptno AND e.sal > cv_sal;

BEGIN
    FOR lv_emp IN csr_emp_dept (lv_sal)
        LOOP
            DBMS_OUTPUT.PUT_LINE ('Employee Name='||lv_emp.ename||
            ' Salary='||lv_emp.sal||' Dept. Name='||lv_emp.dname);
    END LOOP;
END;
/
