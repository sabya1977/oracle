alter session set current_schema = phoenix;
--
drop sequence if exists bu_sub_unit_head_ck_seq;
create sequence bu_sub_unit_head_ck_seq start with 1011 increment by 1 cache 50;
--
drop sequence if exists bu_sub_unit_ck_seq;
create sequence bu_sub_unit_ck_seq start with 11 increment by 1 cache 50;
--
drop sequence if exists phnx_desg_employee_designations_desig_ck_seq;
create sequence phnx_desg_employee_designations_desig_ck_seq start with 1 increment by 1 cache 50;
--
drop sequence phnx_bnk_bank_master_bank_ck_seq;
create sequence phnx_bnk_bank_master_bank_ck_seq start with 1 increment by 1 cache 50;
--
select bu_sub_unit_head_ck_seq.nextval
  from dual;
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Healthcare and Life Sciences',
           'HLS',
           1,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Banking and Financial Services',
           'BFS',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Manufacturing and Logistics',
           'MANLOG',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Retail and Consumer Goods',
           'RCG',
           1,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Communications, Media and Technology',
           'CMT',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Government Services',
           'GS',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Energy and Utilities',
           'EU',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Telecom',
           'TELCOM',
           1,
           bu_sub_unit_head_ck_seq.nextval );
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Insurance',
           'INS',
           1,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Artificial Intelligence and Analytics',
           'AIA',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Cloud, Infrastructure and Security',
           'CIS',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Internet of Things',
           'IOT',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Microsoft Business Group',
           'MBG',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'AWS Business Group',
           'ABG',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Google Business Group',
           'GBG',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Oracle Business Group',
           'OBG',
           2,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'ERP and CRM Solutions',
           'ERPCS',
           3,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Industry Solutions Group',
           'ISG',
           3,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Application Development and Management',
           'ADM',
           3,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Digital Engineering',
           'DE',
           3,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Quality Engineering and Assurance',
           'QEA',
           3,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Project and Program Management',
           'PPM',
           4,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Delivery Audit',
           'DA',
           4,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Business Consulting Group',
           'BCG',
           5,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Technology Consulting Group',
           'TCG',
           5,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Global Business Development',
           'GBD',
           10,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Global Marketing',
           'GMKT',
           10,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Talent Acquisition Group',
           'TAG',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Payroll and Benefits Group',
           'PBG',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Grievances and Compliance',
           'GAC',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Workforce Management',
           'WFM',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Employee Wellness',
           'EW',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Global Mobility Group',
           'GMG',
           6,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Project Finance Group',
           'PFG',
           7,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Infrastructure Service',
           'IS',
           9,
           bu_sub_unit_head_ck_seq.nextval );
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Business Operations Group',
           'BOG',
           9,
           bu_sub_unit_head_ck_seq.nextval );
--
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Transport Services',
           'TS',
           9,
           bu_sub_unit_head_ck_seq.nextval );
--
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Digital Asset Management',
           'DAM',
           8,
           bu_sub_unit_head_ck_seq.nextval );           
--
--
insert into phoenix.phnx_bu_business_sub_units (
   bu_sub_unit_ck,
   bu_sub_unit_name,
   bu_sub_unit_id,
   bu_unit_ck,
   bu_sub_unit_head_ck
) values ( bu_sub_unit_ck_seq.nextval,
           'Digital Access and Security',
           'DAS',
           8,
           bu_sub_unit_head_ck_seq.nextval );
--
--
commit;
--
select *
  from phnx_country_currencies;
--
-- insert designations table
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Engineer-I',
           'SDE-I',
           0,
           4,
           30000.00,
           50000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Engineer-II',
           'SDE-II',
           5,
           8,
           52000.00,
           70000.00,
           1 );           
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Manager',
           'SDM',
           9,
           12,
           72000.00,
           90000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Engineering Manager',
           'EM',
           13,
           18,
           90000.00,
           120000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Technical Director',
           'TD',
           19,
           23,
           120000.00,
           140000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Technical Director',
           'STD',
           24,
           30,
           150000.00,
           180000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Vice President',
           'VP',
           null,
           null,
           180000.00,
           200000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Vice President',
           'SVP',
           null,
           null,
           200000.00,
           220000.00,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Executive President',
           'EVP',
           null,
           null,
           null,
           null,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief Technology Officer',
           'CTO',
           null,
           null,
           null,
           null,
           1 );
