-- SQLLDR 

drop table dept;

create table dept
    ( deptno  number(2) constraint dept_pk primary key,
      dname   varchar2(14),
      loc     varchar2(13));

-- Now run the sqlldr command
