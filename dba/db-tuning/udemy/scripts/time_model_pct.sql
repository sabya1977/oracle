COL STAT_NAME FORMAT A43
SELECT
    STAT_NAME,
    TO_CHAR(VALUE,
    '999,999,999,999') TIME_MICRO_SEC,
    ROUND(VALUE/(
    SELECT
        VALUE
    FROM
        GV$SYS_TIME_MODEL
    WHERE
        STAT_NAME='DB time')*100,
        2) PCT
    FROM
        GV$SYS_TIME_MODEL
    WHERE
        VALUE <>0
        AND STAT_NAME NOT IN ('background elapsed time', 'background cpu time')
    ORDER BY
        VALUE DESC FETCH FIRST 7 ROWS ONLY;