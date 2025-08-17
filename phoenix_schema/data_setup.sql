-- =========================================================
-- File: data_setup.sql
-- Description: This script create data to test data to test error logging
-- Author: Sabyasachi Mitra
-- Creation Date: 20/07/2025
-- version: 1.0 - Initial version
-- =========================================================
--
drop table if exists employees;
drop table if exists departments;
drop table if exists jobs;
drop table if exists locations;
--
create table employees (
   empid       number(6) not null,
   salary      number(10,2) not null,
   name        varchar2(50) not null,
   hire_date   date null,
   email       varchar2(100) null,
   deptid      number(6),
   jobid       number(6),
   location_id number(6),
   constraint employees_pk primary key (empid),
   constraint employees_deptid_fk foreign key (deptid) references departments (deptid),
);
--
create table departments (
   deptid    number(6),
   dept_name varchar2(50),
   constraint departments_pk primary key (deptid));
--
create table jobs (
   jobid     number(6),
   job_title varchar2(50),
   constraint jobs_pk primary key (jobid);
);
--
create table locations (
   location_id number(6),
   city        varchar2(50),
   state       varchar2(50),
   country     varchar2(50),
   constraint locations_pk primary key (location_id)
);
--
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2001,
           85000.00,
           'John Miller',
           date '2022-01-10',
           'john.miller@example.com',
           10,
           101,
           10 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2002,
           87000.00,
           'Emily Clark',
           date '2022-02-15',
           'emily.clark@example.com',
           20,
           102,
           12 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2003,
           91000.00,
           'Michael Lee',
           date '2022-03-20',
           'michael.lee@example.com',
           30,
           103,
           14 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2004,
           80000.00,
           'Sarah Kim',
           date '2022-04-25',
           'sarah.kim@example.com',
           40,
           104,
           16 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2005,
           95000.00,
           'David Smith',
           date '2022-05-30',
           'david.smith@example.com',
           50,
           105,
           18 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2006,
           82000.00,
           'Jessica Brown',
           date '2022-06-05',
           'jessica.brown@example.com',
           60,
           106,
           10 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2007,
           78000.00,
           'Brian Davis',
           date '2022-07-10',
           'brian.davis@example.com',
           70,
           107,
           12 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2008,
           86000.00,
           'Ashley Wilson',
           date '2022-08-15',
           'ashley.wilson@example.com',
           80,
           108,
           14 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2009,
           90000.00,
           'Matthew Martinez',
           date '2022-09-20',
           'matthew.martinez@example.com',
           90,
           109,
           16 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2010,
           83000.00,
           'Lauren Anderson',
           date '2022-10-25',
           'lauren.anderson@example.com',
           10,
           110,
           18 );

insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2011,
           87000.00,
           'Oliver Taylor',
           date '2022-01-10',
           'oliver.taylor@example.com',
           20,
           101,
           24 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2012,
           91000.00,
           'Sophie Harris',
           date '2022-02-15',
           'sophie.harris@example.com',
           30,
           102,
           26 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2013,
           80000.00,
           'Jack Evans',
           date '2022-03-20',
           'jack.evans@example.com',
           40,
           103,
           24 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2014,
           95000.00,
           'Emily Wright',
           date '2022-04-25',
           'emily.wright@example.com',
           50,
           104,
           26 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2015,
           82000.00,
           'George King',
           date '2022-05-30',
           'george.king@example.com',
           60,
           105,
           24 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2016,
           78000.00,
           'Charlotte Scott',
           date '2022-06-05',
           'charlotte.scott@example.com',
           70,
           106,
           26 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2017,
           86000.00,
           'Harry Green',
           date '2022-07-10',
           'harry.green@example.com',
           80,
           107,
           24 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2018,
           90000.00,
           'Lucy Baker',
           date '2022-08-15',
           'lucy.baker@example.com',
           90,
           108,
           26 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2019,
           83000.00,
           'Thomas Carter',
           date '2022-09-20',
           'thomas.carter@example.com',
           10,
           109,
           24 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2020,
           87000.00,
           'Grace Morgan',
           date '2022-10-25',
           'grace.morgan@example.com',
           20,
           110,
           26 );

insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2021,
           91000.00,
           'Wei Zhang',
           date '2022-01-10',
           'wei.zhang@example.com',
           30,
           101,
           74 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2022,
           80000.00,
           'Li Wang',
           date '2022-02-15',
           'li.wang@example.com',
           40,
           102,
           76 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2023,
           95000.00,
           'Chen Liu',
           date '2022-03-20',
           'chen.liu@example.com',
           50,
           103,
           78 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2024,
           82000.00,
           'Fang Xu',
           date '2022-04-25',
           'fang.xu@example.com',
           60,
           104,
           74 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2025,
           78000.00,
           'Jing Sun',
           date '2022-05-30',
           'jing.sun@example.com',
           70,
           105,
           76 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2026,
           86000.00,
           'Hui Zhou',
           date '2022-06-05',
           'hui.zhou@example.com',
           80,
           106,
           78 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2027,
           90000.00,
           'Min Chen',
           date '2022-07-10',
           'min.chen@example.com',
           90,
           107,
           74 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2028,
           83000.00,
           'Yan Li',
           date '2022-08-15',
           'yan.li@example.com',
           10,
           108,
           76 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2029,
           87000.00,
           'Bo Wu',
           date '2022-09-20',
           'bo.wu@example.com',
           20,
           109,
           78 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2030,
           91000.00,
           'Qiang Ma',
           date '2022-10-25',
           'qiang.ma@example.com',
           30,
           110,
           74 );

insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2031,
           80000.00,
           'Yuki Tanaka',
           date '2022-01-10',
           'yuki.tanaka@example.com',
           40,
           101,
           68 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2032,
           95000.00,
           'Haruto Sato',
           date '2022-02-15',
           'haruto.sato@example.com',
           50,
           102,
           70 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2033,
           82000.00,
           'Sakura Yamamoto',
           date '2022-03-20',
           'sakura.yamamoto@example.com',
           60,
           103,
           68 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2034,
           78000.00,
           'Kaito Nakamura',
           date '2022-04-25',
           'kaito.nakamura@example.com',
           70,
           104,
           70 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2035,
           86000.00,
           'Mio Suzuki',
           date '2022-05-30',
           'mio.suzuki@example.com',
           80,
           105,
           68 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2036,
           90000.00,
           'Ren Kobayashi',
           date '2022-06-05',
           'ren.kobayashi@example.com',
           90,
           106,
           70 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2037,
           83000.00,
           'Hinata Takahashi',
           date '2022-07-10',
           'hinata.takahashi@example.com',
           10,
           107,
           68 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2038,
           87000.00,
           'Sota Watanabe',
           date '2022-08-15',
           'sota.watanabe@example.com',
           20,
           108,
           70 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2039,
           91000.00,
           'Aoi Matsumoto',
           date '2022-09-20',
           'aoi.matsumoto@example.com',
           30,
           109,
           68 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2040,
           80000.00,
           'Riku Inoue',
           date '2022-10-25',
           'riku.inoue@example.com',
           40,
           110,
           70 );

insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2041,
           95000.00,
           'Min-Jun Kim',
           date '2022-01-10',
           'minjun.kim@example.com',
           50,
           101,
           72 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2042,
           82000.00,
           'Seo-Yeon Lee',
           date '2022-02-15',
           'seoyeon.lee@example.com',
           60,
           102,
           72 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2043,
           78000.00,
           'Ji-Hoon Park',
           date '2022-03-20',
           'jihoon.park@example.com',
           70,
           103,
           72 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2044,
           86000.00,
           'Ha-Eun Choi',
           date '2022-04-25',
           'haeun.choi@example.com',
           80,
           104,
           72 );
insert into employees (
   empid,
   salary,
   name,
   hire_date,
   email,
   deptid,
   jobid,
   location_id
) values ( 2045,
           90000.00,
           'Joon-Soo Jung',
           date '2022-05-30',
           'joonsoo.jung@example.com',
           90,
           105,
           72 );
--
commit;
--
insert into departments (
   deptid,
   dept_name
) values ( 10,
           'Engineering' );
insert into departments (
   deptid,
   dept_name
) values ( 20,
           'Product Management' );
insert into departments (
   deptid,
   dept_name
) values ( 30,
           'Quality Assurance' );
insert into departments (
   deptid,
   dept_name
) values ( 40,
           'DevOps' );
insert into departments (
   deptid,
   dept_name
) values ( 50,
           'UI/UX Design' );
insert into departments (
   deptid,
   dept_name
) values ( 60,
           'Data Science' );
insert into departments (
   deptid,
   dept_name
) values ( 70,
           'Technical Support' );
insert into departments (
   deptid,
   dept_name
) values ( 80,
           'Human Resources' );
insert into departments (
   deptid,
   dept_name
) values ( 90,
           'IT Security' );
--
-- insert into jobs
--
insert into jobs (
   jobid,
   job_title
) values ( 101,
           'Software Engineer' );
insert into jobs (
   jobid,
   job_title
) values ( 102,
           'Frontend Developer' );
insert into jobs (
   jobid,
   job_title
) values ( 103,
           'Backend Developer' );
insert into jobs (
   jobid,
   job_title
) values ( 104,
           'QA Engineer' );
insert into jobs (
   jobid,
   job_title
) values ( 105,
           'DevOps Engineer' );
insert into jobs (
   jobid,
   job_title
) values ( 106,
           'UI/UX Designer' );
insert into jobs (
   jobid,
   job_title
) values ( 107,
           'Product Manager' );
insert into jobs (
   jobid,
   job_title
) values ( 108,
           'Data Scientist' );
insert into jobs (
   jobid,
   job_title
) values ( 109,
           'Cloud Architect' );
insert into jobs (
   jobid,
   job_title
) values ( 110,
           'Technical Support Engineer' );
