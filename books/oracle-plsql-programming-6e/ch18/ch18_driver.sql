
REM This file calls all of the individual files explicitly listed or 
REM implied in Chapter 18 of Oracle PL/SQL Programming.
. 
REM The files named ch18xxxxxx.sql appear directly in the text 
REM while the others are merely implied in the text.

SET SERVEROUTPUT ON

PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table employee
PROMPT
@@drp_employee.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Table employee
PROMPT
@@tab_employee.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Inserting Row into Table employee
PROMPT
@@ins_employee.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block
PROMPT
@@ch18_01.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package employee_pkg
PROMPT
@@ch18_02.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package errpkg (stub)
PROMPT 
@@errpkg.pkg
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body employee_pkg
PROMPT
@@ch18_04.sql -- Executed in Different Order than Presented in Text
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block
PROMPT
@@ch18_03.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Attempting to Declare a Cursor Variable in the Specification
PROMPT
@@rc_example.pkg
show errors;
PROMPT 
PROMPT ***
PROMPT
PROMPT Attempting to Declare a Cursor Variable in the Body
PROMPT
@@rc_example2.pkg
show errors;
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating a Package with an Optional Package Name After the END Statement
PROMPT
@@ch18_05.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table favorites
PROMPT
@@drp_favorites.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Table favorites
PROMPT
@@tab_favorites.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package favorites_pkg
PROMPT
@@ch18_06.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating a Package Body with an Optional Package Name After the END Statement
PROMPT
@@ch18_07.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body favorites_pkg
PROMPT
@@ch18_08.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body favorites_pkg with an Initialization Section
PROMPT
@@ch18_09.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package employee with a Publicly Accessible max_salary
PROMPT
@@employee_pkg.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package company
PROMPT 
@@company.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body company
PROMPT 
@@ch18_10.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package and Body valerr with Assignment 
PROMPT of Global Variable v in the Declaration Section
PROMPT
@@ch18_11.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing the valerr.get Function (first time)
PROMPT
@@ch18_12.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing the valerr.get Function (second time)
PROMPT
@@ch18_13.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body valerr with Assignment 
PROMPT of Global Variable v in the Initialization Section
PROMPT
@@ch18_14.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table pet
PROMPT
@@drp_pet.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Table pet
PROMPT
@@tab_pet.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package pets_inc
PROMPT
@@ch18_15.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body pets_inc
PROMPT
@@pets_inc.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block that Uses the pets_inc Package
PROMPT
@@ch18_16.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table books
PROMPT
@@drp_books.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Table books
PROMPT
@@tab_books.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package book_info
PROMPT
@@ch18_17.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body book_info
PROMPT
@@ch18_18.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body book_info with Malformed Cursors
PROMPT
@@book_info.sql
show errors;
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating (New Version w/display Procedure)
PROMPT Package and Body book_info 
PROMPT
@@book_info2.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block that References Package book_info
PROMPT
@@ch18_19.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block that Opens book_info.bytitle_cur
PROMPT
@@ch18_20.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Re-executing Anonymous Block that References Package book_info
PROMPT
@@ch18_19.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package personnel
PROMPT
@@ch18_21.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body personnel
PROMPT
@@personnel.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Block that uses personell.open_emps_for_dept
PROMPT
@@ch18_22.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package book_info (Serially Reusable Version) 
PROMPT
@@ch18_23.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body book_info (Serially Reusable Version) 
PROMPT
@@book_info3.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Executing Anonymous Blocks:
PROMPT
PROMPT First Block Opens book_info.byauthor_cur Twice (Without Closing it)
PROMPT in the Same Block and Generates an Error.
PROMPT
PROMPT Second Block Opens book_info.byauthor_cur 
PROMPT (Note that the Cursor Still has Not Been Explicity Closed in this Session) 
PROMPT Because the Package is Serially Reusable it is Able to Re-open the Cursor 
PROMPT Without Generating an Error. 
PROMPT 
PROMPT
@@ch18_24.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package magic_values_pkg 
PROMPT
@@magic_values_pkg.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body magic_values_pkg (with Hard-Coded Literals)
PROMPT
@@ch18_25.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body magic_values_pkg (with Constants)
PROMPT
@@ch18_26.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package config_pkg
PROMPT
@@ch18_27.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package Body magic_value_pkg (with References to config_pkg)
PROMPT
@@ch18_28.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table customer
PROMPT
@@drp_customer.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Table customer
PROMPT
@@tab_customer.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT Creating Package customer_rules
PROMPT
@@ch18_29.sql
PROMPT 
PROMPT ***
PROMPT
PROMPT All Code from Chapter 18 Successfully Executed!
PROMPT 
PROMPT The Results of this Script have been SPOOLED to ch18_results.txt
PROMPT
PROMPT Please Note that all of the Tables and Packages Created by this Script
PROMPT Continue to Exist to Allow the Interested Party an Opportunity 
PROMPT to Examine them at Greater Length.
PROMPT
PROMPT To Clean Up All of the Object Created By This Script, 
PROMPT Please Execute cleanup.sql from SQL*PLUS.
PROMPT
PROMPT



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
