-- =========================================================
-- File: capture_err_log.sql
-- Description: This script captures error logs in Oracle SQL and PL/SQL.
-- Author: Sabyasachi Mitra
-- Creation Date: 19/07/2025
-- version: 1.0 - Initial version
-- =========================================================
--
-- capture data conversion errors from a staging table
-- to a target table using the DBMS_ERRLOG package.ALTER
-- 
-- Setup: Staging table has text
drop table if exists staging_data;
create table staging_data (
   id     varchar2(10),
   salary varchar2(20)
);
insert into staging_data values ( '1',
                                  'abc' );  -- invalid number
insert into staging_data values ( '2',
                                  '1000' ); -- valid
--
drop table if exists test_data;
create table test_data (
   id     number,
   salary number
);
-- create a table to capture error logs
drop table if exists err$_test_data;
--
begin
   dbms_errlog.create_error_log('TEST_DATA');
end;
/
--
-- error still occurs and is not captured in the error log
-- union all statement checks the data stype similarity between
-- the two select statements.
--
insert into test_data (
   id,
   salary
)
   select 1,
          'abc'
     from dual
   union all
   select 2,
          1000
     from dual
   log errors into err$_test_data ( 'CONVERSION_ERROR' ) reject limit unlimited;
--
select *
  from err$_test_data;
--
-- row level insert with error logging
--
truncate table test_data;
truncate table err$_test_data;
--
insert into test_data (
   id,
   salary
)
   select id,
          to_number(salary)
     from staging_data
   log errors into err$_test_data ( 'CONVERSION_ERROR' ) reject limit unlimited;
--     
select *
  from err$_test_data;
select *
  from test_data;
select *
  from staging_data;
--
-- test with UNION ALL create two staging tables.
--
-- clean up previous data
drop table if exists staging_data1;
drop table if exists staging_data2;
truncate table err$_test_data;
truncate table test_data;
--
create table staging_data1 (
   id     varchar2(10),
   salary varchar2(20)
);
insert into staging_data1 values ( '1',
                                   'abc' );  -- invalid number
insert into staging_data1 values ( '2',
                                   '1000' ); -- valid
--
create table staging_data2 (
   id     varchar2(10),
   salary varchar2(20)
);
insert into staging_data2 values ( '3',
                                   '8000' );  -- valid number
insert into staging_data2 values ( '4',
                                   '1500' ); -- valid
--
commit;
---- row level insert with error logging using UNION ALL
-- this will capture errors from both staging tables
-- but it still does not capture the error from the first
-- and the statement fails.
insert into test_data (
   id,
   salary
)
   select id,
          to_number(salary)
     from staging_data1
   union all
   select id,
          to_number(salary)
     from staging_data2
   log errors into err$_test_data ( 'CONVERSION_ERROR' ) reject limit unlimited;
-- 
select *
  from err$_test_data;
--
-- using FORALL to capture errors from both staging tables
-- this will capture errors from both staging tables and
-- will not fail the statement. the error will be logged
-- in the error log table.
-- 
-- step1: create an object type to hold the data
drop type if exists test_data_obj_nt;
drop type if exists test_data_obj;
create or replace type test_data_obj as object (
      id     varchar2(10),
      salary varchar2(20)
);
-- step2: create a nested table type to hold the object type
create or replace type test_data_obj_nt as
   table of test_data_obj;
--
-- step3: create a custom error log table for capturing errors
create table err_test_data (
   error_code    varchar2(10),
   error_message varchar2(4000),
   id            number(6),
   salary        varchar2(20)
);
-- step3 : use BULK COLLECT to fetch data from staging tables into the nested table

truncate table test_data;
truncate table err_test_data;
--
declare
   l_data       test_data_obj_nt;
   l_error_code err_test_data.error_code%type;
   l_error_msg  err_test_data.error_message%type;
   l_err_id     err_test_data.id%type;
   l_err_salary err_test_data.salary%type;
begin
   select test_data_obj(
      id,
      salary
   )
   bulk collect
     into l_data
     from (
      select id,
             salary
        from staging_data1
      union all
      select id,
             salary
        from staging_data2
   );

   for i in l_data.first..l_data.last loop
      dbms_output.put_line('Data to be inserted: '
                           || l_data(i).id
                           || ' '
                           || l_data(i).salary);
   end loop;
   forall i in l_data.first..l_data.last save exceptions
      insert into test_data (
         id,
         salary
      ) values ( l_data(i).id,
                 l_data(i).salary );
   dbms_output.put_line('Data inserted successfully.');
   commit;
