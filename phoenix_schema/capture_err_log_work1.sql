declare
   l_emp_stg_tab2          emp_stage_tab2_obj_nt := emp_stage_tab2_obj_nt();
   type ltr_error_employees_merge is
      table of error_employees_merge%rowtype;
   l_error_employees_merge ltr_error_employees_merge;
begin
   execute immediate ( 'truncate table emp_stage_tab2' );
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
   dbms_output.put_line('Data updated successfully.');
   commit;
--   
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
         l_error_employees_merge(l_error_employees_merge.count).empid := l_emp_stg_tab2(sql%bulk_exceptions(i).error_index).empid
         ;
         l_error_employees_merge(l_error_employees_merge.count).deptid := null;
         l_error_employees_merge(l_error_employees_merge.count).jobid := null;
         l_error_employees_merge(l_error_employees_merge.count).location_id := null;
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
      null;
end;
/
commit;