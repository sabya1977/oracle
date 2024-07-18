REM This Script will Cleanup All of the Obejcts Created by 
REM start.sql and ch18_driver.sql

SPOOL cleanup_results.txt

PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table books
PROMPT
DROP TABLE books;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table customer
PROMPT
DROP TABLE customer;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table employee
PROMPT
DROP TABLE employee;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table favorites
PROMPT
DROP TABLE favorites;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Table pet
PROMPT
DROP TABLE pet;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package book_info
PROMPT
DROP PACKAGE book_info;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package company
PROMPT
DROP PACKAGE company;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package config_pkg
PROMPT
DROP PACKAGE config_pkg;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package customer_rules
PROMPT
DROP PACKAGE customer_rules;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package employee_pkg
PROMPT
DROP PACKAGE employee_pkg;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package errpkg
PROMPT
DROP PACKAGE errpkg;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package favorites_pkg
PROMPT
DROP PACKAGE favorites_pkg;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package magic_values_pkg
PROMPT
DROP PACKAGE magic_values_pkg;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package my_PACKAGE
PROMPT
DROP PACKAGE my_PACKAGE;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package personnel
PROMPT
DROP PACKAGE personnel;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package pets_inc
PROMPT
DROP PACKAGE pets_inc;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package rc_example
PROMPT
DROP PACKAGE rc_example;
PROMPT 
PROMPT ***
PROMPT
PROMPT Dropping Package valerr
PROMPT
DROP PACKAGE valerr;
PROMPT 
PROMPT ***
PROMPT
PROMPT Objects Created for Chapter 18 Successfully Cleaned Up!
PROMPT
PROMPT Results of this Script have been SPOOLED to cleanup_results.txt
PROMPT
PROMPT

SPOOL OFF



/*======================================================================
| Supplement to the third edition of Oracle PL/SQL Programming by Steven
| Feuerstein with Bill Pribyl, Copyright (c) 1997-2002 O'Reilly &
| Associates, Inc. To submit corrections or find more code samples visit
| http://www.oreilly.com/catalog/oraclep3/
*/
