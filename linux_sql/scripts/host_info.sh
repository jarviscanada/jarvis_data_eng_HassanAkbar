#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

if [ $# -ne 5 ]; then
    echo 'Please provide valid host, port, db name, user and password'
    exit 1
fi

hostname=$(hostname -f)

lscpu_out=`lscpu`

cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "^Model:" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache1=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{print $3}' | xargs)
l2_cache=${l2_cache1//[^[:digit:].-]/}
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}' | xargs)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")


insert_stmt="INSERT INTO host_info(hostname, cpu_number,cpu_architecture, cpu_model, cpu_mhz, l2_cache,total_mem, timestamp) VALUES('$hostname', '$cpu_number', '$cpu_architecture', '$cpu_model',  '$cpu_mhz', '$l2_cache', '$total_mem', '$timestamp');"

export PGPASSWORD=$psql_password 

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?



