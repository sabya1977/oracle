rem convert-xml-to-relational.sql
rem Author: Sabyasachi Mitra
rem Date: 08/23/2025
rem courtsey: Tim Hall (oracale-base)
rem Description: Convert XML data to relational format
rem
select xt.*
  from practice.xml_ext x,
       xmltable ( '/employees/employee'
             passing xmltype(x.doc1)
          columns
             "employee_number" number(4) path 'employee_number',
             "employee_name" varchar2(10) path 'employee_name',
             "job" varchar2(9) path 'job'
       ) xt
 order by 1;