--
-- insert into locations
--
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 10,
           'San Francisco',
           'California',
           'USA' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 12,
           'New York',
           'New York',
           'USA' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 14,
           'Austin',
           'Texas',
           'USA' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 16,
           'Seattle',
           'Washington',
           'USA' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 18,
           'Boston',
           'Massachusetts',
           'USA' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 20,
           'Toronto',
           'Ontario',
           'Canada' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 22,
           'Vancouver',
           'British Columbia',
           'Canada' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 24,
           'London',
           'England',
           'UK' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 26,
           'Manchester',
           'England',
           'UK' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 28,
           'Berlin',
           'Berlin',
           'Germany' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 30,
           'Munich',
           'Bavaria',
           'Germany' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 32,
           'Paris',
           'Île-de-France',
           'France' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 34,
           'Lyon',
           'Auvergne-Rhône-Alpes',
           'France' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 36,
           'Madrid',
           'Madrid',
           'Spain' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 38,
           'Barcelona',
           'Catalonia',
           'Spain' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 40,
           'Rome',
           'Lazio',
           'Italy' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 42,
           'Milan',
           'Lombardy',
           'Italy' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 44,
           'Amsterdam',
           'North Holland',
           'Netherlands' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 46,
           'Rotterdam',
           'South Holland',
           'Netherlands' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 48,
           'Stockholm',
           'Stockholm',
           'Sweden' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 50,
           'Gothenburg',
           'Västra Götaland',
           'Sweden' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 52,
           'Zurich',
           'Zurich',
           'Switzerland' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 54,
           'Geneva',
           'Geneva',
           'Switzerland' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 56,
           'Sydney',
           'New South Wales',
           'Australia' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 58,
           'Melbourne',
           'Victoria',
           'Australia' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 60,
           'Brisbane',
           'Queensland',
           'Australia' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 62,
           'Auckland',
           'Auckland',
           'New Zealand' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 64,
           'Wellington',
           'Wellington',
           'New Zealand' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 66,
           'Singapore',
           'Singapore',
           'Singapore' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 68,
           'Tokyo',
           'Tokyo',
           'Japan' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 70,
           'Osaka',
           'Osaka',
           'Japan' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 72,
           'Seoul',
           'Seoul',
           'South Korea' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 74,
           'Hong Kong',
           'Hong Kong',
           'China' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 76,
           'Shanghai',
           'Shanghai',
           'China' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 78,
           'Beijing',
           'Beijing',
           'China' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 86,
           'Dubai',
           'Dubai',
           'UAE' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 88,
           'Abu Dhabi',
           'Abu Dhabi',
           'UAE' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 90,
           'Johannesburg',
           'Gauteng',
           'South Africa' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 92,
           'Cape Town',
           'Western Cape',
           'South Africa' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 94,
           'São Paulo',
           'São Paulo',
           'Brazil' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 96,
           'Rio de Janeiro',
           'Rio de Janeiro',
           'Brazil' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 98,
           'Mexico City',
           'Mexico City',
           'Mexico' );
insert into locations (
   location_id,
   city,
   state,
   country
) values ( 100,
           'Buenos Aires',
           'Buenos Aires',
           'Argentina' );
--
commit;
--
drop table if exists error_employees_merge;
drop table if exists emp_stage_tab1;
drop table if exists emp_stage_tab2;
--
-- create a table to capture errors during merge operation
create table error_employees_merge (
   error_code    varchar2(10),
   error_message varchar2(4000),
   empid         varchar2(6) null,
   deptid        varchar2(6) null,
   jobid         varchar2(6) null,
   location_id   varchar2(6) null
);
--
create table emp_stage_tab1 (
   empid     number(6) not null,
   salary    number(10,2) not null,
   dept_name varchar2(50) null,
   job_title varchar2(50) null,
   city      varchar2(50) null,
   state     varchar2(50) null,
   country   varchar2(50) null
);
--
create or replace type error_employees_merge_obj as object (
      empid       varchar2(6),
      deptid      varchar2(6),
      jobid       varchar2(6),
      location_id varchar2(6)
);
--
drop type if exists error_employees_merge_obj_nt;
create or replace type error_employees_merge_obj_nt as
   table of error_employees_merge_obj;
--
--
drop table if exists emp_stage_tab2;
create table emp_stage_tab2 (
   empid       number(6),
   deptid      number(6),
   jobid       number(6),
   location_id number(6),
   dept_name   varchar2(50),
   job_title   varchar2(50),
   city        varchar2(50),
   state       varchar2(50),
   country     varchar2(50)
);
--
drop type if exists emp_stage_tab2_obj_nt;
drop type if exists emp_stage_tab2_obj;
--
create or replace type emp_stage_tab2_obj as object (
      empid       number(6),
      deptid      number(6),
      jobid       number(6),
      location_id number(6),
      dept_name   varchar2(50),
      job_title   varchar2(50),
      city        varchar2(50),
      state       varchar2(50),
      country     varchar2(50)
);
--
create or replace type emp_stage_tab2_obj_nt as
   table of emp_stage_tab2_obj;
--
--
