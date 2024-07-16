set loadformat csv columns on
truncate table av.geography_dim;
load av.geography_dim /home/sabya/gitrepos/oracle/datasetup//geography_dim.csv
--
truncate table av.product_dim;
load av.product_dim /home/sabya/gitrepos/oracle/datasetup/product_dim.csv
--
truncate table av.time_dim;
load av.time_dim /home/sabya/gitrepos/oracle/datasetup/time_dim.csv
--
truncate table av.sales_fact;
load av.sales_fact /home/sabya/gitrepos/oracle/datasetup/sales_fact.csv
--
