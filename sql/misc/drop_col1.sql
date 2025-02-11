/*
Demo: Setting columns Unused instead of dropping them.
We can set a column unused and reog the table (MOVE)
later to reclaim the space. This saves lot of time 
consumed by DROP column on a large or very large table
--
Author: Sabyasachi Mitra
Date: 03/30/2024
Tested on: Oracle 21c
*/
--
CREATE TABLE P_TAB AS
SELECT * FROM DBA_PROCEDURES;
--
DESC P_TAB;
--
/*
Name              Null?    Type
_________________ ________ ________________
OWNER                      VARCHAR2(128)
OBJECT_NAME                VARCHAR2(128)
PROCEDURE_NAME             VARCHAR2(128)
OBJECT_ID                  NUMBER
....
*/
--
-- set OBJECT_NAME unused
--
ALTER TABLE P_TAB SET UNUSED COLUMN OBJECT_NAME;
--
SELECT TABLE_NAME, COLUMN_NAME, HIDDEN_COLUMN FROM DBA_TAB_COLS WHERE TABLE_NAME = 'P_TAB';
--
/*
TABLE_NAME    COLUMN_NAME                   HIDDEN_COLUMN
_____________ _____________________________ ________________
P_TAB         INTERFACE                     NO
P_TAB         DETERMINISTIC                 NO
P_TAB         AUTHID                        NO
P_TAB         RESULT_CACHE                  NO
P_TAB         ORIGIN_CON_ID                 NO
P_TAB         POLYMORPHIC                   NO
P_TAB         SQL_MACRO                     NO
P_TAB         BLOCKCHAIN                    NO
P_TAB         BLOCKCHAIN_MANDATORY_VOTES    NO
P_TAB         OWNER                         NO
P_TAB         SYS_C00002_24033016:33:14$    YES -- unused column
*/
--
SELECT COUNT(*) NUM_COL_UNUSED FROM DBA_UNUSED_COL_TABS WHERE TABLE_NAME = 'P_TAB';
--
/*
   NUM_COL_UNUSED
_________________
                1
*/                
--
-- gather stats
--
exec DBMS_STATS.GATHER_TABLE_STATS ('', 'P_TAB');
--
-- number of blocks used by the table
--
SELECT BLOCKS, EMPTY_BLOCKS
FROM DBA_TABLES
WHERE TABLE_NAME = 'P_TAB';
--
/*
   BLOCKS    EMPTY_BLOCKS
_________ _______________
      452               0
*/      
--
-- add the column back to the table
--
ALTER TABLE P_TAB ADD OBJECT_NAME VARCHAR2(128);
--
--
-- OBJECT_NAME is added but the unused columns remains present
--
SELECT TABLE_NAME, COLUMN_NAME, HIDDEN_COLUMN FROM DBA_TAB_COLS WHERE TABLE_NAME = 'P_TAB';
/*
TABLE_NAME    COLUMN_NAME                   HIDDEN_COLUMN
_____________ _____________________________ ________________
P_TAB         INTERFACE                     NO
P_TAB         DETERMINISTIC                 NO
P_TAB         AUTHID                        NO
P_TAB         RESULT_CACHE                  NO
P_TAB         ORIGIN_CON_ID                 NO
P_TAB         POLYMORPHIC                   NO
P_TAB         SQL_MACRO                     NO
P_TAB         BLOCKCHAIN                    NO
P_TAB         BLOCKCHAIN_MANDATORY_VOTES    NO
P_TAB         OBJECT_NAME                   NO -- new column added
P_TAB         OWNER                         NO
P_TAB         SYS_C00002_24033016:33:14$    YES -- old unused column
*/
--
-- now reorg the table to reclaim ths space by unused column and gather stats again
--
ALTER TABLE P_TAB MOVE;
exec DBMS_STATS.GATHER_TABLE_STATS ('', 'P_TAB');
--
-- number of blocks used by the table has reduced now.
--
SELECT BLOCKS, EMPTY_BLOCKS
FROM DBA_TABLES
WHERE TABLE_NAME = 'P_TAB';
--
/*
 BLOCKS    EMPTY_BLOCKS
_________ _______________
      398               0
*/      
-- 
-- but the unused column remains in the Oracle data dictionary, though the space is reclaimed.
--
SELECT COUNT(*) NUM_COL_UNUSED FROM DBA_UNUSED_COL_TABS WHERE TABLE_NAME = 'P_TAB';
--
/*
  NUM_COL_UNUSED
_________________
                1
*/                
--
DROP TABLE P_TAB;
--