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
GRANT SELECT ON SYS.GV_$PARAMETER TO developer;
GRANT MANAGE SCHEDULER TO developer;
GRANT ALTER SESSION TO developer;
GRANT ALTER SYSTEM TO developer;
GRANT ANALYZE ANY TO developer;
GRANT ANALYZE ANY DICTIONARY to developer;
GRANT CREATE ANY JOB TO developer;
--
create user oradev21 identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
--
alter user oradev21 quota unlimited on users;
-- 
grant execute on dbms_stats      to oradev21;
grant select  on sys.GV_$STATNAME to oradev21;
grant select  on sys.GV_$MYSTAT   to oradev21;
grant select  on sys.GV_$LATCH    to oradev21;
grant select  on sys.GV_$TIMER    to oradev21;
GRANT SELECT ON GV_$PARAMETER to oradev21;
GRANT SELECT ON GV_$SESSION TO oradev21;
GRANT SELECT ON GV_$SQL_PLAN_STATISTICS_ALL TO oradev21;
GRANT SELECT ON GV_$SQL TO oradev21;
GRANT SELECT ON GV_$SQL_PLAN TO oradev21;
GRANT SELECT ON GV_$SQL_SHARED_CURSOR TO oradev21;
GRANT SELECT ON GV_$SQL TO oradev21;
GRANT SELECT ON GV_$PROCESS TO oradev21;
GRANT SELECT ON GV_$MYSTAT TO oradev21;
GRANT SELECT ON GV_$SQL TO oradev21;
GRANT SELECT ON GV_$SQL_BIND_CAPTURE TO oradev21;
GRANT SELECT ON GV_$SQLAREA TO oradev21;
GRANT SELECT ON GV_$SQLAREA_PLAN_HASH TO oradev21;
GRANT SELECT ON GV_$SQLSTATS TO oradev21;
GRANT SELECT ON GV_$RESULT_CACHE_OBJECTS TO oradev21;
GRANT SELECT ON SYS.COL_USAGE$ TO oradev21;
-- 
BEGIN
SYS.DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SYSTEM_PRIVILEGE
  (GRANTEE_NAME   => 'ORADEV21', 
   PRIVILEGE_NAME => 'ADMINISTER_RESOURCE_MANAGER',
   ADMIN_OPTION   => FALSE);
END;
/
--
grant developer to oradev21;
--
create user oradba21 identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
--
alter user oradba21 quota unlimited on users;
--
grant dba to oradba21;
-- 
grant exp_full_database to oradba21;
-- 
grant imp_full_database to oradba21;