exception
   when others then
      -- handle the exceptions and log them into the error log table
      for i in 1..sql%bulk_exceptions.count loop
         dbms_output.put_line('Error occurred during bulk insert: ');
         dbms_output.put_line('Error at index: '
                              || sql%bulk_exceptions(i).error_index
                              || ', Error Code: '
                              || sql%bulk_exceptions(i).error_code
                              || ', Error Message: '
                              || sqlerrm(-sql%bulk_exceptions(i).error_code));
         dbms_output.put_line(l_data(sql%bulk_exceptions(i).error_index).id
                              || ' '
                              || l_data(sql%bulk_exceptions(i).error_index).salary);

         l_error_code := sql%bulk_exceptions(i).error_code;
         l_error_msg := sqlerrm(-sql%bulk_exceptions(i).error_code);
         l_err_id := l_data(sql%bulk_exceptions(i).error_index).id;
         l_err_salary := l_data(sql%bulk_exceptions(i).error_index).salary;
         -- insert the error details into the error log table
         insert into err_test_data (
            error_code,
            error_message,
            id,
            salary
         ) values ( l_error_code,
                    l_error_msg,
                    l_err_id,
                    l_err_salary );
         commit;
      end loop;
end;
/
--
-- step4: use BULK COLLECT to fetch data from employees, departments, jobs, and locations
-- and insert into the staging table emp_stage_tab1 and capture errors. The example will use
-- object type nested table (defined at SQL level) to capture errors during the insert operation.
--
declare
   type t_emp_stg_tab1 is
      table of emp_stage_tab1%rowtype;
   l_emp_stg_tab1          t_emp_stg_tab1;
   l_error_employees_merge error_employees_merge_obj_nt := error_employees_merge_obj_nt();
begin
   select empid,
          salary,
          dept_name,
          job_title,
          city,
          state,
          country
   bulk collect
     into l_emp_stg_tab1
     from (
      select emp.empid,
             emp.salary,
             dept.dept_name,
             job.job_title,
             loc.city,
             loc.state,
             loc.country
        from employees emp
       inner join departments dept
      on emp.deptid = dept.deptid
       inner join jobs job
      on emp.jobid = job.jobid
       inner join locations loc
      on emp.location_id = loc.location_id
   );
   forall i in l_emp_stg_tab1.first..l_emp_stg_tab1.last save exceptions
      insert into emp_stage_tab1 (
         empid,
         salary,
         dept_name,
         job_title,
         city,
         state,
         country
      ) values ( l_emp_stg_tab1(i).empid,
                 l_emp_stg_tab1(i).salary,
                 l_emp_stg_tab1(i).dept_name,
                 l_emp_stg_tab1(i).job_title,
                 l_emp_stg_tab1(i).city,
                 l_emp_stg_tab1(i).state,
                 l_emp_stg_tab1(i).country );
   dbms_output.put_line('Data inserted successfully.');
   commit;
exception
   when others then
      for i in 1..sql%bulk_exceptions.count loop
         dbms_output.put_line('Error occurred during bulk insert: ');
         dbms_output.put_line('Error at index: '
                              || sql%bulk_exceptions(i).error_index
                              || ', Error Code: '
                              || sql%bulk_exceptions(i).error_code
                              || ', Error Message: '
                              || sqlerrm(-sql%bulk_exceptions(i).error_code));
         l_error_employees_merge.extend;
         l_error_employees_merge(l_error_employees_merge.count) := error_employees_merge_obj(
            empid       => l_emp_stg_tab1(sql%bulk_exceptions(i).error_index).empid,
            deptid      => null, -- Assuming deptid is not available in staging data
            jobid       => null, -- Assuming jobid is not available in staging data
            location_id => null  -- Assuming location_id is not available in staging data
         );
      end loop;
      forall j in l_error_employees_merge.first..l_error_employees_merge.last save exceptions
         insert into error_employees_merge (
            empid,
            deptid,
            jobid,
            location_id
         ) values ( l_error_employees_merge(j).empid,
                    l_error_employees_merge(j).deptid,
                    l_error_employees_merge(j).jobid,
                    l_error_employees_merge(j).location_id );
      commit;
end;
/
--
truncate table error_employees_merge;
truncate table emp_stage_tab2;
--
-- step5: use BULK COLLECT to fetch data from employees, departments, jobs, and locations
-- and insert into the staging table emp_stage_tab2 and capture errors. The example will use
-- record type nested table (defined at pl/sql level) to capture errors during the insert operation
-- to avoid context switch.
--
declare
   l_emp_stg_tab2          emp_stage_tab2_obj_nt := emp_stage_tab2_obj_nt();
   type ltr_error_employees_merge is
      table of error_employees_merge%rowtype;
   l_error_employees_merge ltr_error_employees_merge := ltr_error_employees_merge();
begin
   execute immediate ( 'truncate table emp_stage_tab2' );
   execute immediate ( 'truncate table error_employees_merge' );