--           
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief Executive Officer',
           'CEO',
           null,
           null,
           null,
           null,
           1 );           
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief Operating Officer',
           'COO',
           null,
           null,
           null,
           null,
           1 );           
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief Financial Officer',
           'CFO',
           null,
           null,
           null,
           null,
           1 );   
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief Marketing Officer',
           'CMO',
           null,
           null,
           null,
           null,
           1 );        
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Chief People Officer',
           'CPO',
           null,
           null,
           null,
           null,
           1 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Operations Executive',
           'OE',
           0,
           3,
           500000,
           800000,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Operations Executive',
           'SOE',
           4,
           8,
           820000,
           1200000,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Manager',
           'MGR',
           9,
           12,
           1200000,
           2000000,
           2 );
--
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Manager',
           'SMGR',
           12,
           18,
           2000000,
           3000000,
           2 );
--
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Director',
           'D',
           18,
           22,
           3200000,
           5200000,
           2 );
--           
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Human Resources Executive',
           'HRE',
           0,
           3,
           500000,
           800000,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Human Resources Executive',
           'SHRE',
           4,
           8,
           820000,
           1200000,
           2 );
--           
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Information and Security Engineer-I',
           'ISE-I',
           0,
           3,
           500000,
           800000,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Information and Security Engineer-II',
           'ISE-II',
           4,
           8,
           820000,
           1200000,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Engineer-I',
           'SDE-I',
           0,
           4,
           800000.00,
           1000000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Engineer-II',
           'SDE-II',
           5,
           8,
           1200000.00,
           1500000.00,
           2 );           
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Software Development Manager',
           'SDM',
           9,
           12,
           1700000.00,
           2500000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Engineering Manager',
           'EM',
           13,
           18,
           2700000.00,
           3700000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Technical Director',
           'TD',
           19,
           23,
           3800000.00,
           4500000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Technical Director',
           'STD',
           24,
           30,
           4600000.00,
           5000000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Vice President',
           'VP',
           null,
           null,
           5200000.00,
           7000000.00,
           2 );
--
insert into phoenix.phnx_desg_employee_designations (
   desig_ck,
   desig_desc,
   desig_id,
   min_yrs_exp,
   max_yrs_exp,
   min_salary,
   max_salary,
   currency_ck
) values ( phnx_desg_employee_designations_desig_ck_seq.nextval,
           'Senior Vice President',
           'SVP',
           null,
           null,
           7200000.00,
           8200000.00,
           2 );
--
commit;
--
select *
  from phoenix.phnx_desg_employee_designations;
--
-- insert into bank table
--
-- US Banks
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'BOA',
           'Bank of America',
           'New York Main, New York',
           '10001' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'CHASE',
           'Chase Bank',
           'San Francisco Central, California',
           '94105' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'WELLS',
           'Wells Fargo',
           'Chicago Downtown, Illinois',
           '60601' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'CITI',
           'Citibank',
           'Houston Midtown, Texas',
           '77002' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'UBS',
           'US Bank',
           'Seattle North, Washington',
           '98101' );
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'TCBI',
           'Texas Capital Bank',
           'Texas, Dallas',
           '75201' );
--
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'FIBK',
           'First Interstate BancSystem',
           'Billings, Montana',
           '59101' );
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'SFNC',
           'Simmons Bank',
           'Pine Bluff, Arkansas',
           '71601' );
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'SBI',
           'State Bank of India',
           'Kolkata Main, West Bengal',
           '700020' );
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'SBI',
           'State Bank of India',
           'Kolkata Central, West Bengal',
           '700046' );  
--
--
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'SBI',
           'State Bank of India',
           'Chennai Central, West Bengal',
           '600018' );                    
--           
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'ICICI',
           'ICICI Bank',
           'Bangalore Central',
           '560079' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'HDFC',
           'HDFC Bank',
           'Bangalore City',
           '560050' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'AXIS',
           'Axis Bank',
           'Kolkata Downtown',
           '700046' );
insert into phnx_bnk_bank_master (
   bank_ck,
   bank_id,
   bank_name,
   bank_branch,
   zip_code
) values ( phnx_bnk_bank_master_bank_ck_seq.nextval,
           'PNB',
           'Punjab National Bank',
           'Chennai South',
           '600020' );
--
commit;
--
select *
  from phnx_bnk_bank_master;