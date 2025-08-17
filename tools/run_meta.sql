SET SERVEROUTPUT ON
SET LONG 100000
SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SPOOL cars_gen_ddl.sql
DECLARE
  lv_owner VARCHAR2(30) := 'CARS'; -- Set the owner variable to 'CARS'
BEGIN
  -- Declare and set owner variable
 
  -- Disable unnecessary options like storage, tablespace etc.
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SEGMENT_ATTRIBUTES', FALSE);
  DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);

  FOR t IN (
    SELECT table_name 
    FROM dba_tables 
    WHERE owner = lv_owner 
  ) LOOP
    -- Table DDL
    DBMS_OUTPUT.PUT_LINE('-- Table DDL: ' || t.table_name);
    DBMS_OUTPUT.PUT_LINE(DBMS_METADATA.GET_DDL('TABLE', t.table_name,lv_owner));

    -- Index DDLs
    FOR idx IN (
      SELECT index_name FROM dba_indexes WHERE table_name = t.table_name and owner = lv_owner
    ) LOOP
      DBMS_OUTPUT.PUT_LINE('-- Index DDL: ' || idx.index_name);
      DBMS_OUTPUT.PUT_LINE(DBMS_METADATA.GET_DDL('INDEX', idx.index_name,lv_owner));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
  END LOOP;
END;
/
SPOOL OFF