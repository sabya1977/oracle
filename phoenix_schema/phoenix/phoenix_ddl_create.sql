-- phoenix_ddl_create.sql
-- Author: Sabyasachi Mitra
-- Date: 07/10/2025
-- Description: This script creates the necessary 
-- tables and structures for the Phoenix database.
-- Naming Conventions:
-- 1. All table names are should be prefixed with 'phnx_' followed by table 
-- short name and long name.
--    Example: phnx_rgn_regions for regions table.
-- 2. All primary keys are suffixed with '_pk' and prefixed with the table name and column name.
-- 3. All foreign keys are suffixed with '_fk' and prefixed with full parent table name 
-- and last qualifier of the child table and common column name.
-- 4. All check constraints are suffixed with '_chk' and prefixed with the table name and column name.
-- 5. All unique constraints are suffixed with '_unq' and prefixed with the table name and column name.
-- 6. All identity columns are suffixed with '_ck'.
-- 7. All date columns are suffixed with '_dt'.
-- 8. All varchar2 columns are suffixed with '_name' or '_id' based on their usage.
-- 9. All number columns are suffixed with '_num' or '_amount' based on their usage.
-- 10 All indexes must start with phnx_business_ and end with _idx.
--
--
drop user phoenix cascade;
create user phoenix identified by phoenix
   default tablespace users
   temporary tablespace temp
   profile default
   account unlock;
--
alter user phoenix
   quota unlimited on users;
--
alter session set current_schema = phoenix;
--
--
drop table if exists phnx_region_regions cascade constraint;
--
create table phnx_region_regions (
   region_id   varchar2(4),
   region_name varchar2(50),
   constraint phnx_region_regions_pk primary key ( region_id )
);
--
insert into phnx_region_regions ( region_id, region_name )
values ( 'NA', 'North America' );
insert into phnx_region_regions ( region_id, region_name )
values ( 'APAC', 'Asia Pacific' );
insert into phnx_region_regions ( region_id, region_name )
values ( 'EU', 'Europe' );
--
commit;
--
drop table if exists phnx_region_countries cascade constraint;
--
create table phnx_region_countries (
   country_id varchar2(2),
   country_name varchar2(20),
   region_id varchar2(4),
   region_name varchar2(50),
   constraint phnx_region_countries_pk primary key ( region_id, country_id ),
   constraint phnx_region_countries_fk foreign key ( region_id )
      references phnx_region_regions ( region_id)
);
--
insert into phnx_region_countries ( country_id, country_name, region_id, region_name )
values ( 'US', 'United States', 'NA', 'North America' );
insert into phnx_region_countries ( country_id, country_name, region_id, region_name )
values ( 'IN', 'India', 'APAC', 'Asia Pacific' );
insert into phnx_region_countries ( country_id, country_name, region_id, region_name )
values ( 'GB', 'United Kingdom', 'EU', 'Europe' );
--
commit;
--
--
drop table if exists phnx_region_country_states cascade constraint;
--
create table phnx_region_country_states (
   state_id     varchar2(4),
   state_name   varchar2(50),
   country_id varchar2(2),
   country_name varchar2(20),
   region_id    varchar2 ( 4 ),
   constraint phnx_region_country_states_pk primary key (country_id, state_id),
   constraint phnx_region_country_states_country_fk foreign key ( region_id, country_id )
      references phnx_region_countries ( region_id, country_id )
);
--
insert into phnx_region_country_states ( state_id, state_name, country_id, country_name, region_id )
select abbr as state_id,
       name as state_name,
       'US' as country_id,
       'United States' as country_name,
       'NA' as region_id
  from all_us_states
union all
select 'WB' as state_id,
       'West Bengal' as state_name,
       'IN' as country_id,
       'India' as country_name,
       'APAC' as region_id
union all
select 'KA' as state_id,
       'Karnataka' as state_name,
       'IN' as country_id,
       'India' as country_name,
       'APAC' as region_id
union all
select 'TN' as state_id,
       'Tamil Nadu' as state_name,
       'IN' as country_id,
       'India' as country_name,
       'APAC' as region_id
union all
select 'KL' as state_id,
       'Kerala' as state_name,
       'IN' as country_id,
       'India' as country_name,
       'APAC' as region_id;
