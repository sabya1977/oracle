-- xml_func.sql 
-- 
-- SQL/XML functions :: The SQL/XML functions present in Oracle9i Release 2 
-- allow nested structures to be queried in a standard way with no additional
-- database object definitions. In this article I will only present those I 
-- use most frequently.
-- 
-- The XMLELEMENT function is the basic unit for 
-- turning column data into XML fragments.
-- 
SELECT XMLELEMENT("name", e.ename) AS employee
FROM   emp e
WHERE  e.empno = 7782;
-- 
/*
EMPLOYEE
-------------------------------
<name>CLARK</name>
*/
-- 
-- 
SELECT XMLELEMENT("employee",
            XMLELEMENT("name", e.ename),
            XMLELEMENT("salary", e.sal)) AS employee
FROM   emp e
WHERE  e.empno = 7782;
-- 
/*
EMPLOYEE
_______________________________________________________________
<employee><name>CLARK</name><salary>2450</salary></employee>
*/
-- 
-- XMLATRIBUTES function converts column data 
-- into  attributes of the parent element
-- This function makes multiple column handling
-- easier.
-- 
SELECT XMLELEMENT("employee",
         XMLATTRIBUTES(
           e.empno AS "works_number",
           e.ename AS "name")
       ) AS employee
FROM   emp e
WHERE  e.empno = 7782;
-- 
/*
EMPLOYEE
_________________________________________________________
<employee works_number="7782" name="CLARK"></employee>
*/
-- 
-- XMLFOREST :: Using XMLELEMENT to deal with lots 
-- of columns is rather clumsy. Like XMLATTRIBUTES,
-- the XMLFOREST function allows you to process 
-- multiple columns at once.
-- 
SELECT XMLELEMENT("employee",
         XMLFOREST(
           e.empno AS "works_number",
           e.ename AS "name",
           e.job AS "job")
       ) AS employee
FROM   emp e
WHERE  e.empno = 7782;
-- 
-- 
/*
EMPLOYEE
_____________________________________________________________________________________________
<employee><works_number>7782</works_number><name>CLARK</name><job>MANAGER</job></employee>
*/
-- 
-- XMLAGG :: So far we have seen creating individual XML fragments.
-- What happens if we start dealing with multiple rows of data?
-- 
SELECT XMLELEMENT("employee",
         XMLFOREST(
           e.empno AS "works_number",
           e.ename AS "name")
       ) AS employees
FROM   emp e
WHERE  e.deptno = 10;
-- 
-- We got the XML we wanted, but it is returned 
-- as three fragments in three separate rows.
-- 
/*
EMPLOYEES
_________________________________________________________________________
<employee><works_number>7839</works_number><name>KING</name></employee>
<employee><works_number>7782</works_number><name>CLARK</name></employee>
<employee><works_number>7934</works_number><name>MILLER</name></employee>
*/
-- 
-- XMLAGG :: XMLAGG function allows is to aggregate
-- these separate fragments into a single fragment
-- 
SELECT XMLAGG(
         XMLELEMENT("employee",
           XMLFOREST(
             e.empno AS "works_number",
             e.ename AS "name")
         )
       ) AS employees
FROM   emp e
WHERE  e.deptno = 10;
-- 
-- 
/*
EMPLOYEES
___________________________________________________________________________________________________________________________________________________________________________________________________________________________
<employee><works_number>7839</works_number><name>KING</name></employee><employee><works_number>7782</works_number><name>CLARK</name></employee><employee><works_number>7934</works_number><name>MILLER</name></employee>
*/
-- 
-- Without a root (base) tag, this is not a well formed document, 
-- so we must surround it in an XMLELEMENT to provide the root tag
-- 
SELECT XMLELEMENT("employees",
         XMLAGG(
           XMLELEMENT("employee",
             XMLFOREST(
               e.empno AS "works_number",
               e.ename AS "name")
           )
         )
       ) AS employees
FROM   emp e
WHERE  e.deptno = 10;
-- 
/*
EMPLOYEES
_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
<employees><employee><works_number>7839</works_number><name>KING</name></employee><employee><works_number>7782</works_number><name>CLARK</name></employee><employee><works_number>7934</works_number><name>MILLER</name></employee></employees>
*/
-- 
