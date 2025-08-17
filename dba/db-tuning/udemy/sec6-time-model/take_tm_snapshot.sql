-- save the current time model basic statistics into the TM_HISTORY table
INSERT INTO TM_HISTORY
SELECT
    S.NEXTVAL                          AS SNAP_ID,
    DBTIME.VALUE/1000000               DBTIME,
    DBCPU.VALUE/1000000                DBCPU,
    (DBTIME.VALUE-DBCPU.VALUE)/1000000 WAIT_TIME,
    (
    SELECT
        COUNT(*)
    FROM
        GV$SESSION
    WHERE
        USERNAME IS NOT NULL
    ) USERS_CNT
    FROM
        GV$SYS_TIME_MODEL DBTIME,
        GV$SYS_TIME_MODEL DBCPU
    WHERE
        DBTIME.STAT_NAME = 'DB time'
        AND DBCPU.STAT_NAME = 'DB CPU';
COMMIT;