SET LINES 200 PAGES 0

EXPLAIN PLAN
   FOR
        SELECT /*+ index(t1 (c1,c2)) */
              MIN (c2)
          FROM t1
         WHERE c1 = 3
      ORDER BY c1 DESC;

SELECT * FROM TABLE (DBMS_XPLAN.display);