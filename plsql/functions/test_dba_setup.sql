create role DEVELOPER NOT IDENTIFIED;
grant READ ANY TABLE to developer;
grant CREATE SESSION to developer;
grant SELECT_CATALOG_ROLE to developer;
grant resource to developer;
grant CREATE JOB to developer;
grant GRANT ANY OBJECT PRIVILEGE to developer;
grant DROP ANY MATERIALIZED VIEW to developer;
grant CREATE MATERIALIZED VIEW to developer;
grant DROP ANY PROCEDURE to developer;
grant ALTER ANY TABLE to developer;
grant ON COMMIT REFRESH to developer;
grant ALTER ANY TYPE to developer;
grant ALTER ANY MATERIALIZED VIEW to developer;
grant EXECUTE ANY PROCEDURE to developer;
grant ALTER SESSION to developer;
grant ANALYZE ANY to developer;
grant ALTER ANY PROCEDURE to developer;
grant CREATE ANY SEQUENCE to developer;
grant CREATE VIEW to developer;
grant QUERY REWRITE to developer;
grant ALTER ANY TRIGGER to developer;
grant ALTER ANY SEQUENCE to developer;
grant DROP ANY INDEX to developer;
grant ALTER ANY INDEX to developer;
grant READ ANY TABLE to developer;
grant DROP ANY TRIGGER to developer;
grant DROP ANY SEQUENCE to developer;
grant DELETE ANY TABLE to developer;
grant UPDATE ANY TABLE to developer;
grant INSERT ANY TABLE to developer;
grant DROP ANY TABLE to developer;
grant CREATE ANY TABLE to developer;
grant DROP ANY TYPE to developer;
grant CREATE ANY PROCEDURE to developer;
grant SELECT ANY SEQUENCE to developer;
grant CREATE ANY TYPE to developer;
grant CREATE ANY TRIGGER to developer;
grant CREATE ANY INDEX to developer;
grant SELECT ANY TABLE to developer;
grant CREATE SESSION to developer;
grant CREATE ANY CONTEXT to developer;
grant CREATE ANY MATERIALIZED VIEW to developer;
grant alter any materialized view to developer;
grant drop any materialized view to developer;
grant DROP ANY VIEW to developer;
grant CREATE ANY VIEW to developer;
grant FLASHBACK ANY TABLE to developer;
grant SELECT_CATALOG_ROLE to developer;
grant alter session to developer;
grant select any transaction to developer;
grant alter user to developer;
--
create user tkyte identified by oracle default tablespace USERS TEMPORARY tablespace TEMP quota unlimited on USERS;
grant developer to tkyte;
grant dba to tkyte;
--
create user test identified by oracle default tablespace USERS temporary tablespace TEMP quota unlimited on USERS;
--
create role application;
grant read any table to application;
grant SELECT_CATALOG_ROLE to application;
--
grant create session to test;
--
grant application to test;
--
create user oltp identified by oracle default tablespace USERS temporary tablespace TEMP quota unlimited on USERS;
--




