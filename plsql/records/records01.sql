-- Oracle Records
--
-- A record is a composite data type, which means that it can hold more than one piece 
-- of information, as compared to a scalar data type, such as a number or string. It’s 
-- rare, in fact, that the data with which you are working is just a single value, so 
-- records and other composite data types are likely to figure prominently in your PL/SQL
--  programs.
--
-- Declare Table-based record using %ROWTYPE
--
CREATE OR REPLACE PROCEDURE process_employees (emp_no IN emp.empno%TYPE)
IS
l_employee emp%ROWTYPE;
BEGIN
    SELECT 
        *
    INTO
        l_employee
    FROM 
        emp
    WHERE empno = emp_no;
    DBMS_OUTPUT.PUT_LINE('Employee Name ' || l_employee.ename);
END;
/
--
variable empno number
exec :empno := 7839
begin 
    process_employees (:empno);
end;
/
--
-- Declare Cursor-based record using cursor
--
DECLARE
    dno dept.deptno%TYPE;

    CURSOR emp_rec_cur IS
        SELECT 
            empno, 
            d.deptno,
            dname,
            ename, 
            job, 
            sal
        FROM 
            emp e
        INNER JOIN
            dept d
        ON e.deptno = d.deptno AND d.deptno = dno;
    l_employee emp_rec_cur%ROWTYPE;        
BEGIN   
    dno := 10;
    OPEN emp_rec_cur;
    LOOP
        FETCH emp_rec_cur INTO l_employee;
        EXIT WHEN emp_rec_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE ('Emp No: '|| l_employee.empno ||' ' || 'Emp Name: '|| l_employee.ename);
        DBMS_OUTPUT.PUT_LINE ('Department Name: ' || l_employee.dname);
    END LOOP;
    CLOSE emp_rec_cur;
END;
/
--
-- Using REF Cursor.
--
DECLARE
    /* cursor type for emp table */
    TYPE emp_rc IS REF CURSOR RETURN emp%ROWTYPE;
    /* cursor variable of emp table */
    emp_cv emp_rc;
    /* record variable to store emp records */
    emp_rec emp%ROWTYPE;
BEGIN 
    OPEN emp_cv FOR SELECT * FROM emp;
    FETCH emp_cv INTO emp_rec;
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_rec.ename);
    CLOSE emp_cv;
END;
/
--
-- Using implicit records.
--
BEGIN 
    FOR emp_rec IN (SELECT * FROM emp) /* emp_rec is not explicitly defined */
        LOOP
            DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_rec.ename);
            DBMS_OUTPUT.PUT_LINE('Salary ' || emp_rec.sal);
        END LOOP;
END;
/
--
-- User-defined record types
--
