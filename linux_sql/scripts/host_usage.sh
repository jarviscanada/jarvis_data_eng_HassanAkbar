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

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')";

insert_stmt="INSERT INTO host_usage(host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available, timestamp) VALUES( "$host_id", '$memory_free', '$cpu_idle',  '$cpu_kernel', '$disk_io', '$disk_available', '$timestamp')"


export PGPASSWORD=$psql_password 

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?


#------------
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
cpu_model=$(echo "$lscpu_out" | egrep "^Model:" | awk '{print $2}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz" | awk '{print $3 }' | xargs)
l2_cache1=$(echo "$lscpu_out"  | egrep "L2 cache" | awk '{print $3 }' | xargs)
l2_cache=${l2_cache1//[^[:digit:].-]/}
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}'| xargs)
timestamp=$(date +"%Y-%m-%d %H:%M:%S")


insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem, timestamp) VALUES('$hostname', $cpu_number, '$cpu_architecture', $cpu_model, $cpu_mhz, $l2_cache, $total_mem, '$timestamp');"

export PGPASSWORD=$psql_password 

psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?
