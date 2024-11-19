-- 
-- This lab will demonstrate how to use Oracle datapump utility in SQLPlus
-- Author: Sabyasachi Mitra
-- Date: 11/13/2024
-- 
-- login as sys and create a oracle directory
-- 
create or replace directory test_dir as '/tmp';
-- 
-- grant read, write access on directory to user
grant read, write on directory test_dir to oradev21;
-- 
-- exp_full_database and imp_full_database 
-- roles must be granted to the user if the user
-- intends to export/import other user's schema/tables
-- 
grant exp_full_database to oradev21
-- issue datapump export command
expdp oradev21/oracle@pdb21c schemas=practical directory=test_dir dumpfile=practical.dmp logfile=practical.log
-- 
-- Using SQLcl
-- 
datapump export -schemas practical -directory test_dir -dumpfile practicald.dmp -logfile practicald.log
-- 
datapump export -schemas f1data -directory test_dir -dumpfile f1data.dmp -logfile f1data.log
-- 
datapump export -schemas sh -directory test_dir -dumpfile sh.dmp -logfile sh.log
-- 
datapump export -schemas ot -directory test_dir -dumpfile ot.dmp -logfile ot.log
-- 
datapump export -schemas oe -directory test_dir -dumpfile oe.dmp -logfile oe.log
-- 
datapump export -schemas hr -directory test_dir -dumpfile hr.dmp -logfile hr.log
-- 
datapump export -schemas bi -directory test_dir -dumpfile bi.dmp -logfile bi.log
-- 
datapump export -schemas ix -directory test_dir -dumpfile ix.dmp -logfile ix.log
-- 
datapump export -schemas pm -directory test_dir -dumpfile pm.dmp -logfile pm.log