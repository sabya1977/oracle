create or replace directory test_dir as '/tmp';
-- 
grant read, write on directory test_dir to oradev21;
-- 
grant read, write on directory test_dir to oradba21;