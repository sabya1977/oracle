create role DEVELOPER NOT IDENTIFIED;
--
grant READ ANY TABLE to developer;
--
grant CREATE SESSION to developer;
--
grant SELECT_CATALOG_ROLE to developer;
--
grant resource to developer;
-- 
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
grant DROP ANY VIEW to developer;
grant CREATE ANY VIEW to developer;
GRANT ADVISOR TO developer;
GRANT ADMINISTER ANY SQL TUNING SET TO developer;
GRANT ADMINISTER SQL TUNING SET TO developer;
GRANT ADMINISTER SQL MANAGEMENT OBJECT to developer;
GRANT CREATE MATERIALIZED VIEW TO developer;
GRANT EXECUTE ON DBMS_ADVANCED_REWRITE TO developer;
GRANT EXECUTE ON SYS.DBMS_LOCK TO developer;
GRANT SELECT ON SYS.V_$PARAMETER TO developer;
GRANT MANAGE SCHEDULER TO developer;
GRANT ALTER SESSION TO developer;
GRANT ALTER SYSTEM TO developer;
GRANT ANALYZE ANY TO developer;
GRANT ANALYZE ANY DICTIONARY to developer;
GRANT CREATE ANY JOB TO developer;
--
create user oradev23 identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
--
alter user oradev23 quota unlimited on users;
-- 
grant execute on dbms_stats      to oradev23;
grant select  on sys.V_$STATNAME to oradev23;
grant select  on sys.V_$MYSTAT   to oradev23;
grant select  on sys.V_$LATCH    to oradev23;
grant select  on sys.V_$TIMER    to oradev23;
GRANT SELECT ON V_$PARAMETER to oradev23;
GRANT SELECT ON V_$SESSION TO oradev23;
GRANT SELECT ON V_$SQL_PLAN_STATISTICS_ALL TO oradev23;
GRANT SELECT ON V_$SQL TO oradev23;
GRANT SELECT ON V_$SQL_PLAN TO oradev23;
GRANT SELECT ON V_$SQL_SHARED_CURSOR TO oradev23;
GRANT SELECT ON V_$SQL TO oradev23;
GRANT SELECT ON V_$PROCESS TO oradev23;
GRANT SELECT ON V_$MYSTAT TO oradev23;
GRANT SELECT ON V_$SQL TO oradev23;
GRANT SELECT ON V_$SQL_BIND_CAPTURE TO oradev23;
GRANT SELECT ON V_$SQLAREA TO oradev23;
GRANT SELECT ON V_$SQLAREA_PLAN_HASH TO oradev23;
GRANT SELECT ON V_$SQLSTATS TO oradev23;
GRANT SELECT ON V_$RESULT_CACHE_OBJECTS TO oradev23;
GRANT SELECT ON SYS.COL_USAGE$ TO oradev23;
-- 
BEGIN
SYS.DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SYSTEM_PRIVILEGE
  (GRANTEE_NAME   => 'ORADEV23', 
   PRIVILEGE_NAME => 'ADMINISTER_RESOURCE_MANAGER',
   ADMIN_OPTION   => FALSE);
END;
/
--
grant developer to oradev23;
--
create user oradba23 identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
--
alter user oradba23 quota unlimited on users;
--
grant dba to oradba23;
-- 
grant exp_full_database to oradba23;
-- 
grant imp_full_database to oradba23;
