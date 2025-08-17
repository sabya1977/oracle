-- phoenix_ddl_create.sql
-- Author: Sabyasachi Mitra
-- Date: 07/10/2025
-- Description: This script drops the tables and 
-- structures for the Phoenix database.
--
alter session set current_schema = phoenix;
--
drop table if exists calendar cascade constraint;
drop table if exists project_financials cascade constraint;
drop table if exists project_staffing cascade constraint;
drop table if exists project_definition cascade constraint;
drop table if exists projects cascade constraint;
drop table if exists employee_work_loc_site cascade constraint;
drop table if exists employee_addr_loc cascade constraint;
drop table if exists employee_promotions cascade constraint;
drop table if exists employee_performance cascade constraint;
drop table if exists employee_paycheck cascade constraint;
drop table if exists employees_pay_definition cascade constraint;
drop table if exists employee_fin_def cascade constraint;
drop table if exists employee_master cascade constraint;
drop table if exists bank_master cascade constraint;
drop table if exists designations cascade constraint;
drop table if exists salary_ranges cascade constraint;
drop table if exists employee_types cascade constraint;
drop table if exists employee_status cascade constraint;
drop table if exists sub_units cascade constraint;
drop table if exists units cascade constraint;
drop table if exists currency_master cascade constraint;
drop table if exists cities cascade constraint;
drop table if exists state_city_zip cascade constraint;
drop table if exists countries cascade constraint;
drop table if exists regions cascade constraint;