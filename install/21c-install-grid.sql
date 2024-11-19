-- Script Name: 21c-install-grid-db.sql
-- Author: Sabyasachi Mitra
-- Date: 11/16/2024
-- 
-- This installation script is for installation of Oracle 21c Grid using
-- Oracle ASM storage on Oracle Linux 7.8. Oracle 21c Database installation
-- is covered in another script: 21c-install-grid-db.sql
-- 
yum install -y oracle-database-preinstall-21c
yum install -y bc    
yum install -y binutils
yum install -y compat-libcap1
yum install -y compat-libstdc++-33
yum install -y dtrace-utils
yum install -y elfutils-libelf
yum install -y elfutils-libelf-devel
yum install -y fontconfig-devel
yum install -y glibc
yum install -y glibc-devel
yum install -y ksh
yum install -y libaio
yum install -y libaio-devel
yum install -y libdtrace-ctf-devel
yum install -y libXrender
yum install -y libXrender-devel
yum install -y libX11
yum install -y libXau
yum install -y libXi
yum install -y libXtst
yum install -y libgcc
yum install -y librdmacm-devel
yum install -y libstdc++
yum install -y libstdc++-devel
yum install -y libxcb
yum install -y make
yum install -y net-tools # Clusterware
yum install -y nfs-utils # ACFS
yum install -y python # ACFS
yum install -y python-configshell # ACFS
yum install -y python-rtslib # ACFS
yum install -y python-six # ACFS
yum install -y targetcli # ACFS
yum install -y smartmontools
yum install -y sysstat
yum install -y unixODBC
yum install -y oracleasm
yum install -y oracleasm-support
-- 
yum update -y

groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper 
groupadd -g 54324 backupdba
groupadd -g 54325 dgdba
groupadd -g 54326 kmdba
groupadd -g 54327 asmdba
groupadd -g 54328 asmoper
groupadd -g 54329 asmadmin
groupadd -g 54330 racdba

useradd -u 54322 -g oinstall -G dba,asmdba,racdba,asmoper,asmadmin grid

passwd grid

usermod -u 500 -g oinstall -G dba,oper,asmdba,asmoper,asmadmin,kmdba,dgdba,backupdba,racdba oracle
-- 
--  setup SELINUX
-- 
vim /etc/selinux/config
-- modify
SELINUX=permissive
-- issue the following command to set SELINUX if you don't want to restart
setenforce Permissive
-- stop and disable fireall
systemctl stop firewalld
systemctl disable firewalld
-- 
-- Configure ASM
oracleasm configure -i
-- enter grid, dba, y, y
oracleasm init
-- 
-- create partitions
-- 
fdisk /dev/sdb
/dev/sdb1 - 15GB
/dev/sdb2 - 14GB
/dev/sdb3 - 30GB 
-- 
-- create ASM disks
oracleasm createdisk CRS1 /dev/sdb1
oracleasm createdisk FRA1 /dev/sdb2
oracleasm createdisk DATA1 /dev/sdb3
-- 
-- check if disks are create
-- 
cd /dev/oracleasm/disks
ls -lrt
-- 
/*
brw-rw----. 1 grid dba 8, 17 Nov 17 14:15 CRS1
brw-rw----. 1 grid dba 8, 18 Nov 17 14:15 FRA1
brw-rw----. 1 grid dba 8, 19 Nov 17 14:15 DATA1
*/
-- 
-- create installation directories
mkdir -p /u01/app/oracle
mkdir -p /u01/app/oracle/product/21.3/db_home
mkdir -p /u01/app/oraInventory
chown -R oracle:oinstall /u01
mkdir -p /u01/app/grid
mkdir -p /u01/app/grid/21.3/grid_home
chown -R grid:oinstall /u01/app/grid
chown -R oracle:oinstall /u01/app/oraInventory
chown -R grid:oinstall /u01/app/oraInventory
chmod -R 775 /u01
-- 
-- login as grid user to setup its bash profile
-- take backup of existing bash profile
cp .bash_profile .bash_profile.orig
-- 
-- modify the .bash_profile
-- 
# Set envirornment variables for oracle 21.3 Grid
#
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
#
# Set envirornment variables for oracle 21.3 Grid
#
export ORACLE_SID=+ASM
export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=$ORACLE_BASE/21.3/grid_home
export ORACLE_TERM=xterm
export TNS_ADMIN=$ORACLE_HOME/network/admin
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH=$PATH:/usr/bin:/bin:/usr/local/bin
-- 
-- login as oracle and modify bash profile for oracle user
-- 
export ORACLE_SID=cdb01
export ORACLE_HOSTNAME=orcl21c
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/21.3/db_home
export ORACLE_TERM=xterm
export TNS_ADMIN=$ORACLE_HOME/network/admin
export PATH=$PATH:$HOME/bin:$ORACLE_HOME/bin
export PATH=$PATH:/usr/bin:/bin:/usr/local/bin
-- 
-- after first logging as SYS
alter pluggable database pdb21c open read write;
-- 
alter pluggable database pdb21c save state;
-- 
-- run developer.sql
-- 
-- 
-- create users to import data
-- 
-- 

-- 


