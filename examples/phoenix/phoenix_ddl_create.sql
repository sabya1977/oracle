-- phoenix_ddl_create.sql
-- Author: Sabyasachi Mitra
-- Date: 07/10/2025
-- Description: This script creates the necessary 
-- tables and structures for the Phoenix database.
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

-- Create a calendar table with various date attributes
-- This table will be used for date-related queries and joins
--
create table calendar (
   calendar_ck      number(18)
      generated always as identity,
   calendar_date    date,
   calendar_day     varchar2(10),
   calendar_month   varchar2(10),
   calendar_quarter varchar2(10),
   calendar_year    varchar2(10),
   day_of_week_num  number(1),
   day_of_week_name varchar2(10),
   date_num         varchar2(10),
   quarter_cd       varchar2(10),
   month_name_cd    varchar2(10),
   full_month_name  varchar2(10),
   holiday_name     varchar2(50),
   holiday_flag     number(1),
   constraint calendar_pk primary key ( calendar_ck )
);
--
-- Insert data into the calendar table for a range of dates
-- This will create a calendar from 01/01/2010 to 01/01/2020
-- The calendar will include day, month, quarter, year, and holiday information
--
declare
   start_date date;
   end_date   date;
begin
   start_date := to_date ( '01/01/2010','DD/MM/YYYY' );
   end_date := start_date + 10950;
   while start_date <= end_date loop
      insert into calendar (
         calendar_date,
         calendar_day,
         calendar_month,
         calendar_quarter,
         calendar_year,
         day_of_week_num,
         day_of_week_name,
         date_num,
         quarter_cd,
         month_name_cd,
         full_month_name,
         holiday_name,
         holiday_flag
      ) values ( start_date,
                 to_char(
                    start_date,
                    'DD'
                 ),
                 to_char(
                    start_date,
                    'MM'
                 ),
                 to_char(
                    start_date,
                    'Q'
                 ),
                 to_char(
                    start_date,
                    'YYYY'
                 ),
                 case
                    when to_char(
                       start_date,
                       'D'
                    ) = '1' then
                       7
                    else
                       to_char(
                          start_date,
                          'D'
                       ) - 1
                 end,
                 to_char(
                    start_date,
                    'DY'
                 ),
                 to_char(
                    start_date,
                    'YYYYMMDD'
                 ),
                 to_char(
                    start_date,
                    'YYYY'
                 )
                 || 'Q'
                 || to_char(
                    start_date,
                    'Q'
                 ),
                 to_char(
                    start_date,
                    'MON'
                 ),
                 to_char(
                    start_date,
                    'MONTH'
                 ),
                 null,
                 0 );

      start_date := start_date + 1;
   end loop;
end;
/
--
commit;
--

