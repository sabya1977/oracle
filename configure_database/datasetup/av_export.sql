set sqlformat csv
spool '/home/sabya/gitrepos/oracle/datasetup/sales_fact.csv';
select * from av.sales_fact;
spool off
--
spool '/home/sabya/gitrepos/oracle/datasetup/product_dim.csv';
select * from av.product_dim;
spool off
--
set sqlformat ansiconsole

