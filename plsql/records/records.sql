-- Oracle Records
--
-- A record is a composite data type, which means that it can hold more than one piece 
-- of information, as compared to a scalar data type, such as a number or string. It’s 
-- rare, in fact, that the data with which you are working is just a single value, so 
-- records and other composite data types are likely to figure prominently in your PL/SQL
--  programs.
-- 
-- Records are useful when you want to store values of different data types but only one occurence at a time
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
DECLARE
    TYPE emp_rec_type IS RECORD
        (
            eno emp.empno%TYPE,
            ename VARCHAR2(10),
            sal NUMBER
        );
    emp_rec emp_rec_type;   
    CURSOR emp_cur IS SELECT empno, ename, sal FROM emp;
BEGIN
    OPEN emp_cur;
    LOOP
       FETCH emp_cur INTO emp_rec;
       EXIT WHEN emp_cur%NOTFOUND;
       DBMS_OUTPUT.PUT_LINE('Emp Name ' || emp_rec.eno);
    END LOOP;
    CLOSE emp_cur;
END;
/
--
-- %ROWTYPE Variable Represents Partial Database Table Row
--
DECLARE
    CURSOR c IS 
        SELECT empno, ename, sal FROM emp;

    employee c%ROWTYPE;
BEGIN 
        OPEN c;
        LOOP
            FETCH c INTO employee;
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('Emp Name: ' || employee.ename);
            DBMS_OUTPUT.PUT_LINE('Emp Salary: ' || employee.sal);
        END LOOP;
        CLOSE c;
END;
/
--
-- Inserting records into table
--
CREATE TABLE workers AS SELECT * FROM emp WHERE 1 <> 1;
--
DECLARE
    worker_rv workers%ROWTYPE;
BEGIN 
    FOR emp_rec IN (SELECT * FROM emp)
        LOOP
            worker_rv.empno := emp_rec.empno;
            worker_rv.ename := emp_rec.ename;
            worker_rv.job := emp_rec.job;
            worker_rv.hiredate := emp_rec.hiredate;
            worker_rv.sal := emp_rec.sal;
            worker_rv.comm := emp_rec.comm;
            worker_rv.deptno := emp_rec.deptno;
            INSERT INTO workers VALUES worker_rv;
        END LOOP;
    COMMIT;
END;
/
--
SELECT * FROM workers;
-- Clean up
--
DROP TABLE workers;
--
-- We can assign records to another at record level
--
CREATE TABLE workers AS SELECT * FROM emp WHERE 1 <> 1;
--
DECLARE
    worker_rv workers%ROWTYPE;
BEGIN 
    FOR emp_rec IN (SELECT * FROM emp)
        LOOP
            worker_rv := emp_rec;
            INSERT INTO workers VALUES worker_rv;
        END LOOP;
    COMMIT;
END;
/
--
SELECT * FROM workers;
--
-- Update records
--
DECLARE
    CURSOR worker_cur IS SELECT empno, deptno, sal, comm FROM workers;
    worker_cv worker_cur%ROWTYPE;
    TYPE emp_rec IS RECORD 
        (
            empno emp.empno%TYPE,
            deptno emp.deptno%TYPE,
            sal emp.sal%TYPE,
            comm emp.comm%TYPE
        );
    emp_rv emp_rec;
BEGIN 
    OPEN worker_cur;
    LOOP
        FETCH worker_cur INTO worker_cv;
            EXIT WHEN worker_cur%NOTFOUND;
        IF worker_cv.deptno = 10
           THEN 
                worker_cv.comm := NVL(worker_cv.comm,0) + worker_cv.sal*.5;
        END IF;
        UPDATE workers
        SET comm = worker_cv.comm
        WHERE empno = worker_cv.empno
        RETURNING empno, deptno, sal, comm INTO emp_rv;
        DBMS_OUTPUT.PUT_LINE('Emp No ' || emp_rv.empno);
        DBMS_OUTPUT.PUT_LINE('Emp salary ' || emp_rv.sal);
        DBMS_OUTPUT.PUT_LINE('Emp new commission ' || emp_rv.comm);
    END LOOP;
    CLOSE worker_cur;
END;
/

        
