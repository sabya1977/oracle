rem
rem Copyright (c) 2023 Sabyasachi Mitra
rem Freely available for Oracle Database 19c onwards
rem Function: create custom developer role and create a dba and dev user
rem
   SET ECHO OFF
SET VERIFY OFF
SET HEADING OFF
SET FEEDBACK OFF
WHENEVER SQLERROR EXIT SQL.SQLCODE
--
-- creating a schema only account
--
drop user if exists practice cascade;
create user practice no authentication
   default tablespace users
   temporary tablespace temp
   quota unlimited on users
   profile default
   account unlock;
--
grant
   create session,
   create table,
   create sequence,
   create view
to practice;
--
alter user practice grant connect through oradba23;
--
select *
  from dba_users
 where username = 'PRACTICE';
--
select username,
       account_status,
       authentication_type
  from dba_users
 where username = 'PRACTICE';