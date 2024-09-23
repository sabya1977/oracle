-- name :: xmltype.sql
-- Oracle 9i introduced a dedicated XML datatype called XMLTYPE. 
-- It is made up of a LOB to store the original XML data and a 
-- number of member functions to make the data available to SQL.
-- 
-- The below examples will show how generate XML data from 
-- relation data using XMLType data type.

CREATE TABLE tab1 (
  col1  SYS.XMLTYPE
);
-- 
DECLARE
  v_xml   SYS.XMLTYPE;
  v_doc   CLOB;
BEGIN
  -- XMLTYPE created from a CLOB
  v_doc := '<?xml version="1.0"?>' || Chr(10) || ' <TABLE_NAME>MY_TABLE</TABLE_NAME>';
  v_xml := SYS.XMLTYPE.createXML(v_doc);
  -- This works too!
  --v_xml := sys.xmltype(v_doc);

  INSERT INTO tab1 (col1) VALUES (v_xml);

-- XMLTYPE created from a query
  SELECT SYS_XMLGEN(table_name)
  INTO   v_xml
  FROM   user_tables
  WHERE  rownum = 1;

  INSERT INTO tab1 (col1) VALUES (v_xml);

  COMMIT;
END;
/
-- 
-- The data in the table can be viewed using the following query.
-- 
SET LONG 1000
SELECT a.col1.getStringVal()
FROM   tab1 a;
-- 
-- We can extract the value of specific tags using the following.
-- 
SELECT a.col1.extract('//TABLE_NAME/text()').getStringVal() AS "Table Name"
FROM   tab1 a
WHERE  a.col1.existsNode('/TABLE_NAME')  = 1;
-- 
-- Convert Ref Cursor to XMLTYPE
-- 
-- The following query uses the CURSOR expression twice. The outer call 
-- converts the query to a ref cursor that is passed to the XMLTYPE constructor.
-- Internally the query uses a CURSOR expression to nest the employees data as 
-- a ref cursor within the department rows. 
-- 
SET LONG 1000000
SELECT XMLTYPE(CURSOR(SELECT d.dname AS "department_name",
                             d.deptno AS "department_number",
                             CURSOR(SELECT e.empno AS "employee_number",
                                           e.ename AS "employee_name"
                                    FROM   emp e
                                    WHERE  e.deptno = d.deptno
                                    ORDER BY e.empno) AS "employees"
                     FROM   dept d
                     WHERE d.deptno = 20
                     ORDER BY d.dname)) AS data
FROM   dual;
-- 
/*
DATA
_________________________________________________________________________
<?xml version="1.0"?>
<ROWSET>
  <ROW>
    <department_name>RESEARCH</department_name>
    <department_number>20</department_number>
    <employees>
      <employees_ROW>
        <employee_number>7369</employee_number>
        <employee_name>SMITH</employee_name>
      </employees_ROW>
      <employees_ROW>
        <employee_number>7566</employee_number>
        <employee_name>JONES</employee_name>
      </employees_ROW>
      <employees_ROW>
        <employee_number>7788</employee_number>
        <employee_name>SCOTT</employee_name>
      </employees_ROW>
      <employees_ROW>
        <employee_number>7876</employee_number>
        <employee_name>ADAMS</employee_name>
      </employees_ROW>
      <employees_ROW>
        <employee_number>7902</employee_number>
        <employee_name>FORD</employee_name>
      </employees_ROW>
    </employees>
  </ROW>
</ROWSET>
*/
-- 
-- Using PL/SQL
-- 
SET SERVEROUTPUT ON
DECLARE
  l_cursor SYS_REFCURSOR;
  l_xml    XMLTYPE;
BEGIN
  
  OPEN l_cursor FOR
    SELECT d.dname AS "department_name",
           d.deptno AS "department_number",
           CURSOR(SELECT e.empno AS "employee_number",
                         e.ename AS "employee_name"
                  FROM   emp e
                  WHERE  e.deptno = d.deptno
                  ORDER BY e.empno) AS "employees"
    FROM   dept d
    WHERE  d.deptno = 20
    ORDER BY d.dname;

  l_xml := XMLTYPE(l_cursor);
  DBMS_OUTPUT.put_line(l_xml.getClobVal());
END;
/
-- 
-- 