--
commit;       
--
drop table if exists phnx_cntry_state_city_zip_codes cascade constraint;
--
create table phnx_cntry_state_city_zip_codes (
   zip_code   varchar2(10),
   country_id varchar2(2),
   state_id   varchar2(4),
   state_name varchar2(50),
   city_name  varchar2(50),   
   constraint phnx_cntry_state_city_zip_codes_pk
      primary key ( zip_code ),
   constraint phnx_cntry_state_city_zip_codes_state_fk foreign key ( country_id, state_id )
                       references phnx_region_country_states ( country_id, state_id )
);
--
insert into phnx_cntry_state_city_zip_codes ( zip_code, country_id, state_id, state_name, city_name )
with zip as (
   select country_id,
          region_id,
          zip.state,
          zip.city,
          zip.code
     from phoenix.all_us_zip_codes zip
)
select zip.code,
       zip.country_id,
       zip.state,
       state.state_name,
       zip.city
  from zip
 inner join phoenix.phnx_region_country_states state
on zip.state = state.state_id
   and state.country_id = zip.country_id
   and state.region_id = zip.region_id;
--
commit;
--
drop table if exists phnx_country_currencies cascade constraint;
--
create table phnx_country_currencies (
   currency_ck     number(10) not null,
   country_name  varchar2(20),
   currency_id     varchar2(3),
   currency_name   varchar2(50),
   region_id varchar2(4),
   country_id varchar2(2),
   currency_symbol varchar2(5),
   constraint phnx_country_currencies_currency_ck_pk primary key ( currency_ck ),
   constraint phnx_country_currencies_country_fk foreign key ( region_id, country_id )
      references phnx_region_countries ( region_id, country_id ),
   constraint phnx_country_currencies_id_name_sym_chk check 
      (
      (country_id = 'US' AND country_name = 'UNITED STATES' AND currency_id = 'USD' AND currency_name = 'US Dollar' AND currency_symbol = '$') OR
      (country_id = 'IN' AND country_name = 'INDIA' AND currency_id = 'INR' AND currency_name = 'Indian Rupee' AND currency_symbol = '₹') OR
      (country_id = 'GB' AND country_name = 'UNITED KINGDOM' AND currency_id = 'GBP' AND currency_name = 'British Pound' AND currency_symbol = '£') 
      )
);
--
insert into phnx_country_currencies ( currency_ck, country_name, currency_id, currency_name, region_id, country_id, currency_symbol )
values ( 1, 'UNITED STATES', 'USD', 'US Dollar', 'NA', 'US', '$' );
insert into phnx_country_currencies ( currency_ck, country_name, currency_id, currency_name, region_id, country_id, currency_symbol )
values ( 2, 'INDIA', 'INR', 'Indian Rupee', 'APAC', 'IN', '₹' );
commit;
--
drop table if exists phnx_bu_business_units cascade constraint;
--
create table phnx_bu_business_units (
   bu_unit_ck      number(10) not null,
   bu_unit_name    varchar2(100),
   bu_unit_id      varchar2(10),
   bu_unit_head_ck number(10),
   constraint phnx_bu_business_units_pk primary key ( bu_unit_ck ),
   constraint phnx_bu_business_units_bu_unit_name_chk
      check ( bu_unit_name in ( 'Core Business Groups',
                             'Core Technologies and Solutions',
                             'Software and Platform Engineering',
                             'Enableement Services',
                             'Consulting Solutions and Services',
                             'Global Sales and Marketing',
                             'Human Resources',
                             'Finance',
                             'IT and Security Support',
                             'Corporate' ) ),
   constraint phnx_bu_business_units_bu_unit_id_chk
      check ( bu_unit_id in ( 'CBG',
                           'CTS',
                           'SPE',
                           'CSS',
                           'GSM',
                           'HR',
                           'FIN',
                           'ITSS',
                           'CS',
                           'CORP' ) )
);
--
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 1, 'Core Business Groups', 'CBG', 1001 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 2, 'Core Technologies and Solutions', 'CTS', 1002 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 3, 'Software and Platform Engineering', 'SPE', 1003 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 4, 'Enablement Services', 'CSS', 1004 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 5, 'Consulting Solutions and Services', 'CSS', 1005 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 6, 'Human Resources', 'HR', 1006 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 7, 'Finance', 'FIN', 1007 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 8, 'IT and Security Support', 'ITSS', 1008 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 9, 'Corporate', 'CORP', 1009 );
insert into phnx_bu_business_units ( bu_unit_ck, bu_unit_name, bu_unit_id, bu_unit_head_ck )
values ( 10, 'Global Sales and Marketing', 'GSM', 1010 );
commit;
--
drop table if exists phnx_bu_business_sub_units cascade constraint;
--
create table phnx_bu_business_sub_units (
   bu_sub_unit_ck      number(10) not null,
   bu_sub_unit_name    varchar2(100),
   bu_sub_unit_id      varchar2(10),
   bu_unit_ck          number(10),
   bu_sub_unit_head_ck number(10),
   constraint phnx_bu_business_sub_units_pk primary key ( bu_sub_unit_ck ),
   constraint phnx_bu_business_sub_units_bu_unit_ck_fk foreign key ( bu_unit_ck )
      references phnx_bu_business_units ( bu_unit_ck ),
   constraint phnx_bu_business_sub_units_bu_sub_unit_name_chk
      check ( bu_sub_unit_name in ( 'Healthcare and Life Sciences',
                                 'Banking and Financial Services',
                                 'Manufacturing and Logistics',
                                 'Retail and Consumer Goods',
                                 'Communications, Media and Technology',
                                 'Government Services',
                                 'Energy and Utilities',
                                 'Telecom',
                                 'Insurance',
                                 'Artificial Intelligence and Analytics',
                                 'Cloud, Infrastructure and Security',
                                 'Internet of Things',
                                 'Microsoft Business Group',
                                 'AWS Business Group',
                                 'Google Business Group',
                                 'Oracle Business Group',
                                 'ERP and CRM Solutions',
                                 'Industry Solutions Group',
                                 'Application Development and Management',
                                 'Digital Engineering',
                                 'Quality Engineering and Assurance',
                                 'Project and Program Management',
                                 'Delivery Audit',
                                 'Business Consulting Group',
                                 'Technology Consulting Group',
                                 'Global Business Development',
                                 'Global Marketing',
                                 'Payroll and Benefits Group',
                                 'Talent Acquisition Group',
                                 'Grievances and Compliance',
                                 'Workforce Management',
                                 'Employee Wellness',
                                 'Global Mobility Group',
                                 'Project Finance Group',
                                 'Infrastructure Service',
                                 'Business Operations Group',
                                 'Transport Services',
                                 'Digital Asset Management',
                                 'Digital Access and Security'
 ) ),
   constraint phnx_bu_business_sub_units_bu_sub_unit_id_chk
      check ( bu_sub_unit_id in ( 'HLS',
                               'BFS',
                               'MANLOG',
                               'RCG',
                               'CMT',
                               'GS',
                               'EU',
                               'TELCOM',
                               'INS',
                               'AIA',
                               'CIS',
                               'IOT',
                               'MBG',
                               'ABG',
                               'GBG',
                               'OBG',
                               'ERPCS',
                               'ISG',
                               'ADM',
                               'DE',
                               'QEA',
                               'PPM',
                               'DA',
                               'BCG',
                               'TCG',
                               'GBD',
                               'GMKT',
                               'PBG',
                               'TAG',
                               'GAC',
                               'WFM',
                               'EW',
                               'DAM',
                               'DAS',
                               'GMG',
                               'PFG',
                               'IS',
                               'BOG',
                               'TS'

 ) )
);
--
drop table if exists phnx_empst_employee_status cascade constraint;
--
create table phnx_empst_employee_status (
   employee_ck number(10) not null,
   status_eff_dt      date not null,
   status_end_dt      date,
   employee_status    varchar2(50),
   constraint phnx_empst_employee_status_employee_ck_pk primary key ( employee_ck, status_eff_dt ),
   constraint phnx_empst_employee_status_employee_status_chk
      check ( employee_status in ( 'Active',
                                   'Inactive',
                                   'Maternity Leave',
                                   'Paternity Leave',
                                   'Long Medical Leave',
                                   'Study Leave',
                                   'Terminated',
                                   'Sabatical',
                                   'Retired' ) )
);
--
drop table if exists phnx_emptyp_employee_type cascade constraint;
--
create table phnx_emptyp_employee_type (
   employee_ck   number(10) not null,
   type_eff_dt        date not null,
   type_term_dt      date,
   employee_type_id   varchar2(2),
   employee_type_desc varchar2(20),
   constraint phnx_emptyp_employee_type_employee_ck_pk primary key ( employee_ck, type_eff_dt ),
   constraint  phnx_emptyp_employee_type_employee_type_desc_chk
      check ( employee_type_desc in ( 'Full Time',
                                      'Part Time',
                                      'Contractor',
                                      'Intern',
                                      'Probation' ) ),
   constraint phnx_emptyp_employee_type_employee_type_id_chk
      check ( employee_type_id in ( 'FT',
                                    'PT',
                                    'CT',
                                    'IN',
                                    'PR' ) )
);
--
drop table if exists phnx_desg_employee_designations cascade constraint;
--
create table phnx_desg_employee_designations (
   desig_ck   number(10) not null,
   desig_desc varchar2(100),
   desig_id   varchar2(10),
   min_yrs_exp number (10),
   max_yrs_exp number (10),
   min_salary number(10,2),
   max_salary number(10,2),
   currency_ck number(10),
   constraint phnx_desg_employee_designations_desig_pk primary key ( desig_ck ),
   constraint phnx_desg_employee_designations_currency_ck_fk foreign key (currency_ck)
   references phnx_country_currencies (currency_ck),
   constraint phnx_desg_employee_designations_desig_id_chk
      check ( desig_id in ( 'SDE-I',
                            'SDE-II',
                            'SDM',
                            'EM',
                            'TD',
                            'STD',
                            'OE',
                            'SOE',
                            'HRE',
                            'SHRE',
                            'FE',
                            'SFE',
                            'ISE-I',
                            'ISE-II',
                            'MGR',
                            'SMGR',
                            'D',
                            'VP',
                            'SVP',
                            'EVP',
                            'CEO',
                            'COO',
                            'CFO',
                            'CTO',
                            'CMO',
                            'CPO' ) ),
   constraint phnx_desg_employee_designations_desig_desc_chk
      check (     desig_desc in
                              (
                              'Software Development Engineer-I',
                              'Software Development Engineer-II',
                              'Software Development Manager',
                              'Engineering Manager',
                              'Technical Director',
                              'Senior Technical Director',
                              'Operations Executive',
                              'Senior Operations Executive',
                              'Human Resources Executive',
                              'Senior Human Resources Executive',
                              'Financial Executive',
                              'Senior Financial Executive',
                              'Information and Security Engineer-I',
                              'Information and Security Engineer-II',
                              'Manager',
                              'Senior Manager',
                              'Director',
                              'Vice President',
                              'Senior Vice President',
                              'Executive President',
                              'Chief Executive Officer',
                              'Chief Operating Officer',
                              'Chief Financial Officer',
                              'Chief Technology Officer',
                              'Chief Marketing Officer',
                              'Chief People Officer' 
                           ) )
);
--
drop table if exists phnx_bnk_bank_master;
--
create table phnx_bnk_bank_master (
   bank_ck     number(10) not null,
   bank_id     varchar2(50),
   bank_name   varchar2(100),
   bank_branch varchar2(100),
   zip_code    varchar2(10),
   constraint phnx_bnk_bank_master_zip_code_fk foreign key ( zip_code )
      references phnx_cntry_state_city_zip_codes ( zip_code ),
   constraint phnx_bnk_bank_master_bank_pk primary key ( bank_ck )
);
--
create table phnx_emp_employee_master (
   employee_ck          number(10) not null,
   employee_id          varchar2(120) not null,
   employee_first_name  varchar2(50),
   employee_middle_name varchar2(50),
   employee_last_name   varchar2(50),
   employee_dob_dt      date not null,
   employee_start_dt    date not null,
   employee_end_dt      date,
   employee_status_ck   number(10),
   employee_type_ck     number(10),
   desig_ck             number(10),
   salary_ck            number(10),
   unit_head_ck         number(10),
   sub_unit_head_ck     number(10),
   supervisor_ck        number(10),
   unit_ck              number(10),
   sub_unit_ck          number(10),
   constraint employees_pk primary key ( employee_ck ),
   constraint employee_master_unit_fk foreign key ( unit_ck )
      references units ( unit_ck ),
   constraint employees_sub_unit_fk foreign key ( sub_unit_ck )
      references sub_units ( sub_unit_ck ),
   constraint employees_designations_fk foreign key ( desig_ck )
      references designations ( desig_ck ),
   constraint employees_salary_ranges_fk foreign key ( salary_ck )
      references salary_ranges ( salary_ck ),
   constraint employees_employee_status_fk foreign key ( employee_status_ck )
      references employee_status ( employee_status_ck ),
   constraint employees_employee_type_fk foreign key ( employee_type_ck )
      references employee_type ( employee_type_ck ),
   constraint employees_unit_head_fk foreign key ( unit_head_ck )
      references employee_master ( employee_ck ),
   constraint employees_sub_unit_head_fk foreign key ( sub_unit_head_ck )
      references employee_master ( employee_ck ),
   constraint employees_supervisor_fk foreign key ( supervisor_ck )
      references employee_master ( employee_ck )
);
--
create table employee_fin_def (
   employee_ck             number(10) not null,
   employee_fin_def_eff_dt date not null,
   employee_fin_def_end_dt date,
   employee_tin            varchar2(20),
   employee_uid            varchar2(20),
   bank_account_number     varchar2(50),
   bank_ck                 number(10),
   currency_ck             number(10),
   constraint employee_fin_def_pk primary key ( employee_ck,
                                                   employee_fin_def_eff_dt ),
   constraint employee_fin_def_bank_fk foreign key ( bank_ck )
      references bank_master ( bank_ck ),
   constraint employee_fin_def_currency_fk foreign key ( currency_ck )
      references currency_master ( currency_ck )
);
--
create table employees_pay_definition (
   employee_ck                        number(10) not null,
   pay_definition_eff_dt              date not null,
   pay_definition_end_dt              date,
   employee_salary_pay_day            varchar2(2),
   employee_basic_salary_in           number(10,2),
   employee_hourse_allowance_in       number(10,2),
   employee_conveyance_allowance_in   number(10,2),
   employee_special_allowance_in      number(10,2),
   employee_bonus_amount_in           number(10,2),
   employee_professional_tax_out      number(10,2),
   employee_employee_contribution_out number(10,2),
   employee_tax_deduction_out         number(10,2),
   employee_total_earnings_in         number(10,2),
   employee_total_deductions_out      number(10,2),
   employee_tax_savings               number(10,2),
   employee_net_pay_in                number(10,2),
   currency_ck                        number(10),
   constraint employees_pay_definition_currency_fk foreign key ( currency_ck )
      references currency_master ( currency_ck ),
   constraint employees_pay_definition_pk primary key ( employee_ck,
                                                        pay_definition_eff_dt ),
   constraint employees_pay_definition_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck ),
   constraint employee_salary_pay_day_chk check ( employee_salary_pay_day in ( 'MM',
                                                             'BW' ) )
);
--
create table employee_paycheck (
   employee_ck     number(10) not null,
   paycheck_dt     date not null,
   paycheck_day    number(2),
   paycheck_mm     number(2),
   paycheck_yy     number(4),
   paycheck_qtr    varchar(2),
   paycheck_status varchar2(20),
   constraint employee_paycheck_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck ),
   constraint paycheck_status_chk
      check ( paycheck_status in ( 'Pending',
                                   'Credited',
                                   'Failed',
                                   'Cancelled' ) )
);
--
create table employee_performance (
   employee_ck                      number(10) not null,
   employee_performance_year        varchar2(4) not null,
   employee_performance_rating      varchar2(1) not null,
   employee_performance_rating_desc varchar2(15),
   employee_performance_comments    varchar2(500),
   constraint employee_performance_pk primary key ( employee_ck,
                                                    employee_performance_year ),
   constraint employee_performance_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck ),
   constraint employee_performance_rating_desc_chk
      check ( employee_performance_rating_desc in ( 'Excellent',
                                                    'Good',
                                                    'Average',
                                                    'Below Average',
                                                    'Poor' ) ),
   constraint employee_performance_rating_chk
      check ( employee_performance_rating in ( '1',
                                               '2',
                                               '3',
                                               '4',
                                               '5' ) )
);
--
create table employee_promotions (
   employee_ck      number(10) not null,
   promotion_eff_dt date not null,
   promotion_end_dt date,
   desig_ck         number(10),
   desig_duration   interval year to month,
   constraint employee_promotions_pk primary key ( employee_ck,
                                                   promotion_eff_dt ),
   constraint employee_promotions_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck )
);
-
create table employee_addr_loc (
   employee_ck          number(10) not null,
   employee_addr_eff_dt date not null,
   employee_addr_end_dt date,
   employee_addr_type   varchar2(50),
   employee_addr_line1  varchar2(200),
   employee_addr_line2  varchar2(200),
   employee_addr_line3  varchar2(200),
   employee_state       varchar2(50),
   employee_phone       varchar2(20),
   employee_email       varchar2(100),
   zip_code_ck          number(10),
   constraint employee_addr_zip_codes_fk foreign key ( zip_code_ck )
      references zip_codes ( zip_code_ck ),
   constraint employee_addr_loc_pk primary key ( employee_ck,
                                                 employee_addr_eff_dt,
                                                 employee_addr_type )
);
--
create table employee_work_loc_site (
   employee_ck                  number(10) not null,
   work_loc_site_eff_dt         date not null,
   work_loc_site_end_dt         date,
   employee_work_loc_type       varchar2(1),
   employee_work_loc_type_desc  varchar2(50),
   employee_work_site_type      varchar2(3),
   employee_work_site_type_desc varchar2(50),
   constraint employee_work_loc_site_pk primary key ( employee_ck,
                                                      work_loc_site_eff_dt ),
   constraint employee_work_loc_type_chk
      check ( employee_work_loc_type in ( 'R',
                                          'O',
                                          'H' ) ),
   constraint employee_work_site_type_chk check ( employee_work_site_type in ( 'ON',
                                                                               'OFF' ) ),
   constraint employee_work_loc_site_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck ),
   constraint employee_work_loc_type_desc_chk
      check ( employee_work_loc_type_desc in ( 'Remote',
                                               'Onsite',
                                               'Hybrid' ) ),
   constraint employee_work_site_type_desc_chk check ( employee_work_site_type_desc in ( 'Onshore',
                                                                                         'Offshore' ) )
);
--
create table customer (
   customer_ck   number(10) not null,
   customer_id   varchar2(20) not null,
   customer_name varchar2(300),
   constraint customer_pk primary key ( customer_ck )
);
--
create table projects (
   project_ck   number(10) not null,
   project_id   varchar2(20) not null,
   project_name varchar2(300),
   constraint project_lines_pk primary key ( project_ck )
); 
--
-- The project_definition table is used to define the projects with their effective dates, managers, and associated units.
-- It includes foreign keys to link to the employee master, units, and sub-units.
--
create table project_definition (
   project_ck      number(10) not null,
   project_eff_dt  date not null,
   project_term_dt date,
   project_mgr_ck  number(10),
   unit_ck         number(10),
   sub_unit_ck     number(10),
   constraint project_definition_pk primary key ( project_ck,
                                                  project_eff_dt ),
   constraint project_def_employee_fk foreign key ( project_mgr_ck )
      references employee_master ( employee_ck ),
   constraint project_def_unit_fk foreign key ( unit_ck )
      references units ( unit_ck ),
   constraint project_def_sub_unit_fk foreign key ( sub_unit_ck )
      references sub_units ( sub_unit_ck ),
   constraint projects_project_def_fk foreign key ( project_ck )
      references projects ( project_ck )
);
--
create table project_staffing (
   project_ck   number(10) not null,
   employee_ck  number(10) not null,
   desig_ck     number(10),
   alloc_eff_dt date not null,
   alloc_end_dt date,
   alloc_status varchar2(20),
   constraint project_staffing_pk primary key ( project_ck,
                                                employee_ck,
                                                alloc_eff_dt ),
   constraint project_staffing_projects_fk foreign key ( project_ck )
      references projects ( project_ck ),
   constraint project_staffing_employee_fk foreign key ( employee_ck )
      references employee_master ( employee_ck ),
   constraint project_staffing_designations_fk foreign key ( desig_ck )
      references designations ( desig_ck )
);
--
create table bill_rate (
   bill_rate_ck       number(10) not null,
   bill_rate_eff_dt   date not null,
   bill_rate_end_dt   date,
   desig_ck           number(10),
   offshore_bill_rate number(10,2),
   onshore_bill_rate  number(10,2),
   currency_ck        number(10),
   constraint bill_rate_pk primary key ( bill_rate_ck,
                                         bill_rate_eff_dt ),
   constraint bill_rate_currency_fk foreign key ( currency_ck )
      references currency_master ( currency_ck ),
   constraint bill_rate_desig_fk foreign key ( desig_ck )
      references designations ( desig_ck )
);
--
create table project_financials (
   project_ck                 number(10) not null,
   fin_month                  number(2),
   fin_qtr                    number(2),
   fin_year                   number(4),
   projected_cost             number(10,2),
   actual_cost                number(10,2),
   projected_revenue          number(10,2),
   actual_revenue             number(10,2),
   projected_onshore_rsc_nbr  number(10,2),
   actual_onshore_rsc_nbr     number(10,2),
   projected_offshore_rsc_nbr number(10,2),
   actual_offshore_rsc_nbr    number(10,2),
   tot_projected_rsc_nbr      number(10,2),
   tot_actual_rsc_nbr      number(10,2),
   constraint project_financials_pk
      primary key ( project_ck,
                    fin_month,
                    fin_qtr,
                    fin_year )
);