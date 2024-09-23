-- name: xmltable.sql
-- XMLTable lets you create relational tables and columns from XQuery query results.
-- 
-- Setup
-- 
DROP TABLE EMPLOYEES_XML;
CREATE TABLE EMPLOYEES_XML
(
   id     NUMBER,
   data   XMLTYPE
);
-- 
-- 
INSERT INTO EMPLOYEES_XML
     VALUES (1, xmltype ('<Employees>
    <Employee emplid="1111" type="admin">
        <firstname>John</firstname>
        <lastname>Watson</lastname>
        <age>30</age>
        <email>johnwatson@sh.com</email>
    </Employee>
    <Employee emplid="2222" type="admin">
        <firstname>Sherlock</firstname>
        <lastname>Homes</lastname>
        <age>32</age>
        <email>sherlock@sh.com</email>
    </Employee>
    <Employee emplid="3333" type="user">
        <firstname>Jim</firstname>
        <lastname>Moriarty</lastname>
        <age>52</age>
        <email>jim@sh.com</email>
    </Employee>
    <Employee emplid="4444" type="user">
        <firstname>Mycroft</firstname>
        <lastname>Holmes</lastname>
        <age>41</age>
        <email>mycroft@sh.com</email>
    </Employee>
</Employees>'));
-- 
INSERT INTO EMPLOYEES_XML
     VALUES (2, xmltype ('<Employees>
    <Employee emplid="5555" type="admin">
        <firstname>Will</firstname>
        <lastname>Watson</lastname>
        <age>30</age>
        <email>willwatson@sh.com</email>
    </Employee>
    <Employee emplid="6666" type="admin">
        <firstname>James</firstname>
        <lastname>Baker</lastname>
        <age>39</age>
        <email>jamesbaker@sh.com</email>
    </Employee>
    <Employee emplid="7777" type="user">
        <firstname>Lance</firstname>
        <lastname>Polok</lastname>
        <age>52</age>
        <email>lancep@sh.com</email>
    </Employee>
    <Employee emplid="8888" type="user">
        <firstname>Rubina</firstname>
        <lastname>Shaikh</lastname>
        <age>41</age>
        <email>rubinas@sh.com</email>
    </Employee>
</Employees>'));
-- 
COMMIT;
-- 
-- Getting the number of XML documents. There are 2 employee docs.
-- 
SELECT Count(*)
FROM   employees_xml ex,
       XMLTABLE('for $r in /Employees return $r' passing data) ex;  
-- 
-- Read firstname and lastname of all employees of the first emp doc
-- 
-- the row-generating expression is the XPath /Employees/Employee. The passing 
-- clause defines that the emp.data refers to the XML column data of the table
-- Employees emp. The COLUMNS clause is used to transform XML data into relational
-- data. 
-- Each of the entries in this clause defines a column with a column name 
-- and a SQL data type. In above query we defined two columns firstname and 
-- lastname that points to PATH firstname and lastname or selected XML node.
-- 
SELECT emp.id, x.*
     FROM employees_xml emp,
          XMLTABLE ('/Employees/Employee'
                    PASSING emp.data
                    COLUMNS firstname VARCHAR2(30) PATH 'firstname', 
                            lastname VARCHAR2(30) PATH 'lastname') x
    WHERE emp.id = 1;
-- 
-- 
/*
   ID FIRSTNAME    LASTNAME
_____ ____________ ___________
    1 John         Watson
    1 Sherlock     Homes
    1 Jim          Moriarty
    1 Mycroft      Holmes
*/        
-- 
-- another way to display XML data columns is using text()
-- 
SELECT emp.id, x.*
     FROM employees_xml emp,
          XMLTABLE ('/Employees/Employee/firstname'
                    PASSING emp.data
                    COLUMNS firstname VARCHAR2(30) PATH 'text()') x
    WHERE emp.id = 1;
-- 
-- Read Attribute value of selected node
-- In below query we select attribute type from the employee node.
-- 
SELECT emp.id, x.*
    FROM employees_xml emp,
        XMLTABLE ('/Employees/Employee'
                PASSING emp.data
                COLUMNS firstname VARCHAR2(30) PATH 'firstname',
                        type VARCHAR2(30) PATH '@type') x;
-- 
/*
   ID FIRSTNAME    TYPE
_____ ____________ ________
    1 John         admin
    1 Sherlock     admin
    1 Jim          user
    1 Mycroft      user
    2 Will         admin
    2 James        admin
    2 Lance        user
    2 Rubina       user
*/                            
-- 
-- Read specific employee record using employee id
-- 
SELECT t.id, x.*
     FROM employees_xml t,
          XMLTABLE ('/Employees/Employee[@emplid=2222]'
                    PASSING t.data
                    COLUMNS firstname VARCHAR2(30) PATH 'firstname', 
                            lastname VARCHAR2(30) PATH 'lastname') x
    WHERE t.id = 1;
-- 
/*
   ID FIRSTNAME    LASTNAME
_____ ____________ ___________
    1 Sherlock     Homes
*/
-- 
-- Read firstname lastname of all employees who are older than 40 year
-- 
SELECT t.id, x.*
    FROM employees_xml t,
        XMLTABLE ('/Employees/Employee[age>40]'
                PASSING t.data
                COLUMNS firstname VARCHAR2(30) PATH 'firstname', 
                        lastname VARCHAR2(30) PATH 'lastname',
                        age VARCHAR2(30) PATH 'age') x;
-- 
/*
   ID FIRSTNAME    LASTNAME    AGE
_____ ____________ ___________ ______
    1 Jim          Moriarty    52
    1 Mycroft      Holmes      41
    2 Lance        Polok       52
    2 Rubina       Shaikh      41
*/
-- 