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

vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

timestamp=$(date +"%Y-%m-%d %H:%M:%S")
memory_free=$(echo "$vmstat_mb" | awk '{print $4}'| tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}'| tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $13}'| tail -n1 | xargs)
disk_io=$(vmstat -d | awk '{print $10}'| tail -n1 | xargs)
disk_available=$(df -BM / | egrep "^/dev/sda2" | awk '{print $4}' | sed 's/.$//' | xargs)

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

insert_stmt="INSERT INTO host_usage(host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available, timestamp) VALUES('host_id', '$memory_free', '$cpu_idle',  '$cpu_kernel', '$disk_io', '$disk_available', '$timestamp')"

export PGPASSWORD=$5

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