--
-- fetch data from employees into a collection using BULK COLLECT
--
   select emp_stage_tab2_obj(
      empid,
      deptid,
      jobid,
      location_id,
      null,
      null,
      null,
      null,
      null
   )
   bulk collect
     into l_emp_stg_tab2
     from (
      select empid,
             deptid,
             jobid,
             location_id
        from employees
   );
--   
-- insert from collection into the staging table   
--
   forall i in l_emp_stg_tab2.first..l_emp_stg_tab2.last save exceptions
      insert into emp_stage_tab2 (
         empid,
         deptid,
         jobid,
         location_id,
         dept_name,
         job_title,
         city,
         state,
         country
      ) values ( l_emp_stg_tab2(i).empid,
                 l_emp_stg_tab2(i).deptid,
                 l_emp_stg_tab2(i).jobid,
                 l_emp_stg_tab2(i).location_id,
                 l_emp_stg_tab2(i).dept_name,
                 l_emp_stg_tab2(i).job_title,
                 l_emp_stg_tab2(i).city,
                 l_emp_stg_tab2(i).state,
                 l_emp_stg_tab2(i).country );
   dbms_output.put_line('Data inserted successfully.');
   commit;
--  
-- Prepare data for merge operation
--
   select emp_stage_tab2_obj(
      empid,
      deptid,
      jobid,
      location_id,
      dept_name,
      job_title,
      city,
      state,
      country
   )
   bulk collect
     into l_emp_stg_tab2
     from (
      select emp.empid,
             dept.deptid,
             job.jobid,
             loc.location_id,
             dept.dept_name,
             job.job_title,
             loc.city,
             loc.state,
             loc.country
        from employees emp
       inner join departments dept
      on emp.deptid = dept.deptid
       inner join jobs job
      on emp.jobid = job.jobid
       inner join locations loc
      on emp.location_id = loc.location_id
   );
--
   dbms_output.put_line('Data prepared for merge operation.');   
--
-- Merge stage table with departments, jobs, and locations data
--   
   dbms_output.put_line('Merge operation started.');
   forall i in l_emp_stg_tab2.first..l_emp_stg_tab2.last save exceptions
      merge into emp_stage_tab2 t
      using (
         select empid,
                deptid,
                jobid,
                location_id,
                dept_name,
                job_title,
                city,
                state,
                country
           from table ( l_emp_stg_tab2 )
      ) on ( t.empid = l_emp_stg_tab2(i).empid
         and t.deptid = l_emp_stg_tab2(i).deptid
         and t.jobid = l_emp_stg_tab2(i).jobid
         and t.location_id = l_emp_stg_tab2(i).location_id )
      when matched then update
      set t.dept_name = l_emp_stg_tab2(i).dept_name,
          t.job_title = l_emp_stg_tab2(i).job_title,
          t.city = l_emp_stg_tab2(i).city,
          t.state = l_emp_stg_tab2(i).state,
          t.country = l_emp_stg_tab2(i).country;
   dbms_output.put_line('Data merged successfully.');
   commit;
--   
exception
   when others then
      for i in 1..sql%bulk_exceptions.count loop
         -- dbms_output.put_line('Error occurred during bulk insert: ');
         -- dbms_output.put_line('Error at index: '
         --                      || sql%bulk_exceptions(i).error_index
         --                      || ', Error Code: '
         --                      || sql%bulk_exceptions(i).error_code
         --                      || ', Error Message: '
         --                      || sqlerrm(-sql%bulk_exceptions(i).error_code));
         l_error_employees_merge.extend;
         l_error_employees_merge(l_error_employees_merge.count).empid := l_emp_stg_tab2(sql%bulk_exceptions(i).error_index).empid
         ;
         l_error_employees_merge(l_error_employees_merge.count).error_code := sql%bulk_exceptions(i).error_code;
         l_error_employees_merge(l_error_employees_merge.count).error_message := sqlerrm(-sql%bulk_exceptions(i).error_code);
         l_error_employees_merge(l_error_employees_merge.count).deptid := null;
         l_error_employees_merge(l_error_employees_merge.count).jobid := null;
         l_error_employees_merge(l_error_employees_merge.count).location_id := null;
      end loop;
      forall j in l_error_employees_merge.first..l_error_employees_merge.last save exceptions
         insert into error_employees_merge (
            error_code,
            error_message,
            empid,
            deptid,
            jobid,
            location_id
         ) values ( l_error_employees_merge(j).error_code,
                    l_error_employees_merge(j).error_message,
                    l_error_employees_merge(j).empid,
                    l_error_employees_merge(j).deptid,
                    l_error_employees_merge(j).jobid,
                    l_error_employees_merge(j).location_id );
      commit;
end;
/