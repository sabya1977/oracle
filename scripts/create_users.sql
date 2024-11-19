-- 
drop user bi;
drop user hr;
drop user oe;
drop user pm;
drop user f1data;
drop user ix;
drop user ot;
drop user sh;
drop user practical;

create user bi identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user bi quota unlimited on users;
-- 
create user f1data identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user f1data quota unlimited on users;
-- 
create user hr identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user hr quota unlimited on users;
-- 
create user ix identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user ix quota unlimited on users;
-- 
create user ot identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user ot quota unlimited on users;
-- 
create user pm identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user pm quota unlimited on users;
-- 
create user sh identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user sh quota unlimited on users;
-- 
create user practical identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user practical quota unlimited on users;
-- 
create user oe identified by oracle
default tablespace users
temporary tablespace temp
profile default
account unlock;
-- 
alter user oe quota unlimited on users;