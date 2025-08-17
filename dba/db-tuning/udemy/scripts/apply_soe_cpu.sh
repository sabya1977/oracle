#!/bin/bash

counter=1
while [ $counter -le $1 ]
do
 exit | sqlplus -L -S soe/soe @$SD/apply_cpu.sql $2 &
 ((counter++))
done

