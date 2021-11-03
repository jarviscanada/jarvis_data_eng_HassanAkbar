#!/bin/bash
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5
#Error message for missing arguments
if [ "$#" -ne 5 ]; then
    echo "Illegal number of parameters. Please provide psql host, port number, database name, user and password"
    exit 1
fi
hostname=$(hostname -f)
vmstat_mb=$(vmstat --unit M)
memory_free=$(vmstat --unit M  |  awk '{print $4}' |tail -n1|  xargs)
cpu_idle=$(vmstat --unit M |  awk '{print $15}' | tail -n1| xargs)
cpu_kernel=$(vmstat --unit M |  awk '{print $13}' |tail -n1| xargs)
disk_io=$( vmstat -d  |  awk '{print $10 }' | tail -n1| xargs)
disk_available=$(df -BM / | egrep "^/dev/sda2" | awk '{print $4}' | sed 's/.$//' | xargs)

timestamp=$(date +"%Y-%m-%d %H:%M:%S")

insert_stmt="INSERT INTO host_usage(host_id,memory_free,cpu_idle,cpu_kernel,disk_io,disk_available,timestamp) VALUES ((SELECT id FROM host_info WHERE hostname='$hostname'),'$memory_free','$cpu_idle','$cpu_kernel','$disk_io','$disk_available','$timestamp')"

#Executing Insert statement through psql CLI tool
export PGPASSWORD=$5
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"
exit $?
