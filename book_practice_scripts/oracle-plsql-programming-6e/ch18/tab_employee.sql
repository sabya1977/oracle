CREATE TABLE employee ( 
employee_id NUMBER(38,0) CONSTRAINT pk_employee PRIMARY KEY NOT NULL 
,deptno NUMBER(3,0) NOT NULL
,first_name  VARCHAR2(95) NOT NULL
,last_name   VARCHAR2(95) NOT NULL
,salary NUMBER(11,2)
);




/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
