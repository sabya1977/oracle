-- datapump import -schemas hr -directory test_dir -dumpfile hr.dmp -logfile hr.log
-- -- 
-- datapump import -schemas bi -directory test_dir -dumpfile bi.dmp -logfile bi.log
datapump import -schemas pm -directory test_dir -dumpfile pm.dmp -logfile pm.log
-- 
datapump import -schemas oe -directory test_dir -dumpfile oe.dmp -logfile oe.log
-- 
datapump import -schemas f1data -directory test_dir -dumpfile f1data.dmp -logfile f1data.log
-- 
datapump import -schemas practical -directory test_dir -dumpfile practicald.dmp -logfile practical.log
-- 
datapump import -schemas ix -directory test_dir -dumpfile ix.dmp -logfile ix.log
-- 
datapump import -schemas ix -directory test_dir -dumpfile ix.dmp -logfile ix.log
-- 
datapump import -schemas sh -directory test_dir -dumpfile sh.dmp -logfile sh.log
-- 
datapump import -schemas soe -directory test_dir -dumpfile soe.dmp -logfile soe.log