-- Create a regions table to categorize countries by region
-- This table will be used to join with countries and cities
-- The regions will include North America, South America, Europe, Middle East and Africa, Asia Pacific, and India
-- Each region will have a unique key, ID, and name
-- The region_id will be a short code for the region
-- The region_name will be the full name of the region
-- The region_ck will be the primary key for the regions table
-- The region_id will be a short code for the region
--
create table regions (
   region_ck   number(10) not null,
   region_id   varchar2(4),
   region_name varchar2(50),
   constraint regions_pk primary key ( region_ck ),
   constraint regions_chk
      check ( region_name in ( 'North America',
                               'South America',
                               'Europe',
                               'Middle East and Africa',
                               'Asia Pacific',
                               'India' ) ),
   constraint region_id_chk
      check ( region_id in ( 'NA',
                             'SA',
                             'EU',
                             'MEA',
                             'APAC',
                             'IN' ) )
);
--
--
-- Create a countries table to store country information
-- This table will include country ID, name, and region
-- The country_ck will be the primary key for the countries table
-- The country_id will be a short code for the country
-- The country_name will be the full name of the country
-- The region_ck will be a foreign key referencing the regions table
--
create table countries (
   country_ck   number(10) not null,
   country_id   varchar2(4),
   country_name varchar2(100),
   region_ck    number(10),
   constraint countries_pk primary key ( country_ck ),
   constraint countries_region_fk foreign key ( region_ck )
      references regions ( region_ck ),
   constraint countries_country_name_chk
      check ( country_name in ( 'United States',
                                'Canada',
                                'Mexico',
                                'Brazil',
                                'Argentina',
                                'United Kingdom',
                                'Germany',
                                'France',
                                'Italy',
                                'Spain',
                                'South Africa',
                                'United Arab Emirates',
                                'India',
                                'China',
                                'Japan',
                                'Australia' ) ),
   constraint countries_country_id_chk
      check ( country_id in ( 'US',
                              'CA',
                              'MX',
                              'BR',
                              'AR',
                              'UK',
                              'DE',
                              'FR',
                              'IT',
                              'ES',
                              'ZA',
                              'AE',
                              'IN',
                              'CN',
                              'JP',
                              'AU' ) )
);
--
-- Create a state_city_zip table to store state, city, and zip code information
-- This table will include state name, city name, zip code, and country key
-- The state_city_zip_ck will be the primary key for the state_city_zip table
-- The state_name will be the name of the state.
-- The city_name will be the name of the city
-- The zip_code will be the postal code for the city
-- The country_ck will be a foreign key referencing the countries table
-- The state_city_zip_country_fk will be a foreign key referencing the countries table
-- The state_city_zip_chk will check the length of the zip code
-- The state_city_zip_state_name_chk will check the state name against a list of valid states
--
create table state_city_zip (
   state_city_zip_ck number(10) not null,
   state_name        varchar2(50),
   city_name         varchar2(50),
   zip_code          varchar2(20),
   country_ck        number(10),
   constraint state_city_zip_pk primary key ( state_city_zip_ck ),
   constraint state_city_zip_country_fk foreign key ( country_ck )
      references countries ( country_ck ),
   constraint state_city_zip_zip_code_chk
      check ( length(zip_code) between 5 and 10 ),
   constraint state_city_zip_state_name_chk
      check ( state_name in ( 'California',
                              'Texas',
                              'Florida',
                              'New York',
                              'Illinois',
                              'Pennsylvania',
                              'Ohio',
                              'Georgia',
                              'North Carolina',
                              'Michigan',
                              'New Jersey',
                              'Virginia',
                              'Arizona',
                              'Massachusetts',
                              'Tennessee',
                              'Indiana',
                              'Kansas',
                              'Missouri',
                              'Maryland',
                              'Wisconsin',
                              'South Carolina',
                              'Nebraska',
                              'Nevada',
                              'Rhode Island',
                              'Utah',
                              'Vermont',
                              'Washington',
                              'West Virginia',
                              'Wisconsin',
                              'Wyoming',
                              'Mississippi',
                              'Iowa',
                              'Arakansas',
                              'Alabama',
                              'South Dakota',
                              'Oklahoma',
                              'Oregon',
                              'New Mexico',
                              'New Hampshire',
                              'Hawaii',
                              'Idaho',
                              'Kentucky',
                              ' Massachusetts',
                              'Colorado',
                              'Delaware' ) ),
   constraint state_city_zip_city_name_chk
      check ( city_name in ( 'Los Angeles',
                             'San Francisco',
                             'San Diego',
                             'Houston',
                             'Dallas',
                             'Austin',
                             'New York City',
                             'Chicago',
                             'Philadelphia',
                             'Phoenix',
                             'San Antonio',
                             'San Jose',
                             'Seattle',
                             'Boston',
                             'Washington DC',
                             'Miami',
                             'Atlanta',
                             'Denver',
                             'Orlando',
                             'Portland',
                             'Sacramento',
                             'Salt Lake City',
                             'Omaha',
                             'Kansas City',
                             'Wichita',
                             'Little Rock' ) )
);
--
-- Create a cities table to store city information
-- This table will include city name, country key, and a primary key
-- The city_ck will be the primary key for the cities table
-- The city_name will be the name of the city 
-- The country_ck will be a foreign key referencing the countries table
-- The cities_country_fk will be a foreign key referencing the countries table
-- The cities_city_name_chk will check the city name against a list of valid cities
-- The city_name will be a varchar2 field with a maximum length of 14 characters
--
create table cities (
   city_ck    number(10) not null,
   city_name  varchar2(14),
   country_ck number(10),
   constraint cities_pk primary key ( city_ck ),
   constraint cities_country_fk foreign key ( country_ck )
      references countries ( country_ck ),
   constraint cities_city_name_chk
      check ( city_name in ( 'Shanghai',
                             'Beijing',
                             'Shenzhen',
                             'Guangzhou',
                             'Chengdu',
                             'Hong Kong',
                             'Jinan',
                             'Wuhan',
                             'Qingdao',
                             'Suzhou',
                             'Hangzhou',
                             'Harbin',
                             'Tianjin',
                             'Cape Town',
                             'Johannesburg',
                             'Durban',
                             'Pretoria',
                             'Tokyo',
                             'Osaka',
                             'Kyoto',
                             'Seoul',
                             'Busan',
                             'Paris',
                             'Marseille',
                             'Lyon',
                             'Berlin',
                             'Hamburg',
                             'Munich',
                             'Frankfurt',
                             'Mexico City',
                             'Guadalajara',
                             'Rio de Janeiro',
                             'Sao Paulo',
                             'Buenos Aires',
                             'London',
                             'Brasília',
                             'Manchester',
                             'Birmingham',
                             'Liverpool',
                             'Sheffield',
                             'Rome',
                             'Milan',
                             'Naples',
                             'Turin',
                             'Florence',
                             'Melbourne',
                             'Sydney',
                             'Brisbane',
                             'Perth',
                             'Dubai',
                             'Abu Dhabi',
                             'Dublin',
                             'Madrid',
                             'Barcelona',
                             'Valencia',
                             'New York',
                             'Chicago',
                             'Houston',
                             'Phoenix',
                             'Philadelphia',
                             'San Antonio',
                             'San Diego',
                             'Dallas',
                             'San Jose',
                             'San Francisco',
                             'Richmond',
                             'Denver',
                             'Seattle',
                             'Washington DC',
                             'Boston',
                             'Toronto',
                             'Vancouver',
                             'Montreal',
                             'Ottawa',
                             'Hyderabad',
                             'Chennai',
                             'Bengaleru',
                             'Pune',
                             'Vizag' ) )
);
--
create table zip_codes (
   zip_code_ck number(10) not null,
   zip_code    varchar2(20) not null,
   city_ck     number(10),
   constraint zip_codes_pk primary key ( zip_code_ck ),
   constraint zip_codes_city_fk foreign key ( city_ck )
      references cities ( city_ck ),
   constraint zip_codes_zip_code_chk
      check ( length(zip_code) between 5 and 10 ),
   constraint zip_code_unique unique ( zip_code )
);
--
create table currency_master (
   currency_ck     number(10) not null,
   currency_id     varchar2(3),
   currency_name   varchar2(50),
   country_ck      number(10),
   currency_symbol varchar2(5),
   constraint currency_master_pk primary key ( currency_ck ),
   constraint currency_master_currency_id_chk
      check ( currency_id in ( 'USD',
                               'EUR',
                               'GBP',
                               'INR',
                               'JPY',
                               'CNY',
                               'AUD',
                               'CAD',
                               'BRL',
                               'MXN',
                               'ARS',
                               'ZAR' ) ),
   constraint currency_master_currency_name_chk
      check ( currency_name in ( 'US Dollar',
                                 'Euro',
                                 'British Pound',
                                 'Indian Rupee',
                                 'Japanese Yen',
                                 'Chinese Yuan',
                                 'Australian Dollar',
                                 'Canadian Dollar',
                                 'Brazilian Real',
                                 'Argentine Peso',
                                 'Mexican Peso',
                                 'South African Rand' ) ),
   constraint currency_master_currency_symbol_chk
      check ( currency_symbol in ( '$',
                                   '€',
                                   '£',
                                   '₹',
                                   '¥',
                                   '元',
                                   'A$',
                                   'C$',
                                   'R$',
                                   'MX$',
                                   'AR$',
                                   'ZAR' ) )
);
--
create table units (
   unit_ck      number(10) not null,
   unit_name    varchar2(100),
   unit_id      varchar2(10),
   unit_head_ck number(10),
   constraint units_pk primary key ( unit_ck ),
   constraint units_unit_name_chk
      check ( unit_name in ( 'Core Business Groups',
                             'Core Technologies and Solutions',
                             'Software and Platform Engineering',
                             'Enableement Services',
                             'Consulting Solutions and Services',
                             'Global Sales and Marketing',
                             'Human Resources',
                             'Finance',
                             'IT and Security Support',
                             'Corporate' ) ),
   constraint units_unit_id_chk
      check ( unit_id in ( 'CBG',
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
create table sub_units (
   sub_unit_ck      number(10) not null,
   sub_unit_name    varchar2(100),
   sub_unit_id      varchar2(10),
   unit_ck          number(10),
   sub_unit_head_ck number(10),
   constraint sub_units_pk primary key ( sub_unit_ck ),
   constraint sub_units_unit_fk foreign key ( unit_ck )
      references units ( unit_ck ),
   constraint sub_units_sub_unit_name_chk
      check ( sub_unit_name in ( 'Healthcare and Life Sciences',
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
                                 'Industry Solutions Group' ) ),
   constraint sub_unit_id_chk
      check ( sub_unit_id in ( 'HLS',
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
                               'IoT',
                               'MBG',
                               'ABG',
                               'GBG',
                               'OBG',
                               'ERPG',
                               'ISG' ) )
);
--
--
create table employee_status (
   employee_status_ck number(10) not null,
   status_eff_dt      date not null,
   status_end_dt      date,
   employee_status    varchar2(50),
   constraint employee_status_pk primary key ( employee_status_ck),
   constraint employee_status_employee_status_chk
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
--
create table employee_type (
   employee_type_ck   number(10) not null,
   type_eff_dt        date not null,
   type_end_dt        date,
   employee_type_id   varchar2(2),
   employee_type_desc varchar2(20),
   constraint employee_type_pk primary key ( employee_type_ck ),
   constraint employee_type_desc_chk
      check ( employee_type_desc in ( 'Full Time',
                                      'Part Time',
                                      'Contractor',
                                      'Intern',
                                      'Probation' ) ),
   constraint employee_type_id_chk
      check ( employee_type_id in ( 'FT',
                                    'PT',
                                    'CT',
                                    'IN',
                                    'PR' ) )
);
--
--
create table salary_ranges (
   salary_ck      number(10) not null,
   salary_rang_id varchar2(10),
   salary_minimum number(10,2),
   salary_maximum number(10,2),
   currency_ck    number(10),
   constraint salary_ranges_pk primary key ( salary_ck ),
   constraint salary_ranges_currency_fk foreign key ( currency_ck )
      references currency_master ( currency_ck ),
   constraint salary_range_id_chk
      check ( salary_rang_id in ( 'SR-01',
                                  'SR-02',
                                  'SR-03',
                                  'SR-04',
                                  'SR-05',
                                  'SR-06',
                                  'SR-07',
                                  'SR-08',
                                  'SR-09',
                                  'SR-10',
                                  'SR-11',
                                  'SR-12',
                                  'SR-13',
                                  'SR-14',
                                  'SR-15',
                                  'SR-16',
                                  'SR-17',
                                  'SR-18',
                                  'SR-19',
                                  'SR-20',
                                  'SR-21',
                                  'SR-22',
                                  'SR-23',
                                  'SR-25',
                                  'SR-26',
                                  'SR-27',
                                  'SR-28',
                                  'SR-29',
                                  'SR-30' ) )
);
--
create table designations (
   desig_ck   number(10) not null,
   desig_desc varchar2(100),
   desig_id   varchar2(10),
   salary_ck  number(10),
   constraint designations_pk primary key ( desig_ck ),
   constraint designations_chk
      check ( desig_id in ( 'SDE-I',
                            'SDE-II',
                            'SDE-III',
                            'SDM',
                            'EM',
                            'TD',
                            'STD',
                            'OE',
                            'SOE',
                            'HE',
                            'SHE',
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
   constraint desig_salary_ranges_fk foreign key ( salary_ck )
      references salary_ranges ( salary_ck ),
   constraint desig_desc_chk
      check ( desig_desc in ( 'Software Devleopment Engineer-I',
                              'Software Devleopment Engineer-II',
                              'Software Devleopment Engineer-III',
                              'SOftware Development Manager',
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
                              'Chief People Officer' ) )
);
--
create table bank_master (
   bank_ck     number(10) not null,
   bank_id     varchar2(50),
   bank_name   varchar2(100),
   bank_branch varchar2(100),
   zip_code_ck number(10),
   constraint bank_master_zip_code_fk foreign key ( zip_code_ck )
      references zip_codes ( zip_code_ck ),
   constraint bank_master_pk primary key ( bank_ck )
);
--
create table employee_master (
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