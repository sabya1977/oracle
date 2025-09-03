select *
  from hr.employees;
--
rem using XMLELEMENT
rem
select xmlelement(
   "first name",
   e.first_name
) as employee
  from hr.employees e;
--
select xmlelement(
   "employees",
   xmlelement(
      "first name",
      e.first_name
   ),
   xmlelement(
      "last name",
      e.last_name
   ),
   xmlelement(
      "phone number",
      e.phone_number
   )
) as employees
  from hr.employees e;
rem
rem using XMLATTRIBUTES
rem
select xmlelement(
   "employee",
   xmlattributes(
      e.first_name as "first name",
      e.last_name as "last name",
      e.phone_number as "phone number"
   )
) as employees
  from hr.employees e;
rem
rem The parent XMLELEMENT can contain both attributes and child tags.
rem  
select xmlelement(
   "employee",
   xmlattributes(
      e.first_name as "first name",
      e.last_name as "last name",
      e.phone_number as "phone number"
   ),
   xmlelement(
      "email",
      e.email
   ),
   xmlelement(
      "hire date",
      e.hire_date
   ),
   xmlelement(
      "Department",
      e.department_id
   )
) as employees
  from hr.employees e;
--
rem using XMLFOREST
rem XMLFOREST creates an XML document from a set of columns.
rem
select xmlelement(
   "employees",
   xmlforest(e.employee_id as "employee id",
   e.first_name as "first name",
   e.last_name as "last name",
   e.phone_number as "phone number",
   e.hire_date as "hire date",
   e.department_id as "Department")
) as employees
  from hr.employees e;
rem
rem XMLAGG XMLAGG function allows is to aggregate these separate fragments into a single fragment.
rem
select xmlelement(
   "employees",
   xmlagg(xmlelement(
      "employee",
          xmlforest(e.employee_id as "employee id",
          e.first_name as "first name",
          e.last_name as "last name",
          e.phone_number as "phone number",
          e.hire_date as "hire date",
          e.department_id as "Department")
   ))
) as employees
  from hr.employees e;
rem 
rem XMLROOT function allows us to place an XML declaration tag at the start of our XML document.
rem
select xmlserialize(document xmlelement(
   "employees",
   xmlagg(xmlelement(
      "employee",
          xmlforest(e.employee_id as "employee id",
          e.first_name as "first name",
          e.last_name as "last name",
          e.phone_number as "phone number",
          e.hire_date as "hire date",
          e.department_id as "Department")
   ))
) version '1.0 ?>' indent size = 2) as employees
  from hr.employees e;
--



select xmlroot(xmltype('<employees>all</employees>'),
version '1.0') as "XMLROOT"
  from dual;
rem 
rem XMLSERIALIZE function examples - converts XMLType to formatted string
rem Basic XMLSERIALIZE usage
rem
select xmlserialize(content xmlelement(
   "employees",
   xmlagg(xmlelement(
      "employee",
          xmlforest(e.employee_id as "employee_id",
          e.first_name as "first_name",
          e.last_name as "last_name",
          e.phone_number as "phone_number",
          e.hire_date as "hire_date",
          e.department_id as "department_id")
   ))
) as clob indent) as formatted_employees
  from hr.employees e;
--
rem XMLSERIALIZE with VERSION and ENCODING
rem
select xmlserialize(document xmlelement(
   "employees",
   xmlagg(xmlelement(
      "employee",
          xmlforest(e.employee_id as "employee_id",
          e.first_name as "first_name",
          e.last_name as "last_name")
   ))
) as clob version '1.0' indent size = 1) as xml_document
  from hr.employees e;
--
rem XMLSERIALIZE without indentation
rem
select xmlserialize(content xmlelement(
   "employee_list",
   xmlagg(xmlelement(
      "emp",
          xmlattributes(
         e.employee_id as "id"
      ),
      e.first_name
   ))
) as clob no indent) as compact_xml
  from hr.employees e;
--