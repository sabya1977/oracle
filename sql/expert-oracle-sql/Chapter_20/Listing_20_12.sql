CREATE GLOBAL TEMPORARY TABLE payments_temp
AS
   SELECT *
     FROM payments
    WHERE 1 = 0;

EXPLAIN PLAN
   FOR
MERGE /*+ cardinality(t 3) */
     INTO  payments p
     USING payments_temp t
        ON (p.payment_id = t.payment_id)
WHEN MATCHED
THEN
   UPDATE SET p.employee_id = t.employee_id
             ,p.special_flag = t.special_flag
             ,p.paygrade = t.paygrade
             ,p.payment_date = t.payment_date
             ,p.job_description = t.job_description
WHEN NOT MATCHED
THEN
   INSERT     (payment_id
              ,special_flag
              ,paygrade
              ,payment_date
              ,job_description)
       VALUES (t.payment_id
              ,t.special_flag
              ,t.paygrade
              ,t.payment_date
              ,t.job_description);

SELECT * FROM TABLE (DBMS_XPLAN.display);

EXPLAIN PLAN
   FOR
MERGE /*+ cardinality(t 10000) */
     INTO  payments p
     USING payments_temp t
        ON (p.payment_id = t.payment_id)
WHEN MATCHED
THEN
   UPDATE SET p.employee_id = t.employee_id
             ,p.special_flag = t.special_flag
             ,p.paygrade = t.paygrade
             ,p.payment_date = t.payment_date
             ,p.job_description = t.job_description
WHEN NOT MATCHED
THEN
   INSERT     (payment_id
              ,special_flag
              ,paygrade
              ,payment_date
              ,job_description)
       VALUES (t.payment_id
              ,t.special_flag
              ,t.paygrade
              ,t.payment_date
              ,t.job_description);

SELECT * FROM TABLE (DBMS_XPLAN.display);